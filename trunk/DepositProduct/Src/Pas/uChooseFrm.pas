unit uChooseFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,DBClient,KeyPairDictionary, StdCtrls, Buttons, ExtCtrls,uFieldItemImpl,
  cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, ComCtrls, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ToolWin, dxmdaset, ImgList, ActnList,
  RzButton, RzPanel, RzRadChk;

const
  MaxFormWidth=1000 ;
  MinFormWidth=500 ;
  MinFormWidth2=500 ;
  MaxFormHeight=600 ;
  MinFormHeight=400 ;

type
  TCheckInputEvent=function :boolean of object;
  TChooseForm = class(TForm)
    pnl1: TPanel;
    pnl4: TPanel;
    cxData: TcxGrid;
    cxDataView: TcxGridDBTableView;
    cxDataLevel: TcxGridLevel;
    dxQuery: TdxMemData;
    actList: TActionList;
    actAllSelect: TAction;
    actCancelSelect: TAction;
    actExportOpt: TAction;
    actSelectOpt: TAction;
    il1: TImageList;
    actSearchOpt: TAction;
    dsData: TDataSource;
    actExecute: TAction;
    actUpdate: TAction;
    actSearch: TAction;
    pnl5: TRzPanel;
    edtValues: TEdit;
    lbl2: TLabel;
    cbbFields: TComboBox;
    lbl1: TLabel;
    pnl2: TRzPanel;
    pnlSelect: TRzPanel;
    rztlbr1: TRzToolbar;
    btneAllSelect: TRzToolButton;
    btneCancelSelect: TRzToolButton;
    btneSearch: TRzToolButton;
    btneExportOpt: TRzToolButton;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    chkFilter: TRzCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actExecuteExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cxDataViewCustomDrawIndicatorCell(Sender: TcxGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo;
      var ADone: Boolean);
    procedure cxDataViewCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
  private
    { Private declarations }
    FFieldItems:TFieldItems ;
    FCheckInputEvent: TCheckInputEvent;

    procedure InitializeFormWidth;
    procedure SearchOpt;
    procedure FilterOpt;
    procedure CancelAllOpt;
    procedure SelectAllOpt;
    procedure SelectOpt;
    procedure ExportOpt;
    procedure SearchExecute;
  public
    { Public declarations }
    FExport:Boolean;
    FMultiSelect:boolean ;
    FFindEnable:boolean ;
    FGroupBy:boolean ;
    FKeyFieldName:string ;
    FCheckFieldName:string;
    procedure GetData(ADataSet: TDataSet);
    procedure InitializeGridColumns;
    procedure InitializeVcl;
    property FieldItems:TFieldItems read FFieldItems;
    property CheckInputEvent:TCheckInputEvent read FCheckInputEvent write FCheckInputEvent;
  end;

  TChooseImpl = class(TObject)
  public
    class function ShowChoose(ACaption:string;AdataSet: TDataSet;AFieldItems:TFieldItems;
      var ARstData:TdxMemData;
      const AMultiSelect,AFindEnable,AGroupBy:boolean;AExport:boolean=false):boolean ;
  end;


implementation

{$R *.dfm}



procedure TChooseForm.FormCreate(Sender: TObject);
begin
  self.btnOK.Caption:='确定';
//  self.btnCancel.Caption:='取消';
//  self.btnSearch.Caption:='查询';
//  self.btnSelectAll.Caption:='全选择';
//  self.btnSelectNone.Caption:='全取消';
//  Self.btnSelect.Caption:='反选' ;
//  self.btnExport.Caption:='导出';
  self.chkFilter.Caption:='过滤';
  FMultiSelect:=false ;
  FFindEnable:=false ;
  FExport:=false;
  FGroupBy:=false ;
  FFieldItems:=TFieldItems.Create(nil) ;
  FCheckFieldName:='Checked';
  actExportOpt.Visible:=FExport;
end;



procedure TChooseForm.InitializeVcl;
var
  i:integer ;
begin
  cbbFields.Clear ;
  for i:=0 to FieldItems.Count -1 do
  begin
    if FieldItems.Fields[i].IsShow then
      cbbFields.Items.Add(FieldItems.Fields[i].DisplayLabel);
    if FieldItems.Fields[i].IsKey then
    begin
      FKeyFieldName :=FieldItems.Fields[i].FieldName ;
    end ; 
  end ;

  if cbbFields.Items.Count >0 then cbbFields.ItemIndex :=0 ;
  pnlSelect.Visible :=FMultiSelect ;
  cxDataView.OptionsView.GroupByBox :=FGroupBy ;
  if not FMultiSelect then
    cxDataView.PopupMenu:=nil ;
  InitializeFormWidth ;

end;

procedure TChooseForm.InitializeFormWidth;
var
  i,iLeftWidth,iMinFormWidth:integer ;
begin
  iLeftWidth:=0  ;

  for i:=0 to cxDataView.ColumnCount  -1 do
  begin
    if cxDataView.Columns[i].Visible then
      iLeftWidth:=iLeftWidth + cxDataView.Columns[i].Width ;
  end ;
  
  iMinFormWidth:=MinFormWidth;
  if not FFindEnable then
    iMinFormWidth:=MinFormWidth2;

  if (iLeftWidth+30)<=iMinFormWidth then
  begin
    self.Width :=iMinFormWidth ;
  end else if (iLeftWidth+30)>=MaxFormWidth then
  begin
    self.Width :=MaxFormWidth + 20;
  end else
  begin
    self.Width :=iLeftWidth+50 ;
  end ;
  Self.btnOK.Left:=self.Width - 180;
  Self.btnCancel.Left:=self.Width - 100;

end;

procedure TChooseForm.GetData(ADataSet: TDataSet);
var
  i:integer;
  iField:TField;
begin
  dxQuery.CreateFieldsFromDataSet(ADataSet) ;
  iField:=TBooleanField.Create(dxQuery);
  iField.FieldName:=FCheckFieldName;
  iField.Name:='dxQuery'+FCheckFieldName ;
  iField.DisplayLabel:='选择';
  iField.Visible:=true;
  iField.DataSet:=dxQuery;
  iField.ReadOnly:=False;

  dxQuery.Open ;
  dxQuery.DisableControls ;
  ADataSet.DisableControls ;
  try
    ADataSet.First ;
    while not ADataSet.Eof do
    begin
      dxQuery.Append ;
      dxQuery.FieldByName(FCheckFieldName).Value :='0' ; 
      for i:=0 to ADataSet.FieldCount-1 do
      begin
        if dxQuery.FieldByName(ADataSet.Fields[i].FieldName).FieldKind <>fkData then continue ;  
        dxQuery.FieldByName(ADataSet.Fields[i].FieldName).Value:=ADataSet.Fields[i].Value ; 
      end ;
      dxQuery.Post ;      
      ADataSet.Next ;
    end ;
    dxQuery.First ;
  finally
    ADataSet.EnableControls ;
    dxQuery.EnableControls ;
  end ;

end;

procedure TChooseForm.FormDestroy(Sender: TObject);
begin
  if FFieldItems <> nil then FFieldItems.Free ;
end;

procedure TChooseForm.InitializeGridColumns;
var
  Column:TcxGridDBColumn;
  i:integer ;
begin
  cxDataView.ClearItems ;
  cxDataView.BeginUpdate ;
  if FMultiSelect then
  begin
    Column:=cxDataView.CreateColumn ;
    Column.Name :=cxDataView.Name +FCheckFieldName;
    Column.DataBinding.FieldName :=FCheckFieldName ;
    Column.PropertiesClassName := 'TcxCheckBoxProperties' ;
    Column.Caption := '选择';
    Column.Width :=60 ;
    Column.Options.Editing :=true ;
    Column.Visible :=true ;
  end ;
  for i:=0 to FieldItems.Count -1 do
  begin
    if not FieldItems.Fields[i].IsShow then continue ;
    Column:=cxDataView.CreateColumn ;
    Column.Name :=cxDataView.Name +FieldItems.Fields[i].FieldName;
    Column.DataBinding.FieldName :=FieldItems.Fields[i].FieldName ;
    Column.Caption := FieldItems.Fields[i].DisplayLabel;
    Column.Width :=FieldItems.Fields[i].ShowWidth ;
    Column.Options.Editing :=False ;
    Column.Visible :=true ;
  end ;
  cxDataView.EndUpdate ;
end;

procedure TChooseForm.SearchOpt;
var
  strFieldName,strValues:String ;
  bk:TBookmark ;
begin
  if Trim(edtValues.Text)='' then exit ;
  if cbbFields.ItemIndex =-1 then exit ;
  strFieldName:=dxQuery.Fields[cbbFields.ItemIndex+2].FieldName;

  strValues:=Trim(edtValues.Text) ;
  if FMultiSelect then
  begin
    dxQuery.DisableControls ;
    try
      bk:=dxQuery.GetBookmark ;
      dxQuery.First ;
      while not dxQuery.Eof do
      begin
        dxQuery.Edit ;
        if pos(strValues,Trim(dxQuery.FieldByName(strFieldName).AsString))>0 then
        begin
          dxQuery.FieldByName(FCheckFieldName).Value :='1' ;
          bk:=dxQuery.GetBookmark ;
        end else
        begin
          dxQuery.FieldByName(FCheckFieldName).Value :='0' ;
        end ;
        dxQuery.Post ;
        dxQuery.Next ;
      end ;
      dxQuery.GotoBookmark(bk) ;
    finally
      dxQuery.EnableControls ;
    end; 
  end else
  begin
    dxQuery.DisableControls ;
    try
      bk:=dxQuery.GetBookmark ;
      dxQuery.Next ;
      while not dxQuery.Eof do
      begin
        if pos(strValues,Trim(dxQuery.FieldByName(strFieldName).AsString))>0 then
        begin
          exit ;
        end ;
        dxQuery.Next ;
      end ;
      dxQuery.first ;
      while not dxQuery.Eof do
      begin
        if pos(strValues,Trim(dxQuery.FieldByName(strFieldName).AsString))>0 then
        begin
          exit ;
        end ;
        dxQuery.Next ;
      end ;      
      dxQuery.GotoBookmark(bk) ;

    finally
      dxQuery.EnableControls ;
    end ;
  end ;
end;

procedure TChooseForm.CancelAllOpt;
var
  bk:TBookmark ;
begin
  dxQuery.DisableControls ;
  try
    bk:=dxQuery.GetBookmark ;
    dxQuery.First ;
    while not dxQuery.Eof do
    begin
      dxQuery.Edit ;
      dxQuery.FieldByName(FCheckFieldName).Value :='0' ;
      dxQuery.Post ;
      dxQuery.Next ;
    end;
    dxQuery.GotoBookmark(bk) ;
  finally
    dxQuery.EnableControls ;
  end ;
end;

procedure TChooseForm.SelectAllOpt;
var
  bk:TBookmark ;
  i,j,Idx:integer ;
  strFields:string ;
  vValues:Variant ;
begin
  if cxDataView.DataController.Filter.Active and not cxDataView.DataController.Filter.IsEmpty then
  begin
    Idx := cxDataView.DataController.FocusedRowIndex;
      with dxQuery do
      begin
        DisableControls;
        bk := GetBookmark;
        for I := 0 to cxDataView.ViewData.RowCount - 1 do
        begin
          strFields:='';
          vValues:=VarArrayCreate([0,cxDataView.ColumnCount -1], varVariant);
          for j :=0 to cxDataView.ColumnCount -1 do
          begin
            strFields:=strFields+cxDataView.Columns[j].DataBinding.FieldName+';';
          end ;
          strFields:=copy(strFields,1,length(strFields)-1);
          if Locate(strFields, vValues,[]) then
          begin
            edit;
            FieldByName(FCheckFieldName).Value := '1';
            Post;
          end ;
        end;
        if BookmarkValid(bk) then
          GotoBookmark(bk);
        FreeBookmark(bk);
        EnableControls;
      end;
      cxDataView.DataController.FocusedRowIndex := Idx;
      cxDataView.DataController.EndUpdate;
  end else
  begin
    dxQuery.DisableControls ;
    try
      bk:=dxQuery.GetBookmark ;
      dxQuery.First ;
      while not dxQuery.Eof do
      begin
        dxQuery.Edit ;
        dxQuery.FieldByName(FCheckFieldName).Value :='1' ;
        dxQuery.Post ;
        dxQuery.Next ;
      end;
      dxQuery.GotoBookmark(bk) ;
    finally
      dxQuery.EnableControls ;
    end ;
  end ;
end;

procedure TChooseForm.FilterOpt;
var
  strFieldName,strValues:String ;
begin
  if Trim(edtValues.Text)='' then exit ;
  if cbbFields.ItemIndex =-1 then exit ;
  strFieldName:=dxQuery.Fields[cbbFields.ItemIndex+2].FieldName;
  strValues:=Trim(edtValues.Text) ;
  if cxDataView.GetColumnByFieldName(strFieldName)<>nil then
  begin
    cxDataView.DataController.Filter.Clear ;
    cxDataView.DataController.Filter.AddItem(nil,
      cxDataView.GetColumnByFieldName(strFieldName),
      folike,
      cxDataView.DataController.Filter.PercentWildcard+strValues+cxDataView.DataController.Filter.PercentWildcard,
      strValues);
    cxDataView.DataController.Filter.Active :=true ;
  end ;
end;


procedure TChooseForm.btnOKClick(Sender: TObject);
begin
  if Assigned(FCheckInputEvent)then
  begin
    if  not FCheckInputEvent then exit;
  end ;
  self.ModalResult :=mrok;
end;

procedure TChooseForm.btnCancelClick(Sender: TObject);
begin
  self.ModalResult:=mrCancel;
end;

procedure TChooseForm.SelectOpt;
var
  bk:TBookmark ;
  isChecked:Boolean;
begin
  dxQuery.DisableControls ;
  try
    bk:=dxQuery.GetBookmark ;
    dxQuery.First ;
    while not dxQuery.Eof do
    begin
      isChecked:=dxQuery.FieldByName(FCheckFieldName).Value;
      if isChecked  then
      begin
        dxQuery.Edit ;
        dxQuery.FieldByName(FCheckFieldName).Value :='0' ;
        dxQuery.Post ;
        dxQuery.Next ;
      end
      else
      begin
        dxQuery.Edit ;
        dxQuery.FieldByName(FCheckFieldName).Value :='1' ;
        dxQuery.Post ;
        dxQuery.Next ;
      end;
    end;
    dxQuery.GotoBookmark(bk) ;
  finally
    dxQuery.EnableControls ;
  end ;

end;

procedure TChooseForm.ExportOpt;
begin

end;

procedure TChooseForm.actExecuteExecute(Sender: TObject);
begin
  case TAction(Sender).Tag of
    0:SelectAllOpt;
    1:CancelAllOpt;
    2:ExportOpt;
    3:SelectOpt;
    5:SearchExecute;
  end;
end;

procedure TChooseForm.SearchExecute;
begin
  cxDataView.DataController.Filter.Active :=false ;
  if chkFilter.Checked then
    FilterOpt
  else
    SearchOpt ;
end;

procedure TChooseForm.FormResize(Sender: TObject);
begin
  Self.btnOK.Left:=self.Width - 180;
  Self.btnCancel.Left:=self.Width - 100;
end;

class function TChooseImpl.ShowChoose(ACaption:string;AdataSet: TDataSet;AFieldItems:TFieldItems;
  var ARstData:TdxMemData;
  const AMultiSelect,AFindEnable,AGroupBy:boolean;AExport:boolean=false):boolean ;
var
  fm:TChooseForm;
  i:integer ;
begin
  result:=false ;
  if ARstData=nil then
    ARstData:=TdxMemData.Create(nil);
  fm:=TChooseForm.Create(nil);
  try
    fm.Caption :=ACaption ;
    fm.FMultiSelect := AMultiSelect ;
    fm.FFindEnable :=AFindEnable ;
    fm.FGroupBy :=AGroupBy ;
    fm.FieldItems.Assign(AFieldItems) ;

    fm.GetData(AdataSet) ; 
    fm.InitializeGridColumns ;
    fm.InitializeVcl ;
    if AExport then
    begin
      fm.pnlSelect.Visible:=not AMultiSelect;
    end ;
    fm.ShowModal ;
    if fm.ModalResult = mrOk  then
    begin
      ARstData.Close ;
      ARstData.CreateFieldsFromDataSet(AdataSet) ;
      
      ARstData.Open ;

      if AMultiSelect then
      begin
        if fm.dxQuery.IsEmpty then exit ;

        fm.dxQuery.DisableControls ;
        fm.dxQuery.First ;
        while not fm.dxQuery.Eof do
        begin
          if not fm.dxQuery.FieldByName(fm.FCheckFieldName).AsBoolean then
          begin
            fm.dxQuery.next ;
            continue ;
          end ;
          ARstData.Append ;
          for i:=0 to ARstData.FieldCount-1 do
          begin
            if ARstData.Fields[i].FieldKind <>fkData then continue ;  
            ARstData.Fields[i].Value:=fm.dxQuery.FieldByName(ARstData.Fields[i].FieldName).Value ;
          end ;
          ARstData.Post ;
          fm.dxQuery.Next ;
        end ;
        fm.dxQuery.EnableControls ;
      end else
      begin
        if fm.dxQuery.IsEmpty then exit ;
        
        ARstData.Append ;
        for i:=0 to ARstData.FieldCount-1 do
        begin
          if ARstData.Fields[i].FieldKind <>fkData then continue ;
          ARstData.Fields[i].Value:=fm.dxQuery.FieldByName(ARstData.Fields[i].FieldName).Value ; 
        end ;
        ARstData.Post ;
      end ;
      result:=not ARstData.IsEmpty ;
    end ;
  finally
    fm.Free ;
  end ;
end ;

procedure TChooseForm.cxDataViewCustomDrawIndicatorCell(
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

procedure TChooseForm.cxDataViewCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  Self.ModalResult := mrOk;
end;

end.
