{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:��ܻ����ࡣ                                                     }
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
  //  �����˴�����Դ�����쳣���͡�
  //@@Description:
  //@@Lists:
  //  etParam:�����쳣��
  //  etContextInvalid:�������쳣��
  //  etOperationInvalid:������Ч�쳣��
  //  etOperationTimeOut:��ʱ�쳣��
  //  etOperationFailed:����ʧ���쳣��
  //  etOperationABort:  �쳣�жϡ�
  //  etOutOfRange:����Χ�쳣��
  //  etSystem: ϵͳ������쳣��
  //  etNotSupport:��֧���쳣��
  //  etHandleInvalid���������
  //  etNotService  :û�ж�Ӧ�ķ���
  //  etSecurity    :Ȩ�޲���
  //  etUnknown: ����ȷ���쳣��  
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
 