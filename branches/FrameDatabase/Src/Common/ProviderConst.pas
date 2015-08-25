unit ProviderConst;


interface                 

type
  TWindowMode = (wmSingle, wmPart);

const
  {DBMS Info}
  DBMS_SQLServer_Name = 'Microsoft SQL Server 2000 或其更高版本';
  DBMS_SQLServer_ID   = 'SQLSERVER';
  DBMS_Access_Name    = 'Microsoft Access 97 或其更高版本';
  DBMS_Access_ID      = 'ACCESS';
  DBMS_DB2_Name				= 'IBM DB2 v7.2 或其更高版本';
  DBMS_DB2_ID					= 'DB2';
  PrimaryKeyStr			: string = 'PRIMARY KEY';
  UNIQUESQLTAG			: string = 'UNIQUE';
  {Tips Const}
  Tip_Ask_OverrideDB  = '目标数据库已经存在，是否覆盖？';
  Tip_TestConnSucc    = '连接测试成功！';

  {Error String}
  ErrStr_NoConnStr     = '目前尚无数据库连接字符串。';
  ErrStr_NoInitIntf    = '尚未初始化接口界面。';
  ErrStr_NoSelDBType   = '请选择数据库类型。';
  ErrStr_NoCreateDB    = '尚未创建数据库。';
  ErrStr_NoFoundDB     = '数据库不存在。';
  ErrStr_NoFoundDBFile = '数据库文件的路径无效。';
  ErrStr_NoSvrName     = '请指定数据库服务器。';
  ErrStr_NoUserName    = '请输入用户名。';
  ErrStr_NoDBName      = '请指定数据库名称。';
  ErrStr_NoDBFile      = '请指定数据库文件。';
  ErrStr_Cancel        = '用户取消了操作。';
  ErrStr_TableExists	 = '数据表%s已经存在,请重新选择新表名。';
  ErrStr_TableNoExists = '数据表%s不存在,请重新选择要重命名的表名。';
  {Int Const}
  Int_Max_Table_Count = 1024;
  Int_Max_Field_Count = 1024;

  {Wizard Const}

  Wzd_Init_Caption          = '系统初始化向导';
  Wzd_Conn_Caption          = '数据库连接向导';
  Wzd_Comm_Welcome_Describe = '《%s》可以使用的数据库系统为 %s。';
  Wzd_Init_Welcome_Describe = '“系统初始化向导”允许您对《%s》进行初始化。'
                            + '当您安装完《%s》后，该向导指导您完成初始化。';
  Wzd_Conn_Welcome_Describe = '“数据库连接向导”允许您对《%s》访问的数据库'
                            + '进行连接设置。当您需要更改数据库连接时，该向导指'
                            + '导您完成连接设置。';
  Wzd_Comm_Type_Info        = '选择数据库系统类型';
  Wzd_Init_Type_Tips        = '您要创建哪种类型的数据库？请从下面下拉列表中选取。';
  Wzd_Conn_Type_Tips        = '您要使用哪种数据库存储数据？请从下面下拉列表中选取。';
  Wzd_Init_Conn_Info        = '数据库创建信息设置';
  Wzd_Conn_Conn_Info        = '数据库连接信息设置';
  Wzd_Init_Conn_Tips        = '如何才能创建数据库？请设置下面的创建信息。';
  Wzd_Conn_Conn_Tips        = '如何才能连接到指定的数据库？请设置下面的连接信息。';
  Wzd_InvalidWizardType     = '系统中没有指定的向导模式。';
  Wzd_NoFoundInitDBFile     = '不存在指定的数据库初始化文件：%s。';
  Wzd_NoAvailableDBMS       = '系统中没有可用的数据库管理系统接口对象。';
  Wzd_InvalidDBType         = '系统中没有指定的数据库管理系统接口对象。';
  Wzd_LoadUIFail            = '加载数据库连接设置界面失败：%s';
  Wzd_InitSuccessful        = '系统初始化已经顺利完成！';
  {SQL const}
  
implementation

end.

