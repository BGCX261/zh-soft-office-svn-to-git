{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:���ݴ��������ࡣ                                                 }
{ @@Description:                                                             }
{ @@Author: Suntogether                                                      }
{ @@Version:1.0                                                              }
{ @@Create:2007-02-02                                                        }
{ @@Remarks:                                                                 }
{ @@Modify:                                                                  }
{****************************************************************************}

unit MarshalImpl;

interface

uses Classes,Sysutils,BasalMarshal,KeyPairDictionary,DBClient,DB,AdoDB,CoreImpl;

type
  //Summary:
  // ����ִ������
  // etSQL:ִ��SQL���
  // etData:ִ������
  TExecuteType=(etSql,etData);
  //Summary:
  //���ݴ�������
  //  odtAppend:���
  //  odtUpdate:����
  //  odtDelete:ɾ��
  TOperateDataType=(odtAppend,odtUpdate,odtDelete);
  
  TCustomClientRequest=class(TClientRequestPersistent);
  TCustomServerReply=class(TServerReplyPersistent);


  //Summary:
  // ApplyUpdate ��ص���ͺ���
  TDataApplyUpdateItem=class(TCollectionItem)
  private
    FExecType: TExecuteType;
    FData: OleVariant;
    FTableName: string;
    FExecSql: string;
    FUpdateMode: TUpdateMode;
    FList: TKeyIntDictionary;
    FTableAttr: TTableAttribute;
    function GetCount: Integer;
    function GetFields(Index: Integer): string;
    function GetFlags(Index: Integer): TProviderFlags;
  protected
    function IntToProviderFlags(Value:Integer):TProviderFlags;
    function ProviderFlagsToInt(Value:TProviderFlags):Integer;
    property List:TKeyIntDictionary read FList;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    //Summary:
    // ������е��ֶ������Ϣ�б�
    procedure Clear;
    //Summary:
    // ���һ����Ϣ�ֶ��б�
    function Add(const AFieldName:string;const AFlags:TProviderFlags):Integer;
    //Summary:
    // ͨ���ֶ�����λ�����б������δ֪
    function IndexOf(const AFieldName:string):Integer;
    //Summary:
    // �����ֶ���Ϣ�б�
    function Find(const AFieldName:string;var Index:Integer):Boolean;
    //Summary:
    // �����ֶ����Ʒ����ֶεĸ���ģʽ��Ϣ
    function ValueByName(AFieldName:string):TProviderFlags;
    //Summary:
    // ɾ��ָ��λ�õ��ֶ���Ϣ
    procedure Delete(const Index:Integer);
    //Summary:
    // �����ֶ�����ɾ��
    procedure Remove(const AFieldName:string);
    //Summary:
    // ����ִ�����ݵ�����
    //  etSql:ִ��SQL���
    //  etData:ִ������,����DataProvider.ApplyDatas
    property ExecType:TExecuteType read FExecType write FExecType;
    //Summary:
    // ��Ҫ���������ݱ�
    property TableName:string read FTableName write FTableName;
    //Summary:
    // ������
    property TableAttr:TTableAttribute read FTableAttr write FTableAttr;
    //Summary:
    // ִ�е�SQL���
    // ���etSQL,������Insert,Ҳ������Update
    // ���etData,һ����select
    property ExecSql:string read FExecSql write FExecSql;
    //Summary:
    // ��Ҫ���µ�����
    property Data:OleVariant read FData write FData;
    //Summary:
    // ���ݱ�ĸ���ģʽ
    property UpdateMode:TUpdateMode read FUpdateMode write FUpdateMode;
    //Summary:
    // ��Ҫ�����ֶε�flag���ֶ�����
    property Fields[Index:Integer]:string read GetFields;default;
    //Summary:
    // �ֶθ��µ�ģʽ
    property Flags[Index:Integer]:TProviderFlags read GetFlags;
    //Summary:
    // ���и���ģʽ�ֶε�����
    property Count:Integer read GetCount;
  end;
  //Summary:
  //  ������������ݴ˱�������,����,��ϸ����������,
  //  ����д��Ӧ�ķ���Ҫ���ٲ�������,��ȷ����ִ�б�
  //  ��˳��.
  // ���� Append,Update Ҫ��ִ������,����Ȼ����ϸ��
  // �����Delete Ҫִ����ϸ��,����,���������.         
  TDataApplyUpdateRequest=class(TCustomClientRequest)
  private
    FComputer: string;
    FRequestIP: string;
    FRequestUser: string;
    FOperateType: TOperateDataType;
    FCollection: TCollection;
    function GetCount: Integer;
    function GetItems(Index: Integer): TDataApplyUpdateItem;
  protected
    property Collection:TCollection read FCollection;  
  public
    constructor Create;
    destructor Destroy;override;
    //Summary:
    // ��ʼ����������Ҫ���������ڵ������������ʱ��,�����ʼ��.
    procedure Initialize;override;
    //Summary:
    // ����һ�����ݲ���������������ݽڵ�
    function CreateRequestItem:TDataApplyUpdateItem;overload;
    //Summary:
    // ����һ�����ݲ�����������ڵ�
    function CreateRequestItem(
      AExecType:TExecuteType;
      ATableName:string;
      ATableAttr:TTableAttribute;
      AExecSql:string;
      Data:OleVariant;
      AUpdateMode:TUpdateMode):TDataApplyUpdateItem;overload;
    //Summary:
    // ɾ��һ����������
    procedure Delete(const Index:Integer);
    //Summary:
    // ���ݱ���ɾ��һ����������
    procedure Remove(const ATableName:string);
    function IndexOf(const ATableName:string):Integer;
    //Summary:
    // ���ݸ��µı���,���������������.
    function Search(const ATableName:string):TDataApplyUpdateItem;
    //Summary:
    // ��������ݽڵ�
    property Items[Index:Integer]:TDataApplyUpdateItem read GetItems;default;
    //Summary:
    // ��Ҫ���������������.
    property Count:Integer read GetCount;
    //Summary:
    // �����û�
    property RequestUser:string read FRequestUser write FRequestUser;
    // Summary
    // ����ļ��������
    property Computer:string read FComputer write FComputer;
    //Summary:
    // ����ļ����IP
    property RequestIP:string read FRequestIP write FRequestIP;
    //Summmary:
    // ��������ݴ�������.
    property OperateType:TOperateDataType read FOperateType write FOperateType;
  end;


  TDataApplyUpdateReply=class(TCustomServerReply)
  private
    FErrorMsg: string;
  public
    property ErrorMsg:string read FErrorMsg write FErrorMsg;
  end;


implementation

const
  ProviderFlagInUpdate  =$00000001;
  ProviderFlagInWhere   =$00000002;
  ProviderFlagInKey     =$00000004;
  ProviderFlagHidden    =$00000008;
{ TDataApplyUpdateItem }

function TDataApplyUpdateItem.Add(const AFieldName: string;
  const AFlags: TProviderFlags): Integer;
begin
  if Find(AFieldName,Result)then
  begin
    FList.Values[Result]:=ProviderFlagsToInt(AFlags);
  end else
  begin
    Result:=FList.Add(AFieldName,ProviderFlagsToInt(AFlags));
  end;
end;

procedure TDataApplyUpdateItem.Clear;
begin
  FList.Clear;
end;

constructor TDataApplyUpdateItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FList:=TKeyIntDictionary.Create(nil);
  FList.Sorted:=True;
end;

procedure TDataApplyUpdateItem.Delete(const Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TDataApplyUpdateItem.Destroy;
begin
  inherited;
end;

function TDataApplyUpdateItem.Find(const AFieldName: string;
  var Index: Integer): Boolean;
begin
  Result:=FList.Find(AFieldName,Index);
end;

function TDataApplyUpdateItem.GetCount: Integer;
begin
  Result:=FList.Count;
end;

function TDataApplyUpdateItem.GetFields(Index: Integer): string;
begin
  Result:=FList.Names[Index];
end;

function TDataApplyUpdateItem.GetFlags(Index: Integer): TProviderFlags;
begin
  Result:=IntToProviderFlags(List.Values[Index]);
end;

function TDataApplyUpdateItem.IndexOf(const AFieldName: string): Integer;
begin

end;

function TDataApplyUpdateItem.IntToProviderFlags(
  Value: Integer): TProviderFlags;
begin
  Result:=[];
  if(Value and ProviderFlagInUpdate=ProviderFlagInUpdate)then
    Result:=Result+[pfInUpdate];
  if(Value and ProviderFlagInWhere=ProviderFlagInWhere)then
    Result:=Result+[pfInWhere];
  if(Value and ProviderFlagInKey=ProviderFlagInKey)then
    Result:=Result+[pfInKey];
  if(Value and ProviderFlagHidden=ProviderFlagHidden)then
    Result:=Result+[pfHidden];
end;

function TDataApplyUpdateItem.ProviderFlagsToInt(
  Value: TProviderFlags): Integer;
begin
  Result:=0;
  if (pfInUpdate in Value)then
    Result:=Result or ProviderFlagInUpdate;
  if (pfInWhere in Value)then
    Result:=Result or ProviderFlagInWhere;
  if (pfInKey in Value)then
    Result:=Result or ProviderFlagInKey;
  if (pfHidden in Value)then
    Result:=Result or ProviderFlagHidden;
end;

procedure TDataApplyUpdateItem.Remove(const AFieldName: string);
var
  Index:Integer;
begin
  Index:=FList.IndexOf(AFieldName);
  if(Index>=0)then
    FList.Delete(Index);
end;

function TDataApplyUpdateItem.ValueByName(
  AFieldName: string): TProviderFlags;
var
  Index:Integer;
begin
  Result:=[];
  Index:=IndexOf(AFieldName);
  if(Index>=0)then
    Result:=IntToProviderFlags(FList.Values[Index]);
end;

{ TDataApplyUpdateRequest }


{ TDataApplyUpdateRequest }

constructor TDataApplyUpdateRequest.Create;
begin
  inherited Create;
end;

function TDataApplyUpdateRequest.CreateRequestItem(AExecType: TExecuteType;
  ATableName: string; ATableAttr: TTableAttribute; AExecSql: string;
  Data: OleVariant; AUpdateMode: TUpdateMode): TDataApplyUpdateItem;
begin
  Result:=CreateRequestItem;
  Result.ExecType:=AExecType;
  Result.TableName:=ATableName;
  Result.TableAttr:=ATableAttr;
  Result.ExecSql:=AExecSql;
  Result.Data:=Data;
  Result.UpdateMode:=AUpdateMode;
end;

function TDataApplyUpdateRequest.CreateRequestItem: TDataApplyUpdateItem;
begin
  Result:=FCollection.Add as TDataApplyUpdateItem;
end;

procedure TDataApplyUpdateRequest.Delete(const Index: Integer);
begin
  if(Index>=0)and(Index<Count)then
    FCollection.Delete(Index);
end;

destructor TDataApplyUpdateRequest.Destroy;
begin
  if FCollection<>nil then
    FreeAndNil(FCollection);
  inherited;
end;

function TDataApplyUpdateRequest.GetCount: Integer;
begin
  Result:=FCollection.Count;
end;

function TDataApplyUpdateRequest.GetItems(
  Index: Integer): TDataApplyUpdateItem;
begin
  Result:=TDataApplyUpdateItem(FCollection.Items[Index]);
end;

function TDataApplyUpdateRequest.IndexOf(
  const ATableName: string): Integer;
var
  Index:Integer;
begin
  for Index:=0 to Count -1 do
  begin
    if SameText(ATableName,Items[Index].TableName)then
    begin
      Result:=Index;
      Exit;
    end;
  end;
  Result:=-1;
end;

procedure TDataApplyUpdateRequest.Initialize;
begin
  inherited;
  FCollection:=TCollection.Create(TDataApplyUpdateItem);
end;

procedure TDataApplyUpdateRequest.Remove(const ATableName: string);
var
  Index:Integer;
begin
  Index:=IndexOf(ATableName);
  if(Index>=0)and(Index<Count)then
    Delete(Index);  
end;

function TDataApplyUpdateRequest.Search(
  const ATableName: string): TDataApplyUpdateItem;
var
  Index:Integer;
begin
  Result:=nil;
  Index:=IndexOf(ATableName);
  if(Index>=0)and(Index<Count)then
    Result:=Items[Index];
end;

end.
