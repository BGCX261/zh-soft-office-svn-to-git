unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Menus, AdvMenus, RzStatus, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, RzButton, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  RzSplit, ComCtrls, ActnList, ImgList, RzTabs, StdCtrls, RzEdit, Mask,
  RzLabel, RzDTP, DBClient,dxmdaset,cxExportGrid4Link, RpBase, RpSystem,
  RpDefine, RpRave, cxCurrencyEdit;

type
  TOptionStatus = (osNone,osBrowse,osAppend,osEdit);
  TMainForm = class(TForm)
    advmnmn1: TAdvMainMenu;
    mniN1: TMenuItem;
    mniN2: TMenuItem;
    mniN3: TMenuItem;
    mniHelp: TMenuItem;
    stat1: TStatusBar;
    rztlbr1: TRzToolbar;
    rzspltr1: TRzSplitter;
    pnlEdit: TRzPanel;
    rzpnl2: TRzPanel;
    btneAdd: TRzToolButton;
    actlst1: TActionList;
    ilSmall: TImageList;
    ilLarge: TImageList;
    btneEdit: TRzToolButton;
    btneDel: TRzToolButton;
    btneCancel: TRzToolButton;
    btneSave: TRzToolButton;
    btneSearch: TRzToolButton;
    actEdit: TAction;
    actDel: TAction;
    actSave: TAction;
    actCancel: TAction;
    actSearch: TAction;
    actAdd: TAction;
    actExport: TAction;
    actImport: TAction;
    actPrint: TAction;
    actExit: TAction;
    btneSearch1: TRzToolButton;
    btneSearch2: TRzToolButton;
    btneSearch3: TRzToolButton;
    btneSearch4: TRzToolButton;
    rzspcr1: TRzSpacer;
    lbl1: TRzLabel;
    edtCode: TRzEdit;
    lbl2: TRzLabel;
    edtRevDeptName: TRzEdit;
    lbl3: TRzLabel;
    lbl4: TRzLabel;
    edtRevUserName: TRzEdit;
    lbl5: TRzLabel;
    edtRevUserPhone: TRzEdit;
    lbl6: TRzLabel;
    edtRevUserAddr: TRzEdit;
    lbl7: TRzLabel;
    lbl8: TRzLabel;
    lbl9: TRzLabel;
    mmoDepositDesc: TRzMemo;
    lbl10: TRzLabel;
    dtDepositTime: TRzDateTimePicker;
    dtSendTime: TRzDateTimePicker;
    rztlbr2: TRzToolbar;
    btneAddProduct: TRzToolButton;
    btneDelProduct: TRzToolButton;
    actAddProduct: TAction;
    actDelProduct: TAction;
    cxgrd: TcxGrid;
    cxgrdView: TcxGridDBTableView;
    cxgrdlvlLevel: TcxGridLevel;
    sDetail: TDataSource;
    dsDetail: TClientDataSet;
    cxgrdbclmnViewDBColumn1: TcxGridDBColumn;
    cxgrdbclmnViewDBColumn2: TcxGridDBColumn;
    cxgrdViewDBColumn1: TcxGridDBColumn;
    cxgrdViewDBColumn2: TcxGridDBColumn;
    cxgrdbclmnViewDBColumn3: TcxGridDBColumn;
    cxgrdViewDBColumn3: TcxGridDBColumn;
    cxgrdbclmnViewDBColumn4: TcxGridDBColumn;
    cxgrdViewDBColumn4: TcxGridDBColumn;
    dsHeader: TClientDataSet;
    sHeader: TDataSource;
    lbl11: TRzLabel;
    edtSendDeptName: TRzEdit;
    cxgrdbclmnViewDBColumn5: TcxGridDBColumn;
    cxgrdbclmnViewDBColumn6: TcxGridDBColumn;
    cxgrdbclmnViewDBColumn7: TcxGridDBColumn;
    edtSendDeptAddr: TRzEdit;
    lbl12: TRzLabel;
    edtSendUserPhone: TRzEdit;
    lbl13: TRzLabel;
    rvprjct1: TRvProject;
    rvsystm1: TRvSystem;
    cxgrdbclmnViewDBColumn8: TcxGridDBColumn;
    mniViewHelp: TMenuItem;
    mniU1: TMenuItem;
    mniExit: TMenuItem;
    procedure ActionExcute(Sender:TObject);
    procedure ActionUpdate(Sender:TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxgrdViewCustomDrawIndicatorCell(Sender: TcxGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo;
      var ADone: Boolean);
    procedure cxgrdViewCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mniViewHelpClick(Sender: TObject);
  private
    { Private declarations }
    FOptionStatus :TOptionStatus;
    FHeaderID:Integer;
    procedure AddOpt;
    procedure EditOpt;
    procedure DelOpt;
    procedure CancelOpt;
    procedure SaveOpt;
    procedure SearchOpt;
    procedure ExportOpt;
    procedure ImportOpt;
    procedure PrintOpt;

    procedure AddProduct;
    procedure  DditProduct;
    procedure DelProduct;
    function GetHeader(HeaderID:Integer):Boolean;
    function GetDetail(HeaderID:Integer):Boolean;
    function GetData:Boolean;
    procedure InitInput;
    procedure SetReadOnly(IsReadOnly:Boolean);
    function GetDepositID:Integer;
    function GetDepositSeqID:Integer;


  public
    { Public declarations }
    property OptionStatus:TOptionStatus  read FOptionStatus write FOptionStatus;
    property HeaderID:Integer  read FHeaderID write FHeaderID;
  end;

var
  MainForm: TMainForm;

implementation
uses
  ProductManagerFrm,dmMain,uFunc,RptDepositFrm,AboutFrm;

{$R *.dfm}

procedure TMainForm.ActionExcute(Sender:TObject);
begin
  //
  case TAction(Sender).Tag of
  0:AddOpt;
  1:EditOpt;
  2:DelOpt;
  3:SaveOpt;
  4:CancelOpt;
  5:SearchOpt;
  6:ExportOpt;
  7:ImportOpt;
  8:PrintOpt;
  9:Close;
  10:AddProduct;
  11:DelProduct;

  end;
end;
procedure TMainForm.ActionUpdate(Sender:TObject);
begin
  //
  case TAction(Sender).Tag of
  0:actAdd.Enabled := FOptionStatus = osBrowse;
  1:actEdit.Enabled := (FOptionStatus = osBrowse) and (FHeaderID > 0);
  2:actDel.Enabled := (FOptionStatus = osBrowse) and (FHeaderID > 0);
  3:actSave.Enabled := FOptionStatus <> osBrowse;
  4:actCancel.Enabled := FOptionStatus <> osBrowse; 
  5:actSearch.Enabled := FOptionStatus = osBrowse;
  6:actExport.Enabled := (FOptionStatus = osBrowse) and (FHeaderID > 0);
  7:actImport.Enabled := FOptionStatus = osBrowse;
  8:actPrint.Enabled := (FOptionStatus = osBrowse) and (FHeaderID > 0);
  10:actAddProduct.Enabled := FOptionStatus <> osBrowse;
  11:actDelProduct.Enabled := FOptionStatus <> osBrowse;
  end;
  SetReadOnly(FOptionStatus = osBrowse);

end;

function TMainForm.GetHeader(HeaderID:Integer):Boolean;
begin
  //

  if not dm.SelectSql(Format('SELECT * FROM DepositHeader WHERE DepositID = %d ',[HeaderID]),dsHeader) then Exit;
  edtCode.Text := dsHeader.FieldByName('DepositCode').AsString;
  edtRevDeptName.Text := dsHeader.FieldByName('RevDeptName').AsString;
  dtDepositTime.DateTime := dsHeader.FieldByName('DepositTime').AsDateTime;;
  edtRevUserName.Text := dsHeader.FieldByName('RevUserName').AsString;
  edtRevUserPhone.Text := dsHeader.FieldByName('RevUserPhone').AsString;
  edtRevUserAddr.Text := dsHeader.FieldByName('RevUserAddr').AsString;
  dtSendTime.DateTime := dsHeader.FieldByName('SendTime').AsDateTime;
  edtSendDeptName.Text := dsHeader.FieldByName('SendDeptName').AsString;
  mmoDepositDesc.Text := dsHeader.FieldByName('DepositDesc').AsString;
  edtSendDeptAddr.Text := dsHeader.FieldByName('SendDeptAddr').AsString ;
  edtSendUserPhone.Text := dsHeader.FieldByName('SendUserPhone').AsString ;


end;

function TMainForm.GetDetail(HeaderID:Integer):Boolean;
begin
  //
    if not dm.SelectSql(Format('SELECT * FROM DepositDetail WHERE DepositID = %d',[HeaderID]),dsDetail) then Exit;
end;

function TMainForm.GetData:Boolean;
begin
  //
  
  if not GetHeader(FHeaderID) then Exit  ;
  if not GetDetail(FHeaderID) then Exit;

end;

procedure TMainForm.AddOpt;
begin
  //
  FHeaderID := GetDepositID;
  self.InitInput;
  FOptionStatus := osAppend;
  
end;
procedure TMainForm.EditOpt;
begin
  //
  FOptionStatus := osEdit;
end;
procedure TMainForm.DelOpt;
const
  AExecSql = 'Update DepositHeader SET IsDelete =1 WHERE DepositID = %d';
begin
  //
  if not MessageConfirm(Format('确认要删除订单号为[%s]的订单吗？',[dsHeader.FieldByName('DepositCode').AsString])) then Exit;
  if not dm.ExecSql(Format(AExecSql,[FHeaderID])) then Exit;
end;
procedure TMainForm.CancelOpt;
begin
  //
  FOptionStatus := osBrowse;
end;
procedure TMainForm.SaveOpt;
begin
  //

  if FOptionStatus = osAppend then dsHeader.Append;
  dsHeader.Edit;
  dsHeader.FieldByName('DepositID').Value := FHeaderID;
  dsHeader.FieldByName('DepositCode').Value := edtCode.Text;
  dsHeader.FieldByName('RevDeptName').Value := edtRevDeptName.Text ;
  dsHeader.FieldByName('DepositTime').Value := dtDepositTime.DateTime ;
  dsHeader.FieldByName('RevUserName').Value := edtRevUserName.Text ;
  dsHeader.FieldByName('RevUserPhone').Value := edtRevUserPhone.Text;
  dsHeader.FieldByName('RevUserAddr').Value := edtRevUserAddr.Text ;
  dsHeader.FieldByName('SendTime').Value := dtSendTime.DateTime ;
  dsHeader.FieldByName('SendDeptName').Value := edtSendDeptName.Text;
  dsHeader.FieldByName('DepositDeptName').Value := edtRevDeptName.Text ;
  dsHeader.FieldByName('DepositDesc').Value := mmoDepositDesc.Text;
  dsHeader.FieldByName('SendDeptAddr').Value := edtSendDeptAddr.Text;
  dsHeader.FieldByName('SendUserPhone').Value := edtSendUserPhone.Text;
  dsHeader.FieldByName('LastUpdateTime').Value := Now;
  dsHeader.FieldByName('TotalNum').Value := cxgrdView.DataController.Summary.FooterSummaryValues[2];
  dsHeader.FieldByName('TotalAmount').Value := cxgrdView.DataController.Summary.FooterSummaryValues[1];
  dsHeader.Post;

  try
    if dsHeader.ChangeCount <> 0 then
    if not ApplyUpdates(dsHeader.Delta,'DepositHeader','DepositID') then Exit;
    if dsDetail.ChangeCount <> 0 then
    if not ApplyUpdates(dsDetail.Delta,'DepositDetail','DepositID,SeqID') then Exit;
    MessageInform('保存成功!');
  except
    on e:Exception do
    begin
      MessageError('保存失败:'+e.Message);
      Exit;
    end;
  end;

  FOptionStatus := osBrowse;
end;
procedure TMainForm.SearchOpt;
var
  ARstData :TdxMemData;
begin
  //
  ARstData := TdxMemData.Create(nil);
  try
    if not ChooseDepositHeader('1=1 AND dh.IsDelete = 0',False,ARstData) then  Exit;

    FHeaderID := ARstData.FieldByName('DepositID').AsInteger;
    Self.GetData;

  finally
    //if ARstData <> nil then ARstData.Free;
  end;
end;
procedure TMainForm.ExportOpt;
var
  saveDlg : TSaveDialog;
begin
  //
  saveDlg := TSaveDialog.Create(nil);
  try
    saveDlg.Filter :=  '*.xls|*.xls';;
    if not saveDlg.Execute then Exit;
    ExportGrid4ToExcel(saveDlg.FileName,cxgrd,true,true,true,'xls');
    MessageInform('导出成功:'+ saveDlg.FileName+'.xls');
  finally

  end;
end;
procedure TMainForm.ImportOpt;
begin
  //
end;
procedure TMainForm.PrintOpt;
var
  frm:TRptDepositForm;
begin
  //
  frm := TRptDepositForm.Create(nil);
  frm.dsHeader.Data :=  dsHeader.Data;
  frm.dsDetail.Data := dsDetail.Data;
  frm.lblNum.Caption :=  FormatFloat('0',cxgrdView.DataController.Summary.FooterSummaryValues[2]);
  frm.lblArea.Caption := FormatFloat('0.000',cxgrdView.DataController.Summary.FooterSummaryValues[0]);
  frm.lblAmount.Caption := FormatFloat('0.00',cxgrdView.DataController.Summary.FooterSummaryValues[1]);
  frm.QuickRep.PreviewModal;
  
end;

procedure TMainForm.AddProduct;
var
  frm:TProductManagerForm  ;
begin
  //
  frm := TProductManagerForm.Create(nil);
  try
    frm.InitInput;
    frm.IsAppend := True;
    frm.ShowModal;

  finally
    frm.free;
  end;
end;
procedure TMainForm.DelProduct;
begin
  //
  dsDetail.Delete;
end;

function TMainForm.GetDepositSeqID:Integer;
const
  ASql = 'SELECT COUNT(*) FROM DepositHeader dh WHERE DATEDIFF(''d'',dh.DepositTime,NOW()) = 0';
var
  ADataSet:TClientDataSet;
begin
  ADataSet := TClientDataSet.Create(nil);
  try
    if not dm.SelectSql(ASql,ADataSet) then Exit;
    Result := ADataSet.Fields[0].AsInteger + 1;
  finally
    if ADataSet <> nil then ADataSet.Free;
  end;


end;  

procedure TMainForm.InitInput;
begin

  edtCode.Text := FormatDateTime('YYYYMMDD',Now) +'.' + Format('%.3d', [GetDepositSeqID]);
  edtRevDeptName.Text := EmptyStr;
  edtRevUserName.Text := EmptyStr;
  edtRevUserPhone.Text := EmptyStr;
  edtRevUserAddr.Text := EmptyStr;
  dtDepositTime.DateTime := Now;
  dtSendTime.DateTime := Now;
  edtSendDeptName.Text := '温江百信玻璃行';
  edtSendDeptAddr.Text := '温江德通桥旧货市场' ;
  edtSendUserPhone.Text := '02867233938;15196686827;13438121455';
  edtRevDeptName.SetFocus;
  dsHeader.EmptyDataSet;
  dsDetail.EmptyDataSet;

end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  actImport.Visible := False;
  FOptionStatus := osBrowse;
  self.GetData;


end;

procedure TMainForm.SetReadOnly(IsReadOnly:Boolean);
var
  i: integer;
begin
//  for i:=0 to pnlEdit.ControlCount do
//  begin
//    if pnlEdit.Controls[i] is TRzEdit then
//      (pnlEdit.Controls[i] as TRzEdit).ReadOnly := IsReadOnly;
//  end;
  edtCode.ReadOnly := True;
  edtRevDeptName.ReadOnly := IsReadOnly;
  edtRevUserName.ReadOnly := IsReadOnly;
  edtRevUserPhone.ReadOnly := IsReadOnly;
  edtRevUserAddr.ReadOnly := IsReadOnly;
  edtSendDeptName.ReadOnly := IsReadOnly;
  edtSendDeptAddr.ReadOnly := IsReadOnly;
  edtSendUserPhone.ReadOnly := IsReadOnly;
  mmoDepositDesc.ReadOnly := IsReadOnly;
  dtDepositTime.Enabled := not IsReadOnly;
  dtSendTime.Enabled :=  not IsReadOnly;
end;

procedure TMainForm.cxgrdViewCustomDrawIndicatorCell(
  Sender: TcxGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
var
  FValue: string;
  FBounds: TRect;
begin
  //inherited;
  FBounds := AViewInfo.Bounds;
  if (AViewInfo is TcxGridIndicatorRowItemViewInfo) then
  begin
    ACanvas.FillRect(FBounds);
    ACanvas.DrawComplexFrame(FBounds, clBlack, clBlack, [bBottom, bLeft, bRight], 1);
    FValue := IntToStr(TcxGridIndicatorRowItemViewInfo(AViewInfo).GridRecord.Index+1);
    InflateRect(FBounds, -3, -2);
    ACanvas.Font.Color := clBlack;
    ACanvas.Brush.Style := bsClear;
    ACanvas.DrawText(FValue, FBounds, cxAlignCenter or cxAlignTop);
    ADone := True;
  end;

end;

procedure TMainForm.cxgrdViewCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);

begin
  //
  try
    DditProduct;
    AHandled :=  True;
  except
  end;

end;

procedure  TMainForm.DditProduct;
var
  frm : TProductManagerForm;
begin
  //
  if  FOptionStatus = osBrowse then Exit;
  frm := TProductManagerForm.Create(nil);
  try
    frm.edtName.Text := dsDetail.FieldByName('ProductName').AsString;
    frm.edtCode.Text := dsDetail.FieldByName('ProductCode').AsString;
    frm.edtLength.Text := dsDetail.FieldByName('Length').AsString;
    frm.edtWidth.Text := dsDetail.FieldByName('Width').AsString;
    //frm.edtHeigth.Text := dsDetail.FieldByName('Heigth').AsString;
    frm.edtNum.Text := dsDetail.FieldByName('TotalNum').AsString;
    frm.edtUnitPrice.Text := dsDetail.FieldByName('UnitPrice').AsString;
    frm.edtCircle.Text := dsDetail.FieldByName('Circle').AsString;
    frm.edtArea.Text := dsDetail.FieldByName('Area').AsString;
    frm.edtMemo.Text := dsDetail.FieldByName('ProductDesc').AsString;
    frm.edtTotalAmount.Text := dsDetail.FieldByName('TotalAmount').AsString;
    frm.IsAppend := False;
    frm.ShowModal;

  finally
    frm.Free;
  end;

end;

function TMainForm.GetDepositID:Integer;
const
  ASql = 'SELECT MAX(DepositID) AS ID FROM DepositHeader WHERE 1=1';
var
  ADataSet:TClientDataSet;
begin
  ADataSet := TClientDataSet.Create(nil);
  try
    if not dm.SelectSql(ASql,ADataSet) then Exit;
    Result := ADataSet.Fields[0].AsInteger + 1;
  finally
    if ADataSet <> nil then ADataSet.Free;
  end;


end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FOptionStatus <> osBrowse then
  if MessageConfirm('订单信息处于编辑状态，是否需要保存再退出？') then
  begin
    CanClose := False;
  end;

end;

procedure TMainForm.mniViewHelpClick(Sender: TObject);
var
  frm :TAboutBox;
begin
  frm :=  TAboutBox.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;

end;

end.
