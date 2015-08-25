unit ShareWin;
{$Define AlwaysShareRead}
interface

uses Windows,Messages,SysUtils,Classes,ShareSys, Comctrls, Forms;

const           
  HEAP_NO_SERIALIZE               =$00000001;
  HEAP_GROWABLE                   =$00000002;
  HEAP_GENERATE_EXCEPTIONS        =$00000004;
  HEAP_ZERO_MEMORY                =$00000008;
  HEAP_REALLOC_IN_PLACE_ONLY      =$00000010;
  HEAP_TAIL_CHECKING_ENABLED      =$00000020;
  HEAP_FREE_CHECKING_ENABLED      =$00000040;
  HEAP_DISABLE_COALESCE_ON_FREE   =$00000080;
  HEAP_CREATE_ALIGN_16            =$00010000;
  HEAP_CREATE_ENABLE_TRACING      =$00020000;
  HEAP_MAXIMUM_TAG                =$0FFF;
  HEAP_PSEUDO_TAG_FLAG            =$8000;
  HEAP_TAG_SHIFT                  =16;

//
//    WARNING: these procs and TCommon32bArray can only be used
//  in main thread because HEAP_NO_SERIALIZE is speciafied in every call
var
  DynamicArrayHeap:THandle;
  function  DAHeapAlloc(dwBytes:u_Int32):Pointer;
  function  DAHeapReAlloc(lpMem:Pointer;dwBytes:u_Int32):Pointer;
  function  DAHeapFree(lpMem:Pointer):BOOL;
  procedure DAHeapCompact();
  function  DAHeapAlloc0(dwBytes:u_Int32):Pointer; //zero mem
  function  DAHeapReAlloc0(lpMem:Pointer;dwBytes:u_Int32):Pointer;
  
type
  TCommon32bArray=class(T32bArray)
  protected
    procedure ReAlloc(var MemPtr:Pointer;newCapacity:Integer);override;
  public
    procedure LoadFromStream(Stream:TStream);
    procedure SaveToStream(Stream:TStream);
  end;

const
  faReadOnlyBitMask       =$01;
  faExclusiveBitMask      =$02;
  faTemporaryBitMask      =$04;
  faAutoDeleteBitMask     =$08;
  faTrucExistingBitMask   =$10;
  faRandomAccessBitMask   =$20;
  faSequentialScanBitMask =$40;
  MightErrorReturn        =$FFFFFFFF;
type
  EWin32FileError=class(EOSError);
  TWin32File=class(TComponent)
  private
    FFileHandle:THandle;
    FSize:DWord;
    FSizeHigh:DWord;
    FPosition:DWord;
    FPositionHigh:DWord;
    FOnBeforeOpen: TNotifyEvent;
    FOnAfterOpen: TNotifyEvent;
    FOnBeforeClose: TNotifyEvent;
    FOnAfterClose: TNotifyEvent;
    function GetEof:Boolean;
    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetFileName(const Value: string);

    function GetReadOnly: Boolean;
    procedure SetReadOnly(const Value: Boolean);
    function GetExclusive: Boolean;
    procedure SetExclusive(const Value: Boolean);
    function GetTemporary: Boolean;
    procedure SetTemporary(const Value: Boolean);
    function GetAutoDelete: Boolean;
    procedure SetAutoDelete(const Value: Boolean);
    function GetTrucExisting: Boolean;
    procedure SetTrucExisting(const Value: Boolean);
    function GetRandomAccess: Boolean;
    procedure SetRandomAccess(const Value: Boolean);
    function GetSequentialScan: Boolean;
    procedure SetSequentialScan(const Value: Boolean);
  protected
    FFileName:string;
    FFileAttributes:Integer;
    procedure FileReadError;
    procedure FileWriteError;
    procedure FileSeekError;
    procedure CheckFileOpened;
    procedure CheckFileWritable;
    procedure BeforeOpen;dynamic;
    procedure AfterOpen;dynamic;
    procedure BeforeClose;dynamic;
    procedure AfterClose;dynamic;

    property FileHandle:THandle read FFileHandle;
  public
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;

    procedure AssignFileProp(Source:TWin32File);
    procedure OpenFile(const FileName:string='';ReadOnly:Boolean=False;Exclusive:Boolean=True);
    procedure Open;
    procedure Close;
    procedure DeleteFile();
    procedure DeleteAndFree();

    procedure ReadBuffer(var Buffer;Count:DWord);
    procedure WriteBuffer(const Buffer;Count:DWord);
    function  Read(var Buffer;Count:DWord):DWord;virtual;
    function  Write(const Buffer;Count:DWord):DWord;virtual;
    function  Seek(Ofs,OfsHigh:LongInt;Origin:Word):DWord;virtual;
    procedure SetSize(NewSize,NewSizeHigh:DWord);virtual;
    procedure FlushBuffers();

    function  ReadInteger:LongInt;
    procedure WriteInteger(const IntValue:LongInt);
    function  ReadString:string;
    procedure WriteString(const str:string);
    procedure SkipString;
    function  Readln:string;overload;
    function  Readln(var str:string):Integer;overload;
    procedure Writeln(const str:string);overload;
    procedure Writeln(const str:PChar);overload;
    procedure WriteChar(ch:char;repCount:Integer=1);

    property Eof:Boolean read GetEof;
    property Size:DWord read FSize;
    property SizeHigh:DWord read FSizeHigh;
    property Position:DWord read FPosition;
    property PositionHigh:DWord read FPositionHigh;
  published
    property Active:Boolean read GetActive write SetActive default False;
    property FileName:string read FFileName write SetFileName;

    property ReadOnly:Boolean read GetReadOnly write SetReadOnly default False;
    property Exclusive:Boolean read GetExclusive write SetExclusive default True;
    property Temporary:Boolean read GetTemporary write SetTemporary default False;
    property AutoDelete:Boolean read GetAutoDelete write SetAutoDelete default False;
    property TrucExisting:Boolean read GetTrucExisting write SetTrucExisting default False;
    property RandomAccess:Boolean read GetRandomAccess write SetRandomAccess default False;
    property SequentialScan:Boolean read GetSequentialScan write SetSequentialScan default False;

    property OnBeforeOpen:TNotifyEvent read FOnBeforeOpen write FOnBeforeOpen;
    property OnAfterOpen:TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property OnBeforeClose:TNotifyEvent read FOnBeforeClose write FOnBeforeClose;
    property OnAfterClose:TNotifyEvent read FOnAfterClose write FOnAfterClose;
  end;
  Win32FileClass=class of TWin32File;

const
  Win32FileBufferSize=$10000;
type
  TBufferedWin32File=class(TWin32File)
  private
    FBuffer:Pointer;
    FBufferSize:DWord;
    FFilePos,FFilePosHigh:DWord;
    FDirtyBytes,FBytesInBuf,FFilePtrInc:DWord;
    function GetCountOf64KBuf: DWord;
    procedure SetCountOf64KBuf(Value: DWord);
  protected
    procedure AfterOpen;override;
    procedure BeforeClose;override;
    procedure SetBufferPosition(newPos,newPosHigh:DWord);
  public
    constructor Create(AOwner:TComponent);override;
    destructor  Destroy;override;

    function  Seek(Ofs,OfsHigh:LongInt;Origin:Word):DWord;override;
    function  Read(var Buffer;Count:DWord):DWord;override;
    function  Write(const Buffer;Count:DWord):DWord;override;
    procedure SetSize(NewSize,NewSizeHigh:DWord);override;

    procedure FlushBuffer;
  published
    property CountOf64KBuf:DWord read GetCountOf64KBuf write SetCountOf64KBuf default 1;
  end;

  TWin32FileStream=class(TStream)
  private
    FWin32File:TWin32File;
    function GetFileName: string;
    function GetHandle: THandle;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
  public
    constructor Create;overload;
    constructor Create(const FileName: string; Mode: Word);overload;
    destructor Destroy; override;
    
    property Handle:THandle read GetHandle;
    property FileName:string read GetFileName;
    property Win32File:TWin32File read FWin32File;
  end;

procedure CheckFileHandle(hFile:THandle;const ErrorInfo:string);
function  Win32Check(RetVal:BOOL;const ErrorMsg:string='系统调用失败'): BOOL;
procedure LastWin32CallCheck(const ErrorMsg:string);

function FileExists(const FileName:string):Boolean;
function FileCanOpen(const FileName:string;ReadOnly:Boolean=False):Boolean;

function  sReadln(Stream:TWin32File;var str:string):Integer;

{ file search }
type
  TFileProcessProc=procedure (const FileName:string);
  TFileProcessMethod=procedure (const FileName:string)of object;

procedure AddPathSpr(var Path:string);
function DeleteTailPathSpr(const Path:string):string;

procedure ForAllFile(SearchDir:string;FileProcessProc:TFileProcessProc;
            DoSubDir:Boolean=False;const FileNameMask:string='*.*');overload;
procedure ForAllFile(SearchDir:string;FileProcessProc:TFileProcessMethod;
            DoSubDir:Boolean=False;const FileNameMask:string='*.*');overload;
procedure ListDirFiles(SearchDir:string;FileList:TStrings;
            ListPath:Boolean=True;DoSubDir:Boolean=False;const FileNameMask:string='*.*');
procedure ListSubDirectories(SearchDir:string;DirList:TStrings;ListPath:Boolean=False;Recurse:Boolean=False);
procedure EmptyDirectory(Directory:string;IncludeSubDir:Boolean);
procedure RemoveDirectory(const Directory:string);
procedure CopyDirectory(SrcDir,DstDir:string;OverWrite:Boolean=True;DoSubDir:Boolean=True;ProgressBar:TProgressBar=nil);
function  CalcDirectorySize(Directory:string;DoSubDir:Boolean=True;const FileNameMask:string='*.*'):Cardinal;

function WaitFor(Handle:THandle): Boolean;
function ShellAndWait(const sAppName,sCmdLine:string;Minimize:Boolean):Integer;

var
  SystemPageSize:DWord=4096;
  SystemMaxSectorSize:DWord=512;
  SystemAllocGranularity:DWord=$00010000;

type
  PVirtualBlockInfo=^TVirtualBlockInfo;
  TVirtualBlockInfo=packed record
    MemoryPtr   :Pointer;
    ReserveSize :u_Int32;
    CommitSize  :u_Int32;
    UsedSize    :u_Int32;
  end;
const
  VirtualBlockInfoSize=sizeof(TVirtualBlockInfo);
type
{
  TMiniMemAllocator designed for alloc large number of small
  memory blocks at a time, and free them at last at the same time.

  this will gain more efficiency, and will save some of
  system's memory spending.

  WARNING:
  it cannot be re entered. use it in a simple thread!
}
  TMiniMemAllocator=class//(TSharedObject)
  private
    //FAllocBy:Integer;
    FVBlockCount:Integer;
    FVBlocksInfo:array of TVirtualBlockInfo;
  protected
    procedure CommitMore(NeedSize:uInt32;pMemInfo:PVirtualBlockInfo);
    procedure ReserveAndCommit(NeedSize:uInt32);

    property VBlockCount:Integer read FVBlockCount;
  public
    //constructor Create(AllocBy:Integer=4);
    destructor Destroy;override;

    function  AllocMem(NeedSize:uInt32):Pointer;
    procedure FreeAll;

    //property AllocBy:Integer read FAllocBy;
  end;

implementation

uses Consts,RTLConsts;

const
  sCR=#13#10;
  wCR:Word=$0A0D;

procedure AddPathSpr(var Path:string);
begin
  if(AnsiLastChar(Path)<>Nil)and(AnsiLastChar(Path)^<>'\')then
    Path:=Path+'\'
end;

function DeleteTailPathSpr(const Path:string):string;
begin
  if(AnsiLastChar(Path)<>Nil)and(AnsiLastChar(Path)^='\')then
    Result:=Copy(Path,1,Length(Path)-1)
  else Result:=Path;
end;

function  sReadln(Stream:TWin32File;var str:string):Integer;
const wCR=13;lf=10;BufSize=256;
var
  i,c,sp,p,ss:Integer;
  Buffer:array[0..BufSize] of BYTE;
begin
  Result:=0;SetLength(str,Result);

  sp:=Stream.Position;ss:=Stream.Size;
  p:=sp;
  while(p<ss)do begin
    c:=BufSize;
    if(p+c>ss)then c:=ss-p;
    Stream.ReadBuffer(Buffer,c);
    Buffer[c]:=wCR;
    i:=0;while(Buffer[i]<>wCR)do Inc(i);
    if(i<c)then begin
      if(i<c-1)then begin
        Inc(i);
        if(Buffer[i]=lf)then Inc(i);
        Stream.Seek(p+i,0,sofromBeginning);
        c:=i-2;
        if(c>0)then begin
          SetLength(str,Result+c);
          System.Move(Buffer,Pointer(@str[Result+1])^,c);
          Inc(Result,c);
        end;
        Exit;
      end else begin
        p:=p+c;
        c:=i-1;
        if(c>0)then begin
          SetLength(str,Result+c);
          System.Move(Buffer,Pointer(@str[Result+1])^,c);
          Inc(Result,c);
        end;
        if(p<ss)then begin
          Stream.ReadBuffer(Buffer,1);
          if(Buffer[0]<>lf)then Stream.Seek(-1,0,soFromCurrent);
        end;
      end;
      Exit;
    end else begin                  
      Inc(p,i);//i=c
      SetLength(str,p-sp);
      System.Move(Buffer,Pointer(@str[Result+1])^,i);
      Inc(Result,i);
      {if(p=ss)then begin
        Result:=0;str:='';
      end;}
    end;
  end;
end;

{ TWin32File }

constructor TWin32File.Create(AOwner:TComponent);
begin
  inherited;
  Exclusive:=True;
end;

destructor TWin32File.Destroy;
begin
  Close;
  inherited;
end;

function TWin32File.GetReadOnly: Boolean;
begin
  Result:=FFileAttributes and faReadOnlyBitMask<>0;
end;

procedure TWin32File.SetReadOnly(const Value: Boolean);
begin
  Assert(not Active);
  if(Value)then begin
    AutoDelete:=False;TrucExisting:=False;
    FFileAttributes:=FFileAttributes or faReadOnlyBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faReadOnlyBitMask;
  end;
end;

function TWin32File.GetExclusive: Boolean;
begin
  Result:=FFileAttributes and faExclusiveBitMask<>0;
end;

procedure TWin32File.SetExclusive(const Value: Boolean);
begin
  Assert(not Active);
  if(Value)then begin
    FFileAttributes:=FFileAttributes or faExclusiveBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faExclusiveBitMask;
  end;
end;

function TWin32File.GetTrucExisting: Boolean;
begin
  Result:=FFileAttributes and faTrucExistingBitMask<>0;
end;

procedure TWin32File.SetTrucExisting(const Value: Boolean);
begin
  Assert(not Active);
  if(Value)then begin
    ReadOnly:=False;
    FFileAttributes:=FFileAttributes or faTrucExistingBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faTrucExistingBitMask;
  end;
end;

function TWin32File.GetRandomAccess: Boolean;
begin
  Result:=FFileAttributes and faRandomAccessBitMask<>0;
end;

procedure TWin32File.SetRandomAccess(const Value: Boolean);
begin
  Assert(not Active);
  if(Value)then begin
    SequentialScan:=False;
    FFileAttributes:=FFileAttributes or faRandomAccessBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faRandomAccessBitMask;
  end;
end;

function TWin32File.GetSequentialScan: Boolean;
begin
  Result:=FFileAttributes and faSequentialScanBitMask<>0;
end;

procedure TWin32File.SetSequentialScan(const Value: Boolean);
begin
  Assert(not Active);

  if(Value)then begin
    RandomAccess:=False;
    FFileAttributes:=FFileAttributes or faSequentialScanBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faSequentialScanBitMask;
  end;
end;

function TWin32File.GetTemporary: Boolean;
begin
  Result:=FFileAttributes and faTemporaryBitMask<>0;
end;

procedure TWin32File.SetTemporary(const Value: Boolean);
begin
  Assert(not Active);
  if(Value)then begin
    FFileAttributes:=FFileAttributes or faTemporaryBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faTemporaryBitMask;
  end;
end;

function TWin32File.GetAutoDelete: Boolean;
begin
  Result:=FFileAttributes and faAutoDeleteBitMask<>0;
end;

procedure TWin32File.SetAutoDelete(const Value: Boolean);
begin
  Assert(not Active);
  if(Value)then begin
    ReadOnly:=False;
    FFileAttributes:=FFileAttributes or faAutoDeleteBitMask
  end else begin
    FFileAttributes:=FFileAttributes and not faAutoDeleteBitMask;
  end;
end;

procedure TWin32File.SetFileName(const Value: string);
begin
  Assert(not Active);
  FFileName:=Value;
end;

function TWin32File.GetActive: Boolean;
begin
  Result:=FFileHandle<>0;
end;

procedure TWin32File.AssignFileProp(Source:TWin32File);
begin
  if(Source<>nil)then begin
    FileName:=Source.FileName;
    FFileAttributes:=Source.FFileAttributes;
    OnBeforeOpen:=Source.OnBeforeOpen;
    OnAfterOpen:=Source.OnAfterOpen;
    OnBeforeClose:=Source.OnBeforeClose;
    OnAfterClose:=Source.OnAfterClose;
  end;
end;

procedure TWin32File.SetActive(const Value: Boolean);
begin
  if(Value)and(FFileHandle=0)then Open
  else if(not Value)and(FFileHandle<>0)then Close;
end;

procedure TWin32File.BeforeOpen;
begin
  if(Assigned(OnBeforeOpen))then OnBeforeOpen(Self);
end;

procedure TWin32File.AfterOpen;
begin
  if(Assigned(OnAfterOpen))then OnAfterOpen(Self);
end;

procedure TWin32File.OpenFile(const FileName: string; ReadOnly,
  Exclusive: Boolean);
begin
  if(Active)then
    raise EWin32FileError.CreateFmt('文件 %s 已经打开',[FileName]);
  FFileName:=FileName;
  Self.ReadOnly:=ReadOnly;
  Self.Exclusive:=Exclusive;
  Open;
end;

procedure TWin32File.Open;
const
  AccessModes:array[Boolean] of DWord=(GENERIC_READ or GENERIC_WRITE,GENERIC_READ);
  ShareModes:array[Boolean]of DWord=(FILE_SHARE_READ,{$IFDEF AlwaysShareRead}FILE_SHARE_READ{$ELSE}0{$ENDIF});
  CreationFlags:array[Boolean,Boolean]of DWord=
    ((OPEN_ALWAYS,OPEN_EXISTING),(Create_ALWAYS,OPEN_EXISTING));
  RSeekFlags:array[Boolean]of DWord=(0,FILE_FLAG_RANDOM_ACCESS);
  SSeekFlags:array[Boolean]of DWord=(0,FILE_FLAG_SEQUENTIAL_SCAN);
  TempFlags:array[Boolean]of DWord=(0,FILE_ATTRIBUTE_TEMPORARY);
  DeleteFlags:array[Boolean]of DWord=(0,FILE_FLAG_DELETE_ON_CLOSE);
begin
  if(Active)then Exit;
  if(FileName='')then
    raise EWin32FileError.Create('文件名没有指定');
  if(ReadOnly)and(not FileExists(FileName))then
    raise EWin32FileError.CreateFmt('文件 %s 不存在',[FileName]);

  BeforeOpen;
  
  FSize:=0;FSizeHigh:=0;
  FPosition:=0;FPositionHigh:=0;
  FFileHandle:=CreateFile(PChar(FileName),AccessModes[ReadOnly],
    ShareModes[Exclusive],nil,CreationFlags[TrucExisting,ReadOnly],
    FILE_ATTRIBUTE_NORMAL
      or TempFlags[Temporary] or DeleteFlags[AutoDelete]
      or RSeekFlags[RandomAccess] or SSeekFlags[SequentialScan],
    0);
  if(FFileHandle=INVALID_HANDLE_VALUE)then FFileHandle:=0;
  if(FFileHandle=0)then
    LastWin32CallCheck(Format('打开文件 %s 错误',[FileName]));
  try
    FSize:=GetFileSize(FFileHandle,@FSizeHigh);
    if(FSize=MightErrorReturn)then
      LastWin32CallCheck(Format('获取文件 %s 大小错误',[FileName]));
  except
    CloseHandle(FFileHandle);
    FFileHandle:=0;
    raise ;
  end;

  AfterOpen;
end;

procedure TWin32File.BeforeClose;
begin
  if(Assigned(OnBeforeClose))then OnBeforeClose(Self);
end;

procedure TWin32File.AfterClose;
begin
  if(Assigned(OnAfterClose))then OnAfterClose(Self);
end;

procedure TWin32File.Close;
var
  hFile:THandle;
begin
  if(not Active)then Exit;
  BeforeClose();

  hFile:=FFileHandle;FFileHandle:=0;
  if(CloseHandle(hFile)=FALSE)then
    LastWin32CallCheck(Format('关闭文件 %s 错误',[FileName]));

  AfterClose();
end;

procedure TWin32File.DeleteFile();
begin
  if(Active)then
    raise EWin32FileError.CreateFmt('文件 %s 已经打开',[FileName]);
  if(FileName<>'')then Windows.DeleteFile(PChar(FileName));
end;

procedure TWin32File.DeleteAndFree();
begin
  if(Self=nil)then Exit;
  Close();
  DeleteFile();
  Destroy;
end;

function TWin32File.GetEof: Boolean;
begin
  Result:=(FPositionHigh>FSizeHigh)or
    ((FPositionHigh=FSizeHigh)and(FPosition>=FSize));
end;

procedure TWin32File.SetSize(NewSize,NewSizeHigh: DWord);
begin
  Seek(NewSize,NewSizeHigh,FILE_BEGIN);
  if(SetEndOfFile(FFileHandle)=FALSE)then
    LastWin32CallCheck(Format('设置文件 %s 大小错误',[FileName]));
  FSize:=NewSize;FSizeHigh:=NewSizeHigh;
end;

procedure TWin32File.FileReadError;
begin
  LastWin32CallCheck(Format('读文件 %s 错误',[FileName]));
end;

procedure TWin32File.FileWriteError;
begin
  LastWin32CallCheck(Format('写文件 %s 错误',[FileName]));
end;

procedure TWin32File.FileSeekError;
begin
  LastWin32CallCheck(Format('移动文件 %s 指针错误',[FileName]));
end;

procedure TWin32File.CheckFileOpened;
begin
  if(not Active)then
    raise EWin32FileError.CreateFmt('文件 %s 没有打开',[FileName]);
end;

procedure TWin32File.CheckFileWritable;
begin
  if(ReadOnly)then
    raise EWin32FileError.CreateFmt('文件 %s 以只读方式打开，不能写',[FileName]);
end;

function TWin32File.Seek(Ofs,OfsHigh:LongInt;Origin:Word): DWord;
var
  newPos,newPosHigh:DWord;
begin
  CheckFileOpened;

  case Origin of
    FILE_BEGIN:
      begin
        newPos:=Ofs;newPosHigh:=OfsHigh;
      end;
    FILE_CURRENT:
      asm
          MOV   ECX,Self
          MOV   EAX,[ECX].FPosition
          MOV   EDX,[ECX].FPositionHigh
          ADD   EAX,Ofs
          ADC   EDX,OfsHigh
          MOV   newPos,EAX
          MOV   newPosHigh,EDX
      end;
    FILE_END:
      asm
          MOV   ECX,Self
          MOV   EAX,[ECX].FSize
          MOV   EDX,[ECX].FSizeHigh
          ADD   EAX,Ofs
          ADC   EDX,OfsHigh
          MOV   newPos,EAX
          MOV   newPosHigh,EDX
      end;
    else raise EWin32FileError.Create('参数错误');
  end;
  if(FPosition<>newPos)or(FPositionHigh<>newPosHigh)then begin
    if(MightErrorReturn=SetFilePointer(FFileHandle,Ofs,@OfsHigh,Origin))
    then FileSeekError;

    FPosition:=newPos;FPositionHigh:=newPosHigh;
  end;
  Result:=FPosition;
end;

procedure TWin32File.ReadBuffer(var Buffer;Count:DWord);
begin
  if(Count<>0)and(Read(Buffer,Count)<>Count)then
    raise EWin32FileError.CreateFmt('读文件 %s 长度不对',[FileName]);
end;

procedure TWin32File.WriteBuffer(const Buffer;Count:DWord);
begin
  if(Count<>0)and(Write(Buffer,Count)<>Count)then
    raise EWin32FileError.CreateFmt('写文件 %s 长度不对',[FileName]);
end;

function TWin32File.Read(var Buffer; Count: DWord): DWord;
begin
  CheckFileOpened;

  if(not ReadFile(FFileHandle,Buffer,Count,Result,nil))then
        FileReadError;
  asm
    MOV ECX,Self
    MOV EAX,[ECX].FPosition
    MOV EDX,[ECX].FPositionHigh
    ADD EAX,Result
    ADC EDX,0
    MOV [ECX].FPosition,EAX
    MOV [ECX].FPositionHigh,EDX
  end;
end;

function TWin32File.Write(const Buffer; Count: DWord): DWord;
begin
  CheckFileOpened;
  CheckFileWritable;

  if(not WriteFile(FFileHandle,Buffer,Count,Result,nil))then
        FileWriteError;
  asm
    MOV ECX,Self
    MOV EAX,[ECX].FPosition
    MOV EDX,[ECX].FPositionHigh
    ADD EAX,Result
    ADC EDX,0
    MOV [ECX].FPosition,EAX
    MOV [ECX].FPositionHigh,EDX
  end;
  if(FPositionHigh>FSizeHigh)or((FPositionHigh=FSizeHigh)
        and(FPosition>FSize))then begin
    FSize:=FPosition;
    FSizeHigh:=FPositionHigh;
  end;
end;

procedure TWin32File.FlushBuffers();
begin
  FlushFileBuffers(FileHandle);
end;

function TWin32File.ReadInteger: LongInt;
begin
  ReadBuffer(Result,sizeof(LongInt));
end;

procedure TWin32File.WriteInteger(const IntValue: Integer);
begin
  WriteBuffer(IntValue,sizeof(LongInt));
end;

function TWin32File.ReadString: string;
var
  sLen:LongInt;
begin
  sLen:=ReadInteger;
  if(sLen>0)then begin
    SetString(Result,nil,sLen);
    ReadBuffer(Pointer(Result)^,sLen);
  end else
    Result:='';
end;

procedure TWin32File.WriteString(const str: string);
var
  sLen:LongInt;
begin
  sLen:=Length(str);
  WriteInteger(sLen);
  if(sLen>0)then begin
    WriteBuffer(Pointer(str)^,sLen);
  end;
end;

procedure TWin32File.SkipString;
var
  sLen:LongInt;
begin
  sLen:=ReadInteger;
  if(sLen>0)then begin
    Seek(sLen,0,FILE_CURRENT);
  end;
end;

function  TWin32File.Readln:string;
begin
  Readln(Result);
end;

function  TWin32File.Readln(var str:string):Integer;
begin
  //Result:=;
  //raise EWin32FileError.Create('not finished');
  Result:=ShareWin.sReadln(Self,str);
end;

procedure TWin32File.Writeln(const str: PChar);
var
  sLen:LongInt;
begin
  sLen:=StrLen(str);
  if(sLen>0)then Write(str^,sLen);
  Write(wCR,Sizeof(wCR));
end;

procedure TWin32File.Writeln(const str: string);
begin
  if(str<>'')then
    Write(Pointer(str)^,Length(str));
  Write(wCR,Sizeof(wCR));
end;

procedure TWin32File.WriteChar(ch:char;repCount:Integer=1);
var
  wc:Integer;
  Buf:array[0..63] of char;
begin
  if(repCount>sizeof(buf))then wc:=sizeof(buf) else wc:=repCount;
  FillChar(Buf,wc,ch);
  while(repCount>0)do begin
    if(repCount>sizeof(buf))then wc:=sizeof(buf) else wc:=repCount;
    Write(Buf,wc);
    Dec(repCount,wc);
  end;
end;

{ TBufferedWin32File }

constructor TBufferedWin32File.Create(AOwner:TComponent);
begin
  inherited;
  CountOf64KBuf:=1;
end;

destructor  TBufferedWin32File.Destroy;
var
  pBuf:Pointer;
begin
  if(FBuffer<>nil)then begin
    pBuf:=FBUffer;FBuffer:=nil;
    if(VirtualFree(pBuf,0,MEM_DECOMMIT or MEM_RELEASE)=FALSE)then
        LastWin32CallCheck('释放缓冲区异常');
  end;
  inherited;
end;

function TBufferedWin32File.GetCountOf64KBuf: DWord;
begin
  Result:=FBufferSize div Win32FileBufferSize;
end;

procedure TBufferedWin32File.SetCountOf64KBuf(Value: DWord);
var
  pBuf:Pointer;
begin
  Assert(not Active);
  if(Value=0)or(Value=CountOf64KBuf)then Exit;
  if(Value>1024)then Value:=1024;//16M
  FBufferSize:=Value*Win32FileBufferSize;
  if(FBuffer<>nil)then begin
    pBuf:=FBUffer;FBuffer:=nil;
    if(VirtualFree(pBuf,0,MEM_DECOMMIT or MEM_RELEASE)=FALSE)then
        LastWin32CallCheck('释放缓冲区异常');
  end;
  FBuffer:=VirtualAlloc(nil,FBufferSize,MEM_RESERVE or MEM_COMMIT,PAGE_READWRITE);
  if(FBuffer=nil)then LastWin32CallCheck('无法分配缓冲区');
end;

procedure TBufferedWin32File.SetSize(NewSize, NewSizeHigh: DWord);
begin
  FlushBuffer;
  inherited;
end;

procedure TBufferedWin32File.AfterOpen;
begin
  FDirtyBytes:=0;FFilePosHigh:=0;FFilePos:=FBufferSize;
  SetBufferPosition(0,0);
end;

procedure TBufferedWin32File.BeforeClose;
begin
  FlushBuffer;
end;

procedure TBufferedWin32File.SetBufferPosition(newPos,newPosHigh:DWord);
var
  cbToRead:DWord;
begin
  FlushBuffer;

  newPos:=(newPos+Win32FileBufferSize-1)and not Win32FileBufferSize;
  if(FFilePos<>newPos)or(FFilePosHigh<>newPosHigh)then begin
    if(MightErrorReturn=SetFilePointer(FFileHandle,newPos,@newPosHigh,FILE_BEGIN))
    then FileSeekError;
    FFilePos:=newPos;FFilePosHigh:=newPosHigh;
  end;
  cbToRead:=FSize-newPos;
  if(cbToRead>FBufferSize)or(FSizeHigh>FFilePosHigh)then cbToRead:=FBufferSize;
  if(not ReadFile(FFileHandle,FBuffer^,cbToRead,FFilePtrInc,nil))then
      FileReadError;
  FBytesInBuf:=FFilePtrInc;
  asm
      MOV ECX,Self
      MOV EAX,[ECX].FFilePos
      MOV EDX,[ECX].FFilePosHigh
      ADD EAX,[ECX].FFilePtrInc
      ADC EDX,0
      MOV [ECX].FFilePos,EAX
      MOV [ECX].FFilePosHigh,EDX
  end;
end;

procedure TBufferedWin32File.FlushBuffer;
begin
  if(FDirtyBytes=0)then Exit;
  asm
      MOV ECX,Self
      MOV EAX,[ECX].FFilePos
      MOV EDX,[ECX].FFilePosHigh
      SUB EAX,[ECX].FFilePtrInc
      SBB EDX,0
      MOV [ECX].FFilePos,EAX
      MOV [ECX].FFilePosHigh,EDX
  end;
  if(MightErrorReturn=SetFilePointer(FFileHandle,FFilePos,@FFilePosHigh,FILE_BEGIN))
  then FileSeekError;
  if(not WriteFile(FFileHandle,FBuffer^,FDirtyBytes,FFilePtrInc,nil))then
    FileWriteError;
  asm
      MOV ECX,Self
      MOV EAX,[ECX].FFilePos
      MOV EDX,[ECX].FFilePosHigh
      ADD EAX,[ECX].FFilePtrInc
      ADC EDX,0
      MOV [ECX].FFilePos,EAX
      MOV [ECX].FFilePosHigh,EDX
  end;
  FDirtyBytes:=0;
end;

function  TBufferedWin32File.Seek(Ofs,OfsHigh:LongInt;Origin:Word):DWord;
begin
  CheckFileOpened;
  
  case Origin of
    FILE_BEGIN:
      begin
        FPosition:=Ofs;FPositionHigh:=OfsHigh;
      end;
    FILE_CURRENT:
      asm
          MOV   ECX,Self
          MOV   EAX,[ECX].FPosition
          MOV   EDX,[ECX].FPositionHigh
          ADD   EAX,Ofs
          ADC   EDX,OfsHigh
          MOV   [ECX].FPosition,EAX
          MOV   [ECX].FPositionHigh,EDX
      end;
    FILE_END:
      asm
          MOV   EAX,[ECX].FSize
          MOV   EDX,[ECX].FSizeHigh
          ADD   EAX,Ofs
          ADC   EDX,OfsHigh
          MOV   [ECX].FPosition,EAX
          MOV   [ECX].FPositionHigh,EDX
      end;
    else raise EWin32FileError.Create('参数错误');
  end;
  Result:=FPosition;
end;

function TBufferedWin32File.Read(var Buffer;Count:DWord): DWord;
var
  p:Pointer;
begin
  CheckFileOpened;

  raise EWin32FileError.Create('not finished');
  if(FPositionHigh>FSizeHigh)then Count:=0
  else if(FPositionHigh=FSizeHigh)then begin
    if(FPosition>=FSize)then Count:=0
    else if(FSize-FPosition>Count)then Count:=FSize-FPosition;
  end;
  Result:=Count;
  if(Result=0)then Exit;
  if(FPositionHigh=FFilePosHigh)and
      (FPosition+Count<FFilePos-FFilePtrInc+FBytesInBuf)and
      (FPosition>=FFilePos-FFilePtrInc)then begin
    p:=Pointer(DWord(FBuffer)+FPosition-FFilePos+FFilePtrInc);
    System.Move(p^,Buffer,Count);
    asm
      MOV ECX,Self
      MOV EAX,[ECX].FPosition
      MOV EDX,[ECX].FPositionHigh
      ADD EAX,Result
      ADC EDX,0
      MOV [ECX].FPosition,EAX
      MOV [ECX].FPositionHigh,EDX
    end;
  end else begin

  end;
end;

function TBufferedWin32File.Write(const Buffer; Count: DWord): DWord;
begin
  CheckFileOpened;
  CheckFileWritable;

  raise EWin32FileError.Create('not finished');
  Result:=Count;

end;

{ TWin32FileStream }

constructor TWin32FileStream.Create;
begin
  inherited Create();
  FWin32File:=TWin32File.Create(nil);
end;

constructor TWin32FileStream.Create(const FileName: string; Mode: Word);
begin
  inherited Create();
  FWin32File:=TWin32File.Create(nil);

  if(Mode=fmCreate)then begin
    Win32File.ReadOnly:=False;
    Win32File.Exclusive:=True;
    Win32File.TrucExisting:=True;
  end else begin
    Win32File.ReadOnly:=Mode and (fmOpenWrite or fmOpenReadWrite)=0;
    Win32File.Exclusive:=Mode and (fmShareExclusive or fmShareDenyWrite or fmShareDenyRead)<>0;
    Win32File.TrucExisting:=False;
  end;
  
  if(FileName<>'')then begin
    Win32File.FileName:=FileName;
    Win32File.Open;
  end;
end;

destructor TWin32FileStream.Destroy;
begin
  Win32File.Free;
  inherited;
end;

function TWin32FileStream.GetFileName: string;
begin
  Result:=Win32File.FileName;
end;

function TWin32FileStream.GetHandle: THandle;
begin
  Result:=Win32File.FileHandle;
end;

function TWin32FileStream.Read(var Buffer; Count: Integer): Longint;
begin
  if(Count>0)then
    Result:=Win32File.Read(Buffer,Count)
  else Result:=0;
end;

function TWin32FileStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Result:=Win32File.Seek(Offset,0,Origin)
end;

function TWin32FileStream.Write(const Buffer; Count: Integer): Longint;
begin
  if(Count>0)then
    Result:=Win32File.Write(Buffer,Count)
  else Result:=0;
end;

procedure CheckFileHandle(hFile:THandle;const ErrorInfo:string);
var
  LastError: DWORD;
  Error: EOSError;
begin
  if(hFile=0)or(hFile=INVALID_HANDLE_VALUE)then begin
    LastError := GetLastError;
    Error:=EOSError.CreateFmt('%s%s错误号：%d%s错误信息：%s',
        [ErrorInfo,sCR,LastError,sCR,SysErrorMessage(LastError)]);
    Error.ErrorCode:=LastError;
    raise Error;
  end;
end;

function Win32Check(RetVal:BOOL;const ErrorMsg:string): BOOL;
var
  LastError: DWORD;
  Error: EOSError;
begin
  if not RetVal then begin
    LastError:=GetLastError;
    Error:=EOSError.CreateFmt('%s%s错误号：%d%s错误信息：%s',
        [ErrorMsg,sCR,LastError,sCR,SysErrorMessage(LastError)]);
    Error.ErrorCode:=LastError;
    raise Error;
  end;
  Result := RetVal;
end;

procedure LastWin32CallCheck(const ErrorMsg:string);
var
  LastError: DWORD;
  Error: EOSError;
begin
  LastError:=GetLastError;
  if(LastError=ERROR_SUCCESS)then Exit;
  Error:=EOSError.CreateFmt('%s%s错误号：%d%s错误信息：%s',
      [ErrorMsg,sCR,LastError,sCR,SysErrorMessage(LastError)]);
  Error.ErrorCode:=LastError;
  raise Error;
end;

function FileExists(const FileName:string):Boolean;
var
  hFind:THandle;
  FindData:_Win32_Find_Data;
begin
  hFind:=Windows.FindFirstFile(PChar(FileName),FindData);
  Result:=hFind<>Invalid_Handle_Value;
  if(Result)then Windows.FindClose(hFind);
  if(Result)and(FindData.dwFileAttributes and faDirectory
    =faDirectory)then Result:=False;
end;

function FileCanOpen(const FileName:string;ReadOnly:Boolean):Boolean;
const
  OpenFlags:array[Boolean] of DWord=(OF_READ or OF_WRITE,OF_READ);
var
  hFile:THandle;
  OD:OFSTRUCT;
begin
  Result:=FileExists(FileName);
  if(Result)then begin
    FillChar(OD,sizeof(OFSTRUCT),0);
    OD.cBytes:=sizeof(OFSTRUCT);
    hFile:=Windows.OpenFile(PChar(FileName),OD,OpenFlags[ReadOnly]);
    Result:=(hFile<>HFILE_ERROR)and(hFile<>0);
    if(Result)then CloseHandle(hFile);
  end;
end;

function AddTailPathSpr(const aPath:string):string;
var
  pLast:PChar;
begin
  pLast:=AnsiLastChar(aPath);
  if(pLast<>nil)and(pLast^<>'\')then
    Result:=aPath+'\'
  else
    Result:=aPath;
end;

function DelTailPathSpr(const aPath:string):string;
var
  pLast:PChar;
begin
  pLast:=AnsiLastChar(aPath);
  if(pLast=nil)or(pLast^<>'\')then Result:=aPath
  else Result:=Copy(aPath,1,Length(aPath)-1{Single Byte});
end;

function WaitFor(Handle:THandle): Boolean;
var
  Msg: TMsg;
  Ret: DWORD;
begin
  if GetCurrentThreadID = MainThreadID then
  begin
    repeat
      Ret := MsgWaitForMultipleObjects(1,Handle,False,3000,QS_PAINT);
      if(Ret=WAIT_TIMEOUT)or(Ret=WAIT_OBJECT_0+1)then
      begin
        while(PeekMessage(Msg,0,0,0,PM_REMOVE))do
        begin
          if(Msg.message=WM_PAINT)then
          begin
            TranslateMessage(Msg);
            DispatchMessage(Msg);
          end;
        end;
      end else
        Break;
    until False;
    Result := Ret <> MAXDWORD;
  end else
  begin
    Ret := WaitForSingleObject(Handle, INFINITE);
    Result := Ret <> WAIT_FAILED;
  end;
end;

function ShellAndWait(const sAppName,sCmdLine:string;Minimize:Boolean):Integer;
var
  I,P,L:Integer;
  ExitCode:DWord;
  AppDir:string;
  App,Cmd,Dir:PChar;
  StartInfo:STARTUPINFO;
  AppInfo:PROCESS_INFORMATION;
begin
  FillChar(StartInfo,sizeof(StartInfo),0);
  StartInfo.cb:=sizeof(StartInfo);
  if(Minimize)then
    StartInfo.wShowWindow:=SW_MINIMIZE;
  FillChar(AppInfo,sizeof(AppInfo),0);

  AppDir:='';
  if(sAppName='')then App:=nil
  else begin
    App:=PChar(sAppName);
    AppDir:=ExtractFilePath(sAppName);
  end;
  if(sCmdLine='')then Cmd:=nil else
  begin
    Cmd:=PChar(sCmdLine);
    I:=1;L:=Length(sCmdLine);
    while(I<=L)and(sCmdLine[I]=' ')do Inc(I);
    if(I<L)then
    begin
      if(sCmdLine[I]='"')then
      begin
        P:=I+1;
        while(I<=L)and(sCmdLine[I]<>'"')do Inc(I);
      end else begin
        P:=I;
        while(I<=L)and(sCmdLine[I]<>' ')do Inc(I);
      end;
      AppDir:=ExtractFilePath(Copy(sCmdLine,P,I-P));
    end;
  end;
  if(AppDir='')then Dir:=nil else Dir:=PChar(AppDir);
  Win32Check(CreateProcess(App,Cmd,
        nil,nil,False,NORMAL_PRIORITY_CLASS,
        nil,Dir,StartInfo,AppInfo),'创建进程');
  try
    CloseHandle(AppInfo.hThread);
    
    SetLastError(0);
    if not WaitFor(AppInfo.hProcess) then
      LastWin32CallCheck('等待进程结束');

    while(GetExitCodeProcess(AppInfo.hProcess,ExitCode))
        and(ExitCode=STILL_ACTIVE)do
      Sleep(1);//Application.ProcessMessages;
    Result:=ExitCode;
  finally
    CloseHandle(AppInfo.hProcess);
  end;
end;

procedure ForAllFile(SearchDir:string;FileProcessProc:TFileProcessProc;
            DoSubDir:Boolean=False;const FileNameMask:string='*.*');
var
  Name:string;
  hFind:THandle;
  FindData:TWin32FindData;
begin
  SearchDir:=AddTailPathSpr(SearchDir);

  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(SearchDir+FileNameMask),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=0)then
        FileProcessProc(SearchDir+Name);
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;

  if(not DoSubDir)then Exit;
  
  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(SearchDir+'*.*'),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY<>0)then begin
        if(Name<>'.')and(Name<>'..')then
          ForAllFile(SearchDir+Name,FileProcessProc,True,FileNameMask);
      end;
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;
end;

procedure ForAllFile(SearchDir:string;FileProcessProc:TFileProcessMethod;
            DoSubDir:Boolean=False;const FileNameMask:string='*.*');
var
  Name:string;
  hFind:THandle;
  FindData:TWin32FindData;
begin
  SearchDir:=AddTailPathSpr(SearchDir);

  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(SearchDir+FileNameMask),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=0)then
        FileProcessProc(SearchDir+Name);
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;

  if(not DoSubDir)then Exit;
  
  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(SearchDir+'*.*'),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY<>0)then begin
        if(Name<>'.')and(Name<>'..')then
          ForAllFile(SearchDir+Name,FileProcessProc,True,FileNameMask);
      end;
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;
end;

type
  TFileListor=class
  private
    FCopyStart:Integer;
    FFileList:TStrings;
  public
    procedure AddFileToList(const FileName:string);
  end;

procedure TFileListor.AddFileToList(const FileName:string);
begin
  if(FCopyStart=0)then FFileList.Add(FileName)
  else FFileList.Add(Copy(FileName,FCopyStart,MaxInt));
end;

procedure ListDirFiles(SearchDir:string;FileList:TStrings;
            ListPath:Boolean;DoSubDir:Boolean;const FileNameMask:string);
var
  Listor:TFileListor;
begin
  FileList.BeginUpdate;
  try
    FileList.Clear;
    Listor:=TFileListor.Create();
    try
      Listor.FFileList:=FileList;
      if(not ListPath)then begin
        SearchDir:=AddTailPathSpr(SearchDir);
        Listor.FCopyStart:=Length(SearchDir)+1;
      end;
      
      ForAllFile(SearchDir,Listor.AddFileToList,DoSubDir,FileNameMask);
    finally
      Listor.Free;
    end;
  finally
    FileList.EndUpdate;
  end;
end;

procedure ListSubDirectories(SearchDir:string;DirList:TStrings;ListPath:Boolean;Recurse:Boolean);
var
  Name:string;
  hFind:THandle;
  FindData:TWin32FindData;
begin
  SearchDir:=AddTailPathSpr(SearchDir);
  DirList.BeginUpdate;
  try
    FillChar(FindData,sizeof(FindData),0);
    hFind:=FindFirstFile(PChar(SearchDir+'*.*'),FindData);
    if(hFind<>INVALID_HANDLE_VALUE)then
    begin
      repeat
        Name:=StrPas(FindData.cFileName);
        if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY<>0)
            and(Name<>'.')and(Name<>'..')then
        begin
          if(ListPath)then DirList.Add(SearchDir+Name) else DirList.Add(Name);
          if(Recurse)then ListSubDirectories(SearchDir+Name,DirList,ListPath,True);
        end;
      until (not FindNextFile(hFind,FindData));
      Windows.FindClose(hFind);
    end;
  finally
    DirList.EndUpdate;
  end;
end;

function DirectoryExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(Dir: string): Boolean;
begin
  Result := True;
  if Length(Dir) = 0 then
    raise Exception.Create('创建目录失败');
  Dir := ExcludeTrailingBackslash(Dir);
  if (Length(Dir) < 3) or DirectoryExists(Dir)
    or (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
  Result := ForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
end;

procedure EmptyDirectory(Directory:string;IncludeSubDir:Boolean);
var
  Name:string;
  hFind:THandle;
  FindData:TWin32FindData;
begin
  if(Directory='')then Exit;
  Directory:=DelTailPathSpr(Directory);

  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(Directory+'\*.*'),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY<>0)then begin
        if(IncludeSubDir)and(Name<>'.')and(Name<>'..')then
          RemoveDirectory(Directory+'\'+Name);
      end else
        DeleteFile(Directory+'\'+Name);
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;
end;

procedure RemoveDirectory(const Directory:string);
begin
  EmptyDirectory(Directory,True);
  RemoveDir(Directory);
end;

procedure CopyDirectory(SrcDir,DstDir:string;OverWrite:Boolean=True;DoSubDir:Boolean=True;ProgressBar:TProgressBar=nil);
var
  I:Integer;
  CpyList:TStringList;
begin
  CpyList:=TStringList.Create;
  try
    AddPathSpr(SrcDir);
    AddPathSpr(DstDir);
    ForceDirectories(DstDir);
    if(DoSubDir)then begin
      ListSubDirectories(SrcDir,CpyList);
      for I:=0 to CpyList.Count-1 do
        CopyDirectory(SrcDir+CpyList[I],DstDir+CpyList[I],OverWrite,DoSubDir,ProgressBar);
    end;
    ListDirFiles(SrcDir,CpyList,False);
    if ProgressBar <> nil then
    begin
      ProgressBar.Max := CpyList.Count;
      ProgressBar.Position := 0;
    end;
    for I:=0 to CpyList.Count-1 do
    begin
      CopyFile(PChar(SrcDir+CpyList[I]),PChar(DstDir+CpyList[I]),not OverWrite);
      if ProgressBar <> nil then
      begin
        ProgressBar.Position := ProgressBar.Position + 1;
        Application.ProcessMessages;
      end;
    end;
  finally
    CpyList.Free;
  end;
end;

function  CalcDirectorySize(Directory:string;DoSubDir:Boolean;const FileNameMask:string):Cardinal;
var
  Name:string;
  hFind:THandle;
  FindData:TWin32FindData;
begin
  Result:=0;
  Directory:=AddTailPathSpr(Directory);

  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(Directory+FileNameMask),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=0)then
        Result:=Result+FindData.nFileSizeLow;
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;

  if(not DoSubDir)then Exit;
  
  FillChar(FindData,sizeof(FindData),0);
  hFind:=FindFirstFile(PChar(Directory+'*.*'),FindData);
  if(hFind<>INVALID_HANDLE_VALUE)then begin
    repeat
      Name:=StrPas(FindData.cFileName);
      if(FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY<>0)then begin
        if(Name<>'.')and(Name<>'..')then
          Result:=Result+CalcDirectorySize(Directory+Name,True,FileNameMask);
      end;
    until (not FindNextFile(hFind,FindData));
    Windows.FindClose(hFind);
  end;
end;

function DAHeapAlloc(dwBytes:u_Int32):Pointer;
begin
  Result:=HeapAlloc(
            DynamicArrayHeap,
            HEAP_GENERATE_EXCEPTIONS,
            dwBytes);
end;

function DAHeapAlloc0(dwBytes:u_Int32):Pointer;
begin
  Result:=HeapAlloc(
            DynamicArrayHeap,
            HEAP_GENERATE_EXCEPTIONS or HEAP_ZERO_MEMORY,
            dwBytes);
end;

function DAHeapReAlloc(lpMem:Pointer;dwBytes:u_Int32):Pointer;
begin
  Result:=HeapReAlloc(
            DynamicArrayHeap,
            HEAP_GENERATE_EXCEPTIONS,
            lpMem,
            dwBytes);
end;

function DAHeapReAlloc0(lpMem:Pointer;dwBytes:u_Int32):Pointer;
begin
  Result:=HeapReAlloc(
            DynamicArrayHeap,
            HEAP_GENERATE_EXCEPTIONS or HEAP_ZERO_MEMORY,
            lpMem,
            dwBytes);
end;

function DAHeapFree(lpMem:Pointer):BOOL;
begin
  Result:=HeapFree(DynamicArrayHeap,0,lpMem);
end;

procedure DAHeapCompact();
begin
  HeapCompact(DynamicArrayHeap,0);
end;

 
{ TCommon32bArray }

procedure TCommon32bArray.LoadFromStream(Stream:TStream);
var
  dwCount,dwCountH:u_Int32;
begin
  Stream.ReadBuffer(dwCount,sizeof(dwCount));
  Stream.ReadBuffer(dwCountH,sizeof(dwCountH));
  if(u_Int32(Capacity)<dwCount)then Clear();
  AdjustCount(dwCount,False);
  Stream.ReadBuffer(Memory^,DataSize);
end;

procedure TCommon32bArray.SaveToStream(Stream: TStream);
var
  dwCount:u_Int32;
begin
  dwCount:=Count;
  Stream.WriteBuffer(dwCount,sizeof(dwCount));
  dwCount:=0;
  Stream.WriteBuffer(dwCount,sizeof(dwCount));
  Stream.WriteBuffer(Memory^,DataSize);
end;

procedure TCommon32bArray.ReAlloc(var MemPtr:Pointer;newCapacity:Integer);
begin
  //Assert(newCapacity>0);
  if(Capacity=0)then begin
    MemPtr:=DAHeapAlloc(newCapacity shl 2);
  end else if(newCapacity=0)then begin
    DAHeapFree(MemPtr);MemPtr:=nil;
  end else begin
    MemPtr:=DAHeapReAlloc(MemPtr,newCapacity shl 2);
  end;
end;

{ TMiniMemAllocator }

const
  sVirtualAllocFailed='虚拟内存分配失败！';
  sVirtualFreeFailed='虚拟内存释放失败！';

function TMiniMemAllocator.AllocMem(NeedSize:uInt32):Pointer;
asm
        PUSH    EBX
        PUSH    ESI
        PUSH    EDI
        MOV     EBX,EAX
        {MOV     EAX,[EBX].FAllocBy
        DEC     EAX}
        MOV     EAX,$3     ////FAllocBy////

        ADD     EDX,EAX
        NOT     EAX
        AND     EAX,EDX
        JZ      @@Exit          //Zero Size,return nil
        MOV     EDX,EAX         //NeedSize,in EDX

        MOV     ESI,[EBX].FVBlocksInfo
        MOV     ECX,[EBX].FVBlockCount
@@search:
        DEC     ECX
        JL      @@ReserveAndCommit
        MOV     EAX,[ESI].TVirtualBlockInfo.UsedSize
        ADD     EAX,EDX
        CMP     EAX,[ESI].TVirtualBlockInfo.CommitSize
        JBE     @@DoAlloc
        CMP     EAX,[ESI].TVirtualBlockInfo.ReserveSize
        JBE     @@CommitMore
        ADD     ESI,VirtualBlockInfoSize
        JMP     @@search

@@ReserveAndCommit:
        PUSH    EDX             //NeedSize
        MOV     EAX,EBX
        CALL    ReserveAndCommit
        POP     EDX             //NeedSize
        MOV     ESI,[EBX].FVBlocksInfo
        MOV     ECX,[EBX].FVBlockCount
        DEC     ECX
        IMUL    ECX,VirtualBlockInfoSize
        ADD     ESI,ECX
        JMP     @@DoAlloc
@@CommitMore:
        PUSH    EDX             //NeedSize
        MOV     ECX,ESI
        MOV     EAX,EBX
        CALL    CommitMore
        POP     EDX             //NeedSize
@@DoAlloc:
        MOV     EAX,[ESI].TVirtualBlockInfo.UsedSize
        ADD     EAX,[ESI].TVirtualBlockInfo.MemoryPtr
        ADD     [ESI].TVirtualBlockInfo.UsedSize,EDX
@@Exit:
        POP     EDI
        POP     ESI
        POP     EBX
end;

{constructor TMiniMemAllocator.Create(AllocBy:u_Int32);
begin
  inherited Create;

  FAllocBy:=AllocBy;
  if(FAllocBy<=sizeof(Integer))then FAllocBy:=sizeof(Integer)
  else begin
    FAllocBy:=1 shl Trunc(Ln(FAllocBy)/Ln(2)+0.99999999);
    if(FAllocBy>sizeof(Integer) shl 2)then
            FAllocBy:=sizeof(Integer) shl 2;
  end;
end;
}
destructor TMiniMemAllocator.Destroy;
begin
  FreeAll();
  inherited;
end;

procedure TMiniMemAllocator.FreeAll;
var
  i:Integer;
begin
  try
    for i:=0 to FVBlockCount-1 do begin
      with FVBlocksInfo[i] do begin
        {$IFOPT D+}
        Win32Check(VirtualFree(MemoryPtr,CommitSize,MEM_DECOMMIT),sVirtualFreeFailed);
        Win32Check(VirtualFree(MemoryPtr,0,MEM_RELEASE),sVirtualFreeFailed);
        {$ELSE}
        VirtualFree(MemoryPtr,CommitSize,MEM_DECOMMIT);
        VirtualFree(MemoryPtr,0,MEM_RELEASE);
        {$ENDIF}
      end;
    end;
    SetLength(FVBlocksInfo,0);
  finally
    FVBlockCount:=0;
  end;
end;

procedure TMiniMemAllocator.CommitMore(NeedSize:uInt32;pMemInfo:PVirtualBlockInfo);
var
  lpMem,lpResult:Pointer;
begin
  with pMemInfo^ do begin
    NeedSize:=NeedSize-CommitSize+UsedSize;
    NeedSize:=(NeedSize+SystemPageSize-1) and not (SystemPageSize-1);
    {$IFOPT D+}
    Assert(CommitSize+NeedSize<=ReserveSize);
    {$ENDIF}
    lpMem:=Pointer(DWord(MemoryPtr)+CommitSize);
    lpResult:=VirtualAlloc(lpMem,NeedSize,MEM_COMMIT,PAGE_EXECUTE_READWRITE);
    if(lpResult=nil)then LastWin32CallCheck(sVirtualAllocFailed);
    {$IFOPT D+}
    Assert(lpResult=lpMem);
    {$ENDIF}
    CommitSize:=CommitSize+NeedSize;
  end;
end;

procedure TMiniMemAllocator.ReserveAndCommit(NeedSize:uInt32);
var
  RSize,CSize:Integer;
  lpMem,lpResult:PChar;
begin
  RSize:=((NeedSize+SystemAllocGranularity-1) div SystemAllocGranularity)*SystemAllocGranularity;
  CSize:=(NeedSize+SystemPageSize-1) and not (SystemPageSize-1);

  lpMem:=VirtualAlloc(nil,RSize,MEM_RESERVE,PAGE_EXECUTE_READWRITE);
  if(lpMem=nil)then LastWin32CallCheck(sVirtualAllocFailed);
  try
    lpResult:=VirtualAlloc(lpMem,CSize,MEM_COMMIT,PAGE_EXECUTE_READWRITE);
    if(lpResult=nil)then LastWin32CallCheck(sVirtualAllocFailed);
    {$IFOPT D+}
    Assert(lpResult=lpMem);
    {$ENDIF}
  except
    VirtualFree(lpMem,0,MEM_RELEASE);
  end;

  if(VBlockCount and $3=0)then begin
    SetLength(FVBlocksInfo,VBlockCount+4);
  end;
  with FVBlocksInfo[VBlockCount] do begin
    MemoryPtr:=lpMem;
    ReserveSize:=RSize;
    CommitSize:=CSize;
    UsedSize:=0;
  end;
  Inc(FVBlockCount);
end;

procedure ExtractSysInfo;
var
  SectorSize:DWord;
  R1,R2,R3:DWord;
  DriveChar: Char;
  DriveNum: Integer;
  DriveBits: set of 0..25;
  SysInfo:SYSTEM_INFO;
begin
  GetSystemInfo(SysInfo);
  SystemPageSize:=SysInfo.dwPageSize;
  SystemAllocGranularity:=SysInfo.dwAllocationGranularity;

  SystemMaxSectorSize:=0;
  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do begin
    if not (DriveNum in DriveBits) then Continue;
    DriveChar := Char(DriveNum + Ord('a'));
    if(GetDriveType(PChar(DriveChar + ':\'))=DRIVE_FIXED)then begin
      GetDiskFreeSpace(PChar(DriveChar + ':\'),R1,SectorSize,R2,R3);
      if(SectorSize>SystemMaxSectorSize)then SystemMaxSectorSize:=SectorSize;
    end;
  end;
end;

initialization
  ExtractSysInfo;
  DynamicArrayHeap:=HeapCreate(HEAP_GENERATE_EXCEPTIONS,4096,0);

finalization
  HeapDestroy(DynamicArrayHeap);

end.
