unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,DataMainImpl, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, RzButton, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid,DBClient;

type
  TMainForm = class(TForm)
    cxgrd1DBTableView1: TcxGridDBTableView;
    cxgrdlvlGrid1Level1: TcxGridLevel;
    cxgrd1: TcxGrid;
    rzbtbtn1: TRzBitBtn;
    ds1: TClientDataSet;
    ds2: TDataSource;
    procedure rzbtbtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation
uses
  EnvironmentImpl;


{$R *.dfm}

procedure TMainForm.rzbtbtn1Click(Sender: TObject);
var
  ADataSet:TClientDataSet;
begin
  if not _Environment.DataAccess.SelectSql('SELECT * FROM am',ADataSet) then Exit;
  ds1.Data := ADataSet.Data;

  ShowMessage(IntToStr(ADataSet.RecordCount));

end;

end.

