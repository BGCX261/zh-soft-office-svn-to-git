unit ShareLib;

interface

uses
  Windows,SysUtils,Classes,Controls,Graphics,Messages,Math,FileCtrl,
  Forms,Registry,INIFiles,ComCtrls,CommCtrl,ShareSys;

  function XPixelsToATenthMilliMetre(Pixels:Integer):Integer;
  function YPixelsToATenthMilliMetre(Pixels:Integer):Integer;
  function XATenthMilliMetreToPixels(tmm:Integer):Integer;
  function YATenthMilliMetreToPixels(tmm:Integer):Integer;
  {StringUtils}
const
  sCaretReturn      =#13#10;
  sIndexOutOfRange  ='下标〖%d〗越界';
  sFuncUnsupported  ='该功能不被支持';
  SymbolChars       =['0'..'9','A'..'Z','a'..'z','_'];

  wCaretReturn      :Word    = $0A0D;
  MaxStringRWLength :Integer = $00100000;
  NullDoubleValue   :Double  = 3E-308;
  //LikeNullDoubleValue 

  function CStrToInt(CStr:string):Integer;
  function IntToCStr(IntValue:Integer):String;
  function ColRowNumToStr(Col,Row:Integer):string;
  procedure StrColRowToNum(ColRowstr:string;var Col,Row:Integer);
  function IntToChineseStr(IntValue:Integer):String;
  
  function Buffer2Hex(const Buffer;BufSize:Integer):string;
  function Hex2Buffer(const sHex:string;var Buffer):Integer;

  function IdentifierValid(const Identifier:String):Boolean;
  function SymbolValid(const Symbol:String):Boolean;
  function StringRegular(const str:string):Boolean;
  function FileNameValid(const FileName:string;AllowPath:Boolean):Boolean;
  function GetSameCharString(TheChar:Char;Length:Integer):string;

  function StrBufferLength(const StrBuffer:Pointer;MaxLength:Integer):Integer;
  function AnsiStrLComp0(S1, S2: PChar; MaxLen: Cardinal): Integer;
  function AnsiStrLIComp0(S1, S2: PChar; MaxLen: Cardinal): Integer;
  function DelLeftSpace(const S:string):string;
  function DelRightSpace(const S:string):string;
  function RightPos(const SubStr,S:string):Integer;
  function PCharHeadComp(const p1,p2:PChar):Integer;
  function StrHeadComp(const s,head:string):Integer;
  function StrTailComp(const s,tail:string):Integer;
  function TextHeadComp(const s,head:string):Integer;
  function TextTailComp(const s,tail:string):Integer;
  function strExcludeChar(const str:string;delChar:Char):string;
  function strDeleteSub(const s,subStr:string):string;
  function strTripQuote(const s:String):String;
  function strGetQuoted(const sInitial:string;QuoteMark:Char;var sCode:string):string;overload;
  function strGetQuoted(const sInitial:string;LQMark:Char;RQMark:Char;var sCode:string):string;overload;
  function strReplaceChar(const str:string;OldChar,NewChar:Char):string;
  function strReplaceQuoted(const sInitial:string;RPChar:Char=' ';QuoteMark:Char='"'):string;overload;
  function strReplaceQuoted(const sInitial:string;RPChar:Char;LQMark,RQMark:Char):string;overload;
  function StrIsZeroValue(const FloatStr:string):Boolean;
  function UpdateStr(const s:String):String;
  procedure StreamWriteS(Stream:TStream;const s:string);
  function StreamReadS(Stream:TStream):String;
  procedure StreamSkipS(Stream:TStream);
  function  sReadln(Stream:TStream;var str:string):Integer;
  function  sWriteln(Stream:TStream;const str:string):Integer;
  function CheckStrKeyValid(pKey:Pointer;KeyLen:Integer):Boolean;
  function EncodeString(S:String):String;
  function DecodeString(S:String):String;

procedure ResetFPU;
procedure Evaluate(const str:string;var V:Single;var Code:Integer);overload;
procedure Evaluate(const str:string;var V:Double;var Code:Integer);overload;
procedure Evaluate(const str:string;var V:Extended;var Code:Integer);overload;

  function IsNullValue(const Number{: Double}): Boolean;
  function IsNumberString(const Number:string):Boolean;
  function CheckNumberString(const Number:string;var Value:Double):Boolean;
  function TrimZeroDecimals(const Number:string):string;
  function InsertThoundMark(const Number:string):string;
  function StringToFloat(const Number:string;Decimal:Integer):Double;
  function FormatNumberString(const Number:Double;Decimal:Integer;ShowThoundMark:Boolean):string;overload;
  function FormatNumberString(const Number:Extended;Decimal:Integer;ShowThoundMark:Boolean):string;overload;
  function CorrectNumberString(const Number:string;Decimal:Integer):string;

  function  StringItemGetName(const str:string):string;
  function  StringItemGetValue(const str:string):string;
  function  StringsGetValue(Strs:TStrings;Index:Integer):string;overload;
  function  StringsGetValue(Strs:TStrings;const Name:string):string;overload;
  procedure StringsSetValue(Strs:TStrings;Index:Integer;const Value:string);overload;
  procedure StringsSetValue(Strs:TStrings;const Name:string;const Value:string);overload;
  function  StringsIndexOfValue(Strs:TStrings;const Value:string):Integer;

  function  StringsToSprString(Source:TStrings;SprChar:Char):string;
  procedure SprStringToStrings(const Source:string;SprChar:Char;Values:TStrings);
  function  StringGetSecCount(const StringExpr:string):Integer;
  function  StringGetSecValue(const StringExpr:string;Index:Integer):string;
  function  StringSetSecValue(var StringExpr:string;Index:Integer;const Value:string;Separator:char=';'):Boolean;
  function  GetValueByName(Source:TStrings;const Name:string):string;
  procedure ExMoveStrings(Strs:TStrings;moveStart,moveCount,moveTo:Integer);
  function  CompareStrings(Strs1,Strs2:TStrings):Boolean;
  function  StringsRemoveEmpty(Strs:TStrings):Integer;
  {Reg}
  function  RegReadString(Root:HKEY;const KeyName,ValueName:string;var Value:string):Boolean;overload;
  function  RegReadString(Root:HKEY;const KeyName,ValueName:string):string;overload;
  procedure RegWriteString(Root:HKEY;const KeyName,ValueName,Value:string);
  function  RegReadInteger(Root:HKEY;const KeyName,ValueName:string;var Value:Integer):Boolean;overload;
  function  RegReadInteger(Root:HKEY;const KeyName,ValueName:string):Integer;overload;
  procedure RegWriteInteger(Root:HKEY;const KeyName,ValueName:string;Value:Integer);

  procedure RegLoadStrings(Root:HKEY;const KeyName:string;Strs:TStrings);
  procedure RegSaveStrings(Root:HKEY;const KeyName:string;Strs:TStrings);
  procedure INILoadStrs(Ini:TCustomIniFile;const SecName:string;Strs:TStrings);
  procedure INISaveStrs(Ini:TCustomIniFile;const SecName:string;Strs:TStrings);
  procedure RegReadStrings(Root:HKEY;const KeyName:string;Values:TStrings);
  procedure RegWriteStrings(Root:HKEY;const KeyName:string;Values:TStrings);
  procedure RegRemoveKey(RootKey:HKey;const KeyName:string);
  {FileLib}
  procedure AddPathSpr(var aPath:String);
  procedure DeleteTailPathSpr(var aPath:string);
  function DeleteTailPathSpr0(const aPath:string):string;
  function ReplaceFileNameSpr(const aPath:string;Spr:char='_'):string;
  function ConcatPathFileName(const Path, S: String): String;
  function IsValidFileName(const FileName:string):Boolean;
  function time_GetTempFileName(const NamePrefix:string='';const PathName:string=''):string;
  procedure EmptyDirectory(Directory:string;IncludeSubDir:Boolean);
  procedure RemoveDirectory(const Directory:string);

  procedure EncodeSave(Denst:TStream;Source:Pointer;
                     IntCount:LongInt;SecretKey:LongInt);
  function DecodeLoad(Source:TStream;Denst:Pointer;
                    IntCount:LongInt;SecretKey:LongInt):Byte;
  procedure EncodeSave1(Denst:TStream;Source:Pointer;
                     IntCount:LongInt;SecretKey:LongInt);
  function DecodeLoad1(Source:TStream;Denst:Pointer;
                    IntCount:LongInt;SecretKey:LongInt):Byte;
  function RedundanceDataProofread(var Data;Length:Integer;RepCount:Integer=3):Integer;

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

  function FindMatchFontName(const Name:string):string;

  procedure FillDWord(var Dest; Count, Value: Integer); register;
  function StackAlloc(Size: Integer): Pointer; register;
  procedure StackFree(P: Pointer); register;

  procedure FocusNextControl(Control:TWinControl);
  
  {FPBData}
type
  TFontDataClass=class
  private
    FName:String;
    FColor:TColor;
    FCharSet:TFontCharSet;
    FHeight:Integer;
    FStyle:TFontStyles;
  public
    constructor Create;
    procedure Assign(Font:TFontDataClass);
    procedure AssignFrom(Font:TFont);
    procedure AssignTo(Font:TFont);

    procedure LoadFromStream(Stream:TStream);
    procedure SaveToStream(Stream:TStream);

    property Name:string read FName write FName;
    property Color:TColor read FColor write FColor;
    property CharSet:TFontCharset read FCharSet write FCharSet;
    property Height:Integer read FHeight write FHeight;
    property Style:TFontStyles read FStyle write FStyle;
  end;

  TPenDataClass=class
  private
    FColor:TColor;
    FMode:TPenMode;
    FStyle:TPenStyle;
    FWidth:Integer;
  public
    constructor Create;
    procedure Assign(Pen:TPenDataClass);
    procedure AssignTo(Pen:TPen);
    procedure AssignFrom(Pen:TPen);
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromStream(Stream:TStream);

    property Color:TColor read FColor write FColor;
    property Style:TPenStyle read FStyle write FStyle;
    property Width:Integer read FWidth write FWidth;
    property Mode:TPenMode read FMode write FMode;
  end;

  TBrushDataClass=class
  private
    FColor:TColor;
    FStyle:TBrushStyle;
  public
    constructor Create;
    procedure Assign(Brush:TBrushDataClass);
    procedure AssignTo(Brush:TBrush);
    procedure AssignFrom(Brush:TBrush);
    procedure SaveToStream(Stream:TStream);
    procedure LoadFromStream(Stream:TStream);

    property Color:TColor read FColor write FColor;
    property Style:TBrushStyle read FStyle write FStyle;
  end;

type
  Int32=LongInt;uInt32=Cardinal;
  TMemStream=class(TMemoryStream)
  private
    FHoldSize: Integer;
    procedure SetHoldSize(const Value: Integer);
  protected
    function Realloc(var NewCapacity: Longint): Pointer; override;
  public
    destructor Destroy;override;
    procedure Reset;

    property Capacity;
    property HoldSize:Integer read FHoldSize write SetHoldSize;
  public
    function ReadChar:Char;
    function WriteChar(ch:Char):Integer;overload;
    function WriteChar(ch:Char;RepCount:Integer):Integer;overload;
    function ReadInteger:Int32;
    function WriteInteger(IntValue:Int32):Integer;overload;
    function WriteInteger(IntValue:Int32;RepCount:Integer):Integer;overload;

    function SkipString():Integer;
    function ReadString():string;overload;
    function ReadString(str:PChar):Integer;overload;
    function WriteString(const str:string):Integer;overload;
    function WriteString(const str:PChar):Integer;overload;
    function WriteStrData(const str:string):Integer;overload;
    function WriteStrData(const str:PChar):Integer;overload;
    function CopyString(Source:TStream):Integer;
    function CopyStrData(Source:TStream):Integer;

    function ReadlnString():string;overload;
    function ReadlnString(var str:string):Integer;overload;
    function WritelnString(const str:string):Integer;overload;
    function WritelnString(const str:PChar):Integer;overload;
  public
    function Eof:Boolean;
    function MoveFirst:Integer;
    function MoveLast:Integer;
    function MoveTo(Position:Integer):Integer;
    function MoveBack(Step:Integer=1):Integer;
    function MoveForth(Step:Integer=1):Integer;
    function Insert(Count:Integer;InsData:Pointer):Integer;
    function Delete(Count:Integer):Integer;

    function GetCurrent:PChar;
    function GetDataString():string;
  end;

  function SkipString(Stream:TStream):Integer;
  function ReadString(Stream:TStream):string;overload;
  function ReadString(Stream:TStream;str:PChar):Integer;overload;
  function WriteString(Stream:TStream;const str:string):Integer;overload;
  function WriteString(Stream:TStream;const str:PChar):Integer;overload;
  function ReadlnString(Stream:TStream):string;overload;
  function ReadlnString(Stream:TStream;var str:string):Integer;overload;
  function WritelnString(Stream:TStream;const str:string):Integer;overload;
  function WritelnString(Stream:TStream;const str:PChar):Integer;overload;
  function WriteChar(Stream:TStream;ch:Char;RepCount:Integer=1):Integer;
  function WriteInteger(Stream:TStream;IntValue:Int32;RepCount:Integer=1):Integer;

  procedure CopyDataUntilCR(Src,Dst:TStream;MeetData:PChar;MeetLength:Integer);

const
  qmiModuleName    =   1;
  qmiModuleTitle   =   2;
  WM_QueryModuleInfomation=WM_USER+999;

  //function QueryModuleInfomation(const MainFormClass:string;InfoType:Integer):string;
  //procedure ProcMsg_QueryModuleInfomation(var Message:TMessage);

function ScrollTabControl(Ctrl:TTabControl;Delta:SmallInt):SmallInt;

implementation

uses Consts,RTLConsts;

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
    FWndInstance:=MakeObjectInstance(NewWndProc);
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
    FreeObjectInstance(P);
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


function  MsgDlg(OwnerWnd:HWnd;const sMessage,sTitle:string;Flags:Integer):Integer;
var
  H,Active,Focus:HWnd;
  WindowList:Pointer;
begin
  Focus:=GetFocus;
  H:=Focus;while(H<>0)and(H<>OwnerWnd)do H:=GetParent(H);if(H=0)then Focus:=0;
  Active:=GetActiveWindow;
  try
    WindowList:=DisableTaskWindows(0);
    try
      with TShowDialogClass.Create(OwnerWnd) do
      try
        if(Application.UseRightToLeftReading)then Flags:=Flags or MB_RTLREADING;
        Result:=MessageBox(OwnerWnd,PChar(sMessage),PChar(sTitle),Flags);
      finally
        Free;
      end;
    finally
      EnableTaskWindows(WindowList);
    end;
  finally
    if(Active=OwnerWnd)then SetActiveWindow(OwnerWnd);
    if(Focus<>0)then Windows.SetFocus(Focus);
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

procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI
end;

{ StackAlloc allocates a 'small' block of memory from the stack by
  decrementing SP.  This provides the allocation speed of a local variable,
  but the runtime size flexibility of heap allocated memory.  }
function StackAlloc(Size: Integer): Pointer; register;
asm
  POP   ECX          { return address }
  MOV   EDX, ESP
  ADD   EAX, 3
  AND   EAX, not 3   // round up to keep ESP dword aligned
  CMP   EAX, 4092
  JLE   @@2
@@1:
  SUB   ESP, 4092
  PUSH  EAX          { make sure we touch guard page, to grow stack }
  SUB   EAX, 4096
  JNS   @@1
  ADD   EAX, 4096
@@2:
  SUB   ESP, EAX
  MOV   EAX, ESP     { function result = low memory address of block }
  PUSH  EDX          { save original SP, for cleanup }
  MOV   EDX, ESP
  SUB   EDX, 4
  PUSH  EDX          { save current SP, for sanity check  (sp = [sp]) }
  PUSH  ECX          { return to caller }
end;

{ StackFree pops the memory allocated by StackAlloc off the stack.
- Calling StackFree is optional - SP will be restored when the calling routine
  exits, but it's a good idea to free the stack allocated memory ASAP anyway.
- StackFree must be called in the same stack context as StackAlloc - not in
  a subroutine or finally block.
- Multiple StackFree calls must occur in reverse order of their corresponding
  StackAlloc calls.
- Built-in sanity checks guarantee that an improper call to StackFree will not
  corrupt the stack. Worst case is that the stack block is not released until
  the calling routine exits. }
procedure StackFree(P: Pointer); register;
asm
  POP   ECX                     { return address }
  MOV   EDX, DWORD PTR [ESP]
  SUB   EAX, 8
  CMP   EDX, ESP                { sanity check #1 (SP = [SP]) }
  JNE   @@1
  CMP   EDX, EAX                { sanity check #2 (P = this stack block) }
  JNE   @@1
  MOV   ESP, DWORD PTR [ESP+4]  { restore previous SP  }
@@1:
  PUSH  ECX                     { return to caller }
end;

procedure FocusNextControl(Control:TWinControl);
begin
  while(not (Control is TCustomForm))and(Control.Parent<>nil) do Control:=Control.Parent;
  if(Control is TCustomForm)then
    PostMessage(Control.Handle,WM_NEXTDLGCTL,0,0);
end;

function XPixelsToATenthMilliMetre(Pixels:Integer):Integer;
var
  DC:HDC;
begin
  DC:=GetDC(0);
  try
    Result:=Round(Pixels*256/GetDeviceCaps(DC,LOGPIXELSX));
  finally
    ReleaseDC(0,DC);
  end;
end;

function YPixelsToATenthMilliMetre(Pixels:Integer):Integer;
var
  DC:HDC;
begin
  DC:=GetDC(0);
  try
    Result:=Round(Pixels*256/GetDeviceCaps(DC,LOGPIXELSY));
  finally
    ReleaseDC(0,DC);
  end;
end;

function XATenthMilliMetreToPixels(tmm:Integer):Integer;
var
  DC:HDC;
begin
  DC:=GetDC(0);
  try
    Result:=Round(tmm*GetDeviceCaps(DC,LOGPIXELSX)/256);
  finally
    ReleaseDC(0,DC);
  end;
end;

function YATenthMilliMetreToPixels(tmm:Integer):Integer;
var
  DC:HDC;
begin
  DC:=GetDC(0);
  try
    Result:=Round(tmm*GetDeviceCaps(DC,LOGPIXELSX)/256);
  finally
    ReleaseDC(0,DC);
  end;
end;

function CStrToInt(CStr:string):Integer;
var
  I:Integer;
  c:Char;
begin
  Result:=0;
  for I:=1 to Length(CStr) do begin
    c:=CStr[I];C:=Char(BYTE(C) and (not $20));
    if(C<'A')or(C>'Z')then
      raise EConvertError.CreateFmt('“%s”非法',[CStr]);
    Result:=Result*26+BYTE(C)-BYTE('A')+1;
  end;
end;

function IntToCStr(IntValue:Integer):string;
var
  C:Char;
  slen,I:Integer;
  str:array[0..63] of char;
begin
  slen:=0;
  while(IntValue>0)do begin
    C:=Char(IntValue mod 26+BYTE('A')-1);
    IntValue:=IntValue div 26;
    if(C<'A')then begin C:='Z';Dec(IntValue);end;
    str[slen]:=C;Inc(slen);
  end;

  SetLength(Result,slen);
  for I:=1 to slen do
    Result[I]:=str[slen-I];
end;

function ColRowNumToStr(Col,Row:Integer):string;
var
  C:Char;
  slen,I:Integer;
  str:array[0..63] of char;
begin
  slen:=0;
  while(Col>0)do begin
    C:=Char(Col mod 26+BYTE('A')-1);
    Col:=Col div 26;
    if(C<'A')then begin C:='Z';Dec(Col);end;
    str[slen]:=C;Inc(slen);
  end;

  I:=FormatBuf(str[slen],sizeof(str)-slen-1,'%d',2,[Row]);
  str[slen+I]:=#0;Result:=StrPas(str);

  for I:=1 to slen do
    Result[I]:=str[slen-I];
end;

function IntToChineseStr(IntValue:Integer):String;
Const
  OneToTen='○一二三四五六七八九十';
var
  t:Integer;
begin
  if(IntValue<20)and(IntValue>=10)then begin
    Result:='十';
    IntValue:=IntValue-10;
    if(IntValue>0)then
      Result:=Result+Copy(OneToTen,IntValue*2+1,2);
  end else begin
    Result:='';
    repeat
      t:=IntValue mod 10;IntValue:=IntValue div 10;
      Result:=Copy(OneToTen,t*2+1,2)+Result;
    until(IntValue=0);
  end;
end;

procedure StrColRowToNum(ColRowstr:string;var Col,Row:Integer);
var
  I,len:Integer;
begin
  Col:=0;Row:=0;
  ColRowStr:=Uppercase(ColRowStr);
  len:=Length(ColRowStr);
  I:=1;
  while(I<=len)and(ColRowStr[I]>='A')and(ColRowStr[I]<='Z')do Inc(I);

  Col:=CStrToInt(Copy(ColRowStr,1,I-1));
  Row:=StrToIntDef(Copy(ColRowStr,I,len-I+1),0);
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


function IdentifierValid(const Identifier:String):Boolean;
begin                 
  Result:=SymbolValid(Identifier) and (Identifier[1]>='A')
end;

function SymbolValid(const Symbol:String):Boolean;
var
  I:Integer;
begin
  if(Symbol='')then begin
    Result:=False;Exit;
  end;
  for I:=1 to Length(Symbol) do begin
    if(not (Symbol[I] in SymbolChars))then begin
      Result:=False;
      Exit;
    end;
  end;
  Result:=True;
end;

function StringRegular(const str:string):Boolean;
var
  I,slen:Integer;
begin
  slen:=Length(str);
  if(slen<=0)then begin
    Result:=False;Exit;
  end;
  I:=1;
  while(I<=slen)do begin
    if(ByteType(str,I)=mbSingleByte)and(
        not (str[I] in SymbolChars))then begin
      Result:=False;Exit;
    end;
    Inc(I);
  end;
  Result:=True;
end;

function FileNameValid(const FileName:string;AllowPath:Boolean):Boolean;
const
  DriverChar=':';
  PathSeperateChar='\';
  FileNameErrorChars=['\','/',':','*','?','"','<','>','|'];
var
  I,slen:Integer;
begin
  slen:=Length(FileName);
  if(slen<=0)then begin
    Result:=False;Exit;
  end;
  I:=1;
  while(I<=slen)do
  begin
    if(ByteType(FileName,I)=mbSingleByte)then
    begin
      if(AllowPath)and((FileName[I]=PathSeperateChar)
          or(I=2)and(FileName[I]=DriverChar))then
      begin
      end else
      if(FileName[I] in FileNameErrorChars)then
      begin
        Result:=False;
        Exit;
      end;
    end;
    Inc(I);
  end;
  Result:=True;
end;

function GetSameCharString(TheChar:Char;Length:Integer):string;
var
  I:Integer;
begin
  Assert(Length>=0);
  SetLength(Result,Length);
  if(Length<10)then for I:=1 to Length do Result[I]:=TheChar
  else FillChar(Pointer(Result)^,Length,TheChar);
end;

function StrBufferLength(const StrBuffer:Pointer;MaxLength:Integer):Integer;
asm
        MOV     ECX,EAX
@@1:
        CMP     BYTE PTR [EAX],0
        JZ      @@2
        INC     EAX
        DEC     EDX
        JNZ     @@1
@@2:    SUB     EAX,ECX
end;

function AnsiStrLComp0(S1, S2: PChar; MaxLen: Cardinal): Integer;
var
  L1,L2:Cardinal;
begin
  L1:=StrBufferLength(S1,MaxLen);
  L2:=StrBufferLength(S2,MaxLen);
  Result := CompareString(LOCALE_USER_DEFAULT, SORT_STRINGSORT,
    S1, L1 , S2, L2) - 2;
  if(Result=0)and(L1>L2)then Result:=1 else
  if(Result=0)and(L1<L2)then Result:=-1;
end;

function AnsiStrLIComp0(S1, S2: PChar; MaxLen: Cardinal): Integer;
var
  L1,L2:Cardinal;
begin
  L1:=StrBufferLength(S1,MaxLen);
  L2:=StrBufferLength(S2,MaxLen);
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE or SORT_STRINGSORT,
    S1, L1 , S2, L2) - 2;
  if(Result=0)and(L1>L2)then Result:=1 else
  if(Result=0)and(L1<L2)then Result:=-1;
end;

function DelLeftSpace(const S:string):string;
var
  I,X,sLen:Integer;
begin
  Result:=S;
  sLen:=Length(Result);
  x:=1;
  for I:=1 to sLen do
    if(Result[I]<>' ')then begin
      x:=I;
      break;
    end;
  Result:=Copy(Result,x,sLen-x+1);
end;

function DelRightSpace(const S:string):string;
var
  I,X,sLen:Integer;
begin
  Result:=S;
  sLen:=Length(Result);
  x:=1;
  for I:=sLen downto 1 do
    if(Result[I]<>' ')then begin
      x:=I;
      break;
    end;
  Result:=Copy(Result,1,x-1);
end;

function RightPos(const SubStr,S:string):Integer;
var
  ssl,sl,I:Integer;
begin
  if(SubStr='')then begin
    Result:=0;Exit;
  end;
  ssl:=Length(SubStr);sl:=Length(S);
  for I:=sl-ssl+1 downto 1 do
    if(S[I]=SubStr[1])and(SubStr=Copy(s,I,ssl))then begin
      Result:=I;Exit;
    end;
  Result:=0;
end;

function PCharHeadComp(const p1,p2:PChar):Integer;
asm
        TEST    EAX,EAX
        JZ      @@exit    //zero
        TEST    EDX,EDX
        JZ      @@exit    //undefined
        MOV     ECX,EAX
@@loop:
        MOV     AL,[ECX]
        TEST    AL,AL
        JZ      @@exit
        SUB     AL,[EDX]
        JB      @@1
        JA      @@2
        INC     ECX
        INC     EDX
        JMP     @@loop
@@1:    XOR     EAX,EAX
        DEC     EAX
        JMP     @@exit
@@2:    XOR     EAX,EAX
        INC     EAX
@@exit:
end;

function StrHeadComp(const s,head:string):Integer;
var
  sh:string;
  hlen:Integer;
begin
  hlen:=Length(head);
  sh:=Copy(s,1,hlen);
  Result:=AnsiCompareStr(sh,head);
end;

function StrTailComp(const s,tail:string):Integer;
var
  st:string;
  slen,tlen:Integer;
begin
  slen:=Length(s);tlen:=Length(tail);
  st:=Copy(s,slen-tlen+1,tlen);
  Result:=AnsiCompareStr(st,tail);
end;

function TextHeadComp(const s,head:string):Integer;
var
  sh:string;
  hlen:Integer;
begin
  hlen:=Length(head);
  sh:=Copy(s,1,hlen);
  Result:=AnsiCompareText(sh,head);
end;

function TextTailComp(const s,tail:string):Integer;
var
  st:string;
  slen,tlen:Integer;
begin
  slen:=Length(s);tlen:=Length(tail);
  st:=Copy(s,slen-tlen+1,tlen);
  Result:=AnsiCompareText(st,tail);
end;

function strExcludeChar(const str:string;delChar:Char):string;
var
  ch:Char;
  p,strLen,l:Integer;
begin
  strLen:=Length(str);
  l:=0;
  for p:=1 to strLen do
    if(str[p]=delChar)then Inc(l);
  SetLength(Result,strLen-l);
  l:=1;
  for p:=1 to strLen do begin
    ch:=str[p];
    if(ch<>delChar)then begin
      Result[l]:=ch;Inc(l);
    end;
  end;
end;

function strDeleteSub(const s,subStr:string):string;
var
  dp0,dp,slen:Integer;
begin
  Result:=s;
  slen:=Length(subStr);
  if(sLen=0)then Exit;
  dp0:=0;
  dp:=Pos(subStr,Result);
  while(dp>0)and(dp>=dp0)do begin
    Result:=Copy(Result,1,dp-1)+Copy(Result,dp+slen,Length(result)-dp-slen+1);
    dp0:=dp;
    dp:=Pos(subStr,Result);
  end;
end;

function strReplaceChar(const str:string;OldChar,NewChar:Char):string;
var
  I,slen:Integer;
begin
  slen:=Length(str);
  SetLength(Result,slen);
  I:=1;
  while(I<=slen)do begin
    case ByteType(str,I) of
      mbSingleByte:if(str[I]<>OldChar)then Result[I]:=str[I] else Result[I]:=NewChar;
      mbLeadByte:
        begin
          Result[I]:=str[I];
          Inc(I);if(I<=slen)then Result[I]:=str[I];
        end;
      mbTrailByte:Result[I]:=str[I];
    end;
    Inc(I);
  end;
end;

function strReplaceQuoted(const sInitial:string;RPChar:Char;QuoteMark:Char):string;
var
  I,P,LC,sLen:Integer;
begin
  sLen:=Length(sInitial);

  SetLength(Result,sLen);
  System.Move(Pointer(sInitial)^,Pointer(Result)^,sLen);

  LC:=0;P:=0;
  for I:=1 to sLen do begin
    if(sInitial[I]<>QuoteMark)then Continue;
    if(LC=0)then begin
      P:=I+1;
      Inc(LC);
    end else begin
      Dec(LC);
      FillChar(Result[P],I-P,RPChar);
    end;
  end;
end;

function strReplaceQuoted(const sInitial:string;RPChar:Char;LQMark,RQMark:Char):string;
var
  I,P,LC,sLen:Integer;
begin
  if(LQMark=RQMark)then begin
    Result:=strReplaceQuoted(sInitial,RPChar,LQMark);
    Exit;
  end;
  sLen:=Length(sInitial);

  SetLength(Result,sLen);
  System.Move(Pointer(sInitial)^,Pointer(Result)^,sLen);

  LC:=0;P:=0;
  for I:=1 to sLen do begin
    if(sInitial[I]=LQMark)then begin
      if(LC=0)then P:=I+1;
      Inc(LC);
    end else if(sInitial[I]=RQMark)then begin
      if(LC=0)then Continue;
      Dec(LC);
      if(LC=0)then begin
        FillChar(Result[P],I-P,RPChar);
      end;
    end;
  end;
end;

function strGetQuoted(const sInitial:string;QuoteMark:Char;var sCode:string):string;
var
  I,P,LC,sLen:Integer;
begin
  sLen:=Length(sInitial);
  LC:=0;P:=0;
  Result:='';
  sCode:=Format('找不到『%s』',[QuoteMark]);
  for I:=1 to sLen do begin
    if(sInitial[I]<>QuoteMark)then Continue;
    if(LC=0)then begin
      P:=I+1;
      Inc(LC);sCode:=Format('『%s』不匹配',[QuoteMark]);
    end else begin
      Result:=Copy(sInitial,P,I-P);
      sCode:='';
      Break;
    end;
  end;
end;

function strGetQuoted(const sInitial:string;LQMark:Char;RQMark:Char;var sCode:string):string;
var
  I,P,LC,sLen:Integer;
begin
  if(LQMark=RQMark)then begin
    Result:=strGetQuoted(sInitial,LQMark,sCode);
    Exit;
  end;
  sLen:=Length(sInitial);
  LC:=0;P:=0;
  sCode:=Format('找不到『%s』',[LQMark]);
  for I:=1 to sLen do begin
    if(sInitial[I]=LQMark)then begin
      if(LC=0)then P:=I+1;
      Inc(LC);sCode:=Format('缺『%s』',[RQMark]);
    end else if(sInitial[I]=RQMark)then begin
      if(LC=0)then begin
        sCode:=Format('缺『%s』',[LQMark]);Break;
      end;
      Dec(LC);
      if(LC=0)then begin
        Result:=Copy(sInitial,P,I-P);
        sCode:='';
        Break;
      end;
    end;
  end;
end;

function UpdateStr(const s:String):String;
var
  x,y:LongInt;
begin
  x:=1;y:=Length(s);
  while((s[x]<>#0)and(x<=y))do Inc(x);
  Result:=Copy(s,1,x-1);
end;

function strTripQuote(const s:String):String;
var
  l:Integer;
begin
  l:=Length(s);
  if(l>2)and(s[1]='"')and(s[l]='"')then begin
    Result:=Copy(s,2,l-2);
  end else
    Result:=s;
end;

function StrIsZeroValue(const FloatStr:string):Boolean;
var
  meetdot:Boolean;
  I,p,sLen:Integer;
begin
  Result:=False;
  sLen:=Length(FloatStr);
  meetdot:=False;p:=0;
  for I:=1 to sLen do
    if(FloatStr[I]='.')then begin
      if(not meetdot)then begin
        meetdot:=True;p:=I;
      end else Exit;
    end else if(FloatStr[I]<>'0')then Exit;
  if(meetdot)and(p<=2)or(not meetdot)and(slen=1)then 
      Result:=True;
end;

procedure StreamWriteS(Stream:TStream;const s:string);
var
  sLen:Integer;
begin
  sLen:=Length(s);
  Stream.Write(sLen,Sizeof(sLen));
  if(sLen>0)then begin
    Stream.WriteBuffer(Pointer(s)^,sLen);
  end;
end;

function  StreamReadS(Stream:TStream):String;
var
  sLen:Integer;
begin
  sLen:=0;
  Stream.ReadBuffer(sLen,Sizeof(sLen));
  if(sLen>0)and(sLen<$1000000{16M})then begin
    SetString(Result,nil,sLen);
    Stream.ReadBuffer(Pointer(Result)^,sLen);
  end else if(sLen=0)then Result:=''
  else
    raise EReadError.Create(SReadError);
end;

procedure StreamSkipS(Stream:TStream);
var
  sLen:Integer;
begin
  sLen:=0;
  Stream.ReadBuffer(sLen,Sizeof(sLen));
  if(sLen>0)then begin
    Stream.Seek(sLen,soFromCurrent);
  end;
end;

function  sReadln(Stream:TStream;var str:string):Integer;
const cr=13;lf=10;BufSize=256;
var
  I,c,sp,p,ss:Integer;
  Buffer:array[0..BufSize] of BYTE;
begin
  Result:=0;SetLength(str,Result);
  
  sp:=Stream.Position;ss:=Stream.Size;
  p:=sp;
  while(p<ss)do begin
    c:=BufSize;
    if(p+c>ss)then c:=ss-p;
    Stream.ReadBuffer(Buffer,c);
    Buffer[c]:=cr;
    I:=0;while(Buffer[I]<>cr)do Inc(I);
    if(I<c)then begin
      if(I<c-1)then begin
        Inc(I);
        if(Buffer[I]=lf)then Inc(I);
        Stream.Position:=p+I;
        c:=I-2;
        if(c>0)then begin
          SetLength(str,Result+c);
          System.Move(Buffer,Pointer(@str[Result+1])^,c);
          Inc(Result,c);
        end;
        Exit;
      end else begin
        p:=p+c;
        c:=I-1;
        if(c>0)then begin
          SetLength(str,Result+c);
          System.Move(Buffer,Pointer(@str[Result+1])^,c);
          Inc(Result,c);
        end;
        if(p<ss)then begin
          Stream.ReadBuffer(Buffer,1);
          if(Buffer[0]<>lf)then Stream.Seek(-1,soFromCurrent);
        end;
        Exit;
      end;
    end else begin                  
      Inc(p,I);//I=c
      SetLength(str,p-sp);
      System.Move(Buffer,Pointer(@str[Result+1])^,I);
      Inc(Result,I);
      {if(p=ss)then begin
        Result:=0;str:='';
      end;}
    end;
  end;
end;

function  sWriteln(Stream:TStream;const str:string):Integer;
const CR:Word=$0A0D;
begin
  Result:=Length(str);
  if(Result>0)then begin
    Stream.Write(Pointer(str)^,Result);
  end;
  Stream.Write(CR,2);
end;

function CheckStrKeyValid(pKey:Pointer;KeyLen:Integer):Boolean;
asm
        MOV     ECX,EDX
        MOV     EDX,EAX
@@comp:
        MOV     AL,[EDX]
        INC     EDX
        CMP     AL,$20
        JBE     @@InvalidExit
        DEC     ECX
        JNZ     @@comp
@@ValidExit:
        XOR     EAX,EAX
        INC     EAX
        RET
@@InvalidExit:
        XOR     EAX,EAX
        RET
end;
function GetKey(Seed:Integer):Byte;
var
  Y:Integer;
begin
  Y:=(Seed div 7+1)*48766 mod 41;
  Y:=Y*Y*Y;
  Y:=2+Trunc(2*Sin(Y*37743+ArcTan(Seed)*10));
  Result:=Y;
end;

function GetKey0(Key:Byte):Byte;
const
  Keys:array[0..15]of BYte=(13,5,4,11,9,0,8,12,10,7,2,15,6,3,1,14);
begin
  result:=Keys[Key mod 16];
end;

function EncodeString(S:String):String;
var
  I:Integer;
  B1,B2:Byte;
begin
  SetLength(Result,2*Length(s));
  for I:=1 to Length(s) do begin
    B1:=Byte(S[I]);B2:=B1;
    B1:=B1 and $0F;B2:=B2 SHR 4;
    Result[2*I-1]:=Char(32+GetKey(100+I)*B1+GetKey0(I));
    Result[2*I]:=Char(32+GetKey(12345+I)*B2+GetKey0(I));
  end;
end;

function DecodeString(S:String):String;
var
  I:Integer;
  B1,B2:Byte;
begin
  SetLength(Result,Length(s)div 2);
  for I:=1 to Length(s)div 2 do begin
    B1:=Byte(S[2*I-1])-32-GetKey0(I);
    B2:=Byte(S[2*I])-32-GetKey0(I);
    B1:=B1 div GetKey(100+I);
    B2:=B2 div GetKey(12345+I);
    B2:=B2 SHL 4;B1:=B1 or B2;
    Result[I]:=Char(B1);
  end;
end;

procedure ResetFPU;
asm
    FNINIT
end;

const
  ST0Tag=$C000;
  ST17Tag=$3FFF;
procedure Evaluate(const str:string;var V:Single;var Code:Integer);
var
  Save0,Save1:array[0..15] of Word;
begin
  asm
    LEA     EDX,Save0
    FNSTENV [EDX]
  end;
  Val(Str,V,Code);
  asm
    LEA     EDX,Save1
    FNSTENV [EDX]
  end;
  if((Save0[4] xor Save1[4]) and ST17Tag<>0)
        or(Save0[4] and ST0Tag=ST0Tag)and(Save1[4] and ST0Tag<>ST0Tag)then begin
    asm FSTP ST(0) end;
    Code:=1;
  end;
end;
procedure Evaluate(const str:string;var V:Double;var Code:Integer);
var
  Save0,Save1:array[0..15] of Word;
begin
  asm
    LEA     EDX,Save0
    FNSTENV [EDX]
  end;
  Val(Str,V,Code);
  asm
    LEA     EDX,Save1
    FNSTENV [EDX]
  end;
  if((Save0[4] xor Save1[4]) and ST17Tag<>0)
        or(Save0[4] and ST0Tag=ST0Tag)and(Save1[4] and ST0Tag<>ST0Tag)then begin
    asm FSTP ST(0) end;
    Code:=1;
  end;
end;
procedure Evaluate(const str:string;var V:Extended;var Code:Integer);
var
  Save0,Save1:array[0..15] of Word;
begin
  asm
    LEA     EDX,Save0
    FNSTENV [EDX]
  end;
  Val(Str,V,Code);
  asm
    LEA     EDX,Save1
    FNSTENV [EDX]
  end;
  if((Save0[4] xor Save1[4]) and ST17Tag<>0)
        or(Save0[4] and ST0Tag=ST0Tag)and(Save1[4] and ST0Tag<>ST0Tag)then begin
    asm FSTP ST(0) end;
    Code:=1;
  end;
end;

function IsNullValue(const Number{: Double}): Boolean; assembler;
asm
        CALL    DoubleGetExponent
        MOV     EDX, EAX
        XOR     EAX, EAX
        CMP     EDX, -963   //1.28266775040574E-290
        JG      @@1
        CMP     EDX, -1022  //2.2250738585072E-308
        JL      @@1
        INC     EAX
@@1:
end;
{$HINTS OFF}
function IsNumberString(const Number:string):Boolean;
var
  Value:Double;
  ErrPos:Integer;
begin
  Evaluate(strExcludeChar(Number,','),Value,ErrPos);
  Result:=ErrPos=0;
end;
{$HINTS ON}
function CheckNumberString(const Number:string;var Value:Double):Boolean;
var
  ErrPos:Integer;
begin
  Evaluate(strExcludeChar(Number,','),Value,ErrPos);
  Result:=ErrPos=0;
end;
function TrimZeroDecimals(const Number:string):string;
var
  P:Integer;
begin
  P:=Length(Number);
  while(P>0)and((Number[P]='0')or(Number[P]=','))do Dec(P);
  if(P>0)and(Number[P]='.')then Dec(P);
  Result:=Copy(Number,1,P);
end;
function InsertThoundMark(const Number:string):string;
var
  D:Integer;
  Str:PChar;
begin
  Str:=PChar(Number);
  D:=Integer(StrScan(Str,'.'))-Integer(Str);
  if(D<0)then D:=Length(Number);
  Result:=Number;
  while(D>3)do
  begin
    Insert(',',Result,D-2);
    Dec(D,3);
  end;
end;
function StringToFloat(const Number:string;Decimal:Integer):Double;
var
  Value:Double;
  ErrPos:Integer;
begin
  {$IFDEF NullNumberSupport}
  if (Number = '') then
  begin
    Result := NullDoubleValue;
    Exit;
  end;
  {$ENDIF}

  Evaluate(strExcludeChar(Number,','),Value,ErrPos);
  if(ErrPos>1)then
    Evaluate(Copy(strExcludeChar(Number,','),1,ErrPos-1),Value,ErrPos);
  if(ErrPos>0)then Value:=0
  else if(Decimal>=0)then
    WindDecimalD3(Value,Decimal);
  Result:=Value;
end;
function FormatNumberString(const Number:Double;Decimal:Integer;ShowThoundMark:Boolean):string;
var
  Number0:Extended;
begin
  {$IFDEF NullNumberSupport}
  if (IsNullValue(Number)) then
  begin
    Result := '';
    Exit;
  end;
  {$ENDIF}
  Number0:=Number;
  Result:=FormatNumberString(Number0,Decimal,ShowThoundMark);
end;
function FormatNumberString(const Number:Extended;Decimal:Integer;ShowThoundMark:Boolean):string;
const
  Formats:array[Boolean] of TFloatFormat=(ffFixed,ffNumber);
var
  Length,Dec:Integer;
  Buffer: array[0..63] of Char;
begin
  if(Decimal>=0)then Dec:=Decimal
  else if(Decimal=-1)then Dec:=6
  else Dec:=-Decimal;
  if(Dec<=15)then
  begin
    Length:=FloatToText(Buffer,Number,fvExtended,Formats[ShowThoundMark],20,Dec);
    SetString(Result,Buffer,Length);
    if(Decimal<0)then
      Result:=TrimZeroDecimals(Result);
  end else begin
    Length:=FloatToText(Buffer,Number,fvExtended,ffGeneral,16,0);
    SetString(Result,Buffer,Length);
    if(ShowThoundMark)then
      Result:=InsertThoundMark(Result);
  end;
end;
function CorrectNumberString(const Number:string;Decimal:Integer):string;
var
  Value:Double;
begin
  Value:=StringToFloat(Number,Decimal);
  Result:=FormatNumberString(Value,Decimal,False);
end;


function StringItemGetName(const str:string):string;
var
  P:Integer;
begin
  P:=AnsiPos('=',str);
  if(P>0)then Result:=Copy(str,1,P-1)
  else Result:='';
end;
function StringItemGetValue(const str:string):string;
var
  P:Integer;
begin
  P:=AnsiPos('=',str);
  if(P>0)then Result:=Copy(str,P+1,MaxInt)
  else Result:='';
end;
function StringsGetValue(Strs:TStrings;Index:Integer):string;
begin
  Result:=StringItemGetValue(Strs[Index]);
end;
function StringsGetValue(Strs:TStrings;const Name:string):string;
var
  Index:Integer;
begin
  Index:=Strs.IndexOfName(Name);
  if(Index>=0)then
    Result:=StringItemGetValue(Strs[Index])
  else Result:='';
end;
procedure StringsSetValue(Strs:TStrings;Index:Integer;const Value:string);
begin
  Strs.Values[Strs.Names[Index]]:=Value;
end;
procedure StringsSetValue(Strs:TStrings;const Name:string;const Value:string);
begin
  Strs.Values[Name]:=Value;
end;

function StringsIndexOfValue(Strs:TStrings;const Value:string):Integer;
var
  I:Integer;
  sItem:string;
begin
  for I:=0 to Strs.Count-1 do begin
    sItem:=Strs[I];
    if(AnsiCompareText(StringItemGetValue(sItem),Value)=0)then begin
      Result:=I;Exit;
    end;
  end;
  Result:=-1;
end;

function StringsToSprString(Source:TStrings;SprChar:Char):string;
var
  I:Integer;
begin
  Result:='';
  for I:=0 to Source.Count-1-1 do begin
    Result:=Result+Source[I]+SprChar;
  end;
  if(Source.Count>0)then
    Result:=Result+Source[Source.Count-1];
end;

procedure SprStringToStrings(const Source:string;SprChar:Char;Values:TStrings);
var
  I,s,l:Integer;
  SprItem:string;
begin
  Values.BeginUpdate;
  try
    Values.Clear;

    s:=1;l:=Length(Source);
    for I:=1 to l do begin
      if(Source[I]=SprChar)then begin
        SprItem:=Copy(Source,s,I-s);
        Values.Add(SprItem);
        s:=I+1;
      end else if((I=l)and(s<=l))then begin
        SprItem:=Copy(Source,s,I-s+1);
        Values.Add(SprItem);
        s:=I+1;
      end;
    end;
  finally
    Values.EndUpdate;
  end;
end;

function  StringGetSecCount(const StringExpr:string):Integer;
var
  ch:char;
  I,slen:Integer;
begin
  Result:=1;
  slen:=Length(StringExpr);
  for I:=1 to slen do
  begin
    ch:=StringExpr[I];
    if(I<slen)and(not(ch in SymbolChars))then Inc(Result);
  end;
end;

function  StringGetSecValue(const StringExpr:string;Index:Integer):string;
var
  ch:char;
  I,P,slen:Integer;
begin
  Assert(Index>=0);
  P:=1;
  slen:=Length(StringExpr);
  for I:=1 to slen do
  begin
    if(ByteType(StringExpr,I)<>mbSingleByte)then Continue;
    ch:=StringExpr[I];
    if(I<slen)and(not(ch in SymbolChars))then
    begin
      if(Index>0)then
      begin
        Dec(Index);P:=I+1;
      end else begin
        Result:=Copy(StringExpr,P,I-P);
        Exit;
      end;
    end;
  end;
  if(Index=0)then
    Result:=Copy(StringExpr,P,slen+1-P)
  else Result:='';
end;

function  StringSetSecValue(var StringExpr:string;Index:Integer;const Value:string;Separator:char=';'):Boolean;
var
  ch:char;
  I,P,slen:Integer;
begin
  Assert(Index>=0);
  P:=1;
  slen:=Length(StringExpr);
  for I:=1 to slen do
  begin
    if(ByteType(StringExpr,I)<>mbSingleByte)then Continue;
    ch:=StringExpr[I];
    if(I<slen)and(not(ch in SymbolChars))then
    begin
      if(Index>0)then
      begin
        Dec(Index);P:=I+1;
      end else begin
        StringExpr:=Copy(StringExpr,1,P-1)+Value+Copy(StringExpr,I,MaxInt);
        Result:=True;
        Exit;
      end;
    end;
  end;
  if(Index=0)then
    StringExpr:=Copy(StringExpr,1,P-1)+Value
  else if(Index=1)then
    StringExpr:=StringExpr+Separator+Value;
  Result:=(Index=0)or(Index=1);
end;

function GetValueByName(Source:TStrings;const Name:string):string;
var
  I:Integer;
begin
  for I:=0 to Source.Count-1 do
    if(Source.Names[I]=Name)then begin
      Result:=Source.Values[Source.Names[I]];Exit;
    end;
  Result:='';
end;

procedure ExMoveStrings(strs:TStrings;moveStart,moveCount,moveTo:Integer);
var
  I,Count:Integer;
begin
  Count:=strs.Count;
  if(moveStart<0)or(moveStart>=Count)
      or(moveTo<0)or(moveTo>=Count)then Exit;

  if(moveStart+moveCount>Count)then moveCount:=Count-moveStart;
  if(moveTo+moveCount>Count)then moveCount:=Count-moveTo;
  if(moveto<movestart)then begin
    for I:=0 to moveCount-1 do
      strs[moveTo+I]:=strs[moveStart+I];
  end else begin
    for I:=moveCount-1 downto 0 do
      strs[moveTo+I]:=strs[moveStart+I];
  end;
end;

function  CompareStrings(Strs1,Strs2:TStrings):Boolean;
var
  I:Integer;
begin
  if(Strs1=Strs2)then begin
    Result:=True;Exit;
  end;
  if(Strs1=nil)or(Strs2=nil)then begin
    Result:=False;Exit;
  end;
  if(Strs1.Count<>Strs2.Count)then begin
    Result:=False;Exit;
  end;
  for I:=0 to Strs1.Count-1 do begin
    if(AnsiCompareStr(Strs1[I],Strs2[I])<>0)then begin
      Result:=False;Exit;
    end;
  end;
  Result:=True;
end;

function  StringsRemoveEmpty(Strs:TStrings):Integer;
var
  I:Integer;
begin
  Result:=0;
  for I:=Strs.Count-1 downto 0 do
    if(Strs[I]='')then begin
      Inc(Result);Strs.Delete(I);
    end;
end;

function  RegReadString(Root:HKEY;const KeyName,ValueName:string;var Value:string):Boolean;
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    Result:=Reg.OpenKey(KeyName,False);
    if(Result)then
      Result:=Result and Reg.ValueExists(ValueName);
    if(Result)then begin
      Value:=Reg.ReadString(ValueName);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function RegReadString(Root:HKEY;const KeyName,ValueName:string):string;
begin
  if(not RegReadString(Root,KeyName,ValueName,Result))then Result:='';
end;

procedure RegWriteString(Root:HKEY;const KeyName,ValueName,Value:string);
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    if(Reg.OpenKey(KeyName,True))then begin
      Reg.WriteString(ValueName,Value);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function  RegReadInteger(Root:HKEY;const KeyName,ValueName:string):Integer;
begin
  if(not RegReadInteger(Root,KeyName,ValueName,Result))then Result:=0;
end;

function  RegReadInteger(Root:HKEY;const KeyName,ValueName:string;var Value:Integer):Boolean;
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    Result:=Reg.OpenKey(KeyName,False);
    if(Result)then
      Result:=Result and Reg.ValueExists(ValueName);
    if(Result)then begin
      Value:=Reg.ReadInteger(ValueName);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure RegWriteInteger(Root:HKEY;const KeyName,ValueName:string;Value:Integer);
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    if(Reg.OpenKey(KeyName,True))then begin
      Reg.WriteInteger(ValueName,Value);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure RegLoadStrings(Root:HKEY;const KeyName:string;Strs:TStrings);
var
  ident:string;
  I,x:Integer;
  Reg:TRegistry;
begin
  Strs.BeginUpdate;
  try
    Strs.Clear;
    Reg:=TRegistry.Create;
    try
      Reg.RootKey:=Root;
      if(Reg.OpenKey(KeyName,False))then begin
        ident:='Count';
        if(Reg.ValueExists(ident))then begin
          x:=StrToIntDef(Reg.ReadString(ident),0);
          for I:=0 to x-1 do
          try
            ident:='Item_'+IntToStr(I);
            if(Reg.ValueExists(ident))then
                  Strs.Add(Reg.ReadString(ident));
          except
          end;
        end;
        Reg.CloseKey;
      end;
    finally
      Reg.Free;
    end;
  finally
    Strs.EndUpdate;
  end;
end;

procedure RegSaveStrings(Root:HKEY;const KeyName:string;Strs:TStrings);
var
  I:Integer;
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    Reg.DeleteKey(KeyName);
    if(Reg.OpenKey(KeyName,True))then begin
      Reg.WriteString('Count',IntToStr(Strs.Count));
      for I:=0 to Strs.Count-1 do
        Reg.WriteString('Item_'+IntToStr(I),Strs[I]);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure INILoadStrs(Ini:TCustomIniFile;const SecName:string;Strs:TStrings);
var
  ident:string;
  I,x:Integer;
begin
  Strs.BeginUpdate;
  try
    Strs.Clear;
    ident:='Count';
    if(Ini.ValueExists(SecName,ident))then begin
      x:=StrToIntDef(Ini.ReadString(SecName,ident,'0'),0);
      for I:=0 to x-1 do
      try
        ident:='Item_'+IntToStr(I);
        if(Ini.ValueExists(SecName,ident))then
              Strs.Add(Ini.ReadString(SecName,ident,''));
      except
      end;
    end;
  finally
    Strs.EndUpdate;
  end;
end;

procedure INISaveStrs(Ini:TCustomIniFile;const SecName:string;Strs:TStrings);
var
  I:Integer;
begin
  Ini.EraseSection(SecName);
  Ini.WriteString(SecName,'Count',IntToStr(Strs.Count));
  for I:=0 to Strs.Count-1 do
    Ini.WriteString(SecName,'Item_'+IntToStr(I),Strs[I]);
end;


procedure RegReadStrings(Root:HKEY;const KeyName:string;Values:TStrings);
var
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    if(Reg.OpenKey(KeyName,False))then begin
      Reg.GetValueNames(Values);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure RegWriteStrings(Root:HKEY;const KeyName:string;Values:TStrings);
var
  I:Integer;
  Reg:TRegistry;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=Root;
    if(Reg.OpenKey(KeyName,True))then begin
      for I:=0 to Values.Count-1 do
        Reg.WriteString(Values[I],'');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure RegRemoveKey(RootKey:HKey;const KeyName:string);
var
  Reg:TRegistry;
  procedure DeleteKeyAndSubKeys(const KeyName:string);
  var
    I:Integer;
    SubKeyNames:TStringList;
  begin
    SubKeyNames:=TStringList.Create;
    try
      if(Reg.OpenKey(KeyName,False))then
      try
        Reg.GetKeyNames(SubKeyNames);
      finally
        Reg.CloseKey;
      end;
      for I:=0 to SubKeyNames.Count-1 do
        DeleteKeyAndSubKeys(KeyName+'\'+SubKeyNames[I]);
    finally
      SubKeyNames.Free;
    end;
    Reg.DeleteKey(KeyName);
  end;
begin
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=RootKey;
    if(Reg.KeyExists(KeyName))then begin
      DeleteKeyAndSubKeys(KeyName);
    end;
  finally
    Reg.Free;
  end;
end;

function  GetElemPtr(Memory:Pointer;ElemSize,Index:LongInt):Pointer;
begin
  Result:=Pointer(DWord(Memory)+DWord(Index*ElemSize));
end;

function InsertElem(Memory:Pointer;ElemSize,Index,OldLen:LongInt):Pointer;
begin
  Assert((Index>=0)and(Index<=OldLen));
  if(Index<OldLen)then begin
    System.Move(Pointer(DWord(Memory)+DWord(ElemSize*Index))^,
                Pointer(DWord(Memory)+DWord(ElemSize*(Index+1)))^,
                ElemSize*(OldLen-Index));
  end;
  Result:=Pointer(DWord(Memory)+DWord(ElemSize*Index));
  FillChar(Result^,ElemSize,0);
end;

procedure DeleteElem(Memory:Pointer;ElemSize,Index,OldLen:LongInt);
var
  elemp:Pointer;
begin
  Assert((Index>=0)and(Index<OldLen));
  if(Index<OldLen-1)then begin
    System.Move(Pointer(DWord(Memory)+DWord(ElemSize*(Index+1)))^,
                Pointer(DWord(Memory)+DWord(ElemSize*Index))^,
                ElemSize*(OldLen-Index-1));
  end;
  elemp:=Pointer(DWord(Memory)+DWord(ElemSize*(OldLen-1)));
  FillChar(elemp^,ElemSize,0);
end;

{ TFontDataClass }

procedure TFontDataClass.Assign(Font: TFontDataClass);
begin
  FName:=Font.FName;
  FCharSet:=Font.FCharSet;
  FHeight:=Font.FHeight;
  FStyle:=Font.FStyle;
  FColor:=Font.FColor;
end;

procedure TFontDataClass.AssignFrom(Font: TFont);
begin
  FName:=Font.Name;
  FCharSet:=Font.CharSet;
  FHeight:=Font.Height;
  FStyle:=Font.Style;
  FColor:=Font.Color;
end;

procedure TFontDataClass.AssignTo(Font: TFont);
begin
  Font.Name:=FName;
  Font.CharSet:=FCharSet;
  Font.Height:=FHeight;
  Font.Style:=FStyle;
  Font.Color:=FColor;
end;

constructor TFontDataClass.Create;
begin
  inherited;
  FName:='宋体';
  FHeight:=-12;
  FStyle:=[];
  FColor:=clBlack;
end;

procedure TFontDataClass.LoadFromStream(Stream: TStream);
begin
  FName:=StreamReadS(Stream);
  Stream.Read(FCharSet,Sizeof(FCharSet));
  Stream.Read(FHeight,sizeof(FHeight));
  Stream.Read(FStyle,sizeof(Fstyle));
  Stream.Read(FColor,sizeof(FColor));
end;

procedure TFontDataClass.SaveToStream(Stream: TStream);
begin
  StreamWriteS(Stream,FName);
  Stream.Write(FCharSet,Sizeof(FCharSet));
  Stream.Write(FHeight,sizeof(FHeight));
  Stream.Write(FStyle,sizeof(Fstyle));
  Stream.Write(FColor,sizeof(FColor));
end;

{ TPenDataClass }

procedure TPenDataClass.Assign(Pen:TPenDataClass);
begin
  FColor:=Pen.FColor;
  FMode:=Pen.FMode;
  FStyle:=Pen.FStyle;
  Fwidth:=Pen.FWidth;
end;

procedure TPenDataClass.AssignTo(Pen:TPen);
begin
  Pen.Color:=FColor;
  Pen.Mode:=FMode;
  Pen.Style:=FStyle;
  Pen.Width:=FWidth;
end;

procedure TPenDataClass.AssignFrom(Pen:TPen);
begin
  FColor:=Pen.Color;
  FMode :=Pen.Mode ;
  FStyle:=Pen.Style;
  FWidth:=Pen.Width;
end;

procedure TPenDataClass.SaveToStream(Stream:TStream);
var
  B:Byte;
begin
  Stream.Write(FColor,Sizeof(FColor));
  B:=Byte(FMode);
  Stream.Write(B,Sizeof(b));
  B:=Byte(FStyle);
  Stream.Write(B,Sizeof(b));
  Stream.Write(FWidth,Sizeof(FWidth));
end;

procedure TPenDataClass.LoadFromStream(Stream:TStream);
var
  B:Byte;
begin
  Stream.read(FColor,Sizeof(FColor));
  Stream.Read(B,Sizeof(b));
  FMode:=TPenMode(B);
  Stream.Read(B,Sizeof(b));
  FStyle:=TPenStyle(B);
  Stream.Read(FWidth,Sizeof(FWidth));
end;


constructor TPenDataClass.Create;
begin
  inherited;
  FColor:=clBlack;
  FMode:=pmCopy;
  FStyle:=psSolid;
  FWidth:=1;
end;

{ TBrushDataClass }

procedure TBrushDataClass.Assign(Brush:TBrushDataClass);
begin
  FColor:=Brush.FColor;
  FStyle:=Brush.FStyle;
end;

procedure TBrushDataClass.AssignTo(Brush:TBrush);
begin
  Brush.Color:=FColor;
  Brush.Style:=FStyle;
end;

procedure TBrushDataClass.AssignFrom(Brush:TBrush);
begin
  FColor:=Brush.Color;
  FStyle:=Brush.Style;
end;

constructor TBrushDataClass.Create;
begin
  inherited;
  FColor:=clWhite;
  FStyle:=bsSolid;
end;

procedure TBrushDataClass.SaveToStream(Stream:TStream);
var
  B:Byte;
begin
  Stream.Write(FColor,Sizeof(FColor));
  B:=Byte(FStyle);
  Stream.Write(B,Sizeof(b));
end;

procedure TBrushDataClass.LoadFromStream(Stream:TStream);
var
  B:Byte;
begin
  Stream.Read(FColor,Sizeof(FColor));
  Stream.read(B,Sizeof(b));
  FStyle:=TBrushStyle(B);
end;

procedure AddPathSpr(var aPath:String);
begin
  if(AnsiLastChar(aPath)<>Nil)and(AnsiLastChar(aPath)^ <> '\')then
    aPath:=aPath+'\'
end;

procedure DeleteTailPathSpr(var aPath:string);
begin
  if(AnsiLastChar(aPath)<>Nil)and(AnsiLastChar(aPath)^='\')then
    aPath:=Copy(aPath,1,Length(aPath)-1)
end;

function DeleteTailPathSpr0(const aPath:string):string;
begin
  if(AnsiLastChar(aPath)<>Nil)and(AnsiLastChar(aPath)^='\')then
    Result:=Copy(aPath,1,Length(aPath)-1)
  else Result:=aPath;
end;

function ReplaceFileNameSpr(const aPath:string;Spr:char='_'):string;
var
  I,l:Integer;
begin
  l:=Length(aPath);
  SetLength(Result,l);
  for I:=1 to l do
    if(aPath[I]<>'\')then Result[I]:=aPath[I] else Result[I]:=Spr;
end;

function ConcatPathFileName(const Path, S: String): String;
begin
  if(AnsiLastChar(Path)<>Nil)and(AnsiLastChar(Path)^ <> '\')then
    Result := Path + '\' + S
  else
    Result := Path + S;
end;

function IsValidFileName(const FileName:string):Boolean;
var
  Test:Integer;
begin
  if FileExists(FileName)or DirectoryExists(FileName)
      then Result:=True
  else
  try
    Test:=CreateFile(Pchar(FileName),GENERIC_WRITE,0,nil,CREATE_NEW,FILE_FLAG_DELETE_ON_CLOSE,0);
    if(Test=Integer(INVALID_HANDLE_VALUE))then
      Result:=False
    else begin
      CloseHandle(Test);
      Result:=True;
    end;
  except
    Result:=False;
  end;
end;

function time_GetTempFileName(const NamePrefix:string='';const PathName:string=''):string;
var
  FileName,FileDir:string;
  pFileDir:Pointer;
  nCount:DWord;
  SystemTime: TSystemTime;
  FileID:Integer;
begin
  FileId:=0;
  if(PathName='')or(not DirectoryExists(PathName))then begin
    GetMem(pFileDir,512);
    try
      ZeroMemory(pFileDir,512);
      nCount:=GetTempPath(511,pFileDir);
      if(nCount>511)then begin
        ReallocMem(pFileDir,nCount+1);
        ZeroMemory(pFileDir,nCount+1);
        GetTempPath(nCount,pFileDir);
      end;
      FileDir:=StrPas(PChar(pFileDir));
    finally
      FreeMem(pFileDir);
    end;
  end else
    FileDir:=PathName;
  GetLocalTime(SystemTime);
  FileName:=ConcatPathFileName(FileDir,
        NamePrefix+Format('%2.2d%2.2d%2.2d%2.2d_%5.5d',
            [SystemTime.wMonth,SystemTime.wDay,SystemTime.wHour,
             SystemTime.wMinute,SystemTime.wSecond*SystemTime.wMilliseconds]));
  Result:=FileName;
  while(GetFileAttributes(PChar(Result+'.TMP'))<>Max32bValue)do begin
    Result:=FileName+'_'+IntToStr(FileID);
    Inc(FileID);
  end;
  Result:=Result+'.TMP';
end;

procedure EmptyDirectory(Directory:string;IncludeSubDir:Boolean);
var
  fHandle:THandle;
  Name:string;
  FindData:TWin32FindData;
begin
  if(Directory='')then Exit;
  Directory:=DeleteTailPathSpr0(Directory);
    FillChar(FindData,sizeof(FindData),0);
    fHandle:=FindFirstFile(PChar(Directory+'\*.*'),FindData);
    if(fHandle<>INVALID_HANDLE_VALUE)then
      repeat
        Name:=StrPas(FindData.cFileName);
        if(IncludeSubDir and ((FindData.dwFileAttributes and faDirectory)=faDirectory))then
        begin
          if(Name<>'.')and(Name<>'..')then
            RemoveDirectory(Directory+'\'+Name);
        end else
          DeleteFile(Directory+'\'+Name);
      until (not FindNextFile(fHandle,FindData));
    Windows.FindClose(fHandle);
end;

procedure RemoveDirectory(const Directory:string);
begin
  EmptyDirectory(Directory,True);
  RemoveDir(Directory);
end;

///////////////////////////////////////////////////////////
const
  Key1=$3C3c3c3c;
  Key2=$3b3b3b3b;
  Key3=$67676767;

procedure EncodeSave(Denst:TStream;Source:Pointer;
                     IntCount:LongInt;SecretKey:LongInt);
label
  a1,a2;
var
  Data:Pointer;
begin
  if(IntCount<=0)or(Source=nil)or(Denst=nil)then Exit;
  GetMem(Data,IntCount*4*3);
  try
    asm
      PUSH EDI;PUSH ESI;PUSH EBX;
      PUSH Key3;
      PUSH Key2;
      PUSH Key1;
      MOV ECX,3;
      MOV EBX,SecretKey;
      MOV EDI,Data;
   a1:MOV ESI,Source;
      POP EDX;
      PUSH ECX;
      MOV ECX,IntCount;
      CLD;
   a2:LODSD;
      XOR EAX,EDX;
      XOR EAX,EBX;
      STOSD;
      ADD EBX,$14233241;
      LOOP a2
      POP ECX;
      LOOP a1;
      POP EBX;POP ESI;POP EDI;
    end;
    Denst.Write(Data^,IntCount*4*3);
  finally
    FreeMem(Data);
  end;
end;

function DecodeLoad(Source:TStream;Denst:Pointer;
                    IntCount:LongInt;SecretKey:LongInt):Byte;
type
  IntArray=Array[0..$FFFFFF]of Integer;
  PIntArray=^IntArray;
label
  a1,a2;
var
  Data:Pointer;
  dData:PIntArray;
  DataLen,I,
  i1,i2,i3:LongInt;
begin
  Result:=0;
  if(IntCount<=0)or(Denst=nil)or(Source=nil)then Exit;
  DataLen:=IntCount*4*3;
  GetMem(dData,DataLen);
  try
    GetMem(Data,DataLen);
    try
      Source.Read(Data^,DataLen);
      asm
        PUSH EDI;PUSH ESI;PUSH EBX;
        PUSH Key3;
        PUSH Key2;
        PUSH Key1;
        MOV ECX,3;
        MOV EBX,SecretKey;
        MOV ESI,Data;
        MOV EDI,dData;
     a1:POP EDX;
        PUSH ECX;
        MOV ECX,IntCount;
        CLD;
     a2:LODSD;
        XOR EAX,EBX;
        XOR EAX,EDX;
        STOSD;
        ADD EBX,$14233241;
        LOOP a2
        POP ECX;
        LOOP a1;
        POP EBX;POP ESI;POP EDI;
      end;
    finally
      FreeMem(Data);
    end;
    for I:=0 to IntCount-1 do begin
      I1:=dData^[I];I2:=dData^[IntCount+I];I3:=dData^[2*IntCount+I];
      if not((I1=I2)and(I2=I3))then Result:=Result or 1;
      if(I1=I2)then
        PIntArray(Denst)^[I]:=I1
      else if(I1=I3)then
        PIntArray(Denst)^[I]:=I2
      else if(I2=I3)then
        PIntArray(Denst)^[I]:=I3
      else
        Result:=Result or 2;
    end;
  finally
    FreeMem(dData);
  end;
end;

const
  Key11=$3C5E45A4;
  Key12=$85469456;
  Key13=$5F8D5A5C;

procedure EncodeSave1(Denst:TStream;Source:Pointer;
                     IntCount:LongInt;SecretKey:LongInt);
label
  a1,a2;
var
  Data:Pointer;
begin
  if(IntCount<=0)or(Source=nil)or(Denst=nil)then Exit;
  GetMem(Data,IntCount*4*3);
  try
    asm
      PUSH EDI;PUSH ESI;PUSH EBX;
      PUSH Key13;
      PUSH Key12;
      PUSH Key11;
      MOV ECX,3;
      MOV EBX,SecretKey;
      MOV EDI,Data;
   a1:MOV ESI,Source;
      POP EDX;
      PUSH ECX;
      MOV ECX,IntCount;
      CLD;
   a2:LODSD;
      XOR EAX,EBX;
      XOR EAX,EDX;
      STOSD;
      ADD EBX,$C57B9348;
      LOOP a2
      POP ECX;
      LOOP a1;
      POP EBX;POP ESI;POP EDI;
    end;
    Denst.Write(Data^,IntCount*4*3);
  finally
    FreeMem(Data);
  end;
end;

function DecodeLoad1(Source:TStream;Denst:Pointer;
                    IntCount:LongInt;SecretKey:LongInt):Byte;
type
  IntArray=Array[0..$FFFFFF]of Integer;
  PIntArray=^IntArray;
label
  a1,a2;
var
  Data:Pointer;
  dData:PIntArray;
  DataLen,I,
  i1,i2,i3:LongInt;
begin
  Result:=0;
  if(IntCount<=0)or(Denst=nil)or(Source=nil)then Exit;
  DataLen:=IntCount*4*3;
  GetMem(dData,DataLen);
  try
    GetMem(Data,DataLen);
    try
      Source.Read(Data^,DataLen);
      asm
        PUSH EDI;PUSH ESI;PUSH EBX;
        PUSH Key13;
        PUSH Key12;
        PUSH Key11;
        MOV ECX,3;
        MOV EBX,SecretKey;
        MOV ESI,Data;
        MOV EDI,dData;
     a1:POP EDX;
        PUSH ECX;
        MOV ECX,IntCount;
        CLD;
     a2:LODSD;
        XOR EAX,EDX;
        XOR EAX,EBX;
        STOSD;
        ADD EBX,$C57B9348;
        LOOP a2
        POP ECX;
        LOOP a1;
        POP EBX;POP ESI;POP EDI;
      end;
    finally
      FreeMem(Data);
    end;
    for I:=0 to IntCount-1 do begin
      I1:=dData^[I];I2:=dData^[IntCount+I];I3:=dData^[2*IntCount+I];
      if not((I1=I2)and(I2=I3))then Result:=Result or 1;
      if(I1=I2)then
        PIntArray(Denst)^[I]:=I1
      else if(I1=I3)then
        PIntArray(Denst)^[I]:=I2
      else if(I2=I3)then
        PIntArray(Denst)^[I]:=I3
      else
        Result:=Result or 2;
    end;
  finally
    FreeMem(dData);
  end;
end;

function RedundanceDataProofread(var Data;Length:Integer;RepCount:Integer=3):Integer;
var
  I:Integer;
  B1,B2,B3:BYTE;
begin
  Assert(RepCount=3);
  Result:=0;
  for I:=0 to Length-1 do begin
    B1:=TBytesArray(Data)[I];
    B2:=TBytesArray(Data)[Length+I];
    B3:=TBytesArray(Data)[2*Length+I];
    if not((B1=B2)and(B2=B3))then Result:=Result or 1
    else begin
      if(B1=B2)or(B1=B3)then Continue
      else if(B2=B3)then TBytesArray(Data)[I]:=B2
      else Result:=Result or 2;
    end;
  end;
end;

function FindMatchFontName(const Name:string):string;
var
  I:Integer;
begin
  Result:='';
  with Screen.Fonts do begin
    if(IndexOF(Name)>=0)then begin
      Result:=Name;
      Exit;
    end;
    for I:=0 to Count-1 do begin
      Result:=Strings[I];
      if(Result<>'')and(Result[1]<>'@')and(Pos(Name,Result)>0)then Exit;
    end;
    if(IndexOf('System')>=0)then Result:='System'
    else Result:='';
  end;
end;


function  SkipString(Stream:TStream):Integer;
var
  slen:Int32;
begin
  slen:=0;
  Stream.ReadBuffer(slen,Sizeof(slen));
  if(slen>0)and(slen<=MaxStringRWLength)then begin
    Stream.Seek(slen,soFromCurrent);
  end else if(slen>MaxStringRWLength)then 
    raise EStreamError.CreateFmt('读字符串太长(%d)',[slen]);
  Result:=slen;
end;
function  ReadString(Stream:TStream):string;
var
  slen:Int32;
begin
  slen:=0;
  Stream.ReadBuffer(slen,Sizeof(slen));
  if(slen>0)and(slen<=MaxStringRWLength)then begin
    SetString(Result,nil,slen);
    Stream.ReadBuffer(Pointer(Result)^,slen);
  end else if(slen=0)then Result:=''
  else
    raise EStreamError.CreateFmt('读字符串太长(%d)',[slen]);
end;
function  ReadString(Stream:TStream;str:PChar):Integer;
var
  slen:Int32;
begin
  slen:=0;
  Stream.ReadBuffer(slen,Sizeof(slen));
  if(slen>0)and(slen<=MaxStringRWLength)then begin
    Stream.ReadBuffer(str^,slen);
  end else if(slen=0)then str[0]:=#0
  else
    raise EStreamError.CreateFmt('读字符串太长(%d)',[slen]);
  Result:=slen;
end;
function  WriteString(Stream:TStream;const str:string):Integer;
var
  slen:Int32;
begin
  slen:=Length(str);
  if(slen>MaxStringRWLength)then
    raise EStreamError.CreateFmt('写字符串太长(%d)',[slen]);
  Stream.Write(slen,Sizeof(slen));
  if(slen>0)then begin
    Stream.WriteBuffer(Pointer(str)^,slen);
  end;
  Result:=slen;
end;
function  WriteString(Stream:TStream;const str:PChar):Integer;
var
  slen:Int32;
begin
  slen:=StrLen(str);
  if(slen>MaxStringRWLength)then
    raise EStreamError.CreateFmt('写字符串太长(%d)',[slen]);
  Stream.Write(slen,Sizeof(slen));
  if(slen>0)then begin
    Stream.WriteBuffer(Pointer(str)^,slen);
  end;
  Result:=slen;
end;

function  ReadlnString(Stream:TStream):string;
begin
  ReadlnString(Stream,Result);
end;
function  ReadlnString(Stream:TStream;var str:string):Integer;
const cr=13;lf=10;BufSize=128;
var
  I,C,L,SS:Integer;
  Buffer:array[0..BufSize] of Byte;
begin
  Result:=0;SetLength(str,Result);

  SS:=Stream.Size;
  while(not Stream.Position<SS)do begin
    C:=Stream.Read(Buffer,BufSize);
    Buffer[C]:=cr;
    I:=0;while(Buffer[I]<>cr)do Inc(I);
    if(I<C)then begin
      if(I<C-1)then begin
        L:=I;
        Inc(I);
        if(Buffer[I]=lf)then
            Inc(I);
        Stream.Seek(I-C,soFromCurrent);
        if(L>0)then begin
          SetLength(str,Result+L);
          System.Move(Buffer,Pointer(@str[Result+1])^,L);
          Inc(Result,L);
        end;
      end else begin
        L:=I;
        if(L>0)then begin
          SetLength(str,Result+L);
          System.Move(Buffer,Pointer(@str[Result+1])^,L);
          Inc(Result,L);
        end;
        if(not Stream.Position<SS)then begin
          Stream.ReadBuffer(Buffer,1);
          if(Buffer[0]<>lf)then
            Stream.Seek(-1,soFromCurrent);
        end;
      end;
      Exit;
    end else if(C>0)then begin //I=C                 
      SetLength(str,Result+C);
      System.Move(Buffer,Pointer(@str[Result+1])^,C);
      Inc(Result,C);
    end else
      Break;//nothing read in
  end;
end;
procedure CopyDataUntilCR(Src,Dst:TStream;MeetData:PChar;MeetLength:Integer);
const
  BufSize=4096;
var
  CmpBuf:array [0..127] of char;
  Buffer:array [0..BufSize] of char;
  Pos,Size,Count,I,Len,CmpLen,RC:Integer;
begin
  Pos:=Src.Position;Size:=Src.Size;

  while(Pos<Size)do begin
    Count:=Size-Pos;if(Count>BufSize)then Count:=BufSize;
    Assert(Pos=Src.Position);
    Src.ReadBuffer(Buffer,Count);
    I:=0;Buffer[Count]:=#13;
    while(I<Count)do
    begin
      while(Buffer[I]<>#13)do Inc(I);

      if(I=Count)then begin
        if(Dst<>nil)then Dst.WriteBuffer(Buffer,Count);
        Inc(Pos,Count);
      end else begin
        Len:=I;Inc(I);
        if(I<Count)and(Buffer[I]=#10)then Inc(I)
        else if(I=Count)and(Pos+Count<Size)then
        begin
          Src.ReadBuffer(CmpBuf,1);
          if(CmpBuf[0]<>#10)then Src.Seek(-1,soFromCurrent);
        end;
        CmpLen:=MinInteger(MeetLength,Count-I);
        if(CmpLen>0)and(not CompareMem(@Buffer[I],MeetData,CmpLen))then
          Continue;

        while(MeetLength>CmpLen)do begin
          RC:=MeetLength-CmpLen;
          if(RC>sizeof(CmpBuf))then RC:=sizeof(CmpBuf);
          Src.ReadBuffer(CmpBuf,RC);
          if(not CompareMem(@CmpBuf[0],MeetData+CmpLen,RC))then
          begin
            Src.Seek(Pos+Count,soFromBeginning);
            if(I=Count)then
            begin
              if(Dst<>nil)then Dst.WriteBuffer(Buffer,Count);
              Inc(Pos,Count);
            end;
            Break;
          end;
          Inc(CmpLen,RC);
        end;
        if(MeetLength=CmpLen)then
        begin
          if(Dst<>nil)then Dst.WriteBuffer(Buffer,Len);
          Src.Seek(Pos+Len,soFromBeginning);
          Exit;
        end;
      end;
    end;
  end;
end;

function  WritelnString(Stream:TStream;const str:string):Integer;
var
  slen:Int32;
begin
  slen:=Length(str);
  if(slen>0)then
    Stream.Write(Pointer(str)^,slen);

  Stream.Write(wCaretReturn,Sizeof(wCaretReturn));
  Result:=slen;
end;
function  WritelnString(Stream:TStream;const str:PChar):Integer;
var
  slen:Int32;
begin
  slen:=StrLen(str);
  if(slen>0)then
    Stream.Write(Pointer(str)^,slen);

  Stream.Write(wCaretReturn,Sizeof(wCaretReturn));
  Result:=slen;
end;

function WriteChar(Stream:TStream;ch:Char;RepCount:Integer):Integer;
var
  Count,cbBuf:Integer;
  Buffer:array[0..63] of Char;
begin
  Count:=RepCount;
  FillChar(Buffer,sizeof(Buffer),ch);
  while(Count>0)do begin
    if(Count<=Length(Buffer))then cbBuf:=Count
    else cbBuf:=Length(Buffer);
    Stream.Write(Buffer,cbBuf);
    Dec(Count,cbBuf);
  end;
  Result:=RepCount;
end;
function WriteInteger(Stream:TStream;IntValue:Int32;RepCount:Integer):Integer;
var
  Count,cbBuf:Integer;
  Buffer:array[0..63] of Int32;
begin
  Count:=RepCount;
  Fill_32b(Buffer,Length(Buffer),IntValue);
  while(Count>0)do begin
    if(Count<=Length(Buffer))then cbBuf:=Count
    else cbBuf:=Length(Buffer);
    Stream.Write(Buffer,cbBuf*sizeof(Int32));
    Dec(Count,cbBuf);
  end;
  Result:=RepCount;
end;

{ TMemStream }
destructor TMemStream.Destroy;
begin
  HoldSize:=0;
  inherited;
end;
procedure TMemStream.Reset;
begin
  HoldSize:=Size;
  Clear;
end;
function TMemStream.Realloc(var NewCapacity: Integer): Pointer;
begin
  if(NewCapacity<HoldSize)then NewCapacity:=HoldSize;
  Result:=inherited Realloc(NewCapacity);
end;
procedure TMemStream.SetHoldSize(const Value: Integer);
begin
  Assert(Value>=0);
  FHoldSize:=Value;
  if(Value>Capacity)then Capacity:=Value;
end;


function TMemStream.ReadChar:Char;
begin
  ReadBuffer(Result,sizeof(Char));
end;
function TMemStream.WriteChar(ch:Char):Integer;
begin
  Write(ch,sizeof(char));
  Result:=1;
end;
function TMemStream.WriteChar(ch:Char;RepCount:Integer):Integer;
var
  Buffer:Pointer;
begin
  if(RepCount<=0)then begin
    Result:=0;Exit;
  end;
  if(Size<Position+RepCount)then Size:=Position+RepCount;
  
  Buffer:=Pointer(uInt32(Memory)+uInt32(Position));
  FillChar(Buffer^,RepCount,ch);
  Position:=Position+RepCount;
  Result:=RepCount;
end;
function TMemStream.ReadInteger:Int32;
begin
  ReadBuffer(Result,sizeof(Int32));
end;
function TMemStream.WriteInteger(IntValue:Int32):Integer;
begin
  Write(IntValue,sizeof(Int32));
  Result:=1;
end;
function TMemStream.WriteInteger(IntValue:Int32;RepCount:Integer):Integer;
var
  Count:Integer;
  Buffer:Pointer;
begin
  if(RepCount<=0)then begin
    Result:=0;Exit;
  end;
  Count:=RepCount*sizeof(Int32);
  if(Size<Position+Count)then Size:=Position+Count;

  Buffer:=Pointer(uInt32(Memory)+uInt32(Position));
  Fill_32b(Buffer,RepCount,IntValue);
  Result:=RepCount;
end;

function TMemStream.SkipString():Integer;
begin
  Result:=ShareLib.SkipString(Self);
end;
function TMemStream.ReadString():string;
begin
  Result:=ShareLib.ReadString(Self);
end;
function TMemStream.ReadString(str:PChar):Integer;
begin
  Result:=ShareLib.ReadString(Self,str);
end;
function TMemStream.WriteString(const str:string):Integer;
begin
  Result:=ShareLib.WriteString(Self,str);
end;
function TMemStream.WriteString(const str:PChar):Integer;
begin
  Result:=ShareLib.WriteString(Self,str);
end;
function TMemStream.WriteStrData(const str:string):Integer;
var
  slen:Integer;
begin
  slen:=Length(str);
  if(slen>0)then
    Write(Pointer(str)^,slen);
  Result:=slen;
end;
function TMemStream.WriteStrData(const str:PChar):Integer;
var
  slen:Integer;
begin
  slen:=StrLen(str);
  if(slen>0)then
    Write(Pointer(str)^,slen);
  Result:=slen;
end;
function TMemStream.CopyString(Source:TStream):Integer;
var
  slen:Int32;
begin
  Source.ReadBuffer(slen,sizeof(Int32));
  WriteInteger(slen);
  if(slen>0)then begin
    if(Size<Position+slen)then Size:=Position+slen;
    Source.Read(GetCurrent^,slen);
    MoveForth(slen);
  end;
  Result:=slen;
end;
function TMemStream.CopyStrData(Source:TStream):Integer;
var
  slen:Int32;
begin
  Source.ReadBuffer(slen,sizeof(Int32));
  //WriteInteger(slen);
  if(slen>0)then begin
    if(Size<Position+slen)then Size:=Position+slen;
    Source.Read(GetCurrent^,slen);
    MoveForth(slen);
  end;
  Result:=slen;
end;

function TMemStream.ReadlnString():string;
begin
  Result:=ShareLib.ReadlnString(Self);
end;
function TMemStream.ReadlnString(var str:string):Integer;
begin
  Result:=ShareLib.ReadlnString(Self,str);
end;
function TMemStream.WritelnString(const str:string):Integer;
begin
  Result:=ShareLib.WritelnString(Self,str);
end;
function TMemStream.WritelnString(const str:PChar):Integer;
begin
  Result:=ShareLib.WritelnString(Self,str);
end;

function TMemStream.Eof:Boolean;
begin
  Result:=Position>=Size;
end;
function TMemStream.MoveFirst:Integer;
begin
  Result:=Seek(0,soFromBeginning);
end;
function TMemStream.MoveLast:Integer;
begin
  Result:=Seek(0,soFromEnd);
end; 
function TMemStream.MoveTo(Position:Integer):Integer;
begin
  Result:=Seek(Position,soFromBeginning);
end;
function TMemStream.MoveBack(Step:Integer):Integer;
begin
  Result:=Seek(-Step,soFromCurrent);
end;
function TMemStream.MoveForth(Step:Integer):Integer;
begin
  Result:=Seek(Step,soFromCurrent);
end;

function TMemStream.Insert(Count:Integer;InsData:Pointer):Integer;
begin
  Result:=0;
  if(Position<0)or(Count<=0)then Exit;

  if(Position>Size)then MoveLast;
  Size:=Size+Count;
  if(Position+Count<Size)then 
    System.Move(Pointer(uInt32(Memory)+uInt32(Position))^,
                Pointer(uInt32(Memory)+uInt32(Position+Count))^,
                Size-Count-Position);
  
  if(InsData=nil)then
    Result:=WriteChar(#0,Count)
  else
    Result:=Write(InsData^,Count);
end;
function TMemStream.Delete(Count:Integer):Integer;
begin
  Result:=0;
  if(Position<0)or(Count<0)then Exit;

  if(Position>=Size)then MoveLast;
  if(Position+Count>Size)then Count:=Size-Position;
  if(Count=0)then Exit;

  if(Position+Count<Size)then 
    System.Move(Pointer(uInt32(Memory)+uInt32(Position+Count))^,
                Pointer(uInt32(Memory)+uInt32(Position))^,
                Size-Count-Position);
  Size:=Size-Count;
  Result:=Count;
end;
function TMemStream.GetCurrent:PChar;
begin
  Result:=Pointer(uInt32(Memory)+uInt32(Position));
end;
function TMemStream.GetDataString():string;
begin
  SetString(Result,PChar(Memory),Size);
end;

{function QueryModuleInfomation(const MainFormClass:string;InfoType:Integer):string;
var
  SL:Integer;
  Buffer:Pointer;
  hWnd,hMem:THandle;
begin
  hWnd:=FindWindow(PChar(MainFormClass),nil);
  if(hWnd=0)then Result:=''
  else begin
    hMem:=GlobalAlloc(GMEM_ZEROINIT or GMEM_SHARE,MAX_PATH);
    try
      Buffer:=GlobalLock(hMem);
      try
        Integer(Buffer^):=InfoType;
      finally
        GlobalUnlock(hMem);
      end;
      SL:=SendMessage(hWnd,WM_QueryModuleInfomation,GetCurrentProcessID(),hMem);
      Buffer:=GlobalLock(hMem);
      try
        SetString(Result,PChar(Buffer),SL);
      finally
        GlobalUnlock(hMem);
      end;
    finally
      GlobalFree(hMem);
    end;
  end;
end;

procedure ProcMsg_QueryModuleInfomation(var Message:TMessage);
var
  Buffer:Pointer;
  BufSize:Integer;
  hSrc,hMem:THandle;
begin
  hSrc:=OpenProcess(PROCESS_DUP_HANDLE,False,Message.WParam);
  try
    if(not DuplicateHandle(hSrc,Message.LParam,
          GetCurrentProcess(),@hMem,0,True,DUPLICATE_SAME_ACCESS))
    then Exit;           //????

    Buffer:=GlobalLock(hMem);
    try
      BufSize:=GlobalSize(hMem);
      case Integer(Buffer^) of
        qmiModuleName:
          begin
            StrPLCopy(Buffer,Application.ExeName,BufSize);
            Message.Result:=MinInteger(Length(Application.ExeName),BufSize);
          end;
        qmiModuleTitle:
          begin
            StrPLCopy(Buffer,Application.Title,BufSize);
            Message.Result:=MinInteger(Length(Application.Title),BufSize);
          end;
      end;
    finally
      GlobalUnlock(hMem);
      CloseHandle(hMem);
    end;
  finally
    CloseHandle(hSrc);
  end;
end;}

function ScrollTabControl(Ctrl:TTabControl;Delta:SmallInt):SmallInt;
var
  Wnd: HWND;
  Pos: SmallInt;
  Range: TSmallPoint;
  Notify: NMHDR;
begin
  Result:=-1;
  Wnd:=FindWindowEx(Ctrl.Handle, 0, 'msctls_updown32', nil);
  if Wnd <> 0 then
  begin
    Pos:=LongRec(SendMessage(Wnd, UDM_GETPOS, 0, 0)).Lo+Delta;
    Range:=TSmallPoint(SendMessage(Wnd, UDM_GETRANGE, 0, 0));
    if(Pos<Range.y)then Pos:=Range.y;
    if(Pos>Range.x)then Pos:=Range.x;
    SendMessage(Wnd, UDM_SETPOS, 0, MakeLong(Pos, 0));

    Notify.hwndFrom:=Wnd;
    Notify.idFrom:=1;
    Notify.code:=UDN_DELTAPOS;
    SendMessage(Ctrl.Handle,WM_NOTIFY,1,LongInt(@Notify));
    SendMessage(Ctrl.Handle,WM_HSCROLL,MakeLong(SB_THUMBPOSITION,Pos),0);
    Result:=Pos;
  end;
end;

end.
