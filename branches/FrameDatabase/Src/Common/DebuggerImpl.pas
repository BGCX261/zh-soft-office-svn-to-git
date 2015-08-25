unit DebuggerImpl;

interface

uses Classes,SysUtils,Windows,SyncObjs;

type
  TCustomDebugger=class(TComponent)
  private
    FLock:TCriticalSection;
    FLocation:String;
    function GetLocationDirectory: string;
  protected
    procedure Lock;
    procedure UnLock;
    function GetPrefix:string ;virtual;
    procedure WriteDebuger(Operateuser:string;Value:string);overload ;
    procedure WriteDebuger(Value:string);overload;
    property LocationDirectory:string read GetLocationDirectory;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure SetLoggerEnv(Location:string);
    function WriteLineIf(Current:TObject;NetUser:string;IfTrue:Boolean;Value:string):Boolean;
    function WriteLine(Current:TObject;NetUser:string;Value:string):Boolean;
    function WriteIf(Current:TObject;NetUser:string;IfTrue:Boolean;Value:string):Boolean;
    function TraceWarning(Current:TObject;NetUser:string;Value:string):Boolean;
    function TraceError(Current:TObject;NetUser:string;Value:string):Boolean;
    function Write(Current:TObject;NetUser:string;Value:string):Boolean;overload ;
    function Write(Value:string;Current:TObject=nil):Boolean;overload ;
  end;

  TDebugger=class(TCustomDebugger)
  end;




  function Debugger:TCustomDebugger;
implementation

uses Forms;

var
  _Debugger:TCustomDebugger=nil;

  function Debugger:TCustomDebugger;
  begin
    if _Debugger=nil then
      _Debugger:=TDebugger.Create(nil);
    Result:=_Debugger;
  end;

{ TCustomDebugger }

constructor TCustomDebugger.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FLock:=TCriticalSection.Create;
end;

destructor TCustomDebugger.Destroy;
begin
  FLock.Free;
  inherited;
end;



function TCustomDebugger.GetPrefix: string;
begin
  result:=FormatDateTime('YYYY-MM-DD hh:nn:ss:zzz',Now) ;
end;

procedure TCustomDebugger.Lock;
begin
  FLock.Enter;
end;

function TCustomDebugger.TraceError(Current:TObject;NetUser:string;Value: string): Boolean;
begin
  Lock;
  try
    if Current<>nil then
      WriteDebuger(NetUser,Current.ClassName+#9+Value)
    else WriteDebuger(NetUser,Value);
    Result:=True;
  finally
    UnLock;
  end;
end;

function TCustomDebugger.TraceWarning(Current:TObject;NetUser:string;Value: string): Boolean;
begin
  Lock;
  try
    if Current<>nil then
      WriteDebuger(NetUser,Current.ClassName+#9+Value)
    else WriteDebuger(NetUser,Value);
    Result:=True;
  finally
    UnLock;
  end;
end;

procedure TCustomDebugger.UnLock;
begin
  FLock.Leave;
end;

function TCustomDebugger.Write(Current:TObject;NetUser:string;Value: string): Boolean;
begin
  Lock;
  try
    if Current<>nil then
      WriteDebuger(NetUser,Current.ClassName+#9+Value)
    else WriteDebuger(NetUser,Value);
    Result:=True;
  finally
    UnLock;
  end;
end;

procedure TCustomDebugger.WriteDebuger(Operateuser:string;Value: string);
var
  FileS:TextFile;
  strFileName,Buffer:string;
begin
  strFileName:=LocationDirectory+Operateuser+'Logger'+FormatDateTime('YYYYMMDD',Now)+'.log';;
  try
    Buffer:=GetPrefix+Value;
    AssignFile(FileS,strFileName);
    try
      if FileExists(strFileName)then
        Reset(FileS)
      else Rewrite(FileS);
      Append(FileS);
      WriteLn(FileS,Buffer);
    finally
      CloseFile(FileS);
    end;
  except
    on E:Exception do
    begin
    end;
  end;
end;

function TCustomDebugger.Write(Value: string; Current: TObject): Boolean;
begin
  Lock;
  try
    if Current=nil then
      WriteDebuger(Value)
    else
      WriteDebuger(Current.ClassName+#9+Value);
    Result:=True;
  finally
    UnLock;
  end;
end;

procedure TCustomDebugger.WriteDebuger(Value: string);
var
  FileS:TextFile;
  Buffer,FileName:string;
begin
  FileName:=LocationDirectory+'Logger'+FormatDateTime('YYYYMMDD',Now)+'.log';;
  try
    Buffer:=GetPrefix+Value;
    AssignFile(FileS,FileName);
    try
      if FileExists(FileName)then
        Reset(FileS)
      else Rewrite(FileS);
      Append(FileS);
      WriteLn(FileS,Buffer);
    finally
      CloseFile(FileS);
    end;
  except
    on E:Exception do
    begin
    end;
  end;
end;

function TCustomDebugger.WriteIf(Current:TObject;NetUser:string;IfTrue: Boolean; Value: string): Boolean;
begin
  Lock;
  try
    if Current<>nil then
      WriteDebuger(NetUser,Current.ClassName+#9+Value)
    else WriteDebuger(NetUser,Value);
    Result:=True;
  finally
    UnLock;
  end;
end;

function TCustomDebugger.WriteLine(Current:TObject;NetUser:string;Value: string): Boolean;
begin
  Lock;
  try
    if Current<>nil then
      WriteDebuger(NetUser,Current.ClassName+#9+Value)
    else WriteDebuger(NetUser,Value);
    Result:=True;
  finally
    UnLock;
  end;
end;

function TCustomDebugger.WriteLineIf(Current:TObject;NetUser:string;IfTrue: Boolean;
  Value: string): Boolean;
begin
  Lock;
  try
    if Current<>nil then
      WriteDebuger(NetUser,Current.ClassName+#9+Value)
    else WriteDebuger(NetUser,Value);
    Result:=True;
  finally
    UnLock;
  end;
end;


procedure TCustomDebugger.SetLoggerEnv(Location: string);
begin
  FLocation:=Location;
  ForceDirectories(LocationDirectory);
end;

function TCustomDebugger.GetLocationDirectory: string;
begin
  Result:=IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'Logger\';
  if FLocation<>EmptyStr then
    Result:=IncludeTrailingPathDelimiter(FLocation);
  ForceDirectories(Result) ;
end;
{
initialization
  Debugger();
finalization
  if _Debugger<>nil then
    FreeAndNil(_Debugger);
    }
end.

