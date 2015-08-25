program Zhonghong;

uses
  Forms,
  MainFrm in '..\Pas\MainFrm.pas' {MainForm},
  ProductManagerFrm in '..\Pas\ProductManagerFrm.pas' {ProductManagerForm},
  KeyPairDictionary in '..\Pas\KeyPairDictionary.pas',
  uFieldItemImpl in '..\Pas\uFieldItemImpl.pas',
  uChooseFrm in '..\Pas\uChooseFrm.pas' {ChooseForm},
  dmMain in '..\Pas\dmMain.pas' {dm: TDataModule},
  uFunc in '..\Pas\uFunc.pas',
  RptDepositFrm in '..\Pas\RptDepositFrm.pas' {RptDepositForm},
  AboutFrm in '..\Pas\AboutFrm.pas' {AboutBox},
  uConfigImpl in '..\Pas\uConfigImpl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
