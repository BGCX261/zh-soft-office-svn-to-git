unit ProviderConst;


interface                 

type
  TWindowMode = (wmSingle, wmPart);

const
  {DBMS Info}
  DBMS_SQLServer_Name = 'Microsoft SQL Server 2000 ������߰汾';
  DBMS_SQLServer_ID   = 'SQLSERVER';
  DBMS_Access_Name    = 'Microsoft Access 97 ������߰汾';
  DBMS_Access_ID      = 'ACCESS';
  DBMS_DB2_Name				= 'IBM DB2 v7.2 ������߰汾';
  DBMS_DB2_ID					= 'DB2';
  PrimaryKeyStr			: string = 'PRIMARY KEY';
  UNIQUESQLTAG			: string = 'UNIQUE';
  {Tips Const}
  Tip_Ask_OverrideDB  = 'Ŀ�����ݿ��Ѿ����ڣ��Ƿ񸲸ǣ�';
  Tip_TestConnSucc    = '���Ӳ��Գɹ���';

  {Error String}
  ErrStr_NoConnStr     = 'Ŀǰ�������ݿ������ַ�����';
  ErrStr_NoInitIntf    = '��δ��ʼ���ӿڽ��档';
  ErrStr_NoSelDBType   = '��ѡ�����ݿ����͡�';
  ErrStr_NoCreateDB    = '��δ�������ݿ⡣';
  ErrStr_NoFoundDB     = '���ݿⲻ���ڡ�';
  ErrStr_NoFoundDBFile = '���ݿ��ļ���·����Ч��';
  ErrStr_NoSvrName     = '��ָ�����ݿ��������';
  ErrStr_NoUserName    = '�������û�����';
  ErrStr_NoDBName      = '��ָ�����ݿ����ơ�';
  ErrStr_NoDBFile      = '��ָ�����ݿ��ļ���';
  ErrStr_Cancel        = '�û�ȡ���˲�����';
  ErrStr_TableExists	 = '���ݱ�%s�Ѿ�����,������ѡ���±�����';
  ErrStr_TableNoExists = '���ݱ�%s������,������ѡ��Ҫ�������ı�����';
  {Int Const}
  Int_Max_Table_Count = 1024;
  Int_Max_Field_Count = 1024;

  {Wizard Const}

  Wzd_Init_Caption          = 'ϵͳ��ʼ����';
  Wzd_Conn_Caption          = '���ݿ�������';
  Wzd_Comm_Welcome_Describe = '������%s������ʹ�õ����ݿ�ϵͳΪ %s��';
  Wzd_Init_Welcome_Describe = '������ϵͳ��ʼ���򵼡��������ԡ�%s�����г�ʼ����'
                            + '������װ�꡶%s���󣬸���ָ������ɳ�ʼ����';
  Wzd_Conn_Welcome_Describe = '���������ݿ������򵼡��������ԡ�%s�����ʵ����ݿ�'
                            + '�����������á�������Ҫ�������ݿ�����ʱ������ָ'
                            + '��������������á�';
  Wzd_Comm_Type_Info        = 'ѡ�����ݿ�ϵͳ����';
  Wzd_Init_Type_Tips        = '��Ҫ�����������͵����ݿ⣿������������б���ѡȡ��';
  Wzd_Conn_Type_Tips        = '��Ҫʹ���������ݿ�洢���ݣ�������������б���ѡȡ��';
  Wzd_Init_Conn_Info        = '���ݿⴴ����Ϣ����';
  Wzd_Conn_Conn_Info        = '���ݿ�������Ϣ����';
  Wzd_Init_Conn_Tips        = '��β��ܴ������ݿ⣿����������Ĵ�����Ϣ��';
  Wzd_Conn_Conn_Tips        = '��β������ӵ�ָ�������ݿ⣿�����������������Ϣ��';
  Wzd_InvalidWizardType     = 'ϵͳ��û��ָ������ģʽ��';
  Wzd_NoFoundInitDBFile     = '������ָ�������ݿ��ʼ���ļ���%s��';
  Wzd_NoAvailableDBMS       = 'ϵͳ��û�п��õ����ݿ����ϵͳ�ӿڶ���';
  Wzd_InvalidDBType         = 'ϵͳ��û��ָ�������ݿ����ϵͳ�ӿڶ���';
  Wzd_LoadUIFail            = '�������ݿ��������ý���ʧ�ܣ�%s';
  Wzd_InitSuccessful        = 'ϵͳ��ʼ���Ѿ�˳����ɣ�';
  {SQL const}
  
implementation

end.

