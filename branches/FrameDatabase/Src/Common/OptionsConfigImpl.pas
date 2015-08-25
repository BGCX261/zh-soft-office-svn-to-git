unit OptionsConfigImpl;

interface

uses Classes,Windows,SysUtils,AdoDb,Forms,Registry,ActiveX,DB,WinSock;

type
  EUnSupportException=class(Exception);
  TFTPUseMode=(umWindow,umFTP);
  TTransmitStyle=(tsFTP,tsDTS);
  TTransmitStyles=set of TTransmitStyle;

  TConnectStringBulider=class(TPersistent)
  private
    FUser: string;
    FPassword: string;
    FDatabase: string;
    FDataSource: string;
    FDbType: Integer;
    FConnStr:string;
    FInterfaceDatabase: string;
    FInterfacePath: string;
    FInterfaceMappingPath: string;
    FLocalImportPath: string;
    FCommandTimeOut: integer;
    FLocalExportPath: string;
    function GetConnectionString: string;
    function GetWorkStation: string;
    procedure SetConnectionString(const Value: string);
    procedure SetDatabaseType(const Value: Integer);
    function GetDBMSDescription: string;
    function GetDBMSID: string;
    procedure SetDataSource(const Value: string);
    function GetDatabase: string;
    function GetConnectName: string;
    function GetInterfaceDatabase: string;
  protected
    procedure Parser;
  public
    procedure Assign(Source: TPersistent);override;
    property User:string read FUser write FUser;
    property Password:string read FPassword write FPassword;
    property Database:string read GetDatabase write FDatabase;
    property InterfaceDatabase:string read GetInterfaceDatabase write FInterfaceDatabase;
    property CommandTimeOut:integer read FCommandTimeOut  write FCommandTimeOut;
    
    //本地导入文件
    property LocalImportPath:string read FLocalImportPath write FLocalImportPath;
    property LocalExportPath:string read FLocalExportPath write FLocalExportPath;


    property InterfacePath:string read FInterfacePath write FInterfacePath;
    property InterfaceMappingPath:string read fInterfaceMappingPath write FInterfaceMappingPath;
    property DataSource:string read FDataSource write SetDataSource;
    property DbType:Integer read FDbType write SetDatabaseType;
    property WorkStation:string read GetWorkStation;
    property ConnectionString:string read GetConnectionString write SetConnectionString;
    property DBMSID:string read GetDBMSID;
    property DBMSDescription:string read GetDBMSDescription;
    property ConnectName:string read GetConnectName;
  end;
    
  TFTPConfigOption=class(TComponent)
  private
    FRetry: Integer;
    FPort: Integer;
    FTimeOut: Integer;
    FProxyPort: Integer;
    FPassword: string;
    FHost: string;
    FUser: string;
    FProxyServer: string;
    FRootDir: string;
    FZipPassword: String;
    FUseMode: TFTPUseMode;
    function GetPort: Integer;
    function GetTimeOut: Integer;
  public
    procedure Assign(Source: TPersistent);override;
    destructor Destroy;override;
    property RootDir:string read FRootDir write FRootDir;
    property User:string read FUser write FUser;
    property Password:string read FPassword write FPassword;
    property Host:string read FHost write FHost;
    property Port:Integer read GetPort write FPort;
    property Retry:Integer read FRetry write FRetry;
    property TimeOut:Integer read GetTimeOut write FTimeOut;
    property ProxyServer:string read FProxyServer write FProxyServer;
    property ProxyPort:Integer read FProxyPort write FProxyPort;
    property UseMode:TFTPUseMode read FUseMode write FUseMode;
    property ZipPassword:String read FZipPassword write FZipPassword;
  end;

  TDataProcessOption=class(TComponent)
  private
    FAutoReveive: Boolean;
    FAutoSend: Boolean;
    FSendFrequency: Integer;
    FReveiveFrquency: Integer;
    FTriggerFileDir: String;
    FFileLogDir: String;
    FDefaultTrigger: String;
    FProcedureFileDir: String;
    FDefaultProcedure: String;
    FTransmitStyles: TTransmitStyles;
    function GetAutoReveive: Boolean;
    function GetAutoSend: Boolean;
    function GetReveiveFrquency: Integer;
    function GetSendFrequency: Integer;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent);override;
    property AutoSend:Boolean read GetAutoSend write FAutoSend;
    property SendFrequency:Integer read GetSendFrequency write FSendFrequency;
    property AutoReveive:Boolean read GetAutoReveive write FAutoReveive;
    property ReveiveFrquency:Integer read GetReveiveFrquency write FReveiveFrquency;
    property FileLogDir:String read FFileLogDir write FFileLogDir;
    property DefaultTrigger:String read FDefaultTrigger write FDefaultTrigger;
    property TriggerFileDir:String read FTriggerFileDir write FTriggerFileDir;
    property DefaultProcedure:String read FDefaultProcedure write FDefaultProcedure;
    property ProcedureFileDir:String read FProcedureFileDir write FProcedureFileDir;
    property TransmitStyles:TTransmitStyles read FTransmitStyles write FTransmitStyles;
  end;

  TServerConfigOption=class(TComponent)
  private
    FIsCompress: Boolean;
    FListenQueue: Integer;
    FTerminateWaitTime: Longint;
    FPort: Longint;
    FIPAdress: String;
    FSvrGuid: string;
    FConnectMode: integer;
  public
    constructor Create(AOwner:TComponent);override;
    procedure Assign(Source: TPersistent);override;
    property IsCompress:Boolean read FIsCompress write FIsCompress;
    property Port:Longint read FPort write FPort;
    property IPAdress:String read FIPAdress write FIPAdress;
    property ListenQueue:Integer read FListenQueue write FListenQueue;
    property SvrGuid:string read FSvrGuid write FSvrGuid ;
    property ConnectMode:integer read FConnectMode write FConnectMode;
    property TerminateWaitTime:Longint read FTerminateWaitTime write FTerminateWaitTime;
  end;

  TConfigSettings=class(TComponent)
  private
    FConnStrBulider: TConnectStringBulider;
    FFTPOption: TFTPConfigOption;
    FProcessOption: TDataProcessOption;
    FServerOption: TServerConfigOption;
    FStoreId: string;
    FOnline: Boolean;

    function GetFileName: string;
    function GetStoreId: string;
    function GetFTPOption: TFTPConfigOption;
    function GetProcessOption: TDataProcessOption;
    function GetServerOption: TServerConfigOption;
    function GetConnStrBulider: TConnectStringBulider;
  protected
    function ConvertTransmitStylesSetToInteger(AStyles:TTransmitStyles):Integer;
    function ConvertIntegerToTransmitStyles(Value:Integer):TTransmitStyles;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure LoadFromStream;
    procedure SaveToStream;
    property ConnStrBulider:TConnectStringBulider read GetConnStrBulider;
    property FTPOption:TFTPConfigOption read GetFTPOption ;
    property ProcessOption:TDataProcessOption read GetProcessOption ;
    property ServerOption:TServerConfigOption read GetServerOption ;
    property StoreId:string read GetStoreId write FStoreId;
    property Online:Boolean read FOnline write FOnline;
    property FileName:string read GetFileName;
        

  end;

    TRemoteServerConfig=class(TCollectionItem)
  private
    FServerId: string;
    FFTPOption: TFTPConfigOption;
    FServerOption: TServerConfigOption;
    FServerName: string;
    procedure SetFTPOption(const Value: TFTPConfigOption);
    procedure SetServerOption(const Value: TServerConfigOption);
  protected
  public
    constructor Create(Collection: TCollection);override;
    destructor Destroy;override;
    property FTPOption:TFTPConfigOption read FFTPOption write SetFTPOption;
    property ServerOption:TServerConfigOption read FServerOption write SetServerOption;
    property ServerId:string read FServerId write FServerId;
    property ServerName:string read FServerName write FServerName;
  end;
  
  TRemoteServerConfigItems=class(TCollection)
  private
    function GetItems(Index: Integer): TRemoteServerConfig;
  public
    constructor Create;
    procedure Fill(ADataSet:TDataSet);
    function Add:TRemoteServerConfig;
    property Items[Index:Integer]:TRemoteServerConfig read GetItems;default;
  end;


implementation
uses IniFiles,ShareLib;


const
  dbtAccess = $00000000;
  dbtSqlServer = $00000001;
  dbtOracle = $00000002;
  dbtInterbase = $00000003;
  dbtDb2 = $00000004;
  dbtMySql = $00000005;
  dbtMsOdbcSql = $00000006;
  
  {DBMS_ID}
  SQLSERVER_DBMS_ID ='SqlServer';
  ACCESS_DBMS_ID    ='Access';
  ORACLE_DBMS_ID    ='Oracle';
  INTERBASE_DBMS_ID ='Interbase';
  DB2_DBMS_ID       ='Db2';
  MYSQL_DBMS_ID     ='MySql';
  MSODBC_DBMS_ID     ='MsOdbc';
const
  ServerConfigFileName='ServerConfig.Ini';
  DBConnectSection           ='DBConfig';
  DBConnectUserIdent         ='User';
  DBConnectPasswordIdent     ='Password';
  DBConnectDatabaseIdent     ='Database';
  DBConnectDataSourceIdent   ='DataSource';
  DBConnectDbTypeIdent       ='DbType';
  DBConnectInterfaceDatabaseIdent     ='InterfaceDatabase';
  DBConnectInterfacePath     ='InterfacePath';
  DBConnectInterfaceMappingPath     ='InterfaceMappingPath';
  DBConnectLocalImportPath     ='LocalImportPath';
  DBConnectLocalExportPath     ='LocalExportPath';  


  DBConnectCommandTimeOut='CommandTimeOut';
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
  MSDASQLConnection='Provider=MSDASQL.1;Password=%s;Persist Security Info=True;User ID=%s;Data Source=%s';      
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
    dbtMsOdbcSql:Result:=Format(MSDASQLConnection,[Password,User,DataSource]);
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

function TConnectStringBulider.GetInterfaceDatabase: string;
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
  end else Result := FInterfaceDatabase;  
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





{ TMQConfigEnvironment }

function TConfigSettings.ConvertIntegerToTransmitStyles(
  Value: Integer): TTransmitStyles;
begin
  case Value of
    1:Result:=[tsDTS];
    2:Result:=[tsFTP];
    3:Result:=[tsFTP,tsDTS];
    else Result:=[];
  end;
end;

function TConfigSettings.ConvertTransmitStylesSetToInteger(
  AStyles: TTransmitStyles): Integer;
begin
  if AStyles=[tsFTP,tsDTS]then
  begin
    Result:=3;
  end else if AStyles=[tsFTP]then
  begin
    Result:=2;
  end else if AStyles=[tsDTS]then
  begin
    REsult:=1;
  end else Result:=0;
end;

constructor TConfigSettings.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnStrBulider:=TConnectStringBulider.Create;
  FConnStrBulider.DbType:=dbtSqlServer;
  FFTPOption:=TFTPConfigOption.Create(AOwner);
  FProcessOption:=TDataProcessOption.Create(AOwner);
  FServerOption:=TServerConfigOption.Create(AOwner) ;
  FOnline:=True;
end;

destructor TConfigSettings.Destroy;
begin
  //FConnStrBulider.Free;
  inherited;
end;


function TConfigSettings.GetConnStrBulider: TConnectStringBulider;
begin
  result:=FConnStrBulider ;
end;

function TConfigSettings.GetFileName: string;
begin
  Result:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+ServerConfigFileName;
end;


function TConfigSettings.GetFTPOption: TFTPConfigOption;
begin
  result:=FFTPOption ;
end;

function TConfigSettings.GetProcessOption: TDataProcessOption;
begin
  result:=FProcessOption ;
end;

function TConfigSettings.GetServerOption: TServerConfigOption;
begin
  result:=FServerOption ;
end;

function TConfigSettings.GetStoreId: string;
const
  StoreKey='\SOFTWARE\Remote\Session';
var
  Buffer,strCash:string;
  function ReadDatabaseStoreCode(AStoreId:string):string;
  var
    Conn:TADOConnection;
  begin
    REsult:=EmptyStr;
    CoInitialize(nil) ;
    try
      Conn:=TADOConnection.Create(nil);
    except
      exit ;
    end ;
    try
      try
        Conn.LoginPrompt:=False;
        Conn.ConnectionString:=ConnStrBulider.ConnectionString;
        Conn.Connected:=True;
        with TADOQuery.Create(nil) do
        try
          Connection:=Conn;
          Sql.Text:=Format('select store_code from store where store_code_id=%s',[AStoreId]);
          Active:=True;
          if not IsEmpty then
            Result:=FieldByName('store_code').AsString;
        finally
          Free;
        end;
      except
        on E:Exception do
        begin
        end;
      end;
    finally
      Conn.Free;
    end;
    if REsult=EmptyStr then
      Result:=AStoreId;
  end;
begin
  Buffer:=EmptyStr ;
  if FStoreId<>EmptyStr then
  begin
    Result:=FStoreId;
  end else
  begin
    with TRegistry.Create do
    try
      Buffer:=EmptyStr;
      RootKey:=HKEY_LOCAL_MACHINE;
      if KeyExists(StoreKey)then
      begin
        if OpenKey(StoreKey,False)then
        begin
          Buffer:=ReadString('Code');
          strCash :=ReadString('Cash');
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
    if Buffer<>EmptyStr then
    begin
      FStoreId:=Buffer ;
      if (Trim(strCash)<>'') and (Uppercase(Trim(strCash))<>'NULL') and (Trim(strCash)<>'1') then
      begin
        FStoreId:=Buffer+'_'+strCash ;
      end ;
    end ;
    Result:=Buffer ;
    //Result:=ReadDatabaseStoreCode(Buffer);
  end;
  
end;

procedure TConfigSettings.LoadFromStream;
var
  SuperIni:TIniFile;
begin
  if FileExists(FileName)then
  begin
    SuperIni:=TIniFile.Create(FileName);
    try
      //Summary:
      // 总部数据库连接配置
      ConnStrBulider.User:=SuperIni.ReadString(DBConnectSection,DBConnectUserIdent,EmptyStr);
      //ConnStrBulider.Password:=DecodeString(SuperIni.ReadString(DBConnectSection,DBConnectPasswordIdent,EmptyStr));
      ConnStrBulider.Password:=SuperIni.ReadString(DBConnectSection,DBConnectPasswordIdent,EmptyStr);
      ConnStrBulider.Database:=SuperIni.ReadString(DBConnectSection,DBConnectDatabaseIdent,EmptyStr);
      ConnStrBulider.DataSource:=SuperIni.ReadString(DBConnectSection,DBConnectDataSourceIdent,EmptyStr);
      ConnStrBulider.DbType:=SuperIni.ReadInteger(DBConnectSection,DBConnectDbTypeIdent,1);
      ConnStrBulider.InterfaceDatabase:=SuperIni.ReadString(DBConnectSection,DBConnectInterfaceDatabaseIdent,EmptyStr);
      ConnStrBulider.InterfacePath:=SuperIni.ReadString(DBConnectSection,DBConnectInterfacePath,EmptyStr);
      ConnStrBulider.InterfaceMappingPath:=SuperIni.ReadString(DBConnectSection,DBConnectInterfaceMappingPath,EmptyStr);
      ConnStrBulider.LocalImportPath :=SuperIni.ReadString(DBConnectSection,DBConnectLocalImportPath,EmptyStr);
      ConnStrBulider.LocalExportPath :=SuperIni.ReadString(DBConnectSection,DBConnectLocalExportPath,EmptyStr);

      ConnStrBulider.CommandTimeOut:=SuperIni.ReadInteger(DBConnectSection,DBConnectCommandTimeOut,120);
    finally
      SuperIni.Free;
    end;
  end;

end;


procedure TConfigSettings.SaveToStream;
var
  SuperIni:TIniFile;
begin
  SuperIni:=TIniFile.Create(FileName);
  try
    //Summary:
    // 总部数据库连接配置

    SuperIni.WriteString(DBConnectSection,DBConnectUserIdent,ConnStrBulider.User);
    SuperIni.WriteString(DBConnectSection,DBConnectPasswordIdent,EncodeString(ConnStrBulider.Password));
    SuperIni.WriteString(DBConnectSection,DBConnectDatabaseIdent,ConnStrBulider.Database);
    SuperIni.WriteString(DBConnectSection,DBConnectDataSourceIdent,ConnStrBulider.DataSource);
    SuperIni.WriteInteger(DBConnectSection,DBConnectDbTypeIdent,Integer(ConnStrBulider.DbType));

    SuperIni.WriteInteger(DBConnectSection,DBConnectCommandTimeOut,Integer(ConnStrBulider.CommandTimeOut));

    SuperIni.WriteString(DBConnectSection,DBConnectLocalImportPath,ConnStrBulider.LocalImportPath);
    SuperIni.WriteString(DBConnectSection,DBConnectLocalExportPath,ConnStrBulider.LocalExportPath);
    
    SuperIni.WriteString(DBConnectSection,DBConnectInterfaceDatabaseIdent,ConnStrBulider.InterfaceDatabase);
    SuperIni.WriteString(DBConnectSection,DBConnectInterfacePath,ConnStrBulider.InterfacePath);
    SuperIni.WriteString(DBConnectSection,DBConnectInterfaceMappingPath,ConnStrBulider.InterfaceMappingPath);
  finally
    SuperIni.Free;
  end;
end;

{ TFTPConfigOption }

procedure TFTPConfigOption.Assign(Source: TPersistent);
begin
  if Source is TFTPConfigOption then
  begin
    RootDir:=TFTPConfigOption(Source).RootDir;
    User:=TFTPConfigOption(Source).User;
    Password:=TFTPConfigOption(Source).Password;
    Host:=TFTPConfigOption(Source).Host;
    Port:=TFTPConfigOption(Source).Port;
    Retry:=TFTPConfigOption(Source).Retry;
    TimeOut:=TFTPConfigOption(Source).TimeOut;
    ProxyServer:=TFTPConfigOption(Source).ProxyServer;
    ProxyPort:=TFTPConfigOption(Source).ProxyPort;
    UseMode:=TFTPConfigOption(Source).UseMode;
    ZipPassword:=TFTPConfigOption(Source).ZipPassword;
  end;
end;

destructor TFTPConfigOption.Destroy;
begin
  inherited;
end;

function TFTPConfigOption.GetPort: Integer;
begin
  if FPort<=0 then
    FPort:=21;
  Result := FPort;
end;

function TFTPConfigOption.GetTimeOut: Integer;
begin
  if FTimeOut<0 then
    FTimeOut:=30000;
  Result := FTimeOut;
end;

{ TDataProcessOption }

procedure TDataProcessOption.Assign(Source: TPersistent);
begin
  if Source is TDataProcessOption then
  begin
    AutoSend:=TDataProcessOption(Source).AutoSend;
    SendFrequency:=TDataProcessOption(Source).SendFrequency;
    AutoReveive:=TDataProcessOption(Source).AutoReveive;
    ReveiveFrquency:=TDataProcessOption(Source).ReveiveFrquency;
    FileLogDir:=TDataProcessOption(Source).FileLogDir;
    DefaultTrigger:=TDataProcessOption(Source).DefaultTrigger;
    TriggerFileDir:=TDataProcessOption(Source).TriggerFileDir;
    DefaultProcedure:=TDataProcessOption(Source).DefaultProcedure;
    ProcedureFileDir:=TDataProcessOption(Source).ProcedureFileDir;
    TransmitStyles:=TDataProcessOption(Source).TransmitStyles;

  end;
end;

constructor TDataProcessOption.Create(AOwner:TComponent);
begin
  inherited Create(Aowner);
  TransmitStyles:=[tsFTP];
end;

destructor TDataProcessOption.Destroy;
begin

  inherited;
end;

function TDataProcessOption.GetAutoReveive: Boolean;
begin
  Result := FAutoReveive and (ReveiveFrquency>0);
end;

function TDataProcessOption.GetAutoSend: Boolean;
begin
  Result := FAutoSend and(SendFrequency>0);
end;

function TDataProcessOption.GetReveiveFrquency: Integer;
begin
  Result := FReveiveFrquency;
  if FReveiveFrquency<=0 then
    Result:=30;
end;

function TDataProcessOption.GetSendFrequency: Integer;
begin
  Result := FSendFrequency;
  if FSendFrequency<=0 then
    Result:=30;
end;

{ TServerConfigOption }

procedure TServerConfigOption.Assign(Source: TPersistent);
begin
  if Source is TServerConfigOption then
  begin
    FTerminateWaitTime:=TServerConfigOption(Source).TerminateWaitTime;
    FPort:=TServerConfigOption(Source).Port;
    FIsCompress:=TServerConfigOption(Source).IsCompress;
    FListenQueue:=TServerConfigOption(Source).ListenQueue;
    FIPAdress:=TServerConfigOption(Source).IPAdress;
    FSvrGuid:=TServerConfigOption(Source).SvrGuid;
    FConnectMode:=TServerConfigOption(Source).ConnectMode;
  end;
end;

constructor TServerConfigOption.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FTerminateWaitTime:=5000;
  FPort:=211;
  FIsCompress:=False;
  FListenQueue:=15;
  FIPAdress:='127.0.0.1';
end;

{ TRemoteServerConfig }


constructor TRemoteServerConfig.Create(Collection: TCollection);
begin
  inherited;
  FFTPOption:= TFTPConfigOption.Create(nil);
  FServerOption:= TServerConfigOption.Create(nil);
end;

destructor TRemoteServerConfig.Destroy;
begin
  FFTPOption.Free ;
  FServerOption.Free ;
  inherited;
end;

procedure TRemoteServerConfig.SetFTPOption(const Value: TFTPConfigOption);
begin
  FFTPOption.Assign(Value) ; 
end;

procedure TRemoteServerConfig.SetServerOption(
  const Value: TServerConfigOption);
begin
  FServerOption.Assign(Value) ; 
end;

{ TRemoteServerConfigItems }

function TRemoteServerConfigItems.Add: TRemoteServerConfig;
begin
  Result:=TRemoteServerConfig(inherited Add);
end;

constructor TRemoteServerConfigItems.Create;
begin
  inherited Create(TRemoteServerConfig);  
end;

procedure TRemoteServerConfigItems.Fill(ADataSet: TDataSet);
var
  Item:TRemoteServerConfig;
begin
  ADataSet.First;
  while not ADataSet.Eof do
  begin
    Item:=Add;
    Item.ServerId :=ADataSet.FieldByName('SERVERID').AsString;
    Item.ServerName :=ADataSet.FieldByName('SERVERNAME').AsString;
        
    Item.ServerOption.IPAdress :=ADataSet.FieldByName('SEV_HOST').AsString;
    Item.ServerOption.Port :=ADataSet.FieldByName('SEV_PORT').AsInteger;
    Item.ServerOption.SvrGuid :=ADataSet.FieldByName('SEV_GUID').AsString;
    Item.ServerOption.ConnectMode :=ADataSet.FieldByName('SEV_CONNECTMODE').AsInteger;

    Item.FTPOption.RootDir :=ADataSet.FieldByName('FTP_ROOT').AsString;
    Item.FTPOption.Host :=ADataSet.FieldByName('FTP_HOST').AsString;
    Item.FTPOption.Port :=ADataSet.FieldByName('FTP_PORT').AsInteger;
    Item.FTPOption.User :=ADataSet.FieldByName('FTP_USER').AsString;
    Item.FTPOption.Password :=DecodeString(ADataSet.FieldByName('FTP_PASSWORD').AsString);
    Item.FTPOption.Retry :=ADataSet.FieldByName('FTP_RETRY').AsInteger;
    Item.FTPOption.TimeOut :=ADataSet.FieldByName('FTP_RETRY').AsInteger;
    Item.FTPOption.ProxyServer :=ADataSet.FieldByName('FTP_PROXYHOST').AsString;
    Item.FTPOption.ProxyPort   :=ADataSet.FieldByName('FTP_PROXYPORT').AsInteger;

    ADataSet.Next;
  end;      
end;

function TRemoteServerConfigItems.GetItems(
  Index: Integer): TRemoteServerConfig;
begin
  Result:=TRemoteServerConfig(inherited Items[Index]);
end;

end.
