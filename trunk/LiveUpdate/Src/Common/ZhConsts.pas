{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2006 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit ZhConsts;
{* |<PRE>
================================================================================
* ������ƣ�������������
* ��Ԫ���ƣ�������Դ�ַ������嵥Ԫ
* ��Ԫ���ߣ�CnPack������
* ��    ע��
* ����ƽ̨��PWin98SE + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnConsts.pas,v 1.11 2006/09/23 17:27:03 passion Exp $
* �޸ļ�¼��
*           2004.09.18 V1.2
*                ����CnMemProf���ַ�������
*           2002.04.18 V1.1
*                ���������ַ�������
*           2002.04.08 V1.0
*                ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows;

//{$I CnPack.inc}

//==============================================================================
// ����Ҫ���ػ����ַ���
//==============================================================================

resourcestring

  // ע���·��
  SCnPackRegPath = '\Software\CnPack';

  // ��������·��
  SCnPackToolRegPath = 'CnTools';

//==============================================================================
// ��Ҫ���ػ����ַ���
//==============================================================================


var
  // ������Ϣ
{$IFDEF GB2312}
  SCnInformation: string = '��ʾ';
  SCnWarning: string = '����';
  SCnError: string = '����';
  SCnEnabled: string = '��Ч';
  SCnDisabled: string = '����';
  SCnMsgDlgOK: string = 'ȷ��(&O)';
  SCnMsgDlgCancel: string = 'ȡ��(&C)';
{$ELSE}
  SCnInformation: string = 'Information';
  SCnWarning: string = 'Warning';
  SCnError: string = 'Error';
  SCnEnabled: string = 'Enabled';
  SCnDisabled: string = 'Disabled';
  SCnMsgDlgOK: string = '&OK';
  SCnMsgDlgCancel: string = '&Cancel';
{$ENDIF}

const
  // ��������Ϣ
  SCnPackAbout = 'CnPack';
  SCnPackVer = 'Ver 0.0.8.0';
  SCnPackStr = SCnPackAbout + ' ' + SCnPackVer;
  SCnPackUrl = 'http://www.cnpack.org';
  SCnPackBbsUrl = 'http://bbs.cnpack.org';
  SCnPackNewsUrl = 'news://news.cnpack.org';
  SCnPackEmail = 'master@cnpack.org';
  SCnPackBugEmail = 'bugs@cnpack.org';
  SCnPackSuggestionsEmail = 'suggestions@cnpack.org';

  SCnPackDonationUrl = 'http://www.cnpack.org/foundation.php';
  SCnPackDonationUrlSF = 'http://sourceforge.net/donate/index.php?group_id=110999';
{$IFDEF GB2312}
  SCnPackGroup = 'CnPack ������';
{$ELSE}
  SCnPackGroup = 'CnPack Team';
{$ENDIF}
  SCnPackCopyright = '(C)Copyright 2001-2006 ' + SCnPackGroup;

  // CnPropEditors
{$IFDEF GB2312}
  SCopyrightFmtStr =
    SCnPackStr + #13#10#13#10 +
    '�������: %s' + #13#10 +
    '�������: %s(%s)' + #13#10 +
    '���˵��: %s' + #13#10#13#10 +
    '������վ: ' + SCnPackUrl + #13#10 +
    '����֧��: ' + SCnPackEmail + #13#10#13#10 +
    SCnPackCopyright;
{$ELSE}
  SCopyrightFmtStr =
    SCnPackStr + #13#10#13#10 +
    'Component Name: %s' + #13#10 +
    'Author: %s(%s)' + #13#10 +
    'Comment: %s' + #13#10 +
    'HomePage: ' + SCnPackUrl + #13#10 +
    'Email: ' + SCnPackEmail + #13#10#13#10 +
    SCnPackCopyright;
{$ENDIF}

resourcestring

  // �����װ�����
  SCnNonVisualPalette = 'CnPack Tools';
  SCnGraphicPalette = 'CnPack VCL';
  SCnNetPalette = 'CnPack Net';
  SCnDatabasePalette = 'CnPack DB';
  SCnReportPalette = 'CnPack Report';

  // �������Ա��Ϣ���ں�����ӣ�ע�Ȿ�ػ�����
var
  {$IFDEF GB2312}
  SCnPack_Zjy: string = '�ܾ���';
  SCnPack_Shenloqi: string = '����ǿ(Chinbo)';
  SCnPack_xiaolv: string = '������';
  SCnPack_Flier: string = 'Flier Lu';
  SCnPack_LiuXiao: string = '��Х(Passion)';
  SCnPack_PanYing: string = '��ӥ(Pan Ying)';
  SCnPack_Hubdog: string = '��ʡ(Hubdog)';
  SCnPack_Wyb_star: string = '����';
  SCnPack_Licwing: string = '����(Licwing Zue)';
  SCnPack_Alan: string = '��ΰ(Alan)';
  SCnPack_Aimingoo: string = '�ܰ���(Aimingoo)';
  SCnPack_QSoft: string = '����(QSoft)';
  SCnPack_Hospitality: string = '������(Hospitality)';
  SCnPack_SQuall: string = '����(SQUALL)';
  SCnPack_Hhha: string = 'Hhha';
  SCnPack_Beta: string = '�ܺ�(beta)';
  SCnPack_Leeon: string = '���(Leeon)';
  SCnPack_SuperYoyoNc: string = '���ӽ�';
  SCnPack_JohnsonZhong: string = 'Johnson Zhong';
  SCnPack_DragonPC: string = 'Dragon P.C.';
  SCnPack_Kendling: string = 'С��(Kending)';
  SCnPack_ccrun: string = 'ccRun(����)';
{$ELSE}
  SCnPack_Zjy: string = 'Zhou JingYu';
  SCnPack_Shenloqi: string = 'Chinbo';
  SCnPack_xiaolv: string = 'xiaolv';
  SCnPack_Flier: string = 'Flier Lu';
  SCnPack_LiuXiao: string = 'Liu Xiao';
  SCnPack_PanYing: string = 'Pan Ying';
  SCnPack_Hubdog: string = 'Hubdog';
  SCnPack_Wyb_star: string = 'wyb_star';
  SCnPack_Licwing: string = 'Licwing zue';
  SCnPack_Alan: string = 'Alan';
  SCnPack_Aimingoo: string = 'Aimingoo';
  SCnPack_QSoft: string = 'QSoft';
  SCnPack_Hospitality: string = 'ZhangJiongXuan (Hospitality)';
  SCnPack_SQuall: string = 'SQUALL';
  SCnPack_Hhha: string = 'Hhha';
  SCnPack_Beta: string = 'beta';
  SCnPack_Leeon: string = 'Leeon';
  SCnPack_SuperYoyoNc: string = 'SuperYoyoNC';
  SCnPack_JohnsonZhong: string = 'Johnson Zhong';
  SCnPack_DragonPC: string = 'Dragon P.C.';
  SCnPack_Kendling: string = 'Kending';
  SCnPack_ccrun: string = 'ccrun';
{$ENDIF}
  // CnCommon
{$IFDEF GB2312}
  SUnknowError: string = 'δ֪����';
  SErrorCode: string = '������룺';
{$ELSE}
  SUnknowError: string = 'Unknow error';
  SErrorCode: string = 'Error code:';
{$ENDIF}

const
  SCnPack_ZjyEmail = 'zjy@cnpack.org';
  SCnPack_ShenloqiEmail = 'Shenloqi@hotmail.com';
  SCnPack_xiaolvEmail = 'xiaolv888@etang.com';
  SCnPack_FlierEmail = 'flier_lu@sina.com';
  SCnPack_LiuXiaoEmail = 'passion@cnpack.org';
  SCnPack_PanYingEmail = 'panying@sina.com';
  SCnPack_HubdogEmail = 'hubdog@263.net';
  SCnPack_Wyb_starMail = 'wyb_star@sina.com';
  SCnPack_LicwingEmail = 'licwing@chinasystemsn.com';
  SCnPack_AlanEmail = 'BeyondStudio@163.com';
  SCnPack_AimingooEmail = 'aim@263.net';
  SCnPack_QSoftEmail = 'hq.com@263.net';
  SCnPack_HospitalityEmail = 'Hospitality_ZJX@msn.com';
  SCnPack_SQuallEmail = 'squall_sa@163.com';
  SCnPack_HhhaEmail = 'Hhha@eyou.com';
  SCnPack_BetaEmail = 'beta@01cn.net';
  SCnPack_LeeonEmail = 'real-like@163.com';
  SCnPack_SuperYoyoNcEmail = 'superyoyonc@sohu.com';
  SCnPack_JohnsonZhongEmail = 'zhongs@tom.com';
  SCnPack_DragonPCEmail = 'dragonpc@21cn.com';
  SCnPack_KendlingEmail = 'kendling@21cn.com';
  SCnPack_ccRunEmail = 'info@ccrun.com';
  // CnMemProf
{$IFDEF GB2312}
  SCnPackMemMgr = '�ڴ���������';
  SMemLeakDlgReport = '���� %d ���ڴ�©��[�滻�ڴ������֮ǰ�ѷ��� %d ��]��';
  SMemMgrODSReport = '��ȡ = %d���ͷ� = %d���ط��� = %d';
  SMemMgrOverflow = '�ڴ���������ָ���б�������������б�������';
  SMemMgrRunTime = '%d Сʱ %d �� %d �롣';
  SOldAllocMemCount = '�滻�ڴ������ǰ�ѷ��� %d ���ڴ档';
  SAppRunTime = '��������ʱ��: ';
  SMemSpaceCanUse = '���õ�ַ�ռ�: %d ǧ�ֽ�';
  SUncommittedSpace = 'δ�ύ����: %d ǧ�ֽ�';
  SCommittedSpace = '���ύ����: %d ǧ�ֽ�';
  SFreeSpace = '���в���: %d ǧ�ֽ�';
  SAllocatedSpace = '�ѷ��䲿��: %d ǧ�ֽ�';
  SAllocatedSpacePercent = '��ַ�ռ�����: %d%%';
  SFreeSmallSpace = 'ȫ��С�����ڴ��: %d ǧ�ֽ�';
  SFreeBigSpace = 'ȫ��������ڴ��: %d ǧ�ֽ�';
  SUnusedSpace = '����δ���ڴ��: %d ǧ�ֽ�';
  SOverheadSpace = '�ڴ����������: %d ǧ�ֽ�';
  SObjectCountInMemory = '�ڴ������Ŀ: ';
  SNoMemLeak = 'û���ڴ�й©��';
  SNoName = '(δ����)';
  SNotAnObject = '���Ƕ���';
  SByte = '�ֽ�';
  SCommaString = '��';
  SPeriodString = '��';
{$ELSE}
  SCnPackMemMgr = 'CnMemProf';
  SMemLeakDlgReport = 'Found %d memory leaks. [There are %d allocated before replace memory manager.]';
  SMemMgrODSReport = 'Get = %d  Free = %d  Realloc = %d';
  SMemMgrOverflow = 'Memory Manager''s list capability overflow, Please enlarge it!';
  SMemMgrRunTime = '%d hour(s) %d minute(s) %d second(s)��';
  SOldAllocMemCount = 'There are %d allocated before replace memory manager.';
  SAppRunTime = 'Application total run time: ';
  SMemSpaceCanUse = 'HeapStatus.TotalAddrSpace: %d KB';
  SUncommittedSpace = 'HeapStatus.TotalUncommitted: %d KB';
  SCommittedSpace = 'HeapStatus.TotalCommitted: %d KB';
  SFreeSpace = 'HeapStatus.TotalFree: %d KB';
  SAllocatedSpace = 'HeapStatus.TotalAllocated: %d KB';
  SAllocatedSpacePercent = 'TotalAllocated div TotalAddrSpace: %d%%';
  SFreeSmallSpace = 'HeapStatus.FreeSmall: %d KB';
  SFreeBigSpace = 'HeapStatus.FreeBig: %d KB';
  SUnusedSpace = 'HeapStatus.Unused: %d KB';
  SOverheadSpace = 'HeapStatus.Overhead: %d KB';
  SObjectCountInMemory = 'Objects count in memory: ';
  SNoMemLeak = ' No memory leak.';
  SNoName = '(no name)';
  SNotAnObject = ' Not an object';
  SByte = 'Byte';
  SCommaString = ',';
  SPeriodString = '.';
{$ENDIF GB2312}

implementation

end.

