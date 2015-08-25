program LiveUpdate;

uses
  Forms,
  MainFrm in '..\Pas\MainFrm.pas' {MainForm},
  ZhCustomUtils in '..\Common\ZhCustomUtils.pas',
  ZhFileTreeImpl in '..\Common\ZhFileTreeImpl.pas',
  ZhFileUtils in '..\Common\ZhFileUtils.pas',
  ZhFtpTransferImpl in '..\Common\ZhFtpTransferImpl.pas',
  ZhPubUtils in '..\Common\ZhPubUtils.pas',
  ZhSocketTransferImpl in '..\Common\ZhSocketTransferImpl.pas',
  ZhTreeImpl in '..\Common\ZhTreeImpl.pas',
  ZhVersionImpl in '..\Common\ZhVersionImpl.pas',
  ZhXmlParserImpl in '..\Common\ZhXmlParserImpl.pas',
  ZhConstProtocol in '..\Common\ZhConstProtocol.pas',
  ZhStream in '..\Common\ZhStream.pas',
  ZhCommon in '..\Common\ZhCommon.pas',
  ZhConsts in '..\Common\ZhConsts.pas',
  ZhIni in '..\Common\ZhIni.pas',
  ZhIniStrUtils in '..\Common\ZhIniStrUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
