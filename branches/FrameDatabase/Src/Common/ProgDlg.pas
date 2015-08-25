unit ProgDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, ExtCtrls, ExForm, TntStdCtrls, Buttons, TntButtons;

type
  TProgressDialog = class(TExForm)
    lTryStopping: TLabel;
    ProgPanel: TPanel;
    ProgressBar: TGauge;
    lPrompt: TTntLabel;
    CancelButton: TTntBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCanBreak,FTaskDone:Boolean;
    procedure SetCanBreak(const Value: Boolean);
  protected
    procedure ModalShown;override;
  public
    { Public declarations }
    TaskCanceled:Boolean;
    function AddProgress(iAdd:Integer=1):Integer;
    function DlgShowProgress(const TaskTitle:string;TaskMax:Integer):Boolean;
    procedure initMulitLanguage;
    property CanBreak:Boolean read FCanBreak write SetCanBreak;
  end;

var
  ProgressDialog: TProgressDialog;

implementation

{$R *.DFM}

uses ShareLib;

procedure TProgressDialog.ModalShown;
begin
  FTaskDone:=False;
  try
    if (Top<0)or(Top+Height>Screen.Height)then
      Top:=(Screen.Height-Height) div 2;
    inherited ModalShown;
    if(TaskCanceled)then ModalResult:=mrCancel
    else ModalResult:=mrOK;
  finally
    FTaskDone:=True;
  end;
end;

procedure TProgressDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if(ModalResult=0)and(not CanBreak)and(not TaskCanceled)then CancelButtonClick(nil);
  CanClose:=FTaskDone;
end;

function TProgressDialog.AddProgress(iAdd:Integer):Integer;
begin
  ProgressBar.Progress:=ProgressBar.Progress+iAdd;
  Application.ProcessMessages;
  if(TaskCanceled)then Abort;
  Result:=ProgressBar.Progress;
end;

function TProgressDialog.DlgShowProgress(const TaskTitle:string;TaskMax:Integer):Boolean;
begin
  Caption:=TaskTitle;
  lPrompt.Caption:='正在进行'+TaskTitle+'...';//'正在进行'+
  lTryStopping.Caption:='正在终止'+TaskTitle+'...';//'正在终止'
  lPrompt.Visible:=True;
  lTryStopping.Visible:=False;

  ProgressBar.MinValue:=0;
  ProgressBar.MaxValue:=TaskMax;
  ProgressBar.Progress:=0;

  AutoCloseModal:=True;
  TaskCanceled:=False;
  Result:=ShowModal=mrOK;
end;

procedure TProgressDialog.SetCanBreak(const Value: Boolean);
begin
  FCanBreak:=Value;
  CancelButton.Visible:=Value;
  if(Value)then
    lPrompt.Width:=CancelButton.Left+CancelButton.Width-lPrompt.Left
  else lPrompt.Width:=CancelButton.Left-5-lPrompt.Left;
end;

procedure TProgressDialog.CancelButtonClick(Sender: TObject);
begin
  if(IDOK=MsgDlg('正在进行'+Caption+'，要终止吗？',//'，要终止吗？',//'正在进行'
        '警告',MB_ICONINFORMATION or MB_OKCANCEL))then begin//'警告'
    TaskCanceled:=True;
    CancelButton.Visible:=False;
    lPrompt.Visible:=False;
    lTryStopping.Visible:=True;
  end;
end;

procedure TProgressDialog.initMulitLanguage;
begin
  CancelButton.Caption :='终止'+'(&S)'  ;//终止
end;

procedure TProgressDialog.FormCreate(Sender: TObject);
begin
  initMulitLanguage ;
end;

end.
