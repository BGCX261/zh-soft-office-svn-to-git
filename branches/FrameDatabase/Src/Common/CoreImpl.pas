
{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:��ܺ����ࡣ                                                     }
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
  // vtDebug: ����
  // vtRelease:����
  TVersionType=(vtDebug,vtRelease);
  //Summary:
  // ttSystem:�û�ϵͳ��
  // ttBusiness:ҵ�����ݱ�
  // ttDictionary:�����ֵ��
  TTableType=(ttSystem,ttBusiness,ttDictionary);
  //Summary:
  //  taMain:����
  //  taAttach:����
  //  taDetail:��ϸ��
  TTableAttribute=(taMain,taAttach,taDetail);
  //Summary:
  // �ֶ���������
  // ctValue:ֵ
  // ctCache:���ؼ���
  // ctDatabase:���ݿ����
  // ctLookUp:LooKUp�ֶ�
  // ctNone:�������κεĲ���
  TCalcType=(ctValue,ctCache,ctLookUp,ctDatabase,ctNone);

  TVirtualCtrlType=(vctTextEdit,vctMaskEdit,vctMemo,vctSpinEdit,vctTimeEdit,
                    vctCombobox,vctDateEdit,vctCheckbox,vctCurrencyEdit,
                    vctButtonEdit,vctRadioGroup,vctMruEdit,vctHyperLinkEdit,
                    vctLookupCombobox,vctCategory);

  //Summary:
  // ��������
  //  dtBoolean:������
  //  dtSmallInt,dtInteger,dtLargeint,dtWord:������
  //  dtCurrency,dtDouble:������
  //  dtString:�ַ���
  //  dtDate,dtTime,dtDateTime:��������
  //  dtMemo:��ע����
  TDataType=(dtBoolean,dtInteger,dtCurrency,dtDouble,dtString,dtWideString,dtMemo,dtDate,dtTime,dtDateTime);
  //Summary:
  // ҳ����������
  //  ftNone:��
  //  ftSum:��
  //  ftCount:��¼��
  //  ftAvg:ƽ��ֵ
  TFooterType=(ftNone,ftSum,ftCount,ftAvg);
  //Summary:
  // ģ������
  // û��ʲô����ô�
  TTempletType=(tkSimple);
  //Summary:
  // �༭������
  // eaMain:���༭��
  // eaList:��ϸ�༭��
  // eaAttach:���ӱ༭��
  TEditAreaType=(eaMain,eaList,eaAttach);
  //Summary:
  // ��������
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
    // ������
    property Code:string read FCode write FCode;
    //Summary:
    // �������
    property Name:string read FName write FName;
    //Summary:
    // �����ʾ����
    property ShowName:string read GetShowName;
    //Summary:
    // ��Դ���
    property ResId:Integer read FResId write FResId;
    //Summary:
    // ��Դ����
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
    // ����һ����ڵ�
    function CreateTableItem(AModuleItem:TModuleItem):TTableItem;
    //Summary:
    // ��ģ���������һ�����ݱ�
    // ����������������TableItems ����ʵ�֣�������ӱ�����ô˺�����
    function Add(AItem:TTableItem):Integer;
    //Summary:
    // ��ǰ�ڵ��Ƿ��Ǳ�ϵͳ�Ĺ��ܽڵ㡣
    function Usable(SystemId:Integer):Boolean;
    //Summary:
    // �õ�������Ϣ
    function GetMasterTable:TTableItem;
    
    property Initialized:Boolean read FInitialized write FInitialized;
    //Summary:
    // ģ�����
    property Code:string read FCode write FCode;
    //Summary:
    // ģ�����
    property Templet:string read FTemplet write FTemplet;
    //Summary:
    // ������
    property Category:string read FCategory write FCategory;
    //Summary:
    // ʵ�ʹ��ܴ���
    property Command:string read FCommand write FCommand;
    //Summary:
    // ģ������
    property Name:string read FName write FName;
    //Summary:
    // �Զ�������
    property Name2:string read FName2 write FName2;
    //Summary:
    // ���Ƿ���
    property Mnemonic:string read FMnemonic write FMnemonic;
    //Summary:
    // ��Դ���
    property ResId:Integer read FResId write FResId;
    //Summary:
    // �Ƿ��ܽڵ�
    property IsFunc:Boolean read FIsFunc write FIsFunc;
    //Summary:
    //���ƽ̨��ʾ
    property IsShowShortCut:Boolean read FIsShowShortCut write FIsShowShortCut;
    //Summary:
    // �Ƿ񹤾�����ʾ
    property IsToolBar:Boolean read FIsToolBar write FIsToolBar;
    //Summary:
    // �������
    property AddIn:string read FAddIn write FAddIn;
    //Summary:
    // ͼ������
    property Icon:string read FIcon write FIcon;
    //Summary:
    // ����ϵͳ ���߿��Ա���Щϵͳ����
    property BelongSys:Integer read FBelongSys write FBelongSys;   
    //Summary:
    // ģ������
    property Describe:string read  FDescribe write FDescribe;
    //Summary:
    // �Ƿ�ϵͳģ��
    property IsSystemic:Boolean read FIsSystemic write FIsSystemic;
    //Summary:
    // �汾��Ϣ
    property Version:string read FVersion write FVersion;
    //Summary:
    // ģ��ӵ�а�ť��Դ
    property ChildFunc:Integer read FChildFunc write FChildFunc;
    //Summary:
    // ��ʾ������
    property ShowName:string read GetShowName;
    //Summary:
    // ģ��ӵ�е����ݱ���б�
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
    // ����һ���ֶ�����
    function CreateFieldItem(ATableItem:TTableItem):TFieldItem;
    //Summary:
    // ���һ���ֶ�����
    function Add(AItem:TFieldItem):Integer;
    //Summary:
    // �Զ����ɾ��������Ĳ�ѯ���
    //Parameters:
    //  AWhereSql:Where����
    //  AGroupBy:��������
    //  AOrderBy:��������
    //Remarks:
    // ���е�����������Ҫ���� ��where������group by������order by���ؼ��֣���������
    // �ġ�asc������desc���������ַ�����������
    //Examples��
    // ��select field1,field2 from table1��
    function GetSelectSql(AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function GetSelectSql(ATop:Integer;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function GetSelectSql(AFields:string;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    function GetSelectSql(ATop:Integer;AFields:string;const AWhereSql:string;AGroupBy:string;AOrderBy:string;const IncludeCalcFielded:Boolean=True):string;overload;
    //Summary:
    // �Զ����ɾ��������ĸ������
    //Parameters:
    //  AWhereSql:Where����
    //  AGroupBy:��������
    //  AOrderBy:��������
    //Remarks:
    // ���е�����������Ҫ���� ��where������group by������order by���ؼ��֣���������
    // �ġ�asc������desc���������ַ�����������
    //Examples��
    // ��update table1 set field1='%s' from table 1��
    function GetUpdateSql(AWhereSql:string):string;overload;
    function GetUpdateSql(AFields:string;AWhereSql:string):string;overload;
    //Summary:
    // �޸ı�����
    function GetRenameTableSQL(const NewTableName: string): string;
    //Summary:
    // �Ƿ���ڵ�SQL
    function TableExistsSql: string;
    // Summary:
    // �Զ�����ɾ�����
    function GetDeleteSql(AWhereSql:string):string;
    //Summary:
    // �õ����ݱ�Ĺؼ����б�
    function FieldKeys:TStringList;
    //Summary:
    // �õ����ݱ�Ĵ����ű�
    //Parameters:
    // ��������ؼ��ֵȷ������Ϣ
    function GetCreateSql:string;
    //Summary:
    // �õ�ɾ�����ݱ�Ľű�
    function GetDropSql:string;
    //Summary:
    //�õ����������Ľű�
    //Parameters:
    //  Fields:�ֶ��б��ԡ�;�� �ָ�
    //  IndexName:��������
    //  IndexType:��������
    //  Unique:�Ƿ�Ψһ����   
    function GetCreateIndexSql(const Fields:string;const IndexName:string;
      IndexType:TIndexType;Unique:WordBool):string;
    function GetDropIndexSQL(const AIndexName: string): string;
    function GetIndexExistsSQL(const AIndexName: string):string;

    //Summary:
    // ���Ѵ��ڵ����ݱ���������һ���ֶ�SQL
    //Parameters:
    //  FieldItem:�ֶ���Ϣ
    function GetAddFieldSql(FieldItem:TFieldItem): string;
    //Summary:
    // �γɸ������ݿ��SQL���
    //Summary:
    // �����
    property Code:string read FCode write FCode;
    //Summary:
    // ����ʵ��ģ�����
    property Module:string read FModule write FModule;
    //Summary:
    // ��Դ���
    property ResId:Integer read FResId write FResId;
    //Summary:
    // ������
    property Name:string read FName write FName;
    //Summary:
    // ������
    property TableType:TTableType read FTableType write FTableType;
    //Summary:
    // ������
    property Attribute:TTableAttribute read FTableAttribute write FTableAttribute;
    //Summary:
    // ������
    property Describe:string read FDescribe write FDescribe;
    //Summary:
    // ��Ӧ����
    property Condition:string read FCondition write FCondition;
    //Summary:
    // ��Ӧ��ģ�����
    property ModuleOwner:TModuleItem read FModuleOwner;
    //Summary:
    // ��ʾ������
    property ShowName:string read GetShowName;
    //Summary:
    // �ֶ��б�
    property FieldItems:TFieldItems read FFieldItems;
    //Summary:
    // ���ڵ��ֶ�����
    property ParentField:string read FParentField write  FParentField;
    //Summary:
    // �ӽڵ��ֶ�����
    property ChildField:string read FChildField write FChildField;
    //Summary:
    //�����ַ���
    property OrderByStr:string read FOrderByStr write FOrderByStr;
    //Summary:
    //������ṹ
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
    // �õ������ֶε�SQL��
    function GetFieldSql:string;
    //Summary:
    // �ֶδ���
    property FieldName:string read FFieldName write FFieldName;
    //Summary:
    // �����
    property Table:string read FTable write FTable;
    //Summary:
    // �ֶ�����
    property DisplayLabel:string read FDisplayLabel write FDisplayLabel;
    //Summary:
    // ��Դ���
    property ResId:Integer read FResId write FResId;
    //Summary:
    // ��������
    property DataType:TDataType read FDataType write FDataType;
    // Summary:
    // �ֶδ�С
    property Size:Integer read FSize write FSize;
    // Summary:
    // ����
    property Describe:string read FDescribe write FDescribe;
    //Summary:
    // ����
    property Decimal:SmallInt read FDecimal write FDecimal;
    //Summary:
    // �Ƿ���ȱʡֵ
    property isDefault:Boolean read FisDefault write FisDefault;    
    //Summary:
    // ȱʡֵ
    property DefaultValue:Variant read FDefaultValue write FDefaultValue;
    //Summary:
    // �Ƿ�ؼ���
    property IsKey:Boolean read FIsKey write FIsKey;
    //Summary:
    // �Ƿ�Ψһֵ
    property IsUnique:Boolean read FIsUnique write FIsUnique;
    //Summary:
    // �Ƿ�����Ϊ��
    property AllowNull:Boolean read FAllowNull write FAllowNull;
    //Summary:
    //�Ƿ��������ֶ�
    property AutoIncrement:Boolean read FAutoIncrement write FAutoIncrement;
    //Summary:
    // �����Ӳ�ֵ
    property AutoIncrementStep:Integer read FAutoIncrementStep write FAutoIncrementStep;
    //Summary:
    // �ֶμ�������
    property CalcType:TCalcType read FCalcType write FCalcType;
    //Summary:
    // ���㹫ʽ
    property Formula:string read FFormula write FFormula;
    //Summary:
    //��ʾ��ʽ��
    property DisplayFormat:string read FDisplayFormat write FDisplayFormat;
    //Summary:
    // ��ʾ�ؼ�����
    property CtrlType:TVirtualCtrlType read FCtrlType write FCtrlType;
    //Summary:
    //��Ӧ���ֵ�ֵ
    property Dictionary:string read FDictionary write FDictionary;
    //Summary:
    // �����ؼ����ֶ�
    property LinkFieldName:string read FLinkFieldName write FLinkFieldName;
    //Summary:
    // ��������ֶ�
    property KeyFieldName:string read FKeyFieldName write FKeyFieldName;
    //Summary:
    // ��ʾ�ֵ��ֶ�����
    property ShowField:string read FShowField write FShowField;
    //Summary:
    //�Ƿ���ʾ
    property IsShow:Boolean read FIsShow write FIsShow;
    //Summary:
    //�Ƿ���Ա༭
    property IsEdit:Boolean read FIsEdit write FIsEdit;
    //Summary:
    // �Ƿ�tabstop
    property TabStop:Boolean read FTabStop write FTabStop;
    //Summary:
    // TabOrder
    property TabOrder:Integer read FTabOrder write FTabOrder;
    // Summary:
    //ҳ������
    property Footer:TFooterType read FFooterType write FFooterType;
    //Summary:
    // ��ʾ�к�
    property RowIndex:Integer read FRowIndex write FRowIndex;
    //Summary:
    // ��ʾ�к�
    property ColIndex:Integer read FColIndex write FColIndex;
    //Summary:
    //��ʾ���
    property ShowWidth:Integer read FShowWidth write FShowWidth;
    //Summary:
    // �Ƿ��׼����
    property IsStandOut:Boolean read FIsStandOut write FIsStandOut;
    //Summary:
    // ��Ӧ�ı����
    property TableOwner:TTableItem read FTableOwner;
    //Summary:
    // ��ʾ������
    property ShowName:string read GetShowName;
    //Summary:                                       
    // ����ģ�����
    property LinkModule:string read FLinkModule write FLinkModule;
    //Summary:
    // �Ƿ�������ʾ
    property IsPassword:Boolean read FIsPassword write FIsPassword;
    //Summary:
    // �༭��ʽ��ģʽ
    property EditFormat:string read FEditFormat write FEditFormat;
    //Summary:
    // �Ƿ�Ĭ�����
    property IsBrowseShow:Boolean read FIsBrowseShow write FIsBrowseShow;
    //Summary:
    // �Ƿ�����ֶ�
    property IsAssociate:Boolean read GetIsAssociate;
    //Summary:
    // �Ƿ����������
    property IsLinkMaster:Boolean read FIsLinkMaster write FIsLinkMaster;
    //Summary:
    // ������������ֶ�
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
