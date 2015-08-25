{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:数据访问接口定义.                                                }
{ @@Description:                                                             }
{ @@Author: Suntogether                                                      }
{ @@Version:1.0                                                              }
{ @@Create:2007-01-15                                                        }
{ @@Remarks:                                                                 }
{ @@Modify:                                                                  }
{****************************************************************************}
unit DataAccessInt;

interface

uses Classes,DBClient,DB,AdoDb,BasalMarshal,MarshalImpl;

type

  IDataAccessInt=interface
  ['{B7E9DE53-A4EE-4DD0-911A-FDAA02EA3C61}']
    function LastError:string;
    function TryConnecting:Boolean;overload;
    function TryConnecting(Config:TPersistent):Boolean;overload;
    function SelectSql(const ASelectSql:string;var ADataSet:TClientDataSet):Boolean;
    function ExistsSql(const ASelectSql:string):integer;
    function ExecuteSql(const AExecSql:string):Boolean;
    function GetDateTime:TdateTime ;
    function ExecuteRequest(ARequest:TCustomClientRequest;var AReply:TCustomServerReply):Boolean;overload;
    function ExecuteRequest(ARequest:TCustomClientRequest;var AReply:TCustomServerReply;var ADataSet:TClientDataSet):Boolean;overload;
    function GetKeyFieldValue(AKeyCode:string):integer ;
    function ResetKeyFieldValue(AKeyCode:string;AKeyValue:Integer):boolean ;   
    procedure Initialize;
  end;

  IDataAccessFactoryInt=interface
  ['{2E6B016E-8753-4506-87BE-0F76E2CA9A29}']
  //['{6B9EC4D4-962D-4DEF-8B38-5AFC1D9286D6}']
    function GetDataAccessInt(ADataAccessType:string):IDataAccessInt;
  end;

implementation

end.
