
{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:框架核心类。                                                     }
{ @@Description:                                                             }
{ @@Author: Suntogether                                                      }
{ @@Version:1.0                                                              }
{ @@Create:2007-01-15                                                        }
{ @@Remarks:                                                                 }
{ @@Modify:                                                                  }
{****************************************************************************}
unit CoreImpl;

interface

uses Classes,SysUtils,KeyPairDictionary,DataAccess,DB, DBClient;

type
  //Summary:
  // vtDebug: 调试
  // vtRelease:发布
  TVersionType=(vtDebug,vtRelease);
  //Summary:
  // ttSystem:用户系统表
  // ttBusiness:业务数据表
  // ttDictionary:数据字典表
  TTableType=(ttSystem,ttBusiness,ttDictionary);
  //Summary:
  //  taMain:主表
  //  taAttach:附表
  //  taDetail:明细表
  TTableAttribute=(taMain,taAttach,taDetail);
  //Summary:
  // 字段运算类型
  // ctValue:值
  // ctCache:本地计算
  // ctDatabase:数据库计算
  // ctLookUp:LooKUp字段
  // ctNone:无需做任何的操作
  TCalcType=(ctValue,ctCache,ctLookUp,ctDatabase,ctNone);

  TVirtualCtrlType=(vctTextEdit,vctMaskEdit,vctMemo,vctSpinEdit,vctTimeEdit,
                    vctCombobox,vctDateEdit,vctCheckbox,vctCurrencyEdit,
                    vctButtonEdit,vctRadioGroup,vctMruEdit,vctHyperLinkEdit,
                    vctLookupCombobox,vctCategory);

  //Summary:
  // 数据类型
  //  dtBoolean:布尔型
  //  dtSmallInt,dtInteger,dtLargeint,dtWord:整数型
  //  dtCurrency,dtDouble:浮点数
  //  dtString:字符串
  //  dtDate,dtTime,dtDateTime:日期类型
  //  dtMemo:备注类型
  TDataType=(dtBoolean,dtInteger,dtCurrency,dtDouble,dtString,dtWideString,dtMemo,dtDate,dtTime,dtDateTime);
  //Summary:
  // 页脚运算类型
  //  ftNone:无
  //  ftSum:和
  //  ftCount:记录数
  //  ftAvg:平均值
  TFooterType=(ftNone,ftSum,ftCount,ftAvg);
  //Summary:
  // 模板类型
  // 没有什么大的用处
  TTempletType=(tkSimple);
  //Summary:
  // 编辑区类型
  // eaMain:主编辑区
  // eaList:明细编辑区
  // eaAttach:附加编辑区
  TEditAreaType=(eaMain,eaList,eaAttach);
  //Summary:
  // 索引类型
  TIndexType=(itParmary,itIndex);


  TCategoryItem=class(TPersistent)
  private
    FResId: Integer;
    FDescribe: string;
    FName: string;
    FCode: string;
    function GetShowName: string;
  public
    procedure Assign(Source: TPersistent); override;
    //Summary:
    // 类别编码
    property Code:string read FCode write FCode;
    //Summary:
    // 类别名称
    property Name:string read FName write FName;
    //Summary:
    // 类别显示名称
    property ShowName:string read GetShowName;
    //Summary:
    // 资源编号
    property ResId:Integer read FResId write FResId;
    //Summary:
    // 资源描述
    property Describe:string read FDescribe write FDescribe;
  end;

  TCategorySearcher=class(TKeyStringDictionary)
  private
    function GetCategorys(Index: Integer): TCategoryItem;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Clear;override;
    function LookUp(Code:string):TCategoryItem;
    property Category[Index:Integer]:TCategoryItem read GetCategorys;default;  
  end;

  TTableItem=class;
  TTableItems=class;

  TModuleItem=class(TPersistent)
  private
    FIsFunc: Boolean;
    FIsToolBar: Boolean;
    FIsSystemic: Boolean;
    FBelongSys: Integer;
    FIsShowShortCut: Boolean;
    FResId: Integer;
    FChildFunc: Integer;
    FCommand: string;
    FTemplet: string;
    FCategory: string;
    FVersion: string;
    FName2: string;
    FIcon: string;
    FAddIn: string;
    FDescribe: string;
    FCode: string;
    FName: string;
    FMnemonic: string;
    FTableItems: TTableItems;
    FInitialized: Boolean;
    function GetShowName: string;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    //Summary:
    // 创建一个表节点
    function CreateTableItem(AModuleItem:TModuleItem):TTableItem;
    //Summary:
    // 向模块里面添加一个数据表
    // 其他操作均可以在TableItems 里面实现，但是添加必须调用此函数。
    function Add(AItem:TTableItem):Integer;
    //Summary:
    // 当前节点是否是本系统的功能节点。
    function Usable(SystemId:Integer):Boolean;
    //Summary:
    // 得到主表信息
    function GetMasterTable:TTableItem;
    
    property Initialized:Boolean read FInitialized write FInitialized;
    //Summary:
    // 模块编码
    property Code:string read FCode write FCode;
    //Summary:
    // 模板代码
    property Templet:string read FTemplet write FTemplet;
    //Summary:
    // 类别代码
    property Category:string read FCategory write FCategory;
    //Summary:
    // 实际功能代码
    property Command:string read FCommand write FCommand;
    //Summary:
    // 模块名称
    property Name:string read FName write FName;
    //Summary:
    // 自定义名称
    property Name2:string read FName2 write FName2;
    //Summary:
    // 助记符号
    property Mnemonic:string read FMnemonic write FMnemonic;
    //Summary:
    // 资源编号
    property ResId:Integer read FResId write FResId;
    //Summary:
    // 是否功能节点
    property IsFunc:Boolean read FIsFunc write FIsFunc;
    //Summary:
    //快捷平台显示
    property IsShowShortCut:Boolean read FIsShowShortCut write FIsShowShortCut;
    //Summary:
    // 是否工具兰显示
    property IsToolBar:Boolean read FIsToolBar write FIsToolBar;
    //Summary:
    // 插件编码
    property AddIn:string read FAddIn write FAddIn;
    //Summary:
    // 图标名称
    property Icon:string read FIcon write FIcon;
    //Summary:
    // 所属系统 或者可以被那些系统共享
    property BelongSys:Integer read FBelongSys write FBelongSys;   
    //Summary:
    // 模块描述
    property Describe:string read  FDescribe write FDescribe;
    //Summary:
    // 是否系统模块
    property IsSystemic:Boolean read FIsSystemic write FIsSystemic;
    //Summary:
    // 版本信息
    property Version:string read FVersion write FVersion;
    //Summary:
    // 模块拥有按钮资源
    property ChildFunc:Integer read FChildFunc write FChildFunc;
    //Summary:
    // 显示的名称
    property ShowName:string read GetShowName;
    //Summary:
    // 模块拥有的数据表的列表
    property TableItems:TTableItems read FTableItems;
  end;


  TModuleSearcher=class(TKeyStringDictionary)
  private
    function GetModules(Index: Integer): TModuleItem;
  public
    constructor Create(AOwner:TComponent);override;
    procedure Clear;override;
    function LookUp(Code:string):TModuleItem;
    function SearchByCommand(ACommand:string):TModuleItem;
    property Modules[Index:Integer]:TModuleItem read GetModules;default;
  end;
  TFieldItem=class;
  TFieldItems=class;
  
  TTableItem=class(TPersistent)
  private
    FModule: string;
    FDescribe: string;
    FCode: string;
    FName: string;
    FCondition: string;
    FTableAttribute: TTableAttribute;
    FTableType: TTableType;
    FResId: Integer;
    FModuleOwner: TModuleItem;
    FFieldItems: TFieldItems;
    FFieldKeys:TStringList;
    FParentField: string;
    FChildField: string;
    FOrderByStr: string;
    FIsCreateTable: Boolean;
    function GetShowName: string;
  protected
    function InternalSelectSql(AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function InternalSelectSql(AFields:string;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    //Summary:
    // 创建一个字段类型
    function CreateFieldItem(ATableItem:TTableItem):TFieldItem;
    //Summary:
    // 添加一个字段类型
    function Add(AItem:TFieldItem):Integer;
    //Summary:
    // 自动生成具有条件的查询语句
    //Parameters:
    //  AWhereSql:Where条件
    //  AGroupBy:分组条件
    //  AOrderBy:排序条件
    //Remarks:
    // 所有的条件都不需要加入 “where”，“group by”，“order by”关键字，但是排序
    // 的“asc”，“desc”在排序字符串参数里面
    //Examples：
    // “select field1,field2 from table1“
    function GetSelectSql(AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function GetSelectSql(ATop:Integer;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function GetSelectSql(AFields:string;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function GetSelectSql(ATop:Integer;AFields:string;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    //Summary:
    // 自动生成具有条件的更新语句
    //Parameters:
    //  AWhereSql:Where条件
    //  AGroupBy:分组条件
    //  AOrderBy:排序条件
    //Remarks:
    // 所有的条件都不需要加入 “where”，“group by”，“order by”关键字，但是排序
    // 的“asc”，“desc”在排序字符串参数里面
    //Examples：
    // “update table1 set field1='%s' from table 1“
    function GetUpdateSql(AWhereSql:string):string;overload;
    function GetUpdateSql(AFields:string;AWhereSql:string):string;overload;
    //Summary:
    // 修改表名称
    function GetRenameTableSQL(const NewTableName: string): string;
    //Summary:
    // 是否存在的SQL
    function TableExistsSql: string;
    // Summary:
    // 自动生成删除语句
    function GetDeleteSql(AWhereSql:string):string;
    //Summary:
    // 得到数据表的关键字列表
    function FieldKeys:TStringList;
    //Summary:
    // 得到数据表的创建脚本
    //Parameters:
    // 里面包含关键字等方面的信息
    function GetCreateSql:string;
    //Summary:
    // 得到删除数据表的脚本
    function GetDropSql:string;
    //Summary:
    //得到创建索引的脚本
    //Parameters:
    //  Fields:字段列表，以”;“ 分隔
    //  IndexName:索引名字
    //  IndexType:索引类型
    //  Unique:是否唯一索引   
    function GetCreateIndexSql(const Fields:string;const IndexName:string;
      IndexType:TIndexType;Unique:WordBool):string;
    function GetDropIndexSQL(const AIndexName: string): string;
    function GetIndexExistsSQL(const AIndexName: string):string;

    //Summary:
    // 在已存在的数据表里面增加一个字段SQL
    //Parameters:
    //  FieldItem:字段信息
    function GetAddFieldSql(FieldItem:TFieldItem): string;
    //Summary:
    // 形成更新数据库的SQL语句
    //Summary:
    // 表代码
    property Code:string read FCode write FCode;
    //Summary:
    // 所属实际模块代码
    property Module:string read FModule write FModule;
    //Summary:
    // 资源编号
    property ResId:Integer read FResId write FResId;
    //Summary:
    // 表名称
    property Name:string read FName write FName;
    //Summary:
    // 表类型
    property TableType:TTableType read FTableType write FTableType;
    //Summary:
    // 表属性
    property Attribute:TTableAttribute read FTableAttribute write FTableAttribute;
    //Summary:
    // 表描述
    property Describe:string read FDescribe write FDescribe;
    //Summary:
    // 适应条件
    property Condition:string read FCondition write FCondition;
    //Summary:
    // 对应的模块对象
    property ModuleOwner:TModuleItem read FModuleOwner;
    //Summary:
    // 显示的名称
    property ShowName:string read GetShowName;
    //Summary:
    // 字段列表
    property FieldItems:TFieldItems read FFieldItems;
    //Summary:
    // 父节点字段名称
    property ParentField:string read FParentField write  FParentField;
    //Summary:
    // 子节点字段名称
    property ChildField:string read FChildField write FChildField;
    //Summary:
    //排序字符串
    property OrderByStr:string read FOrderByStr write FOrderByStr;
    //Summary:
    //创建表结构
    property IsCreateTable:Boolean read FIsCreateTable write FIsCreateTable;    
  end;

  TTableItems=class(TKeyStringDictionary)
  private
    function GetTables(Index: Integer): TTableItem;
  public
    constructor Create(AOwner:TComponent);override;
    procedure Clear;override;
    function LookUp(Code:string):TTableItem;
    property Tables[Index:Integer]:TTableItem read GetTables;default;
  end;

  TFieldItem=class(TPersistent)
  private
    FIsShow: Boolean;
    FAutoIncrement: Boolean;
    FIsStandOut: Boolean;
    FAllowNull: Boolean;
    FIsKey: Boolean;
    FIsEdit: Boolean;
    FIsUnique: Boolean;
    FTabStop: Boolean;
    FResId: Integer;
    FAutoIncrementStep: Integer;
    FShowWidth: Integer;
    FColIndex: Integer;
    FTabOrder: Integer;
    FRowIndex: Integer;
    FSize: Integer;
    FDecimal: SmallInt;
    FFormula: string;
    FTable: string;
    FDescribe: string;
    FDictionary: string;
    FShowField: string;
    FCalcType: TCalcType;
    FCtrlType: TVirtualCtrlType;
    FDataType: TDataType;
    FFooterType: TFooterType;
    FDefaultValue: Variant;
    FTableOwner: TTableItem;
    FLinkModule: string;
    FIsPassword: Boolean;
    FDisplayFormat: string;
    FEditFormat: string;
    FIsBrowseShow: Boolean;
    FLinkFieldName: string;
    FKeyFieldName: string;
    FIsLinkMaster: Boolean;
    FMasterField: string;
    FDisplayLabel: string;
    FFieldName: string;
    FisDefault: Boolean;
    function GetShowName: string;
    function GetIsAssociate: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    //Summary:
    // 得到创建字段的SQL；
    function GetFieldSql:string;
    //Summary:
    // 字段代码
    property FieldName:string read FFieldName write FFieldName;
    //Summary:
    // 表代码
    property Table:string read FTable write FTable;
    //Summary:
    // 字段名称
    property DisplayLabel:string read FDisplayLabel write FDisplayLabel;
    //Summary:
    // 资源编号
    property ResId:Integer read FResId write FResId;
    //Summary:
    // 数据类型
    property DataType:TDataType read FDataType write FDataType;
    // Summary:
    // 字段大小
    property Size:Integer read FSize write FSize;
    // Summary:
    // 描述
    property Describe:string read FDescribe write FDescribe;
    //Summary:
    // 精度
    property Decimal:SmallInt read FDecimal write FDecimal;
    //Summary:
    // 是否有缺省值
    property isDefault:Boolean read FisDefault write FisDefault;    
    //Summary:
    // 缺省值
    property DefaultValue:Variant read FDefaultValue write FDefaultValue;
    //Summary:
    // 是否关键字
    property IsKey:Boolean read FIsKey write FIsKey;
    //Summary:
    // 是否唯一值
    property IsUnique:Boolean read FIsUnique write FIsUnique;
    //Summary:
    // 是否允许为空
    property AllowNull:Boolean read FAllowNull write FAllowNull;
    //Summary:
    //是否自增加字段
    property AutoIncrement:Boolean read FAutoIncrement write FAutoIncrement;
    //Summary:
    // 自增加步值
    property AutoIncrementStep:Integer read FAutoIncrementStep write FAutoIncrementStep;
    //Summary:
    // 字段计算类型
    property CalcType:TCalcType read FCalcType write FCalcType;
    //Summary:
    // 计算公式
    property Formula:string read FFormula write FFormula;
    //Summary:
    //显示格式化
    property DisplayFormat:string read FDisplayFormat write FDisplayFormat;
    //Summary:
    // 显示控件类型
    property CtrlType:TVirtualCtrlType read FCtrlType write FCtrlType;
    //Summary:
    //对应的字典值
    property Dictionary:string read FDictionary write FDictionary;
    //Summary:
    // 关联关键子字段
    property LinkFieldName:string read FLinkFieldName write FLinkFieldName;
    //Summary:
    // 本身关联字段
    property KeyFieldName:string read FKeyFieldName write FKeyFieldName;
    //Summary:
    // 显示字典字段名称
    property ShowField:string read FShowField write FShowField;
    //Summary:
    //是否显示
    property IsShow:Boolean read FIsShow write FIsShow;
    //Summary:
    //是否可以编辑
    property IsEdit:Boolean read FIsEdit write FIsEdit;
    //Summary:
    // 是否tabstop
    property TabStop:Boolean read FTabStop write FTabStop;
    //Summary:
    // TabOrder
    property TabOrder:Integer read FTabOrder write FTabOrder;
    // Summary:
    //页脚类型
    property Footer:TFooterType read FFooterType write FFooterType;
    //Summary:
    // 显示行号
    property RowIndex:Integer read FRowIndex write FRowIndex;
    //Summary:
    // 显示列号
    property ColIndex:Integer read FColIndex write FColIndex;
    //Summary:
    //显示宽度
    property ShowWidth:Integer read FShowWidth write FShowWidth;
    //Summary:
    // 是否标准导出
    property IsStandOut:Boolean read FIsStandOut write FIsStandOut;
    //Summary:
    // 对应的表对象
    property TableOwner:TTableItem read FTableOwner;
    //Summary:
    // 显示的名称
    property ShowName:string read GetShowName;
    //Summary:                                       
    // 连接模块编码
    property LinkModule:string read FLinkModule write FLinkModule;
    //Summary:
    // 是否密码显示
    property IsPassword:Boolean read FIsPassword write FIsPassword;
    //Summary:
    // 编辑格式化模式
    property EditFormat:string read FEditFormat write FEditFormat;
    //Summary:
    // 是否默认浏览
    property IsBrowseShow:Boolean read FIsBrowseShow write FIsBrowseShow;
    //Summary:
    // 是否关联字段
    property IsAssociate:Boolean read GetIsAssociate;
    //Summary:
    // 是否与主表关联
    property IsLinkMaster:Boolean read FIsLinkMaster write FIsLinkMaster;
    //Summary:
    // 与主表关联的字段
    property MasterField:string read FMasterField write FMasterField;
  end;

  TFieldItems=class(TKeyStringDictionary)
  private
    function GetFields(Index: Integer): TFieldItem;
  public
    constructor Create(AOwner:TComponent);override;
    procedure Clear;override;
    procedure Assign(Source: TKeyStringDictionary);
    function LookUp(Code:string):TFieldItem;
    property Fields[Index:Integer]:TFieldItem read GetFields;default;
  end;

  TCommandDataItem=class(TObject)
  protected
    FModule: TModuleItem;
  public
    property Module:TModuleItem read FModule write FModule;
  end;
  
  TMemDataDictionary=class(TPersistent)
  private
    FCode: string;
    FDataSet: TDataSet;
    FDisplayLabel: string;
  protected
  public
    property Code:string read FCode write FCode;
    property DisplayLabel:string read FDisplayLabel write FDisplayLabel;
    property DataSet:TDataSet read FDataSet write FDataSet;
  end;
  
  TMemDataDictionarys=class(TKeyStringDictionary)
  private
    function GetMemData(Index: Integer): TMemDataDictionary;
  public
    constructor Create(AOwner:TComponent);override;
    procedure Clear;override;
    function LookUp(Code:string):TMemDataDictionary;
    property MemDatas[Index:Integer]:TMemDataDictionary read GetMemData;default;
  end;
    
implementation

uses FuncUtils;

const
  SQLKEY_SELECT_IDENTIFIER  ='select';
  SQLKEY_FROM_IDENTIFIER    ='from';
  SQLKEY_UPDATE_IDENTIFIER  ='update';
  SQLKEY_DELETE_IDENTIFIER  ='delete';
  SQLKEY_GROUPBY_IDENTIFIER ='group by';
  SQLKEY_ORDERBY_IDENTIFIER ='order by';
  SQLKEY_WHERE_IDENTIFIER   ='where';
  SQLKEY_TOP_IDENTIFIER     ='top';
  SQLKEY_SET_IDENTIFIER     ='set';
  SQL_SEPARATOR_CHAR        =',';
  SQL_BLANK_CHAR            =' ';
  SQL_PARAMETER_CHARS       ='=:';

  
{ TCategory }

procedure TCategoryItem.Assign(Source: TPersistent);
begin
  if Source is TCategoryItem then
  begin
    FResId:=TCategoryItem(Source).ResId;
    FDescribe:=TCategoryItem(Source).Describe;
    FName:=TCategoryItem(Source).Name;
    FCode:=TCategoryItem(Source).Code;
  end;
end;

function TCategoryItem.GetShowName: string;
begin
  Result:=FName;
end;

{ TModule }


function TModuleItem.Add(AItem: TTableItem): Integer;
begin
  Result:=TableItems.Add(AItem.Code,AItem.Name,AItem);
end;

procedure TModuleItem.Assign(Source: TPersistent);
var
  Index:Integer;
  Item:TTableItem;
begin
  if Source is TModuleItem then
  begin
    FIsFunc:=TModuleItem(Source).IsFunc;
    FIsToolBar:=TModuleItem(Source).IsToolBar;
    FIsSystemic:=TModuleItem(Source).IsSystemic;
    FBelongSys:=TModuleItem(Source).BelongSys;
    FIsShowShortCut:=TModuleItem(Source).IsShowShortCut;
    FResId:=TModuleItem(Source).ResId;
    FChildFunc:=TModuleItem(Source).ChildFunc;
    FCommand:=TModuleItem(Source).Command;
    FTemplet:=TModuleItem(Source).Templet;
    FCategory:=TModuleItem(Source).Category;
    FVersion:=TModuleItem(Source).Version;
    FName2:=TModuleItem(Source).Name2;
    FIcon:=TModuleItem(Source).Icon;
    FAddIn:=TModuleItem(Source).AddIn;
    FDescribe:=TModuleItem(Source).Describe;
    FCode:=TModuleItem(Source).Code;
    FName:=TModuleItem(Source).Name;
    FMnemonic:=TModuleItem(Source).Mnemonic;
    FTableItems.Clear;
    for Index:=0 to TModuleItem(Source).TableItems.Count -1 do
    begin
      Item:=CreateTableItem(Self);
      Item.Assign(TModuleItem(Source).TableItems[Index]);
      Add(Item);
    end;
  end;
end;

{ TTableItem }

function TTableItem.Add(AItem: TFieldItem): Integer;
begin
  Result:=FFieldItems.Add(AItem.FieldName,AItem.DisplayLabel,AItem);
end;

procedure TTableItem.Assign(Source: TPersistent);
var
  Index:Integer;
  Item:TFieldItem;
begin
  if(Source is TTableItem)then
  begin
    FModule:=TTableItem(Source).Module;
    FDescribe:=TTableItem(Source).Describe;
    FCode:=TTableItem(Source).Code;
    FName:=TTableItem(Source).Name;
    FCondition:=TTableItem(Source).Condition;
    FTableAttribute:=TTableItem(Source).Attribute;
    FTableType:=TTableItem(Source).TableType;
    FResId:=TTableItem(Source).ResId;
    FParentField:=TTableItem(Source).ParentField;
    FChildField:=TTableItem(Source).ChildField;
    FFieldKeys.Assign(TTableItem(Source).FieldKeys);
    FFieldItems.Clear;
    for Index:=0 to TTableItem(Source).FieldItems.Count-1 do
    begin
      Item:=CreateFieldItem(Self);
      Item.Assign(TTableItem(Source).FieldItems[Index]);
      Add(Item);
    end;
  end;
end;


function TTableItem.GetSelectSql(AWhereSql, AGroupBy,
  AOrderBy: string;const IncludeCalcFielded:Boolean=True): string;
begin
{
  if code='RPJJL_GroupUser_Join' then
  begin
    Result:='select RPJJL_GroupUser_Join.GroupID,RPJJL_GroupUser_Join.User_ID, '
 + '	RPJJL_user.usercode,RPJJL_user.name'
 +' from RPJJL_GroupUser_Join inner join RPJJL_user on RPJJL_GroupUser_Join.user_id =RPJJL_user.user_id  ' ;
  if(Trim(AWhereSql)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_WHERE_IDENTIFIER+SQL_BLANK_CHAR+AWhereSql;
    exit ;
  end ;
  }
  Result:=InternalSelectSql(AWhereSql,AGroupBy,AOrderBy);
  if(Result=EmptyStr)then Exit;
  Result:=SQLKEY_SELECT_IDENTIFIER+SQL_BLANK_CHAR+Result;
end;


constructor TTableItem.Create;
begin
  inherited Create;
  FIsCreateTable:=true ;
  FFieldItems:=TFieldItems.Create(nil);
  FFieldItems.Sorted:=True;
  FFieldKeys:=TStringList.Create;
end;

function TTableItem.CreateFieldItem(ATableItem:TTableItem): TFieldItem;
begin
  Result:=TFieldItem.Create;
  Result.FTableOwner:=ATableItem;
end;

destructor TTableItem.Destroy;
begin
  FFieldKeys.Free;
  FFieldItems.Free;
  inherited;
end;

function TTableItem.FieldKeys: TStringList;
var
  Index:Integer;
begin
  if (FFieldKeys.Count=0)then
  begin
    for Index:=0 to FieldItems.Count-1 do
      if(FieldItems[Index].IsKey)then
        FFieldKeys.Add(FieldItems[Index].FieldName);
  end;
  Result:=FFieldKeys;
end;

function TTableItem.GetShowName: string;
begin
  Result:=FName;
end;

function TTableItem.GetCreateIndexSql(const Fields, IndexName: string;
  IndexType: TIndexType; Unique: WordBool): string;
begin

end;

function TTableItem.GetCreateSql: string;
begin

end;

function TTableItem.GetDropSql: string;
begin

end;

function TTableItem.GetSelectSql(ATop: Integer; const AWhereSql: string;
  AGroupBy, AOrderBy: string;const IncludeCalcFielded:Boolean=True): string;
begin
  Result:=InternalSelectSql(AWhereSql,AGroupBy,AOrderBy);
  if(Result=EmptyStr)then Exit;
  Result:=SQLKEY_SELECT_IDENTIFIER+SQL_BLANK_CHAR+SQLKEY_TOP_IDENTIFIER+SQL_BLANK_CHAR
    +IntToStr(ATop)+SQL_BLANK_CHAR+Result;
end;

function TTableItem.GetSelectSql(AFields: string; const AWhereSql: string;
  AGroupBy, AOrderBy: string;const IncludeCalcFielded:Boolean=True): string;
begin
  Result:=InternalSelectSql(AFields,AWhereSql,AGroupBy,AOrderBy);
  if (Result=EmptyStr)then Exit;
  Result:=SQLKEY_SELECT_IDENTIFIER+SQL_BLANK_CHAR+Result;
end;

function TTableItem.GetSelectSql(ATop: Integer; AFields: string;
  const AWhereSql: string; AGroupBy, AOrderBy: string;const IncludeCalcFielded:Boolean=True): string;
begin
  Result:=InternalSelectSql(AFields,AWhereSql,AGroupBy,AOrderBy);
  if(Result=EmptyStr)then Exit;
  Result:=SQLKEY_SELECT_IDENTIFIER+SQL_BLANK_CHAR+SQLKEY_TOP_IDENTIFIER+SQL_BLANK_CHAR
    +IntToStr(ATop)+SQL_BLANK_CHAR+Result;
end;

function TTableItem.GetUpdateSql(AFields, AWhereSql: string): string;
begin
  if(Trim(AFields)=EmptyStr)then Exit;
  Result:=SQLKEY_UPDATE_IDENTIFIER+SQL_BLANK_CHAR+Code+SQLKEY_SET_IDENTIFIER
    +SQL_BLANK_CHAR+AFields;
  if(Trim(AWhereSql)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_WHERE_IDENTIFIER+SQL_BLANK_CHAR+AWhereSql;
end;

function TTableItem.GetUpdateSql(AWhereSql: string): string;
var
  Index:Integer;
begin
  Result:=EmptyStr;
  for Index:=0 to FieldItems.Count-1 do
  begin
    if FieldItems[Index].CalcType=ctValue then
      Result:=Result+SQL_SEPARATOR_CHAR+FieldItems[Index].FieldName+SQL_PARAMETER_CHARS+FieldItems[Index].FieldName;
  end;
  Result:=Copy(Result,2,MaxInt);
  if (Trim(AWhereSql)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+AWhereSql;
  Result:=SQLKEY_UPDATE_IDENTIFIER+SQL_BLANK_CHAR+Code+SQL_BLANK_CHAR+SQLKEY_SET_IDENTIFIER
    +SQL_BLANK_CHAR+Result;
end;

function TTableItem.GetAddFieldSql(FieldItem: TFieldItem): string;
begin

end;

function TTableItem.GetDropIndexSQL(const AIndexName: string): string;
begin

end;

function TTableItem.GetIndexExistsSQL(const AIndexName: string): string;
begin

end;

function TTableItem.GetRenameTableSQL(const NewTableName: string): string;
begin

end;

function TTableItem.TableExistsSql: string;
begin

end;

function TTableItem.InternalSelectSql(AWhereSql, AGroupBy,
  AOrderBy: string;const IncludeCalcFielded:Boolean=True): string;
var
  Index:Integer;
begin
  Result:=EmptyStr;
  for Index:=0 to FieldItems.Count-1 do
  begin
    if FieldItems[Index].AutoIncrement then Continue;
    if IncludeCalcFielded then
    begin
      if (FieldItems[Index].CalcType=ctValue)or(FieldItems[Index].CalcType=ctDatabase)then
        Result:=Result+SQL_SEPARATOR_CHAR+FieldItems[Index].FieldName;
    end else
    begin
      if FieldItems[Index].CalcType=ctValue then
        Result:=Result+SQL_SEPARATOR_CHAR+FieldItems[Index].FieldName;
    end;
  end;
  if(Result<>EmptyStr)then
    Result:=Copy(Result,2,MaxInt);
  if(Result=EmptyStr)then Exit;
  Result:=Result+SQL_BLANK_CHAR+SQLKEY_FROM_IDENTIFIER+SQL_BLANK_CHAR+Code;
  if(Trim(AWhereSql)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_WHERE_IDENTIFIER+SQL_BLANK_CHAR+AWhereSql;
  if(Trim(AGroupBy)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_GROUPBY_IDENTIFIER+SQL_BLANK_CHAR+AGroupBy;
  if(Trim(AOrderBy)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_ORDERBY_IDENTIFIER+SQL_BLANK_CHAR+AOrderBy;
end;

function TTableItem.InternalSelectSql(AFields: string;
  const AWhereSql: string; AGroupBy, AOrderBy: string;const IncludeCalcFielded:Boolean=True): string;
begin
  Result:=AFields+SQL_BLANK_CHAR+SQLKEY_FROM_IDENTIFIER+SQL_BLANK_CHAR+Code;
  if(Trim(AWhereSql)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_WHERE_IDENTIFIER+SQL_BLANK_CHAR+AWhereSql;
  if(Trim(AGroupBy)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_GROUPBY_IDENTIFIER+SQL_BLANK_CHAR+AGroupBy;
  if(Trim(AOrderBy)<>EmptyStr)then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_ORDERBY_IDENTIFIER+SQL_BLANK_CHAR+AOrderBy;
end;

function TTableItem.GetDeleteSql(AWhereSql: string): string;
begin
  Result:=SQL_BLANK_CHAR+SQLKEY_DELETE_IDENTIFIER+SQL_BLANK_CHAR+SQLKEY_FROM_IDENTIFIER+SQL_BLANK_CHAR+Code+SQL_BLANK_CHAR;
  if Trim(AWhereSql)<>EmptyStr then
    Result:=Result+SQL_BLANK_CHAR+SQLKEY_WHERE_IDENTIFIER+SQL_BLANK_CHAR+AWhereSql+SQL_BLANK_CHAR; 
end;

{ TFieldItem }

procedure TFieldItem.Assign(Source: TPersistent);
begin
  if(Source is TFieldItem)then
  begin
    FIsShow:=TFieldItem(Source).IsShow;
    FAutoIncrement:=TFieldItem(Source).AutoIncrement;
    FIsStandOut:=TFieldItem(Source).IsStandOut;
    FAllowNull:=TFieldItem(Source).AllowNull;
    FIsKey:=TFieldItem(Source).IsKey;
    FIsEdit:=TFieldItem(Source).IsEdit;
    FIsUnique:=TFieldItem(Source).IsUnique;
    FTabStop:=TFieldItem(Source).TabStop;
    FResId:=TFieldItem(Source).ResId;
    FAutoIncrementStep:=TFieldItem(Source).AutoIncrementStep;
    FShowWidth:=TFieldItem(Source).ShowWidth;
    FColIndex:=TFieldItem(Source).ColIndex;
    FTabOrder:=TFieldItem(Source).TabOrder;
    FRowIndex:=TFieldItem(Source).RowIndex;
    FSize:=TFieldItem(Source).Size;
    FDecimal:=TFieldItem(Source).Decimal;
    FFieldName:=TFieldItem(Source).FieldName;
    FFormula:=TFieldItem(Source).Formula;
    FTable:=TFieldItem(Source).Table;
    FDescribe:=TFieldItem(Source).Describe;
    FDictionary:=TFieldItem(Source).Dictionary;
    FShowField:=TFieldItem(Source).ShowField;
    FDisplayLabel:=TFieldItem(Source).DisplayLabel;
    FDisplayFormat:=TFieldItem(Source).DisplayFormat;
    FCalcType:=TFieldItem(Source).CalcType;
    FCtrlType:=TFieldItem(Source).CtrlType;
    FDataType:=TFieldItem(Source).DataType;
    FFooterType:=TfieldItem(Source).Footer;
    FDefaultValue:=TFieldItem(Source).DefaultValue;
    FLinkModule:=TFieldItem(Source).LinkModule;
    FIsPassword:=TFieldItem(Source).IsPassword;
    FDisplayFormat:=TFieldItem(Source).DisplayFormat;
    FEditFormat:=TFieldItem(Source).EditFormat;
    FIsBrowseShow:=TFieldItem(Source).IsBrowseShow;
    FLinkFieldName:=TFieldItem(Source).LinkFieldName;
    FKeyFieldName:=TFieldItem(Source).KeyFieldName;
    FIsLinkMaster:=TFieldItem(Source).IsLinkMaster;
    FMasterField:=TFieldItem(Source).MasterField;
  end;
end;

constructor TModuleItem.Create;
begin
  inherited Create;
  FTableItems:=TTableItems.Create(nil);
  FTableItems.Sorted:=True;
  FInitialized:=False;
end;


function TModuleItem.CreateTableItem(AModuleItem:TModuleItem): TTableItem;
begin
  Result:=TTableItem.Create;
  Result.FModuleOwner:=AModuleItem;
end;

destructor TModuleItem.Destroy;
begin
  FTableItems.Free;
  inherited;
end;

function TModuleItem.GetMasterTable: TTableItem;
var
  Index:Integer;
begin
  Result:=nil;
  for Index:=0 to TableItems.Count-1 do
  begin
    if TableItems[Index].Attribute=taMain then
    begin
      Result:=TableItems[Index];
      Exit;
    end;
  end;
end;



function TModuleItem.GetShowName: string;
begin
  Result:=FName;
end;

function TFieldItem.GetFieldSql: string;
begin
  Result:=EmptyStr;
end;

function TFieldItem.GetIsAssociate: Boolean;
begin
  Result:=(Dictionary<>EmptyStr)and(KeyFieldName<>EmptyStr)and(LinkFieldName<>EmptyStr)
    and(ShowField<>EmptyStr);
end;

function TFieldItem.GetShowName: string;
begin
  Result:=DisplayLabel;
end;


{ TCategorySearcher }

procedure TCategorySearcher.Clear;
var
  Index:Integer;
  Obj:TObject;
begin
  for Index:=0 to inherited Count -1 do
  begin
    Obj:=inherited Objects[Index];
    if Obj<>nil then
      FreeAndNIl(Obj);
  end;
  inherited Clear;
end;

constructor TCategorySearcher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Sorted:=True;
end;

destructor TCategorySearcher.Destroy;
begin
  inherited;
end;

function TCategorySearcher.GetCategorys(Index: Integer): TCategoryItem;
begin
  Result:=(inherited Objects[Index]) as TCategoryItem;
end;

function TCategorySearcher.LookUp(Code: string): TCategoryItem;
var
  Index:Integer;
begin
  Result:=nil;
  Index:=inherited IndexOf(Code);
  if(Index>=0)and(Index<inherited Count)then
    Result:=Category[Index];
end;

{ TModuleSearcher }

procedure TModuleSearcher.Clear;
var
  Index:Integer;
  Obj:TObject;
begin
  for Index:=0 to inherited Count -1 do
  begin
    Obj:=inherited Objects[Index];
    if Obj<>nil then
      FreeAndNIl(Obj);
  end;
  inherited;
end;

constructor TModuleSearcher.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Sorted:=True;
end;

function TModuleSearcher.GetModules(Index: Integer): TModuleItem;
begin
  Result:=(inherited Objects[Index]) as TModuleItem;
end;

function TModuleSearcher.LookUp(Code: string): TModuleItem;
var
  Index:Integer;
begin
  Result:=nil;
  Index:=inherited IndexOf(Code);
  if(Index>=0)and(Index<inherited Count)then
    Result:=Modules[Index];
end;

function TModuleSearcher.SearchByCommand(ACommand: string): TModuleItem;
var
  Index:Integer;
begin
  for Index:=0 to Count -1 do
    if SameText(ACommand,Modules[Index].Command)then
    begin
      Result:=Modules[Index];
      Exit;
    end;
  Result:=nil;
end;

{ TTableItems }

procedure TTableItems.Clear;
var
  Index:Integer;
  Obj:TObject;
begin
  for Index:=0 to inherited Count -1 do
  begin
    Obj:=inherited Objects[Index];
    if Obj<>nil then
      FreeAndNIl(Obj);
  end;
  inherited;
end;

constructor TTableItems.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  inherited Sorted:=True;
end;

function TTableItems.GetTables(Index: Integer): TTableItem;
begin
  Result:=(inherited Objects[Index])as TTableItem;
end;

function TTableItems.LookUp(Code: string): TTableItem;
var
  Index:Integer;
begin
  Result:=nil;
  Index:=inherited IndexOf(Code);
  if(Index>=0)and(Index<inherited Count)then
    Result:=Tables[Index];
end;

{ TFieldItems }

procedure TFieldItems.Clear;
var
  Index:Integer;
  Obj:TObject;
begin
  for Index:=0 to inherited Count -1 do
  begin
    Obj:=inherited Objects[Index];
    if Obj<>nil then
      FreeAndNIl(Obj);
  end;
  inherited;
end;

procedure TFieldItems.Assign(Source: TKeyStringDictionary);
var
  Item:TFieldItem;
  i:integer ;
begin
  if not (Source is TFieldItems)then exit ;
  Clear ;
  for i:=0 to TFieldItems(Source).Count -1 do
  begin
    Item:=TFieldItem.Create;
    Item.Assign(TFieldItems(Source).Fields[i]) ;
    Add(Item.FieldName,Item.DisplayLabel,Item); 
  end ;
end;

constructor TFieldItems.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  inherited Sorted:=True;
end;

function TFieldItems.GetFields(Index: Integer): TFieldItem;
begin
  Result:=(inherited Objects[Index])as TFieldItem;
end;

function TFieldItems.LookUp(Code: string): TFieldItem;
var
  Index:Integer;
begin
  Result:=nil;
  Index:=inherited IndexOf(Code);
  if(Index>=0)and(Index<inherited Count)then
    Result:=Fields[Index];
end;

function TModuleItem.Usable(SystemId: Integer): Boolean;
begin
 //Result:=(SystemId and BelongSys)=CurrentSystemNumber;
end;


{ TMemDataDictionarys }

procedure TMemDataDictionarys.Clear;
begin
  inherited;

end;

constructor TMemDataDictionarys.Create(AOwner: TComponent);
begin
  inherited;

end;

function TMemDataDictionarys.GetMemData(
  Index: Integer): TMemDataDictionary;
begin
  Result:=(inherited Objects[Index])as TMemDataDictionary;
end;

function TMemDataDictionarys.LookUp(Code: string): TMemDataDictionary;
var
  Index:Integer;
begin
  Result:=nil;
  Index:=inherited IndexOf(Code);
  if(Index>=0)and(Index<inherited Count)then
    Result:=MemDatas[Index];

end;

end.
