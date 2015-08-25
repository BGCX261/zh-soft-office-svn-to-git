{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:数据处理请求类。                                                 }
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
  // 数据执行类型
  // etSQL:执行SQL语句
  // etData:执行数据
  TExecuteType=(etSql,etData);
  //Summary:
  //数据处理类型
  //  odtAppend:添加
  //  odtUpdate:更新
  //  odtDelete:删除
  TOperateDataType=(odtAppend,odtUpdate,odtDelete);
  
  TCustomClientRequest=class(TClientRequestPersistent);
  TCustomServerReply=class(TServerReplyPersistent);


  //Summary:
  // ApplyUpdate 相关的类和函数
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
    // 清除所有的字段相关信息列表
    procedure Clear;
    //Summary:
    // 添加一个信息字段列表
    function Add(const AFieldName:string;const AFlags:TProviderFlags):Integer;
    //Summary:
    // 通过字段名定位他在列表里面的未知
    function IndexOf(const AFieldName:string):Integer;
    //Summary:
    // 查找字段信息列表
    function Find(const AFieldName:string;var Index:Integer):Boolean;
    //Summary:
    // 根据字段名称返回字段的更新模式信息
    function ValueByName(AFieldName:string):TProviderFlags;
    //Summary:
    // 删除指定位置的字段信息
    procedure Delete(const Index:Integer);
    //Summary:
    // 根据字段名称删除
    procedure Remove(const AFieldName:string);
    //Summary:
    // 请求执行数据的类型
    //  etSql:执行SQL语句
    //  etData:执行数据,调用DataProvider.ApplyDatas
    property ExecType:TExecuteType read FExecType write FExecType;
    //Summary:
    // 需要操作的数据表
    property TableName:string read FTableName write FTableName;
    //Summary:
    // 表属性
    property TableAttr:TTableAttribute read FTableAttr write FTableAttr;
    //Summary:
    // 执行的SQL语句
    // 如果etSQL,可能是Insert,也可能是Update
    // 如果etData,一定是select
    property ExecSql:string read FExecSql write FExecSql;
    //Summary:
    // 需要更新的数据
    property Data:OleVariant read FData write FData;
    //Summary:
    // 数据表的更新模式
    property UpdateMode:TUpdateMode read FUpdateMode write FUpdateMode;
    //Summary:
    // 需要设置字段的flag的字段名称
    property Fields[Index:Integer]:string read GetFields;default;
    //Summary:
    // 字段更新的模式
    property Flags[Index:Integer]:TProviderFlags read GetFlags;
    //Summary:
    // 具有更新模式字段的数量
    property Count:Integer read GetCount;
  end;
  //Summary:
  //  此类里面的数据此表是主表,附表,明细表类型排序,
  //  所以写对应的服务要更举操作类型,来确定先执行表
  //  的顺序.
  // 例如 Append,Update 要先执行主表,附表然后明细表
  // 如果是Delete 要执行明细表,附表,最后是主表.         
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
    // 初始化请求所需要的数据且在调用请求参数的时候,必须初始化.
    procedure Initialize;override;
    //Summary:
    // 创建一个数据操作的子请求的数据节点
    function CreateRequestItem:TDataApplyUpdateItem;overload;
    //Summary:
    // 创建一个数据操作的子请求节点
    function CreateRequestItem(
      AExecType:TExecuteType;
      ATableName:string;
      ATableAttr:TTableAttribute;
      AExecSql:string;
      Data:OleVariant;
      AUpdateMode:TUpdateMode):TDataApplyUpdateItem;overload;
    //Summary:
    // 删除一个数据请求
    procedure Delete(const Index:Integer);
    //Summary:
    // 根据表名删除一个数据请求
    procedure Remove(const ATableName:string);
    function IndexOf(const ATableName:string):Integer;
    //Summary:
    // 根据更新的表名,操作其请求的数据.
    function Search(const ATableName:string):TDataApplyUpdateItem;
    //Summary:
    // 请求的数据节点
    property Items[Index:Integer]:TDataApplyUpdateItem read GetItems;default;
    //Summary:
    // 需要处理的数据请求数.
    property Count:Integer read GetCount;
    //Summary:
    // 请求用户
    property RequestUser:string read FRequestUser write FRequestUser;
    // Summary
    // 请求的计算机名称
    property Computer:string read FComputer write FComputer;
    //Summary:
    // 请求的计算机IP
    property RequestIP:string read FRequestIP write FRequestIP;
    //Summmary:
    // 请求的数据处理类型.
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
