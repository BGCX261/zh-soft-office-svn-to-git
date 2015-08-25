{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:框架基本类。                                                     }
{ @@Description:                                                             }
{ @@Author: Suntogether                                                      }
{ @@Version:1.0                                                              }
{ @@Create:2006-12-07                                                        }
{ @@Remarks:                                                                 }
{ @@Modify:                                                                  }
{****************************************************************************}

unit BasalMarshal;

interface
                            
uses Classes,Sysutils,Serialize;

type
  TRequestReturnType=(rtNone,rtParam,rtDataSet,rtMixed);

  TReplyObjectType=(roError,roNormal);
  //@@Summary:
  //  定义了传输可以处理的异常类型。
  //@@Description:
  //@@Lists:
  //  etParam:参数异常。
  //  etContextInvalid:上下文异常。
  //  etOperationInvalid:操作无效异常。
  //  etOperationTimeOut:超时异常。
  //  etOperationFailed:操作失败异常。
  //  etOperationABort:  异常中断。
  //  etOutOfRange:超范围异常。
  //  etSystem: 系统引起的异常。
  //  etNotSupport:不支持异常。
  //  etHandleInvalid：句柄错误
  //  etNotService  :没有对应的服务
  //  etSecurity    :权限不够
  //  etUnknown: 不明确的异常。  
  TReplyErrorType=(etParam,etContextInvalid,etOperationInvalid,
    etOperationTimeOut,etOperationFailed,etOutOfRange,etSystem,etNotSupport,
    etHandleInvalid,etNotService,etSecurity,etSerialize,etUnknown);
    
  TClientRequestPersistent=class(TSerializedPersistent)
  private
    FReturnType: TRequestReturnType;
    FServiceGuid: string;
  public
    procedure Initialize;override;
  published
    property ReturnType:TRequestReturnType read FReturnType write FReturnType;
    property ServiceGuid:string read FServiceGuid write FServiceGuid;
  end;

  TServerReplyPersistent=class(TSerializedPersistent)
  private
    FRepObjType: TReplyObjectType;
  public
    procedure Initialize;override;
  published
    property ReplyType:TReplyObjectType read FRepObjType write FRepObjType;
  end;

  TServerReplyError=class(TServerReplyPersistent)
  private
    FClassName: string;
    FErrorMsg: String;
    FErrorType: TReplyErrorType;
  public
    procedure Initialize;override;
  published
    property _Class:string read FClassName write FClassName;
    property ErrorType:TReplyErrorType read FErrorType write FErrorType;
    property ErrorMsg:String read FErrorMsg write FErrorMsg;
  end;

implementation

procedure InitializeClassSearcher;
begin
  if ClassSearcher=nil then
  begin
    ClassSearcher:=TClassSearcher.Create;
    ClassSearcher.Register(TServerReplyError);
  end;
end;
procedure FinalizeClassSearcher;
begin
  if ClassSearcher<>nil then
    FreeAndNil(ClassSearcher);
end;


procedure TClientRequestPersistent.Initialize;
begin
  FReturnType:=rtNone;
end;

{ TServerReplyPersistent }

procedure TServerReplyPersistent.Initialize;
begin
  FRepObjType:=roNormal;
end;

{ TServerReplyError }

procedure TServerReplyError.Initialize;
begin
  inherited Initialize;
  FRepObjType:=roError;
  FClassName:='';
  ErrorType:=etUnknown;
  ErrorMsg:='';
end;

initialization
  InitializeClassSearcher;
finalization
  FinalizeClassSearcher;
end.
 