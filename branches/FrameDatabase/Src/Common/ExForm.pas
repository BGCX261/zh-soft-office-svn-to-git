unit ExForm;

interface

uses Windows,SysUtils,Classes,Messages,Controls,Graphics,Forms;

var
  WindowModalShownMessage:DWOrd=0;
type
  TExForm=class(TForm)
  private
    FDoAfterModal:Boolean;
    FModalProc: TThreadMethod;
    FAutoCloseModal: Boolean;
  protected
    procedure ModalShown;virtual;
    procedure Activate;override;
    procedure WndProc(var Message: TMessage); override;
  public
    function ShowModal:Integer;override;

    property AutoCloseModal:Boolean read FAutoCloseModal write FAutoCloseModal;
    property ModalProc:TThreadMethod read FModalProc write FModalProc;
  end;


implementation

uses Consts;
{ TExForm }

function TExForm.ShowModal:Integer;
begin
  FDoAfterModal:=True;
  try
    Result:=inherited ShowModal;
  finally
    FDoAfterModal:=False;
  end;
end;

procedure TExForm.ModalShown;
begin
  if(Assigned(FModalProc))then FModalProc;
end;

procedure TExForm.Activate;
begin
  inherited;
  if(FDoAfterModal)then
  try
    Repaint;
    Application.ProcessMessages;
    PostMessage(Handle,WindowModalShownMessage,0,0);
  finally
    FDoAfterModal:=False;
  end;
end;

procedure TExForm.WndProc(var Message: TMessage);
begin
  if(Message.Msg=WindowModalShownMessage)then begin
    FDoAfterModal:=False;
    try
      ModalShown;
    finally
      if(AutoCloseModal)and(ModalResult=0)then ModalResult:=mrCancel;
    end;
  end else inherited;
end;

initialization
  WindowModalShownMessage:=RegisterWindowMessage('WindowModalShownMessage_DELPHI_LIKUNQI');

  
end.
