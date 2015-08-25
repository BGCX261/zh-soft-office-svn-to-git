
{*******************************************************}
{                                                       }
{  Protocol define                                      }
{  ������һЩ���������ͣ������������͵�                 }
{                                                       }
{  Author: �º���                                       }
{  Data:   2007-03-18                                   }
{  Build:  2007-03-18                                   }
{                                                       }
{*******************************************************}

unit ZhConstProtocol;

interface

const
  MAX_TEXTSIZE = 4000;                 //������һ��TCP��Ϊ 4096 �ֽڣ�����ͷԤ������� 96 ���ֽ�
  MAX_BUFSIZE = 4096;                  //һ��TCP���Ķ������Ϊ4096�ֽ�
  BATCH_FORMAT = 'YYYYMMDDHHMMSS';     //ʹ�õ�ǰʱ���������κ�
  FILEPATH_UPDATE = 'Update\';         //����������Ϣ���ļ���
  FILEPATH_CONFIG = 'Update\Config\';  //������Ϣ
  FILEPATH_BACKUP = 'Update\Backup\';  //���汸����Ϣ���ļ���
  FILEPATH_CLog = 'Update\ClientLog\'; //����ͻ�����־���ļ���
  FILEPATH_SLog = 'Update\ServerLog\'; //�����������־���ļ���
  FILENAME_UPDATELIST = 'UpdateList.xml';
                                       //�����б���ļ���
  FILENAME_UPDATELIST_BACKUP = 'UpdateList~.xml';
                                       //�����б����ļ����ļ���
  FILENAME_CLIENTCONFIG = 'ClientConfig.xml';
                                       //�ͻ��������ļ����ļ���
  FILENAME_RUNNING = 'ClientRunning.xml';
                                       //�ͻ���ʵʱ״̬��Ϣ
  FILENAME_BACKUP = 'Backup.xml';      //�����ļ���Ϣ
  TEMP_EXTENSION = '.tmp';             //��δ����Ԫ�ļ��������ļ��Ӻ�׺����
  BACKUP_EXTENSION = '.bak';           //���ݵ��ļ�
type
  { ʢ�ű������ĵĻ����� }
  TText = array[0..MAX_TEXTSIZE - 1] of Char;

  { Ҫ�����ļ�����Ϣ }
  PFileInfo = ^TFileInfo;
  TFileInfo = record
    fiIndex: Integer;                  //�ļ���ţ���1��ʼ
    fiFileName: ShortString;           //Ҫ���͵��ļ�����������չ��
    fiFilePath: ShortString;           //�ļ������·�����������ָ���'\'
    fiFileLength: ShortString;         //�ļ�����
  end;

  { �������� }
  TPackageType = (
    ptNone,                            //ȱʡ
    ptExtend,                          //��չ���ͣ��û����Ը�����Ҫ�Լ������京��
    ptRequestUpdate,                   //�����֪ͨ�ͻ���Ҫ���и��£�ֻ�б�ͷû�б���
    ptUpdateList,                      //����˷��͸����б���߿ͻ��˽��ո����б�
    ptTransFile,                       //�����ļ�
    ptEnd,                             //�յ������Ϣ��ʾ�����Ѿ���ɣ�ֻ�б�ͷû�б���
    ptException,                       //�յ������Ϣ��ʾ�����쳣��ֹ�����ٽ��н������Ĳ�����ֻ�б�ͷû�б���
    ptMessage);                        //������Ϣ��Ϊ���������������Ϣ���ܳ��� MAX_BUFSIZE �ֽ�

  { ���ĵı�ͷ }
  TPackageHead = packed record
    phType: TPackageType;              //���ĵ�����
    phExtend: Cardinal;                //���ĵĶ�����Ϣ
    phGUID: TGUID;                     //ʹ��GUID�ڱ�Ҫ��ʱ����Ϊ������Ϣ��
  end;

  { ����˷��͸����б��� }
  { ֮���Ե����г�����û�к������ļ�ͳһ��һ��Ϊ������ϵķ��� }
  PUpdateListPackage = ^TUpdateListPackage;
  TUpdateListPackage = packed record
    ulpPackageIndex: Integer;          //��ǰ���͵��ļ��ķְ���ţ���1��ʼ
    ulpPackageTotalCount: Integer;     //��ǰ���͵��ļ��ܹ��İ���Ŀ����1��ʼ����Ϊ0��ʾ��֪���ܵİ���
    ulpLength: Integer;                //���ĵ���Ч�ֽ���
    ulpText: TText;                    //����
  end;

  { �ͻ��˻ظ������ļ��б��� }
  TReplyUpdateListPackage = packed record
    rupPackageIndex: Integer;          //������Ҫ���յ��ļ��ķְ���ţ���1��ʼ
    rupPackageTotalCount: Integer;     //���յ��ļ��ܹ��İ���Ŀ
  end;

  { ����˷����ļ����� }
  PFilePackage = ^TFilePackage;
  TFilePackage = packed record
    sfpFileIndex: Integer;             //��ǰ���͵��ļ����ļ��б��е���ţ���1��ʼ
    sfpFileTotalCount: Integer;        //��ǰ���͵��ļ��б����ܹ����ļ���Ŀ
    sfpPackageIndex: Integer;          //��ǰ���͵��ļ��ķְ���ţ���1��ʼ
    sfpPackageTotalCount: Integer;     //��ǰ���͵��ļ��ܹ��İ���Ŀ
    sfpLength: Integer;                //���ĵ���Ч�ֽ���
    sfpText: TText;                    //����
  end;

  { �ͻ��˻ظ��ļ����� }
  PReplyFilePackage = ^TReplyFilePackage;
  TReplyFilePackage = packed record
    rfpFileIndex: Integer;             //������Ҫ���յ��ļ����ļ��б��е���ţ���1��ʼ
    rfpFileTotalCount: Integer;        //��ǰ���յ��ļ��б����ܹ����ļ���Ŀ
    rfpPackageIndex: Integer;          //������Ҫ���յ��ļ��ķְ���ţ���1��ʼ
    rfpPackageTotalCount: Integer;     //���յ��ļ��ܹ��İ���Ŀ
  end;

  { ��Ϣ���� }
  PTalkMessage = ^TTalkMessage;
  TTalkMessage = packed record
    tmLength: Integer;                 //�������ݳ���
    tmText: TText;                     //����
  end;

  { �ͻ������� }
  TClientConfig = record
    ccServerIP: string;                //������IP
    ccServerPort: Word;                //�������˿�
  end;

  { �ͻ���ʵʱ��Ϣ }
  TClientRunningInfo = record
    criTransport: Boolean;             //�Ƿ����ڴ�����
    criFileIndex: Integer;             //���ڴ�����ļ���ţ����ļ����Ϊ0�����ڴ����ʾ������Ǹ����б��ļ�
    criPackageIndex: Integer;          //���ڴ���İ����
  end;

  { �ͻ��˱����ļ�����Ϣ }
  TClientBackupInfo = record
    cbiBatch: string;
    cbiFileName: string;
  end;
  TClientBackupInfoArray = array of TClientBackupInfo;

  { ����ʱ�������¼� }
  TUpdateEvent = procedure(Sender: TObject; APackageType: TPackageType; AWParam, ALParam: Cardinal) of object;

implementation

end.