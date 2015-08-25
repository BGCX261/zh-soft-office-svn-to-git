{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:��ܲ��ֳ����ͱ�����                                             }
{ @@Description:                                                             }
{ @@Author: Suntogether                                                      }
{ @@Version:1.0                                                              }
{ @@Create:2007-01-15                                                        }
{ @@Remarks:                                                                 }
{ @@Modify:                                                                  }
{****************************************************************************}
unit FrameCommon;


interface

uses Classes,SysUtils,DebuggerImpl,DataAccessInt;

const
  TabSeparator=#9;

  //LocalNetAccessTypeName='6A87A31D0E534F1881AB12CD780D0484';
  //LocalNetAccessTypeName='C5CCEA1F-4C04-47F3-8F01-D1258019973B';
  LocalNetAccessTypeName= '2E6B016E-8753-4506-87BE-0F76E2CA9A29';

  DefaultGetKeyIdProcedureName='stp_GetNextSequence';
  DefaultRollBackKeyIdProcedureName='stp_RollBackNextSequence';
  DefaultResetKeyIdProcedureName='stp_ResetNextSequence';
  DefaultDBScriptFileDirectory='DBScript\';
var
  //Summary:
  // ��ǰϵͳ���
  CurrentSystemNumber:LongInt;
  //Summary:
  // ���������Ϣ
  Debugger:TDebugger;

  DataAccessFactory:IDataAccessFactoryInt ;

implementation

uses Forms;

initialization
  Debugger:=TDebugger.Create(nil);
finalization
  FreeAndNil(Debugger);
 
end.


