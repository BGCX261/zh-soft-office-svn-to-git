unit DBScriptExecutorImpl;

interface

uses Classes,Windows,SysUtils,AdoDb,Db,SQLDMO_TLB,Contnrs;

type
  TSqlObjectType=(otUserDefineDataType,otSystemTable,otView,otUserTable,otStoredProcedure,
    otDefault,otRule,otTrigger,otUserDefinedFunction,otAllDatabaseUserObjects,
    otAllDatabaseObjects,otAllbutSystemObjects);

  TSqlObjectTypes=set of TSqlObjectType;

  TScriptState=(ssUnKnown,ssSuccess,ssError);

  EDBScriptExecutorError=class(Exception);

  TDBScriptExecutor=class(TComponent)
  private
    Server:_SQLServer2;
    Database:_Database2;
  protected
    FLastError:string;
    function TryExecuteScript(Buffer:string):TScriptState;
    function ReadScript(AFileName:string):string;
    function GetDBObjectList(DBType:TSqlObjectType):SQLObjectList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure InitialzeDBScriptExecutorEnvironment;
    function ExecSqlFile(AFileName:string):TScriptState;
    function ExecSqlBuffer(Buffer:string):TScriptState;
    procedure DBObjectTransfterSQLScript(DBType:TSqlObjectType;TargetDir:string);overload;
    procedure DBObjectTransfterSQLScript(DBType:TSqlObjectType;TargetDir:string;DBObjectName:string);overload;
    property LastError:string read FLastError;
  end;

implementation

uses EnvironmentImpl,DataAccess;
{ TDBScriptExecutor }

constructor TDBScriptExecutor.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TDBScriptExecutor.DBObjectTransfterSQLScript(
  DBType: TSqlObjectType; TargetDir: string);
var
  FileName:string;
  List:SQLObjectList;
  Obj:DBObject;
  Index:Integer;
begin
  List:=GetDBObjectList(DBType);
  if List=nil then Exit;
  ForceDirectories(IncludeTrailingPathDelimiter(TargetDir));
  for Index:=1 to List.Count do
  begin
    Obj:=List.Item(Index) as DBObject;
    FileName:=IncludeTrailingPathDelimiter(TargetDir)+'dbo.'+Obj.Name+'.Sql';
    Obj.Script(SQLDMOScript_Default,FileName,SQLDMOScript2_AnsiFile);
  end;
end;

procedure TDBScriptExecutor.DBObjectTransfterSQLScript(
  DBType: TSqlObjectType; TargetDir, DBObjectName: string);
var
  FileName:string;
  List:SQLObjectList;
  Obj:DBObject;
  Index:Integer;
begin
  List:=GetDBObjectList(DBType);
  if List=nil then Exit;
  ForceDirectories(IncludeTrailingPathDelimiter(TargetDir));
  for Index:=1 to List.Count do
  begin
    Obj:=List.Item(Index) as DBObject;
    if SameText(OBJ.Name,DBObjectName)then
    begin
      FileName:=IncludeTrailingPathDelimiter(TargetDir)+'dbo.'+Obj.Name+'.Sql';
      Obj.Script(SQLDMOScript_Default,FileName,SQLDMOScript2_AnsiFile);
      Break;
    end;
  end;
end;

destructor TDBScriptExecutor.Destroy;
begin
  if Server<>nil then
    Server:=nil;
  if Database<>nil then
    Database:=nil;
  inherited;
end;


function TDBScriptExecutor.ExecSqlBuffer(Buffer: string): TScriptState;
begin
  Result:=TryExecuteScript(Buffer);
end;

function TDBScriptExecutor.ExecSqlFile(AFileName:string):TScriptState;
var
  Buffer:string;
begin
  Result:=ssError;
  if FileExists(AFileName)then
  begin
    Buffer:=ReadScript(AFileName);
    if(Buffer<>EmptyStr)then
      Result:=TryExecuteScript(Buffer)
    else begin
      FLastError:='Sql Script is Empty';
    end;
  end else
  begin
    FLastError:='SQL File is not Exists';
  end;
end;

function TDBScriptExecutor.GetDBObjectList(
  DBType: TSqlObjectType): SQLObjectList;
begin
  Result:=nil;
  case DBType of
    otUserDefineDataType:Result:=Database.ListObjects(SQLDMOObj_UserDefinedDatatype,SQLDMOObjSort_Name);
    otSystemTable:Result:=Database.ListObjects(SQLDMOObj_SystemTable,SQLDMOObjSort_Name);
    otView:Result:=Database.ListObjects(SQLDMOObj_View,SQLDMOObjSort_Name);
    otUserTable:Result:=Database.ListObjects(SQLDMOObj_UserTable,SQLDMOObjSort_Name);
    otStoredProcedure:Result:=Database.ListObjects(SQLDMOObj_StoredProcedure,SQLDMOObjSort_Name);
    otDefault:Result:=Database.ListObjects(SQLDMOObj_Default,SQLDMOObjSort_Name);
    otRule:Result:=Database.ListObjects(SQLDMOObj_Rule,SQLDMOObjSort_Name);
    otTrigger:Result:=Database.ListObjects(SQLDMOObj_Trigger,SQLDMOObjSort_Name);
    otUserDefinedFunction:Result:=Database.ListObjects(SQLDMOObj_UserDefinedFunction,SQLDMOObjSort_Name);
    otAllDatabaseUserObjects:Result:=Database.ListObjects(SQLDMOObj_AllDatabaseUserObjects,SQLDMOObjSort_Name);
    otAllDatabaseObjects:Result:=Database.ListObjects(SQLDMOObj_AllDatabaseObjects,SQLDMOObjSort_Name);
    otAllbutSystemObjects:Result:=Database.ListObjects(SQLDMOObj_AllButSystemObjects,SQLDMOObjSort_Name);
  end;
end;

procedure TDBScriptExecutor.InitialzeDBScriptExecutorEnvironment;
var
  Index:Integer;
  DB:_Database;
begin
  with _Environment.ConfigSettings do
  begin
    Server:=nil;Database:=nil;
    Server:=CoSQLServer2.Create;
    Server.Connect(ConnStrBulider.DataSource,ConnStrBulider.User,ConnStrBulider.Password);
    for Index:=1 to Server.Databases.Count do
    begin
      DB:=Server.Databases.Item(Index,Server);
      if SameText(DB.Name,ConnStrBulider.Database)then
      begin
        Database:=DB as _Database2;
        Break;
      end;
    end;
  end;
  if Database=nil then
    raise EDBScriptExecutorError.Create('初始化数据库执行环境错误');
end;

function TDBScriptExecutor.ReadScript(AFileName: string): string;
var
  FileHandle:TextFile;
  Buffer:string;
begin
  Result:=EmptyStr;
  AssignFile(FileHandle,AFileName);
  try
    Reset(FileHandle);
    while not Eof(FileHandle) do
    begin
      Buffer:=EmptyStr;
      Readln(FileHandle,Buffer);
      Result:=Result+Buffer+sLineBreak;
    end;
  finally
    CloseFile(FileHandle);
  end;
end;

function TDBScriptExecutor.TryExecuteScript(Buffer: string): TScriptState;
begin
  try
    FLastError:=EmptyStr;
    if Buffer<>EmptyStr then
      Database.ExecuteImmediate(Buffer,SQLDMOExec_Default,Length(Buffer));
    Result:=ssSuccess;
  except
    on E:Exception do
    begin
      FLastError:=E.Message;
      Result:=ssError;
    end;
  end;
end;

end.
