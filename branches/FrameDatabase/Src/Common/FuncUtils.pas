unit FuncUtils;

interface

uses
  SysUtils,Windows,Classes,Controls,Graphics,Messages,Math,Forms,StdCtrls,DateUtils;

function CompressBuffer(Buffer:WideString):WideString;overload;
function DecompressBuffer(Buffer:WideString):WideString;overload;

function CompressBuffer(Buffer:string):string;overload;
function DecompressBuffer(Buffer:string):string;overload;

function InterlockedAdd(var I: Integer): Integer;
function InterlockedSub(var I: Integer): Integer;
function InterlockedExchange(var A: Integer; B: Integer): Integer;
function InterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
function CompareGuid(Guid1,Guid2:Pointer):Integer;
function CreateClassGuid:string;
function Buffer2Hex(const Buffer;BufSize:Integer):string;
function Hex2Buffer(const sHex:string;var Buffer):Integer;
function GetSecondCount:integer ;
//执行程序
function ExecutePro(const Command: string; bWaitExecute: Boolean;
  bShowWindow: Boolean; PI: PProcessInformation): Boolean;
function SplitString(const Buffer:string;const Separator:Char;Items:TStrings):Boolean;
function KillProc(AProName: string):boolean;

{
function  MsgDlg(OwnerWnd:HWnd;const sMessage,sTitle:string;Flags:Integer):Integer;overload;
procedure MsgDlg(const sMessage:string);overload;
procedure MsgDlg(const sMessage,sTitle:string);overload;
function  MsgDlg(const sMessage:string;Flags:Integer):Integer;overload;
function  MsgDlg(const sMessage,sTitle:string;Flags:Integer):Integer;overload;
function  YesNoDlg(const sMessage:string):Integer;overload;
function  YesNoDlg(const sMessage,sTitle:string):Integer;overload;
function  OKCancelDlg(const sMessage:string):Integer;overload;
function  OKCancelDlg(const sMessage,sTitle:string):Integer;overload;
function  YesNoCancelDlg(const sMessage:string):Integer;overload;
function  YesNoCancelDlg(const sMessage,sTitle:string):Integer;overload;
procedure WarnDlg(const sMessage:string);overload;
procedure WarnDlg(const sMessage,sTitle:string);overload;
procedure WarnAndAbort(const sMessage:string);overload;
procedure WarnAndAbort(const sMessage,sTitle:string);overload;
procedure WarningDlgAndExit(const sMessage:string);
}
function InputQueryString(const ACaption, APrompt: string;var Value: string): Boolean;
procedure GetSqlServerLists(List:TStrings);



  //@@Summary:获取硬盘的序列号。
  //@@Description:
  //@@Parameters:
  //@@Return Value:硬盘序列号。
  //@@Exceptions:
  //@@Version:1.0
  //@@History:2005-02-24
  //@@Examples:
function GetIdeDiskSerialNumber:string;

  //@@Summary:获取Cpu的序列号。
  //@@Description:
  //@@Parameters:
  //@@Return Value:Cpu序列号。
  //@@Exceptions:
  //@@Version:1.0
  //@@History:2005-02-24
  //@@Examples:
function GetCpuSerialNumber:string;

function GetCurrentComputerName:string;


implementation

uses ComObj,ActiveX,TlHelp32;

type

  TWndProcHacker=class
  private
    FOwnerWnd:HWnd;
    FWndInstance:TFarProc;
    FSaveWndProc:TFarProc;
    procedure HookNewWndProc;
  protected
    procedure CallDefault(var Message:TMessage);
    procedure NewWndProc(var Message:TMessage);virtual;
    property OwnerWnd:HWnd read FOwnerWnd;
  public
    constructor Create(OwnerWnd:HWnd);
    destructor Destroy;override;

    procedure RestoreWndProc;
  end;

type
  TShowDialogClass=class(TWndProcHacker)
  private
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging);
  protected
    procedure NewWndProc(var Message:TMessage);override;
  end;

const
  IDENTIFY_BUFFER_SIZE = 512;

type
  PIDERegs = ^TIDERegs;
  TIDERegs = packed record
    Feature:Byte;     //Used for specifying SMART "commands".
    SectorCount:Byte; // IDE sector count register
    SectorNumber:Byte;// IDE sector number register
    CylLow:Byte;      // IDE low order cylinder value
    CylHigh:Byte;     // IDE high order cylinder value
    DriveHead:Byte;   // IDE drive/head register
    Command:Byte;     // Actual IDE command.
    Reserved:Byte;    // reserved for future use. Must be zero.
  end;

  PDriverStatus =^TDriverStatus;
  TDriverStatus = packed record
    DriverError:Byte;
    IDEStatus:Byte;
    Reserved:array[0..1] of Byte;
    Reserved1:array[0..1] of DWord;
  end;

  PSendCmdInParams = ^TSendCmdInParams;
  TSendCmdInParams = packed record
    BufferSize:DWord;
    DriveRegs:TIDERegs;
    DriveNumber:Byte;
    Reserved:array[0..2] of Byte;
    Reserved1:array[0..3] of DWord;
    Buffer:array[0..0] of Byte;
  end;

  PSendCmdOutParams = ^TSendCmdOutParams;
  TSendCmdOutParams = packed record
    BufferSize:DWord;
    DriverStatus: TDriverStatus;
    Buffer:array[0..0] of Byte;
  end;
  PSector = ^TSector;
  TSector = packed record
    GenConfig: Word;
    NumCyls: Word;
    Reserved: Word;
    NumHeads: Word;
    BytesPerTrack: Word;
    BytesPerSector: Word;
    SectorsPerTrack: Word;
    VendorUnique: array[0..2] of Word;
    SerialNumber: array[0..19] of CHAR;
    BufferType: Word;
    BufferSize: Word;
    ECCSize: Word;
    FirmwareRev: array[0..7] of Char;
    ModelNumber: array[0..39] of Char;
    MoreVendorUnique: Word;
    DoubleWordIO: Word;
    Capabilities: Word;
    Reserved1: Word;
    PIOTiming: Word;
    DMATiming: Word;
    BS: Word;
    NumCurrentCyls: Word;
    NumCurrentHeads: Word;
    NumCurrentSectorsPerTrack: Word;
    lCurrentSectorCapacity: DWORD;
    MultSectorStuff: Word;
    lTotalAddressableSectors: DWORD;
    SingleWordDMA: Word;
    MultiWordDMA: Word;
    bReserved: array[0..127] of BYTE;
  end;
const
  ID_BIT = $200000;
type

  TCpuId = array[1..4] of LongInt;
  TVendor	= array [0..11] of Char;

constructor TWndProcHacker.Create(OwnerWnd:HWnd);
begin
  inherited Create;
  FOwnerWnd:=OwnerWnd;
  HookNewWndProc;
end;

destructor TWndProcHacker.Destroy;
begin
  RestoreWndProc;
  inherited;
end;

procedure TWndProcHacker.HookNewWndProc;
begin
  if(FOwnerWnd>0)then begin
    FWndInstance:=Classes.MakeObjectInstance(NewWndProc);
    FSaveWndProc:=Pointer(GetWindowLong(FOwnerWnd,GWL_WNDPROC));
    SetWindowLong(FOwnerWnd,GWL_WNDPROC,LongInt(FWndInstance));
  end;
end;

procedure TWndProcHacker.RestoreWndProc;
var
  P:Pointer;
begin
  if(FWndInstance<>nil)then begin
    SetWindowLong(FOwnerWnd,GWL_WNDPROC,LongInt(FSaveWndProc));
    FSaveWndProc:=nil;
    P:=FWndInstance;FWndInstance:=nil;
    Classes.FreeObjectInstance(P);
  end;
end;

procedure TWndProcHacker.CallDefault(var Message:TMessage);
begin
  with Message do
    Result:=CallWindowProc(FSaveWndProc,FOwnerWnd,Msg,wParam,lParam);
end;

procedure TWndProcHacker.NewWndProc(var Message:TMessage);
begin
  CallDefault(Message);
end;

{ TShowDialogClass }

procedure TShowDialogClass.NewWndProc(var Message:TMessage);
begin
  inherited;
  if(Message.Msg=WM_WINDOWPOSCHANGING)then
    WMWindowPosChanging(TWMWindowPosChanging(Message));
end;
procedure TShowDialogClass.WMWindowPosChanging(var Message: TWMWindowPosChanging);
var
  DlgWnd:HWnd;
  WndRect,DlgRect:TRect;
begin
  if(Message.WindowPos^.hwnd<>OwnerWnd)then Exit;
  RestoreWndProc;
  if(Message.WindowPos^.flags<>SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE)then Exit;

  DlgWnd:=GetActiveWindow();
  if(DlgWnd=FOwnerWnd)then Exit;

  GetWindowRect(DlgWnd,DlgRect);
  GetWindowRect(FOwnerWnd,WndRect);
  SetWindowPos(DlgWnd,HWND_TOP,//HWND_TOPMOST,
            (WndRect.Left+WndRect.Right-DlgRect.Right+DlgRect.Left)div 2,
            (WndRect.Top+WndRect.Bottom-DlgRect.Bottom+DlgRect.Top)div 2,
            0,0,SWP_NOREDRAW or SWP_NOSIZE{ or SWP_NOACTIVATE});
  BringWindowToTop(DlgWnd);
  SetActiveWindow(DlgWnd);
  //SetForegroundWindow(DlgWnd);
end;

function CompareGuid(Guid1,Guid2:Pointer):Integer;
asm
        MOV     ECX,[EAX]
        CMP     ECX,[EDX]
        JNZ     @@1
        MOV     ECX,[EAX+$4]
        CMP     ECX,[EDX+$4]
        JNZ     @@1
        MOV     ECX,[EAX+$8]
        CMP     ECX,[EDX+$8]
        JNZ     @@1
        MOV     ECX,[EAX+$C]
        CMP     ECX,[EDX+$C]
        JNZ     @@1
        XOR     EAX, EAX
        RET
@@1:
        JG      @@2
        MOV     EAX, -1
        RET
@@2:    MOV     EAX, 1
end;

function InterlockedAdd(var I: Integer): Integer;
asm
        MOV     EDX,1
        XCHG    EAX,EDX
  LOCK  XADD    [EDX],EAX
        INC     EAX
end;
function InterlockedSub(var I: Integer): Integer;
asm
        MOV     EDX,-1
        XCHG    EAX,EDX
  LOCK  XADD    [EDX],EAX
        DEC     EAX
end;

function InterlockedExchange(var A: Integer; B: Integer): Integer;
asm
        XCHG    [EAX],EDX
        MOV     EAX,EDX
end;
function InterlockedExchangeAdd(var A: Integer; B: Integer): Integer;
asm
        XCHG    EAX,EDX
  LOCK  XADD    [EDX],EAX
end;
function Buffer2Hex(const Buffer;BufSize:Integer):string;
const
  Hex: array[0..15] of Char = '0123456789ABCDEF';
var
  S: PByte;
  D: PChar;
begin
  Result := '';
  if BufSize <= 0 then Exit;
  SetLength(Result, BufSize*2);
  D := PChar(Result);
  S := @Buffer;
  while BufSize > 0 do
  begin
    D^ := Hex[S^ shr  4]; Inc(D);
    D^ := Hex[S^ and $F]; Inc(D);
    Inc(S);
    Dec(BufSize);
  end;
end;

function Hex2Buffer(const sHex:string;var Buffer):Integer;
var
  D: PByte;
  V: Byte;
  S: PChar;
  Len: Integer; 
begin
  Len := Length(sHex) and not 1;
  Result := Len div 2;

  D := @Buffer;
  S := PChar(sHex);
  while Len > 0 do
  begin
    V := Byte(UpCase(S^));
    Inc(S);
    if V > Byte('9') then D^ := V - Byte('A') + 10
      else D^ := V - Byte('0');
    V := Byte(UpCase(S^));
    Inc(S);
    D^ := D^ shl 4;
    if V > Byte('9') then D^ := D^ or (V - Byte('A') + 10)
      else D^ := D^ or (V - Byte('0'));
    Dec(Len, 2);
    Inc(D);
  end;
end;

{
function  MsgDlg(OwnerWnd:HWnd;const sMessage,sTitle:string;Flags:Integer):Integer;
var
  WindowList:Pointer;
begin
  if(Application.UseRightToLeftReading)then
        Flags:=Flags or MB_RTLREADING;

  WindowList:=DisableTaskWindows(0);
  try
    with TShowDialogClass.Create(OwnerWnd) do
    try
      Result:=MessageBox(Application.Handle,PChar(sMessage),PChar(sTitle),Flags);
    finally
      Free;
    end;
  finally
    EnableTaskWindows(WindowList);
    SetActiveWindow(OwnerWnd);
    Windows.SetFocus(OwnerWnd);
  end;
end;

procedure MsgDlg(const sMessage:string);
begin
  MsgDlg(sMessage,'信息',MB_ICONINFORMATION);
end;

procedure MsgDlg(const sMessage,sTitle:string);
begin
  MsgDlg(sMessage,sTitle,MB_ICONINFORMATION);
end;

function MsgDlg(const sMessage:string;Flags:Integer):Integer;
begin
  Result:=MsgDlg(sMessage,'信息',Flags);
end;

function MsgDlg(const sMessage,sTitle:string;Flags:Integer):Integer;
begin
  Result:=MsgDlg(GetActiveWindow(),sMessage,sTitle,Flags);
end;

function YesNoDlg(const sMessage:string):Integer;
begin
  Result:=MsgDlg(sMessage,MB_ICONQUESTION or MB_YESNO);
end;

function YesNoDlg(const sMessage,sTitle:string):Integer;
begin
  Result:=MsgDlg(sMessage,sTitle,MB_ICONQUESTION or MB_YESNO);
end;

function  OKCancelDlg(const sMessage:string):Integer;overload;
begin
  Result:=MsgDlg(sMessage,MB_ICONQUESTION or MB_OKCANCEL);
end;

function  OKCancelDlg(const sMessage,sTitle:string):Integer;overload;
begin
  Result:=MsgDlg(sMessage,sTitle,MB_ICONQUESTION or MB_OKCANCEL);
end;

function YesNoCancelDlg(const sMessage:string):Integer;
begin
  Result:=MsgDlg(sMessage,MB_ICONQUESTION or MB_YESNOCANCEL);
end;

function YesNoCancelDlg(const sMessage,sTitle:string):Integer;
begin
  Result:=MsgDlg(sMessage,sTitle,MB_ICONQUESTION or MB_YESNOCANCEL);
end;

procedure WarnDlg(const sMessage:string);
begin
  MsgDlg(sMessage,'警告',MB_ICONEXCLAMATION);
end;

procedure WarnDlg(const sMessage,sTitle:string);
begin
  MsgDlg(sMessage,sTitle,MB_ICONEXCLAMATION);
end;

procedure WarnAndAbort(const sMessage:string);
begin
  MsgDlg(sMessage,'警告',MB_ICONEXCLAMATION);
  Abort();
end;

procedure WarnAndAbort(const sMessage,sTitle:string);
begin
  MsgDlg(sMessage,sTitle,MB_ICONEXCLAMATION);
  Abort();
end;

procedure WarningDlgAndExit(const sMessage:string);
begin
  WarnAndAbort(sMessage);
end;
}
function GetIdeDiskSerialNumber:string;
var
  Device:THandle;
  Returned:DWord;
  InCmd:TSendCmdInParams;
  OutCmds:array[0..(SizeOf(TSendCmdOutParams)+IDENTIFY_BUFFER_SIZE)] of Byte;
  OutCmd: TSendCmdOutParams absolute OutCmds;
  procedure ChangeByteOrder( var Data; Size : Integer );
  var
    ptr : PChar;
    i : Integer;
    c : Char;
  begin
    ptr := @Data;
    for i := 0 to (Size shr 1)-1 do
    begin
      c := ptr^;
      ptr^ := (ptr+1)^;
      (ptr+1)^ := c;
      Inc(ptr,2);
    end;
  end;
begin
  Result := '';
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    Device:=CreateFile('\\.\PhysicalDrive0',GENERIC_READ or GENERIC_WRITE,
      FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  end else Device:=CreateFile('\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
  if Device = INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(InCmd,SizeOf(TSendCmdInParams)-1,#0);
    FillChar(OutCmds,SizeOf(OutCmds),#0);
    Returned:=0;
    with InCmd do
    begin
      BufferSize := IDENTIFY_BUFFER_SIZE;
      DriveRegs.SectorCount:=1;
      DriveRegs.SectorNumber:=1;
      DriveRegs.DriveHead:=$A0;
      DriveRegs.Command:=$EC;
    end;
    if not DeviceIoControl(Device,$0007C088,@Incmd,SizeOf(TSendCmdInParams)-1,
      @outCmds,SizeOf(OutCmds),Returned,nil) then Exit;
  finally
    CloseHandle(Device);
  end;
  with PSector(@OutCmd.Buffer)^ do
  begin
    ChangeByteOrder(SerialNumber,SizeOf(SerialNumber));
    (PChar(@SerialNumber)+SizeOf(SerialNumber))^:=#0;
    Result := StrPas(PChar(@SerialNumber));
  end;
end;

function IsCpuAvailable:Boolean;
asm
	PUSHFD							{direct access to flags no possible, only via stack}
  POP     EAX					{flags to EAX}
  MOV     EDX,EAX			{save current flags}
  XOR     EAX,ID_BIT	{not ID bit}
  PUSH    EAX					{onto stack}
  POPFD								{from stack to flags, with not ID bit}
  PUSHFD							{back to stack}
  POP     EAX					{get back to EAX}
  XOR     EAX,EDX			{check if ID bit affected}
  JZ      @exit				{no, CPUID not availavle}
  MOV     AL,True			{Result=True}
  @exit:
end;
function GetCpuId:TCpuId;
asm
  PUSH    EBX         {Save affected register}
  PUSH    EDI
  MOV     EDI,EAX     {@Resukt}
  MOV     EAX,1
  DW      $A20F       {CPUID Command}
  STOSD			          {CPUID[1]}
  MOV     EAX,EBX
  STOSD               {CPUID[2]}
  MOV     EAX,ECX
  STOSD               {CPUID[3]}
  MOV     EAX,EDX
  STOSD               {CPUID[4]}
  POP     EDI					{Restore registers}
  POP     EBX
end;

function GetCPUVendor : TVendor;
asm
  PUSH    EBX					{Save affected register}
  PUSH    EDI
  MOV     EDI,EAX			{@Result (TVendor)}
  MOV     EAX,0
  DW      $A20F				{CPUID Command}
  MOV     EAX,EBX
  XCHG		EBX,ECX     {save ECX result}
  MOV			ECX,4
@1:
  STOSB
  SHR     EAX,8
  LOOP    @1
  MOV     EAX,EDX
  MOV			ECX,4
@2:
  STOSB
  SHR     EAX,8
  LOOP    @2
  MOV     EAX,EBX
  MOV			ECX,4
@3:
  STOSB
  SHR     EAX,8
  LOOP    @3
  POP     EDI					{Restore registers}
  POP     EBX
end;
function GetCpuSerialNumber:string;
var
  Id:TCpuId;
  I:Integer;
begin
  Result := '';
  for I:=Low(Id) to High(Id) do
    Id[I]:=-1;
  if IsCpuAvailable then
  begin
    Id:= GetCpuId;
    for I:=Low(Id) to High(Id) do
      Result := Result + IntToHex(Id[I],8);
  end;
end;

function CompressBuffer(Buffer:WideString):WideString;
begin
  Result:=Buffer;

end;
function DecompressBuffer(Buffer:WideString):WideString;
begin
  Result:=Buffer;
end;

function CompressBuffer(Buffer:string):string;
begin
  Result:=Buffer;
end;
function DecompressBuffer(Buffer:string):string;
begin
  Result:=Buffer;
end;

function SplitString(const Buffer:string;const Separator:Char;Items:TStrings):Boolean;
var
  V,T:string;
  I:Integer;
begin
  V:=Buffer;
  Items.Clear;
  repeat
    I:=Pos(Separator,V);
    if I=0 then
      T:=V
    else begin
      T:=Copy(V,1,I-1);
      System.Delete(V,1,I);
    end;
    Items.Add(T);
  until I=0;
  Result:=True;
end;

function GetCurrentComputerName:string;
var
  Buffer:PChar;
  Len:DWORD;
begin
  Result:='';
  Len:=255;
  GetMem(Buffer,Len);
  try
    if Windows.GetComputerName(Buffer,Len)then
      SetString(Result,Buffer,Len);
  finally
    FreeMem(Buffer);
  end;
end;
function InputQueryString(const ACaption, APrompt: string;var Value: string): Boolean;
const
  MsgDlgOK='确定';
  MsgDlgCancel='取消';  
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  function GetAveCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;

begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := MsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := MsgDlgCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;          
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;
function CreateClassGuid:string;
var
  Buffer:string;
begin
  Buffer:=CreateClassID;
  Buffer:=StringReplace(Buffer,'{','',[rfReplaceAll]);
  Buffer:=StringReplace(Buffer,'}','',[rfReplaceAll]);
  Buffer:=StringReplace(Buffer,'-','',[rfReplaceAll]);
  Result:=Buffer;
end;
procedure GetSqlServerLists(List:TStrings);

var
  I: Integer;
  ServerNames, SQLApp: OleVariant;
  OldCursor: TCursor;
begin
  List.Clear;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    try
      SQLApp := CreateOleObject('SQLDMO.Application');
      ServerNames := SQLApp.ListAvailableSQLServers;
      for I := 1 to ServerNames.Count do
        List.Add(ServerNames.Item(I));
    except
    end;
  finally
    Screen.Cursor := OldCursor;
  end;

end;
function KillProc(AProName: string):boolean;
var
  ExeFileName: String;
  ContinueLoop: BOOL;
  FSnapshotHandle:THandle;
  FProcessEntry32:TProcessEntry32;
begin
  result:=True ;
  ExeFileName := AProName;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
         UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) =
         UpperCase(ExeFileName))) then
    begin
      TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
                        FProcessEntry32.th32ProcessID), 0);
    end; 
    ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32);
  end;

end;
function ExecutePro(const Command: string; bWaitExecute,
  bShowWindow: Boolean; PI: PProcessInformation): Boolean;
var
  StartupInfo       : TStartupInfo;
  ProcessInformation: TProcessInformation;
begin
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  with StartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    if bShowWindow then
      wShowWindow := SW_NORMAL
    else
      wShowWindow := SW_HIDE;
  end;

  Result := CreateProcess(nil, PChar(Command),
    nil, nil, True, NORMAL_PRIORITY_CLASS, nil, nil,
    StartupInfo, ProcessInformation);

  if not Result then Exit;

  if bWaitExecute then
    WaitForSingleObject(ProcessInformation.hProcess, INFINITE);

  if Assigned(PI) then
    Move(ProcessInformation, PI^, SizeOf(ProcessInformation));
end;
function GetSecondCount:integer ;
begin
  result:=(yearof(Now)-2007)*32140800 + monthof(Now)*2678400 + Dayof(Now)*86400 + HourOf(Now)*3600 +SecondOf(Now)*60 ;
end; 
end.
