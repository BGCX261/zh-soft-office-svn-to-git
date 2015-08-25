unit RptDepositFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls, DB, DBClient;

type
  TRptDepositForm = class(TForm)
    QuickRep: TQuickRep;
    QRBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRBand2: TQRBand;
    QRDBText1: TQRDBText;
    QRLabel3: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel7: TQRLabel;
    QRDBText6: TQRDBText;
    QRLabel12: TQRLabel;
    QRDBText11: TQRDBText;
    QRDBText5: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText7: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel4: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel2: TQRLabel;
    QRBand3: TQRBand;
    QRShape2: TQRShape;
    QRLabel14: TQRLabel;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    lbl: TQRShape;
    QRLabel15: TQRLabel;
    QRLabel16: TQRLabel;
    QRLabel17: TQRLabel;
    QRLabel18: TQRLabel;
    QRShape3: TQRShape;
    QRLabel19: TQRLabel;
    QRShape7: TQRShape;
    QRLabel20: TQRLabel;
    QRShape8: TQRShape;
    QRLabel21: TQRLabel;
    QRBand4: TQRBand;
    QRShape9: TQRShape;
    QRShape10: TQRShape;
    QRShape11: TQRShape;
    QRShape12: TQRShape;
    QRShape13: TQRShape;
    QRShape14: TQRShape;
    QRShape15: TQRShape;
    QRShape16: TQRShape;
    QRShape17: TQRShape;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    QRDBText19: TQRDBText;
    QRDBText20: TQRDBText;
    QRBand5: TQRBand;
    QRShape18: TQRShape;
    QRShape19: TQRShape;
    QRShape20: TQRShape;
    dsHeader: TClientDataSet;
    dsDetail: TClientDataSet;
    ChildBand1: TQRChildBand;
    QRLabel31: TQRLabel;
    QRLabel32: TQRLabel;
    QRLabel33: TQRLabel;
    QRLabel34: TQRLabel;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRLabel35: TQRLabel;
    QRLabel36: TQRLabel;
    QRDBText10: TQRDBText;
    QRShape21: TQRShape;
    lblNum: TQRLabel;
    lblArea: TQRLabel;
    lblAmount: TQRLabel;
    qrshp1: TQRShape;
    qrlbl1: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RptDepositForm: TRptDepositForm;

implementation

{$R *.dfm}

end.
