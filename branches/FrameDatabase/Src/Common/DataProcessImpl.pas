unit DataProcessImpl;

interface

uses SysUtils,Classes,DBClient,DB,AdoDb,DataAccess,Provider,CoreImpl,Controls,
  MarshalImpl,Variants,dxmdaset,TntDBCtrls,
  ExtCtrls,DBCtrls,StdCtrls,RzDBEdit,RzDBBnEd,
  TntButtons, TntStdCtrls,TntExtCtrls,DBGridEh,DBCtrlsEh,dxDBELib,RzDBCmbo;

type
  TUIStatusType =(stNone,stBrowse,stAppend,stEdit);
  TDataTableAdapter=class;
  TFieldAdapter=class;

  TDataProcessingEvent=procedure(ADataAdapter:TDataTableAdapter)of object;
  TDataProcessedEvent=procedure(ADataAdapter:TDataTableAdapter)of object;

  TDataSubmitingEvent=procedure(Sender:TObject;var AllowSubmit:Boolean)of object;
  TDataSubmitedEvent=procedure(Sender:TObject; Submited:Boolean)of object;
  
  TCustomBusinessDataProcessImpl=class(TComponent)
  private
    FLastError: string;
    FOnEdited: TDataProcessedEvent;
    FOnEditing: TDataProcessingEvent;
    FOnDeleted: TDataProcessedEvent;
    FOnCanceled: TDataProcessedEvent;
    FOnSaved: TDataProcessedEvent;
    FOnAppended: TDataProcessedEvent;
    FOnSaveing: TDataProcessingEvent;
    FOnAppending: TDataProcessingEvent;
    FOnCanceling: TDataProcessingEvent;
    FOnDeleteing: TDataProcessingEvent;
    FModuleItem: TModuleItem;
    FMemDataDictionarys:TMemDataDictionarys ;
    FOnPosted: TDataProcessedEvent;
    FOnPosting: TDataProcessingEvent;
    FTables: TStringList;

    FOnEditAlled: TDataSubmitedEvent;
    FOnEditAlling: TDataSubmitingEvent;
    FOnSaveAlled: TDataSubmitedEvent;
    FOnSaveAlling: TDataSubmitingEvent;
    FMasterWhereSql: string;
    FOnAppendAlled: TDataSubmitedEvent;
    FOnAppendAlling: TDataSubmitingEvent;
    FOnDeleteAlled: TDataSubmitedEvent;
    FOnDeleteAlling: TDataSubmitingEvent;
    //FCopyPasteBufferMgr: TRecordSetBufferManager;
    function GetDataTables(Index: Integer): TDataTableAdapter;
    function GetTableCount: Integer;
  protected
    FMasterTable:TDataTableAdapter;
    procedure Appending(ADataAdapter:TDataTableAdapter);virtual;
    procedure Appended(ADataAdapter:TDataTableAdapter);virtual;
    procedure Editing(ADataAdapter:TDataTableAdapter);virtual;
    procedure Edited(ADataAdapter:TDataTableAdapter);virtual;
    procedure Saveing(ADataAdapter:TDataTableAdapter);virtual;
    procedure Saved(ADataAdapter:TDataTableAdapter);virtual;
    procedure Canceling(ADataAdapter:TDataTableAdapter);virtual;
    procedure Canceled(ADataAdapter:TDataTableAdapter);virtual;
    procedure Deleteing(ADataAdapter:TDataTableAdapter);virtual;
    procedure Deleted(ADataAdapter:TDataTableAdapter);virtual;
    procedure Posting(ADataAdapter:TDataTableAdapter);virtual;
    procedure Posted(ADataAdapter:TDataTableAdapter);virtual;

    procedure AppendMastering(var AllowAppend:Boolean);virtual;
    procedure AppendMastered(isAppended:Boolean);virtual;      
    procedure EditMastering(var AllowEdit:Boolean);virtual;
    procedure EditMastered(isEdited:Boolean);virtual;    
    procedure SaveAlling(var AllowSubmit:Boolean);virtual;
    procedure SaveAlled( Submited:Boolean);virtual;
    procedure DeleteAlling(var AllowDelete:Boolean);virtual;
    procedure DeleteAlled( ADeleted:Boolean);virtual;    
    property Tables:TStringList read FTables;
    //property CopyPasteBufferMgr:TRecordSetBufferManager read FCopyPasteBufferMgr;
    function GetSaveSql(DataTable:TDataTableAdapter):string;virtual;
    function GetDeleteSql(DataTable:TDataTableAdapter):string;virtual;    
    procedure InitializeMasterData;virtual;
    procedure CreateDataTable;overload ;virtual;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Initialize(AModuleItem:TModuleItem);virtual;
    //根据某个表结构创建数据集
    procedure CreateDataTable(AIndex:integer;var ADataSet:TClientDataSet); overload ;virtual;
    procedure CreateDataTable(AIndex:integer;var ADataSet:TdxMemData); overload ;virtual;
    function IndexOfTableName(const ATableName: string): Integer;
    function IndexOfMaster: Integer;
    function DataTableOfTableName(ATableName:string):TDataTableAdapter ;
    function SelectSql(const ASelectSql:string;var ADataSet:TClientDataSet):Boolean;
    function ExecuteSql(const AExecSql:string):Boolean;
    //
    function GetSaveWhere(DataTable:TDataTableAdapter):string;virtual;

    function GetData(const AMasterWhereSql:string):boolean ;
    function GetMasterData(const AWhereSql:string):boolean;
    function GetDetailData:boolean;
    function GetDetailSqlWhere(ATableIndex: Integer):string;
    function GetDetailNextSeq(ATableName,AFieldName:string):integer;
    procedure DataBinDings(ATableIndex: Integer;AParentControl:TWinControl);
    
    //Summary:
    // 系统提供的对主表或者全部的简单数据处理接口
    function AppendMaster:Boolean;
    function EditMaster:Boolean;
    function SaveAll:Boolean;
    function SaveSingle(AtableIndex:integer;var ADataSet:TClientDataSet):Boolean;
    function DeleteAll:Boolean;
    function CancelMaster:Boolean;
    //生成关键字段值
    function SetKeyFieldValue:boolean ;
    function SetDetailKeyFieldValue:boolean ;
    function GetKeyFieldValue(AKeyCode:string):integer ;
    //回滚KeyID
    function RollBackKeyId(AKeyCode:string;AKeyID:integer):boolean ;
    //Summary:
    // 系统提供标准复制粘贴
    procedure Copy;overload;virtual;
    procedure Copy(DataTable:TDataTableAdapter);overload;virtual;
    procedure Paste;overload;virtual;
    procedure Paste(DataTable:TDataTableAdapter);overload;virtual;
    //Summary:
    // 系统提供标准的导入导出接口    
    function ExportToXls(const AFileName:string):Boolean;overload;virtual;
    function ImportFromXls(const AFileName:string):Boolean;overload;virtual;
    function ExportToXml(const AFileName:string):Boolean;overload;virtual;
    function ImportFromXml(const AFileName:string):Boolean;overload;virtual;
    function ExportToZip(const AFileName:string):Boolean;overload;virtual;
    function ImportFromZip(const AFileName:string):Boolean;overload;virtual;
    function ExportToXls(const AFileName:string;const ADataTable:TDataTableAdapter):Boolean;overload;virtual;
    function ImportFromXls(const AFileName:string;const ADataTable:TDataTableAdapter):Boolean;overload;virtual;
    function ExportToXml(const AFileName:string;const ADataTable:TDataTableAdapter):Boolean;overload;virtual;
    function ImportFromXml(const AFileName:string;const ADataTable:TDataTableAdapter):Boolean;overload;virtual;
    function ExportToZip(const AFileName:string;const ADataTable:TDataTableAdapter):Boolean;overload;virtual;
    function ImportFromZip(const  AFileName:string;const ADataTable:TDataTableAdapter):Boolean;overload;virtual;
    
    property ModuleItem:TModuleItem read FModuleItem;
    property MasterTable:TDataTableAdapter read FMasterTable;
    property MasterWhereSql:string read FMasterWhereSql ;
    property TableCount:Integer read GetTableCount;
    property DataTables[Index:Integer]:TDataTableAdapter read GetDataTables;default;
    property MemDataDictionarys:TMemDataDictionarys read FMemDataDictionarys;
    
    property LastError:string read FLastError;
    property OnAppending:TDataProcessingEvent read FOnAppending write FOnAppending;
    property OnAppended:TDataProcessedEvent read FOnAppended write FOnAppended;
    property OnEditing:TDataProcessingEvent read FOnEditing write FOnEditing;
    property OnEdited:TDataProcessedEvent read FOnEdited write FOnEdited;       
    property OnDeleteing:TDataProcessingEvent read FOnDeleteing write FOnDeleteing;
    property OnDeleted:TDataProcessedEvent read FOnDeleted write FOnDeleted;
    property OnCanceling:TDataProcessingEvent read FOnCanceling write FOnCanceling;
    property OnCanceled:TDataProcessedEvent read FOnCanceled write FOnCanceled;
    property OnSaveing:TDataProcessingEvent read FOnSaveing write FOnSaveing;
    property OnSaved:TDataProcessedEvent read FOnSaved write FOnSaved;
    property OnPosting:TDataProcessingEvent read FOnPosting write FOnPosting;
    property OnPosted:TDataProcessedEvent read FOnPosted write FOnPosted;

    property OnAppendAlling:TDataSubmitingEvent read FOnAppendAlling write FOnAppendAlling;
    property OnAppendAlled:TDataSubmitedEvent read FOnAppendAlled write FOnAppendAlled;
    property OnEditAlling:TDataSubmitingEvent read FOnEditAlling write FOnEditAlling;
    property OnEditAlled:TDataSubmitedEvent read FOnEditAlled write FOnEditAlled;    
    property OnSaveAlling:TDataSubmitingEvent read FOnSaveAlling write FOnSaveAlling;
    property OnSaveAlled:TDataSubmitedEvent read FOnSaveAlled write FOnSaveAlled;
    property OnDeleteAlling:TDataSubmitingEvent read FOnDeleteAlling write FOnDeleteAlling;
    property OnDeleteAlled:TDataSubmitedEvent read FOnDeleteAlled write FOnDeleteAlled;
     
  end;

  TDataTableAdapter=class(TComponent)
  private
    FDataSet: TClientDataSet;
    FDataOwner: TCustomBusinessDataProcessImpl;
    FDataSource: TDataSource;
    FTableItem: TTableItem;
    FFields: TStringList;    
    FViewCtrl:TComponent;        //关联明细数据浏览组件    
    function GetFieldAdapters(Index: Integer): TFieldAdapter;
    function GetFieldCount: Integer;
  protected
    procedure Intialize(ATableItem:TTableItem);
    function DoAppend:Boolean;virtual;
    function DoEdit:Boolean;virtual;
    function DoCnacel:Boolean;virtual;
    function DoPost:Boolean;virtual;
    function DoDelete:Boolean;virtual;
    property Fields:TStringList read FFields;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    function Append:Boolean;
    function Edit:Boolean;
    function Post:Boolean;
    function Delete:Boolean;
    function Cnacel:Boolean;
    property TableItem:TTableItem read FTableItem;
    property DataFields[Index:Integer]:TFieldAdapter read GetFieldAdapters;default;
    property FieldCount:Integer read GetFieldCount;
    property DataOwner:TCustomBusinessDataProcessImpl read FDataOwner;
    property DataSet:TClientDataSet read FDataSet;
    property DataSource:TDataSource read FDataSource;
    property ViewCtrl:TComponent read FViewCtrl write FViewCtrl ;
  end;

  TFieldAdapter=class(TComponent)
  private
    FTableOwner: TDataTableAdapter;
    FFieldItem: TFieldItem;
    FControl: TWinControl;
  protected
    procedure Intialize(AFieldItem:TFieldItem);
  public
    constructor Create(AComponent:TComponent);override;
    destructor Destroy;override;
    property FieldItem:TFieldItem read FFieldItem;
    property Control:TWinControl read FControl write FControl;
    property TableOwner:TDataTableAdapter read FTableOwner;
  end;

  TArchiveDataProcessImpl=class(TCustomBusinessDataProcessImpl)
  end;

  TCustomBillDocDataProcessImpl=class(TCustomBusinessDataProcessImpl)
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Initialize(AModuleItem:TModuleItem);override;  
  end;

implementation

uses FrameCommon, DataAccessInt,KeyPairDictionary,EnvironmentImpl;//ServiceDefine,DataToXlsImpl

{ TCustomBusinessDataProcessImpl }

procedure TCustomBusinessDataProcessImpl.Appended(
  ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnAppended)then
    FOnAppended(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.Appending(
  ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnAppending)then
    FOnAppending(ADataAdapter);
end;

function TCustomBusinessDataProcessImpl.AppendMaster: Boolean;
var
  bAllowAppend:boolean ;
begin
  AppendMastering(bAllowAppend);
  if not bAllowAppend then exit ;

  try
    MasterTable.DataSet.Append ;
    if TableCount>1 then GetDetailData ;
    Result:=true ;
  except
    on E:Exception do
    begin
      Result:=False;
      FLastError:=E.Message;
    end;
  end ;
  AppendMastered(Result);
    
end;

function TCustomBusinessDataProcessImpl.CancelMaster: Boolean;
var
  Index:Integer;
begin
  Result:=True;
  try
    for Index:=0 to TableCount -1 do
    begin
      if(DataTables[Index].TableItem.Attribute=taMain)then Continue;
      DataTables[Index].DataSet.CancelUpdates;
    end;
    MasterTable.Dataset.CancelUpdates;
  except
    on E:Exception do
    begin
      Result:=False;
      FLastError:=E.Message;
    end;
  end;
end;

procedure TCustomBusinessDataProcessImpl.Canceled(
  ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnCanceled)then
    FOnCanceled(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.Canceling(
  ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnCanceling)then
    FOnCanceling(ADataAdapter);
end;

constructor TCustomBusinessDataProcessImpl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTables:=TStringList.Create;
  FTables.Sorted:=True;
  FMemDataDictionarys:=TMemDataDictionarys.Create(AOwner) ;
 //FCopyPasteBufferMgr:=TRecordSetBufferManager.Create;
end;

function TCustomBusinessDataProcessImpl.DeleteAll: Boolean;
var
  Index:Integer;
  Buffer,MainSql,DeleteSql:string;
  AllowDelete:boolean ;
begin
  Result:=False;
  AllowDelete:=True;
  DeleteAlling(AllowDelete);
  if not AllowDelete then exit ; 
  try
    DeleteSql:=EmptyStr;
    for Index:=0 to TableCount-1 do
    begin
      Buffer:=GetDeleteSql(DataTables[Index]);
      with DataTables[Index].TableItem do
      begin
        case Attribute of
          taMain:MainSql:=Buffer;
          taAttach:DeleteSql:=DeleteSql+Buffer;
          taDetail:DeleteSql:=Buffer+DeleteSql;
        end;
      end;
    end;
    if MainSql<>EmptyStr then
      DeleteSql:=DeleteSql+MainSql;
    Result:=ExecuteSql(DeleteSql);
    if(Result)then
    begin
      MasterTable.DataSet.Delete;
      MasterTable.DataSet.Reconcile(NULL);
    end;
    DeleteAlled(Result) ;
  except
    on E:Exception do
    begin
      Result:=False;
      FLastError:=E.Message;
    end;
  end;
end;

procedure TCustomBusinessDataProcessImpl.Deleted(ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnDeleted)then
    FOnDeleted(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.Deleteing(ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnDeleteing)then
    FOnDeleteing(ADataAdapter);
end;

destructor TCustomBusinessDataProcessImpl.Destroy;
begin
  //FCopyPasteBufferMgr.Free;
  FTables.Free;
  inherited;
end;

function TCustomBusinessDataProcessImpl.EditMaster: Boolean;
var
  bAllowEdit:boolean ;
begin
  EditMastering(bAllowEdit);
  if not bAllowEdit then exit ;  
  Result:=MasterTable.Edit;
  EditMastered(Result);
end;

function TCustomBusinessDataProcessImpl.ExecuteSql(
  const AExecSql: string): Boolean;
begin
  Result:=_Environment.DataAccess.ExecuteSql(AExecSql);
  if(not Result)then
    FLastError:=_Environment.DataAccess.LastError;
end;


function TCustomBusinessDataProcessImpl.GetDataTables(
  Index: Integer): TDataTableAdapter;
begin
  Result:=TDataTableAdapter(FTables.Objects[Index]);
end;

function TCustomBusinessDataProcessImpl.GetTableCount: Integer;
begin
  Result:=FTables.Count;
end;

procedure TCustomBusinessDataProcessImpl.Initialize(
  AModuleItem: TModuleItem);
var
  Index:Integer;
  DataTable:TDataTableAdapter;
begin
  if AModuleItem=nil then exit ;
  FModuleItem:=AModuleItem;
  with ModuleItem.TableItems do
  begin
    for Index:=0 to Count-1 do
    begin
      DataTable:=TDataTableAdapter.Create(Self);
      DataTable.Intialize(Tables[Index]);
      DataTable.FDataOwner:=Self;
      if (Tables[Index].Attribute=taMain)then
        FMasterTable:=DataTable;
      FTables.AddObject(Tables[Index].Code,DataTable);
    end;
  end;
  CreateDataTable ;
//  CreateDataTable();
//  InitializeMasterData;
end;

procedure TCustomBusinessDataProcessImpl.Posted(ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnPosted)then
    FOnPosted(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.Posting(ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnPosting)then
    FOnPosting(ADataAdapter);
end;

function TCustomBusinessDataProcessImpl.SaveAll: Boolean;
var
  Index,KeyIndex:Integer;
  Request:TDataApplyUpdateRequest;
  RequestItem:TDataApplyUpdateItem;
  Reply:TCustomServerReply;
  ExecSql:string;
  AllowSubmit:Boolean;
  function GetModifyData(DataTable:TDataTableAdapter):OleVariant;
  begin
    try
      Result:=DataTable.DataSet.Delta;
    except
      Result:=NULL;
    end;
  end;
begin
  Result:=False;
  AllowSubmit:=True;
  SaveAlling(AllowSubmit);
  if not AllowSubmit then Exit;
  Request:=TDataApplyUpdateRequest.Create;
  try
    Request.Initialize;
    Request.OperateType:=odtUpdate;
    Request.RequestUser:='000';
    Request.RequestIP:='127.0.0.1';
    Request.Computer:='';
    //Request.ServiceGuid:=DataApplyUpdateServiceGuid;
    if MasterTable<>nil then
    begin
      RequestItem:=Request.CreateRequestItem;
      RequestItem.ExecType:=etData;
      RequestItem.TableName:=MasterTable.TableItem.Code;
      RequestItem.TableAttr:=MasterTable.TableItem.Attribute;
      ExecSql:=GetSaveSql(MasterTable);
      RequestItem.ExecSql:=ExecSql;
      RequestItem.Data:=GetModifyData(MasterTable);
      RequestItem.UpdateMode:=upWhereKeyOnly;
      with MasterTable.TableItem.FieldItems do
      begin
        for KeyIndex:=0 to Count -1 do
          if Fields[KeyIndex].IsKey then
            RequestItem.Add(Fields[KeyIndex].FieldName,[pfInKey]);
      end;
    end; 
    for Index:=0 to TableCount-1 do
    begin
      if DataTables[Index].TableItem.Attribute=taMain then
        continue ; 
      RequestItem:=Request.CreateRequestItem;
      RequestItem.ExecType:=etData;
      RequestItem.TableName:=DataTables[Index].TableItem.Code;
      RequestItem.TableAttr:=DataTables[Index].TableItem.Attribute;
      ExecSql:=GetSaveSql(DataTables[Index]);
      RequestItem.ExecSql:=ExecSql;
      RequestItem.Data:=GetModifyData(DataTables[Index]);
      RequestItem.UpdateMode:=upWhereKeyOnly;
      with DataTables[Index].TableItem.FieldItems do
      begin
        for KeyIndex:=0 to Count -1 do
          if Fields[KeyIndex].IsKey then
            RequestItem.Add(Fields[KeyIndex].FieldName,[pfInKey]);
      end;
    end;
    Result:=_Environment.DataAccess.ExecuteRequest(Request,Reply);
    if(Result)then
    begin
      for Index:=0 to TableCount -1 do
        DataTables[Index].DataSet.Reconcile(NULL);
    end else
    begin
      FLastError:=_Environment.DataAccess.LastError ;
    end ;
  finally
    SaveAlled(Result);
    Request.Free;
  end;
end;

procedure TCustomBusinessDataProcessImpl.Saved(ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnSaved)then
    FOnSaved(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.Saveing(ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnSaveing)then
    FOnSaveing(ADataAdapter);
end;

function TCustomBusinessDataProcessImpl.SelectSql(const ASelectSql: string;
  var ADataSet: TClientDataSet): Boolean;
begin
  Result:=_Environment.DataAccess.SelectSql(ASelectSql,ADataSet);
  if not Result then FLastError:=_Environment.DataAccess.LastError ;
end;

procedure TCustomBusinessDataProcessImpl.SaveAlled(Submited: Boolean);
begin
  if Assigned(FOnSaveAlled)then
    FOnSaveAlled(Self,Submited);
end;

procedure TCustomBusinessDataProcessImpl.SaveAlling(
  var AllowSubmit: Boolean);
begin
  AllowSubmit:=true ;
  if Assigned(FOnSaveAlling)then
    FOnSaveAlling(Self,AllowSubmit);
end;


procedure TCustomBusinessDataProcessImpl.InitializeMasterData;
var
  SqlText:string;
  Stmt:TClientDataSet;
begin
  SqlText:=MasterTable.TableItem.GetSelectSql(EmptyStr,EmptyStr,EmptyStr,False);
  SelectSql(SqlText,Stmt);
  
  try
    MasterTable.DataSet.Data:=Stmt.Data;
  finally
    Stmt.Free;
  end;
end;

function TCustomBusinessDataProcessImpl.GetSaveSql(
  DataTable: TDataTableAdapter): string;
var
  FieldIndex:Integer;
  WhereSql:string;
begin
  Result:=EmptyStr;
  WhereSql:=EmptyStr;
  WhereSql:=GetSaveWhere(DataTable) ;
  Result:=DataTable.TableItem.GetSelectSql(WhereSql,EmptyStr,EmptyStr,False);
  {
  with DataTable.TableItem do
  begin
    case Attribute of
      taMain,taAttach:
      begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsKey)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end;
          end;
        end;
      end;
      taDetail:
      begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsLinkMaster)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(MasterTable.DataSet.FieldByname(FieldItems[FieldIndex].MasterField).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(MasterTable.DataSet.FieldByname(FieldItems[FieldIndex].MasterField).AsString);
            end;
          end;
        end;
      end;
    end;
    Result:=GetSelectSql(WhereSql,EmptyStr,EmptyStr,False);
  end;
  }
end;

procedure TCustomBusinessDataProcessImpl.Copy(
  DataTable: TDataTableAdapter);
var
  Index:Integer;
  //RecordBuffer:TRecordSetBuffer;
  SourceBuffer,DestBuffer:Pointer;
  Appended:Boolean;
begin
  {
  with DataTable do
  begin
    if(DataSet.Active)and(not DataSet.IsEmpty)then
    begin
      RecordBuffer:=CopyPasteBufferMgr.Search(TableItem.Code);
      Appended:=(RecordBuffer=nil);
      if Appended then
        RecordBuffer:=CopyPasteBufferMgr.CreateRecordSetBuffer;
      RecordBuffer.Clear;
      RecordBuffer.TableName:=TableItem.Code;
      RecordBuffer.RecordSize:=DataSet.RecordSize;
      case TableItem.Attribute of
        taMain,taAttach:
        begin
          RecordBuffer.RecordCount:=1;
          SourceBuffer:=DataSet.ActiveBuffer;
          DestBuffer:=RecordBuffer.RecBuffer[0];
          System.Move(SourceBuffer^,DestBuffer^,RecordBuffer.RecordSize);
        end;
        taDetail:
        begin
          RecordBuffer.RecordCount:=DataSet.RecordCount;
          DataSet.First;
          Index:=0;
          while not DataSet.Eof do
          begin
            SourceBuffer:=DataSet.ActiveBuffer;
            DestBuffer:=RecordBuffer.RecBuffer[Index];
            System.Move(SourceBuffer^,DestBuffer^,RecordBuffer.RecordSize);
            DataSet.Next;
            Inc(Index);
          end;
        end;
      end;
      if Appended then
        CopyPasteBufferMgr.Add(RecordBuffer);
    end;
  end;
  }
end;

procedure TCustomBusinessDataProcessImpl.Copy;
var
  Index,P:Integer;
  //RecordBuffer:TRecordSetBuffer;
  //SourceBuffer,DestBuffer:Pointer;
begin
  {
  CopyPasteBufferMgr.Clear;
  for Index:=0 to TableCount -1 do
  begin
    with DataTables[Index] do
    begin
      if (DataSet.Active)and(not DataSet.IsEmpty) then
      begin
        RecordBuffer:=CopyPasteBufferMgr.CreateRecordSetBuffer;
        RecordBuffer.TableName:=TAbleItem.Code;
        RecordBuffer.RecordSize:=DataSet.RecordSize;
        case TableItem.Attribute of
          taMain,taAttach:
          begin
            RecordBuffer.RecordCount:=1;
            SourceBuffer:=DataSet.ActiveBuffer;
            DestBuffer:=RecordBuffer.RecBuffer[0];
            System.Move(SourceBuffer^,DestBuffer^,RecordBuffer.RecordSize);
          end;
          taDetail:
          begin
            RecordBuffer.RecordCount:=DataSet.RecordCount;
            DataSet.First;
            P:=0;
            while not DataSet.Eof do
            begin
              SourceBuffer:=DataSet.ActiveBuffer;
              DestBuffer:=RecordBuffer.RecBuffer[P];
              System.Move(SourceBuffer^,DestBuffer^,RecordBuffer.RecordSize);
              DataSet.Next;
              Inc(P);
            end;
          end;
        end;
        CopyPasteBufferMgr.Add(RecordBuffer);
      end;
    end;
  end;
  }
end;

procedure TCustomBusinessDataProcessImpl.Paste(
  DataTable: TDataTableAdapter);
begin
end;

procedure TCustomBusinessDataProcessImpl.Paste;
var
  Index,P:Integer;
  //RecordBuffer:TRecordSetBuffer;
  SourceBuffer,DestBuffer:Pointer;
  KeyBuffers:TKeyStringDictionary;
  procedure PreparePaste;
  var
    Keys:TStringList;
    KeyIndex:Integer;
  begin
    Keys:=MasterTable.TableItem.FieldKeys;
    try
      for KeyIndex:=0 to Keys.Count-1 do
        KeyBuffers.Add(Keys[KeyIndex],EmptyStr);    
    finally
      Keys.Free;
    end;
  end;
begin
  {
  //Summary:
  // 先粘贴主表,保存主表现有的关键字信息
  KeyBuffers:=TKeyStringDictionary.Create(nil);
  try
    PreparePaste;
    with MasterTable do
    begin
      RecordBuffer:=CopyPasteBufferMgr.Search(TableItem.Code);
      if(RecordBuffer<>nil)and(RecordBuffer.RecordCount=1)then
      begin
        for Index:=0 to KeyBuffers.Count- 1 do
          KeyBuffers.Values[Index]:=DataSet.FieldByName(KeyBuffers[Index].Key).AsString;
        DestBuffer:=DataSet.ActiveBuffer;
        SourceBuffer:=RecordBuffer.RecBuffer[0];
        System.Move(SourceBuffer^,DestBuffer^,DataSet.RecordSize);
        for Index:=0 to KeyBuffers.Count-1 do
          DataSet.FieldByName(KeyBuffers.Names[Index]).AsString:=KeyBuffers.Values[Index];
      end;
    end;
    //<to do>
    // 数据库信息表(us_fields)增加一个字段,保存当前字段跟主表的外间关系字段.
    // 否则没有办法.
    for Index:=0 to TableCount-1 do
    begin
      with DataTables[Index] do
      begin
        if TableItem.Attribute=taMain then Continue;
        if(DataSet.Active)then
        begin
          RecordBuffer:=CopyPasteBufferMgr.Search(TableItem.Code);
          if RecordBuffer=nil then Continue;
          case TableItem.Attribute of
            taAttach:
            begin
            end;
            taDetail:
            begin

            end;
          end;
        end;
      end;
    end;
  finally
    KeyBuffers.Free;
  end;
  }
end;



function TCustomBusinessDataProcessImpl.ExportToXls(
  const AFileName: string): Boolean;
var
  ErrorMsg:string;
begin
  {
  with TStandareArchiveToExcelAdapter.Create do
  try
    Result:=Execute(AFileName,Self,ErrorMsg);
  finally
    Free;
  end;
  }
end;

function TCustomBusinessDataProcessImpl.ExportToXls(
  const AFileName: string; const ADataTable: TDataTableAdapter): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ExportToXml(
  const AFileName: string): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ExportToXml(
  const AFileName: string; const ADataTable: TDataTableAdapter): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ExportToZip(
  const AFileName: string; const ADataTable: TDataTableAdapter): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ExportToZip(
  const AFileName: string): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ImportFromXls(
  const AFileName: string): Boolean;
begin
end;

function TCustomBusinessDataProcessImpl.ImportFromXls(
  const AFileName: string; const ADataTable: TDataTableAdapter): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ImportFromXml(
  const AFileName: string): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ImportFromXml(
  const AFileName: string; const ADataTable: TDataTableAdapter): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ImportFromZip(
  const AFileName: string; const ADataTable: TDataTableAdapter): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.ImportFromZip(
  const AFileName: string): Boolean;
begin

end;

function TCustomBusinessDataProcessImpl.GetDeleteSql(
  DataTable: TDataTableAdapter): string;
var
  FieldIndex:Integer;
  WhereSql:string;
begin
  Result:=EmptyStr;
  WhereSql:=EmptyStr;
  with DataTable.TableItem do
  begin
    case Attribute of
      taMain,taAttach:
      begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsKey)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end;
          end;
        end;
      end;
      taDetail:
      begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsLinkMaster)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end;
          end;
        end;
      end;
    end;
    Result:=DataTable.TableItem.GetDeleteSql(WhereSql);
  end;
end;

procedure TCustomBusinessDataProcessImpl.CreateDataTable;
var
  i,j,IndexTbl,IndexDictionary:integer;
  iField:TField;
  intLkCnt:integer;
  dxLk:TdxMemData;
begin

  for i:=0 to FModuleItem.TableItems.Count -1 do
  begin
    IndexTbl:=Tables.IndexOf(FModuleItem.TableItems.Tables[i].Code);
    if not FModuleItem.TableItems.Tables[i].IsCreateTable then exit ;
    
    DataTables[IndexTbl].DataSet.Close ;
    for j:=0 to FModuleItem.TableItems.Tables[i].FieldItems.Count -1 do
    begin
      with FModuleItem.TableItems.Tables[i].FieldItems[j] do
      begin
        if (CalcType= ctValue) or (CalcType= ctCache) then
        begin
          case DataType of
            dtBoolean:
              iField:=TBooleanField.Create(DataTables[IndexTbl].DataSet);
            dtInteger:
              iField:=TIntegerField.Create(DataTables[IndexTbl].DataSet);
            dtCurrency:
              iField:=TCurrencyField.Create(DataTables[IndexTbl].DataSet);    
            dtDouble:
            begin
              iField:=TFloatField.Create(DataTables[IndexTbl].DataSet);
              if EditFormat<>'' then
              begin
                TFloatField(iField).EditFormat :=EditFormat ;
                TFloatField(iField).DisplayFormat:=EditFormat ;
              end;
              if DisplayFormat<>'' then
                TFloatField(iField).DisplayFormat:=DisplayFormat ;
            end ;
            dtString:
            begin
              iField:=TStringField.Create(DataTables[IndexTbl].DataSet);
              iField.Size:=Size ;
            end ;
            dtWideString:
            begin
              iField:=TWideStringField.Create(DataTables[IndexTbl].DataSet);
              iField.Size:=Size ;
            end ;            
            dtMemo:
              iField:=TMemoField.Create(DataTables[IndexTbl].DataSet);
            dtDate:
              iField:=TDateField.Create(DataTables[IndexTbl].DataSet);
            dtTime:
              iField:=TTimeField.Create(DataTables[IndexTbl].DataSet);
            dtDateTime:
              iField:=TDateTimeField.Create(DataTables[IndexTbl].DataSet);
          end ;
          iField.FieldName:=FieldName;
          iField.Name:='dx'+FModuleItem.TableItems.Tables[i].Code+iField.FieldName;
          iField.DisplayLabel:=DisplayLabel;
          iField.Visible:=true;
          if CalcType= ctCache then
            iField.FieldKind :=fkCalculated ;
          iField.DataSet:=DataTables[IndexTbl].DataSet;
          iField.ReadOnly:=False;        
        end else if CalcType= ctLookUp then
        begin
          if IsAssociate then
          begin
            IndexDictionary:=MemDataDictionarys.IndexOf(Dictionary) ;
            if IndexDictionary<0 then continue ;
            
            //MemDataDictionarys.MemDatas[IndexDictionary].DataSet ; 
            case DataType of
              dtBoolean:
                iField:=TBooleanField.Create(DataTables[IndexTbl].DataSet);
              dtInteger:
                iField:=TIntegerField.Create(DataTables[IndexTbl].DataSet);
              dtCurrency:
                iField:=TCurrencyField.Create(DataTables[IndexTbl].DataSet);    
              dtDouble:
                iField:=TFloatField.Create(DataTables[IndexTbl].DataSet);
              dtString:
              begin
                iField:=TStringField.Create(DataTables[IndexTbl].DataSet);
                iField.Size:=Size ;
              end ;
              dtWideString:
              begin
                iField:=TWideStringField.Create(DataTables[IndexTbl].DataSet);
                iField.Size:=Size ;
              end ;               
              dtMemo:
                iField:=TMemoField.Create(DataTables[IndexTbl].DataSet);
              dtDate:
                iField:=TDateField.Create(DataTables[IndexTbl].DataSet);
              dtTime:
                iField:=TTimeField.Create(DataTables[IndexTbl].DataSet);
              dtDateTime:
                iField:=TDateTimeField.Create(DataTables[IndexTbl].DataSet);
            end ;
            iField.FieldName:=FieldName;
            iField.Name:=DataTables[IndexTbl].DataSet.Name+iField.FieldName;
            iField.DisplayLabel:=DisplayLabel;
            iField.Visible:=true;

                      
            iField.FieldKind:=fkLookup;
            iField.KeyFields:=KeyFieldName;
            iField.LookupDataSet:=MemDataDictionarys.MemDatas[IndexDictionary].DataSet;
            iField.LookupKeyFields:=LinkFieldName;
            iField.LookupResultField:=ShowField;
            iField.ReadOnly:=true;
            iField.DataSet:=DataTables[IndexTbl].DataSet;
          end ;
        end ;
      end ;
    end;
  end ;
  {
  with FModuleItem.TableItems do
  begin
    for Index:=0 to Count-1 do
    begin
      DataTable:=TDataTableAdapter.Create(Self);
      DataTable.Intialize(Tables[Index]);
      DataTable.FDataOwner:=Self;
      if (Tables[Index].Attribute=taMain)then
        FMasterTable:=DataTable;
      FTables.AddObject(Tables[Index].Code,DataTable);
    end;
  end;

  //主表
  //字段类型    '0'-string  '1'-int   '2'-float  '3'-datetime '4'-boolean
  MainTable.MainMemData.Close;
  for i:=low(MainTable.MainTInfo) to high(MainTable.MainTInfo) do
  begin
    try
      case StrToInt(MainTable.MainTInfo[i].strFldType) of
        0:
        begin
          iFld:=TStringField.Create(MainTable.MainMemData);
          iFld.Size:=MainTable.MainTInfo[i].intSize;
        end;
        1:
        begin
          iFld:=TFloatField.Create(MainTable.MainMemData);
          TFloatField(iFld).DisplayFormat:='#0';
          TFloatField(iFld).EditFormat:='#0';
        end;
        2:
        begin
          iFld:=TFloatField.Create(MainTable.MainMemData);
          if MainTable.MainTInfo[i].strSlJeDspMode='2' then
          begin
            TFloatField(iFld).DisplayFormat:=varInterface.CurDsp.DispFormat;
            TFloatField(iFld).EditFormat:=varInterface.CurDsp.EdtFormat;
            if varInterface.CurDsp.chrCur='1' then TFloatField(iFld).currency:=true;
          end;
          if MainTable.MainTInfo[i].strSlJeDspMode='3' then
          begin
            TFloatField(iFld).DisplayFormat:=varInterface.ZkDsp.DispFormat;
            TFloatField(iFld).EditFormat:=varInterface.ZkDsp.EdtFormat;
            //TFloatField(iFld).CustomConstraint:='x>=0 and x<=1';
            //TFloatField(iFld).ConstraintErrorMessage:='折扣选定范围在0..1之间！ ';
          end;
        end;
        3:
        begin
          iFld:=TDateTimeField.Create(MainTable.MainMemData);
        end;
        4:
        begin
          iFld:=TStringField.Create(MainTable.MainMemData);
        end;
        5:
        begin
          iFld:=TIntegerField.Create(MainTable.MainMemData);
        end;
      end;
      iFld.FieldName:=MainTable.MainTInfo[i].strFldName;
      iFld.Name:=MainTable.MainMemData.Name+iFld.FieldName;
      iFld.DisplayLabel:=MainTable.MainTInfo[i].strFldDisplay;
      iFld.Visible:=MainTable.MainTInfo[i].isShow;
      iFld.DataSet:=MainTable.MainMemData;
      iFld.ReadOnly:=False;//not MainTable.MainTInfo[i].isEdit;
    except
      on E: Exception do
      begin
        g_Error.strWho:=poiInterface^.User.strName;
        g_Error.strWhat:=E.Message;
        g_Error.strWhere:='TDjLayout.CreateMainTable setfield';
        g_Error.WriteErr;
      end;
    end;
    try
      if MainTable.MainTInfo[i].isAttach then
      begin
        if MainTable.MainTInfo[i].AttachDataSet<>nil then
        begin
          iFld:=TStringField.Create(MainTable.MainMemData);
          iFld.FieldName:=MainTable.MainTInfo[i].strFldName+'_A';
          iFld.Name:=MainTable.MainMemData.Name+iFld.FieldName;
          iFld.DisplayLabel:=MainTable.MainTInfo[i].strFldDisplay+'名称';
          iFld.Size := 50;
          iFld.FieldKind:=fkLookup;
          iFld.KeyFields:=MainTable.MainTInfo[i].strFldName;
          iFld.LookupDataSet:=MainTable.MainTInfo[i].AttachDataSet;
          iFld.LookupKeyFields:=MainTable.MainTInfo[i].AttachKeyField;
          iFld.LookupResultField:=MainTable.MainTInfo[i].AttachField;
          if not MainTable.MainTInfo[i].isShow then iFld.Visible:=false;
          iFld.ReadOnly:=true;
          iFld.DataSet:=MainTable.MainMemData;
        end
        else begin
          if VarIsArray(MainTable.MainTInfo[i].AttachItems) then
          begin
            intLkCnt:=MainTable.MainTInfo[i].AttachItems[0];
            for j:=0 to intLkCnt-1 do
            begin
              dxLk:=TdxMemData(DataMain.FindComponent(MainTable.MainTInfo[i].AttachItems[1][j]));
              iFld:=TStringField.Create(MainTable.MainMemData);
              iFld.FieldName:=MainTable.MainTInfo[i].strFldName+'_A'+inttostr(j);
              iFld.Name:=MainTable.MainMemData.Name+iFld.FieldName;
              iFld.DisplayLabel:=MainTable.MainTInfo[i].strFldDisplay+'名称'+inttostr(j);
              iFld.FieldKind:=fkLookup;
              iFld.KeyFields:=MainTable.MainTInfo[i].strFldName;
              iFld.LookupDataSet:=dxLk;
              iFld.LookupKeyFields:=MainTable.MainTInfo[i].AttachItems[2][j];
              iFld.LookupResultField:=MainTable.MainTInfo[i].AttachItems[3][j];
              if not MainTable.MainTInfo[i].isShow then iFld.Visible:=false;
              iFld.ReadOnly:=true;
              iFld.DataSet:=MainTable.MainMemData;
            end;  
            iFld:=TStringField.Create(MainTable.MainMemData);
            iFld.FieldName:=MainTable.MainTInfo[i].strFldName+'_A';
            iFld.Name:=MainTable.MainMemData.Name+iFld.FieldName;
            iFld.DisplayLabel:=MainTable.MainTInfo[i].strFldDisplay+'名称';
            iFld.FieldKind:=fkCalculated;
            if not MainTable.MainTInfo[i].isShow then iFld.Visible:=false;
            iFld.ReadOnly:=true;
            iFld.DataSet:=MainTable.MainMemData;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        g_Error.strWho:=poiInterface^.User.strName;
        g_Error.strWhat:=E.Message;
        g_Error.strWhere:='TDjLayout.CreateMainTable setattach';
        g_Error.WriteErr;
      end;
    end;
  end;
   }
end;

function TCustomBusinessDataProcessImpl.GetDetailData:boolean;
var
  Index:integer ;
  SqlText,strSqlWhere:string;
  Stmt:TClientDataSet;  
begin
  result:=false ;
  Stmt:=TClientDataSet.Create(nil);  
  try
    try
      with ModuleItem.TableItems do
      begin
        for Index:=0 to Count-1 do
        begin    
          if (Tables[Index].Attribute=taMain)then continue ;
          if not MasterTable.DataSet.Active or MasterTable.DataSet.IsEmpty then
            strSqlWhere :=EmptyStr
          else
            strSqlWhere:=GetDetailSqlWhere(Index) ;
          if strSqlWhere=EmptyStr then strSqlWhere:='1=2' ;

          SqlText:=Tables[Index].GetSelectSql(strSqlWhere,EmptyStr,Tables[Index].OrderByStr,False);
          if not SelectSql(SqlText,Stmt) then exit ;
          DataTables[Index].DataSet.DisableControls ;
          try
            DataTables[Index].DataSet.Data:=Stmt.Data;
            DataTables[Index].DataSet.First ;
          finally
            DataTables[Index].DataSet.EnableControls ;
          end ;
        end ;
      end;
      result:=true ;
    except
      on e:exception do
      begin
        FLastError:=e.Message ;
      end ;
    end ;
  finally
    Stmt.Free;
  end;
end;

function TCustomBusinessDataProcessImpl.GetMasterData(
  const AWhereSql: string):boolean;
var
  SqlText:string;
  Stmt:TClientDataSet;
begin
  result:=false ;
  FMasterWhereSql:=AWhereSql ;

  SqlText:=MasterTable.TableItem.GetSelectSql(AWhereSql,EmptyStr,MasterTable.TableItem.OrderByStr,False);
  if not SelectSql(SqlText,Stmt) then exit ;

  try
    MasterTable.DataSet.Data:=Stmt.Data;
    
    result:=true ;
  finally
    Stmt.Free;
  end;
end;

function TCustomBusinessDataProcessImpl.GetData(const AMasterWhereSql:string):boolean;
begin
  result:=false ;
  if not GetMasterData(AMasterWhereSql) then exit ;
  result:=GetDetailData ;
end;

function TCustomBusinessDataProcessImpl.GetDetailSqlWhere(
  ATableIndex: Integer): string;
var
  i:integer ;
  strWhere,strValue:string ;
begin
  strWhere:='' ;
  try
    with ModuleItem.TableItems.Tables[ATableIndex] do
    begin
      for i:=0 to FieldItems.Count-1 do
      begin
        if not FieldItems.Fields[i].IsLinkMaster then continue ;
        if Trim(FieldItems.Fields[i].MasterField)='' then continue ;
      
        case FieldItems.Fields[i].DataType of
          dtString,dtWideString:
            strValue:=QuotedStr(MasterTable.DataSet.fieldByName(FieldItems.Fields[i].MasterField).AsString) ;
          else
            strValue:=MasterTable.DataSet.fieldByName(FieldItems.Fields[i].MasterField).AsString ;
        end ;

        if Trim(strValue)<>'' then
        begin
          if strWhere='' then
            strWhere:=Code +'.'+FieldItems.Fields[i].FieldName+ '=' + strValue 
          else
            strWhere:=strWhere +' and '+ Code +'.'+FieldItems.Fields[i].FieldName+ '=' + strValue ;
        end ;
      end ;
    end ;
  except
    on e:exception do
    begin
      strWhere:='' ;
      FLastError:=e.Message ;
    end ;
  end ;
  result:=strWhere ;
end;

procedure TCustomBusinessDataProcessImpl.Edited(
  ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnEdited)then
    FOnEdited(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.Editing(
  ADataAdapter: TDataTableAdapter);
begin
  if Assigned(FOnEditing)then
    FOnEditing(ADataAdapter);
end;

procedure TCustomBusinessDataProcessImpl.EditMastered(isEdited: Boolean);
begin
  if Assigned(FOnEditAlled)then
    FOnEditAlled(Self,isEdited);
end;

procedure TCustomBusinessDataProcessImpl.EditMastering(
  var AllowEdit: Boolean);
begin
  AllowEdit:=true ;
  if Assigned(FOnEditAlling)then
    FOnEditAlling(Self,AllowEdit);
end;

procedure TCustomBusinessDataProcessImpl.AppendMastered(isAppended: Boolean);
begin
  if Assigned(FOnAppendAlled)then
    FOnAppendAlled(Self,isAppended);
end;

procedure TCustomBusinessDataProcessImpl.AppendMastering(
  var AllowAppend: Boolean);
begin
  AllowAppend:=true ;
  if Assigned(FOnAppendAlling)then
    FOnAppendAlling(Self,AllowAppend);
end;

function TCustomBusinessDataProcessImpl.SetKeyFieldValue: boolean;
var
  i:integer ;
  strKeyField:string ;
  iKeyValue:integer ;
begin
  result:=false ;
  for i:=0 to MasterTable.TableItem.FieldKeys.Count -1 do
  begin
    strKeyField:=MasterTable.TableItem.FieldKeys.Strings[i] ;
    with MasterTable.TableItem.FieldItems.LookUp(strKeyField) do
    begin
      if Trim(MasterField)='' then
      begin
        result:=True ;
        exit ;
      end ;
      if not MasterTable.DataSet.FieldByName(strKeyField).IsNull then
        break ;
      iKeyValue:=GetKeyFieldValue(MasterField) ;
      MasterTable.DataSet.FieldByName(strKeyField).AsInteger :=iKeyValue ;
    end ;
  end ;
  SetDetailKeyFieldValue ;
  result:=true ; 

end;

function TCustomBusinessDataProcessImpl.GetKeyFieldValue(AKeyCode:string): integer;
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

procedure TCustomBusinessDataProcessImpl.DataBinDings(ATableIndex: Integer;
  AParentControl: TWinControl);
var
  i:integer ;
begin
  if AParentControl.ClassType =TDBEdit then
  begin
    TDBEdit(AParentControl).DataSource :=DataTables[ATableIndex].DataSource;
    exit ;
  end else if AParentControl.ClassType =TDBGridEh then
  begin
    TDBGridEh(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TDBDateTimeEditEh then
  begin
    TDBDateTimeEditEh(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TDBComboBoxEh then
  begin
    TDBComboBoxEh(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TdxDBLookupEdit then
  begin
    TdxDBLookupEdit(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TDBComboBox then
  begin
    TDBComboBox(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TDBMemo then
  begin
    TDBMemo(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TDBCheckBox then
  begin
    TDBCheckBox(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TRzDBButtonEdit then
  begin
    TRzDBButtonEdit(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TRzDBLookupComboBox then
  begin
    TRzDBLookupComboBox(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TRzDBComboBox then
  begin
    TRzDBComboBox(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end else if AParentControl.ClassType =TTntDBComboBox then
  begin
    TTntDBComboBox(AParentControl).DataSource :=DataTables[ATableIndex].DataSource ;
    exit ;
  end ;


  for i:=0 to AParentControl.ControlCount -1 do
  begin
    if (AParentControl.Controls[i].ClassType =TTntGroupBox)
      or (AParentControl.Controls[i].ClassType =TGroupBox)
      or (AParentControl.Controls[i].ClassType =TPanel)
      or (AParentControl.Controls[i].ClassType =TTntPanel)
    then
      DataBinDings(ATableIndex,TWinControl(AParentControl.Controls[i])) 
    else if AParentControl.Controls[i].ClassType =TDBEdit then
      TDBEdit(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource 
    else if AParentControl.Controls[i].ClassType =TDBGridEh then
      TDBGridEh(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource
    else if AParentControl.Controls[i].ClassType =TDBDateTimeEditEh then
      TDBDateTimeEditEh(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource
    else if AParentControl.Controls[i].ClassType =TDBComboBoxEh then
      TDBComboBoxEh(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource 
    else if AParentControl.Controls[i].ClassType =TdxDBLookupEdit then
      TdxDBLookupEdit(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource 
    else if AParentControl.Controls[i].ClassType =TDBComboBox then
      TDBComboBox(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource 
    else if AParentControl.Controls[i].ClassType =TDBMemo then
      TDBMemo(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource
    else if AParentControl.Controls[i].ClassType =TRzDBButtonEdit then
      TRzDBButtonEdit(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource
    else if AParentControl.Controls[i].ClassType =TRzDBComboBox then
      TRzDBComboBox(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource               
    else if AParentControl.Controls[i].ClassType =TDBCheckBox then
      TDBCheckBox(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource
    else if AParentControl.Controls[i].ClassType =TTntDBComboBox then
      TTntDBComboBox(AParentControl.Controls[i]).DataSource :=DataTables[ATableIndex].DataSource ;

  end ;
end;

function TCustomBusinessDataProcessImpl.DataTableOfTableName(
  ATableName: string): TDataTableAdapter;
var
  index:integer ;
begin
  result:=nil ;
  index:=FTables.IndexOf(ATableName) ;
  if index =-1 then exit ;
  result :=GetDataTables(index) ;
end;

function TCustomBusinessDataProcessImpl.IndexOfTableName(
  const ATableName: string): Integer;
begin
  result:=Tables.IndexOf(ATableName) ; 
end;

function TCustomBusinessDataProcessImpl.SetDetailKeyFieldValue: boolean;
var
  i,j:integer ;
  strFieldName,strMasterField:string ;
  bk:TbookMark ;
  isFiltered:boolean ;
begin
  if TableCount<=1 then exit ;
  for i:=0 to TableCount -1 do
  begin
    if DataTables[i].TableItem.Attribute=taMain then continue ;
    DataTables[i].DataSet.DisableControls;
    bk:=DataTables[i].DataSet.GetBookmark ;
    DataTables[i].DataSet.First ;
    isFiltered:=DataTables[i].DataSet.Filtered ;
    DataTables[i].DataSet.Filtered:=false ;
    while not DataTables[i].DataSet.Eof do
    begin
      DataTables[i].DataSet.Edit ;
      for j:=0 to DataTables[i].TableItem.FieldItems.Count -1 do
      begin
        if not DataTables[i].TableItem.FieldItems.Fields[j].IsLinkMaster then continue ;
        strFieldName:=DataTables[i].TableItem.FieldItems.Fields[j].FieldName ;
        strMasterField:=DataTables[i].TableItem.FieldItems.Fields[j].MasterField ; 
        DataTables[i].DataSet.FieldByName(strFieldName).Value :=MasterTable.DataSet.FieldByName(strMasterField).Value ;
      end ;
      DataTables[i].DataSet.Post ;
      DataTables[i].DataSet.Next ;
    end ;
    DataTables[i].DataSet.Filtered:=isFiltered ;
    DataTables[i].DataSet.GotoBookmark(bk) ; 
    DataTables[i].DataSet.EnableControls ;
  end ; 
end;

procedure TCustomBusinessDataProcessImpl.DeleteAlled(ADeleted: Boolean);
begin
  if Assigned(FOnDeleteAlled)then
    FOnDeleteAlled(Self,ADeleted);
end;

procedure TCustomBusinessDataProcessImpl.DeleteAlling(
  var AllowDelete: Boolean);
begin
  if Assigned(FOnDeleteAlling)then
    FOnDeleteAlling(Self,AllowDelete);
end;

function TCustomBusinessDataProcessImpl.SaveSingle(AtableIndex:integer;var ADataSet:TClientDataSet): Boolean;
var
  Index,KeyIndex:Integer;
  Request:TDataApplyUpdateRequest;
  RequestItem:TDataApplyUpdateItem;
  Reply:TCustomServerReply;
  ExecSql:string;
  AllowSubmit:Boolean;
  function GetModifyData:OleVariant;
  begin
    try
      Result:=ADataSet.Delta;
    except
      Result:=NULL;
    end;
  end;
  function GetSaveSql:string;
  var
    FieldIndex:integer ;
    WhereSql:String ;
  begin
    result:=EmptyStr ;
    with DataTables[AtableIndex].TableItem do
    begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsKey)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(ADataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(ADataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end;
          end;
        end;
        Result:=GetSelectSql(WhereSql,EmptyStr,EmptyStr,False);
    end ;
  end ;
begin
  Result:=False;
  AllowSubmit:=True;
  SaveAlling(AllowSubmit);
  if not AllowSubmit then Exit;
  Request:=TDataApplyUpdateRequest.Create;
  try
    Request.Initialize;
    Request.OperateType:=odtUpdate;
    Request.RequestUser:='000';
    Request.RequestIP:='127.0.0.1';
    Request.Computer:='';
    //Request.ServiceGuid:=DataApplyUpdateServiceGuid;
    
    RequestItem:=Request.CreateRequestItem;
    RequestItem.ExecType:=etData;
    RequestItem.TableName:=DataTables[AtableIndex].TableItem.Code;
    RequestItem.TableAttr:=DataTables[AtableIndex].TableItem.Attribute;
    ExecSql:=GetSaveSql;
    RequestItem.ExecSql:=ExecSql;
    RequestItem.Data:=GetModifyData;
    RequestItem.UpdateMode:=upWhereKeyOnly;
    with DataTables[AtableIndex].TableItem.FieldItems do
    begin
      for KeyIndex:=0 to Count -1 do
        if Fields[KeyIndex].IsKey then
          RequestItem.Add(Fields[KeyIndex].FieldName,[pfInKey]);
    end;
    Result:=_Environment.DataAccess.ExecuteRequest(Request,Reply);
    if(Result)then
    begin
      ADataSet.Reconcile(NULL);
    end else
    begin
      FLastError:=_Environment.DataAccess.LastError ;
    end ;
    SaveAlled(Result);
  finally
    Request.Free;
  end;

end;

function TCustomBusinessDataProcessImpl.GetDetailNextSeq(ATableName,
  AFieldName: string): integer;
var
  iSeq:integer ;
  bk:TbookMark ;
begin
  iSeq:=0 ;
  with DataTableOfTableName(ATableName).DataSet do
  begin
    DisableControls;
    try
      bk:=GetBookmark ;
      First;
      while not eof do
      begin
        if iSeq< fieldByName(AFieldName).AsInteger then
          iSeq:= fieldByName(AFieldName).AsInteger;
        next ;
      end;
      GotoBookmark(bk) ;
    finally
      EnableControls;
    end ;
  end ;
  result:=iSeq ;
end;

function TCustomBusinessDataProcessImpl.GetSaveWhere(
  DataTable: TDataTableAdapter): string;
var
  FieldIndex:Integer;
  WhereSql:string;
begin
  Result:=EmptyStr;
  WhereSql:=EmptyStr;
  with DataTable.TableItem do
  begin
    case Attribute of
      taMain,taAttach:
      begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsKey)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(DataTable.DataSet.FieldByname(FieldItems[FieldIndex].FieldName).AsString);
            end;
          end;
        end;
      end;
      taDetail:
      begin
        for FieldIndex:=0 to FieldItems.Count -1 do
        begin
          if(FieldItems[FieldIndex].IsLinkMaster)then
          begin
            if(WhereSql=EmptyStr)then
            begin
              WhereSql:=FieldItems[FieldIndex].FieldName+'='+
                QuotedStr(MasterTable.DataSet.FieldByname(FieldItems[FieldIndex].MasterField).AsString);
            end else
            begin
              WhereSql:=WhereSql+' and '+FieldItems[FieldIndex].FieldName+'='+
               QuotedStr(MasterTable.DataSet.FieldByname(FieldItems[FieldIndex].MasterField).AsString);
            end;
          end;
        end;
      end;
    end;
  end;
  Result:=WhereSql ;
end;

function TCustomBusinessDataProcessImpl.IndexOfMaster: Integer;
begin
  result:=Tables.IndexOf(FMasterTable.TableItem.Code) ; 
end;

procedure TCustomBusinessDataProcessImpl.CreateDataTable(AIndex: integer;
  var ADataSet: TClientDataSet);
var
  j,IndexDictionary:integer;
  iField:TField;
  intLkCnt:integer;
  dxLk:TdxMemData;
begin
  ADataSet.Close ;
  for j:=0 to FModuleItem.TableItems.Tables[AIndex].FieldItems.Count -1 do
  begin
    with FModuleItem.TableItems.Tables[AIndex].FieldItems[j] do
    begin
      if (CalcType= ctValue) or (CalcType= ctCache) then
      begin
        case DataType of
          dtBoolean:
            iField:=TBooleanField.Create(ADataSet);
          dtInteger:
            iField:=TIntegerField.Create(ADataSet);
          dtCurrency:
            iField:=TCurrencyField.Create(ADataSet);    
          dtDouble:
          begin
            iField:=TFloatField.Create(ADataSet);
            if EditFormat<>'' then
            begin
              TFloatField(iField).EditFormat :=EditFormat ;
              TFloatField(iField).DisplayFormat:=EditFormat ;
            end;
            if DisplayFormat<>'' then
              TFloatField(iField).DisplayFormat:=DisplayFormat ;
          end ;
          dtString:
          begin
            iField:=TStringField.Create(ADataSet);
            iField.Size:=Size ;
          end ;
          dtWideString:
          begin
            iField:=TWideStringField.Create(ADataSet);
            iField.Size:=Size ;
          end ;            
          dtMemo:
            iField:=TMemoField.Create(ADataSet);
          dtDate:
            iField:=TDateField.Create(ADataSet);
          dtTime:
            iField:=TTimeField.Create(ADataSet);
          dtDateTime:
            iField:=TDateTimeField.Create(ADataSet);
        end ;
        iField.FieldName:=FieldName;
        iField.Name:='dx'+ADataSet.Name+iField.FieldName;
        iField.DisplayLabel:=DisplayLabel;
        iField.Visible:=true;
        if CalcType= ctCache then
          iField.FieldKind :=fkCalculated ;
        iField.DataSet:=ADataSet;
        iField.ReadOnly:=False;        
      end else if CalcType= ctLookUp then
      begin
        if IsAssociate then
        begin
          IndexDictionary:=MemDataDictionarys.IndexOf(Dictionary) ;
          if IndexDictionary<0 then continue ;
            
          //MemDataDictionarys.MemDatas[IndexDictionary].DataSet ; 
          case DataType of
            dtBoolean:
              iField:=TBooleanField.Create(ADataSet);
            dtInteger:
              iField:=TIntegerField.Create(ADataSet);
            dtCurrency:
              iField:=TCurrencyField.Create(ADataSet);
            dtDouble:
              iField:=TFloatField.Create(ADataSet);
            dtString:
            begin
              iField:=TStringField.Create(ADataSet);
              iField.Size:=Size ;
            end ;
            dtWideString:
            begin
              iField:=TWideStringField.Create(ADataSet);
              iField.Size:=Size ;
            end ;               
            dtMemo:
              iField:=TMemoField.Create(ADataSet);
            dtDate:
              iField:=TDateField.Create(ADataSet);
            dtTime:
              iField:=TTimeField.Create(ADataSet);
            dtDateTime:
              iField:=TDateTimeField.Create(ADataSet);
          end ;
          iField.FieldName:=FieldName;
          iField.Name:=ADataSet.Name+iField.FieldName;
          iField.DisplayLabel:=DisplayLabel;
          iField.Visible:=true;

                      
          iField.FieldKind:=fkLookup;
          iField.KeyFields:=KeyFieldName;
          iField.LookupDataSet:=MemDataDictionarys.MemDatas[IndexDictionary].DataSet;
          iField.LookupKeyFields:=LinkFieldName;
          iField.LookupResultField:=ShowField;
          iField.ReadOnly:=true;
          iField.DataSet:=ADataSet;
        end ;
      end ;
    end ;
  end;
end;

procedure TCustomBusinessDataProcessImpl.CreateDataTable(AIndex: integer;
  var ADataSet: TdxMemData);
var
  j,IndexDictionary:integer;
  iField:TField;
  intLkCnt:integer;
  dxLk:TdxMemData;
begin
  ADataSet.Close ;
  for j:=0 to FModuleItem.TableItems.Tables[AIndex].FieldItems.Count -1 do
  begin
    with FModuleItem.TableItems.Tables[AIndex].FieldItems[j] do
    begin
      if (CalcType= ctValue) or (CalcType= ctCache) then
      begin
        case DataType of
          dtBoolean:
            iField:=TBooleanField.Create(ADataSet);
          dtInteger:
            iField:=TIntegerField.Create(ADataSet);
          dtCurrency:
            iField:=TCurrencyField.Create(ADataSet);    
          dtDouble:
          begin
            iField:=TFloatField.Create(ADataSet);
            if EditFormat<>'' then
            begin
              TFloatField(iField).EditFormat :=EditFormat ;
              TFloatField(iField).DisplayFormat:=EditFormat ;
            end;
            if DisplayFormat<>'' then
              TFloatField(iField).DisplayFormat:=DisplayFormat ;
          end ;
          dtString:
          begin
            iField:=TStringField.Create(ADataSet);
            iField.Size:=Size ;
          end ;
          dtWideString:
          begin
            iField:=TWideStringField.Create(ADataSet);
            iField.Size:=Size ;
          end ;            
          dtMemo:
            iField:=TMemoField.Create(ADataSet);
          dtDate:
            iField:=TDateField.Create(ADataSet);
          dtTime:
            iField:=TTimeField.Create(ADataSet);
          dtDateTime:
            iField:=TDateTimeField.Create(ADataSet);
        end ;
        iField.FieldName:=FieldName;
        iField.Name:='dx'+ADataSet.Name+iField.FieldName;
        iField.DisplayLabel:=DisplayLabel;
        iField.Visible:=true;
        if CalcType= ctCache then
          iField.FieldKind :=fkCalculated ;
        iField.DataSet:=ADataSet;
        iField.ReadOnly:=False;        
      end else if CalcType= ctLookUp then
      begin
        if IsAssociate then
        begin
          IndexDictionary:=MemDataDictionarys.IndexOf(Dictionary) ;
          if IndexDictionary<0 then continue ;
            
          //MemDataDictionarys.MemDatas[IndexDictionary].DataSet ; 
          case DataType of
            dtBoolean:
              iField:=TBooleanField.Create(ADataSet);
            dtInteger:
              iField:=TIntegerField.Create(ADataSet);
            dtCurrency:
              iField:=TCurrencyField.Create(ADataSet);
            dtDouble:
              iField:=TFloatField.Create(ADataSet);
            dtString:
            begin
              iField:=TStringField.Create(ADataSet);
              iField.Size:=Size ;
            end ;
            dtWideString:
            begin
              iField:=TWideStringField.Create(ADataSet);
              iField.Size:=Size ;
            end ;               
            dtMemo:
              iField:=TMemoField.Create(ADataSet);
            dtDate:
              iField:=TDateField.Create(ADataSet);
            dtTime:
              iField:=TTimeField.Create(ADataSet);
            dtDateTime:
              iField:=TDateTimeField.Create(ADataSet);
          end ;
          iField.FieldName:=FieldName;
          iField.Name:=ADataSet.Name+iField.FieldName;
          iField.DisplayLabel:=DisplayLabel;
          iField.Visible:=true;

                      
          iField.FieldKind:=fkLookup;
          iField.KeyFields:=KeyFieldName;
          iField.LookupDataSet:=MemDataDictionarys.MemDatas[IndexDictionary].DataSet;
          iField.LookupKeyFields:=LinkFieldName;
          iField.LookupResultField:=ShowField;
          iField.ReadOnly:=true;
          iField.DataSet:=ADataSet;
        end ;
      end ;
    end ;
  end;

end;

function TCustomBusinessDataProcessImpl.RollBackKeyId(AKeyCode: string;
  AKeyID: integer): boolean;
var
  SqlText:string;
begin
  result:=false;
  SqlText:=' exec @KeyId='+DefaultRollBackKeyIdProcedureName+' '+Quotedstr(AKeyCode)+','+inttostr(AKeyID);
  try
    result:=_Environment.DataAccess.ExecuteSql(SqlText) ;
    if not result then
    begin
      Debugger.WriteLine(nil,'HomeLikeErp','RollBackKeyId:'+_Environment.DataAccess.LastError);
    end ;
  finally
  end;

end;

{ TDataTableAdapter }

function TDataTableAdapter.Append: Boolean;
begin
  try
    DataOwner.Appending(Self);
    Result:=DoAppend;
    DataOwner.Appended(Self);
  except
    on E:Exception do
    begin
      Result:=FAlse;
    end;
  end;
end;

function TDataTableAdapter.Cnacel: Boolean;
begin
  try
    DataOwner.Canceling(Self);
    Result:=DoCnacel;
    DataOwner.Canceled(Self);
  except
    on E:Exception do
    begin
      Result:=False;
    end;
  end;
end;

constructor TDataTableAdapter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFields:=TStringList.Create;
  FFields.Sorted:=True;
  FDataSource:=TDataSource.Create(Self);
  FDataSet:=TClientDataSet.Create(Self);
  FDataSource.DataSet:=FDataSet;
end;

function TDataTableAdapter.Delete: Boolean;
begin
  try
    DataOwner.Deleteing(Self);
    Result:=DoDelete;
    DataOwner.Deleted(Self);
  except
    on E:Exception do
    begin
      Result:=False;
    end;
  end;
end;

destructor TDataTableAdapter.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TDataTableAdapter.DoAppend: Boolean;
begin
  DataSet.Append;
  //Summary:
  // 处理初始化值。
  Result:=True;
end;

function TDataTableAdapter.DoCnacel: Boolean;
begin
  DataSet.CancelUpdates;
end;

function TDataTableAdapter.DoDelete: Boolean;
begin
  case TableItem.Attribute of
    taMain:Dataset.Delete;
    taAttach:DataSet.Delete;
    taDetail:DataSet.EmptyDataSet;
  end;
  Result:=True;
end;

function TDataTableAdapter.DoEdit: Boolean;
begin
  DataSet.Edit;
  Result:=True;
end;

function TDataTableAdapter.DoPost: Boolean;
begin
  DataSet.Post;
  Result:=True;
end;


function TDataTableAdapter.Edit: Boolean;
begin
  try
    DataOwner.Editing(SElf);
    Result:=DoEdit;
    DataOwner.Edited(Self);
  except
    on E:Exception do
    begin
      Result:=False;
    end;
  end;
end;

function TDataTableAdapter.GetFieldAdapters(Index: Integer): TFieldAdapter;
begin
  Result:=TFieldAdapter(FFields.Objects[Index]);
end;

function TDataTableAdapter.GetFieldCount: Integer;
begin
  Result:=FFields.Count;
end;

procedure TDataTableAdapter.Intialize(ATableItem: TTableItem);
var
  Field:TFieldAdapter;
  Index:Integer;
begin
  FTableItem:=ATableItem;
  with FTableItem.FieldItems do
  begin
    for Index:=0 to Count -1 do
    begin
      Field:=TFieldAdapter.Create(Self);
      Field.Intialize(Fields[Index]);
      Field.FTableOwner:=Self;
      FFields.AddObject(Fields[Index].FieldName,Field);
    end;
  end;
end;


function TDataTableAdapter.Post: Boolean;
begin
  try
    DataOwner.Posting(SElf);
    Result:=DoPost;
    DataOwner.Posted(SElf);
  except
    on E:Exception do
    begin
      Result:=False;
    end;
  end;
end;

{ TFieldAdapter }

constructor TFieldAdapter.Create(AComponent: TComponent);
begin
  inherited Create(AComponent);
end;

destructor TFieldAdapter.Destroy;
begin
  inherited;
end;

procedure TFieldAdapter.Intialize(AFieldItem: TFieldItem);
begin
  FFieldItem:=AFieldItem;
end;

{ TCustomBillDocDataProcessImpl }

constructor TCustomBillDocDataProcessImpl.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TCustomBillDocDataProcessImpl.Destroy;
begin

  inherited;
end;

procedure TCustomBillDocDataProcessImpl.Initialize(
  AModuleItem: TModuleItem);
begin
  inherited;
end;

end.
