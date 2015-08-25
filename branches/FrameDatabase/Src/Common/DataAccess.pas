unit DataAccess;

interface

uses
  AdoDB,DB,AdoInt,Windows,Classes,Contnrs,WinSock,SyncObjs,SysUtils,
  ExtCtrls,DataAccessProvider,Provider,DBClient,Dialogs;
const
  dbtAccess = $00000000;
  dbtSqlServer = $00000001;
  dbtOracle = $00000002;
  dbtInterbase = $00000003;
  dbtDb2 = $00000004;
  dbtMySql = $00000005;
  {DBMS_ID}
  SQLSERVER_DBMS_ID ='SqlServer';
  ACCESS_DBMS_ID    ='Access';
  ORACLE_DBMS_ID    ='Oracle';
  INTERBASE_DBMS_ID ='Interbase';
  DB2_DBMS_ID       ='Db2';
  MYSQL_DBMS_ID     ='MySql';

type

  TConnectInPoolStatus=(psNone,psUse,psUnUse);

  EDataAccessException=class(Exception);

  EUnSupportException=class(Exception);
  
  TConnectStringBulider=class(TPersistent)
  private
    FUser: string;
    FPassword: string;
    FDatabase: string;
    FDataSource: string;
    FDbType: Integer;
    FConnStr:string;
    function GetConnectionString: string;
    function GetWorkStation: string;
    procedure SetConnectionString(const Value: string);
    procedure SetDatabaseType(const Value: Integer);
    function GetDBMSDescription: string;
    function GetDBMSID: string;
    procedure SetDataSource(const Value: string);
    function GetDatabase: string;
    function GetConnectName: string;
  protected
    procedure Parser;
  public
    procedure Assign(Source: TPersistent);override;
    property User:string read FUser write FUser;
    property Password:string read FPassword write FPassword;
    property Database:string read GetDatabase write FDatabase;
    property DataSource:string read FDataSource write SetDataSource;
    property DbType:Integer read FDbType write SetDatabaseType;
    property WorkStation:string read GetWorkStation;
    property ConnectionString:string read GetConnectionString write SetConnectionString;
    property DBMSID:string read GetDBMSID;
    property DBMSDescription:string read GetDBMSDescription;
    property ConnectName:string read GetConnectName;
  end;

  TCommandStatement=class(TADOCommand);
  TTableStatement=class(TADOTable);
  TStoredStatement=class(TADOStoredProc);
  TDataSetStatement=class(TADODataSet);
  TQueryStatement=class(TADOQuery);



  IConnection =interface
  ['{ACBF57C8-F868-4946-88BD-862FDE3E5DFB}']
    function GetDbType:Integer;
    function GetProvider:IConnectProvider;
    function GetCommandTimeOut:Integer;
    function GetConnectTimeOut:Integer;
    procedure SetCommandTimeOut(const Value:Integer);
    procedure SetConnectTimeOut(const Value:Integer);
    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
    function GetInTransaction:Boolean;
    function BeginTrans:Integer;
    procedure CommitTrans;
    procedure RollbackTrans;
    function GoBackPool:Boolean;
    procedure UpdateStatementConnection(DataSet:TCustomADODataSet);
    procedure UpdateCommandConnection(Command:TADOCommand);
    function CreateCommand:TCommandStatement;
    function CreateTable:TTableStatement;
    function CreateStoredproc:TStoredStatement;
    function CreateDataSet:TDataSetStatement;overload;
    function CreateDataSet(CursorType:TCursorType;LockType:TAdoLockType):TDataSetStatement;overload;
    function CreateDataSet(const Sql:string):TDataSetStatement;overload;
    function CreateQuery(CursorType:TCursorType;LockType:TAdoLockType):TQueryStatement;overload;
    function CreateQuery:TQueryStatement;overload;
    function CreateQuery(const Sql:string):TQueryStatement;overload;
    property Connected:Boolean read GetConnected write SetConnected;
    property InTransaction:Boolean read GetInTransaction;
    property DbType:Integer read GetDbType;
    property Provider:IConnectProvider read GetProvider;
    property CommandTimeOut:Integer read GetCommandTimeOut write SetCommandTimeOut;
    property ConnectTimeOut:Integer read GetConnectTimeOut write SetConnectTimeOut;
  end;

  IConnectionContext = interface
  ['{BCD4B8B9-25AF-496F-A40A-992DBD4A5882}']
    function GetConnection:IConnection;
    function ConnectString:string;
    function ConnectName:string;
    procedure Close(Connect:IConnection);
  end;

  IConnectionContextManager=interface
  ['{D88DFCF9-A575-489D-AF34-BC0FEE82CFBD}']
    function GetConnectionContext(ConnectName:string):IConnectionContext;
    procedure RegisterConnectionContext(
      const ConnectName:string;
      const ConnectionStr:string;
      const DBType:Integer;
      const MinConnection:Integer=1;
      const MaxConnection:Integer=5;
      const CommandTimeOut:Integer=30;
      const ConnectTimeOut:Integer=15);
    procedure UnRegisterConnectionContext(const ConnectName:string);
    procedure UnRegisterAllConnectionContext;
  end;

  
  TConnection=class(TInterfacedObject,IConnection)
  private
    Connect:TADOConnection;
    FDBType:Integer;
    FCommandTimeOut:Integer;
    FConnectTimeOut:Integer;
    FInPoolStatus: TConnectInPoolStatus;
    FProvider:IConnectProvider;
    FActiveCount: Integer;
    function GetCommandTimeOut: Integer;
    function GetConnectTimeOut: Integer;
    procedure SetCommandTimeOut(const Value: Integer);
    procedure SetConnectTimeOut(const Value: Integer);
  protected
    function GetDbType:Integer;
    function GetProvider:IConnectProvider;
    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
    function GetInTransaction:Boolean;
    function BeginTrans:Integer;
    procedure CommitTrans;
    procedure RollbackTrans;
    function GoBackPool:Boolean;    
    procedure UpdateStatementConnection(DataSet:TCustomADODataSet);
    procedure UpdateCommandConnection(Command:TADOCommand);
    function CreateCommand:TCommandStatement;
    function CreateTable:TTableStatement;
    function CreateStoredproc:TStoredStatement;
    function CreateDataSet:TDataSetStatement;overload;
    function CreateDataSet(CursorType:TCursorType;LockType:TAdoLockType):TDataSetStatement;overload;
    function CreateDataSet(const Sql:string):TDataSetStatement;overload;
    function CreateQuery(CursorType:TCursorType;LockType:TAdoLockType):TQueryStatement;overload;
    function CreateQuery:TQueryStatement;overload;
    function CreateQuery(const Sql:string):TQueryStatement;overload;
    property Connected:Boolean read GetConnected write SetConnected;
    property InTransaction:Boolean read GetInTransaction;
    property DbType:Integer read GetDbType;
    property Provider:IConnectProvider read GetProvider;
    property CommandTimeOut:Integer read GetCommandTimeOut write SetCommandTimeOut;
    property ConnectTimeOut:Integer read GetConnectTimeOut write SetConnectTimeOut;
    property InPoolStatus:TConnectInPoolStatus read FInPoolStatus write FInPoolStatus;
    property ActiveCount:Integer read FActiveCount write FActiveCount;
  public
    constructor Create;
    destructor Destroy;override;
    //property RinpakConnection:TAdoConnection read Connect;
  end;

  TConnectionFactorys=class(TObject)
  private
    FList: TObjectList;
    function GetConnects(Index: Integer): TConnection;
    function Getcount: Integer;
  protected
    property List:TObjectList read FList;
  public
    constructor Create;
    destructor Destroy;override;
    function Add(Conn:TConnection):Integer;
    property Count:Integer read Getcount;
    property Connects[Index:Integer]:TConnection read GetConnects;default;
  end;


  TConnectionContext=class(TInterfacedObject,IConnectionContext)
  private
    
    FMinConnect: Integer;
    FMaxConnect: Integer;
    FConnections: TConnectionFactorys;
    FConnectName:string;
    ConnectBulider:TConnectStringBulider;
    FLock:TCriticalSection;
    FConnectTimeOut: Integer;
    FCommandTimeOut: Integer;
    FHandle:Cardinal;
    FTimeOut:Cardinal;
    FTimer:TTimer;
    FReleaseed:Boolean;
  protected
    procedure DoTimer(Sender:TObject);
    procedure PrepareFreeConnection;
    procedure Lock;
    procedure UnLock;
    function GetUnUseCount:Integer;
    function Search(const NuUse:Boolean=False):TConnection;
    function GetConnection:IConnection;
    procedure Close(Connect:IConnection);
    function ConnectString:string;
    function ConnectName:string;
    procedure Initialize(
      UniqueName:string;
      const ConnectionStr:string;
      const DBType:Integer;
      const MinConnection:Integer=1;
      const MaxConnection:Integer=10;
      const CommandTimeOut:Integer=120;
      const ConnectTimeOut:Integer=15);
    property Connections:TConnectionFactorys read FConnections;
    property MinConnect:Integer read FMinConnect write FMinConnect;
    property MaxConnect:Integer read FMaxConnect write FMaxConnect;
    property CommandTimeOut:Integer read FCommandTimeOut write FCommandTimeOut;
    property ConnectTimeOut:Integer read FConnectTimeOut write FConnectTimeOut;
  public
    constructor Create;
    destructor Destroy;override;
  end;

  TConnectionContextManager=class(TInterfacedObject,IConnectionContextManager)
  private
    FLock:TCriticalSection;
    FConnectContexts: TInterfaceList;
  protected
    procedure Lock;
    procedure UnLock;
    function Find(const ConnectName:string):IConnectionContext;overload;
    function GetConnectionContext(ConnectName:string):IConnectionContext;
    procedure RegisterConnectionContext(
      const ConnectName:string;
      const ConnectionStr:string;
      const DBType:Integer;
      const MinConnection:Integer=1;
      const MaxConnection:Integer=5;
      const CommandTimeOut:Integer=30;
      const ConnectTimeOut:Integer=15);
    procedure UnRegisterConnectionContext(const ConnectName:string);
    procedure UnRegisterAllConnectionContext;
    property ConnectContexts:TInterfaceList read FConnectContexts;
  public
    constructor Create;
    destructor Destroy;override;
  end;


function ConnectionContextMgr:IConnectionContextManager;

implementation

uses Math, ComObj,SqlServerProvider,ActiveX,FuncUtils,FrameCommon;

var
  ContextMgr:IConnectionContextManager=nil;

function ConnectionContextMgr:IConnectionContextManager;
begin
  if ContextMgr=nil then
    ContextMgr:=TConnectionContextManager.Create;
  Result:=ContextMgr;
end;


{ TConnectStringBulider }

procedure TConnectStringBulider.Assign(Source: TPersistent);
var
  Conn:TConnectStringBulider;
begin
  if Source is TConnectStringBulider then
  begin
    Conn:=Source as TConnectStringBulider;
    FUser:=Conn.User;
    FPassword:=Conn.Password;
    FDatabase:=Conn.Database;
    FDataSource:=Conn.DataSource;
    FDbType:=Conn.DbType;
  end;
end;

function TConnectStringBulider.GetConnectionString: string;
const
  MySqlConntion='DRIVER={MySQL ODBC 3.51 Driver};DESC=;'
    +'DATABASE=%s;SERVER=%s;UID=%s;PASSWORD=%s;PORT=3306;OPTION=;STMT=;';
  DB2Connection='Provider=IBMDADB2.1;Password=%s;Persist Security Info=True;'
    +'User ID=%s;Data Source=%s;Location=%s';
  AccessConnection ='Provider=Microsoft.Jet.OLEDB.4.0;User ID=%s;'
    +'Data Source=%s;Persist Security Info=True;Jet OLEDB:Database Password=%s';
  SqlServerConnection='Provider=SQLOLEDB.1;Password=%s'
      +';Persist Security Info=True;User ID=%s'
      +';Initial Catalog=%s;Data Source=%S'
      +';Use Encryption for Data=False;'
      +'Tag with column collation when possible=False;'
      +'Use Procedure for Prepare=1;'
      +'Auto Translate=True;'
      +'Packet Size=4096;'
      +'Workstation ID=%s';
  OracleConnection='Provider=MSDAORA.1;Password=%S;'
      +'User ID=%S;Data Source=%S;Persist Security Info=True';
begin
  Result:='';
  case DbType of
    dbtAccess:Result:=Format(AccessConnection,[User,DataSource,Password]);
    dbtSqlServer:
      Result:=Format(SqlServerConnection,[Password,User,Database,DAtaSource,WorkStation]);
    dbtOracle:Result:=Format(OracleConnection,[Password,User,Database]);
    dbtInterbase:raise EUnSupportException.Create('不支持的数据库类型');
    dbtDB2:Result:=Format(DB2Connection,[Password,User,Database,DataSource]);
    dbtMySql:Result:=Format(MySqlConntion,[Database,DataSource,User,Password]);
    else
      raise EUnSupportException.Create('不支持的数据库类型');
  end;
  FConnStr:=Result;
end;

function TConnectStringBulider.GetConnectName: string;
begin
  Result:=WorkStation+'.'+DBMSID+'.'+Database;
end;

function TConnectStringBulider.GetDatabase: string;
var
  FileName:string;
  I:Integer;
begin
  if DbType=dbtAccess then
  begin
    FileName:=ExtractFileName(DataSource);
    I:=Pos('.',FileName);
    if I>0 then
      Result:=Copy(FileName,1,I-1)
    else Result:=FileName;
  end else Result := FDatabase;
end;

function TConnectStringBulider.GetDBMSDescription: string;
begin
  case DbType of
    dbtAccess:Result:=ACCESS_DBMS_ID;
    dbtSqlServer:Result:=SQLSERVER_DBMS_ID;
    dbtOracle:Result:=ORACLE_DBMS_ID;
    dbtInterbase:Result:=INTERBASE_DBMS_ID;
    dbtDb2:Result:=DB2_DBMS_ID;
    dbtMySql:Result:=MYSQL_DBMS_ID;
    else Result:='UnKnown';
  end;
end;

function TConnectStringBulider.GetDBMSID: string;
begin
  case DbType of
    dbtAccess:Result:=ACCESS_DBMS_ID;
    dbtSqlServer:Result:=SQLSERVER_DBMS_ID;
    dbtOracle:Result:=ORACLE_DBMS_ID;
    dbtInterbase:Result:=INTERBASE_DBMS_ID;
    dbtDb2:Result:=DB2_DBMS_ID;
    dbtMySql:Result:=MYSQL_DBMS_ID;
    else Result:='UnKnown';
  end;
end;

function TConnectStringBulider.GetWorkStation: string;
const
  Len=200;
var
  Data:TWSAData;
  Buffer:PChar;
begin
  GetMem(Buffer,Len);
  try
    try
      Winsock.WSAStartup($101,Data);
      Winsock.gethostname(Buffer,Len);
      Result:=Buffer;
      Winsock.WSACleanup;
    except
    end;
  finally
    FreeMem(Buffer,Len);
  end;
end;

procedure TConnectStringBulider.Parser;
var
  List:TStringList;
  procedure ParserString;
  var
    I,Len:Integer;
    Value:string;
    C:Char;
  begin
    Len:=Length(FConnStr);
    I:=1;
    while (I<=Len) do
    begin
      C:=FConnStr[I];
      if (C<>';') then
        Value:=Value+C
      else if (C=';') then
      begin
        List.Add(Value);
        Value:='';
      end;
      Inc(I);
    end;
    if Value<>'' then
      List.Add(Value);
  end;
  procedure ParserSqlServer;
  var
    Value:string;
  begin
    ParserString;
    User:=List.Values['User ID'];
    Database:=List.Values['Initial Catalog'];
    DataSource:=List.Values['Data Source'];
    Password:=List.Values['Password'];
    Value:=List.Values['Persist Security Info'];
  end;
  procedure ParserMySql;
  begin
    ParserString;
    User:=List.Values['UID'];
    Database:=List.Values['DATABASE'];
    DataSource:=List.Values['SERVER'];
    Password:=List.Values['PASSWORD'];
  end;
  procedure ParserAccess;
  begin
    ParserString;
    User:=List.Values['User ID'];
    DataSource:=List.Values['Data Source'];
    Password:=List.Values['Jet OLEDB:Database Password'];
  end;
  procedure ParserDB2;
  begin
    ParserString;
    User:=List.Values['User ID'];
    Database:=List.Values['Data Source'];
    DataSource:=List.Values['Location='];
    Password:=List.Values['Password'];
  end;
  procedure ParserOracle;
  begin
    ParserString;
    User:=List.Values['User ID'];
    Database:=List.Values['Data Source'];
    DataSource:=List.Values['Location='];
    Password:=List.Values['Password'];
  end;
begin
  if(FConnStr='')then Exit;
  List:=TStringList.Create;
  try
    case DbType of
      dbtAccess: ParserAccess;
      dbtSqlServer:ParserSqlServer;
      dbtOracle:ParserOracle;
      dbtInterbase:;
      dbtDB2:ParserDB2;
      dbtMySql:ParserMySql;
    end;
  finally
    List.Free;
  end;
end;

procedure TConnectStringBulider.SetConnectionString(const Value: string);
begin
  if ConnectionString<>Value then
    FConnStr:=Value;
    Parser;
end;

procedure TConnectStringBulider.SetDatabaseType(const Value: Integer);
begin
  if FDbType<>Value then
    FDbType := Value;
  Parser;
end;

procedure TConnectStringBulider.SetDataSource(const Value: string);
begin
  FDataSource := Value;
end;

{ TConnection }

function TConnection.BeginTrans: Integer;
begin
  Result:=Connect.BeginTrans;
end;

procedure TConnection.CommitTrans;
begin
  Connect.CommitTrans;
end;

constructor TConnection.Create;
begin
  inherited;
  Connect:=TADOConnection.Create(nil);
  Connect.LoginPrompt:=False;
  FInPoolStatus:=psNone;
  FActiveCount:=0;
end;

function TConnection.CreateCommand: TCommandStatement;
begin
  Result:=TCommandStatement.Create(nil);
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

function TConnection.CreateDataSet(const Sql: string): TDataSetStatement;
var
  rstData :TADODataSet ;
begin
  rstData:=TADODataSet.Create(nil);
  rstData.CommandText:=Sql;
  rstData.CommandTimeout:=CommandTimeOut;
  rstData.Connection:=Connect;
  rstData.Open;

  {Result:=TDataSetStatement.Create(nil);

  REsult.CommandText:=Sql;
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
  Result.Open;
  }
  ShowMessage(rstData.Fields[0].FieldName);
end;

function TConnection.CreateDataSet(CursorType: TCursorType;
  LockType: TAdoLockType): TDataSetStatement;
begin
  Result:=TDataSetStatement.Create(nil);
  Result.CursorType:=CursorType;
  Result.LockType:=LockType;
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

function TConnection.CreateDataSet: TDataSetStatement;
begin
  Result:=TDataSetStatement.Create(nil);
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;


function TConnection.CreateQuery(const Sql: string): TQueryStatement;
begin
  Result:=TQueryStatement.Create(nil);
  Result.EnableBCD:=FAlse;
  Result.SQL.Text:=Sql;
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

function TConnection.CreateQuery(CursorType: TCursorType;
  LockType: TAdoLockType): TQueryStatement;
begin
  Result:=TQueryStatement.Create(nil);
  Result.CursorType:=CursorType;
  Result.LockType:=LockType;
  Result.EnableBCD:=FAlse;
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

function TConnection.CreateQuery: TQueryStatement;
begin
  Result:=TQueryStatement.Create(nil);
  Result.EnableBCD:=FAlse;
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

function TConnection.CreateStoredproc: TStoredStatement;
begin
  Result:=TStoredStatement.Create(nil);
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

function TConnection.CreateTable: TTableStatement;
begin
  Result:=TTableStatement.Create(nil);
  Result.CommandTimeout:=CommandTimeOut;
  Result.Connection:=Connect;
end;

destructor TConnection.Destroy;
begin
  Connect.Free;
  if FProvider<>nil then
    FProvider:=nil;
  inherited;
end;

function TConnection.GetCommandTimeOut: Integer;
begin
  Result:=FCommandTimeOut;
end;

function TConnection.GetConnected: Boolean;
begin
  Result:=Connect.Connected;
end;

function TConnection.GetConnectTimeOut: Integer;
begin
  Result:=FConnectTimeOut;
end;

function TConnection.GetDbType: Integer;
begin
  Result:=FDBType;
end;

function TConnection.GetInTransaction: Boolean;
begin
  Result:=Connect.InTransaction;
end;

function TConnection.GetProvider: IConnectProvider;
begin
  case FDBType of
    dbtSqlServer:
    begin
      if FProvider=nil then
        FProvider:=TSQLServerProvider.Create;
      Result:=FProvider;
    end;
    else  Result:=nil;
  end;
end;

function TConnection.GoBackPool:Boolean;
begin
  Dec(FActiveCount);
  if FActiveCount=0 then
    Self.InPoolStatus:=psUnUse;
  Result:=(Self.InPoolStatus=psNone)or(Self.InPoolStatus=psUnUse);
end;

procedure TConnection.RollbackTrans;
begin
  Connect.RollbackTrans;
end;

procedure TConnection.SetCommandTimeOut(const Value: Integer);
begin
  FCommandTimeOut:=Value;
  Connect.CommandTimeout:=Value;
end;

procedure TConnection.SetConnected(const Value: Boolean);
begin
  Connect.Connected:=Value;
end;

procedure TConnection.SetConnectTimeOut(const Value: Integer);
begin
  FConnectTimeOut:=Value;
  Connect.ConnectionTimeout:=Value;
end;

procedure TConnection.UpdateCommandConnection(Command: TADOCommand);
begin
  Command.Connection:=Connect;
  Command.CommandTimeout:=CommandTimeOut;
end;

procedure TConnection.UpdateStatementConnection(DataSet: TCustomADODataSet);
begin
  DataSet.Connection:=Connect;
  if DataSet is TADOTable then
  begin
    TAdoTAble(DataSet).CommandTimeout:=CommandTimeOut;
  end else if DataSet is TADODataSet then
  begin
    TADODataSet(DataSet).CommandTimeout:=CommandTimeOut;
  end else if Dataset is TADOStoredProc then
  begin
    TADOStoredProc(DataSet).CommandTimeout:=CommandTimeOut;
  end else if DataSet is TADOQuery then
  begin
    TADOQuery(DataSet).CommandTimeout:=CommandTimeOut;
  end;
end;

{ TConnectionContext }

procedure TConnectionContext.Close(Connect: IConnection);
begin
  lock;
  try
    if Connect<>nil then
    begin
      if Connect.GoBackPool then
        ReleaseSemaphore(FHandle,1,nil);
    end;
  finally
    unLock;
  end;
end;

function TConnectionContext.ConnectName: string;
begin
  lock;
  try
    Result:=FConnectName;
  finally
    UnLock;
  end;
end;

function TConnectionContext.ConnectString: string;
begin
  lock;
  try
    Result:=ConnectBulider.ConnectionString;
  finally
    unlock;
  end;
end;

constructor TConnectionContext.Create;
begin
  inherited Create;
  FReleaseed:=False;
  FMinConnect:=1;
  FMaxConnect:=5;
  FConnectTimeOut:=15;
  FCommandTimeOut:=30;
  FLock:=TCriticalSection.Create;
  ConnectBulider:=TConnectStringBulider.Create;
  FConnections:=TConnectionFactorys.Create;
  FTimeOut:=500;
  FTimer:=TTimer.Create(nil);
  FTimer.Interval:=$CDFE600;{1小时}
  FTimer.OnTimer:=DoTimer;
end;

destructor TConnectionContext.Destroy;
begin
  FTimer.Free;
  if FHandle<>0 then
    CloseHandle(FHandle);
  PrepareFreeConnection;
  FLock.Free;
  Connections.Free;
  ConnectBulider.Free;
  inherited;
end;

procedure TConnectionContext.DoTimer(Sender: TObject);
var
  IdleCount,Index,ReleaseC:LongInt;
  Connect:TConnection;
  function GetIdleCount:Integer;
  var
    Conn:TConnection;
    Index:Integer;
  begin
    Result:=0;
    for Index:=0 to FConnections.Count-1 do
    begin
      Conn:=Connections[Index];
      if((Conn.InPoolStatus=psUnUse)or(Conn.InPoolStatus=psNone))and(Conn.Connected)then
        Inc(Result);
    end;
  end;
begin
  Lock;
  try
    FReleaseed:=True;
    try
      IdleCount:=GetIdleCount;
      if(IdleCount>=10)then
      begin
        try
          ReleaseC:=0;
          if(IdleCount mod 2 =0)then
          begin
            for Index:=FConnections.Count-1 downto 0 do
            begin
              if(ReleaseC=IdleCount-5)then Break;
              Connect:=FConnections.GetConnects(Index);
              if(Connect.InPoolStatus=psNone)or(Connect.InPoolStatus=psUnUse)then
              begin
                if Connect.Connected then
                begin
                  Connect.Connected:=False;
                  Inc(ReleaseC);
                end;
              end;
            end;
          end else
          begin
            for Index:=0 to FConnections.Count-1 do
            begin
              if(ReleaseC=IdleCount-5)then Break;
              Connect:=FConnections.GetConnects(Index);
              if(Connect.InPoolStatus=psNone)or(Connect.InPoolStatus=psUnUse)then
              begin
                if Connect.Connected then
                begin
                  Connect.Connected:=False;
                  Inc(ReleaseC);
                end;
              end;
            end;
          end;
        except
        end;
      end;
    finally
      FReleaseed:=False;
    end;
  finally
    UnLock;
  end;
end;

function TConnectionContext.GetConnection: IConnection;
const
  Search_Error=$0000000F;
  Connection_Error=$00000008;
  PoolCount_Error =$00000800;
  MaxPoolCount    =$00001388;
  AutoPoolStep    =$00000005;
var
  Conn:TConnection;
  FConnStr,ErrorMsg:string;
  Return:Cardinal;
  ErrorCode:LongInt;
  OldCount:LongInt;
  function CreateInstance:TConnection;
  begin
    CoInitialize(nil);
    Result:=TConnection.Create;
    Result.Connect.ConnectionString:=FConnStr;
    try
      Result.CommandTimeOut:=CommandTimeOut;
      Result.ConnectTimeOut:=ConnectTimeOut;
      REsult.FDBType:=ConnectBulider.DbType;
      Result.Connected:=True;
      Result.InPoolStatus:=psUse;
      Result.ActiveCount:=Result.ActiveCount+1;
    except
      on E:Exception do
      begin
        ErrorMsg:=e.Message ;
        ErrorCode:=Connection_Error;
        FreeAndNIl(Result);
      end;
    end;
  end;
begin
  Lock;
  try
    //while FReleaseed do ;
    ErrorCode:=0;
    Result:=nil;
    FConnStr:=ConnectString;
    Assert(FConnStr<>'','ConnectionString is null!');
    Conn:=Search;
    if (Conn<>nil)then
    begin
      try
        if not Conn.Connected then
        begin
          Conn.Connect.ConnectionString:=FConnStr;
          Conn.Connected:=True;
        end;
        Conn.InPoolStatus:=psUse;
        Conn.ActiveCount:=Conn.ActiveCount+1;
        Result:=Conn as IConnection;
      except
        on E:Exception do
        begin
          ErrorMsg:=e.Message ;
          ErrorCode:=Connection_Error;
        end;
      end;
    end else ErrorCode:=Search_Error;    
    {
    Return:=WaitForSingleObject(FHandle,FTimeOut);
    case Return of
      WAIT_FAILED,WAIT_ABANDONED,WAIT_TIMEOUT:
      begin
        Conn:=Search;
        if(Conn<>nil)then
        begin
          try
            if not Conn.Connected then
            begin
              Conn.Connect.ConnectionString:=FConnStr;
              Conn.Connected:=True;
            end;
            Conn.InPoolStatus:=psUse;
            Conn.ActiveCount:=Conn.ActiveCount+1;
            Result:=Conn as IConnection;
          except
            on E:Exception do
            begin
              ErrorCode:=Return;
            end;
          end;
        end else
          ErrorCode:=Return;
      end;
      WAIT_OBJECT_0:
      begin
        Conn:=Search;
        if (Conn<>nil)then
        begin
          try
            if not Conn.Connected then
            begin
              Conn.Connect.ConnectionString:=FConnStr;
              Conn.Connected:=True;
            end;
            Conn.InPoolStatus:=psUse;
            Conn.ActiveCount:=Conn.ActiveCount+1;
            Result:=Conn as IConnection;
          except
            on E:Exception do
            begin
              ErrorCode:=Connection_Error;
            end;
          end;
        end else ErrorCode:=Search_Error;
      end;
    end;
    }
    if(Result<>nil)then Exit;
    if(Connections.Count<MaxConnect)then
    begin
      Conn:=CreateInstance;
      if Conn<>nil then
      begin
        Connections.Add(Conn);
        Result:=Conn as IConnection;
        Result._AddRef;
      end;
    end else ErrorCode:=PoolCount_Error;
    if Result=nil then
    begin
      case ErrorCode of
        Connection_Error:;
        PoolCount_Error,Search_Error,WAIT_FAILED,WAIT_ABANDONED,WAIT_TIMEOUT:
        begin
          if(FMaxConnect<MaxPoolCount)then
          begin
            CloseHandle(FHandle);
            OldCount:=GetUnUseCount+AutoPoolStep;
            FMaxConnect:=FMaxConnect+AutoPoolStep;
            FHandle:=CreateSemaphore(nil,OldCount,FMaxConnect,nil);
            Conn:=CreateInstance;
            if Conn<>nil then
            begin
              Connections.Add(Conn);
              Result:=Conn as IConnection;
              Result._AddRef;
            end;
          end;
        end;
      end;
    end;
  finally
    UnLock;
  end;
end;

function TConnectionContext.GetUnUseCount: Integer;
var
  Conn:TConnection;
  Index:Integer;
begin
  Result:=0;
  for Index:=0 to FConnections.Count-1 do
  begin
    Conn:=Connections[Index];
    if(Conn.InPoolStatus=psUnUse)or(Conn.InPoolStatus=psNone)then
      Inc(Result);
  end;
end;

procedure TConnectionContext.Initialize(UniqueName: string;
  const ConnectionStr: string; const DBType, MinConnection,
  MaxConnection,CommandTimeOut,ConnectTimeOut:Integer);
begin
  FConnectName:=UniqueName;
  ConnectBulider.ConnectionString:=ConnectionStr;
  ConnectBulider.DbType:=DBType;
  if MinConnection>0 then
    FMinConnect:=MinConnection;
  if MaxConnection>0then
    FMaxConnect:=MaxConnection;
  Self.CommandTimeOut:=CommandTimeOut;
  Self.ConnectTimeOut:=ConnectTimeOut;
  FHandle:=CreateSemaphore(nil,FMaxConnect,MaxConnection,PChar(UniqueName));
end;

procedure TConnectionContext.Lock;
begin
  FLock.Enter;
end;

procedure TConnectionContext.PrepareFreeConnection;
var
  I:Integer;
begin
  for I:=0 to Connections.Count-1 do
    Connections[I]._Release;
end;

function TConnectionContext.Search(const NuUse:Boolean=False): TConnection;
var
  Conn:TConnection;
  Index:Integer;
begin
  Result:=nil;
  for Index:=0 to FConnections.Count-1 do
  begin
    Conn:=Connections[Index];
    if(Conn.InPoolStatus=psUnUse)or(Conn.InPoolStatus=psNone)then
    begin
      Result:=Conn;
      Exit;
    end;
  end;
  if Result=nil then
  begin
    for Index:=0 to FConnections.Count-1 do
    begin
      Conn:=Connections[Index];
      if not Conn.InTransaction then
      begin
        Result:=Conn;
        Exit;
      end;
    end;
  end;
end;

procedure TConnectionContext.UnLock;
begin
  FLock.Leave;
end;

{ TConnectionContextManager }

constructor TConnectionContextManager.Create;
begin
  inherited ;
  FConnectContexts:=TInterfaceList.Create;
  FLock:=TCriticalSection.Create;  
end;

destructor TConnectionContextManager.Destroy;
begin
  FConnectContexts.Free;
  FLock.Free;
  inherited;
end;

function TConnectionContextManager.Find(
  const ConnectName: string): IConnectionContext;
var
  Context:IConnectionContext;
  I:Integer;
begin
  Lock;
  try
    for I:=0 to ConnectContexts.Count -1 do
    begin
      Context:=ConnectContexts[I] as IConnectionContext;
      if SameText(ConnectName,Context.ConnectName)then
      begin
        Result:=Context;
        Exit;
      end;
    end;
    Result:=nil;
  finally
    UnLock;
  end;
end;

function TConnectionContextManager.GetConnectionContext(
  ConnectName: string): IConnectionContext;
begin
  Result:=Find(ConnectName);
end;

procedure TConnectionContextManager.Lock;
begin
  FLock.Enter;
end;

procedure TConnectionContextManager.RegisterConnectionContext(
  const ConnectName, ConnectionStr: string; const DBType, MinConnection,
  MaxConnection,CommandTimeOut,ConnectTimeOut:Integer);
var
  Context:TConnectionContext;
begin
  Lock;
  try
    if Find(ConnectName)<>nil then Exit;
    Context:=TConnectionContext.Create;
    Context.Initialize(
      ConnectName,
      ConnectionStr,
      DBType,
      MinConnection,
      MaxConnection,
      CommandTimeOut,
      ConnectTimeOut);
    ConnectContexts.Add(Context as IConnectionContext);
  finally
    UnLock;
  end;
end;


procedure TConnectionContextManager.UnLock;
begin
  FLock.Leave;
end;

procedure TConnectionContextManager.UnRegisterAllConnectionContext;
begin
  Lock;
  try
    FConnectContexts.Clear;
  finally
    UnLock;
  end;
end;

procedure TConnectionContextManager.UnRegisterConnectionContext(
  const ConnectName: string);
var
  Context:IConnectionContext;
begin
  Lock;
  try
    Context:=Find(ConnectName);
    if Context <> nil then
      ConnectContexts.Remove(Context);
  finally
    UnLock;
  end;
end;

{ TConnectionFactorys }

function TConnectionFactorys.Add(Conn: TConnection): Integer;
begin
  Result:=FList.Add(Conn);
end;

constructor TConnectionFactorys.Create;
begin
  inherited Create;
  FList:=TObjectList.Create(FAlse);
end;

destructor TConnectionFactorys.Destroy;
begin
  FList.Free;
  inherited;
end;

function TConnectionFactorys.GetConnects(Index: Integer): TConnection;
begin
  Result:=TConnection(list.Items[Index]);
end;

function TConnectionFactorys.Getcount: Integer;
begin
  Result:=FList.Count;
end;



initialization
  ConnectionContextMgr;
finalization
  //if ContextMgr<>nil then
    //ContextMgr:=nil;
end.
