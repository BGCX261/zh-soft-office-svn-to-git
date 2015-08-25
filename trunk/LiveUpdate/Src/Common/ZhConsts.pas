{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2006 CnPack 开发组                       }
{                   ------------------------------------                       }
{                                                                              }
{            本开发包是开源的自由软件，您可以遵照 CnPack 的发布协议来修        }
{        改和重新发布这一程序。                                                }
{                                                                              }
{            发布这一开发包的目的是希望它有用，但没有任何担保。甚至没有        }
{        适合特定目的而隐含的担保。更详细的情况请参阅 CnPack 发布协议。        }
{                                                                              }
{            您应该已经和开发包一起收到一份 CnPack 发布协议的副本。如果        }
{        还没有，可访问我们的网站：                                            }
{                                                                              }
{            网站地址：http://www.cnpack.org                                   }
{            电子邮件：master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit ZhConsts;
{* |<PRE>
================================================================================
* 软件名称：开发包基础库
* 单元名称：公共资源字符串定义单元
* 单元作者：CnPack开发组
* 备    注：
* 开发平台：PWin98SE + Delphi 5.0
* 兼容测试：PWin9X/2000/XP + Delphi 5/6
* 本 地 化：该单元中的字符串均符合本地化处理方式
* 单元标识：$Id: CnConsts.pas,v 1.11 2006/09/23 17:27:03 passion Exp $
* 修改记录：
*           2004.09.18 V1.2
*                新增CnMemProf的字符串定义
*           2002.04.18 V1.1
*                新增部分字符串定义
*           2002.04.08 V1.0
*                创建单元
================================================================================
|</PRE>}

interface

uses
  Windows;

//{$I CnPack.inc}

//==============================================================================
// 不需要本地化的字符串
//==============================================================================

resourcestring

  // 注册表路径
  SCnPackRegPath = '\Software\CnPack';

  // 辅助工具路径
  SCnPackToolRegPath = 'CnTools';

//==============================================================================
// 需要本地化的字符串
//==============================================================================


var
  // 公共信息
{$IFDEF GB2312}
  SCnInformation: string = '提示';
  SCnWarning: string = '警告';
  SCnError: string = '错误';
  SCnEnabled: string = '有效';
  SCnDisabled: string = '禁用';
  SCnMsgDlgOK: string = '确认(&O)';
  SCnMsgDlgCancel: string = '取消(&C)';
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
  // 开发包信息
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
  SCnPackGroup = 'CnPack 开发组';
{$ELSE}
  SCnPackGroup = 'CnPack Team';
{$ENDIF}
  SCnPackCopyright = '(C)Copyright 2001-2006 ' + SCnPackGroup;

  // CnPropEditors
{$IFDEF GB2312}
  SCopyrightFmtStr =
    SCnPackStr + #13#10#13#10 +
    '组件名称: %s' + #13#10 +
    '组件作者: %s(%s)' + #13#10 +
    '组件说明: %s' + #13#10#13#10 +
    '下载网站: ' + SCnPackUrl + #13#10 +
    '技术支持: ' + SCnPackEmail + #13#10#13#10 +
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

  // 组件安装面板名
  SCnNonVisualPalette = 'CnPack Tools';
  SCnGraphicPalette = 'CnPack VCL';
  SCnNetPalette = 'CnPack Net';
  SCnDatabasePalette = 'CnPack DB';
  SCnReportPalette = 'CnPack Report';

  // 开发组成员信息请在后面添加，注意本地化处理
var
  {$IFDEF GB2312}
  SCnPack_Zjy: string = '周劲羽';
  SCnPack_Shenloqi: string = '沈龙强(Chinbo)';
  SCnPack_xiaolv: string = '吕宏庆';
  SCnPack_Flier: string = 'Flier Lu';
  SCnPack_LiuXiao: string = '刘啸(Passion)';
  SCnPack_PanYing: string = '潘鹰(Pan Ying)';
  SCnPack_Hubdog: string = '陈省(Hubdog)';
  SCnPack_Wyb_star: string = '王玉宝';
  SCnPack_Licwing: string = '朱磊(Licwing Zue)';
  SCnPack_Alan: string = '张伟(Alan)';
  SCnPack_Aimingoo: string = '周爱民(Aimingoo)';
  SCnPack_QSoft: string = '何清(QSoft)';
  SCnPack_Hospitality: string = '张炅轩(Hospitality)';
  SCnPack_SQuall: string = '刘玺(SQUALL)';
  SCnPack_Hhha: string = 'Hhha';
  SCnPack_Beta: string = '熊恒(beta)';
  SCnPack_Leeon: string = '李柯(Leeon)';
  SCnPack_SuperYoyoNc: string = '许子健';
  SCnPack_JohnsonZhong: string = 'Johnson Zhong';
  SCnPack_DragonPC: string = 'Dragon P.C.';
  SCnPack_Kendling: string = '小冬(Kending)';
  SCnPack_ccrun: string = 'ccRun(老妖)';
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
  SUnknowError: string = '未知错误';
  SErrorCode: string = '错误代码：';
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
  SCnPackMemMgr = '内存管理监视器';
  SMemLeakDlgReport = '出现 %d 处内存漏洞[替换内存管理器之前已分配 %d 处]。';
  SMemMgrODSReport = '获取 = %d，释放 = %d，重分配 = %d';
  SMemMgrOverflow = '内存管理监视器指针列表溢出，请增大列表项数！';
  SMemMgrRunTime = '%d 小时 %d 分 %d 秒。';
  SOldAllocMemCount = '替换内存管理器前已分配 %d 处内存。';
  SAppRunTime = '程序运行时间: ';
  SMemSpaceCanUse = '可用地址空间: %d 千字节';
  SUncommittedSpace = '未提交部分: %d 千字节';
  SCommittedSpace = '已提交部分: %d 千字节';
  SFreeSpace = '空闲部分: %d 千字节';
  SAllocatedSpace = '已分配部分: %d 千字节';
  SAllocatedSpacePercent = '地址空间载入: %d%%';
  SFreeSmallSpace = '全部小空闲内存块: %d 千字节';
  SFreeBigSpace = '全部大空闲内存块: %d 千字节';
  SUnusedSpace = '其它未用内存块: %d 千字节';
  SOverheadSpace = '内存管理器消耗: %d 千字节';
  SObjectCountInMemory = '内存对象数目: ';
  SNoMemLeak = '没有内存泄漏。';
  SNoName = '(未命名)';
  SNotAnObject = '不是对象';
  SByte = '字节';
  SCommaString = '，';
  SPeriodString = '。';
{$ELSE}
  SCnPackMemMgr = 'CnMemProf';
  SMemLeakDlgReport = 'Found %d memory leaks. [There are %d allocated before replace memory manager.]';
  SMemMgrODSReport = 'Get = %d  Free = %d  Realloc = %d';
  SMemMgrOverflow = 'Memory Manager''s list capability overflow, Please enlarge it!';
  SMemMgrRunTime = '%d hour(s) %d minute(s) %d second(s)。';
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

