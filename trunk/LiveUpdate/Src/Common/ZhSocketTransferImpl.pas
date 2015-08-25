unit ZhSocketTransferImpl;

interface

uses
  Windows, Classes, Forms, ScktComp, SysUtils, WinSock, ZhFileTreeImpl, Contnrs,
  SyncObjs;

const
  { 数据包长度 }
  PACKET_SIZE   = 1024;

  { 定义消息 }
  FILE_LIST     = $00000001;
  FILE_INFO     = $00000002;
  FILE_DOWNLOAD = $00000003;

  { 网络超时 }
  G_TIMEOUT     = 60000;

  { 代理信息 }
  SOCKS_VER5 = $05;
  CMD_CONNECT = $01;
  RSV_DEFAULT = $00;
  ATYP_DN = $03;
  REP_SUCCESS = $00;
  ATYP_IPV4 = $01;

type
  TAuthenType = (atNone, atUserPass);
  TDownloadStatus = (dsBegin, dsFileBegin, dsFileData, dsFileEnd, dsEnd, dsError);
  TDownloadCallback = procedure(Sender: TObject; DownloadStatus: TDownloadStatus;
    const WorkCount: Integer) of object;

  //下载进度
  TDownloadProgress = procedure(DownloadStatus: TDownloadStatus; FileName: string;
    WorkCount: Integer);

  { 代理服务器属性 }
  TProxyInfo = record
    Enabled: Boolean;
    IP: string;
    Port: Integer;
    Username: string;
    Password: string;
  end;

  PSocksInfo = ^TSocksInfo;
  TSocksInfo = record
    ProxyIP: PChar;     //代理服务器IP
    ProxyPort: Integer; //代理服务器端口
    ProxyUser: PChar;   //代理服务器用户名
    ProxyPass: PChar;   //代理服务器密码
  end;

  { 项目 }
  TProjectItem = class(TCollectionItem)
  private
    FDescription: string;
    FProjectName: string;
    FResTree: TResTree;
    FRootDir: string;
    function GetResTreeFileName: string;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure RemoveResTree;
    procedure SaveResTree;
    procedure LoadResTree;
    property ProjectName: string read FProjectName write FProjectName;
    property Description: string read FDescription write FDescription;
    property RootDir: string read FRootDir write FRootDir;
    property ResTree: TResTree read FResTree;
  end;

  { 项目管理器 }
  TProjectCollection = class(TCollection)
  private
    FFileName: string;
    FOwner: TPersistent;
    procedure SaveToFile;
    procedure LoadFromFile;
    function GetItem(Index: Integer): TProjectItem;
  public
    constructor Create(AOwner: TPersistent; FileName: string);
    destructor Destroy; override;
    function Add(ProjectName, Descripton, RootDir: string): TProjectItem;
    procedure Delete(Index: Integer);
    procedure Clear;
    function IndexOf(const ProjectName: string): Integer;
    property Items[Index: Integer]: TProjectItem read GetItem; default;
  end;

  TMyServerClientThread = class(TServerClientThread)
  private
    procedure SendFileList(ProjectName: string);
    procedure SendFile(ProjectName, FileName: string);
  protected
    procedure ClientExecute; override;
  public
    constructor Create(CreateSuspended: Boolean; ASocket: TServerClientWinSocket);
    destructor Destroy; override;
  end;

  ThxUpdateServer = class(TObject)
  private
    FServerSocket: TServerSocket;
    procedure FServerSocketGetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
      var SocketThread: TServerClientThread);
    procedure FServerSocketThreadStart(Sender: TObject; Thread: TServerClientThread);
    procedure FServerSocketThreadEnd(Sender: TObject; Thread: TServerClientThread);
    procedure FServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
    function GetActive: Boolean;
  public
    constructor Create(APort: Integer);
    destructor Destroy; override;

    procedure StartService;
    procedure StopServerice;
    property Active: Boolean read GetActive;
  end;

  { 下载文件列表，共用一个连接，下载完毕后连接不断开}
  TDownloadFileListThread = class(TThread)
  private
    FClientSocket: TClientSocket;
    FResTree: TResTree;
    FProjectName: string;
    FDownloadCallback: TDownloadCallback;
    FDownloadStatus: TDownloadStatus;
    FWorkCount: Integer;
    procedure DoDownloadCallback;
    procedure SyncDownloadCallback(DownloadStatus: TDownloadStatus; WorkCount: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; ClientSocket: TClientSocket;
      ProjectName: string; ResTree: TResTree; DownloadCallback: TDownloadCallback);
    property ResTree: TResTree read FResTree;
  end;

  ThxUpdateClient = class;

  { 下载多个文件，共用一个连接，下载完毕后连接不断开 }
  TDownloadFilesThread = class(TThread)
  private
    FClientSocket: TClientSocket;
    FFileNames: TStrings;
    FDownloadCallback: TDownloadCallback;
    FUpdateClient: ThxUpdateClient;
    FProjectName: string;
    FDownloadFileName: string;
    FDownloadStatus: TDownloadStatus;
    FWorkCount: Integer;
    procedure DoDownloadCallback;
    procedure SyncDownloadCallback(DownloadStatus: TDownloadStatus; WorkCount: Integer);
    procedure DownloadAFile(AFileName: string);
  protected
    procedure Execute; override;
  public
    constructor Create(UpdateClient: ThxUpdateClient; CreateSuspended: Boolean; ClientSocket: TClientSocket;
      ProjectName: string; FileNames: TStrings; DownloadCallback: TDownloadCallback);
    destructor Destroy; override;
    property DownloadFileName: string read FDownloadFileName;
  end;

  ThxUpdateClient = class(TObject)
  private
    FClientSocket: TClientSocket;
    FResTree: TResTree;
    FProjectName: string;
    FProxyInfo: TProxyInfo;
    function GetActive: Boolean;
    function Handclasp(Socket: TSocket; AuthenType: TAuthenType): Boolean;
    function ConnectByProxy(Socket: TSocket; RemoteIP: string; RemotePort: Integer): Boolean;
  public
    constructor Create(ProjectName: string);
    destructor Destroy; override;

    procedure Open(ServerIP: string; Port: Integer);
    procedure Close;
    procedure DownloadFileList(DownloadCallback: TDownloadCallback);
    procedure DownloadFiles(FileNames: TStrings; DownloadCallback: TDownloadCallback);

    property Active: Boolean read GetActive;
    property ProxyInfo: TProxyInfo read FProxyInfo write FProxyInfo;
  end;

  function GetProjectCollection: TProjectCollection;

implementation

uses
  ZhPubUtils, TypInfo;

var
  G_ProjectCollection: TProjectCollection = nil;

function GetProjectCollection: TProjectCollection;
begin
  if G_ProjectCollection = nil then
    G_ProjectCollection:= TProjectCollection.Create(nil, ExtractFilePath(ParamStr(0)) + 'myprjs.dat');

  Result:= G_ProjectCollection;
end;

{ TMyServerClientThread }

procedure TMyServerClientThread.ClientExecute;
var
  Stream: TWinSocketStream;
  CMD: Cardinal;
  ProjectName, FileName: string;
begin
  while (not Terminated) and ClientSocket.Connected do
  begin
    try
      Stream := TWinSocketStream.Create(ClientSocket, G_TIMEOUT);
      try
        if Stream.WaitForData(G_TIMEOUT) then
        begin
          if ClientSocket.ReceiveLength = 0 then
          begin
            ClientSocket.Close;
            Break;
          end;
          try
            CMD:= StreamReadInteger(Stream);
            ProjectName:= StreamReadString(Stream);

            if GetProjectCollection.IndexOf(ProjectName) = -1 then
              ClientSocket.Close;

            case CMD of
              // 下载文件列表
              FILE_LIST:
              begin
                SendFileList(ProjectName);
              end;
              // 下载文件
              FILE_DOWNLOAD:
              begin
                FileName:= StreamReadString(Stream);
                SendFile(ProjectName, FileName);
              end;
            end;
          except
            ClientSocket.Close;
          end;
        end
        else
          ClientSocket.Close;
      finally
        Stream.Free;
      end;
    except
      HandleException;
    end;
  end;
  Terminate;
end;

constructor TMyServerClientThread.Create(CreateSuspended: Boolean; ASocket: TServerClientWinSocket);
begin
  inherited Create(CreateSuspended, ASocket);
  FreeOnTerminate:= True;
end;

destructor TMyServerClientThread.Destroy;
begin
  inherited Destroy;
end;

procedure TMyServerClientThread.SendFile(ProjectName, FileName: string);
var
  fs: TFileStream;
  wss: TWinSocketStream;
  Buf: array[0..PACKET_SIZE - 1] of char;
  ReadCount: Integer;
  Index: Integer;
  RootDir: string;
begin
  wss:= TWinSocketStream.Create(ClientSocket, G_TIMEOUT);
  try
    Index:= GetProjectCollection.IndexOf(ProjectName);
    RootDir:= FormatDirectoryName(GetProjectCollection.Items[Index].RootDir);
    fs:= TFileStream.Create(RootDir + FileName, fmOpenRead);
    try
      StreamWriteInteger(wss, FILE_DOWNLOAD);
      StreamWriteString(wss, FileName);
      StreamWriteInteger(wss, fs.Size);
      while fs.Position < fs.Size do
      begin
        ReadCount:= fs.Read(Buf, PACKET_SIZE);
        wss.WriteBuffer(Buf, ReadCount);
      end;
    finally
      fs.Free;
    end;
  finally
    wss.Free;
  end;
end;

procedure TMyServerClientThread.SendFileList(ProjectName: string);
var
  Index: Integer;
  wss: TWinSocketStream;
begin
  Index:= GetProjectCollection.IndexOf(ProjectName);
  wss:= TWinSocketStream.Create(ClientSocket, G_TIMEOUT);
  try
    StreamWriteInteger(wss, FILE_LIST);
    // 需要时才加载，可以节约资源
    with GetProjectCollection.Items[Index] do
    begin
      LoadResTree;
      ResTree.SaveToStream(wss);
      //ResTree.Clear;
    end;
  finally
    wss.Free;
  end;
end;

{ ThxUpdateServer }

constructor ThxUpdateServer.Create(APort: Integer);
begin
  FServerSocket:= TServerSocket.Create(nil);
  FServerSocket.ServerType:= stThreadBlocking;
  FServerSocket.ThreadCacheSize:= 0;
  FServerSocket.Port:= APort;
  FServerSocket.OnGetThread:= FServerSocketGetThread;
  FServerSocket.OnThreadStart:= FServerSocketThreadStart;
  FServerSocket.OnThreadEnd:= FServerSocketThreadEnd;
  FServerSocket.OnListen:= FServerSocketListen;
end;

destructor ThxUpdateServer.Destroy;
begin
  FServerSocket.Free;
  inherited Destroy;
end;

procedure ThxUpdateServer.FServerSocketGetThread(Sender: TObject;
  ClientSocket: TServerClientWinSocket; var SocketThread: TServerClientThread);
begin
  Assert(ClientSocket.Connected);
  SocketThread:= TMyServerClientThread.Create(False, ClientSocket);
end;

procedure ThxUpdateServer.FServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
begin

end;

procedure ThxUpdateServer.FServerSocketThreadEnd(Sender: TObject; Thread: TServerClientThread);
begin

end;

procedure ThxUpdateServer.FServerSocketThreadStart(Sender: TObject; Thread: TServerClientThread);
begin

end;

function ThxUpdateServer.GetActive: Boolean;
begin
  Result:= FServerSocket.Active;
end;

procedure ThxUpdateServer.StartService;
begin
  FServerSocket.Open;
end;

procedure ThxUpdateServer.StopServerice;
begin
  FServerSocket.Close;
end;

{ TDownloadFileListThread }

constructor TDownloadFileListThread.Create(CreateSuspended: Boolean; ClientSocket: TClientSocket;
  ProjectName: string; ResTree: TResTree; DownloadCallback: TDownloadCallback);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:= True;
  FClientSocket:= ClientSocket;
  FProjectName:= ProjectName;
  FResTree:= ResTree;
  FDownloadCallback:= DownloadCallback;
end;

procedure TDownloadFileListThread.DoDownloadCallback;
begin
  if Assigned(FDownloadCallback) then
    FDownloadCallback(Self, FDownloadStatus, FWorkCount);
end;

procedure TDownloadFileListThread.Execute;
var
  wss: TWinSocketStream;
  CMD: Cardinal;
begin
  // 下载文件列表
  if (not Terminated) and (FClientSocket.Socket.Connected) then
  begin
    wss:= TWinSocketStream.Create(FClientSocket.Socket, G_TIMEOUT);
    try
      // 请求下载文件列表
      StreamWriteInteger(wss, FILE_LIST);
      StreamWriteString(wss, FProjectName);

      SyncDownloadCallback(dsBegin, 0);

      // 等待下载文件列表
      if wss.WaitForData(G_TIMEOUT) then
      begin
        CMD:= StreamReadInteger(wss);
        Assert(CMD = FILE_LIST);
        FResTree.LoadFromStream(wss);

        SyncDownloadCallback(dsEnd, wss.Size);

        Terminate;
      end
      else
        FClientSocket.Close;
    finally
      wss.Free;
    end;
  end;
end;

{ TDownloadFiles }

constructor TDownloadFilesThread.Create(UpdateClient: ThxUpdateClient;  CreateSuspended: Boolean; ClientSocket: TClientSocket;
  ProjectName: string; FileNames: TStrings; DownloadCallback: TDownloadCallback);
begin
  inherited Create(CreateSuspended);
  FUpdateClient:= UpdateClient;
  FreeOnTerminate:= True;
  FClientSocket:= ClientSocket;
  FProjectName:= ProjectName;
  FDownloadCallback:= DownloadCallback;
  FFileNames:= TStringList.Create;
  FFileNames.Assign(FileNames);
  FDownloadFileName:= '';
  Assert(FClientSocket.Socket.Connected = True);
end;

destructor TDownloadFilesThread.Destroy;
begin
  FFileNames.Free;
  inherited Destroy;
end;

procedure TDownloadFilesThread.DownloadAFile(AFileName: string);
var
  CMD: Cardinal;
  wss: TWinSocketStream;
  fs: TFileStream;
  FileName: string;
  FileSize: Integer;
  Buf: array[0..PACKET_SIZE - 1] of char;
  WriteCount: Integer;
  szDir: string;
begin
  Assert(FClientSocket.Socket.Connected = True);
  wss:= TWinSocketStream.Create(FClientSocket.Socket, G_TIMEOUT);
  try
    // 请求下载文件列表
    StreamWriteInteger(wss, FILE_DOWNLOAD);
    StreamWriteString(wss, FProjectName);
    StreamWriteString(wss, AFileName);
    // 等待下载文件列表
    if wss.WaitForData(G_TIMEOUT) then
    begin
      CMD:= StreamReadInteger(wss);
      Assert(CMD = FILE_DOWNLOAD);
      FileName:= StreamReadString(wss);
      FileSize:= StreamReadInteger(wss);

      FDownloadFileName:= FileName;

      //开始下载
      SyncDownloadCallback(dsFileBegin, FileSize);

      //下载指定文件
      FileName:= ExtractFilePath(Application.ExeName) + FDownloadFileName;
      szDir:= ExtractFilePath(FileName);
      if not ForceDirectories(szDir) then
        raise Exception.Create('创建目录失败！');
      fs:= TFileStream.Create(FileName, fmCreate);
      try
        while fs.Size < FileSize do
        begin
          FillChar(Buf, PACKET_SIZE, #0);
          WriteCount:= wss.Read(Buf, PACKET_SIZE);
          fs.WriteBuffer(Buf, WriteCount);

          //下载中....
          SyncDownloadCallback(dsFileData, WriteCount);
        end;

        //下载完毕
        SyncDownloadCallback(dsFileEnd, fs.Size);
      finally
        fs.Free;
      end;
    end
    else
      FClientSocket.Close;
  finally
    wss.Free;
  end;
end;

procedure TDownloadFilesThread.DoDownloadCallback;
begin
  if Assigned(FDownloadCallback) then
    FDownloadCallback(Self, FDownloadStatus, FWorkCount);
end;

procedure TDownloadFilesThread.Execute;
var
  I: Integer;
begin
  Assert(FClientSocket.Socket.Connected = True);
  // 下载指定文件
  for I:= 0 to FFileNames.Count - 1 do
  begin
    if (not Terminated) and (FClientSocket.Socket.Connected) then
      DownloadAFile(FFileNames[I])
    else
      Break;
  end;
  FDownloadFileName:= '';

  SyncDownloadCallback(dsEnd, 0);

  Terminate;
end;

procedure TDownloadFileListThread.SyncDownloadCallback(
  DownloadStatus: TDownloadStatus; WorkCount: Integer);
begin
  FDownloadStatus:= DownloadStatus;
  FWorkCount:= WorkCount;
  if Application.Handle = 0 then
    DoDownloadCallback
  else
    Synchronize(Self, DoDownloadCallback);
end;

{ ThxUpdateClient }

procedure ThxUpdateClient.Close;
begin
  FClientSocket.Close;
end;

function ThxUpdateClient.ConnectByProxy(Socket: TSocket; RemoteIP: string;
  RemotePort: Integer): Boolean;
var
  Buf: array[0..1023] of Byte;
  Ret: Integer;
  saRemote: TSockAddr;
begin
  Result:= False;

  FillChar(saRemote, SizeOf(saRemote), #0);
  saRemote.sin_family:= AF_INET;
  saRemote.sin_addr.S_addr:= inet_addr(PChar(RemoteIP));
  saRemote.sin_port:= htons(RemotePort);

  Buf[0]:= SOCKS_VER5;    // 代理协议版本号(Socks5)
  Buf[1]:= CMD_CONNECT;   // Reply
  Buf[2]:= RSV_DEFAULT;   // 保留字段
  Buf[3]:= ATYP_IPV4;     // 地址类型(IPV4)
  CopyMemory(@Buf[4], @saRemote.sin_addr, 4); // 目标地址
  CopyMemory(@Buf[8], @saRemote.sin_port, 2); // 目标端口号
  Ret:= send(Socket, Buf, 10, 0);
  if Ret = -1 then Exit;
  Ret:= recv(Socket, Buf, 1023, 0);
  if Ret = -1 then Exit;
  if Buf[1] <> REP_SUCCESS then Exit;
  Result:= True;
end;

constructor ThxUpdateClient.Create(ProjectName: string);
var
  wsData: TWSAData;
begin
  FProjectName:= ProjectName;
  FResTree:= TResTree.Create;
  Assert(WSAStartup(MAKEWORD(1, 1), wsData) = 0);
  FClientSocket:= TClientSocket.Create(nil);
  FClientSocket.ClientType:= ctBlocking;
end;

destructor ThxUpdateClient.Destroy;
begin
  if FClientSocket.Socket.Connected then
    FClientSocket.Close;
  FreeAndNil(FClientSocket);
  FreeAndNil(FResTree);
  WSACleanup;
  inherited Destroy;
end;

procedure ThxUpdateClient.DownloadFileList(DownloadCallback: TDownloadCallback);
begin
  FResTree.Clear;
  TDownloadFileListThread.Create(False, FClientSocket, FProjectName, FResTree, DownloadCallback);
end;

procedure ThxUpdateClient.DownloadFiles(FileNames: TStrings; DownloadCallback: TDownloadCallback);
begin
  TDownloadFilesThread.Create(Self, False, FClientSocket, FProjectName, FileNames, DownloadCallback);
end;

function ThxUpdateClient.GetActive: Boolean;
begin
  Result:= FClientSocket.Socket.Connected;
end;

function ThxUpdateClient.Handclasp(Socket: TSocket; AuthenType: TAuthenType): Boolean;
var
  Buf: array[0..254] of Byte;
  I, Ret: Integer;
  Username, Password: string;
begin
  Result:= False;
  case AuthenType of
    // 无需验证
    atNone:
    begin
      Buf[0]:= SOCKS_VER5;
      Buf[1]:= $01;
      Buf[2]:= $00;
      Ret:= send(Socket, Buf, 3, 0);
      if Ret = -1 then Exit;
      Ret:= recv(Socket, Buf, 255, 0);
      if Ret < 2 then Exit;
      if Buf[1] <> $00 then Exit;
      Result:= True;
    end;
    // 用户名密码验证
    atUserPass:
    begin
      Buf[0]:= SOCKS_VER5;
      Buf[1]:= $02;
      Buf[2]:= $00;
      Buf[3]:= $02;
      Ret:= send(Socket, Buf, 4, 0);
      if Ret = -1 then Exit;
      FillChar(Buf, 255, #0);
      Ret:= recv(Socket, Buf, 255, 0);
      if Ret < 2 then Exit;
      if Buf[1] <> $02 then Exit;
      Username:= FProxyInfo.Username;
      Password:= FProxyInfo.Password;
      FillChar(Buf, 255, #0);
      Buf[0]:= $01;
      Buf[1]:= Length(Username);
      for I:= 0 to Buf[1] - 1 do
        Buf[2 + I]:= Ord(Username[I + 1]);
      Buf[2 + Length(Username)]:= Length(Password);
      for I:= 0 to Buf[2 + Length(Username)] - 1 do
        Buf[3 + Length(Username) + I]:= Ord(Password[I + 1]);
      Ret:= send(Socket, Buf, Length(Username) + Length(Password) + 3, 0);
      if Ret = -1 then Exit;
      Ret:= recv(Socket, Buf, 255, 0);
      if Ret = -1 then Exit;
      if Buf[1] <> $00 then Exit;
      Result:= True;
    end;
  end;
end;

procedure ThxUpdateClient.Open(ServerIP: string; Port: Integer);
begin
  Assert(FClientSocket.Socket.Connected = False);
  try
    if not FProxyInfo.Enabled then
    begin
      FClientSocket.Host:= ServerIP;
      FClientSocket.Port:= Port;
      FClientSocket.Open;
    end
    else begin  { 使用代理服务器 }
      // 连接到Socks服务器
      FClientSocket.Host:= FProxyInfo.IP;
      FClientSocket.Port:= FProxyInfo.Port;
      FClientSocket.Open;
      if Trim(FProxyInfo.Username) <> '' then
        Handclasp(FClientSocket.Socket.SocketHandle, atUserPass)
      else
        Handclasp(FClientSocket.Socket.SocketHandle, atNone);
      // 连接到目标地址
      ConnectByProxy(FClientSocket.Socket.SocketHandle, ServerIP, Port);
    end;
  except
    raise Exception.Create('无法连接到LiveUpdate服务器，请检查网络配置！');
  end;
end;

{ TProjectMgr }

function TProjectCollection.Add(ProjectName, Descripton, RootDir: string): TProjectItem;
begin
  Result:= TProjectItem(inherited Add);
  Result.ProjectName:= ProjectName;
  Result.Description:= Descripton;
  Result.RootDir:= RootDir;
end;

procedure TProjectCollection.Clear;
begin
  inherited Clear;
end;

constructor TProjectCollection.Create(AOwner: TPersistent; FileName: string);
begin
  inherited Create(TProjectItem);
  FOwner:= AOwner;

  FFileName:= FileName;
  LoadFromFile;
end;

procedure TProjectCollection.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

destructor TProjectCollection.Destroy;
begin
  SaveToFile;
  Clear;
  inherited Destroy;
end;

function TProjectCollection.GetItem(Index: Integer): TProjectItem;
begin
  Result:= TProjectItem(inherited GetItem(Index));
end;


function TProjectCollection.IndexOf(const ProjectName: string): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 0 to Count - 1 do
    if SameText(TProjectItem(Items[I]).ProjectName, ProjectName) then
    begin
      Result:= I;
      Break;
    end;
end;

procedure TProjectCollection.LoadFromFile;
var
  I, C: Integer;
  Stream: TStream;
  szProjectName, szRootDir, szDescription: string;
begin
  Clear;
  if not FileExists(FFileName) then Exit;
  Stream:= TFileStream.Create(FFileName, fmOpenRead);
  try
    C:= StreamReadInteger(Stream);
    for I:= 0 to C - 1 do
    begin
      szProjectName:= StreamReadString(Stream);
      szRootDir:= StreamReadString(Stream);
      szDescription:= StreamReadString(Stream);;
      Add(szProjectName, szDescription, szRootDir);
    end;
  finally
    Stream.Free;
  end;
end;


procedure TProjectCollection.SaveToFile;
var
  I: Integer;
  Stream: TFileStream;
begin
  Stream:= TFileStream.Create(FFileName, fmCreate);
  try
    StreamWriteInteger(Stream, Count);
    for I:= 0 to Count - 1 do
      with Items[I] do
      begin
        StreamWriteString(Stream, ProjectName);
        StreamWriteString(Stream, RootDir);
        StreamWriteString(Stream, Description);
      end;
  finally
    Stream.Free;
  end;
end;

{ TProjectItem }

constructor TProjectItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FResTree:= TResTree.Create;
end;

destructor TProjectItem.Destroy;
begin
  FResTree.Free;
  inherited Destroy;
end;

function TProjectItem.GetResTreeFileName: string;
begin
  Result:= ExtractFilePath(ParamStr(0)) + 'Projects\' + FProjectName + '.vf';
end;

procedure TProjectItem.LoadResTree;
begin
  if FileExists(GetResTreeFileName) then
    FResTree.LoadFromFile(GetResTreeFileName);
end;

procedure TProjectItem.RemoveResTree;
var
  ResFileName: string;
begin
  ResFileName:= GetResTreeFileName;
  if FileExists(ResFileName) then
    DeleteFile(ResFileName);
end;

procedure TProjectItem.SaveResTree;
var
  ResFilePath, ResFileName: string;
begin
  ResFileName:=  GetResTreeFileName;
  ResFilePath:= ExtractFilePath(ResFileName);
  if not DirectoryExists(ResFilePath) then
    ForceDirectories(ResFilePath);
  FResTree.SaveToFile(ResFileName);
end;

procedure TDownloadFilesThread.SyncDownloadCallback(
  DownloadStatus: TDownloadStatus; WorkCount: Integer);
begin
  FDownloadStatus:= DownloadStatus;
  FWorkCount:= WorkCount;
  {
  if Application.Handle = 0 then
    DoDownloadCallback
  else
    Synchronize(Self, DoDownloadCallback);
  }
  DoDownloadCallback;
end;

end.
