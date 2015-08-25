program TEST;

uses
  Forms,
  MainFrm in '..\Pas\MainFrm.pas' {MainForm},
  DataMainBaseImpl in '..\Common\DataMainBaseImpl.pas' {DataMainBase: TDataModule},
  DataMainImpl in 'DataMainImpl.pas' {DataMain: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDataMain, DataMain);
  Application.Run;
end.
