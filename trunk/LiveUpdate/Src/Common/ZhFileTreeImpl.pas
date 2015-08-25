unit ZhFileTreeImpl;

interface

uses
  Windows, Classes, SysUtils, ComCtrls, ComStrs, ZhTreeImpl;

const
  { ������Ϣ }

  FILE_LIST     = $00000001;
  FILE_INFO     = $00000002;
  FILE_DOWNLOAD = $00000003;

  { ���糬ʱ }
  G_TIMEOUT     = 10000;

type
  { ��Դ�ļ����� }
  TResType = (rtFile, rtDirectory, rtExecute);

  { �汾���� }
  TVersion = string;

  { ��Դ�ļ���Ϣ }
  PResInfo = ^TResInfo;
  TResInfo = packed record
    FileName: string;   // �ļ���(������·��)
    Description: string;// �ļ�����
    FileSize: Integer;  // �ļ���С��
    FileAttr: Integer;  // �ļ�����
    ModifyTime: TDateTime;// �޸�ʱ��
    Version: TVersion;    // �汾��(IP��ַ��ʽ)
    ResType: TResType;  // ��Դ����
    DownloadURL: string;// �����ļ������·��
  end;

  TErrorObject = class(Exception);
  TResTree = class;

  { �ļ���� }
  TResNode = class(TNode)
  protected
    procedure SaveMe(Stream: TStream); override;
    procedure LoadMe(Stream: TStream); override;
  end;

  { �ļ��� }
  TResTree = class(TTree)
  private
    FRootDir: string; // ��Ŀ¼��ʵ��·��
    procedure SearchFiles(APath: string; Mask: string; var Node: TNode);
    function ExtractRelativePath(FileName: string): string;
  protected
    function CreateNode: TNode; override;
  public
    procedure Clear; override;
    procedure LoadFiles(Directory: string);
    function AddDirectory(ParentNode: TResNode; Directory: string): TResNode;
    function AddFile(ParentNode: TResNode; AFileName: string): TResNode;

    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
  end;

  { �ͻ��˱���İ汾��Ϣ }
  PVersionInfo = ^TVersionInfo;
  TVersionInfo = record
    FileName: string; // �ļ���(�������·��)
    Version: TVersion;  // �汾��
  end;


  PVerInfo = ^TVerInfo;
  TVerInfo = record
    FileName: PChar;
    Version: PChar;
  end;

  { ��ʷ�汾�б� }
  TVersionList = class(TObject)
  private
    FVersions: TList;
    FFileName: string;
    function GetCount: Integer;
    function GetItems(Index: Integer): PVersionInfo;
    procedure Add(AFileName: string; AVersion: string);
    function GetVersions(FileName: string): TVersion;
    procedure SetVersions(FileName: string; const Value: TVersion);
  public
    constructor Create(FileName: string);
    destructor Destroy; override;

    procedure Clear;
    function IndexOf(FileName: string): Integer;
    procedure Update(FileName: string; Version: TVersion);
    procedure SaveToFile;
    procedure LoadFromFile;
    property Items[Index: Integer]: PVersionInfo read GetItems; default;
    property Versions[FileName: string]: TVersion read GetVersions write SetVersions;
    property Count: Integer read GetCount;
  end;

  // �汾�ȽϺ���
  function SameVersion(V1, V2: TVersion): Boolean;

implementation

uses
  ZhPubUtils, ZhVersionImpl;

function SameVersion(V1, V2: TVersion): Boolean;
begin
  Result:= SameText(V1, V2);
end;

procedure StreamWriteResInfo(Stream: TStream; ResInfo: TResInfo);
begin
  with ResInfo do
  begin
    StreamWriteString(Stream, FileName);   // �������·��(��MyDir\Myfile.exe)
    StreamWriteString(Stream, Description);// ������Ϣ
    StreamWriteInteger(Stream, FileSize);  // �ļ���С��
    StreamWriteInteger(Stream, FileAttr);  // �ļ�����
    StreamWriteString(Stream, Version);    // �汾��(IP��ַ��ʽ)
    StreamWriteByte(Stream, Byte(ResType));// ��Դ�ļ�����
    StreamWriteString(Stream, DownloadURL);// ��Դ���������·��
  end;
end;

function StreamReadResInfo(Stream: TStream): TResInfo;
begin
  with Result do
  begin
    FileName:= StreamReadString(Stream);   // �������·��(��MyDir\Myfile.exe)
    Description:= StreamReadString(Stream);// ������Ϣ
    FileSize:=  StreamReadInteger(Stream); // �ļ���С��
    FileAttr:= StreamReadInteger(Stream);  // �ļ�����
    Version:= StreamReadString(Stream);    // �汾��(IP��ַ��ʽ)
    ResType:= TResType(StreamReadByte(Stream)); // ��Դ�ļ�����
    DownloadURL:= StreamReadString(Stream); // ��Դ���������·��
  end;
end;

{ TResNode }

procedure TResNode.LoadMe(Stream: TStream);
var
  pInfo: PResInfo;
begin
  inherited;
  Text:= StreamReadString(Stream);
  New(pInfo);
  pInfo^:= StreamReadResInfo(Stream);
  Data:= pInfo;
end;

procedure TResNode.SaveMe(Stream: TStream);
begin
  inherited;
  StreamWriteString(Stream, Text);
  StreamWriteResInfo(Stream, PResInfo(Data)^);
end;

{ ThxResTree }

function TResTree.ExtractRelativePath(FileName: string): string;
begin
  if Pos(FRootDir, FileName) = 1 then
    Result:= copy(FileName, Length(FRootDir) + 1, Length(FileName) - Length(FRootDir))
  else
    raise Exception.Create('�ļ��������޷��ҵ����·����');
end;

function TResTree.CreateNode: TNode;
begin
  Result:= TResNode.Create(Self);
end;

procedure TResTree.LoadFiles(Directory: string);
var
  ResNode: TNode;
begin
  FRootDir:= FormatDirectoryName(Directory);
  Clear;    // ɾ�����н�㣬�����ͷŽ������
  ResNode:= RootNode;
  ResNode.Text:= FRootDir;
  SearchFiles(Directory, '*.*', ResNode);
end;

function TResTree.AddDirectory(ParentNode: TResNode; Directory: string): TResNode;

  function GetDirectoryName: string;
  begin
    Result:= FormatDirectoryName(Directory);
    delete(Result, Length(Result), 1);
    Result:= ExtractFileName(Directory);
  end;

var
  Node: TNode;
  pInfo: PResInfo;
begin
  FRootDir:= ParentNode.Tree.RootNode.Text;

  // ���Ŀ¼
  New(pInfo);
  with pInfo^ do
  begin
    FileName:= GetDirectoryName;
    Description:= GetFileDescription(Directory);
    FileSize:= 0;
    FileAttr:= 16;
    Version:= GetFileVersion(Directory);
    ResType:= rtDirectory;
    DownloadURL:= ExtractRelativePath(Directory);
  end;

  Node:= AddNode(ParentNode, pInfo^.FileName);
  Node.Data:= pInfo;
  Result:= TResNode(Node);

  SearchFiles(Directory, '*.*', Node);
end;

procedure TResTree.SearchFiles(APath, Mask: string; var Node: TNode);

  function IsDirNotation(ADirName: string): Boolean;
  begin
    Result:= (ADirName = '.') or (ADirName = '..');
  end;

var
  srFile, srDir: TSearchRec;
  FindResult: Integer;
  pInfo: PResInfo;
begin
  APath:= FormatDirectoryName(APath);
  FindResult:= FindFirst(APath + Mask, faAnyFile + faHidden + faSysFile + faReadOnly, srFile);
  try
    // �����ļ�
    while FindResult = 0 do
    begin
      New(pInfo);
      with pInfo^ do
      begin
        FileName:= srFile.Name;
        Description:= GetFileDescription(srFile.Name);
        FileSize:= srFile.Size;
        FileAttr:= srFile.Attr;
        ModifyTime:= FileDateToDateTime(FileAge(APath + srFile.Name));
        Version:= GetFileVersion(APath + srFile.Name);
        ResType:= rtFile;
        DownloadURL:= ExtractRelativePath(APath + srFile.Name);
      end;
      AddNode(Node, pInfo^.FileName).Data:= pInfo;

      FindResult:= FindNext(srFile);
    end;

    // ����Ŀ¼
    FindResult:= FindFirst(APath + Mask, faDirectory, srDir);
    while FindResult = 0 do
    begin
      if ((srDir.Attr and faDirectory) = faDirectory) and not IsDirNotation(srDir.Name) then
      begin
        New(pInfo);
        with pInfo^ do
        begin
          FileName:= srDir.Name;
          Description:= GetFileDescription(srDir.Name);
          FileSize:= srDir.Size;
          FileAttr:= srDir.Attr;
          Version:= GetFileVersion(srDir.Name);
          ResType:= rtDirectory;
          DownloadURL:= ExtractRelativePath(APath + srDir.Name);
        end;

        Node:= AddNode(Node, pInfo^.FileName);
        Node.Data:= pInfo;

        SearchFiles(APath + srDir.Name, Mask, Node); // Recursion here
        Node:= Node.Parent;
      end;
      FindResult:= FindNext(srDir);
    end;
  finally
    FindClose(srFile);
  end;
end;

procedure TResTree.Clear;
var
  I: Integer;
begin
  // ɾ������(ע�⣺�����û�����ݣ������ͷ�!)
  for I:= 1 to Count - 1 do
    Dispose(PResInfo(Items[I].Data));
  // ɾ�����
  inherited Clear;;
end;

procedure TResTree.LoadFromFile(FileName: string);
var
  Stream: TStream;
begin
  Clear;
  if not FileExists(FileName) then Exit;
  Stream:= TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TResTree.SaveToFile(FileName: string);
var
  Stream: TStream;
begin
  if FileExists(FileName) then DeleteFile(FileName);
  Stream:= TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

{ TVersionList }

procedure TVersionList.Add(AFileName, AVersion: string);
var
  pInfo: PVersionInfo;
begin
  New(pInfo);
  with pInfo^ do
  begin
    FileName:= AFileName;
    Version:= AVersion;
  end;
  FVersions.Add(pInfo);
end;

procedure TVersionList.Clear;
var
  I: Integer;
begin
  for I:= FVersions.Count - 1 downto 0 do
    Dispose(PVersionInfo(FVersions[I]));
  FVersions.Clear;
end;

constructor TVersionList.Create(FileName: string);
begin
  FFileName:= FileName;
  FVersions:= TList.Create;
  if FileName <> '' then
    LoadFromFile;
end;

destructor TVersionList.Destroy;
begin
  if FFileName <> '' then
    SaveToFile;
  Clear;
  FVersions.Free;
  inherited;
end;

function TVersionList.GetCount: Integer;
begin
  Result:= FVersions.Count;
end;

function TVersionList.GetItems(Index: Integer): PVersionInfo;
begin
  Result:= PVersionInfo(FVersions[Index]);
end;

function TVersionList.GetVersions(FileName: string): TVersion;
var
  Index: Integer;
begin
  Index:= IndexOf(FileName);
  if Index = -1 then
    raise Exception.Create('δ�ҵ��ļ��汾��Ϣ!');
  Result:= Items[Index]^.Version;
end;

function TVersionList.IndexOf(FileName: string): Integer;
var
  I: Integer;
begin
  Result:= -1;
  for I:= 0 to FVersions.Count - 1 do
    if SameText(PVersionInfo(FVersions[I])^.FileName, FileName) then
    begin
      Result:= I;
      Break;
    end;
end;

procedure TVersionList.LoadFromFile;
var
  Stream: TStream;
  I, C: Integer;
  szFileName, szVersion: string;
begin
  Clear;
  if not FileExists(FFileName) then Exit;
  Stream:= TFileStream.Create(FFileName, fmOpenRead);
  try
    C:= StreamReadInteger(Stream);
    for I:= 0 to C - 1 do
    begin
      szFileName:= StreamReadString(Stream);
      szVersion:= StreamReadString(Stream);
      Add(szFileName, szVersion);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TVersionList.SaveToFile;
var
  Stream: TStream;
  I: Integer;
begin
  Stream:= TFileStream.Create(FFileName, fmCreate);
  try
    StreamWriteInteger(Stream, Count);
    for I:= 0 to Count - 1 do
    begin
      StreamWriteString(Stream, Items[I]^.FileName);
      StreamWriteString(Stream, Items[I].Version);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TVersionList.SetVersions(FileName: string; const Value: TVersion);
var
  Index: Integer;
begin
  Index:= IndexOf(FileName);
  if Index = -1 then
    raise Exception.Create('δ�ҵ��ļ��汾��Ϣ!');
  Items[Index]^.Version:= Value;
end;


procedure TVersionList.Update(FileName, Version: string);
var
  Index: Integer;
begin
  Index:= IndexOf(FileName);
  if Index <> -1 then
    Items[Index]^.Version:= Version
  else
    Add(FileName, Version);
end;

function TResTree.AddFile(ParentNode: TResNode; AFileName: string): TResNode;
var
  pInfo: PResInfo;
  srFile: TSearchRec;
  APath: string;
begin
  FRootDir:= ParentNode.Tree.RootNode.Text;
  APath:= ExtractFilePath(AFileName);

  FindFirst(AFileName, faAnyFile + faHidden + faSysFile + faReadOnly, srFile);
  try
    New(pInfo);
    with pInfo^ do
    begin
      FileName:= srFile.Name;
      Description:= GetFileDescription(srFile.Name);
      FileSize:= srFile.Size;
      FileAttr:= srFile.Attr;
      ModifyTime:= FileDateToDateTime(FileAge(APath + srFile.Name));
      Version:= GetFileVersion(APath + srFile.Name);
      ResType:= rtFile;
      DownloadURL:= ExtractRelativePath(APath + srFile.Name);
    end;

    Result:= TResNode(AddNode(ParentNode, pInfo^.FileName));
    Result.Data:= pInfo;
  finally
    FindClose(srFile);
  end;
end;

end.
