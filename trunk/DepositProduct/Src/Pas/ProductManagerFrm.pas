unit ProductManagerFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, ExtCtrls, RzPanel, StdCtrls, Mask, RzEdit, RzLabel,
  DBClient,MainFrm, ActnList;

type
  TProductManagerForm = class(TForm)
    rzpnl2: TRzPanel;
    lbl1: TRzLabel;
    edtName: TRzEdit;
    lbl2: TRzLabel;
    edtCode: TRzEdit;
    lbl4: TRzLabel;
    edtLength: TRzEdit;
    lbl5: TRzLabel;
    edtWidth: TRzEdit;
    lbl3: TRzLabel;
    edtNum: TRzEdit;
    lbl7: TRzLabel;
    edtCircle: TRzEdit;
    btnSave: TRzBitBtn;
    rzbtbtn2: TRzBitBtn;
    lbl8: TRzLabel;
    edtArea: TRzEdit;
    lbl9: TRzLabel;
    edtMemo: TRzEdit;
    lbl10: TRzLabel;
    edtUnitPrice: TRzEdit;
    actlst1: TActionList;
    actMultSave: TAction;
    lbl11: TRzLabel;
    edtTotalAmount: TRzEdit;
    actSave: TAction;
    btnMultSave: TRzBitBtn;
    procedure edtLengthChange(Sender: TObject);
    procedure edtLengthKeyPress(Sender: TObject; var Key: Char);
    procedure actMultSaveExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
  private
    { Private declarations }
    FIsAppend:Boolean;

    function SetCircle:Boolean;
    function SetArea:Boolean;
    function SetToatalAmount:Boolean;
    procedure SetFocusChange(Sender: TObject)  ;
  public
    { Public declarations }

    procedure InitInput;
    procedure SaveProduct;
    property IsAppend:Boolean  read FIsAppend write FIsAppend;


  end ;

var
  ProductManagerForm: TProductManagerForm;

implementation


{$R *.dfm}

function TProductManagerForm.SetCircle:Boolean;
begin
  edtCircle.Text := FloatToStr((StrToFloatDef(edtLength.Text,0.000) + StrToFloatDef(edtWidth.Text,0.000))*2*StrToFloatDef(edtNum.Text,0.000));
end;

function TProductManagerForm.SetArea:Boolean;
begin
  edtArea.Text := FloatToStr((StrToFloatDef(edtLength.Text,0.000) * StrToFloatDef(edtWidth.Text,0.000)*StrToFloatDef(edtNum.Text,0.000))/1000000);
end;

function TProductManagerForm.SetToatalAmount:Boolean;
begin
  edtTotalAmount.Text:= FloatToStr((StrToFloatDef(edtUnitPrice.Text,0.000)*StrToFloatDef(edtLength.Text,0.000) * StrToFloatDef(edtWidth.Text,0.000)*StrToFloatDef(edtNum.Text,0.000))/1000000);
end;

procedure TProductManagerForm.edtLengthChange(Sender: TObject);
begin
  SetCircle;
  SetArea;
  SetToatalAmount;
end;

procedure TProductManagerForm.InitInput;
begin
  edtLength.Text := EmptyStr;
  edtWidth.Text := EmptyStr;
  //edtHeigth.Text := EmptyStr;
  edtName.Text := EmptyStr;
  edtCode.Text := EmptyStr;
  edtNum.Text := '1';
  edtUnitPrice.Text := EmptyStr;
  edtMemo.Text := EmptyStr;

end;

procedure TProductManagerForm.edtLengthKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in ['0'..'9','.',#8]) then key:=#0;
  if (key='.') and (Pos('.',(Sender as TRzEdit).Text)>0) then key:=#0;
end;

procedure TProductManagerForm.SaveProduct;
begin
  if FIsAppend then
  begin
    MainForm.dsDetail.Append;
    MainForm.dsDetail.FieldByName('DepositID').Value := MainForm.HeaderID;
    MainForm.dsDetail.FieldByName('SeqID').Value := MainForm.dsDetail.RecordCount + 1;
  end
  else
  MainForm.dsDetail.Edit;
  MainForm.dsDetail.FieldByName('ProductName').Value := edtName.Text;
  MainForm.dsDetail.FieldByName('ProductCode').Value := edtCode.Text;
  MainForm.dsDetail.FieldByName('Length').Value := StrToFloatDef(edtLength.Text,0.000);
  MainForm.dsDetail.FieldByName('Width').Value := StrToFloatDef(edtWidth.Text,0.000);
  //MainForm.dsDetail.FieldByName('Heigth').Value := StrToFloatDef(edtWidth.Text,0.000);
  MainForm.dsDetail.FieldByName('TotalNum').Value := StrToFloatDef(edtNum.Text,0.000);
  MainForm.dsDetail.FieldByName('UnitPrice').Value := StrToFloatDef(edtUnitPrice.Text,0.000);
  MainForm.dsDetail.FieldByName('Circle').Value := StrToFloatDef(edtCircle.Text,0.000);
  MainForm.dsDetail.FieldByName('Area').Value := StrToFloatDef(edtArea.Text,0.000);
  MainForm.dsDetail.FieldByName('ProductDesc').Value := edtMemo.Text;
  MainForm.dsDetail.FieldByName('Unit').Value := 'Ƭ';
  MainForm.dsDetail.FieldByName('TotalAmount').Value := StrToFloatDef(edtTotalAmount.Text,0.000);
  MainForm.dsDetail.Post;
end;

procedure TProductManagerForm.actMultSaveExecute(Sender: TObject);
begin
  SaveProduct;


end;

procedure TProductManagerForm.actSaveExecute(Sender: TObject);
begin
  SaveProduct;
  Self.ModalResult := mrOk;
end;

procedure TProductManagerForm.SetFocusChange(Sender: TObject);
var
  iTag:Integer;
begin


end;

end.
