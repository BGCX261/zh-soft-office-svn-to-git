unit DBScriptCreatorImpl;

interface

uses Classes,SysUtils,DataAccess,AdoDb,Db,SqlServerProvider,RzLstBox, RzGroupBar,
 DataAccessProvider,DBScriptExecutorImpl,comobj,TntMenus,TntActnList;
type
  EDBScriptCreatorError=class(Exception);
  
  TAbstractDBScriptCreator=class(TComponent)
  private
    FLastError: string;
    FConnection: IConnection;
    FDBScriptSql:string;
    FProvider:IConnectProvider;
    FScriptExecutor: TDBScriptExecutor;
    function GetDBScriptSql: string;
  protected
    procedure AppendLine(Line:string);
    function ExpandBlank(Value:string):string;
    property Connection:IConnection read FConnection;
    property Provider:IConnectProvider read FProvider;
    property ScriptExecutor:TDBScriptExecutor read FScriptExecutor;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure InitializeContext;virtual;
    function CreateScript(ATableName:string):Boolean;overload;virtual;
    function CreateScript(ATableName:string;ATempletFileName:string):Boolean;overload;virtual;
    function Execute:Boolean;
    procedure SaveToFile(AFileName:string);
    property DBScriptSql:string read GetDBScriptSql;
    property LastError:string read FLastError;
  end;
  TInitTableSequenceProcedureCreator=class(TAbstractDBScriptCreator)
  public
    function CreateScript(ATableName:string):Boolean;overload;override;
    function CreateScript(ATableName:string;ATempletFileName:string):Boolean;overload;override;
    function CreateScriptFromAction(ATableName:string;AActionList: TTntActionList):boolean;overload;
    function CreateScriptFromAction(ATableName:string;ARzGroup: TRzGroup):boolean;overload;
  end;
implementation
uses EnvironmentImpl,FrameCommon;
{ TAbstractDBScriptCreator }

procedure TAbstractDBScriptCreator.AppendLine(Line: string);
begin
  FDBScriptSql:=FDBScriptSql+Line+sLineBreak;
end;

constructor TAbstractDBScriptCreator.Create(AOwner: TComponent);
begin
  inherited;
  FScriptExecutor:= TDBScriptExecutor.Create(nil);
end;

function TAbstractDBScriptCreator.CreateScript(
  ATableName: string): Boolean;
begin
  Result:=False;
end;

function TAbstractDBScriptCreator.CreateScript(ATableName,
  ATempletFileName: string): Boolean;
begin
  Result:=False;
end;

destructor TAbstractDBScriptCreator.Destroy;
begin
  FScriptExecutor.Free ;
  inherited;
end;

function TAbstractDBScriptCreator.Execute: Boolean;
begin
  try
    Result:=ScriptExecutor.ExecSqlBuffer(DBScriptSql)=ssSuccess;
    if not Result then FLastError:=ScriptExecutor.LastError ;
  except
    on E:Exception do
    begin
      FLastError:=e.Message ;
      Result:=False;
    end;
  end;
end;

function TAbstractDBScriptCreator.ExpandBlank(Value: string): string;
begin
  Result:=' '+Value+' ';
end;

function TAbstractDBScriptCreator.GetDBScriptSql: string;
begin
  Result:=UpperCase(FDBScriptSql);
end;

procedure TAbstractDBScriptCreator.InitializeContext;
begin
  FConnection:=_Environment.ConnectionContext.GetConnection;
  FDBScriptSql:=EmptyStr;
  FLastError:=EmptyStr;
  FProvider:=TSQLServerProvider.Create;
  FScriptExecutor.InitialzeDBScriptExecutorEnvironment;
end;

procedure TAbstractDBScriptCreator.SaveToFile(AFileName: string);
var
  FileName:string;
  SQLFile:TextFile;
begin
  FLastError:=EmptyStr;
  FileName:=ChangeFileExt(AFileName,'.SQL');
  try
    AssignFile(SQLFile,FileName);
    try
      if FileExists(FileName)then
        SysUtils.DeleteFile(FileName);
      Rewrite(SQLFile);
      Append(SQLFile);
      Write(SQLFile,DbScriptSql);
    finally
      CloseFile(SQLFile);
    end;
  except
    on E:Exception do
    begin
      FLastError:=E.Message;
    end;
  end;

end;

{ TInitTableSequenceProcedureCreator }

function TInitTableSequenceProcedureCreator.CreateScript(
  ATableName: string): Boolean;
begin

end;

function TInitTableSequenceProcedureCreator.CreateScript(ATableName,
  ATempletFileName: string): Boolean;
begin

end;

function TInitTableSequenceProcedureCreator.CreateScriptFromAction(
  ATableName: string; AActionList: TTntActionList): boolean;
const
  SqlInsert='INSERT INTO RPJJL_Menu(MenuID,ParentId,Code,Description,Seq)';
  SqlValues='VALUES(%d,%d,''%s'',''%s'',%d)';

  SqlActInsert=' INSERT INTO RPJJL_MenuAction(MenuID,ActionId,Code,Description,Seq) ';
  SqlActValues=' VALUES(%d,%d,''%s'',''%s'',%d)';
var
  i,iIndex:integer;
  strParentID,strActionList,strTemp:string ;
  iMenuID,iParentID,iActionID:integer ;
  lstAction,lstAction2,lstAction3,lstAction4,lstAction5,
  lstAction6,lstAction7,lstAction8,lstAction9,lstAction10:TStringList ;
begin
  lstAction:=TStringList.Create  ;
  lstAction.Add('新增') ;
  lstAction.Add('修改') ;
  lstAction.Add('删除') ;

  lstAction2:=TStringList.Create  ;
  lstAction2.Add('销售') ;
  lstAction2.Add('储值/还款') ;
  lstAction2.Add('退货') ;
  lstAction2.Add('退货费用') ;
  lstAction2.Add('打印') ;
  lstAction2.Add('刷新顾客收银状态') ;
  
  lstAction3:=TStringList.Create  ;
  lstAction3.Add('修改') ;
  lstAction3.Add('批量修改') ;
  lstAction3.Add('批量更新') ;
  lstAction3.Add('上楼费') ;
  lstAction3.Add('属性导入') ;

  lstAction4:=TStringList.Create  ;
  lstAction4.Add('修改') ;
  lstAction4.Add('确认') ;
  lstAction4.Add('审批') ;

  lstAction5:=TStringList.Create  ;
  lstAction5.Add('门店确认') ;


  lstAction6:=TStringList.Create  ;
  lstAction6.Add('零售价') ;
  lstAction6.Add('档案成本') ;
  lstAction6.Add('平均成本') ;


  lstAction7:=TStringList.Create  ;
  lstAction7.Add('零售价') ;
  lstAction7.Add('档案成本') ;


  lstAction8:=TStringList.Create  ;
  lstAction8.Add('采购单') ;
  lstAction8.Add('收货单') ;
  lstAction8.Add('收货单MST') ;
  lstAction8.Add('厂送收货单') ;
  lstAction8.Add('物流返厂单') ;
  lstAction8.Add('MST返厂单') ;
  lstAction8.Add('调拨发出单') ;
  lstAction8.Add('调拨接收单') ;


  lstAction9:=TStringList.Create  ;
  lstAction9.Add('修改') ;
  lstAction9.Add('确认') ;
  lstAction9.Add('审批') ;
  lstAction9.Add('作废') ;


  lstAction10:=TStringList.Create  ;
  lstAction10.Add('门店交接') ;
  lstAction10.Add('新建') ;
  lstAction10.Add('编辑') ;
  lstAction10.Add('确认') ;
  lstAction10.Add('打印') ;
  lstAction10.Add('作废') ;  

    
  try
    for i:=0 to AActionList.ActionCount-1 do
    begin
      strParentID:=Trim(AActionList.Actions[i].Category) ;

      strActionList:=TTntAction(AActionList.Actions[i]).Hint;

      if strParentID=EmptyStr then continue ;
      if AActionList.Actions[i].Tag=0 then continue ;
      try iParentID:=strtoint(strParentID);except continue;end ;

      iMenuID:=iParentID *1000+AActionList.Actions[i].Tag  ;
 
      AppendLine(SqlInsert);
      AppendLine(format(SqlValues,[iMenuID,iParentID,AActionList.Actions[i].Name,TTntAction(AActionList.Actions[i]).Caption,AActionList.Actions[i].Tag ]));
      AppendLine(TabSeparator);
      iIndex:=0 ;
      while Trim(strActionList)<>'' do
      begin
        strTemp:=copy(strActionList,1,1);
        if Trim(strTemp)='' then continue ;
        iActionID:=iMenuID* 100 +iIndex+2;

        if strTemp='1' then
        begin

          AppendLine(SqlActInsert);
          if (AActionList.Actions[i].Name='ActionClearingInv')
            or (AActionList.Actions[i].Name='ActionClearingAg')
            or (AActionList.Actions[i].Name='ActionClearingWait')
            or (AActionList.Actions[i].Name='ActionClearingInFee')
            or (AActionList.Actions[i].Name='ActionClearingFee')
            or (AActionList.Actions[i].Name='ActionClearingFreight')
            or (AActionList.Actions[i].Name='ActionRealCsoAccFee')
            or (AActionList.Actions[i].Name='ActionRealCsoAccFreight') then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction4[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionClearingCom' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction9[iIndex],iIndex]))          
          else if AActionList.Actions[i].Name='ActionSkuOther' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction3[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionDelivery' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,'重印',iIndex]))
          else if AActionList.Actions[i].Name='ActionCustomerConfirm' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction5[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionProductInfoQuery' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction6[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionCash' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction2[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionPo_s' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction7[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionRmPoReport' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction8[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionCsoDateModify' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,'ActionCsoDateModify','变更时间无限制(15点后)',iIndex]))
          else if AActionList.Actions[i].Name='ActionRm' then
            //AppendLine(format(SqlActValues,[iMenuID,iActionID,'ActionRm','门店交接',iIndex]))
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction10[iIndex],iIndex]))
          else if AActionList.Actions[i].Name='ActionVipcardPasswrodModify' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,'ActionVipcardPasswrodModify','可不需要原密码',iIndex]))
          else
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction[iIndex],iIndex]));
          AppendLine(TabSeparator);        
        end ;
        inc(iIndex) ;
        strActionList:=copy(strActionList,2,length(strActionList)) ;
      end ;
      {
      for j:=0 to 2 do
      begin
        strTemp:=copy(strActionList,1,1);
        if Trim(strTemp)='' then continue ;
        iActionID:=iMenuID* 100 +j+2;
        if strTemp='1' then
        begin

          AppendLine(SqlActInsert);
          if AActionList.Actions[i].Name='ActionCash' then
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction2[j],j]))
          else
            AppendLine(format(SqlActValues,[iMenuID,iActionID,AActionList.Actions[i].Name,lstAction[j],j]));
          AppendLine(TabSeparator);        
        end ;
      end ;
      }
    end ;
  finally
    lstAction.Free ;
  end;
end;

function TInitTableSequenceProcedureCreator.CreateScriptFromAction(
  ATableName: string; ARzGroup: TRzGroup): boolean;
const
  SqlInsert=' IF NOT EXISTS(SELECT 1 FROM RPJJL_Menu(nolock) WHERE MenuID=%d)'
    +' INSERT INTO RPJJL_Menu(MenuID,ParentId,Code,Description,Seq)';
  SqlValues='VALUES(%d,%d,''%s'',''%s'',%d)';

  SqlActInsert=' IF NOT EXISTS(SELECT 1 FROM RPJJL_MenuAction(nolock) WHERE MenuID=%d and ActionId=%d)'
    +' INSERT INTO RPJJL_MenuAction(MenuID,ActionId,Code,Description,Seq) ';
  SqlActValues=' VALUES(%d,%d,''%s'',''%s'',%d)';
var
  i,iIndex,iTag:integer;
  strParentID,strActionList,strTemp,strActionName,strActionCaption:string ;
  iMenuID,iParentID,iActionID:integer ;
  lstAction,lstAction2,lstAction3,lstAction4,lstAction5:TStringList ;
begin
  lstAction:=TStringList.Create  ;
  lstAction.Add('新增') ;
  lstAction.Add('修改') ;
  lstAction.Add('删除') ;

  lstAction2:=TStringList.Create  ;
  lstAction2.Add('销售') ;
  lstAction2.Add('储值/还款') ;
  lstAction2.Add('退货') ;
  lstAction2.Add('退货费用') ;
  lstAction2.Add('打印') ;
  lstAction2.Add('刷新顾客收银状态') ;

  lstAction3:=TStringList.Create  ;
  lstAction3.Add('修改') ;
  lstAction3.Add('批量修改') ;
  lstAction3.Add('批量更新') ;
  lstAction3.Add('上楼费') ;

  lstAction4:=TStringList.Create  ;
  lstAction4.Add('修改') ;
  lstAction4.Add('确认') ;
  lstAction4.Add('审批') ;

  lstAction5:=TStringList.Create  ;
  lstAction5.Add('门店确认') ;
  try
    for i:=0 to ARzGroup.Items.Count -1 do
    begin
      if ARzGroup.Items[i].Action=nil then continue ;
      
      strActionName:=TTntAction(ARzGroup.Items[i].Action).Name ;
      strActionCaption:=TTntAction(ARzGroup.Items[i].Action).Caption ;
      strParentID:=Trim(TTntAction(ARzGroup.Items[i].Action).Category) ;

      strActionList:=TTntAction(ARzGroup.Items[i].Action).Hint;
      iTag:=TTntAction(ARzGroup.Items[i].Action).Tag ;
      if strParentID=EmptyStr then continue ;
      if iTag=0 then continue ;
      try iParentID:=strtoint(strParentID);except continue;end ;

      iMenuID:=iParentID *1000+iTag ;
 
      AppendLine(format(SqlInsert,[iMenuID]));
      AppendLine(format(SqlValues,[iMenuID,iParentID,strActionName,strActionCaption,iTag ]));
      AppendLine(TabSeparator);
      iIndex:=0 ;
      while Trim(strActionList)<>'' do
      begin
        strTemp:=copy(strActionList,1,1);
        if Trim(strTemp)='' then continue ;
        iActionID:=iMenuID* 100 +iIndex+2;

        if strTemp='1' then
        begin
          AppendLine(format(SqlActInsert,[iMenuID,iActionID]));
          AppendLine(format(SqlActValues,[iMenuID,iActionID,strActionName,lstAction[iIndex],iIndex]));
          AppendLine(TabSeparator);        
        end ;
        inc(iIndex) ;
        strActionList:=copy(strActionList,2,length(strActionList)) ;
      end ;
    end ;
  finally
    lstAction.Free ;
  end;

end;

end.
