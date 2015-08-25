
{*******************************************************}
{                                                       }
{  Protocol define                                      }
{  定义了一些公共的类型，包括报文类型等                 }
{                                                       }
{  Author: 穆洪星                                       }
{  Data:   2007-03-18                                   }
{  Build:  2007-03-18                                   }
{                                                       }
{*******************************************************}

unit ZhConstProtocol;

interface

const
  MAX_TEXTSIZE = 4000;                 //定义中一个TCP包为 4096 字节，给包头预留了最多 96 个字节
  MAX_BUFSIZE = 4096;                  //一个TCP报文定义最大为4096字节
  BATCH_FORMAT = 'YYYYMMDDHHMMSS';     //使用当前时间生成批次号
  FILEPATH_UPDATE = 'Update\';         //保存升级信息的文件夹
  FILEPATH_CONFIG = 'Update\Config\';  //配置信息
  FILEPATH_BACKUP = 'Update\Backup\';  //保存备份信息的文件夹
  FILEPATH_CLog = 'Update\ClientLog\'; //保存客户端日志的文件夹
  FILEPATH_SLog = 'Update\ServerLog\'; //保存服务器日志的文件夹
  FILENAME_UPDATELIST = 'UpdateList.xml';
                                       //更新列表的文件名
  FILENAME_UPDATELIST_BACKUP = 'UpdateList~.xml';
                                       //更新列表备份文件的文件名
  FILENAME_CLIENTCONFIG = 'ClientConfig.xml';
                                       //客户端配置文件的文件名
  FILENAME_RUNNING = 'ClientRunning.xml';
                                       //客户端实时状态信息
  FILENAME_BACKUP = 'Backup.xml';      //备份文件信息
  TEMP_EXTENSION = '.tmp';             //还未更新元文件的最新文件加后缀区分
  BACKUP_EXTENSION = '.bak';           //备份的文件
type
  { 盛放报文正文的缓冲器 }
  TText = array[0..MAX_TEXTSIZE - 1] of Char;

  { 要发送文件的信息 }
  PFileInfo = ^TFileInfo;
  TFileInfo = record
    fiIndex: Integer;                  //文件序号，从1开始
    fiFileName: ShortString;           //要发送的文件名，包括扩展名
    fiFilePath: ShortString;           //文件保存的路径，最后包含分隔符'\'
    fiFileLength: ShortString;         //文件长度
  end;

  { 报文类型 }
  TPackageType = (
    ptNone,                            //缺省
    ptExtend,                          //扩展类型，用户可以根据需要自己定义其含义
    ptRequestUpdate,                   //服务端通知客户端要进行更新，只有报头没有报文
    ptUpdateList,                      //服务端发送更新列表或者客户端接收更新列表
    ptTransFile,                       //传输文件
    ptEnd,                             //收到这个信息表示操作已经完成，只有报头没有报文
    ptException,                       //收到这个信息表示操作异常终止，不再进行接下来的操作，只有报头没有报文
    ptMessage);                        //发送消息，为方便起见，单条消息不能超过 MAX_BUFSIZE 字节

  { 报文的报头 }
  TPackageHead = packed record
    phType: TPackageType;              //报文的类型
    phExtend: Cardinal;                //报文的额外信息
    phGUID: TGUID;                     //使用GUID在必要的时候作为区分信息用
  end;

  { 服务端发送更新列表报文 }
  { 之所以单独列出来而没有和其他文件统一在一起为了理解上的方便 }
  PUpdateListPackage = ^TUpdateListPackage;
  TUpdateListPackage = packed record
    ulpPackageIndex: Integer;          //当前发送的文件的分包序号，从1开始
    ulpPackageTotalCount: Integer;     //当前发送的文件总共的包数目，从1开始。若为0表示不知道总的包数
    ulpLength: Integer;                //正文的有效字节数
    ulpText: TText;                    //正文
  end;

  { 客户端回复更新文件列表报文 }
  TReplyUpdateListPackage = packed record
    rupPackageIndex: Integer;          //接下来要接收的文件的分包序号，从1开始
    rupPackageTotalCount: Integer;     //接收的文件总共的包数目
  end;

  { 服务端发送文件报文 }
  PFilePackage = ^TFilePackage;
  TFilePackage = packed record
    sfpFileIndex: Integer;             //当前发送的文件在文件列表中的序号，从1开始
    sfpFileTotalCount: Integer;        //当前发送的文件列表中总共的文件数目
    sfpPackageIndex: Integer;          //当前发送的文件的分包序号，从1开始
    sfpPackageTotalCount: Integer;     //当前发送的文件总共的包数目
    sfpLength: Integer;                //正文的有效字节数
    sfpText: TText;                    //正文
  end;

  { 客户端回复文件报文 }
  PReplyFilePackage = ^TReplyFilePackage;
  TReplyFilePackage = packed record
    rfpFileIndex: Integer;             //接下来要接收的文件在文件列表中的序号，从1开始
    rfpFileTotalCount: Integer;        //当前接收的文件列表中总共的文件数目
    rfpPackageIndex: Integer;          //接下来要接收的文件的分包序号，从1开始
    rfpPackageTotalCount: Integer;     //接收的文件总共的包数目
  end;

  { 消息报文 }
  PTalkMessage = ^TTalkMessage;
  TTalkMessage = packed record
    tmLength: Integer;                 //聊天内容长度
    tmText: TText;                     //正文
  end;

  { 客户端设置 }
  TClientConfig = record
    ccServerIP: string;                //服务器IP
    ccServerPort: Word;                //服务器端口
  end;

  { 客户端实时信息 }
  TClientRunningInfo = record
    criTransport: Boolean;             //是否正在传输中
    criFileIndex: Integer;             //正在传输的文件序号，若文件序号为0且正在传输表示传输的是更新列表文件
    criPackageIndex: Integer;          //正在传输的包序号
  end;

  { 客户端备份文件的信息 }
  TClientBackupInfo = record
    cbiBatch: string;
    cbiFileName: string;
  end;
  TClientBackupInfoArray = array of TClientBackupInfo;

  { 更新时发生的事件 }
  TUpdateEvent = procedure(Sender: TObject; APackageType: TPackageType; AWParam, ALParam: Cardinal) of object;

implementation

end.