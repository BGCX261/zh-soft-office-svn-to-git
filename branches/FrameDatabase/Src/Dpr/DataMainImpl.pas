unit DataMainImpl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DataMainBaseImpl, ADODB, Provider, DB, DBClient,DataAccessInt;

type
  TDataMain = class(TDataMainBase,IDataAccessInt)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataMain: TDataMain;

implementation
uses
  EnvironmentImpl;

{$R *.dfm}

procedure TDataMain.DataModuleCreate(Sender: TObject);
begin
  inherited;
  _Environment.InitializeEnvironment;
end;

procedure TDataMain.DataModuleDestroy(Sender: TObject);
begin
  inherited;
  //
end;

end.
