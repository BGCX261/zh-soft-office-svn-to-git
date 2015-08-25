unit EnvironmentImpl;

interface

uses Classes,SysUtils,DataAccess,OptionsConfigImpl,
  DBClient,MConnect,DataAccessInt;//DataAccessImpl


const
  ConnectionDatabaseName='DBConnection';
type
  TRuntimeEnvironmentImpl=class(TComponent)
  private
    FRuned:Boolean;
    FConnectionContext: IConnectionContext;
    FConfigSettings:TConfigSettings;
    //FDataAccess:IDataAccessInt;

    function GetRuned: Boolean;
    function GetConfigSettings: TConfigSettings;

  protected
    procedure InitializeAdoContext;
    function GetDataAccess: IDataAccessInt;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    function TryConnectDatabase:Boolean;
    function JudgeDBConnection(var JudgeResult:string):Boolean;
    function JudgeConfigSettings(IsServer:Boolean;var JudgeResult:string):Boolean;
    procedure InitializeEnvironment;
    procedure Startup;
    procedure Stop;
    property Runed:Boolean read GetRuned;
    property ConnectionContext:IConnectionContext read FConnectionContext;
    property DataAccess:IDataAccessInt read GetDataAccess;
    property ConfigSettings:TConfigSettings read GetConfigSettings;
  end;


function _Environment:TRuntimeEnvironmentImpl;
implementation

uses Forms,SConnect,Adodb,db,ActiveX,ComObj,Math,FrameCommon,DataMainImpl,
  DataAccessImpl,FrameDataAccessImpl;

var
  Environment:TRuntimeEnvironmentImpl=nil;

function _Environment:TRuntimeEnvironmentImpl;
begin
  if Environment=nil then
    Environment:=TRuntimeEnvironmentImpl.Create(nil);
  Result:=Environment;
end;

{ TRuntimeEnvironmentImpl }

constructor TRuntimeEnvironmentImpl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfigSettings:=TConfigSettings.Create(AOwner);
  FConfigSettings.LoadFromStream;
end;

destructor TRuntimeEnvironmentImpl.Destroy;
begin
  //FRemoteAdapter:=nil ;
  Freeandnil(FConfigSettings) ;
  //Freeandnil(FConnectionContext);

  //Freeandnil(FDataAccess) ;
  inherited;
end;


function TRuntimeEnvironmentImpl.GetConfigSettings: TConfigSettings;
begin
  Result:=FConfigSettings;
end;


function TRuntimeEnvironmentImpl.GetDataAccess: IDataAccessInt;
begin

//  if FDataAccess=nil then
//  begin
//    //Result:=DataAccessFactory.GetDataAccessInt(LocalNetAccessTypeName);
//    Result.Initialize;
//  end;
//
//  Result:=DataMain as IDataAccessInt ;
//  Result:=FDataAccess;
  result:=DataMain as IDataAccessInt;
end;

function TRuntimeEnvironmentImpl.GetRuned: Boolean;
begin
  Result:=FRuned;
end;

procedure TRuntimeEnvironmentImpl.InitializeAdoContext;
begin
  with ConfigSettings.ConnStrBulider do
  begin
    ConnectionContextMgr.UnRegisterAllConnectionContext;
    ConnectionContextMgr.RegisterConnectionContext(ConnectionDatabaseName,ConnectionString,dbtSqlServer,1,10,CommandTimeOut*1000);
    FConnectionContext:=ConnectionContextMgr.GetConnectionContext(ConnectionDatabaseName);
  end;

end;

procedure TRuntimeEnvironmentImpl.InitializeEnvironment;
begin
  InitializeAdoContext;

end;



function TRuntimeEnvironmentImpl.JudgeConfigSettings(IsServer: Boolean;
  var JudgeResult: string): Boolean;
begin
  Result:=JudgeDBConnection(JudgeResult);
end;

function TRuntimeEnvironmentImpl.JudgeDBConnection(
  var JudgeResult: string): Boolean;
var
  Connect:TADOConnection;
begin
  CoInitialize(nil);
  Connect:=TADOConnection.Create(nil);
  try
    Connect.LoginPrompt:=False;
    Connect.ConnectionString:=ConfigSettings.ConnStrBulider.ConnectionString;
    try
      Connect.Connected:=True;
      Result:=Connect.Connected;
    except
      on E:Exception do
      begin
        JudgeResult:='数据库连接错误.具体原因:'+E.Message;
        Result:=False;
      end;
    end;
  finally
    Connect.Free;
  end;
end;



procedure TRuntimeEnvironmentImpl.Startup;
begin
  FRuned:=True;
end;

procedure TRuntimeEnvironmentImpl.Stop;
begin
  FRuned:=False;
end;

function TRuntimeEnvironmentImpl.TryConnectDatabase: Boolean;
var
  Connect:TADOConnection;
begin
  begin
    CoInitialize(nil);
    Connect:=TADOConnection.Create(nil);
    try
      Connect.LoginPrompt:=False;
      Connect.ConnectionString:=ConfigSettings.ConnStrBulider.ConnectionString;
      try
        Connect.Connected:=True;
        Result:=Connect.Connected;
      except
        on E:Exception do
        begin
          Result:=False;
        end;
      end;
    finally
      Connect.Free;
    end;
  end;
end;

initialization
  _Environment;
finalization
  if Environment<>nil then
    //Environment=nil;
    FreeAndNil(Environment);
end.
