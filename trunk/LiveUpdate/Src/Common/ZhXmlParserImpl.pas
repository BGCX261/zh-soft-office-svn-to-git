
{*******************************************************}
{                                                       }
{  XML File IO Manager                                  }
{  XML�ļ���IO����                                      }
{                                                       }
{  Author: �º���                                       }
{  Data:   2007-03-23                                   }
{  Build:  2007-03-23                                   }
{                                                       }
{*******************************************************}

unit ZhXmlParserImpl;

interface

uses
  SysUtils, Classes, Variants, Forms, XMLDoc, XMLIntf, ZhConstProtocol;

type
  TXMLParser = class
  private
    FExeDir: string;                   //��ִ���ļ�·��
    FUpdateDir: string;                //���յ��Ĵ������ļ��ı���·��
    FCurrentDir: string;               //��ǰ������·��
    FFileName: string;
    FErrorInfo: string;
    function InitXMLDocument(var AXMLDocument: TXMLDocument): Boolean;
    function CreateXMLDocument(var AXMLDocument: TXMLDocument): Boolean;
    function GetRoot(var AXMLDocument: TXMLDocument): IXMLNode;
    procedure NoError;
  public
    constructor Create;
    destructor Destroy; override;
    { �������� }
    class function GetExeDir: string;
    class function ConvertVariantToInt(const AVariant: OleVariant): Integer;
    class function ConvertVariantToStr(const AVariant: OleVariant): string;
    class function ConvertVariantToBool(const AVariant: OleVariant): Boolean;
    class function SetDir(const ADir: string): string;
    { Update List }
    function GetBatchNo: string;
    function SetBatchNo(const ABatchNo: string): Boolean; overload;
    function SetBatchNo(const ABatchNo: TDateTime): Boolean; overload;
    function GetUpdateList(var AList: TList): Boolean;
    function SetUpdateList(const AList: TList): Boolean;
    { Client Config }
    function GetClientConfig: TClientConfig;
    function SetClientConfig(const AClientConfig: TClientConfig): Boolean;
    { Client Running Information }
    function GetClientRunningInfo: TClientRunningInfo;
    function SetClientRunningInfo(const AClientRunningInfo: TClientRunningInfo): Boolean;
    { Client Backup File Information }
    procedure GetClientBackupInfoArray(var AClientBackupInfoArray: TClientBackupInfoArray);
    function GetClientBackupInfo(const AFileName: string): TClientBackupInfo;
    function InsertClientBackupInfo(const AClientBackupInfo: TClientBackupInfo): Boolean;
    function DeleteClientBackupInfo(const AFileName: string): Boolean;
    { �������� }
    property ExeDir: string read FExeDir;
    property UpdateDir: string read FUpdateDir;
    property CurrentDir: string read FCurrentDir write FCurrentDir;
    property FileName: string read FFileName write FFileName;
    property ErrorInfo: string read FErrorInfo;
  end;

const
  UPDATELIST_ROOT = 'UpdateList';
  UPDATELIST_BATCHNO = 'BatchNo';
  UPDATELIST_FILEINFO = 'FileInfo';
  UPDATELIST_FILEINFO_INDEX = 'Index';
  UPDATELIST_FILEINFO_FILENAME = 'FileName';
  UPDATELIST_FILEINFO_FILEPATH = 'FilePath';
  UPDATELIST_FILEINFO_FILELENGTH = 'FileLength';
  CLIENTCONFIG_ROOT = 'ClientConfig';
  CLIENTCONFIG_SERVERIP = 'ServerIP';
  CLIENTCONFIG_SERVERPORT = 'ServerPort';
  CLIENTRUNNING_ROOT = 'ClientRunning';
  CLIENTRUNNING_TRANSPORT = 'Transport';
  CLIENTRUNNING_FILEINDEX = 'FileIndex';
  CLIENTRUNNING_PACKAGEINDEX = 'PackageIndex';
  CLIENTBACKUP_ROOT = 'ClientBackupInfo';
  CLIENTBACKUP_BACKUPINFO = 'FileInfo';
  CLIENTBACKUP_BATCH = 'Batch';
  CLIENTBACKUP_FILENAME = 'FileName';


{$I 'Language.inc'}

implementation

{ TXMLParser }

{ ת��Variant���� }
{ 2007-03-23 by muhx }
class function TXMLParser.ConvertVariantToBool(const AVariant: OleVariant): Boolean;
begin
  try
    if VarIsNull(AVariant) then
      Result := False
    else
      Result := AVariant;
  except
    Result := False;
  end;
end;

{ ת��Variant���� }
{ 2007-03-23 by muhx }
class function TXMLParser.ConvertVariantToInt(const AVariant: OleVariant): Integer;
begin
  try
    if VarIsNull(AVariant) then
      Result := 0
    else
      Result := AVariant;
  except
    Result := 0;
  end;
end;

{ ת��Variant���� }
{ 2007-03-23 by muhx }
class function TXMLParser.ConvertVariantToStr(const AVariant: OleVariant): string;
begin
  try
    if VarIsNull(AVariant) then
      Result := ''
    else
      Result := AVariant;
  except
    Result := '';
  end;
end;

{ ���ص�ǰ��ִ���ļ����ڵ�·��, ��'\'���� }
{ 2007-03-23 by muhx }
class function TXMLParser.GetExeDir: string;
begin
  try
    Result := ExtractFileDir(Application.ExeName);
    Result := Trim(Result);
    Result := IncludeTrailingPathDelimiter(Result);
  except
    Result := '';
  end;
end;

{ ���ò�ѯ·�� }
{ 2007-03-22 by muhx }
class function TXMLParser.SetDir(const ADir: string): string;
begin
  Result := '';
  if not DirectoryExists(ADir) then
    if not ForceDirectories(ADir) then
      raise Exception.Create('Create Error');
  Result := ADir;
end;

{ ���� }
{ 2007-03-23 by muhx }
constructor TXMLParser.Create;
begin
  inherited;
  try
    FExeDir := GetExeDir;
    FUpdateDir := SetDir(GetExeDir + FILEPATH_UPDATE);
    FCurrentDir := FUpdateDir;
    FFileName := FILENAME_UPDATELIST;
    NoError;
  except
    on E: Exception do
      FErrorInfo := E.Message;
  end;
end;

{ �ͷŶ��� }
{ 2007-03-23 by muhx }
destructor TXMLParser.Destroy;
begin
  inherited Destroy;
end;

{ ����XMLDocument�ؼ������XML��� }
{ 2007-03-23 by muhx }
function TXMLParser.CreateXMLDocument(var AXMLDocument: TXMLDocument): Boolean;
begin
  Result := False;
  if Assigned(AXMLDocument) then
  begin
    FErrorInfo := LXMLDocumentExist;
    Exit;
  end;
  AXMLDocument := TXMLDocument.Create(Application);
  try
    with AXMLDocument do
    begin
      Options := Options + [doNodeAutoIndent];
      Active := False;
      XML.Clear;
      Active := True;
      Result := Active;
      if Result then
        NoError;
    end;
  except
    on E: Exception do
      FErrorInfo := E.Message;
  end;
end;

{ ��ʼ��XMLDocument�ؼ� }
{ 2007-03-23 by muhx }
function TXMLParser.InitXMLDocument(var AXMLDocument: TXMLDocument): Boolean;
begin
  Result := False;
  if not Assigned(AXMLDocument) then
    Result := CreateXMLDocument(AXMLDocument);
  try
    with AXMLDocument do
    begin
      Active := False;
      Options := Options + [doNodeAutoIndent];
      XML.Clear;
      Active := True;
      Version := '1.0';
      Encoding := 'GB2312';
      StandAlone := 'no';
      Result := Active;
      if Result then
        NoError;
    end;
  except
    on E: Exception do
      FErrorInfo := E.Message;
  end;
end;

{ ����״̬����մ������ }
{ 2007-03-22 by muhx }
procedure TXMLParser.NoError;
begin
  FErrorInfo := '';
end;

{ �õ�XML�ļ��еĸ��ڵ� }
{ 2007-03-23 by muhx }
function TXMLParser.GetRoot(var AXMLDocument: TXMLDocument): IXMLNode;
begin
  try
    AXMLDocument.Active := False;
    AXMLDocument.XML.Clear;
    AXMLDocument.LoadFromFile(IncludeTrailingPathDelimiter(FCurrentDir) + FFileName);
    Result := AXMLDocument.DocumentElement;
    NoError;
  except
    on E: Exception do
    begin
      FErrorInfo := E.Message;
      Result := nil;
    end;
  end;
end;

{ UpdateList }

{ ���ļ��еõ����κ� }
{ 2007-03-22 by muhx }
function TXMLParser.GetBatchNo: string;
var
  TmpRoot: IXMLNode;
  TmpFileName: string;
  TmpXMLDocument: TXMLDocument;
begin
  Result := '';
  { �ڵ����������֮ǰʹ����ҪԤ��ȷ�� FCurrentDir �� FFileName }
  TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      if not FileExists(TmpFileName) then
        SetBatchNo('');
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      if not Assigned(TmpRoot.ChildNodes.FindNode(UPDATELIST_BATCHNO)) then
      begin
        SetBatchNo('');
        TmpRoot := GetRoot(TmpXMLDocument);
      end;
      Result := ConvertVariantToStr(TmpRoot.ChildNodes.FindNode(UPDATELIST_BATCHNO).NodeValue);
      NoError;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ �����κ�д���ļ� }
{ 2007-03-22 by muhx }
function TXMLParser.SetBatchNo(const ABatchNo: string): Boolean;
var
  TmpFileName: string;
  TmpRoot, TmpBatchNo: IXMLNode;
  TmpXMLDocument: TXMLDocument;
begin
  Result := False;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_UPDATE);
      FFileName := FILENAME_UPDATELIST;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
      begin
        if not InitXMLDocument(TmpXMLDocument) then
          Abort;
        TmpRoot := TmpXMLDocument.AddChild(UPDATELIST_ROOT);
        TmpBatchNo := TmpRoot.AddChild(UPDATELIST_BATCHNO);
        TmpBatchNo.NodeValue := ABatchNo;
      end
      else
      begin
        TmpRoot := GetRoot(TmpXMLDocument);
        if TmpRoot = nil then
          Abort;
        if not Assigned(TmpRoot.ChildNodes.FindNode(UPDATELIST_BATCHNO)) then
          TmpRoot.AddChild(UPDATELIST_BATCHNO);
        TmpRoot.ChildNodes.FindNode(UPDATELIST_BATCHNO).NodeValue := ABatchNo;
      end;
      TmpXMLDocument.SaveToFile(TmpFileName);
      NoError;
      Result := True;
    except
      on E: Exception do
      begin
        FErrorInfo := E.Message;
        Exit;
      end;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ �����κ�д���ļ� }
{ 2007-03-22 by muhx }
function TXMLParser.SetBatchNo(const ABatchNo: TDateTime): Boolean;
var
  TmpBatchNo: string;
begin
  TmpBatchNo := FormatDateTime(BATCH_FORMAT, Now);
  Result := SetBatchNo(TmpBatchNo);
end;

{ ���ļ��еõ��ļ��б� }
{ 2007-03-22 by muhx }
function TXMLParser.GetUpdateList(var AList: TList): Boolean;
var
  TmpFileName: string;
  TmpRoot, TmpFileInfo: IXMLNode;
  TmpPFileInfo: PFileInfo;
  I: Integer;
  TmpXMLDocument: TXMLDocument;
begin
  Result := False;
  if not Assigned(AList) then
  begin
    FErrorInfo := LListNotCreate;
    Exit;
  end;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_UPDATE);
      FFileName := FILENAME_UPDATELIST;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      AList.Clear;
      if not FileExists(TmpFileName) then
        SetUpdateList(AList);
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      for I := 0 to TmpRoot.ChildNodes.Count - 1 do
      begin
        TmpFileInfo := TmpRoot.ChildNodes[I];
        if TmpFileInfo.NodeName = UPDATELIST_FILEINFO then
        begin
          New(TmpPFileInfo);
          TmpPFileInfo^.fiIndex :=
            ConvertVariantToInt(TmpFileInfo.ChildNodes.FindNode(UPDATELIST_FILEINFO_INDEX).NodeValue);
          TmpPFileInfo^.fiFileName :=
            ConvertVariantToStr(TmpFileInfo.ChildNodes.FindNode(UPDATELIST_FILEINFO_FILENAME).NodeValue);
          TmpPFileInfo^.fiFilePath :=
            ConvertVariantToStr(TmpFileInfo.ChildNodes.FindNode(UPDATELIST_FILEINFO_FILEPATH).NodeValue);
          TmpPFileInfo^.fiFileLength :=
            ConvertVariantToStr(TmpFileInfo.ChildNodes.FindNode(UPDATELIST_FILEINFO_FILELENGTH).NodeValue);
          AList.Add(TmpPFileInfo);
        end;
      end;
      NoError;
      Result := True;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ �������б�д��XML�ļ� }
{ 2007-03-22 by muhx }
function TXMLParser.SetUpdateList(const AList: TList): Boolean;
var
  TmpFileName: string;
  TmpRoot, TmpFileInfo, TmpNode: IXMLNode;
  TmpPFileInfo: PFileInfo;
  I: Integer;
  TmpXMLDocument: TXMLDocument;
begin
  Result := False;
  if not Assigned(AList) then
  begin
    FErrorInfo := LListNotCreate;
    Exit;
  end;
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_UPDATE);
      FFileName := FILENAME_UPDATELIST;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
      begin
        if not InitXMLDocument(TmpXMLDocument) then
          Abort;
        TmpRoot := TmpXMLDocument.AddChild(UPDATELIST_ROOT);
      end
      else
        TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      for I := TmpRoot.ChildNodes.Count - 1 downto 0 do
        if TmpRoot.ChildNodes[I].NodeName = UPDATELIST_FILEINFO then
          TmpRoot.ChildNodes.Delete(I);
      for I := 0 to AList.Count - 1 do
      begin
        TmpPFileInfo := PFileInfo(AList.Items[I]);
        TmpFileInfo := TmpRoot.AddChild(UPDATELIST_FILEINFO);
        TmpNode := TmpFileInfo.AddChild(UPDATELIST_FILEINFO_INDEX);
        TmpNode.NodeValue := TmpPFileInfo^.fiIndex;
        TmpNode := TmpFileInfo.AddChild(UPDATELIST_FILEINFO_FILENAME);
        TmpNode.NodeValue := TmpPFileInfo^.fiFileName;
        TmpNode := TmpFileInfo.AddChild(UPDATELIST_FILEINFO_FILEPATH);
        TmpNode.NodeValue := TmpPFileInfo^.fiFilePath;
        TmpNode := TmpFileInfo.AddChild(UPDATELIST_FILEINFO_FILELENGTH);
        TmpNode.NodeValue := TmpPFileInfo^.fiFileLength;
      end;
      TmpXMLDocument.SaveToFile(TmpFileName);
      NoError;
      Result := True;
    except
      on E: Exception do
      begin
        FErrorInfo := E.Message;
        Exit;
      end;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ Client Config }

{ ��ȡ�ͻ������� }
{ 2007-03-29 by muhx }
function TXMLParser.GetClientConfig: TClientConfig;
var
  TmpFileName: string;
  TmpRoot: IXMLNode;
  TmpXMLDocument: TXMLDocument;
begin
  FillChar(Result, SizeOf(Result), 0);
  Result.ccServerIP := '127.0.0.1';
  Result.ccServerPort := 5150;
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_CONFIG);
      FFileName := FILENAME_CLIENTCONFIG;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
        SetClientConfig(Result);
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      with Result do
      begin
        ccServerIP := ConvertVariantToStr(TmpRoot.ChildNodes.FindNode(CLIENTCONFIG_SERVERIP).NodeValue);
        ccServerPort := ConvertVariantToInt(TmpRoot.ChildNodes.FindNode(CLIENTCONFIG_SERVERPORT).NodeValue);
      end;
      NoError;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ ���ÿͻ������� }
{ 2007-03-29 by muhx }
function TXMLParser.SetClientConfig(const AClientConfig: TClientConfig): Boolean;
var
  TmpFileName: string;
  TmpRoot, TmpNode: IXMLNode;
  TmpXMLDocument: TXMLDocument;
begin
  Result := False;
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_CONFIG);
      FFileName := FILENAME_CLIENTCONFIG;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
      begin
        if not InitXMLDocument(TmpXMLDocument) then
          Abort;
        TmpRoot := TmpXMLDocument.AddChild(CLIENTCONFIG_ROOT);
        TmpNode := TmpRoot.AddChild(CLIENTCONFIG_SERVERIP);
        TmpNode.NodeValue := AClientConfig.ccServerIP;
        TmpNode := TmpRoot.AddChild(CLIENTCONFIG_SERVERPORT);
        TmpNode.NodeValue := AClientConfig.ccServerPort;
      end
      else
      begin
        TmpRoot := GetRoot(TmpXMLDocument);
        if TmpRoot = nil then
          Abort;
        if not Assigned(TmpRoot.ChildNodes.FindNode(CLIENTCONFIG_SERVERIP)) then
          TmpRoot.AddChild(CLIENTCONFIG_SERVERIP);
        TmpRoot.ChildNodes.FindNode(CLIENTCONFIG_SERVERIP).NodeValue := AClientConfig.ccServerIP;
        if not Assigned(TmpRoot.ChildNodes.FindNode(CLIENTCONFIG_SERVERPORT)) then
          TmpRoot.AddChild(CLIENTCONFIG_SERVERPORT);
        TmpRoot.ChildNodes.FindNode(CLIENTCONFIG_SERVERPORT).NodeValue := AClientConfig.ccServerPort;
      end;
      TmpXMLDocument.SaveToFile(TmpFileName);
      NoError;
      Result := True;
    except
      on E: Exception do
      begin
        FErrorInfo := E.Message;
        Exit;
      end;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ Client Running Information }

{ ��ȡ�ͻ���ʵʱ��Ϣ }
{ 2007-03-30 by muhx }
function TXMLParser.GetClientRunningInfo: TClientRunningInfo;
var
  TmpFileName: string;
  TmpRoot: IXMLNode;
  TmpXMLDocument: TXMLDocument;
begin
  FillChar(Result, SizeOf(Result), 0);
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_CONFIG);
      FFileName := FILENAME_RUNNING;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
        SetClientRunningInfo(Result);
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      with Result do
      begin
        criTransport := ConvertVariantToBool(TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_TRANSPORT).NodeValue);
        criFileIndex := ConvertVariantToInt(TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_FILEINDEX).NodeValue);
        criPackageIndex := ConvertVariantToInt(TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_PACKAGEINDEX).NodeValue);
      end;
      NoError;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ ���ÿͻ���ʵʱ��Ϣ }
{ 2007-03-30 by muhx }
function TXMLParser.SetClientRunningInfo(const AClientRunningInfo: TClientRunningInfo): Boolean;
var
  TmpFileName: string;
  TmpRoot, TmpNode: IXMLNode;
  TmpXMLDocument: TXMLDocument;
begin
  Result := False;
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_CONFIG);
      FFileName := FILENAME_RUNNING;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
      begin
        if not InitXMLDocument(TmpXMLDocument) then
          Abort;
        TmpRoot := TmpXMLDocument.AddChild(CLIENTRUNNING_ROOT);
        { Transport }
        TmpNode := TmpRoot.AddChild(CLIENTRUNNING_TRANSPORT);
        TmpNode.NodeValue := AClientRunningInfo.criTransport;
        { File index }
        TmpNode := TmpRoot.AddChild(CLIENTRUNNING_FILEINDEX);
        TmpNode.NodeValue := AClientRunningInfo.criFileIndex;
        { Package index }
        TmpNode := TmpRoot.AddChild(CLIENTRUNNING_PACKAGEINDEX);
        TmpNode.NodeValue := AClientRunningInfo.criPackageIndex;
      end
      else
      begin
        TmpRoot := GetRoot(TmpXMLDocument);
        if TmpRoot = nil then
          Abort;
        { Transport }
        if not Assigned(TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_TRANSPORT)) then
          TmpRoot.AddChild(CLIENTRUNNING_TRANSPORT);
        TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_TRANSPORT).NodeValue := AClientRunningInfo.criTransport;
        { File index }
        if not Assigned(TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_FILEINDEX)) then
          TmpRoot.AddChild(CLIENTRUNNING_FILEINDEX);
        TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_FILEINDEX).NodeValue := AClientRunningInfo.criFileIndex;
        { Package index }
        if not Assigned(TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_PACKAGEINDEX)) then
          TmpRoot.AddChild(CLIENTRUNNING_PACKAGEINDEX);
        TmpRoot.ChildNodes.FindNode(CLIENTRUNNING_PACKAGEINDEX).NodeValue := AClientRunningInfo.criPackageIndex;
      end;
      TmpXMLDocument.SaveToFile(TmpFileName);
      NoError;
      Result := True;
    except
      on E: Exception do
      begin
        FErrorInfo := E.Message;
        Exit;
      end;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ Client Backup Information }

{ ȡ�����б����ļ���¼ }
{ 2007-03-30 by muhx }
procedure TXMLParser.GetClientBackupInfoArray(var AClientBackupInfoArray: TClientBackupInfoArray);
var
  TmpFileName: string;
  TmpRoot, TmpNode: IXMLNode;
  TmpXMLDocument: TXMLDocument;
  TmpClientBackupInfo: TClientBackupInfo;
  TmpArrayLength, I: Integer;
begin
  SetLength(AClientBackupInfoArray, 0);
  FillChar(TmpClientBackupInfo, SizeOf(TmpClientBackupInfo), 0);
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_BACKUP);
      FFileName := FILENAME_BACKUP;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
        InsertClientBackupInfo(TmpClientBackupInfo);
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      TmpArrayLength := TmpRoot.ChildNodes.Count;
      if TmpArrayLength <= 0 then
        Exit;
      SetLength(AClientBackupInfoArray, TmpArrayLength);
      for I := 0 to TmpArrayLength - 1 do
      begin
        TmpNode := TmpRoot.ChildNodes[I];
        AClientBackupInfoArray[I].cbiBatch :=
          ConvertVariantToStr(TmpNode.ChildNodes.FindNode(CLIENTBACKUP_BATCH).NodeValue);
        AClientBackupInfoArray[I].cbiFileName :=
          ConvertVariantToStr(TmpNode.ChildNodes.FindNode(CLIENTBACKUP_FILENAME).NodeValue);
      end;
      NoError;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ ȡ�÷��������ı����ļ���¼ }
{ 2007-03-30 by muhx }
function TXMLParser.GetClientBackupInfo(const AFileName: string): TClientBackupInfo;
var
  TmpFileName: string;
  TmpRoot: IXMLNode;
  TmpXMLDocument: TXMLDocument;
  I: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_BACKUP);
      FFileName := FILENAME_BACKUP;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
        InsertClientBackupInfo(Result);
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      for I := 0 to TmpRoot.ChildNodes.Count - 1 do
      begin
        if AFileName =
          ConvertVariantToStr(TmpRoot.ChildNodes[I].ChildNodes.FindNode(CLIENTBACKUP_FILENAME).NodeValue) then
        begin
          Result.cbiFileName := AFileName;
          Result.cbiBatch :=
            ConvertVariantToStr(TmpRoot.ChildNodes[I].ChildNodes.FindNode(CLIENTBACKUP_BATCH).NodeValue);
        end;
      end;
      NoError;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ ɾ�����������ı����ļ���¼ }
{ 2007-03-30 by muhx }
function TXMLParser.DeleteClientBackupInfo(const AFileName: string): Boolean;
var
  TmpFileName: string;
  TmpRoot: IXMLNode;
  TmpXMLDocument: TXMLDocument;
  I: Integer;
begin
  Result := False;
  FillChar(Result, SizeOf(Result), 0);
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_BACKUP);
      FFileName := FILENAME_BACKUP;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      if not FileExists(TmpFileName) then
        Exit;
      TmpRoot := GetRoot(TmpXMLDocument);
      if TmpRoot = nil then
        Abort;
      for I := 0 to TmpRoot.ChildNodes.Count - 1 do
      begin
        if AFileName =
          ConvertVariantToStr(TmpRoot.ChildNodes[I].ChildNodes.FindNode(CLIENTBACKUP_FILENAME).NodeValue) then
        begin
          TmpRoot.ChildNodes.Delete(I);
          Break;
        end;
      end;
      { �����ļ� }
      TmpXMLDocument.SaveToFile(TmpFileName);
      NoError;
      Result := True;
    except
      on E: Exception do
        FErrorInfo := E.Message;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

{ ���뱸���ļ���¼ }
{ 2007-03-30 by muhx }
function TXMLParser.InsertClientBackupInfo(
  const AClientBackupInfo: TClientBackupInfo): Boolean;
var
  TmpFileName: string;
  TmpRoot, TmpNode, TmpChildNode: IXMLNode;
  TmpXMLDocument: TXMLDocument;
begin
  Result := False;
  TmpXMLDocument := nil;
  CreateXMLDocument(TmpXMLDocument);
  try
    try
      FCurrentDir := SetDir(GetExeDir + FILEPATH_BACKUP);
      FFileName := FILENAME_BACKUP;
      TmpFileName := IncludeTrailingPathDelimiter(FCurrentDir) + FFileName;
      { �ж��ļ��Ƿ���ڣ�����������򴴽��ļ����������ڵ� }  
      if not FileExists(TmpFileName) then
      begin
        if not InitXMLDocument(TmpXMLDocument) then
          Abort;
        TmpRoot := TmpXMLDocument.AddChild(CLIENTBACKUP_ROOT);
      end
      else
      begin
        TmpRoot := GetRoot(TmpXMLDocument);
        if TmpRoot = nil then
          Abort;
      end;
      { �ж��Ƿ�ֻ�Ǵ����ļ� }
      if AClientBackupInfo.cbiBatch = '' then
        Exit;
      { �����ݲ����ļ��� }
      TmpNode := TmpRoot.AddChild(CLIENTBACKUP_BACKUPINFO);
      TmpChildNode := TmpNode.AddChild(CLIENTBACKUP_BATCH);
      TmpChildNode.NodeValue := AClientBackupInfo.cbiBatch;
      TmpChildNode := TmpNode.AddChild(CLIENTBACKUP_FILENAME);
      TmpChildNode.NodeValue := AClientBackupInfo.cbiFileName;
      { �����ļ� }
      TmpXMLDocument.SaveToFile(TmpFileName);
      NoError;
      Result := True;
    except
      on E: Exception do
      begin
        FErrorInfo := E.Message;
        Exit;
      end;
    end;
  finally
    TmpXMLDocument.Free;
  end;
end;

end.
