unit DataMainBaseImpl;

interface

uses
  SysUtils, Classes, Provider, DB, DBClient,Variants, ADODB,DataAccess,
  DataAccessInt,MarshalImpl;
const
  CommonDataSetProviderName='PubDataSetProvider';
type
  TDataMainBase = class(TDataModule,IDataAccessInt)
    PubDataSet: TClientDataSet;
    PubDataSetProvider: TDataSetProvider;
    PubQuery: TADOQuery;
    SaveDataSetProvider: TDataSetProvider;
    SaveDataSet: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure SaveDataSetProviderUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    { Private declarations }
    FLastError:string;
  protected
    { protected declarations }
    procedure InitializeAdoContext;
    procedure InitializeService;
    function LastError:string;
    function TryConnecting:Boolean;overload;
    function TryConnecting(Config:TPersistent):Boolean;overload;
    function ExecuteRequest(ARequest:TCustomClientRequest;var AReply:TCustomServerReply):Boolean;overload;
    function ExecuteRequest(ARequest:TCustomClientRequest;var AReply:TCustomServerReply;var ADataSet:TClientDataSet):Boolean;overload;

    procedure Initialize;virtual;   
  public
    { Public declarations }

    function SelectSql(const ASelectSql:string;var ADataSet:TClientDataSet):Boolean;overload;

    function ExistsSql(const ASelectSql:string):integer;
    function ExecuteSql(const AExecSql:string):Boolean;
    function GetDateTime:TdateTime ;    
    function GetUpdateVariant:variant;
    function ApplyUpdates(AData: OleVariant): WideString;
    function GetKeyFieldValue(AKeyCode:string):integer ;
    function ResetKeyFieldValue(AKeyCode:string;AKeyValue:Integer):boolean ;    
  end;

//var
  //DataMainBase: TDataMainBase;

implementation
 uses OptionsConfigImpl,EnvironmentImpl,BasalMarshal,FrameCommon;//ServiceDefine,ServiceError
{$R *.dfm}

{ TDataMain }

function TDataMainBase.ApplyUpdates(AData: OleVariant): WideString;
begin
end;

function TDataMainBase.ExecuteSql(const AExecSql:string): Boolean;
var
  Stmt:TQueryStatement;
  Connection:IConnection;
begin
  Result:=False;
  FLastError:=EmptyStr;
  Connection:=_Environment.ConnectionContext.GetConnection;
  if Connection=nil then Exit;
  try
    Stmt:=Connection.CreateQuery(AExecSql);
    try
      //Connection.BeginTrans;
      try
        Stmt.ExecSQL;
        //Connection.CommitTrans;
        Result:=True;
      except
        on E:Exception do
        begin
          //Connection.RollbackTrans;
          FLastError:=E.Message;
        end;
      end;
    finally
      Stmt.Free;
    end;
  finally
    _Environment.ConnectionContext.Close(Connection);
  end;

end;
function TDataMainBase.GetUpdateVariant: variant;

begin


end;

procedure TDataMainBase.InitializeAdoContext;
begin
end;

procedure TDataMainBase.DataModuleCreate(Sender: TObject);
begin
  //_Environment.InitializeEnvironment ;
end;

function TDataMainBase.LastError: string;
begin
  result:=FLastError;
end;

function TDataMainBase.TryConnecting: Boolean;
begin

end;

function TDataMainBase.TryConnecting(Config: TPersistent): Boolean;
begin

end;

function TDataMainBase.SelectSql(const ASelectSql: string;
  var ADataSet: TClientDataSet): Boolean;
var
  Connection:IConnection;
begin
  Result:=False;
  FLastError:=EmptyStr;
  Connection:=_Environment.ConnectionContext.GetConnection;
  if Connection=nil then
  begin
    FLastError:=' Connection is nil';
    Exit;
  end ;
  try
    Connection.UpdateStatementConnection(PubQuery);
    //if (ADataSet=nil) then
    ADataSet:=TClientDataSet.Create(Self);
    ADataSet.Active:=False;
    ADataSet.ProviderName:=CommonDataSetProviderName;
    PubDataSetProvider.DataSet:=PubQuery;
    with PubQuery do
    begin
      Active:=False;
      SQL.Text:=ASelectSql;
      try
        Active:=True;
        ADataSet.Active:=True;
        Result:=ADataSet.Active;
      except
        on E:Exception do
        begin
          FLastError:=E.Message;
          Result:=False;
        end;
      end;
    end;
  finally
    _Environment.ConnectionContext.Close(Connection);
  end;

end;

procedure TDataMainBase.Initialize;
begin
  FLastError:='' ;
end;

function TDataMainBase.ExecuteRequest(ARequest: TCustomClientRequest;
  var AReply: TCustomServerReply): Boolean;
var
  Connection:IConnection;
  SaveDataSet:TDataSetStatement ;
  isError:Boolean;
  i,j,iErrorCount:integer ;
begin
  Result:=False;
  Connection:=_Environment.ConnectionContext.GetConnection;
  SaveDataSet:=Connection.CreateDataSet ;
  try

    isError:=False;
    Connection.BeginTrans ;
    for i:=0 to TDataApplyUpdateRequest(ARequest).Count -1 do
    begin
      if (trim(TDataApplyUpdateRequest(ARequest).Items[i].ExecSql)='')
        or (VarIsNull(TDataApplyUpdateRequest(ARequest).Items[i].Data))then Continue;
      SaveDataSetProvider.UpdateMode:=TDataApplyUpdateRequest(ARequest).Items[i].UpdateMode; 
      SaveDataSet.Close;

      SaveDataSet.CommandText:=TDataApplyUpdateRequest(ARequest).Items[i].ExecSql ;
      SaveDataSet.Open;

      for j:=0 to TDataApplyUpdateRequest(ARequest).Items[i].Count-1 do
      begin

        SaveDataSet.FieldByName(TDataApplyUpdateRequest(ARequest).Items[i].Fields[j]).ProviderFlags:=
          TDataApplyUpdateRequest(ARequest).Items[i].Flags[j];
        //SaveDataSet.FieldByName(TDataApplyUpdateRequest(ARequest).Items[i].Fields[j]).ProviderFlags+TDataApplyUpdateRequest(ARequest).Items[i].Flags[j];
      end ;

      SaveDataSetProvider.DataSet:=SaveDataSet;
      SaveDataSetProvider.ApplyUpdates(TDataApplyUpdateRequest(ARequest).Items[i].Data ,0, iErrorCount);
      isError:=iErrorCount>0;
      if isError then break ;
    end;
    if not isError then
    begin
      Connection.CommitTrans;
      result:=true ;
    end else
    begin
      if FLastError='' then FLastError:='Î´Öª´íÎó!' ;
      Connection.RollbackTrans ;
    end;
    _Environment.ConnectionContext.Close(Connection);
  except
    on e:exception do
    begin
      FLastError:=e.Message ;
    end; 
  end;
  
  {
  FLastError:=EmptyStr;
  Service:=ServiceSearcher.GetService(ARequest.ServiceGuid);
  if(Service=nil)then
  begin
    FLastError:=RqeustServiceNotExistError;
    Exit;
  end;
  Service.Intialize(Self,ARequest);
  AReply:=Service.Execute;
  Result:=AReply.ReplyType=roNormal;
  }
end;

function TDataMainBase.ExecuteRequest(ARequest: TCustomClientRequest;
  var AReply: TCustomServerReply; var ADataSet: TClientDataSet): Boolean;
begin

end;

procedure TDataMainBase.InitializeService;
begin

end;

function TDataMainBase.GetDateTime: TdateTime;
var
  cdsQry:TClientDataSet ;
begin
  try
    SelectSql('SELECT GETDATE() AS NOW',cdsQry);
    result:= cdsQry.fieldByName('NOW').AsDateTime ;
  finally
    cdsQry.Free ;
  end ;
end;

procedure TDataMainBase.SaveDataSetProviderUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  FLastError:=e.Message ;
end;

function TDataMainBase.ExistsSql(const ASelectSql: string): integer;
var
  Connection:IConnection;
  cdsQry: TClientDataSet ;
begin
  Result:=-1;
  FLastError:=EmptyStr;
  Connection:=_Environment.ConnectionContext.GetConnection;
  if Connection=nil then
  begin
    FLastError:=' Connection is nil';
    Exit;
  end ;
  try
    Connection.UpdateStatementConnection(PubQuery);
    //if (ADataSet=nil) then
    cdsQry:=TClientDataSet.Create(Self);
    cdsQry.Active:=False;
    cdsQry.ProviderName:=CommonDataSetProviderName;
    PubDataSetProvider.DataSet:=PubQuery;
    with PubQuery do
    begin
      Active:=False;
      SQL.Text:=ASelectSql;
      try
        Active:=True;
        cdsQry.Active:=True;
        Result:=cdsQry.RecordCount ;
      except
        on E:Exception do
        begin
          FLastError:=E.Message;
          Result:=-1;
        end;
      end;
    end;
  finally
    cdsQry.Free ;
    _Environment.ConnectionContext.Close(Connection);
  end;

end;

function TDataMainBase.GetKeyFieldValue(AKeyCode: string): integer;
var
  SqlText:string;
  cdsQry:TClientDataSet;
begin
  result:=-1;
  SqlText:=' declare @KeyId int '
          +' exec @KeyId='+DefaultGetKeyIdProcedureName+' '+Quotedstr(AKeyCode)
          +' select @KeyId as KeyId ' ;
  try
    if not SelectSql(SqlText,cdsQry) then exit ;
    result:=cdsQry.Fields[0].AsInteger ;
  finally
    cdsQry.Free;
  end;

end;

function TDataMainBase.ResetKeyFieldValue(AKeyCode: string;
  AKeyValue: Integer): boolean;
var
  SqlText:string;
begin
  result:=false;
  SqlText:=' exec '+DefaultResetKeyIdProcedureName+' '+Quotedstr(AKeyCode)+',' +inttostr(AKeyValue) ;
  result := ExecuteSql(SqlText) ;
end;


end.
