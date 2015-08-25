unit ShareSys;

interface


uses Windows,SysUtils;
const
  Max16bValue   =$FFFF;
  Max32bValue   =$FFFFFFFF;
  lowWordMask   =$0000FFFF;
  highWordMask  =$FFFF0000;
  uInvalidIndex =Max32bValue;
  BoolTrue      =$1;
  BoolFalse     =$0;
type
  _int8=ShortInt;
  _int16=SmallInt;
  _int32=LongInt;
  u_int8=Byte;
  u_int16=Word;
  u_int32=Cardinal;
  Int32=LongInt;
  uInt32=Cardinal;
  // use exact bits type for all store types, else use system standard

  TBytesArray=array [0..MaxInt shr 1] of Byte;
  PBytesArray=^TBytesArray;

  TShortIntArray=array [0..MaxInt shr 1] of _int8;
  PShortIntArray=^TShortIntArray;
  TWordArray=array [0..MaxInt shr 2] of u_int16;
  PWordArray=^TWordArray;
  TIntegerArray=array [0..MaxInt shr 4] of _int32;
  PIntegerArray=^TIntegerArray;
  TPointerArray=array [0..MaxInt shr 4] of Pointer;
  PPointerArray=^TPointerArray;


  function RevertByte(const IntValue:Integer):Integer;
  function Minu_int(D1,D2:u_int32):u_int32;
  function Maxu_int(D1,D2:u_int32):u_int32;
  function MinInteger(I1,I2:_int32):_int32;
  function MaxInteger(I1,I2:_int32):_int32;

  function MinSingle(const D1,D2:Single):Single;
  function MinSingleV(var D1,D2:Single):Single;
  function MaxSingle(const D1,D2:Single):Single;
  function MaxSingleV(var D1,D2:Single):Single;
  function MinDouble(const D1,D2:Double):Double;
  function MinDoubleV(var D1,D2:Double):Double;
  function MaxDouble(const D1,D2:Double):Double;
  function MaxDoubleV(var D1,D2:Double):Double;
  function MinExtended(const D1,D2:Extended):Extended;
  function MinExtendedV(var D1,D2:Extended):Extended;
  function MaxExtended(const D1,D2:Extended):Extended;
  function MaxExtendedV(var D1,D2:Extended):Extended;

  function DoubleGetExponent(var D{:Double}):Integer;
  function DoubleLikeZero(var D{:Double}):Boolean;

  function CompareDoubleBuffer(P1,P2:Pointer):Integer;
  function CompareCurrencyBuffer(P1,P2:Pointer):Integer;
  function CompareBytesBuffer(P1,P2:Pointer;Count:Integer):Integer;

  procedure CopyDouble(var Src,Dst{:Double});
  procedure XChgDouble(var D1,D2{:Double});
  function CompCopyDouble(var Src,Dst):Boolean;
  function CompCopyString(Src,Dst:Pointer;len:Integer):Boolean;
  function CountBits(BitsValue:Integer):Integer;

  procedure Fill_16b(var Dest;dwCount:u_int32;wValue:u_int16);
  procedure Fill_32b(var Dest;dwCount:u_int32;dwValue:u_int32);

  function Compare_32b(List1,List2:Pointer;dwCount:u_int32):_int32;

  function Get_8b(List:Pointer;dwCount:u_int32;Index:u_int32):u_int8;
  function Get_16b(List:Pointer;dwCount:u_int32;Index:u_int32):u_int16;
  function Get_32b(List:Pointer;dwCount:u_int32;Index:u_int32):u_int32;

  function iGet_8b(List:Pointer;dwCount:u_int32;Index:u_int32):_int8;
  function iGet_16b(List:Pointer;dwCount:u_int32;Index:u_int32):_int16;
  function iGet_32b(List:Pointer;dwCount:u_int32;Index:u_int32):_int32;

  procedure Set_8b(List:Pointer;dwCount:u_int32;Index:u_int32;Value:u_int8);
  procedure Set_16b(List:Pointer;dwCount:u_int32;Index:u_int32;Value:u_int16);
  procedure Set_32b(List:Pointer;dwCount:u_int32;Index:u_int32;Value:u_int32);

  procedure Invert_8b(List:Pointer;dwCount:u_int32);
  procedure Invert_16b(List:Pointer;dwCount:u_int32);
  procedure Invert_32b(List:Pointer;dwCount:u_int32);

  function IndexOf_8b(List:Pointer;dwCount:u_int32;bFind:u_int8):_int32;
  function IndexOf_16b(List:Pointer;dwCount:u_int32;wFind:u_int16):_int32;
  function IndexOf_32b(List:Pointer;dwCount:u_int32;dwFind:u_int32):_int32;

  function Find_8b(List:Pointer;dwCount:u_int32;bFind:u_int8;var Index:u_int32):_int32;
  function Find_16b(List:Pointer;dwCount:u_int32;wFind:u_int16;var Index:u_int32):_int32;
  function Find_32b(List:Pointer;dwCount:u_int32;dwFind:u_int32;var Index:u_int32):_int32;

  function iFind_8b(List:Pointer;dwCount:u_int32;bFind:_int8;var Index:u_int32):_int32;
  function iFind_16b(List:Pointer;dwCount:u_int32;iFind:_int16;var Index:u_int32):_int32;
  function iFind_32b(List:Pointer;dwCount:u_int32;lFind:_int32;var Index:u_int32):_int32;

  procedure Move_32b1(List:Pointer;dwCount:u_int32;fromIndex,toIndex:u_int32);
  procedure InsMove_32b(List:Pointer;dwCount:u_int32;Index,Count:u_int32;Value:u_int32);
  procedure DelMove_32b(List:Pointer;dwCount:u_int32;Index,Count:u_int32);
  //procedure MoveList_32b(List:Pointer;dwCount:u_int32;Index1,Index2:u_int32;Count:u_int32);
  //procedure Exchange_32b(List:Pointer;dwCount:u_int32;Index1,Index2:u_int32;Count:u_int32);

  procedure Sort_32b(List:Pointer;dwCount:u_int32);
  procedure QuickSort_32b(List:Pointer;start,stop:u_int32);
  procedure iSort_32b(List:Pointer;dwCount:u_int32);
  procedure iQuickSort_32b(List:Pointer;start,stop:u_int32);
  
  //0:NormalDouble,1:not a number,2:-∞,3+∞
  function _DoubleValueType(pDoubleValue:Pointer):_int32;
  function SingleValueType(var vSingle:Single):_int32;
  function DoubleValueType(var vDouble:Double):_int32;
  function ExtendedValueType(var vExtended:Extended):_int32;

  {  eax,st(0)-->       <--st(0)  }
  procedure _WindDecimal(decimal:Byte);
  function WindDecimalD(const E:Double;Decimal:Byte):Double;
  function WindDecimalE(const E:Extended;Decimal:Byte):Extended;
  procedure WindDecimalD3(var E:Double;Decimal:Byte);
  procedure WindDecimalE3(var E:Extended;Decimal:Byte);

type
  TSharedObject=class(TObject)
  private
    FRefCount: Integer;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
  public
    function AddRef():Integer;
    function Release():Integer;

    property RefCount: Integer read FRefCount;
  end;
  TISharedObject=class(TInterfacedObject)
  public
    function AddRef():Integer;
    function Release():Integer;
  end;

  TExBits=class
  private
    FSize: _int32;
    FBits: Pointer;
    procedure SetSize(Value: _int32);
    procedure SetBit(Index: _int32; Value: Boolean);
    function GetBit(Index: _int32): Boolean;
  public
    destructor Destroy; override;
    procedure Assign(Source:TExBits);
    procedure InvertAll;
    procedure SetAll(SetValue:Boolean);
    function  HasValue(SearchValue:Boolean):Boolean;

    procedure BoolAND(Source:TExBits);
    procedure BoolANDNot(Source:TExBits);
    procedure BoolOR(Source:TExBits);
    procedure BoolXOR(Source:TExBits);

    property Bits[Index: _int32]: Boolean read GetBit write SetBit; default;
    property Size:_int32 read FSize write SetSize;
  end;

  TExtBits=class(TExBits)
  public
    procedure Insert(Index:_int32;Value:Boolean);
    procedure InsertEx(Index,InsCount:_int32;DefaultValue:Boolean=False);
    procedure Delete(Index:_int32);
    procedure DeleteEx(Index:_int32;DelCount:_int32);
    procedure Move(CurIndex, NewIndex: _int32);
    procedure Exchange(Index1,Index2:_int32);
  end;

  T32bArray=class(TSharedObject)
  private
    FCount:Integer;
    FCapacity:Integer;
    FMemory:Pointer;
    procedure SetCount(newCount:Integer);
  protected
    procedure SetCapacity(newCapacity:Integer);
    procedure ReAlloc(var MemPtr:Pointer;newCapacity:Integer);virtual;
  public
    constructor Create(InitCapacity:Integer=0);
    destructor Destroy;override;
  private
    function  GetDataSize():Integer;
    function  GetMemSize():Integer;
    function  GetElemPtr(Index:Integer):Pointer;
    function  GetElems1(Index:Integer):u_int32;
    function  GetElems2(Index:Integer):_int32;
    function  GetElems3(Index:Integer): Pointer;
    function  GetElems4(Index:Integer): TObject;
    procedure SetElems1(Index:Integer;const Value:u_int32);
    procedure SetElems2(Index:Integer;const Value:_int32);
    procedure SetElems3(Index:Integer;const Value:Pointer);
    procedure SetElems4(Index:Integer;const Value:TObject);
    function  GetFirst1():u_int32;
    function  GetFirst2():_int32;
    function  GetFirst3():Pointer;
    procedure SetFirst1(const Value:u_int32);
    procedure SetFirst2(const Value:_int32);
    procedure SetFirst3(const Value:Pointer);
    function  GetLast1():u_int32;
    function  GetLast2():_int32;
    function  GetLast3():Pointer;
    procedure SetLast1(const Value:u_int32);
    procedure SetLast2(const Value:_int32);
    procedure SetLast3(const Value:Pointer);
  public
    procedure Clear(FreeMem:Boolean=True);
    procedure AdjustCount(newCount:Integer;DoZero:Boolean=True);
    procedure AdjustCapacity(newCapacity:Integer);
    procedure FreeMore();

    procedure Add1(const data:u_int32);
    procedure Add2(const data:_int32);
    procedure Add3(const data:Pointer);
    procedure Insert1(Index,Count:Integer;Value:u_int32);
    procedure Insert2(Index,Count:Integer;Value:_int32);
    procedure Insert3(Index,Count:Integer;Value:Pointer);
    procedure Delete(Index,Count:Integer;FreeMore:Boolean=False);

    function  IndexOf1(data:u_int32):Integer;
    function  IndexOf2(data:_int32):Integer;
    function  IndexOf3(data:Pointer):Integer;
    function  InArray1(data:u_int32):Boolean;
    function  InArray2(data:_int32):Boolean;
    function  InArray3(data:Pointer):Boolean;

    function  Search1(start:Integer;data:u_int32):Integer;
    function  Search2(start:Integer;data:_int32):Integer;
    function  Search3(start:Integer;data:Pointer):Integer;

    function  Find1(data:u_int32;var Index:Integer):Boolean;
    function  Find2(data:_int32;var Index:Integer):Boolean;
    function  Find3(data:Pointer;var Index:Integer):Boolean;
    function  sIndexOf1(data:u_int32):Integer;
    function  sIndexOf2(data:_int32):Integer;
    function  sIndexOf3(data:Pointer):Integer;
    function  sInArray1(data:u_int32):Boolean;
    function  sInArray2(data:_int32):Boolean;
    function  sInArray3(data:Pointer):Boolean;
    //FindFirst,FindLast

    function  FindFirst1(data:u_int32;var Index:Integer):Boolean;
    function  FindFirst2(data:_int32;var Index:Integer):Boolean;
    function  FindFirst3(data:Pointer;var Index:Integer):Boolean;

    function  FindLast1(data:u_int32;var Index:Integer):Boolean;
    function  FindLast2(data:_int32;var Index:Integer):Boolean;
    function  FindLast3(data:Pointer;var Index:Integer):Boolean;

    function  sAdd1(Value:u_int32):Integer;
    function  sAdd2(Value:_int32):Integer;
    function  sAdd3(Value:Pointer):Integer;
    function  sAddNoDup1(Value:u_int32):Integer;
    function  sAddNoDup2(Value:_int32):Integer;
    function  sAddNoDup3(Value:Pointer):Integer;

    function  Remove1(Value:u_int32):Integer;
    function  Remove2(Value:_int32):Integer;
    function  Remove3(Value:Pointer):Integer;
    procedure RemoveAll1(Value:u_int32);
    procedure RemoveAll2(Value:_int32);
    procedure RemoveAll3(Value:Pointer);
    function  sRemove1(Value:u_int32):Integer;
    function  sRemove2(Value:_int32):Integer;
    function  sRemove3(Value:Pointer):Integer;

    function  GetMemory(Index:Integer):Pointer;
    //move,exchange
    procedure Move(fromIndex,toIndex:Integer);

    procedure Sort1();
    procedure Sort2();
    procedure Sort3();

    property  Count:Integer read FCount write SetCount;
    property  Capacity:Integer read FCapacity write SetCapacity;
    property  Memory:Pointer read FMemory;
    property  DataSize:Integer read GetDataSize;
    property  MemSize:Integer read GetMemSize;
    property  Elems1[Index:Integer]:u_int32 read GetElems1 write SetElems1;default;
    property  Elems2[Index:Integer]:_int32 read GetElems2 write SetElems2;
    property  Elems3[Index:Integer]:Pointer read GetElems3 write SetElems3;
    property  Elems4[Index:Integer]:TObject read GetElems4 write SetElems4;
    property  ElemPtr[Index:Integer]:Pointer read GetElemPtr;
    property  First1:u_int32 read GetFirst1 write SetFirst1;
    property  First2:_int32 read GetFirst2 write SetFirst2;
    property  First3:Pointer read GetFirst3 write SetFirst3;
    property  Last1:u_int32 read GetLast1 write SetLast1;
    property  Last2:_int32 read GetLast2 write SetLast2;
    property  Last3:Pointer read GetLast3 write SetLast3;
  public
    function  IsEmpty:Boolean;
    procedure Reset(ResetStorage:Boolean=False);

    function  GetTop1():u_int32;
    function  GetTop2():_int32;
    function  GetTop3():Pointer;
    function  GetTop4():TObject;
    function  Pop1():u_int32;
    function  Pop2():_int32;
    function  Pop3():Pointer;
    function  Pop4():TObject;
    procedure Push1(const data:u_int32);
    procedure Push2(const data:_int32);
    procedure Push3(const data:Pointer);
    procedure Push4(const data:TObject);
  public
    procedure Assign(Source:T32bArray);
    function  Compare(Source:T32bArray):Boolean;
    procedure CopyFrom(Source:T32bArray;FromIndex,ToIndex,CopyCount:Integer);

    function  CountDistinctValue:Integer;
    procedure ListDistinctValue(toArr:T32bArray);
    procedure RemoveDuplicateValues;  //will disturb Elems order

    procedure IncElem(Index:Integer);
    procedure DecElem(Index:Integer);
    //IncArray,DecArray,IncArrayIfGE,DecArrayIfGE,RemoveIfGE
    //procedure IncFillArray(StartValue:_int32;IncStep:_int32);overload;
    //procedure IncFillArray(FillStart,FillCount:Integer;StartValue,IncStep:_int32);overload;
    // MakeIntersection(Another:T32bArray;SortFlag:Integer=0{bit 31,1,0});
    // ExcludeArray(Another:T32bArray;SortFlag:Integer=0{bit 31,1,0});
  end;

procedure DebugAssert(Condition:Boolean;const Info:string='');

implementation

procedure DebugAssert(Condition:Boolean;const Info:string);
begin
  {$IFOPT D+}Assert(Condition,Info);{$ENDIF}
end;

function RevertByte(const IntValue:Integer):Integer;
asm
        ROL     AX,8
        ROL     EAX,16
        ROL     AX,8
end;

function Minu_int(D1,D2:u_int32):u_int32;assembler;
asm
    CMP EAX,EDX
    JB @@1{below}
    MOV EAX,EDX
@@1:
end;
function Maxu_int(D1,D2:u_int32):u_int32;assembler;
asm
    CMP EAX,EDX
    JNB @@1
    MOV EAX,EDX
@@1:
end;
function MinInteger(I1,I2:_int32):_int32;assembler;
asm
    CMP EAX,EDX
    JL @@1
    MOV EAX,EDX
@@1:
end;
function MaxInteger(I1,I2:_int32):_int32;assembler;
asm
    CMP EAX,EDX
    JNL @@1{less}
    MOV EAX,EDX
@@1:
end;
function MinSingle(const D1,D2:Single):Single;
asm
        fld     D1
        fld     D2
        fcom
        fwait
        fstsw   AX
        SAHF
        JB      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MinSingleV(var D1,D2:Single):Single;
asm
        fld     u_int32 PTR [EAX]
        fld     u_int32 PTR [EDX]
        fcom
        fwait
        fstsw   AX
        SAHF
        JB      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MaxSingle(const D1,D2:Single):Single;
asm
        fld     D1
        fld     D2
        fcom
        fwait
        fstsw   AX
        SAHF
        JA      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MaxSingleV(var D1,D2:Single):Single;
asm
        fld     u_int32 PTR [EAX]
        fld     u_int32 PTR [EDX]
        fcom
        fwait
        fstsw   AX
        SAHF
        JA      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MinDouble(const D1,D2:Double):Double;
asm
        fld     D1
        fld     D2
        fcom
        fwait
        fstsw   AX
        SAHF
        JB      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MinDoubleV(var D1,D2:Double):Double;
asm
        fld     QWORD PTR [EAX]
        fld     QWORD PTR [EDX]
        fcom
        fwait
        fstsw   AX
        SAHF
        JB      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MaxDouble(const D1,D2:Double):Double;
asm
        fld     D1
        fld     D2
        fcom
        fwait
        fstsw   AX
        SAHF
        JA      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MaxDoubleV(var D1,D2:Double):Double;
asm
        fld     QWORD PTR [EAX]
        fld     QWORD PTR [EDX]
        fcom
        fwait
        fstsw   AX
        SAHF
        JA      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MinExtended(const D1,D2:Extended):Extended;
asm
        fld     D1
        fld     D2
        fcom
        fwait
        fstsw   AX
        SAHF
        JB      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MinExtendedV(var D1,D2:Extended):Extended;
asm
        fld     TBYTE PTR [EAX]
        fld     TBYTE PTR [EDX]
        fcom
        fwait
        fstsw   AX
        SAHF
        JB      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MaxExtended(const D1,D2:Extended):Extended;
asm
        fld     D1
        fld     D2
        fcom
        fwait
        fstsw   AX
        SAHF
        JA      @@1
        fxch
@@1:    fstp    ST(0)
end;
function MaxExtendedV(var D1,D2:Extended):Extended;
asm
        fld     TBYTE PTR [EAX]
        fld     TBYTE PTR [EDX]
        fcom
        fwait
        fstsw   AX
        SAHF
        JA      @@1
        fxch
@@1:    fstp    ST(0)
end;

function DoubleGetExponent(var D{:Double}):Integer;
asm
    MOV     ECX,EAX
    MOV     EAX,[ECX+$4]
    AND     EAX,$7FF00000
    SHR     EAX,20
    SUB     EAX,1023
end;
function DoubleLikeZero(var D{:Double}):Boolean;
begin
  Result:=DoubleGetExponent(D)<-23;//D<0.00000011...
end;

function CompareDoubleBuffer(P1,P2:Pointer):Integer;
asm
        fld     QWORD PTR [EAX]
        fcomp   QWORD PTR [EDX]
        fwait
        fstsw   AX
        SAHF
        MOV     EAX,-1
        JB      @@3
        JE      @@2
@@1:    INC     EAX
@@2:    INC     EAX
@@3:    RET
end;
function CompareCurrencyBuffer(P1,P2:Pointer):Integer;
asm
        fild    QWORD PTR [EDX]
        fild    QWORD PTR [EAX]
        fcompp
        fwait
        fstsw   AX
        SAHF
        MOV     EAX,-1
        JB      @@3
        JE      @@2
@@1:    INC     EAX
@@2:    INC     EAX
@@3:    RET
end;
function CompareBytesBuffer(P1,P2:Pointer;Count:Integer):Integer;
asm
        PUSH    ESI
        MOV     ESI,EAX
        XOR     EAX,EAX
        TEST    ECX,ECX
        JLE     @@3
@@1:
        LODSB
        SUB     AL,[EDX]
        JNZ     @@2
        INC     EDX
        DEC     ECX
        JNZ     @@1
        RET
@@2:
        MOV     AL,1
        JA      @@3
        MOV     EAX,-1
@@3:    RET
end;


procedure CopyDouble(var Src,Dst{:Double});
asm
    MOV ECX,[EAX]
    MOV [EDX],ECX
    MOV ECX,[EAX+$4]
    MOV [EDX+$4],ECX
end;
procedure XChgDouble(var D1,D2{:Double});
asm
    MOV   ECX,[EAX]
    XCHG  [EDX],ECX
    MOV   [EAX],ECX
    MOV   ECX,[EAX+$4]
    XCHG  [EDX+$4],ECX
    MOV   [EAX+$4],ECX
end;
function CompCopyDouble(var Src,Dst):Boolean;
asm
        MOV     ECX,EAX
        MOV     EAX,[ECX]
        CMP     EAX,[EDX]
        JZ      @@2
        MOV     [EDX],EAX
        MOV     EAX,[ECX+$4]
@@1:
        MOV     [EDX+$4],EAX
        MOV     EAX,BoolTrue
        RET
@@2:
        MOV     EAX,[ECX+$4]
        CMP     EAX,[EDX+$4]
        JNZ     @@1
        MOV     EAX,BoolFalse
        RET
end;
function CompCopyString(Src,Dst:Pointer;len:Integer):Boolean;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX

        XOR     EDX,EDX
        TEST    ECX,ECX
        JZ      @@Finish
        CLD
@@1:
        LODSB
        CMP     AL,[EDI]
        JZ      @@2
        MOV     EDX,1
@@2:
        STOSB
        LOOP    @@1

@@Finish:
        CMP     [EDI].Byte,0
        JZ      @@3
        MOV     [EDI].Byte,0
        MOV     EDX,1
@@3:
        MOV     EAX,EDX
        POP     EDI
        POP     ESI
end;

function CountBits(BitsValue:Integer):Integer;
asm
        XOR     EDX,EDX
        MOV     ECX,32  //sizeof(Integer)*8;
@@1:
        RCL     EAX,1
        JNC     @@2
        INC     EDX
@@2:
        LOOP    @@1
        MOV     EAX,EDX
end;

procedure Fill_16b(var Dest;dwCount:u_int32;wValue:u_int16);
asm
        PUSH    EDI
        MOV     EDI,EAX
        MOV     EAX,ECX
        SHR     EAX,16
        MOV     AX,CX
        MOV     ECX,EDX
        SHR     ECX,1
        REP     STOSD
        TEST    EDX,$1
        JZ      @@1
        STOSW
@@1:
        POP     EDI
end;
procedure Fill_32b(var Dest;dwCount:u_int32;dwValue:u_int32);
asm
        XCHG    EDX,ECX
        PUSH    EDI
        MOV     EDI,EAX
        MOV     EAX,EDX
        REP     STOSD
        POP     EDI
end;

function Compare_32b(List1,List2:Pointer;dwCount:u_int32):_int32;
asm
        PUSH    ESI
        MOV     ESI,EAX
        XOR     EAX,EAX
@@cmp:
        DEC     ECX
        JL      @@exit
        LODSD
        SUB     EAX,[EDX]
        JB      @@1
        JA      @@2
        ADD     EDX,$4
        JMP     @@cmp
@@1:
        MOV     EAX,-1
        JMP     @@exit
@@2:
        MOV     EAX,1
@@exit:
        POP     ESI
end;

function Get_8b(List:Pointer;dwCount:u_int32;Index:u_int32):u_int8;
asm
        CMP     ECX,EDX
        JB      @@1
        XOR     EAX,EAX
        JMP     @@2
@@1:
        MOVZX   EAX,[EAX+ECX].BYTE
@@2:
end;
function iGet_8b(List:Pointer;dwCount:u_int32;Index:u_int32):_int8;
asm
        JMP     Get_8b
end;
function Get_16b(List:Pointer;dwCount:u_int32;Index:u_int32):u_int16;
asm
        CMP     ECX,EDX
        JB      @@1
        XOR     EAX,EAX
        JMP     @@2
@@1:
        SHL     ECX,1
        MOVZX   EAX,[EAX+ECX].WORD
@@2:
end;
function iGet_16b(List:Pointer;dwCount:u_int32;Index:u_int32):_int16;
asm
        JMP     Get_16b
end;
function Get_32b(List:Pointer;dwCount:u_int32;Index:u_int32):u_int32;
asm
        CMP     ECX,EDX
        JB      @@1
        XOR     EAX,EAX
        JMP     @@2
@@1:
        SHL     ECX,2
        MOV     EAX,[EAX+ECX]
@@2:
end;
function iGet_32b(List:Pointer;dwCount:u_int32;Index:u_int32):_int32;
asm
        JMP     Get_32b
end;

procedure Set_8b(List:Pointer;dwCount:u_int32;Index:u_int32;Value:u_int8);
asm
        CMP     ECX,EDX
        JAE     @@1
        MOV     DL,Value
        MOV     [EAX+ECX],DL
@@1:
end;
procedure Set_16b(List:Pointer;dwCount:u_int32;Index:u_int32;Value:u_int16);
asm
        CMP     ECX,EDX
        JAE     @@1
        SHL     ECX,1
        MOV     DX,Value
        MOV     [EAX+ECX],DX
@@1:
end;
procedure Set_32b(List:Pointer;dwCount:u_int32;Index:u_int32;Value:u_int32);
asm
        CMP     ECX,EDX
        JAE     @@1
        SHL     ECX,2
        MOV     EDX,Value
        MOV     [EAX+ECX],EDX
@@1:
end;

procedure Invert_8b(List:Pointer;dwCount:u_int32);
asm
        TEST    EDX,EDX
        JLE     @@Exit
        ADD     EDX,EAX
        DEC     EDX
@@Xchg:
        MOV     CL,[EAX]
        XCHG    CL,[EDX]
        MOV     [EAX],CH
        INC     EAX
        DEC     EDX
        CMP     EAX,EDX
        JB      @@Xchg
@@Exit:
end;
procedure Invert_16b(List:Pointer;dwCount:u_int32);
asm
        SHL     EDX,1
        JLE     @@Exit
        ADD     EDX,EAX
        SUB     EDX,2
@@Xchg:
        MOV     CX,[EAX]
        XCHG    CX,[EDX]
        MOV     [EAX],CX
        ADD     EAX,2
        SUB     EDX,2
        CMP     EAX,EDX
        JB      @@Xchg
@@Exit:
end;
procedure Invert_32b(List:Pointer;dwCount:u_int32);
asm
        SHL     EDX,2
        JLE     @@Exit
        ADD     EDX,EAX
        SUB     EDX,4
@@Xchg:
        MOV     ECX,[EAX]
        XCHG    ECX,[EDX]
        MOV     [EAX],ECX
        ADD     EAX,4
        SUB     EDX,4
        CMP     EAX,EDX
        JB      @@Xchg
@@Exit:
end;

function IndexOf_8b(List:Pointer;dwCount:u_int32;bFind:u_int8):_int32;
asm
        PUSH    EDI
        MOV     EDI,EAX

        MOV     EAX,ECX     // dwFind in EAX
        MOV     ECX,EDX     // dwCount in ECX
        TEST    ECX,ECX
        JZ      @@finished

        DEC     EDX
        //SHL     EDX,2
        ADD     EDX,EDI
        PUSH    EBX
        MOV     BL,[EDX]
        MOV     [EDX],EAX   // set GetLast value to dwFind
        CLD
@@loop:
        SCASB               // EDI will always points to later one
        JNZ     @@loop

        MOV     [EDX],BL    // now restore GetLast value

        ADD     EDX,$1//$4
        SUB     EDX,EDI
        //SHR     EDX,2
        JNZ     @@1         // not the GetLast one
        CMP     AL,BL       // is GetLast one?
        JZ      @@1

        MOV     EDX,ECX
@@1:
        POP     EBX

        SUB     ECX,EDX
@@finished:
        MOV     EAX,ECX
        DEC     EAX
        POP     EDI
end;
function IndexOf_16b(List:Pointer;dwCount:u_int32;wFind:u_int16):_int32;
asm
        PUSH    EDI
        MOV     EDI,EAX

        MOV     EAX,ECX     // dwFind in EAX
        MOV     ECX,EDX     // dwCount in ECX
        TEST    ECX,ECX
        JZ      @@finished

        DEC     EDX
        SHL     EDX,1//2
        ADD     EDX,EDI
        PUSH    EBX
        MOV     BX,[EDX]
        MOV     [EDX],EAX   // set GetLast value to dwFind
        CLD
@@loop:
        SCASW               // EDI will always points to later one
        JNZ     @@loop

        MOV     [EDX],BX    // now restore GetLast value

        ADD     EDX,$2//$4
        SUB     EDX,EDI
        SHR     EDX,1//2
        JNZ     @@1         // not the GetLast one
        CMP     AX,BX       // is GetLast one?
        JZ      @@1

        MOV     EDX,ECX
@@1:
        POP     EBX

        SUB     ECX,EDX
@@finished:
        MOV     EAX,ECX
        DEC     EAX
        POP     EDI
end;
function IndexOf_32b(List:Pointer;dwCount:u_int32;dwFind:u_int32):_int32;
asm
        PUSH    EDI
        MOV     EDI,EAX

        MOV     EAX,ECX     // dwFind in EAX
        MOV     ECX,EDX     // dwCount in ECX
        TEST    ECX,ECX
        JZ      @@finished

        DEC     EDX
        SHL     EDX,2
        ADD     EDX,EDI
        PUSH    EBX
        MOV     EBX,[EDX]
        MOV     [EDX],EAX   // set GetLast value to dwFind
        CLD
@@loop:
        SCASD               // EDI will always points to later one
        JNZ     @@loop

        MOV     [EDX],EBX   // now restore GetLast value

        ADD     EDX,$4
        SUB     EDX,EDI
        SHR     EDX,2
        JNZ     @@1         // not the GetLast one
        CMP     EAX,EBX     // is GetLast one?
        JZ      @@1

        MOV     EDX,ECX
@@1:
        POP     EBX

        SUB     ECX,EDX
@@finished:
        MOV     EAX,ECX
        DEC     EAX
        POP     EDI
end;

function Find_8b(List:Pointer;dwCount:u_int32;bFind:u_int8;var Index:u_int32):_int32;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        XOR     EBX,EBX
        XCHG    ECX,EDX
        DEC     ECX
        JL      @@falseExit
@@search:
        CMP     EBX,ECX
        JA      @@falseExit
        MOV     EDI,EBX
        ADD     EDI,ECX
        SHR     EDI,1
        MOV     EAX,EDI

        //SHL     EAX,0
        CMP     DL,[ESI+EAX]

        JB      @@below
        JA      @@above
        MOV     EBX,EDI
        JMP     @@TrueExit
@@below:
        MOV     ECX,EDI
        DEC     ECX
        JL      @@falseExit
        JMP     @@search
@@above:
        MOV     EBX,EDI
        INC     EBX
        JMP     @@search
@@TrueExit:
        MOV     EAX,BoolTrue
        JMP     @@exit
@@falseExit:
        MOV     EAX,BoolFalse
@@exit:
        MOV     EDX,Index   //?????????????????
        MOV     [EDX],EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;
function Find_16b(List:Pointer;dwCount:u_int32;wFind:u_int16;var Index:u_int32):_int32;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        XOR     EBX,EBX
        XCHG    ECX,EDX
        DEC     ECX
        JL      @@falseExit
@@search:
        CMP     EBX,ECX
        JA      @@falseExit
        MOV     EDI,EBX
        ADD     EDI,ECX
        SHR     EDI,1
        MOV     EAX,EDI

        SHL     EAX,1
        CMP     DX,[ESI+EAX]

        JB      @@below
        JA      @@above
        MOV     EBX,EDI
        JMP     @@TrueExit
@@below:
        MOV     ECX,EDI
        DEC     ECX
        JL      @@falseExit
        JMP     @@search
@@above:
        MOV     EBX,EDI
        INC     EBX
        JMP     @@search
@@TrueExit:
        MOV     EAX,BoolTrue
        JMP     @@exit
@@falseExit:
        MOV     EAX,BoolFalse
@@exit:
        MOV     EDX,Index   //?????????????????
        MOV     [EDX],EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;
function Find_32b(List:Pointer;dwCount:u_int32;dwFind:u_int32;var Index:u_int32):_int32;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        XOR     EBX,EBX
        XCHG    ECX,EDX
        DEC     ECX
        JL      @@falseExit
@@search:
        CMP     EBX,ECX
        JA      @@falseExit
        MOV     EDI,EBX
        ADD     EDI,ECX
        SHR     EDI,1
        MOV     EAX,EDI

        SHL     EAX,2
        CMP     EDX,[ESI+EAX]

        JB      @@below
        JA      @@above
        MOV     EBX,EDI
        JMP     @@TrueExit
@@below:
        MOV     ECX,EDI
        DEC     ECX
        JL      @@falseExit
        JMP     @@search
@@above:
        MOV     EBX,EDI
        INC     EBX
        JMP     @@search
@@TrueExit:
        MOV     EAX,BoolTrue
        JMP     @@exit
@@falseExit:
        MOV     EAX,BoolFalse
@@exit:
        MOV     EDX,Index   //?????????????????
        MOV     [EDX],EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;
function iFind_8b(List:Pointer;dwCount:u_int32;bFind:_int8;var Index:u_int32):_int32;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        XOR     EBX,EBX
        XCHG    ECX,EDX
        DEC     ECX
        JL      @@falseExit
@@search:
        CMP     EBX,ECX
        JA      @@falseExit
        MOV     EDI,EBX
        ADD     EDI,ECX
        SHR     EDI,1
        MOV     EAX,EDI

        //SHL     EAX,0
        CMP     DL,[ESI+EAX]

        JL      @@less
        JG      @@greater
        MOV     EBX,EDI
        JMP     @@TrueExit
@@less:
        MOV     ECX,EDI
        DEC     ECX
        JL      @@falseExit
        JMP     @@search
@@greater:
        MOV     EBX,EDI
        INC     EBX
        JMP     @@search
@@TrueExit:
        MOV     EAX,BoolTrue
        JMP     @@exit
@@falseExit:
        MOV     EAX,BoolFalse
@@exit:
        MOV     EDX,Index   //?????????????????
        MOV     [EDX],EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;
function iFind_16b(List:Pointer;dwCount:u_int32;iFind:_int16;var Index:u_int32):_int32;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        XOR     EBX,EBX
        XCHG    ECX,EDX
        DEC     ECX
        JL      @@falseExit
@@search:
        CMP     EBX,ECX
        JA      @@falseExit
        MOV     EDI,EBX
        ADD     EDI,ECX
        SHR     EDI,1
        MOV     EAX,EDI

        SHL     EAX,1
        CMP     DX,[ESI+EAX]

        JL      @@less
        JG      @@greater
        MOV     EBX,EDI
        JMP     @@TrueExit
@@less:
        MOV     ECX,EDI
        DEC     ECX
        JL      @@falseExit
        JMP     @@search
@@greater:
        MOV     EBX,EDI
        INC     EBX
        JMP     @@search
@@TrueExit:
        MOV     EAX,BoolTrue
        JMP     @@exit
@@falseExit:
        MOV     EAX,BoolFalse
@@exit:
        MOV     EDX,Index   //?????????????????
        MOV     [EDX],EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;
function iFind_32b(List:Pointer;dwCount:u_int32;lFind:_int32;var Index:u_int32):_int32;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        MOV     ESI,EAX
        XOR     EBX,EBX
        XCHG    ECX,EDX
        DEC     ECX
        JL      @@falseExit
@@search:
        CMP     EBX,ECX
        JA      @@falseExit
        MOV     EDI,EBX
        ADD     EDI,ECX
        SHR     EDI,1
        MOV     EAX,EDI

        SHL     EAX,2
        CMP     EDX,[ESI+EAX]

        JL      @@less
        JG      @@greater
        MOV     EBX,EDI
        JMP     @@TrueExit
@@less:
        MOV     ECX,EDI
        DEC     ECX
        JL      @@falseExit
        JMP     @@search
@@greater:
        MOV     EBX,EDI
        INC     EBX
        JMP     @@search
@@TrueExit:
        MOV     EAX,BoolTrue
        JMP     @@exit
@@falseExit:
        MOV     EAX,BoolFalse
@@exit:
        MOV     EDX,Index   //?????????????????
        MOV     [EDX],EBX
        POP     EBX
        POP     EDI
        POP     ESI
end;

procedure Move_32b1(List:Pointer;dwCount:u_int32;fromIndex,toIndex:u_int32);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        CMP     ECX,EDX
        JAE     @@exit
        MOV     EAX,toIndex
        CMP     EAX,EDX
        JAE     @@exit
        MOV     EDI,ECX
        SHL     EDI,2
        ADD     EDI,ESI
        MOV     ESI,EDI

        CMP     ECX,EAX
        JE      @@exit
        JA      @@back
@@fore:
        SUB     EAX,ECX
        MOV     ECX,EAX
        ADD     ESI,$4
        CLD
        JMP     @@Move
@@back:
        SUB     ECX,EAX
        SUB     ESI,$4
        STD
@@Move:
        MOV     EDX,[EDI]
        REP     MOVSD
        CLD
        MOV     [EDI],EDX

@@exit:
        POP     EDI
        POP     ESI
end;

procedure InsMove_32b(List:Pointer;dwCount:u_int32;Index,Count:u_int32;Value:u_int32);
asm
        PUSH    ESI
        PUSH    EDI
        MOV     EDI,EAX

        CMP     EDX,ECX
        JA      @@MoveData      //Index<=dwCount
        MOV     EDX,EAX
        SHL     ECX,2
        ADD     EDX,ECX
        JMP     @@store
        
@@MoveData:
        MOV     EAX,Count
        TEST    EAX,EAX
        JZ      @@exit      //Count>0
        SHL     ECX,2
        ADD     ECX,EDI     //ECX: ^Index
        DEC     EDX
        SHL     EDX,2
        ADD     EDI,EDX     //EDI: ^dwCount-1
        MOV     ESI,EDI     //ESI: ^dwCount-1
        SHL     EAX,2
        ADD     EDI,EAX     //EDI: ^dwCount+Count-1
        MOV     EDX,ECX     //EDX: ^Index
        MOV     EAX,ESI
        XCHG    EAX,ECX
        SUB     ECX,EAX
        SHR     ECX,2
        INC     ECX         //ECX: ^dwCount-Index
        STD
        REP     MOVSD
        CLD
@@store:
        MOV     EDI,EDX     //EDX: ^Index
        MOV     ECX,Count
        MOV     EAX,Value
        REP     STOSD
@@exit:
        POP     EDI
        POP     ESI
end;

procedure DelMove_32b(List:Pointer;dwCount:u_int32;Index,Count:u_int32);
asm
        PUSH    EDI
        MOV     EDI,EAX
        TEST    EAX,EAX
        JZ      @@exit
        MOV     EAX,Count
        ADD     EAX,ECX
        SUB     EDX,EAX
        JBE     @@exit
        MOV     Count,EDX
        MOV     EDX,ESI
        SHL     EAX,2
        MOV     ESI,EDI
        ADD     ESI,EAX    //ESI: ^Index+Count
        SHL     ECX,2
        ADD     EDI,ECX    //EDI: ^Index
        MOV     ECX,Count
        CLD
        REP     MOVSD
        MOV     ESI,EDX
@@exit:
        POP     EDI
end;

procedure Sort_32b(List:Pointer;dwCount:u_int32);
asm
        MOV     ECX,EDX
        DEC     ECX
        JLE     @@1
        XOR     EDX,EDX
        CALL    QuickSort_32b
@@1:
end;

procedure QuickSort_32b(List:Pointer;start,stop:u_int32);
asm
        CMP     EDX,ECX
        JAE     @@exit
        PUSH    EBP
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EBP,EDX
        MOV     EDI,ECX
@@loop:
        MOV     EBX,EBP
        MOV     EDX,EDI

        MOV     ECX,EBX
        ADD     ECX,EDX
        SHR     ECX,1
        MOV     ECX,[ESI+ECX*4]
        JMP     @@1a
@@1:
        INC     EBX
@@1a:
        CMP     ECX,[ESI+EBX*4]
        JA      @@1
        JMP     @@2a
@@2:
        DEC     EDX
@@2a:
        CMP     ECX,[ESI+EDX*4]
        JB      @@2
@@3:
        CMP     EBX,EDX
        JE      @@4
        JA      @@5
        MOV     EAX,[ESI+EBX*4]
        XCHG    EAX,[ESI+EDX*4]
        MOV     [ESI+EBX*4],EAX
@@4:
        INC     EBX
        DEC     EDX
        JL      @@6
@@5:
        CMP     EBX,EDX
        JBE     @@1a

        CMP     EDX,EBP
        JBE     @@6
        MOV     EAX,ESI
        MOV     ECX,EDX
        MOV     EDX,EBP
        CALL    QuickSort_32b
@@6:
        MOV     EBP,EBX
        CMP     EBX,EDI
        JB      @@loop
@@finish:
        POP     EBX
        POP     ESI
        POP     EDI
        POP     EBP
@@exit:
end;

procedure iSort_32b(List:Pointer;dwCount:u_int32);
asm
        MOV     ECX,EDX
        DEC     ECX
        JLE     @@1
        XOR     EDX,EDX
        CALL    iQuickSort_32b
@@1:
end;

procedure iQuickSort_32b(List:Pointer;start,stop:u_int32);
asm
        CMP     EDX,ECX
        JAE     @@exit
        PUSH    EBP
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EBP,EDX
        MOV     EDI,ECX
@@loop:
        MOV     EBX,EBP
        MOV     EDX,EDI

        MOV     ECX,EBX
        ADD     ECX,EDX
        SHR     ECX,1
        MOV     ECX,[ESI+ECX*4]
        JMP     @@1a
@@1:
        INC     EBX
@@1a:
        CMP     ECX,[ESI+EBX*4]
        JG      @@1
        JMP     @@2a
@@2:
        DEC     EDX
@@2a:
        CMP     ECX,[ESI+EDX*4]
        JL      @@2
@@3:
        CMP     EBX,EDX
        JE      @@4
        JA      @@5
        MOV     EAX,[ESI+EBX*4]
        XCHG    EAX,[ESI+EDX*4]
        MOV     [ESI+EBX*4],EAX
@@4:
        INC     EBX
        DEC     EDX
        JL      @@6
@@5:
        CMP     EBX,EDX
        JBE     @@1a

        CMP     EDX,EBP
        JBE     @@6
        MOV     EAX,ESI
        MOV     ECX,EDX
        MOV     EDX,EBP
        CALL    iQuickSort_32b
@@6:
        MOV     EBP,EBX
        CMP     EBX,EDI
        JB      @@loop
@@finish:
        POP     EBX
        POP     ESI
        POP     EDI
        POP     EBP
@@exit:
end;

function _DoubleValueType(pDoubleValue:Pointer):_int32;
asm
        MOV     EDX,EAX
        XOR     EAX,EAX
        MOV     AX,[EDX+06h]
        AND     EAX,7FF8h
        CMP     EAX,7FF8h
        JE      @@NotANumber
        CMP     EAX,7FF0h
        JE      @@InfiniteValue
        JMP     @@NumberValue
@@InfiniteValue:
        CMP     u_int32 PTR [EDX],0
        JNE     @@NotANumber
        MOV     EAX,[EDX+4]
        MOV     EDX,EAX
        AND     EDX,0FFFFh
        JNZ     @@NotANumber
        ROL     EAX,1
        AND     EAX,01h
        INC     EAX
        INC     EAX
        JMP     @@Exit
@@NotANumber:
        MOV     EAX,1
        JMP     @@Exit
@@NumberValue:
        XOR     EAX,EAX
@@Exit:
end;
function SingleValueType(var vSingle:Single):_int32;
var
  D:Double;
asm
        fld     u_int32 PTR [EAX]
        LEA     EAX,D
        fstp    QWORD PTR [EAX]
        CALL    _DoubleValueType
end;
function DoubleValueType(var vDouble:Double):_int32;
asm
        JMP _DoubleValueType
end;
function ExtendedValueType(var vExtended:Extended):_int32;
var
  D:Double;
asm
        fld     TBYTE PTR [EAX]
        LEA     EAX,D
        fstp    QWORD PTR [EAX]
        CALL    _DoubleValueType
end;

procedure __WindDecimal(decimal:Byte);
//注意：不能修改EDX
const
  Dot5Adjust:Double=1E-10;
{  eax,st(0)-->
   -->st(0)                       }
var
  fpucw0,fpucw1:Word;
  decpower:_int32;
asm
        AND     EAX,$0F
        JNZ      @@decRound
        //Round
        fadd    Dot5Adjust
        FSTCW   fpucw0
        FWAIT
        MOV     AX,fpucw0
        AND     AX,$F3FF    //Round
        MOV     fpucw1,AX
        FLDCW   fpucw1
        FRNDINT
        FWAIT
        FLDCW   fpucw0
        JMP     @@Exit

@@decRound:
        //E:ST(0),EAX:Decimal
        XOR     ECX,ECX
        INC     ECX
@@dec10:
        //IMUL    ECX,10
        LEA     ECX,ECX+4*ECX
        ADD     ECX,ECX
        DEC     EAX
        JNZ     @@dec10
        MOV     decpower,ECX
        //now ST(0) E
        FSTCW   fpucw0
        FWAIT
        MOV     AX,fpucw0
        OR      AX,$0C00    //int
        MOV     fpucw1,AX
        FLDCW   fpucw1
        FLD     ST(0)
        FRNDINT
        FXCH
        FSUB    ST(0),ST(1)
        //now ST(0)frac,ST(1):INT
        FIMUL   decpower
        fadd    Dot5Adjust
        MOV     AX,fpucw0
        AND     AX,$F3FF    //Round
        MOV     fpucw1,AX
        FLDCW   fpucw1
        FRNDINT
        FIDIV   decpower
        FADDP   ST(1),ST(0)
        FWAIT
        FLDCW   fpucw0
@@Exit:
end;
procedure _WindDecimal(decimal:Byte);
//注意：不能修改EDX
asm
        CMP     AL,10
        JA      @@2         //大于10，有精度误差，不操作
        MOV     ECX,EAX
        fldz
        fcomp
        fstsw   AX
        SAHF
        MOV     EAX,ECX
        JBE     __WindDecimal
@@1:
        fchs
        CALL    __WindDecimal
        fchs
@@2:
end;
function WindDecimalD(const E:Double;Decimal:Byte):Double;assembler;
asm
        FLD     QWORD PTR [EBP+8]
        CALL    _WindDecimal
end;
function WindDecimalE(const E:Extended;Decimal:Byte):Extended;assembler;
asm
        FLD     TBYTE PTR [EBP+8]
        CALL    _WindDecimal
end;
procedure WindDecimalD3(var E:Double;Decimal:Byte);
asm
        XCHG    EAX,EDX
        FLD     QWORD PTR [EDX]
        CALL    _WindDecimal      //EDX不变
        FSTP    QWORD PTR [EDX]
end;
procedure WindDecimalE3(var E:Extended;Decimal:Byte);
asm
        XCHG    EAX,EDX
        FLD     TBYTE PTR [EDX]
        CALL    _WindDecimal      //EDX不变
        FSTP    TBYTE PTR [EDX]
end;

{ TSharedObject }

procedure TSharedObject.AfterConstruction;
begin
// Release the constructor's implicit refcount
  Dec(FRefCount);
end;

procedure TSharedObject.BeforeDestruction;
begin
  DebugAssert(RefCount=0,'对象['+ClassName+']还在使用，不能释对象');
end;

// Set an implicit refcount so that refcounting
// during construction won't destroy the object.
class function TSharedObject.NewInstance: TObject;
begin
  Result := inherited NewInstance();
  TSharedObject(Result).FRefCount := 1;
end;

function TSharedObject.AddRef: Integer;
begin
  Inc(FRefCount);
  Result := FRefCount;
end;

function TSharedObject.Release: Integer;
begin
  Dec(FRefCount);
  Result := FRefCount;
  if Result = 0 then Destroy;
end;

{ TISharedObject }

function TISharedObject.AddRef: Integer;
begin
  Result:=_AddRef();
end;

function TISharedObject.Release: Integer;
begin
  Result:=_Release();
end;

{ TExBits }

const
  BitsPerByte = 8;
  BitsPerInt = SizeOf(_int32) * BitsPerByte;

destructor TExBits.Destroy;
begin
  SetSize(0);
  inherited Destroy;
end;

procedure TExBits.Assign(Source:TExBits);
var
  MemSize: _int32;
begin
  if(Source=nil)or(Source=Self)then Exit;
  Size:=Source.Size;
  MemSize:=((Size+BitsPerInt-1) div BitsPerInt)*SizeOf(_int32);
  if(Size>0)then
    Move(Source.FBits^,FBits^,MemSize);
end;

procedure TExBits.InvertAll;
var
  MemSize:_int32;
begin
  if(Size=0)then Exit;
  MemSize:=((Size+BitsPerInt-1) div BitsPerInt);
  asm
        MOV     EDX,[EAX].FBits
        MOV     ECX,MemSize
  @@Loop:
        MOV     EAX,[EDX]
        NOT     EAX
        MOV     [EDX],EAX
        ADD     EDX,4
        DEC     ECX
        JNZ     @@Loop
  end;
end;

procedure TExBits.SetAll(SetValue:Boolean);
const
  FillValue:array[Boolean] of Byte=(0,$FF);
var
  MemSize: _int32;
begin
  MemSize:=((Size+BitsPerInt-1) div BitsPerInt)*SizeOf(_int32);
  FillChar(FBits^,MemSize,FillValue[SetValue]);
end;

procedure TExBits.BoolAND(Source:TExBits);
var
  i,IntCount:_int32;
  p1,p2:^_int32;
begin
  if(Source.Size<Size)then Size:=Source.Size;
  IntCount:=((MinInteger(Size,Source.Size)+BitsPerInt-1) div BitsPerInt);
  p1:=FBits;p2:=Source.FBits;
  for i:=0 to IntCount-1 do begin
    p1^:=p1^ and p2^;
    Inc(p1);Inc(p2);
  end;
end;

procedure TExBits.BoolANDNot(Source:TExBits);
var
  i,IntCount:_int32;
  p1,p2:^_int32;
begin
  //if(Source.Size<Size)then Size:=Source.Size;
  IntCount:=((MinInteger(Size,Source.Size)+BitsPerInt-1) div BitsPerInt);
  p1:=FBits;p2:=Source.FBits;
  for i:=0 to IntCount-1 do begin
    p1^:=p1^ and not p2^;
    Inc(p1);Inc(p2);
  end;
end;

procedure TExBits.BoolOR(Source:TExBits);
var
  i,IntCount:_int32;
  p1,p2:^_int32;
begin
  if(Source.Size>Size)then Size:=Source.Size;
  IntCount:=((MinInteger(Size,Source.Size)+BitsPerInt-1) div BitsPerInt);
  p1:=FBits;p2:=Source.FBits;
  for i:=0 to IntCount-1 do begin
    p1^:=p1^ or p2^;
    Inc(p1);Inc(p2);
  end;
end;

procedure TExBits.BoolXOR(Source:TExBits);
var
  i,IntCount:_int32;
  p1,p2:^_int32;
begin
  IntCount:=((MinInteger(Size,Source.Size)+BitsPerInt-1) div BitsPerInt);
  p1:=FBits;p2:=Source.FBits;
  for i:=0 to IntCount-1 do begin
    p1^:=p1^ XOR p2^;
    Inc(p1);Inc(p2);
  end;
end;

procedure TExBits.SetSize(Value: _int32);
var
  NewMem: Pointer;
  i,OldSize: _int32;
  NewMemSize,OldMemSize: _int32;
begin
{
  if (Value<=0)then
  begin
    if FBits<>nil then
    begin
      GlobalFreePtr(FBits);
      FBits:=nil;
      FSize:=0;
    end;
    Exit;
  end;
  if Value=Size then Exit;
  NewMemSize:=((Value+BitsPerInt-1) div BitsPerInt)*SizeOf(_int32);
  OldMemSize:=((Size+BitsPerInt-1) div BitsPerInt)*SizeOf(_int32);
  if(NewMemSize<>OldMemSize)then
  begin
    if OldMemSize=0 then
      FBits:=GlobalAllocPtr(GMEM_MOVEABLE,NewMemSize)
    else begin
      FBits:=GlobalReAllocPtr(
        FBits,
        NewMemSize,
        GMEM_MOVEABLE);
    end;
    if FBits=nil then OutOfMemoryError
  end;
  OldSize:=FSize;FSize:=NewMemSize*BitsPerByte;
  for i:=OldSize to MinInteger(OldMemSize*BitsPerByte,FSize)-1 do
        Bits[i]:=False;
  FSize:=Value;
  }

  if(Value<0)or(Value=Size)then Exit;
  NewMemSize:=((Value+BitsPerInt-1) div BitsPerInt)*SizeOf(_int32);
  OldMemSize:=((Size+BitsPerInt-1) div BitsPerInt)*SizeOf(_int32);
  if(NewMemSize<>OldMemSize)then begin
    NewMem:=nil;
    if(NewMemSize<>0)then begin
      GetMem(NewMem,NewMemSize);
      FillChar(NewMem^,NewMemSize,0);
    end;
    if(OldMemSize<>0)then begin
      if(NewMem<>nil)then
        Move(FBits^,NewMem^,MinInteger(OldMemSize,NewMemSize));
      FreeMem(FBits,OldMemSize);
    end;
    FBits := NewMem;
  end;
  OldSize:=FSize;FSize:=NewMemSize*BitsPerByte;
  for i:=OldSize to MinInteger(OldMemSize*BitsPerByte,FSize)-1 do
        Bits[i]:=False;
  FSize:=Value;



end;

procedure TExBits.SetBit(Index: _int32; Value: Boolean); assembler;
asm
        CMP     Index,[EAX].FSize
        JAE     @@Size

@@1:    MOV     EAX,[EAX].FBits
        OR      Value,Value
        JZ      @@2
        BTS     [EAX],Index
        RET

@@2:    BTR     [EAX],Index
@@3:    RET

@@Size: CMP     Index,0
        JL      @@3
        PUSH    Self
        PUSH    Index
        PUSH    ECX {Value}
        INC     Index
        CALL    SetSize
        POP     ECX {Value}
        POP     Index
        POP     Self
        JMP     @@1
end;

function TExBits.GetBit(Index: _int32): Boolean; assembler;
asm
        CMP     EDX,[EAX].FSize
        JAE     @@3
        MOV     EAX,[EAX].FBits
        BT      [EAX],Index
        SBB     EAX,EAX
        AND     EAX,1
        RET
@@3:    XOR     EAX,EAX
end;

function TExBits.HasValue(SearchValue: Boolean): Boolean;
var
  p:PBytesArray;
  l,MemSize:LongInt;
begin
  if(Size=0)then begin
    Result:=False;Exit;
  end;
  p:=PBytesArray(FBits);
  l:=0;
  MemSize:=(FSize+$7) shr 3;
  if(SearchValue)then begin
    while(p^[l]=0)and(l<MemSize)do Inc(l);
  end else begin
    while(p^[l]=$FF)and(l<MemSize)do Inc(l);
  end;
  Result:=(l<MemSize);
end;

{ TExtBits }

procedure TExtBits.Insert(Index: _int32; Value: Boolean);
var
  i:_int32;
begin
  if(Index<0)then Exit;
  if(Index>=Size)then Bits[Size]:=Value
  else begin
    Size:=Size+1;
    for i:=Size-1 downto Index+1 do
      Bits[i]:=Bits[i-1];
    Bits[Index]:=Value;
  end;
end;

procedure TExtBits.InsertEx(Index,InsCount:_int32;DefaultValue:Boolean);
var
  i,MoveCount:_int32;
begin
  if(InsCount<=0)then Exit;
  Assert( (Index>=0) );

  if(Index>size)then Size:=Index;
  MoveCount:=Size-Index;
  Size:=Size+InsCount;
  for i:=Index+MoveCount-1 downto Index do
    Bits[i+InsCount]:=Bits[i];
  for i:=Index to Index+InsCount-1 do
    Bits[i]:=DefaultValue;
end;

procedure TExtBits.Delete(Index: _int32);
var
  i:_int32;
begin
  if(Index<0)or(Index>=Size)then Exit;
  for i:=Index to Size-1-1 do
    Bits[i]:=Bits[i+1];
  Size:=Size-1;
end;

procedure TExtBits.DeleteEx(Index:_int32;DelCount:_int32);
var
  i:_int32;
begin
  if(Index<0)or(Index>=Size)then Exit;
  if(Index+DelCount>Size)then DelCount:=Size-Index;

  for i:=Index to Size-DelCount-1 do
    Bits[i]:=Bits[i+DelCount];
  Size:=Size-DelCount;
end;

procedure TExtBits.Move(CurIndex, NewIndex: _int32);
var
  i:_int32;
  Bit:Boolean;
begin
  if(CurIndex<0)or(NewIndex<0)then Exit;
  if(Size<=CurIndex)then begin
    if(Size>NewIndex)then Insert(NewIndex,False);
  end else if(Size<=NewIndex)then begin
    Bit:=Bits[CurIndex];
    Delete(CurIndex);
    if(Bit)then Bits[NewIndex]:=Bit;
  end else begin
    Bit:=Bits[CurIndex];
    for i:=CurIndex to NewIndex-1 do Bits[i]:=Bits[i+1];
    for i:=CurIndex downto NewIndex+1 do Bits[i]:=Bits[i-1];
    Bits[NewIndex]:=Bit;
  end;
end;

procedure TExtBits.Exchange(Index1,Index2:_int32);
var
  Bit:Boolean;
begin
  Bit:=Bits[Index1];
  if(Bit xor Bits[Index2])then begin
    Bits[Index1]:=Bits[Index2];
    Bits[Index2]:=Bit;
  end;
end;

{ T32bArray }

constructor T32bArray.Create(InitCapacity:Integer);
begin
  inherited Create;
  if(InitCapacity>0)then SetCapacity(InitCapacity);
end;
destructor T32bArray.Destroy;
begin
  Clear(True);
  inherited;
end;
function T32bArray.GetDataSize():Integer;
begin
  Result:=Count shl 2;
end;
function T32bArray.GetMemSize():Integer;
begin
  Result:=Capacity shl 2;
end;
procedure T32bArray.SetCount(newCount:Integer);
begin
  AdjustCount(newCount,True);
end;
procedure T32bArray.SetCapacity(newCapacity:Integer);
var
  Delta:Integer;
begin
  if(newCapacity<0)then Exit;
  if(newCapacity>4096)then Delta:=$FF
  else if(newCapacity>256)then Delta:=$3F
  else Delta:=$0F;
  newCapacity:=(newCapacity+Delta)and not Delta;
  if(newCapacity=FCapacity)then Exit;

  ReAlloc(FMemory,newCapacity);

  FCapacity:=newCapacity;
end;
procedure T32bArray.ReAlloc(var MemPtr:Pointer;newCapacity:Integer);
begin
  //Assert(newCapacity>0);
  if(Capacity=0)then begin
    GetMem(MemPtr,newCapacity shl 2);
  end else if(newCapacity=0)then begin
    FreeMem(MemPtr);MemPtr:=nil;
  end else begin
    ReallocMem(MemPtr,newCapacity shl 2);
  end;
end;
procedure T32bArray.Clear(FreeMem:Boolean);
begin
  FCount:=0;
  if(FreeMem)then SetCapacity(0);
end;
procedure T32bArray.AdjustCount(newCount:Integer;DoZero:Boolean);
begin
  if(newCount<0)then Exit;
  if(newCount<Count)then begin
    FCount:=newCount;
  end else if(newCount>Count)then begin
    if(newCount>Capacity)then SetCapacity(newCount);
    if(DoZero)then
        Fill_32b(Pointer(u_int32(Memory)+u_int32(Count shl 2))^,
                newCount-Count,0);
    FCount:=newCount;
  end;
end;
procedure T32bArray.AdjustCapacity(newCapacity:Integer);
begin
  if(newCapacity>=Count)then begin
    ReAlloc(FMemory,newCapacity);

    FCapacity:=newCapacity;
  end;
end;
procedure T32bArray.FreeMore();
begin
  AdjustCapacity(Count);
end;

function T32bArray.GetElemPtr(Index:Integer):Pointer;
begin
  Result:=Pointer(uInt32(Memory)+uInt32(Index shl 2));
end;

function T32bArray.GetElems1(Index:Integer):u_int32;
asm
        CMP     EDX,[EAX].FCount
        JB      @@1       //unsigned jmp
        XOR     EAX,EAX
        JMP     @@2
@@1:
        SHL     EDX,2
        ADD     EDX,[EAX].FMemory
        MOV     EAX,[EDX]
@@2:
end;
function T32bArray.GetElems2(Index:Integer):_int32;
asm
        JMP     GetElems1
end;
function T32bArray.GetElems3(Index:Integer): Pointer;
asm
        JMP     GetElems1
end;

function  T32bArray.GetElems4(Index:Integer): TObject;
asm
        JMP     GetElems1
end;

procedure T32bArray.SetElems1(Index:Integer;const Value:u_int32);
asm
        CMP     EDX,[EAX].FCount
        JAE     @@1      //unsigned jmp
        SHL     EDX,2
        ADD     EDX,[EAX].FMemory
        MOV     [EDX],ECX
@@1:
end;
procedure T32bArray.SetElems2(Index:Integer;const Value:_int32);
asm
        JMP     SetElems1
end;
procedure T32bArray.SetElems3(Index:Integer;const Value:Pointer);
asm
        JMP     SetElems1
end;

procedure T32bArray.SetElems4(Index:Integer;const Value:TObject);
asm
        JMP     SetElems1
end;

function T32bArray.GetFirst1():u_int32;
begin
  Result:=Elems1[0];
end;
function T32bArray.GetFirst2():_int32;
begin
  Result:=Elems2[0];
end;
function T32bArray.GetFirst3():Pointer;
begin
  Result:=Elems3[0];
end;
procedure T32bArray.SetFirst1(const Value:u_int32);
begin
  Elems1[0]:=Value;
end;
procedure T32bArray.SetFirst2(const Value:_int32);
begin
  Elems2[0]:=Value;
end;
procedure T32bArray.SetFirst3(const Value:Pointer);
begin
  Elems3[0]:=Value;
end;
function T32bArray.GetLast1():u_int32;
begin
  Result:=Elems1[Count-1];
end;
function T32bArray.GetLast2():_int32;
begin
  Result:=Elems2[Count-1];
end;
function T32bArray.GetLast3():Pointer;
begin
  Result:=Elems3[Count-1];
end;
procedure T32bArray.SetLast1(const Value:u_int32);
begin
  Elems1[Count-1]:=Value;
end;
procedure T32bArray.SetLast2(const Value:_int32);
begin
  Elems2[Count-1]:=Value;
end;
procedure T32bArray.SetLast3(const Value:Pointer);
begin
  Elems3[Count-1]:=Value;
end;

procedure T32bArray.Add1(const data:u_int32);
asm
        MOV     ECX,[EAX].FCount
        CMP     ECX,[EAX].FCapacity
        JB      @@Store
        PUSH    EDX
        PUSH    EAX
        MOV     EDX,ECX
        INC     EDX
        CALL    SetCapacity
        POP     EAX
        POP     EDX
@@Store:
        MOV     ECX,[EAX].FCount
        INC     [EAX].FCount
        SHL     ECX,2
        ADD     ECX,[EAX].FMemory
        MOV     [ECX],EDX
end;
procedure T32bArray.Add2(const data:_int32);
asm
        JMP     T32bArray.Add1
end;
procedure T32bArray.Add3(const data:Pointer);
asm
        JMP     T32bArray.Add1
end;

procedure T32bArray.Insert1(Index,Count:Integer;Value:u_int32);
var
  OCount:Integer;
begin
  OCount:=Self.Count;
  if(Index>=0)and(Index<=OCount)and(Count>0)then begin
    AdjustCount(OCount+Count,False);
    InsMove_32b(Memory,OCount,Index,Count,Value);
  end;
end;
procedure T32bArray.Insert2(Index,Count:Integer;Value:_int32);
var
  OCount:Integer;
begin
  OCount:=Self.Count;
  if(Index>=0)and(Index<=OCount)and(Count>0)then begin
    AdjustCount(OCount+Count,False);
    InsMove_32b(Memory,OCount,Index,Count,Value);
  end;
end;
procedure T32bArray.Insert3(Index,Count:Integer;Value:Pointer);
var
  OCount:Integer;
begin
  OCount:=Self.Count;
  if(Index>=0)and(Index<=OCount)and(Count>0)then begin
    AdjustCount(OCount+Count,False);
    InsMove_32b(Memory,OCount,Index,Count,u_int32(Value));
  end;
end;

procedure T32bArray.Delete(Index,Count:Integer;FreeMore:Boolean);
var
  OCount:Integer;
begin
  OCount:=Self.Count;
  if(Index>=0)and(Count>0)and(Index+Count<=OCount)then begin
    DelMove_32b(Memory,OCount,Index,Count);
    AdjustCount(OCount-Count);
    if(FreeMore)then SetCapacity(Self.Count);
  end;
end;

function T32bArray.IndexOf1(data:u_int32):Integer;
asm
        MOV     ECX,EDX
        MOV     EDX,[EAX].FCount
        MOV     EAX,[EAX].FMemory
        JMP     IndexOf_32b
end;
function T32bArray.IndexOf2(data:_int32):Integer;
asm
        MOV     ECX,EDX
        MOV     EDX,[EAX].FCount
        MOV     EAX,[EAX].FMemory
        JMP     IndexOf_32b
end;
function T32bArray.IndexOf3(data:Pointer):Integer;
asm
        MOV     ECX,EDX
        MOV     EDX,[EAX].FCount
        MOV     EAX,[EAX].FMemory
        JMP     IndexOf_32b
end;
function T32bArray.InArray1(data:u_int32):Boolean;
begin
  Result:=IndexOf1(data)>=0;
end;
function T32bArray.InArray2(data:_int32):Boolean;
begin
  Result:=IndexOf2(data)>=0;
end;
function T32bArray.InArray3(data:Pointer):Boolean;
begin
  Result:=IndexOf3(data)>=0;
end;

function  T32bArray.Search1(start:Integer;data:u_int32):Integer;
begin
  if(start>=0)and(start<Count)then begin
    Result:=IndexOf_32b(Pointer(u_int32(Memory)+u_int32(start shl 2)),Count-start,data);
    if(Result>=0)then Inc(Result,start);
  end else begin
    Result:=-1;
  end;
end;
function  T32bArray.Search2(start:Integer;data:_int32):Integer;
asm
        JMP     T32bArray.Search1
end;
function  T32bArray.Search3(start:Integer;data:Pointer):Integer;
asm
        JMP     T32bArray.Search1
end;

function  T32bArray.Find1(data:u_int32;var Index:Integer):Boolean;
begin
  Result:=Find_32b(FMemory,Count,data,u_int32(Index))=BoolTrue;
end;
function  T32bArray.Find2(data:_int32;var Index:Integer):Boolean;
begin
  Result:=iFind_32b(FMemory,Count,data,u_int32(Index))=BoolTrue;
end;
function  T32bArray.Find3(data:Pointer;var Index:Integer):Boolean;
begin
  Result:=Find_32b(FMemory,Count,u_int32(data),u_int32(Index))=BoolTrue;
end;
function  T32bArray.sIndexOf1(data:u_int32):Integer;
begin
  if(not Find1(data,Result))then Result:=-1;
end;
function  T32bArray.sIndexOf2(data:_int32):Integer;
begin
  if(not Find2(data,Result))then Result:=-1;
end;
function  T32bArray.sIndexOf3(data:Pointer):Integer;
begin
  if(not Find3(data,Result))then Result:=-1;
end;
function  T32bArray.sInArray1(data:u_int32):Boolean;
var
  Index:Integer;
begin
  Result:=Find1(data,Index);
end;
function  T32bArray.sInArray2(data:_int32):Boolean;
var
  Index:Integer;
begin
  Result:=Find2(data,Index);
end;
function  T32bArray.sInArray3(data:Pointer):Boolean;
var
  Index:Integer;
begin
  Result:=Find3(data,Index);
end;

function  T32bArray.FindFirst1(data:u_int32;var Index:Integer):Boolean;
var
  sb,se,sp,flag:Integer;
begin
  sb:=0;se:=Count-1;flag:=-1;
  while(sb<=se)do begin
    sp:=(sb+se) shr 1;
    flag:=data-Elems1[sp];
    if(flag>0)then sb:=sp+1
    else if(flag<0)then se:=sp-1
    else begin
      se:=sp;
      if(sb=sp)then Break;
    end;
  end;
  Index:=sb;
  Result:=flag=0;
end;

function  T32bArray.FindFirst2(data:_int32;var Index:Integer):Boolean;
var
  sb,se,sp,flag:Integer;
begin
  sb:=0;se:=Count-1;flag:=-1;
  while(sb<=se)do begin
    sp:=(sb+se) shr 1;
    flag:=data-Elems2[sp];
    if(flag>0)then sb:=sp+1
    else if(flag<0)then se:=sp-1
    else begin
      se:=sp;
      if(sb=sp)then Break;
    end;
  end;
  Index:=sb;
  Result:=flag=0;
end;

function  T32bArray.FindFirst3(data:Pointer;var Index:Integer):Boolean;
begin
  Result:=FindFirst1(u_int32(data),Index);
end;

function  T32bArray.FindLast1(data:u_int32;var Index:Integer):Boolean;
var
  sb,se,sp,flag:Integer;
begin
  sb:=0;se:=Count-1;flag:=-1;
  while(sb<=se)do begin
    sp:=(sb+se+1) shr 1;
    flag:=data-Elems1[sp];
    if(flag>0)then sb:=sp+1
    else if(flag<0)then se:=sp-1
    else begin
      sb:=sp;
      if(se=sp)then Break;
    end;
  end;
  Index:=sb;
  Result:=flag=0;
end;

function  T32bArray.FindLast2(data:_int32;var Index:Integer):Boolean;
var
  sb,se,sp,flag:Integer;
begin
  sb:=0;se:=Count-1;flag:=-1;
  while(sb<=se)do begin
    sp:=(sb+se+1) shr 1;
    flag:=data-Elems2[sp];
    if(flag>0)then sb:=sp+1
    else if(flag<0)then se:=sp-1
    else begin
      sb:=sp;
      if(se=sp)then Break;
    end;
  end;
  Index:=sb;
  Result:=flag=0;
end;

function  T32bArray.FindLast3(data:Pointer;var Index:Integer):Boolean;
begin
  Result:=FindLast1(u_int32(data),Index);
end;

function  T32bArray.sAdd1(Value:u_int32):Integer;
begin
  Find1(Value,Result);
  Insert1(Result,1,Value);
end;
function  T32bArray.sAdd2(Value:_int32):Integer;
begin
  Find2(Value,Result);
  Insert2(Result,1,Value);
end;
function  T32bArray.sAdd3(Value:Pointer):Integer;
begin
  Find3(Value,Result);
  Insert3(Result,1,Value);
end;

function  T32bArray.sAddNoDup1(Value:u_int32):Integer;
begin
  if(not Find1(Value,Result))then Insert1(Result,1,Value);
end;
function  T32bArray.sAddNoDup2(Value:_int32):Integer;
begin
  if(not Find2(Value,Result))then Insert2(Result,1,Value);
end;
function  T32bArray.sAddNoDup3(Value:Pointer):Integer;
begin
  if(not Find3(Value,Result))then Insert3(Result,1,Value);
end;

function  T32bArray.Remove1(Value:u_int32):Integer;
begin
  Result:=IndexOf1(Value);
  if(Result>=0)then Delete(Result,1,False);
end;
function  T32bArray.Remove2(Value:_int32):Integer;
begin
  Result:=IndexOf2(Value);
  if(Result>=0)then Delete(Result,1,False);
end;
function  T32bArray.Remove3(Value:Pointer):Integer;
begin
  Result:=IndexOf3(Value);
  if(Result>=0)then Delete(Result,1,False);
end;
procedure T32bArray.RemoveAll1(Value:u_int32);
var
  id:Integer;
begin
  id:=IndexOf1(Value);
  while(id>=0)do begin
    Delete(id,1,False);
    id:=Search1(id,Value);
  end;
end;
procedure T32bArray.RemoveAll2(Value:_int32);
asm
        JMP     T32bArray.RemoveAll1
end;
procedure T32bArray.RemoveAll3(Value:Pointer);
asm
        JMP     T32bArray.RemoveAll1
end;

function  T32bArray.sRemove1(Value:u_int32):Integer;
begin
  if(Find1(Value,Result))then
    Delete(Result,1,False)
  else Result:=-1;
end;
function  T32bArray.sRemove2(Value:_int32):Integer;
begin
  if(Find2(Value,Result))then
    Delete(Result,1,False)
  else Result:=-1;
end;
function  T32bArray.sRemove3(Value:Pointer):Integer;
begin
  if(Find3(Value,Result))then
    Delete(Result,1,False)
  else Result:=-1;
end;

function  T32bArray.GetMemory(Index:Integer):Pointer;
begin
  Result:=Pointer(uInt32(Memory)+uInt32(Index shl 2));
end;

procedure T32bArray.Move(fromIndex,toIndex:Integer);
begin
  Move_32b1(Memory,Count,fromIndex,toIndex);
end;

procedure T32bArray.Sort1();
begin
  Sort_32b(Memory,Count);
end;
procedure T32bArray.Sort2();
begin
  iSort_32b(Memory,Count);
end;
procedure T32bArray.Sort3();
begin
  Sort_32b(Memory,Count);
end;

function  T32bArray.IsEmpty:Boolean;
begin
  Result:=Count=0;
end;
procedure T32bArray.Reset(ResetStorage:Boolean);
begin
  Clear(ResetStorage);
end;

function  T32bArray.GetTop1:u_int32;
begin
  Result:=Last1;
end;
function  T32bArray.GetTop2:_int32;
begin
  Result:=Last2;
end;
function  T32bArray.GetTop3:Pointer;
begin
  Result:=Last3;
end;

function  T32bArray.GetTop4():TObject;
begin
  Result:=Last3;
end;

function  T32bArray.Pop1:u_int32;
asm
        MOV     ECX,[EAX].FCount
        DEC     ECX
        JL      @@1
        MOV     [EAX].FCount,ECX
        SHL     ECX,2
        MOV     EDX,[EAX].FMemory
        MOV     EAX,[EDX+ECX]
        JMP     @@2
@@1:    XOR     EAX,EAX
@@2:
end;
function  T32bArray.Pop2:_int32;
asm
        JMP     T32bArray.Pop1
end;
function  T32bArray.Pop3:Pointer;
asm
        JMP     T32bArray.Pop1
end;

function  T32bArray.Pop4():TObject;
asm
        JMP     T32bArray.Pop1
end;

procedure T32bArray.Push1(const data:u_int32);
begin
  Add1(data);
end;
procedure T32bArray.Push2(const data:_int32);
begin
  Add2(data);
end;
procedure T32bArray.Push3(const data:Pointer);
begin
  Add3(data);
end;

procedure T32bArray.Push4(const data:TObject);
begin
  Add3(data);
end;

procedure T32bArray.Assign(Source:T32bArray);
begin
  if(Source=nil)or(Source=Self)then Exit;
  if(Capacity<Source.Count)then Clear(True);
  AdjustCount(Source.Count,False);
  if(Count>0)then
    System.Move(Source.Memory^,Memory^,DataSize);
end;

function  T32bArray.Compare(Source:T32bArray):Boolean;
begin
  if(Source=nil)then begin
    Result:=False;Exit;
  end;
  if(Count<>Source.Count)then begin
    Result:=False;Exit;
  end;
  Result:=Compare_32b(Source.Memory,Memory,Count)=0;
end;

procedure T32bArray.CopyFrom(Source:T32bArray;FromIndex,ToIndex,CopyCount:Integer);
begin
  if(FromIndex<0)or(FromIndex>=Source.Count)then Exit;
  if(CopyCount=0)or(CopyCount+FromIndex>Source.Count)then
      CopyCount:=Source.Count-FromIndex;
  if(ToIndex<0)or(ToIndex>=Count)then Exit;
  if(ToIndex+CopyCount>Count)then
    Count:=ToIndex+CopyCount;
  if(CopyCount>0)then
    System.Move(
          Pointer(uInt32(Source.Memory)+uInt32(FromIndex shl 2))^,
          Pointer(uInt32(Memory)+uInt32(ToIndex shl 2))^,
          CopyCount shl 2);
end;

function T32bArray.CountDistinctValue: Integer;
var
  Arr:T32bArray;
begin
  Result:=Count;
  if(Result<=1)then Exit;
  Arr:=T32bArray.Create(Result);
  try
    ListDistinctValue(Arr);
    Result:=Arr.Count;
  finally
    Arr.Free;
  end;
end;

procedure T32bArray.ListDistinctValue(toArr:T32bArray);
var
  I:Integer;
begin
  toArr.Clear(False);
  for I:=0 to Count-1 do begin
    toArr.sAddNoDup1(Elems1[I]);
  end;
end;

procedure T32bArray.RemoveDuplicateValues;
var
  Arr:T32bArray;
begin
  if(Count>1)then begin
    Arr:=T32bArray.Create();
    try
      Arr.Assign(Self);
      Arr.ListDistinctValue(Self);
    finally
      Arr.Free;
    end;
  end;
end;

procedure T32bArray.IncElem(Index:Integer);
asm
    CMP     Index,[EAX].FCount
    JNB     @@1
    MOV     EAX,[EAX].FMemory
    INC     DWORD PTR [EAX]+EDX*4
@@1:
end;

procedure T32bArray.DecElem(Index:Integer);
asm
    CMP     Index,[EAX].FCount
    JNB     @@1
    MOV     EAX,[EAX].FMemory
    INC     DWORD PTR [EAX]+EDX*4
@@1:
end;

end.
