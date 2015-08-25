unit DbBase;

interface

uses SysUtils,Classes,DbLib,ShareLib,ShareWin;

type
  EDbError=class(Exception);
  TDbCursor=class
  private
    FActiveBuffer:Pointer;
    FOffsets:TCommonArray;
    FDataSizes:TCommonArray;
    function GetFieldCount: Integer;
    function GetOffset(Index: Integer): Integer;
    function GetDataSizes(Index: Integer): Integer;
    procedure SetActiveBuffer(Buffer:Pointer);
    function GetDataBuffer(Index: Integer): Pointer;
  protected
    function AddField(Offset,Size:Integer):Integer;
    procedure DelField(Index:Integer);

    procedure SetFieldCount(const Value: Integer);
    procedure SetOffset(Index: Integer; const Value: Integer);
    procedure SetDataSizes(Index: Integer; const Value: Integer);
  public
    constructor Create;
    destructor Destroy;override;

    property ActiveBuffer:Pointer read FActiveBuffer write SetActiveBuffer;
    property FieldCount:Integer read GetFieldCount;
    property Offset[Index:Integer]:Integer read GetOffset;
    property DataSize[Index:Integer]:Integer read GetDataSizes;
    property DataBuffer[Index:Integer]:Pointer read GetDataBuffer;
  public
    function  AsBoolean(Index:Integer):Boolean;
    procedure GetBoolean(Index:Integer;var Value:Boolean);
    procedure SetBoolean(Index:Integer;Value:Boolean);
    
    function  AsByte(Index:Integer):Byte;
    procedure GetByte(Index:Integer;var Value:Byte);
    procedure SetByte(Index:Integer;const Value:Byte);

    function  AsInteger(Index:Integer):LongInt;
    procedure GetInteger(Index:Integer;var Value:LongInt);
    procedure SetInteger(Index:Integer;const Value:LongInt);

    function  AsDouble(Index:Integer):Double;
    procedure GetDouble(Index:Integer;var Value:Double);
    procedure SetDouble(Index:Integer;const Value:Double);

    function  AsCurrency(Index:Integer):Currency;
    procedure GetCurrency(Index:Integer;var Value:Currency);
    procedure SetCurrency(Index:Integer;const Value:Currency);

    function  AsDateTime(Index:Integer):TDateTime;
    procedure GetDateTime(Index:Integer;var Value:TDateTime);
    procedure SetDateTime(Index:Integer;const Value:TDateTime);

    function  GetPChar(Index:Integer;Value:PChar):Integer;
    procedure SetPChar(Index:Integer;Value:PChar);

    function  GetString(Index:Integer):string;
    procedure SetString(Index:Integer;const Value:string);

    function  GetPChar1(Index:Integer;Value:PChar):Integer;
    procedure SetPChar1(Index:Integer;Value:PChar);

    function  GetString1(Index:Integer):string;
    procedure SetString1(Index:Integer;const Value:string);

    function  AsNumber(Index:Integer):LongInt;
    procedure GetNumber(Index:Integer;var Value:LongInt);
    procedure SetNumber(Index:Integer;Value:LongInt);

    function  AsFloat(Index:Integer):Double;
    procedure GetFloat(Index:Integer;var Value:Double);
    procedure SetFloat(Index:Integer;const Value:Double);
  public
    procedure GetData(Index:Integer;var Value);overload;
    procedure GetData(Indexes:TCommonArray;var Value);overload;
    procedure GetData(Indexes:array of Integer;var Value);overload;
    procedure SetData(Index:Integer;const Value);overload;
    procedure SetData(Indexes:array of Integer;const Value);overload;
    procedure CopyValue(Source:TDbCursor;FromIndex,ToIndex:Integer);
    procedure CopyValues(Source:TDbCursor;IndexMaps:TCommonArray);

    procedure ReadValue(Stream:TStream;Index:Integer);overload;
    procedure ReadValue(Stream:TStream;Indexes:TCommonArray);overload;
    procedure ReadValue(Stream:TStream;Indexes:array of Integer);overload;
    procedure WriteValue(Stream:TStream;Index:Integer);overload;
    procedure WriteValue(Stream:TStream;Indexes:TCommonArray);overload;
    procedure WriteValue(Stream:TStream;Indexes:array of Integer);overload;
  end;

  TRecordsBuffer=class
  private
    FRecordList:TCommonArray;
    FDeleteList:TCommonArray;
    FRecordSize: Integer;
    procedure SetRecordSize(const Value: Integer);
    function GetRecordCount: Integer;
    procedure SetRecordCount(const Value: Integer);
    function GetRecBuffer(Index: Integer): Pointer;
  protected
    function  AllocBuffer(nSize:Integer):Pointer;virtual;
    procedure FreeBuffer(Buffer:Pointer);virtual;
    function  AllocRecord:Pointer;virtual;
    procedure FreeRecord(Buffer:Pointer);virtual;

    property DeleteList:TCommonArray read FDeleteList;
  public
    constructor Create;
    destructor Destroy;override;

    procedure Clear;virtual;
    function AddRecord:Pointer;
    function InsRecord(Index:Integer):Pointer;
    procedure DelRecord(Index:Integer);overload;
    procedure DelRecord(Buffer:Pointer);overload;
    procedure DeleteRecord(Index:Integer);
    procedure PackBuffers;

    property RecordSize:Integer read FRecordSize write SetRecordSize;
    property RecordList:TCommonArray read FRecordList;
    property RecordCount:Integer read GetRecordCount write SetRecordCount;
    property RecBuffer[Index:Integer]:Pointer read GetRecBuffer;default;
  end;

type
  TFieldType=(ftString,ftInteger,ftBoolean,ftFloat,ftCurrency,ftDateTime);
  TMemIndexField=record
    DataType        :TFieldType;
    DataSize        :Integer;
    Descending      :Boolean;
    CaseSensitive   :Boolean;
  end;
  TMemIndexFields=array of TMemIndexField;
  TMemIndex=class
  private
    FKeys:TCommonArray;
    FMemMgr:TMiniMemAllocator;
    FKeyLength:Integer;
    FKeyBuffer:Pointer;
    procedure ExtractKeyFields;
    function GetCount:Integer;
    function GetData(Index:Integer):Integer;
    function GetCapacity: Integer;
    procedure SetCapacity(const Value: Integer);
  protected
    function Compare(Key1,Key2:Pointer):Integer;
  public
    IndexFields:TMemIndexFields;
    constructor Create;
    destructor Destroy;override;

    procedure Reset;
    procedure Insert(Index:Integer;KeyBuffer:Pointer;Data:Integer);
    function  Find(KeyBuffer:Pointer;var Index:Integer):Boolean;
    function  FindFirst(KeyBuffer:Pointer;var Index:Integer):Boolean;
    function  FindLast(KeyBuffer:Pointer;var Index:Integer):Boolean;

    property Count:Integer read GetCount;
    property Data[Index:Integer]:Integer read GetData;
    property KeyLength:Integer read FKeyLength;
    property KeyBuffer:Pointer read FKeyBuffer;
    property Capacity:Integer read GetCapacity write SetCapacity;
  end;
const
  FieldSizes:array[TFieldType] of Integer=
    (0,4,1,8,8,8);

function  DSGetStringValue1(Buffer:PChar;Len:Integer):string;
procedure DSSetStringValue1(Buffer:PChar;Len:Integer;const Value:string);
function  DSGetPCharValue1(Buffer:PChar;Len:Integer;Value:Pchar):Integer;
procedure DSSetPCharValue1(Buffer:PChar;Len:Integer;const Value:PChar);

implementation

function  DSGetStringValue1(Buffer:PChar;Len:Integer):string;
var
  p:PChar;
  SaveChar:Char;
begin
  Assert(Len>0);

  p:=Buffer+Len-1;
  SaveChar:=Buffer[0];Buffer[0]:=#0;//not 32
  while(p^=#32)do Dec(p);
  Buffer[0]:=SaveChar;Len:=p-Buffer+1;
  if(Len=1)and(SaveChar=#32)then Dec(Len);

  SetString(Result,Buffer,Len);
end;

procedure DSSetStringValue1(Buffer:PChar;Len:Integer;const Value:string);
var
  sl:Integer;
begin
  Assert(Len>0);

  sl:=Length(Value);
  if(sl>Len)then sl:=Len;
  if(sl>0)then
    System.Move(Pointer(Value)^,Buffer^,sl);
  for sl:=sl to Len-1 do Buffer[sl]:=#32;
end;

function  DSGetPCharValue1(Buffer:PChar;Len:Integer;Value:Pchar):Integer;
var
  p:PChar;
  SaveChar:Char;
begin
  Assert(Len>0);

  p:=Buffer+Len-1;
  SaveChar:=Buffer[0];Buffer[0]:=#0;//not 32
  while(p^=#32)do Dec(p);
  Buffer[0]:=SaveChar;Len:=p-Buffer+1;
  if(Len=1)and(SaveChar=#32)then Dec(Len);

  StrLCopy(Value,Buffer,Len);
  Result:=Len;
end;

procedure DSSetPCharValue1(Buffer:PChar;Len:Integer;const Value:PChar);
var
  sl:Integer;
begin
  Assert(Len>0);

  sl:=strLen(Value);
  if(sl>Len)then sl:=Len;
  if(sl>0)then
    System.Move(Pointer(Value)^,Buffer^,sl);
  for sl:=sl to Len-1 do Buffer[sl]:=#32;
end;

{ TDbCursor }

constructor TDbCursor.Create;
begin
  inherited Create;
  FOffsets:=TCommonArray.Create;
  FDataSizes:=TCommonArray.Create;
end;

destructor TDbCursor.Destroy;
begin
  inherited;
  FOffsets.Free;
  FDataSizes.Free;
end;

procedure TDbCursor.SetActiveBuffer(Buffer: Pointer);
begin
  FActiveBuffer:=Buffer;
end;

function TDbCursor.GetFieldCount: Integer;
begin
  Result:=FOffsets.Count;
end;

procedure TDbCursor.SetFieldCount(const Value: Integer);
begin
  FOffsets.Count:=Value;
  FDataSizes.Count:=Value;
end;

function TDbCursor.GetOffset(Index: Integer): Integer;
begin
  Result:=FOffsets.Elems2[Index];
end;

procedure TDbCursor.SetOffset(Index: Integer; const Value: Integer);
begin
  Assert(Value>=0);
  FOffsets.Elems2[Index]:=Value;
end;

function TDbCursor.GetDataSizes(Index: Integer): Integer;
begin
  Result:=FDataSizes.Elems2[Index];
end;

procedure TDbCursor.SetDataSizes(Index: Integer; const Value: Integer);
begin
  Assert(Value>=0);
  FDataSizes.Elems2[Index]:=Value;
end;

function TDbCursor.GetDataBuffer(Index: Integer): Pointer;
begin
  Result:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
end;

function TDbCursor.AddField(Offset, Size: Integer): Integer;
begin
  Assert((Offset>=0)and(Size>=0));
  Result:=FOffsets.Add2(Offset);
  FDataSizes.Add2(Size);
end;

procedure TDbCursor.DelField(Index: Integer);
begin
  FOffsets.Delete(Index,1);
  FDataSizes.Delete(Index,1);
end;

procedure TDbCursor.GetData(Index:Integer;var Value);
begin
  System.Move(Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index])^,Value,FDataSizes.Elems2[Index]);
end;

procedure TDbCursor.GetData(Indexes:TCommonArray;var Value);
var
  Offset:Cardinal;
  I,Index,Size:Integer;
begin
  Offset:=0;
  for I:=0 to Indexes.Count-1 do begin
    Index:=Indexes.Elems2[I];Size:=FDataSizes.Elems2[Index];
    System.Move(Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index])^,
                Pointer(Cardinal(@Value)+Offset)^,
                Size);
    Inc(Offset,Size);
  end;
end;

procedure TDbCursor.GetData(Indexes:array of Integer;var Value);
var
  Offset:Cardinal;
  I,Index,Size:Integer;
begin
  Offset:=0;
  for I:=Low(Indexes) to High(Indexes) do begin
    Index:=Indexes[I];Size:=FDataSizes.Elems2[Index];
    System.Move(Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index])^,
                Pointer(Cardinal(@Value)+Offset)^,
                Size);
    Inc(Offset,Size);
  end;
end;

procedure TDbCursor.SetData(Index:Integer;const Value);
begin
  System.Move(Value,Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index])^,FDataSizes.Elems2[Index]);
end;

procedure TDbCursor.SetData(Indexes:array of Integer;const Value);
var
  Offset:Cardinal;
  I,Index,Size:Integer;
begin
  Offset:=0;
  for I:=Low(Indexes) to High(Indexes) do
  begin
    Index:=Indexes[I];Size:=FDataSizes.Elems2[Index];
    System.Move(Pointer(Cardinal(@Value)+Offset)^,
                Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index])^,
                Size);
    Inc(Offset,Size);
  end;
end;

procedure TDbCursor.CopyValue(Source:TDbCursor;FromIndex,ToIndex:Integer);
begin
  System.Move(Source.DataBuffer[FromIndex]^,
              Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[ToIndex])^,
              FDataSizes.Elems2[ToIndex]);
end;

procedure TDbCursor.CopyValues(Source:TDbCursor;IndexMaps:TCommonArray);
var
  I,Index:Integer;
begin
  for I:=0 to IndexMaps.Count-1 do begin
    Index:=IndexMaps.Elems2[I];
    if(Index<0)then Continue;
    System.Move(Source.DataBuffer[Index]^,
              Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[I])^,
              FDataSizes.Elems2[I]);
  end;
end;

procedure TDbCursor.ReadValue(Stream:TStream;Index:Integer);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Stream.Read(Buffer^,FDataSizes.Elems2[Index]);
end;

procedure TDbCursor.WriteValue(Stream:TStream;Index:Integer);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Stream.Write(Buffer^,FDataSizes.Elems2[Index]);
end;

procedure TDbCursor.ReadValue(Stream:TStream;Indexes:TCommonArray);
var
  Buffer:Pointer;
  I,Index:Integer;
begin
  for I:=0 to Indexes.Count-1 do begin
    Index:=Indexes.Elems2[I];
    Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
    Stream.Read(Buffer^,FDataSizes.Elems2[Index]);
  end;
end;

procedure TDbCursor.ReadValue(Stream:TStream;Indexes:array of Integer);
var
  Buffer:Pointer;
  I,Index:Integer;
begin
  for I:=Low(Indexes) to High(Indexes) do begin
    Index:=Indexes[I];
    Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
    Stream.Read(Buffer^,FDataSizes.Elems2[Index]);
  end;
end;

procedure TDbCursor.WriteValue(Stream:TStream;Indexes:TCommonArray);
var
  Buffer:Pointer;
  I,Index:Integer;
begin
  for I:=0 to Indexes.Count-1 do begin
    Index:=Indexes.Elems2[I];
    Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
    Stream.Write(Buffer^,FDataSizes.Elems2[Index]);
  end;
end;

procedure TDbCursor.WriteValue(Stream:TStream;Indexes:array of Integer);
var
  Buffer:Pointer;
  I,Index:Integer;
begin
  for I:=Low(Indexes) to High(Indexes) do begin
    Index:=Indexes[I];
    Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
    Stream.Write(Buffer^,FDataSizes.Elems2[Index]);
  end;
end;

function  TDbCursor.AsBoolean(Index:Integer):Boolean;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=Byte(Buffer^)<>0;
end;

procedure TDbCursor.GetBoolean(Index:Integer;var Value:Boolean);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Value:=Byte(Buffer^)<>0;
end;

procedure TDbCursor.SetBoolean(Index:Integer;Value:Boolean);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Byte(Buffer^):=Ord(Value);
end;

function  TDbCursor.AsByte(Index:Integer):Byte;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=Byte(Buffer^);
end;

procedure TDbCursor.GetByte(Index:Integer;var Value:Byte);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Value:=Byte(Buffer^);
end;

procedure TDbCursor.SetByte(Index:Integer;const Value:Byte);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Byte(Buffer^):=Value;
end;


function  TDbCursor.AsInteger(Index:Integer):LongInt;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=LongInt(Buffer^);
end;

procedure TDbCursor.GetInteger(Index:Integer;var Value:LongInt);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Value:=LongInt(Buffer^);
end;

procedure TDbCursor.SetInteger(Index:Integer;const Value:LongInt);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  LongInt(Buffer^):=Value;
end;


function  TDbCursor.AsDouble(Index:Integer):Double;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=Double(Buffer^);
end;

procedure TDbCursor.GetDouble(Index:Integer;var Value:Double);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  CopyDouble(Buffer^,Value);
end;

procedure TDbCursor.SetDouble(Index:Integer;const Value:Double);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  CopyDouble(Pointer(@Value)^,Buffer^);
end;


function  TDbCursor.AsCurrency(Index:Integer):Currency;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=Currency(Buffer^);
end;

procedure TDbCursor.GetCurrency(Index:Integer;var Value:Currency);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  CopyDouble(Buffer^,Value);
end;

procedure TDbCursor.SetCurrency(Index:Integer;const Value:Currency);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  CopyDouble(Pointer(@Value)^,Buffer^);
end;


function  TDbCursor.AsDateTime(Index:Integer):TDateTime;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=TDateTime(Buffer^);
end;

procedure TDbCursor.GetDateTime(Index:Integer;var Value:TDateTime);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  CopyDateTime(Buffer^,Value);
end;

procedure TDbCursor.SetDateTime(Index:Integer;const Value:TDateTime);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  CopyDateTime(Pointer(@Value)^,Buffer^);
end;

function  TDbCursor.GetPChar(Index:Integer;Value:PChar):Integer;
var
  Buffer:PChar;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=StrLen(Buffer);
  System.Move(Buffer^,Value^,Result);
  Value[Result]:=#0;
end;

procedure TDbCursor.SetPChar(Index:Integer;Value:PChar);
var
  Buffer:PChar;
  I,sLen,MaxLen:Integer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  MaxLen:=DataSize[Index];
  sLen:=StrLen(Value);
  if(sLen>=MaxLen)then sLen:=MaxLen-1;
  System.Move(Value^,Buffer^,sLen);
  for I:=sLen to MaxLen-1 do Buffer[I]:=#0;
end;

function  TDbCursor.GetString(Index:Integer):string;
var
  Buffer:PChar;
  sLen:Integer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  sLen:=StrLen(Buffer);
  System.SetString(Result,Buffer,sLen);
end;

procedure TDbCursor.SetString(Index:Integer;const Value:string);
var
  Buffer:PChar;
  I,sLen,MaxLen:Integer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  MaxLen:=DataSize[Index];
  sLen:=Length(Value);
  if(sLen>=MaxLen)then sLen:=MaxLen-1;
  System.Move(Pointer(Value)^,Buffer^,sLen);
  for I:=sLen to MaxLen-1 do Buffer[I]:=#0;
end;


function  TDbCursor.GetPChar1(Index:Integer;Value:PChar):Integer;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=DSGetPCharValue1(Buffer,FDataSizes.Elems2[Index],Value);
end;

procedure TDbCursor.SetPChar1(Index:Integer;Value:PChar);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  DSSetPCharValue1(Buffer,FDataSizes.Elems2[Index],Value);
end;

function  TDbCursor.GetString1(Index:Integer):string;
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  Result:=DSGetStringValue1(Buffer,FDataSizes.Elems2[Index]);
end;

procedure TDbCursor.SetString1(Index:Integer;const Value:string);
var
  Buffer:Pointer;
begin
  Buffer:=Pointer(Cardinal(ActiveBuffer)+FOffsets.Elems1[Index]);
  DSSetStringValue1(Buffer,FDataSizes.Elems2[Index],Value);
end;

function  TDbCursor.AsNumber(Index:Integer):LongInt;
var
  sNumber:string;
begin
  sNumber:=GetString1(Index);
  Result:=NumberToInteger(sNumber);
end;

procedure TDbCursor.GetNumber(Index:Integer;var Value:LongInt);
begin
  Value:=AsNumber(Index);
end;

procedure TDbCursor.SetNumber(Index:Integer;Value:LongInt);
begin
  SetString1(Index,IntToStr(Value));
end;

function  TDbCursor.AsFloat(Index:Integer):Double;
begin
  GetFloat(Index,Result);
end;

procedure TDbCursor.GetFloat(Index:Integer;var Value:Double);
var
  sNumber:string;
begin
  sNumber:=GetString1(Index);
  Value:=NumberToFloat(sNumber);
end;

procedure TDbCursor.SetFloat(Index:Integer;const Value:Double);
begin
  SetString1(Index,FloatToStr(Value));
end;

{ TRecordsBuffer }

constructor TRecordsBuffer.Create;
begin
  inherited Create;
  FRecordList:=TCommonArray.Create;
  FDeleteList:=TCommonArray.Create;
end;

destructor TRecordsBuffer.Destroy;
begin
  Clear;
  inherited;
  FRecordList.Free;
  FDeleteList.Free;
end;

procedure TRecordsBuffer.SetRecordSize(const Value: Integer);
begin
  Assert(Value>0);
  if(Value=FRecordSize)then Exit;
  Assert(RecordList.Count=0);

  if(DeleteList.Count>0)then PackBuffers();
  FRecordSize := Value;
end;

function  TRecordsBuffer.AllocBuffer(nSize:Integer):Pointer;
begin
  GetMem(Result,nSize)
end;

procedure TRecordsBuffer.FreeBuffer(Buffer: Pointer);
begin
  FreeMem(Buffer);
end;

function TRecordsBuffer.AllocRecord:Pointer;
begin
  if(DeleteList.IsEmpty)then
    Result:=AllocBuffer(RecordSize)
  else Result:=DeleteList.Pop3;
end;

procedure TRecordsBuffer.FreeRecord(Buffer:Pointer);
begin
  DeleteList.Push3(Buffer);
end;

function TRecordsBuffer.GetRecBuffer(Index: Integer): Pointer;
begin
  Result:=RecordList[Index];
end;

function TRecordsBuffer.AddRecord: Pointer;
begin
  Result:=InsRecord(RecordList.Count);
end;

function TRecordsBuffer.InsRecord(Index: Integer): Pointer;
begin
  Result:=AllocRecord;
  RecordList.Insert3(Index,1,Result);
end;

procedure TRecordsBuffer.DelRecord(Index: Integer);
var
  Buffer:Pointer;
begin
  Buffer:=RecordList[Index];
  RecordList.Delete(Index,1);
  FreeRecord(Buffer);
end;

procedure TRecordsBuffer.DelRecord(Buffer:Pointer);
begin
  RecordList.Remove3(Buffer);
  FreeRecord(Buffer);
end;

procedure TRecordsBuffer.DeleteRecord(Index:Integer);
var
  Buffer:Pointer;
begin
  Buffer:=RecordList[Index];
  RecordList.Delete(Index,1);
  FreeBuffer(Buffer);
end;

function TRecordsBuffer.GetRecordCount: Integer;
begin
  Result:=RecordList.Count;
end;

procedure TRecordsBuffer.SetRecordCount(const Value: Integer);
var
  I:Integer;
begin
  for I:=RecordList.Count-1 downto Value do
    DelRecord(I);

  for I:=RecordList.Count to Value-1 do
    InsRecord(I);
end;

procedure TRecordsBuffer.PackBuffers;
begin
  while(not DeleteList.IsEmpty)do
    FreeBuffer(DeleteList.Pop3);
end;

procedure TRecordsBuffer.Clear;
begin
  PackBuffers;
  while(not RecordList.IsEmpty)do
    FreeBuffer(RecordList.Pop3);
end;

{ TMemIndex }

function CompareDouble(P1,P2:Pointer):Integer;
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
function CompareCurrency(P1,P2:Pointer):Integer;
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

constructor TMemIndex.Create;
begin
  inherited Create;
  FKeys:=TCommonArray.Create(256);
  FMemMgr:=TMiniMemAllocator.Create;
end;

destructor TMemIndex.Destroy;
begin
  FMemMgr.Free;
  FKeys.Free;
  inherited;
end;

procedure TMemIndex.Reset;
begin
  FKeyBuffer:=nil;
  FKeys.Reset;
  FMemMgr.FreeAll;
  ExtractKeyFields;
  FKeyBuffer:=FMemMgr.AllocMem(FKeyLength+1);
end;

procedure TMemIndex.ExtractKeyFields;
var
  I,S:Integer;
begin
  FKeyLength:=0;
  for I:=Low(IndexFields) to High(IndexFields) do
  begin
    S:=FieldSizes[IndexFields[I].DataType];
    if(S=0)then
      Inc(FKeyLength,IndexFields[I].DataSize)
    else begin
      Inc(FKeyLength,S);
      IndexFields[I].DataSize:=S;
    end;
  end;
end;

function TMemIndex.Compare(Key1,Key2:Pointer):Integer;
var
  I:Integer;
begin
  for I:=Low(IndexFields) to High(IndexFields) do
  with IndexFields[I] do
  begin
    case DataType of
      ftString:
        if(not CaseSensitive)then
          Result:=AnsiStrLIComp0(Key1,Key2,DataSize)
        else Result:=AnsiStrLComp0(Key1,Key2,DataSize);
      ftInteger:Result:=Integer(Key1^)-Integer(Key2^);
      ftBoolean:Result:=Byte(Key1^)-Byte(Key2^);
      ftFloat,ftDateTime:Result:=CompareDouble(Key1,Key2);
      ftCurrency:Result:=CompareCurrency(Key1,Key2);
      else raise EDbError.Create('不可识别的类型');
    end;
    if(Result<>0)then
    begin
      if(Descending)then Result:=-Result;
      Exit;
    end;
    Inc(Integer(Key1),DataSize);
    Inc(Integer(Key2),DataSize);
  end;
  Result:=0;
end;

function TMemIndex.GetCount:Integer;
begin
  Result:=FKeys.Count;
end;

function TMemIndex.GetCapacity: Integer;
begin
  Result:=FKeys.Capacity;
end;

procedure TMemIndex.SetCapacity(const Value: Integer);
begin
  FKeys.Capacity:=Value;
end;

function TMemIndex.GetData(Index:Integer):Integer;
begin
  Result:=Integer(FKeys.Elems3[Index]^);
end;

procedure TMemIndex.Insert(Index:Integer;KeyBuffer:Pointer;Data:Integer);
var
  NewKey:Pointer;
begin
  Assert(FKeyLength>0,'索引字段信息错误');

  NewKey:=FMemMgr.AllocMem(sizeof(Integer)+FKeyLength);
  FKeys.Insert3(Index,1,NewKey);

  Integer(NewKey^):=Data;
  Inc(Integer(NewKey),sizeof(Integer));
  System.Move(KeyBuffer^,NewKey^,FKeyLength);
end;

function TMemIndex.Find(KeyBuffer:Pointer;var Index:Integer):Boolean;
var
  sb,se,sp,flag:Integer;
begin
  flag:=-1;
  sb:=0;se:=FKeys.Count-1;
  while(sb<=se)do
  begin
    sp:=(sb+se) shr 1;
    flag:=Compare(KeyBuffer,Pointer(FKeys.Elems1[sp]+sizeof(Integer)));
    if(flag>0)then sb:=sp+1
    else if(flag<0)then se:=sp-1
    else begin
      sb:=sp;
      Break;
    end;
  end;
  Index:=sb;
  Result:=flag=0;
end;

function TMemIndex.FindFirst(KeyBuffer:Pointer;var Index:Integer):Boolean;
var
  sb,se,sp,flag:Integer;
begin
  flag:=-1;
  sb:=0;se:=FKeys.Count-1;
  while(sb<=se)do
  begin
    sp:=(sb+se) shr 1;
    flag:=Compare(KeyBuffer,Pointer(FKeys.Elems1[sp]+sizeof(Integer)));
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

function TMemIndex.FindLast(KeyBuffer: Pointer; var Index: Integer): Boolean;
var
  sb,se,sp,flag:Integer;
begin
  flag:=-1;
  sb:=0;se:=FKeys.Count-1;
  while(sb<=se)do
  begin
    sp:=(sb+se+1) shr 1;
    flag:=Compare(KeyBuffer,Pointer(FKeys.Elems1[sp]+sizeof(Integer)));
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


end.
