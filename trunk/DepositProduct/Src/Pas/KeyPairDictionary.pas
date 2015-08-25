unit KeyPairDictionary;

interface


uses Classes,Windows,SysUtils;

type
  EDictionaryException=class(Exception);
  PKeyPointerPair=^TKeyPointerPair;
  TKeyPointerPair=record
    Key:string;
    Value:Pointer;
    Object_:TObject;
  end;
  PKeyPointerPairList=^TKeyPointerPairList;
  TKeyPointerPairList=array[0..MaxInt div SizeOf(TKeyPointerPair)-1]of TKeyPointerPair ;

  PKeyIntPair=^TKeyIntPair;
  TKeyIntPair=record
    Key:string;
    Value:Integer;
    Object_:TObject;
  end;

  PKeyIntPairList=^TKeyIntPairList;
  TKeyIntPairList=array[0..MaxInt div SizeOf(TKeyIntPair)-1]of TKeyIntPair ;

  PKeyFloatPair=^TKeyFloatPair;
  TKeyFloatPair=record
    Key:string;
    Value:Double;
    Object_:TObject;
  end;

  PKeyFloatPairList=^TKeyFloatPairList;
  TKeyFloatPairList=array[0..MaxInt div SizeOf(TKeyFloatPair)-1]of TKeyFloatPair ;

  PKeyStringPair=^TKeyStringPair;
  TKeyStringPair=record
    Key:string;
    Value:string;
    Object_:TObject;
  end;

  PKeyStringPairList=^TKeyStringPairList;
  TKeyStringPairList=array[0..MaxInt div SizeOf(TKeyStringPair)-1]of TKeyStringPair ;

  PKeyDateTimePair=^TKeyDateTimePair;
  TKeyDateTimePair=record
    Key:string;
    Value:TDateTime;
    Object_:TObject;
  end;

  PKeyDateTimePairList=^TKeyDateTimePairList;
  TKeyDateTimePairList=array[0..MaxInt div SizeOf(TKeyDateTimePair)-1]of TKeyDateTimePair ;
  
  
  TKeyPointerDictionary=class(TComponent)
  private
    FMemory: PKeyPointerPairList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TKeyPointerPair;
    function GetKeys(Index: Integer): String;
    function GetObjects(Index: Integer): TObject;
    function GetValues(Index: Integer): Pointer;
    procedure SetKeys(Index: Integer; const Value: String);
    procedure SetObjects(Index: Integer; const Value: TObject);
    procedure SetValues(Index: Integer; const Value: Pointer);
    function GetSorted: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure InsertItem(Index:Integer;const AKey:string;const AValue:Pointer;OBJ:TObject);
    function GetNodeSize: Integer;
  protected
    function Grow(const NewCount:Integer):Integer;virtual;
    function ValidIndex(Index:Integer):Boolean;
    procedure QuickSort(L,R:Integer);
    function CompareStrings(const S1, S2: string): Integer;
    property List:PKeyPointerPairList read FMemory;
    property NodeSize:Integer read GetNodeSize;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;virtual;
    procedure Sort;
    function Add(const Key:string;const Value:Pointer):Integer;overload;virtual;
    function Add(const Key:string;const Value:Pointer;OBJ:TObject):Integer;overload;virtual;
    procedure Insert(Index:Integer;const Key:string;const Value:Pointer);overload;virtual;
    procedure Insert(Index:Integer;const Key:string;const Value:Pointer;OBJ:TObject);overload;virtual;
    procedure Delete(Index:Integer);
    procedure Exchange(const OneIndex,TwoIndex:Integer);
    procedure Move(const OldIndex,NewIndex:Integer);
    procedure RemoveDuplicateValues;virtual;
    function IndexOf(const Key:string):Integer;
    function Find(const Key:string;var Index:Integer):Boolean;
    function FindLast(
      const Key:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function FindFirst(
      const Key:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function Search(
      const Key:string;
      var Index:Integer;
      const StartIndex:Integer;
      const EndIndex:Integer):Boolean;
    function ValueByKey(Key:string):Pointer;
    property Count:Integer read GetCount;
    property Items[Index:Integer]:TKeyPointerPair read GetItems;default;
    property Keys[Index:Integer]:String read GetKeys write SetKeys;
    property Values[Index:Integer]:Pointer read GetValues write SetValues;
    property Objects[Index:Integer]:TObject read GetObjects write SetObjects;
    property Sorted:Boolean read GetSorted write SetSorted;
    property CaseSensitive:Boolean read FCaseSensitive write FCaseSensitive;
  end;

  TKeyIntDictionary=class(TComponent)
  private
    FList: PKeyIntPairList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TKeyIntPair;
    function GetNames(Index: Integer): String;
    function GetObjects(Index: Integer): TObject;
    function GetValues(Index: Integer): Integer;
    procedure SetNames(Index: Integer; const Value: String);
    procedure SetObjects(Index: Integer; const Value: TObject);
    procedure SetValues(Index: Integer; const Value: Integer);
    function GetSorted: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure InsertItem(Index:Integer;const AName:string;const AValue:Integer;OBJ:TObject);
    function GetNodeSize: Integer;
  protected
    function Grow(const NewCount:Integer):Integer;virtual;
    function ValidIndex(Index:Integer):Boolean;
    procedure QuickSort(L,R:Integer);
    function CompareStrings(const S1, S2: string): Integer;
    property NodeSize:Integer read GetNodeSize;
    property List:PKeyIntPairList read FList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;virtual;
    procedure Sort;
    function Add(const Name:string;const Value:Integer):Integer;overload;virtual;
    function Add(const Name:string;const Value:Integer;OBJ:TObject):Integer;overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:Integer);overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:Integer;OBJ:TObject);overload;virtual;
    procedure Delete(Index:Integer);
    procedure Exchange(const OneIndex,TwoIndex:Integer);
    procedure Move(const OldIndex,NewIndex:Integer);
    procedure RemoveDuplicateValues;virtual;
    function IndexOf(const Name:string):Integer;
    function Find(const Name:string;var Index:Integer):Boolean;
    function FindLast(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function FindFirst(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function Search(
      const Name:string;
      var Index:Integer;
      const StartIndex:Integer;
      const EndIndex:Integer):Boolean;
    function ValueByName(Name:string):Integer;
    property Count:Integer read GetCount;
    property Items[Index:Integer]:TKeyIntPair read GetItems;default;
    property Names[Index:Integer]:String read GetNames write SetNames;
    property Values[Index:Integer]:Integer read GetValues write SetValues;
    property Objects[Index:Integer]:TObject read GetObjects write SetObjects;
    property Sorted:Boolean read GetSorted write SetSorted;
    property CaseSensitive:Boolean read FCaseSensitive write FCaseSensitive;
  end;

  
  TKeyFloatDictionary=class(TComponent)
  private
    FList: PKeyFloatPairList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TKeyFloatPair;
    function GetNames(Index: Integer): String;
    function GetObjects(Index: Integer): TObject;
    function GetValues(Index: Integer): Double;
    procedure SetNames(Index: Integer; const Value: String);
    procedure SetObjects(Index: Integer; const Value: TObject);
    procedure SetValues(Index: Integer; const Value: Double);
    function GetSorted: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure InsertItem(Index:Integer;const AName:string;const AValue:Double;OBJ:TObject);
    function GetNodeSize: Integer;
  protected
    function Grow(const NewCount:Integer):Integer;virtual;
    function ValidIndex(Index:Integer):Boolean;
    procedure QuickSort(L,R:Integer);
    function CompareStrings(const S1, S2: string): Integer;
    property NodeSize:Integer read GetNodeSize;
    property List:PKeyFloatPairList read FList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;virtual;
    procedure Sort;
    function Add(const Name:string;const Value:Double):Integer;overload;virtual;
    function Add(const Name:string;const Value:Double;OBJ:TObject):Integer;overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:Double);overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:Double;OBJ:TObject);overload;virtual;
    procedure Delete(Index:Integer);
    procedure Exchange(const OneIndex,TwoIndex:Integer);
    procedure Move(const OldIndex,NewIndex:Integer);
    procedure RemoveDuplicateValues;virtual;
    function IndexOf(const Name:string):Integer;
    function Find(const Name:string;var Index:Integer):Boolean;
    function FindLast(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function FindFirst(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function Search(
      const Name:string;
      var Index:Integer;
      const StartIndex:Integer;
      const EndIndex:Integer):Boolean;
    function ValueByName(Name:string):Double;
    property Count:Integer read GetCount;
    property Items[Index:Integer]:TKeyFloatPair read GetItems;default;
    property Names[Index:Integer]:String read GetNames write SetNames;
    property Values[Index:Integer]:Double read GetValues write SetValues;
    property Objects[Index:Integer]:TObject read GetObjects write SetObjects;
    property Sorted:Boolean read GetSorted write SetSorted;
    property CaseSensitive:Boolean read FCaseSensitive write FCaseSensitive;
  end;

  TKeyStringDictionary=class(TComponent)
  private
    FList: PKeyStringPairList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TKeyStringPair;
    function GetNames(Index: Integer): String;
    function GetObjects(Index: Integer): TObject;
    function GetValues(Index: Integer): string;
    procedure SetNames(Index: Integer; const Value: String);
    procedure SetObjects(Index: Integer; const Value: TObject);
    procedure SetValues(Index: Integer; const Value: string);
    function GetSorted: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure InsertItem(Index:Integer;const AName:string;const AValue:string;OBJ:TObject);
    function GetNodeSize: Integer;
  protected
    function Grow(const NewCount:Integer):Integer;virtual;
    function ValidIndex(Index:Integer):Boolean;
    procedure QuickSort(L,R:Integer);
    function CompareStrings(const S1, S2: string): Integer;
    property NodeSize:Integer read GetNodeSize;
    property List: PKeyStringPairList read FList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;virtual;
    procedure Sort;
    function Add(const Name:string;const Value:string):Integer;overload;virtual;
    function Add(const Name:string;const Value:string;OBJ:TObject):Integer;overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:string);overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:string;OBJ:TObject);overload;virtual;
    procedure Delete(Index:Integer);
    procedure Exchange(const OneIndex,TwoIndex:Integer);
    procedure Move(const OldIndex,NewIndex:Integer);
    procedure RemoveDuplicateValues;virtual;
    function IndexOf(const Name:string):Integer;
    function Find(const Name:string;var Index:Integer):Boolean;
    function FindLast(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function FindFirst(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function Search(
      const Name:string;
      var Index:Integer;
      const StartIndex:Integer;
      const EndIndex:Integer):Boolean;
    function ValueByName(Name:string):string;
    property Count:Integer read GetCount;
    property Items[Index:Integer]: TKeyStringPair read GetItems;default;
    property Names[Index:Integer]:String read GetNames write SetNames;
    property Values[Index:Integer]:string read GetValues write SetValues;
    property Objects[Index:Integer]:TObject read GetObjects write SetObjects;
    property Sorted:Boolean read GetSorted write SetSorted;
    property CaseSensitive:Boolean read FCaseSensitive write FCaseSensitive;
  end;
  TKeyDateTimeDictionary=class(TComponent)
  private
    FList: PKeyDateTimePairList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TKeyDateTimePair;
    function GetNames(Index: Integer): String;
    function GetObjects(Index: Integer): TObject;
    function GetValues(Index: Integer): TDateTime;
    procedure SetNames(Index: Integer; const Value: String);
    procedure SetObjects(Index: Integer; const Value: TObject);
    procedure SetValues(Index: Integer; const Value: TDateTime);
    function GetSorted: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure InsertItem(Index:Integer;const AName:string;const AValue:TDateTime;OBJ:TObject);
    function GetNodeSize: Integer;
  protected
    function Grow(const NewCount:Integer):Integer;virtual;
    function ValidIndex(Index:Integer):Boolean;
    procedure QuickSort(L,R:Integer);
    function CompareStrings(const S1, S2: string): Integer;
    property NodeSize:Integer read GetNodeSize;
    property List: PKeyDateTimePairList read FList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;virtual;
    procedure Sort;
    function Add(const Name:string;const Value:TDateTime):Integer;overload;virtual;
    function Add(const Name:string;const Value:TDateTime;OBJ:TObject):Integer;overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:TDateTime);overload;virtual;
    procedure Insert(Index:Integer;const Name:string;const Value:TDateTime;OBJ:TObject);overload;virtual;
    procedure Delete(Index:Integer);
    procedure Exchange(const OneIndex,TwoIndex:Integer);
    procedure Move(const OldIndex,NewIndex:Integer);
    procedure RemoveDuplicateValues;virtual;
    function IndexOf(const Name:string):Integer;
    function Find(const Name:string;var Index:Integer):Boolean;
    function FindLast(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function FindFirst(
      const Name:string;
      var Index:Integer;
      var DuplicatedCount:Integer):Boolean;
    function Search(
      const Name:string;
      var Index:Integer;
      const StartIndex:Integer;
      const EndIndex:Integer):Boolean;
    function ValueByName(Name:string):TDateTime;
    property Count:Integer read GetCount;
    property Items[Index:Integer]: TKeyDateTimePair read GetItems;default;
    property Names[Index:Integer]:String read GetNames write SetNames;
    property Values[Index:Integer]:TDateTime read GetValues write SetValues;
    property Objects[Index:Integer]:TObject read GetObjects write SetObjects;
    property Sorted:Boolean read GetSorted write SetSorted;
    property CaseSensitive:Boolean read FCaseSensitive write FCaseSensitive;
  end;

implementation

{ TKeyPointerDictionary }

function TKeyPointerDictionary.Add(const Key: string;
  const Value: Pointer; OBJ: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Key, Result);
  InsertItem(Result, Key, Value,OBJ);
end;

function TKeyPointerDictionary.Add(const Key: string;
  const Value: Pointer): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Key, Result);
  InsertItem(Result, Key, Value,nil);
end;

procedure TKeyPointerDictionary.Assign(Source: TPersistent);
  procedure AddKeys(Keys:TKeyPointerDictionary);
  var
    I:Integer;
  begin
    for I:=0 to Keys.Count-1 do
      Add(Keys.Keys[I],Keys.Values[I],Keys.Objects[I]);
  end;
begin
  inherited;
  if Source is TKeyPointerDictionary then
  begin
    Clear;
    FSorted:=TKeyPointerDictionary(Source).Sorted;
    FCaseSensitive:=TKeyPointerDictionary(Source).CaseSensitive;
    AddKeys(TKeyPointerDictionary(Source));
  end;

end;

procedure TKeyPointerDictionary.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FMemory^[0], FCount);
    SetCount(0);
  end;

end;

function TKeyPointerDictionary.CompareStrings(const S1,
  S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TKeyPointerDictionary.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCaseSensitive:=False;
  FCount:=0;
  FCapacity:=0;
end;

procedure TKeyPointerDictionary.Delete(Index: Integer);
begin
  if ValidIndex(Index)then
  begin
    Finalize(FMemory^[Index]);
    Dec(FCount);
    if Index < FCount then
      System.Move(FMemory^[Index + 1], FMemory^[Index],
        (FCount - Index) * NodeSize);
  end;

end;

destructor TKeyPointerDictionary.Destroy;
begin
  if FCount <> 0 then
    Finalize(FMemory^[0], FCount);
  SetCount(0);
  inherited;
end;

procedure TKeyPointerDictionary.Exchange(const OneIndex,
  TwoIndex: Integer);
var
  Temp:TKeyPointerPair;
begin
  if ValidIndex(OneIndex)and ValidIndex(TwoIndex)then
  begin
    Temp.Key:=FMemory^[oneIndex].Key;
    Temp.Value:=FMemory^[oneIndex].Value;
    Temp.Object_:=FMemory^[oneIndex].Object_;
    FMemory^[oneIndex].Key:=FMemory^[TwoIndex].Key;
    FMemory^[oneIndex].Value:=FMemory^[TwoIndex].Value;
    FMemory^[oneIndex].Object_:=FMemory^[TwoIndex].Object_;
    FMemory^[TwoIndex].Key:=Temp.Key;
    FMemory^[TwoIndex].Value:=Temp.Value;
    FMemory^[TwoIndex].Object_:=Temp.Object_;
  end;

end;

function TKeyPointerDictionary.Find(const Key: string;
  var Index: Integer): Boolean;
var
  b,e,m,c:Integer;
begin
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Key,Items[M].Key);
      if c=0 then
      begin
        e:=m;
        if (m = b) then break;
      end else if c>0 then
        b:=m+1
      else e:=m-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;

end;

function TKeyPointerDictionary.FindFirst(const Key: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyPointerPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Key,Items[m].Key);
      if c=0 then
      begin
        e:=m;
        if b = m then break;
      end else if c>0 then
        b:=m+1
      else
      e:=m-1;
    until (b>e);
  end;
  Index:=b;
  Result:=c=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B+DuplicatedCount)<Count do
    begin
      V:=Items[B+DuplicatedCount];
      if  CompareStrings(P.Key,V.Key)<>0 then Break;
      Inc(DuplicatedCount);
    end;
  end;

end;

function TKeyPointerDictionary.FindLast(const Key: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyPointerPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      C:=CompareStrings(Key,Items[m].Key);
      if C=0 then
      begin
        e:=M;
        if m = b then break;
      end else if C>0 then
        B:=M+1
      else
      e:=M-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B-DuplicatedCount)>=0 do
    begin
      V:=Items[B-DuplicatedCount];
      if  CompareStrings(P.Key,V.Key)<>0 then Break;
      Inc(DuplicatedCount);
    end;
  end;
end;

function TKeyPointerDictionary.GetCount: Integer;
begin
  Result:=FCount;
end;

function TKeyPointerDictionary.GetItems(
  Index: Integer): TKeyPointerPair;
begin
  if ValidIndex(Index)then
    Result:=List^[Index];
end;

function TKeyPointerDictionary.GetKeys(Index: Integer): String;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].Key;
end;

function TKeyPointerDictionary.GetNodeSize: Integer;
begin
  Result:=Sizeof(TKeyPointerPair);
end;

function TKeyPointerDictionary.GetObjects(Index: Integer): TObject;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index].Object_;
end;

function TKeyPointerDictionary.GetSorted: Boolean;
begin
  Result:=FSorted;

end;

function TKeyPointerDictionary.GetValues(Index: Integer): Pointer;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index].Value;
end;

function TKeyPointerDictionary.Grow(const NewCount: Integer): Integer;
var
  Delta: Integer;
begin
  if NewCount > 64 then
    Delta:=NewCount div 4
  else if NewCount>8 then
    Delta:=16
  else Delta:=4;
  Result:=NewCount + Delta;
end;

function TKeyPointerDictionary.IndexOf(const Key: string): Integer;
begin
  if not Sorted then
  begin
    for Result:=0 to Count -1 do
      if CompareStrings(Key,Keys[Result])=0then Exit;
    Result:=-1;
  end else
  begin
    if not Find(Key, Result) then
      Result := -1;
  end;

end;

procedure TKeyPointerDictionary.Insert(Index: Integer; const Key: string;
  const Value: Pointer; OBJ: TObject);
begin
  InsertItem(Index,Key,Value,OBJ);
end;

procedure TKeyPointerDictionary.Insert(Index: Integer; const Key: string;
  const Value: Pointer);
begin
  InsertItem(Index,Key,Value,nil);
end;

procedure TKeyPointerDictionary.InsertItem(Index: Integer;
  const AKey: string; const AValue: Pointer; OBJ: TObject);
begin
  SetCount(FCount+1);
  if(Index<FCount-1)then
    System.Move(FMemory^[Index],FMemory^[Index+1],
      (FCount-Index-1)*NodeSize);
  with FMemory^[Index] do
  begin
    Pointer(Key):=nil;
    Pointer(Value):=nil;
    Key:=AKey;
    Value:=AValue;
    Object_:=OBJ;
  end;

end;

procedure TKeyPointerDictionary.Move(const OldIndex, NewIndex: Integer);
var
  Key:string;
  Value:Pointer;
  OBJ:TObject;
begin
  if OldIndex <> NewIndex then
  begin
    Key:=Keys[OldIndex];
    Value:=Values[OldIndex];
    OBJ:=Objects[OldIndex];
    Delete(OldIndex);
    InsertItem(NewIndex,Key,Value,OBJ);
  end;

end;

procedure TKeyPointerDictionary.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(Items[I].Key,Items[P].Key) < 0 do Inc(I);
      while CompareStrings(Items[J].Key, Items[P].Key) > 0 do Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;

end;

procedure TKeyPointerDictionary.RemoveDuplicateValues;
begin
  EDictionaryException.Create('RemoveDuplicateValues function is not support');
end;

function TKeyPointerDictionary.Search(const Key: string;
  var Index: Integer; const StartIndex, EndIndex: Integer): Boolean;
begin
  if Sorted then
  begin
    Result:=Find(Key,Index);
    Result:= Result and (Index>=StartIndex) and (Index<=EndIndex);
  end else
  begin
    Index:=IndexOf(Key);
    Result:=(Index>=StartIndex) and (Index<=EndIndex);
  end;
end;

procedure TKeyPointerDictionary.SetCount(const Value: Integer);
var
  OldCapacity,NewCapacity:Integer;
begin
  if Value<=0 then
  begin
    if (FMemory<>nil) then
    begin
      GlobalFreePtr(FMemory);
      FMemory:=nil;
      FCount:=0;
      FCapacity:=0;
    end;
    Exit;
  end;
  if Value = FCount then Exit;
  if Count =0 then
    OldCapacity:=0
  else OldCapacity:=Grow(Count);
  NewCapacity:=Grow(Value);
  if (OldCapacity<>NewCapacity) then
  begin
    if OldCapacity=0 then
      FMemory:=GlobalAllocPtr(GMEM_MOVEABLE,NewCapacity*NodeSize)
    else begin
      FMemory:=GlobalReAllocPtr(
        FMemory,
        NewCapacity*NodeSize,
        GMEM_MOVEABLE);
    end;
    if FMemory=nil then OutOfMemoryError
  end;
  if Value>Count then
    ZeroMemory(
      Pointer(LongInt(FMemory)+LongInt(Count*NodeSize)),
      (Value-Count)*NodeSize
    );
  FCapacity:=NewCapacity;
  FCount:=Value;
end;

procedure TKeyPointerDictionary.SetKeys(Index: Integer;
  const Value: String);
begin
  if ValidIndex(Index)then
    List^[Index].Key:=Value;
end;

procedure TKeyPointerDictionary.SetObjects(Index: Integer;
  const Value: TObject);
begin
  if ValidIndex(Index)then
    List^[Index].Object_:=Value;
end;

procedure TKeyPointerDictionary.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted and (Count>1) then
        QuickSort(0,Count-1);
  end;
end;

procedure TKeyPointerDictionary.SetValues(Index: Integer;
  const Value: Pointer);
begin
  if ValidIndex(Index)then
    List^[Index].Value:=Value;
end;

procedure TKeyPointerDictionary.Sort;
begin
  if not Sorted then
    Sorted:=True;
end;

function TKeyPointerDictionary.ValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index>=0)and(Index<Count);
end;


function TKeyPointerDictionary.ValueByKey(Key: string): Pointer;
var
  Index:Integer;
begin
  Result:=nil;
  if Find(Key,Index)then
    Result:=Values[Index];

end;

{ TKeyIntDictionary }

function TKeyIntDictionary.Add(const Name: string;
  const Value: Integer): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,nil);
end;

function TKeyIntDictionary.Add(const Name: string; const Value: Integer;
  OBJ: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,OBJ);
end;

procedure TKeyIntDictionary.Assign(Source: TPersistent);
  procedure AddMaps(Maps:TKeyIntDictionary);
  var
    I:Integer;
  begin
    for I:=0 to Maps.Count-1 do
      Add(Maps.Names[I],Maps.Values[I],Maps.Objects[I]);    
  end;
begin
  inherited;
  if Source is TKeyIntDictionary then
  begin
    Clear;
    FSorted:=TKeyIntDictionary(Source).Sorted;
    FCaseSensitive:=TKeyIntDictionary(Source).CaseSensitive;
    AddMaps(TKeyIntDictionary(Source));
  end;
end;


procedure TKeyIntDictionary.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    SetCount(0);
  end;
end;

function TKeyIntDictionary.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TKeyIntDictionary.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FCaseSensitive:=False;
  FCount:=0;
  FCapacity:=0;
end;

procedure TKeyIntDictionary.Delete(Index: Integer);
begin
  if ValidIndex(Index)then
  begin
    Finalize(FList^[Index]);
    Dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * NodeSize);
  end;
end;

destructor TKeyIntDictionary.Destroy;
begin
  if FCount <> 0 then
    Finalize(FList^[0], FCount);
  SetCount(0);
  inherited;
end;

procedure TKeyIntDictionary.Exchange(const OneIndex, TwoIndex: Integer);
var
  Temp:TKeyIntPair;
begin
  if ValidIndex(OneIndex)and ValidIndex(TwoIndex)then
  begin
    Temp.Key:=FList^[oneIndex].Key;
    Temp.Value:=FList^[oneIndex].Value;
    Temp.Object_:=FList^[oneIndex].Object_;
    FList^[oneIndex].Key:=FList^[TwoIndex].Key;
    FList^[oneIndex].Value:=FList^[TwoIndex].Value;
    FList^[oneIndex].Object_:=FList^[TwoIndex].Object_;
    FList^[TwoIndex].Key:=Temp.Key;
    FList^[TwoIndex].Value:=Temp.Value;
    FList^[TwoIndex].Object_:=Temp.Object_;
  end;
end;

function TKeyIntDictionary.Find(const Name: string;
  var Index: Integer): Boolean;
var
  b,e,m,c:Integer;
begin
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[M].Key);
      if c=0 then
      begin
        e:=m;
        if (m = b) then break;
      end else if c>0 then
        b:=m+1
      else e:=m-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
end;

function TKeyIntDictionary.FindFirst(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyIntPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[m].Key);
      if c=0 then
      begin
        e:=m;
        if b = m then break;
      end else if c>0 then
        b:=m+1
      else
      e:=m-1;
    until (b>e);
  end;
  Index:=b;
  Result:=c=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B+DuplicatedCount)<Count do
    begin
      V:=Items[B+DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;
end;

function TKeyIntDictionary.FindLast(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyIntPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      C:=CompareStrings(Name,Items[m].Key);
      if C=0 then
      begin
        e:=M;
        if m = b then break;
      end else if C>0 then
        B:=M+1
      else
      e:=M-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B-DuplicatedCount)>=0 do
    begin
      V:=Items[B-DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;

end;

function TKeyIntDictionary.GetCount: Integer;
begin
  Result:=FCount;
end;

function TKeyIntDictionary.GetItems(Index: Integer): TKeyIntPair;
begin
  if ValidIndex(Index)then
    Result:=List^[Index];
end;

function TKeyIntDictionary.GetNames(Index: Integer): String;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].Key;
end;

function TKeyIntDictionary.GetNodeSize: Integer;
begin
  Result:=SizeOf(TKeyIntPair);
end;

function TKeyIntDictionary.GetObjects(Index: Integer): TObject;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index].Object_;
end;

function TKeyIntDictionary.GetSorted: Boolean;
begin
  Result:=FSorted;
end;

function TKeyIntDictionary.GetValues(Index: Integer): Integer;
begin
  Result:=0;
  if ValidIndex(Index)then
    Result:=Items[Index].Value;
end;

function TKeyIntDictionary.Grow(const NewCount: Integer): Integer;
var
  Delta: Integer;
begin
  if NewCount > 64 then
    Delta:=NewCount div 4
  else if NewCount>8 then
    Delta:=16
  else Delta:=4;
  Result:=NewCount + Delta;
end;

function TKeyIntDictionary.IndexOf(const Name: string): Integer;
begin
  if not Sorted then
  begin
    for Result:=0 to Count -1 do
      if CompareStrings(Name,Names[Result])=0then Exit;
    Result:=-1;
  end else
  begin
    if not Find(Name, Result) then
      Result := -1;
  end;
end;

procedure TKeyIntDictionary.Insert(Index: Integer; const Name: string;
  const Value: Integer);
begin
  InsertItem(Index,Name,Value,nil);
end;

procedure TKeyIntDictionary.Insert(Index: Integer; const Name: string;
  const Value: Integer; OBJ: TObject);
begin
  InsertItem(Index,Name,Value,OBJ);
end;

procedure TKeyIntDictionary.InsertItem(Index: Integer; const AName: string;
  const AValue: Integer; OBJ: TObject);
begin
  SetCount(FCount+1);
  if(Index<FCount-1)then
    System.Move(FList^[Index],FList^[Index+1],
      (FCount-Index-1)*NodeSize);
  with FList^[Index] do
  begin
    Pointer(Key):=nil;
    Pointer(Value):=nil;
    Key:=AName;
    Value:=AValue;
    Object_:=OBJ;
  end;
end;

procedure TKeyIntDictionary.Move(const OldIndex, NewIndex: Integer);
var
  Name:string;
  Value:Variant;
  OBJ:TObject;
begin
  if OldIndex <> NewIndex then
  begin
    Name:=Names[OldIndex];
    Value:=Values[OldIndex];
    OBJ:=Objects[OldIndex];
    Delete(OldIndex);
    InsertItem(NewIndex,Name,Value,OBJ);
  end;
end;

procedure TKeyIntDictionary.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(Items[I].Key,Items[P].Key) < 0 do Inc(I);
      while CompareStrings(Items[J].Key, Items[P].Key) > 0 do Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;


procedure TKeyIntDictionary.RemoveDuplicateValues;
begin
  EDictionaryException.Create('RemoveDuplicateValues function is not support');
end;

function TKeyIntDictionary.Search(const Name: string; var Index: Integer;
  const StartIndex, EndIndex: Integer): Boolean;
begin
  if Sorted then
  begin
    Result:=Find(Name,Index);
    Result:= Result and (Index>=StartIndex) and (Index<=EndIndex);
  end else
  begin
    Index:=IndexOf(Name);
    Result:=(Index>=StartIndex) and (Index<=EndIndex);
  end;
end;

procedure TKeyIntDictionary.SetCount(const Value: Integer);
var
  OldCapacity,NewCapacity:Integer;
begin
  if Value<=0 then
  begin
    if (FList<>nil) then
    begin
      GlobalFreePtr(FList);
      FList:=nil;
      FCount:=0;
      FCapacity:=0;
    end;
    Exit;
  end;
  if Value = FCount then Exit;
  if Count =0 then
    OldCapacity:=0
  else OldCapacity:=Grow(Count);
  NewCapacity:=Grow(Value);
  if (OldCapacity<>NewCapacity) then
  begin
    if OldCapacity=0 then
      FList:=GlobalAllocPtr(GMEM_MOVEABLE,NewCapacity*NodeSize)
    else begin
      FList:=GlobalReAllocPtr(
        FList,
        NewCapacity*NodeSize,
        GMEM_MOVEABLE);
    end;
    if FList=nil then OutOfMemoryError
  end;
  if Value>Count then
    ZeroMemory(
      Pointer(LongInt(FList)+LongInt(Count*NodeSize)),
      (Value-Count)*NodeSize
    );
  FCapacity:=NewCapacity;
  FCount:=Value;
end;

procedure TKeyIntDictionary.SetNames(Index: Integer; const Value: String);
begin
  if ValidIndex(Index)then
    List^[Index].Key:=Value;
end;

procedure TKeyIntDictionary.SetObjects(Index: Integer;
  const Value: TObject);
begin
  if ValidIndex(Index)then
    List^[Index].Object_:=Value;
end;

procedure TKeyIntDictionary.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted and (Count>1) then
        QuickSort(0,Count-1);
  end;
end;

procedure TKeyIntDictionary.SetValues(Index: Integer;
  const Value: Integer);
begin
  if ValidIndex(Index)then
    List^[Index].Value:=Value;
end;

procedure TKeyIntDictionary.Sort;
begin
  if not Sorted then
    Sorted:=True;
end;

function TKeyIntDictionary.ValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index>=0)and(Index<Count);
end;

function TKeyIntDictionary.ValueByName(Name: string): Integer;
var
  Index:Integer;
begin
  Result:=0;
  if Find(Name,Index)then
    Result:=Values[Index];
end;


function TKeyFloatDictionary.Add(const Name: string;
  const Value: Double): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,nil);
end;

function TKeyFloatDictionary.Add(const Name: string; const Value: Double;
  OBJ: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,OBJ);
end;

procedure TKeyFloatDictionary.Assign(Source: TPersistent);
  procedure AddMaps(Maps:TKeyFloatDictionary);
  var
    I:Integer;
  begin
    for I:=0 to Maps.Count-1 do
      Add(Maps.Names[I],Maps.Values[I],Maps.Objects[I]);
  end;
begin
  inherited;
  if Source is TKeyFloatDictionary then
  begin
    Clear;
    FSorted:=TKeyFloatDictionary(Source).Sorted;
    FCaseSensitive:=TKeyFloatDictionary(Source).CaseSensitive;
    AddMaps(TKeyFloatDictionary(Source));
  end;
end;


procedure TKeyFloatDictionary.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    SetCount(0);
  end;
end;

function TKeyFloatDictionary.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TKeyFloatDictionary.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FCaseSensitive:=False;
  FCount:=0;
  FCapacity:=0;
end;

procedure TKeyFloatDictionary.Delete(Index: Integer);
begin
  if ValidIndex(Index)then
  begin
    Finalize(FList^[Index]);
    Dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * NodeSize);
  end;
end;

destructor TKeyFloatDictionary.Destroy;
begin
  if FCount <> 0 then
    Finalize(FList^[0], FCount);
  SetCount(0);
  inherited;
end;

procedure TKeyFloatDictionary.Exchange(const OneIndex, TwoIndex: Integer);
var
  Temp:TKeyFloatPair;
begin
  if ValidIndex(OneIndex)and ValidIndex(TwoIndex)then
  begin
    Temp.Key:=FList^[oneIndex].Key;
    Temp.Value:=FList^[oneIndex].Value;
    Temp.Object_:=FList^[oneIndex].Object_;
    FList^[oneIndex].Key:=FList^[TwoIndex].Key;
    FList^[oneIndex].Value:=FList^[TwoIndex].Value;
    FList^[oneIndex].Object_:=FList^[TwoIndex].Object_;
    FList^[TwoIndex].Key:=Temp.Key;
    FList^[TwoIndex].Value:=Temp.Value;
    FList^[TwoIndex].Object_:=Temp.Object_;
  end;
end;

function TKeyFloatDictionary.Find(const Name: string;
  var Index: Integer): Boolean;
var
  b,e,m,c:Integer;
begin
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[M].Key);
      if c=0 then
      begin
        e:=m;
        if (m = b) then break;
      end else if c>0 then
        b:=m+1
      else e:=m-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
end;

function TKeyFloatDictionary.FindFirst(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyFloatPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[m].Key);
      if c=0 then
      begin
        e:=m;
        if b = m then break;
      end else if c>0 then
        b:=m+1
      else
      e:=m-1;
    until (b>e);
  end;
  Index:=b;
  Result:=c=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B+DuplicatedCount)<Count do
    begin
      V:=Items[B+DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;
end;

function TKeyFloatDictionary.FindLast(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyFloatPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      C:=CompareStrings(Name,Items[m].Key);
      if C=0 then
      begin
        e:=M;
        if m = b then break;
      end else if C>0 then
        B:=M+1
      else
      e:=M-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B-DuplicatedCount)>=0 do
    begin
      V:=Items[B-DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;

end;

function TKeyFloatDictionary.GetCount: Integer;
begin
  Result:=FCount;
end;

function TKeyFloatDictionary.GetItems(Index: Integer): TKeyFloatPair;
begin
  if ValidIndex(Index)then
    Result:=List^[Index];
end;

function TKeyFloatDictionary.GetNames(Index: Integer): String;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].Key;
end;

function TKeyFloatDictionary.GetNodeSize: Integer;
begin
  Result:=SizeOf(TKeyFloatPair);
end;

function TKeyFloatDictionary.GetObjects(Index: Integer): TObject;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index].Object_;
end;

function TKeyFloatDictionary.GetSorted: Boolean;
begin
  Result:=FSorted;
end;

function TKeyFloatDictionary.GetValues(Index: Integer): Double;
begin
  Result:=0;
  if ValidIndex(Index)then
    Result:=Items[Index].Value;
end;

function TKeyFloatDictionary.Grow(const NewCount: Integer): Integer;
var
  Delta: Integer;
begin
  if NewCount > 64 then
    Delta:=NewCount div 4
  else if NewCount>8 then
    Delta:=16
  else Delta:=4;
  Result:=NewCount + Delta;
end;

function TKeyFloatDictionary.IndexOf(const Name: string): Integer;
begin
  if not Sorted then
  begin
    for Result:=0 to Count -1 do
      if CompareStrings(Name,Names[Result])=0then Exit;
    Result:=-1;
  end else
  begin
    if not Find(Name, Result) then
      Result := -1;
  end;
end;

procedure TKeyFloatDictionary.Insert(Index: Integer; const Name: string;
  const Value: Double);
begin
  InsertItem(Index,Name,Value,nil);
end;

procedure TKeyFloatDictionary.Insert(Index: Integer; const Name: string;
  const Value: Double; OBJ: TObject);
begin
  InsertItem(Index,Name,Value,OBJ);
end;

procedure TKeyFloatDictionary.InsertItem(Index: Integer; const AName: string;
  const AValue: Double; OBJ: TObject);
begin
  SetCount(FCount+1);
  if(Index<FCount-1)then
    System.Move(FList^[Index],FList^[Index+1],
      (FCount-Index-1)*NodeSize);
  with FList^[Index] do
  begin
    Pointer(Key):=nil;
    Key:=AName;
    Value:=AValue;
    Object_:=OBJ;
  end;
end;

procedure TKeyFloatDictionary.Move(const OldIndex, NewIndex: Integer);
var
  Name:string;
  Value:Variant;
  OBJ:TObject;
begin
  if OldIndex <> NewIndex then
  begin
    Name:=Names[OldIndex];
    Value:=Values[OldIndex];
    OBJ:=Objects[OldIndex];
    Delete(OldIndex);
    InsertItem(NewIndex,Name,Value,OBJ);
  end;
end;

procedure TKeyFloatDictionary.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(Items[I].Key,Items[P].Key) < 0 do Inc(I);
      while CompareStrings(Items[J].Key, Items[P].Key) > 0 do Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;


procedure TKeyFloatDictionary.RemoveDuplicateValues;
begin
  EDictionaryException.Create('RemoveDuplicateValues function is not support');
end;

function TKeyFloatDictionary.Search(const Name: string; var Index: Integer;
  const StartIndex, EndIndex: Integer): Boolean;
begin
  if Sorted then
  begin
    Result:=Find(Name,Index);
    Result:= Result and (Index>=StartIndex) and (Index<=EndIndex);
  end else
  begin
    Index:=IndexOf(Name);
    Result:=(Index>=StartIndex) and (Index<=EndIndex);
  end;
end;

procedure TKeyFloatDictionary.SetCount(const Value: Integer);
var
  OldCapacity,NewCapacity:Integer;
begin
  if Value<=0 then
  begin
    if (FList<>nil) then
    begin
      GlobalFreePtr(FList);
      FList:=nil;
      FCount:=0;
      FCapacity:=0;
    end;
    Exit;
  end;
  if Value = FCount then Exit;
  if Count =0 then
    OldCapacity:=0
  else OldCapacity:=Grow(Count);
  NewCapacity:=Grow(Value);
  if (OldCapacity<>NewCapacity) then
  begin
    if OldCapacity=0 then
      FList:=GlobalAllocPtr(GMEM_MOVEABLE,NewCapacity*NodeSize)
    else begin
      FList:=GlobalReAllocPtr(
        FList,
        NewCapacity*NodeSize,
        GMEM_MOVEABLE);
    end;
    if FList=nil then OutOfMemoryError
  end;
  if Value>Count then
    ZeroMemory(
      Pointer(LongInt(FList)+LongInt(Count*NodeSize)),
      (Value-Count)*NodeSize
    );
  FCapacity:=NewCapacity;
  FCount:=Value;
end;

procedure TKeyFloatDictionary.SetNames(Index: Integer; const Value: String);
begin
  if ValidIndex(Index)then
    List^[Index].Key:=Value;
end;

procedure TKeyFloatDictionary.SetObjects(Index: Integer;
  const Value: TObject);
begin
  if ValidIndex(Index)then
    List^[Index].Object_:=Value;
end;

procedure TKeyFloatDictionary.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted and (Count>1) then
        QuickSort(0,Count-1);
  end;
end;

procedure TKeyFloatDictionary.SetValues(Index: Integer;
  const Value: Double);
begin
  if ValidIndex(Index)then
    List^[Index].Value:=Value;
end;

procedure TKeyFloatDictionary.Sort;
begin
  if not Sorted then
    Sorted:=True;
end;

function TKeyFloatDictionary.ValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index>=0)and(Index<Count);
end;

function TKeyFloatDictionary.ValueByName(Name: string):Double;
var
  Index:Integer;
begin
  Result:=0;
  if Find(Name,Index)then
    Result:=Values[Index];
end;


function TKeyStringDictionary.Add(const Name: string;
  const Value: string): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,nil);
end;

function TKeyStringDictionary.Add(const Name: string; const Value: string;
  OBJ: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,OBJ);
end;

procedure TKeyStringDictionary.Assign(Source: TPersistent);
  procedure AddMaps(Maps:TKeyStringDictionary);
  var
    I:Integer;
  begin
    for I:=0 to Maps.Count-1 do
      Add(Maps.Names[I],Maps.Values[I],Maps.Objects[I]);
  end;
begin
  inherited;
  if Source is TKeyStringDictionary then
  begin
    Clear;
    FSorted:=TKeyStringDictionary(Source).Sorted;
    FCaseSensitive:=TKeyStringDictionary(Source).CaseSensitive;
    AddMaps(TKeyStringDictionary(Source));
  end;
end;


procedure TKeyStringDictionary.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    SetCount(0);
  end;
end;

function TKeyStringDictionary.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TKeyStringDictionary.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FCaseSensitive:=False;
  FCount:=0;
  FCapacity:=0;
end;

procedure TKeyStringDictionary.Delete(Index: Integer);
begin
  if ValidIndex(Index)then
  begin
    Finalize(FList^[Index]);
    Dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * NodeSize);
  end;
end;

destructor TKeyStringDictionary.Destroy;
begin
  if FCount <> 0 then
    Finalize(FList^[0], FCount);
  SetCount(0);
  inherited;
end;

procedure TKeyStringDictionary.Exchange(const OneIndex, TwoIndex: Integer);
var
  Temp:TKeyStringPair;
begin
  if ValidIndex(OneIndex)and ValidIndex(TwoIndex)then
  begin
    Temp.Key:=FList^[oneIndex].Key;
    Temp.Value:=FList^[oneIndex].Value;
    Temp.Object_:=FList^[oneIndex].Object_;
    FList^[oneIndex].Key:=FList^[TwoIndex].Key;
    FList^[oneIndex].Value:=FList^[TwoIndex].Value;
    FList^[oneIndex].Object_:=FList^[TwoIndex].Object_;
    FList^[TwoIndex].Key:=Temp.Key;
    FList^[TwoIndex].Value:=Temp.Value;
    FList^[TwoIndex].Object_:=Temp.Object_;
  end;
end;

function TKeyStringDictionary.Find(const Name: string;
  var Index: Integer): Boolean;
var
  b,e,m,c:Integer;
begin
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[M].Key);
      if c=0 then
      begin
        e:=m;
        if (m = b) then break;
      end else if c>0 then
        b:=m+1
      else e:=m-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
end;

function TKeyStringDictionary.FindFirst(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyStringPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[m].Key);
      if c=0 then
      begin
        e:=m;
        if b = m then break;
      end else if c>0 then
        b:=m+1
      else
      e:=m-1;
    until (b>e);
  end;
  Index:=b;
  Result:=c=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B+DuplicatedCount)<Count do
    begin
      V:=Items[B+DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;
end;

function TKeyStringDictionary.FindLast(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyStringPair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      C:=CompareStrings(Name,Items[m].Key);
      if C=0 then
      begin
        e:=M;
        if m = b then break;
      end else if C>0 then
        B:=M+1
      else
      e:=M-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B-DuplicatedCount)>=0 do
    begin
      V:=Items[B-DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;

end;

function TKeyStringDictionary.GetCount: Integer;
begin
  Result:=FCount;
end;

function TKeyStringDictionary.GetItems(Index: Integer): TKeyStringPair;
begin
  if ValidIndex(Index)then
    Result:=List^[Index];
end;

function TKeyStringDictionary.GetNames(Index: Integer): String;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].Key;
end;

function TKeyStringDictionary.GetNodeSize: Integer;
begin
  Result:=SizeOf(TKeyStringPair);
end;

function TKeyStringDictionary.GetObjects(Index: Integer): TObject;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index].Object_;
end;

function TKeyStringDictionary.GetSorted: Boolean;
begin
  Result:=FSorted;
end;

function TKeyStringDictionary.GetValues(Index: Integer): string;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].Value;
end;

function TKeyStringDictionary.Grow(const NewCount: Integer): Integer;
var
  Delta: Integer;
begin
  if NewCount > 64 then
    Delta:=NewCount div 4
  else if NewCount>8 then
    Delta:=16
  else Delta:=4;
  Result:=NewCount + Delta;
end;

function TKeyStringDictionary.IndexOf(const Name: string): Integer;
begin
  if not Sorted then
  begin
    for Result:=0 to Count -1 do
      if CompareStrings(Name,Names[Result])=0then Exit;
    Result:=-1;
  end else
  begin
    if not Find(Name, Result) then
      Result := -1;
  end;
end;

procedure TKeyStringDictionary.Insert(Index: Integer; const Name: string;
  const Value: string);
begin
  InsertItem(Index,Name,Value,nil);
end;

procedure TKeyStringDictionary.Insert(Index: Integer; const Name: string;
  const Value: string; OBJ: TObject);
begin
  InsertItem(Index,Name,Value,OBJ);
end;

procedure TKeyStringDictionary.InsertItem(Index: Integer; const AName: string;
  const AValue: string; OBJ: TObject);
begin
  SetCount(FCount+1);
  if(Index<FCount-1)then
    System.Move(FList^[Index],FList^[Index+1],
      (FCount-Index-1)*NodeSize);
  with FList^[Index] do
  begin
    Pointer(Key):=nil;
    Pointer(Value):=nil;
    Key:=AName;
    Value:=AValue;
    Object_:=OBJ;
  end;
end;

procedure TKeyStringDictionary.Move(const OldIndex, NewIndex: Integer);
var
  Name:string;
  Value:Variant;
  OBJ:TObject;
begin
  if OldIndex <> NewIndex then
  begin
    Name:=Names[OldIndex];
    Value:=Values[OldIndex];
    OBJ:=Objects[OldIndex];
    Delete(OldIndex);
    InsertItem(NewIndex,Name,Value,OBJ);
  end;
end;

procedure TKeyStringDictionary.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(Items[I].Key,Items[P].Key) < 0 do Inc(I);
      while CompareStrings(Items[J].Key, Items[P].Key) > 0 do Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;


procedure TKeyStringDictionary.RemoveDuplicateValues;
begin
  EDictionaryException.Create('RemoveDuplicateValues function is not support');
end;

function TKeyStringDictionary.Search(const Name: string; var Index: Integer;
  const StartIndex, EndIndex: Integer): Boolean;
begin
  if Sorted then
  begin
    Result:=Find(Name,Index);
    Result:= Result and (Index>=StartIndex) and (Index<=EndIndex);
  end else
  begin
    Index:=IndexOf(Name);
    Result:=(Index>=StartIndex) and (Index<=EndIndex);
  end;
end;

procedure TKeyStringDictionary.SetCount(const Value: Integer);
var
  OldCapacity,NewCapacity:Integer;
begin
  if Value<=0 then
  begin
    if (FList<>nil) then
    begin
      GlobalFreePtr(FList);
      FList:=nil;
      FCount:=0;
      FCapacity:=0;
    end;
    Exit;
  end;
  if Value = FCount then Exit;
  if Count =0 then
    OldCapacity:=0
  else OldCapacity:=Grow(Count);
  NewCapacity:=Grow(Value);
  if (OldCapacity<>NewCapacity) then
  begin
    if OldCapacity=0 then
      FList:=GlobalAllocPtr(GMEM_MOVEABLE,NewCapacity*NodeSize)
    else begin
      FList:=GlobalReAllocPtr(
        FList,
        NewCapacity*NodeSize,
        GMEM_MOVEABLE);
    end;
    if FList=nil then OutOfMemoryError
  end;
  if Value>Count then
    ZeroMemory(
      Pointer(LongInt(FList)+LongInt(Count*NodeSize)),
      (Value-Count)*NodeSize
    );
  FCapacity:=NewCapacity;
  FCount:=Value;
end;

procedure TKeyStringDictionary.SetNames(Index: Integer; const Value: String);
begin
  if ValidIndex(Index)then
    List^[Index].Key:=Value;
end;

procedure TKeyStringDictionary.SetObjects(Index: Integer;
  const Value: TObject);
begin
  if ValidIndex(Index)then
    List^[Index].Object_:=Value;
end;

procedure TKeyStringDictionary.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted and (Count>1) then
        QuickSort(0,Count-1);
  end;
end;

procedure TKeyStringDictionary.SetValues(Index: Integer;
  const Value: string);
begin
  if ValidIndex(Index)then
    List^[Index].Value:=Value;
end;

procedure TKeyStringDictionary.Sort;
begin
  if not Sorted then
    Sorted:=True;
end;

function TKeyStringDictionary.ValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index>=0)and(Index<Count);
end;

function TKeyStringDictionary.ValueByName(Name: string):string;
var
  Index:Integer;
begin
  Result:='';
  if Find(Name,Index)then
    Result:=Values[Index];
end;

function TKeyDateTimeDictionary.Add(const Name: string;
  const Value: TDateTime): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,nil);
end;

function TKeyDateTimeDictionary.Add(const Name: string; const Value: TDateTime;
  OBJ: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value,OBJ);
end;

procedure TKeyDateTimeDictionary.Assign(Source: TPersistent);
  procedure AddMaps(Maps:TKeyDateTimeDictionary);
  var
    I:Integer;
  begin
    for I:=0 to Maps.Count-1 do
      Add(Maps.Names[I],Maps.Values[I],Maps.Objects[I]);
  end;
begin
  inherited;
  if Source is TKeyDateTimeDictionary then
  begin
    Clear;
    FSorted:=TKeyDateTimeDictionary(Source).Sorted;
    FCaseSensitive:=TKeyDateTimeDictionary(Source).CaseSensitive;
    AddMaps(TKeyDateTimeDictionary(Source));
  end;
end;


procedure TKeyDateTimeDictionary.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    SetCount(0);
  end;
end;

function TKeyDateTimeDictionary.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TKeyDateTimeDictionary.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FCaseSensitive:=False;
  FCount:=0;
  FCapacity:=0;
end;

procedure TKeyDateTimeDictionary.Delete(Index: Integer);
begin
  if ValidIndex(Index)then
  begin
    Finalize(FList^[Index]);
    Dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * NodeSize);
  end;
end;

destructor TKeyDateTimeDictionary.Destroy;
begin
  if FCount <> 0 then
    Finalize(FList^[0], FCount);
  SetCount(0);
  inherited;
end;

procedure TKeyDateTimeDictionary.Exchange(const OneIndex, TwoIndex: Integer);
var
  Temp:TKeyDateTimePair;
begin
  if ValidIndex(OneIndex)and ValidIndex(TwoIndex)then
  begin
    Temp.Key:=FList^[oneIndex].Key;
    Temp.Value:=FList^[oneIndex].Value;
    Temp.Object_:=FList^[oneIndex].Object_;
    FList^[oneIndex].Key:=FList^[TwoIndex].Key;
    FList^[oneIndex].Value:=FList^[TwoIndex].Value;
    FList^[oneIndex].Object_:=FList^[TwoIndex].Object_;
    FList^[TwoIndex].Key:=Temp.Key;
    FList^[TwoIndex].Value:=Temp.Value;
    FList^[TwoIndex].Object_:=Temp.Object_;
  end;
end;

function TKeyDateTimeDictionary.Find(const Name: string;
  var Index: Integer): Boolean;
var
  b,e,m,c:Integer;
begin
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[M].Key);
      if c=0 then
      begin
        e:=m;
        if (m = b) then break;
      end else if c>0 then
        b:=m+1
      else e:=m-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
end;

function TKeyDateTimeDictionary.FindFirst(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyDateTimePair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      c:=CompareStrings(Name,Items[m].Key);
      if c=0 then
      begin
        e:=m;
        if b = m then break;
      end else if c>0 then
        b:=m+1
      else
      e:=m-1;
    until (b>e);
  end;
  Index:=b;
  Result:=c=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B+DuplicatedCount)<Count do
    begin
      V:=Items[B+DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;
end;

function TKeyDateTimeDictionary.FindLast(const Name: string; var Index,
  DuplicatedCount: Integer): Boolean;
var
  P,V:TKeyDateTimePair;
  b,e,m,c:Integer;
begin
  DuplicatedCount:=-1;
  if not Sorted then Sorted:=True;
  b:=0;
  e:=Count -1;
  c:=-1;
  if e>=0 then
  begin
    repeat
      m:=(b+e)shr 1;
      C:=CompareStrings(Name,Items[m].Key);
      if C=0 then
      begin
        e:=M;
        if m = b then break;
      end else if C>0 then
        B:=M+1
      else
      e:=M-1;
    until (b>e);
  end;
  Index:=B;
  Result:=C=0;
  if Result then
  begin
    P:=Items[B];
    DuplicatedCount:=1;
    while (B-DuplicatedCount)>=0 do
    begin
      V:=Items[B-DuplicatedCount];
      if not CompareStrings(P.Key,V.Key)=0 then Break;
      Inc(DuplicatedCount);
    end;
  end;

end;

function TKeyDateTimeDictionary.GetCount: Integer;
begin
  Result:=FCount;
end;

function TKeyDateTimeDictionary.GetItems(Index: Integer): TKeyDateTimePair;
begin
  if ValidIndex(Index)then
    Result:=List^[Index];
end;

function TKeyDateTimeDictionary.GetNames(Index: Integer): String;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].Key;
end;

function TKeyDateTimeDictionary.GetNodeSize: Integer;
begin
  Result:=SizeOf(TKeyDateTimePair);
end;

function TKeyDateTimeDictionary.GetObjects(Index: Integer): TObject;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index].Object_;
end;

function TKeyDateTimeDictionary.GetSorted: Boolean;
begin
  Result:=FSorted;
end;

function TKeyDateTimeDictionary.GetValues(Index: Integer): TDateTime;
const
  Const_Default_DateTime=1890-12-31;
begin
  Result:=Const_Default_DateTime;
  if ValidIndex(Index)then
    Result:=Items[Index].Value;
end;

function TKeyDateTimeDictionary.Grow(const NewCount: Integer): Integer;
var
  Delta: Integer;
begin
  if NewCount > 64 then
    Delta:=NewCount div 4
  else if NewCount>8 then
    Delta:=16
  else Delta:=4;
  Result:=NewCount + Delta;
end;

function TKeyDateTimeDictionary.IndexOf(const Name: string): Integer;
begin
  if not Sorted then
  begin
    for Result:=0 to Count -1 do
      if CompareStrings(Name,Names[Result])=0then Exit;
    Result:=-1;
  end else
  begin
    if not Find(Name, Result) then
      Result := -1;
  end;
end;

procedure TKeyDateTimeDictionary.Insert(Index: Integer; const Name: string;
  const Value: TDateTime);
begin
  InsertItem(Index,Name,Value,nil);
end;

procedure TKeyDateTimeDictionary.Insert(Index: Integer; const Name: string;
  const Value: TDateTime; OBJ: TObject);
begin
  InsertItem(Index,Name,Value,OBJ);
end;

procedure TKeyDateTimeDictionary.InsertItem(Index: Integer; const AName: string;
  const AValue: TDateTime; OBJ: TObject);
begin
  SetCount(FCount+1);
  if(Index<FCount-1)then
    System.Move(FList^[Index],FList^[Index+1],
      (FCount-Index-1)*NodeSize);
  with FList^[Index] do
  begin
    Pointer(Key):=nil;
    Key:=AName;
    Value:=AValue;
    Object_:=OBJ;
  end;
end;

procedure TKeyDateTimeDictionary.Move(const OldIndex, NewIndex: Integer);
var
  Name:string;
  Value:Variant;
  OBJ:TObject;
begin
  if OldIndex <> NewIndex then
  begin
    Name:=Names[OldIndex];
    Value:=Values[OldIndex];
    OBJ:=Objects[OldIndex];
    Delete(OldIndex);
    InsertItem(NewIndex,Name,Value,OBJ);
  end;
end;

procedure TKeyDateTimeDictionary.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(Items[I].Key,Items[P].Key) < 0 do Inc(I);
      while CompareStrings(Items[J].Key, Items[P].Key) > 0 do Dec(J);
      if I <= J then
      begin
        Exchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;


procedure TKeyDateTimeDictionary.RemoveDuplicateValues;
begin
  EDictionaryException.Create('RemoveDuplicateValues function is not support');
end;

function TKeyDateTimeDictionary.Search(const Name: string; var Index: Integer;
  const StartIndex, EndIndex: Integer): Boolean;
begin
  if Sorted then
  begin
    Result:=Find(Name,Index);
    Result:= Result and (Index>=StartIndex) and (Index<=EndIndex);
  end else
  begin
    Index:=IndexOf(Name);
    Result:=(Index>=StartIndex) and (Index<=EndIndex);
  end;
end;

procedure TKeyDateTimeDictionary.SetCount(const Value: Integer);
var
  OldCapacity,NewCapacity:Integer;
begin
  if Value<=0 then
  begin
    if (FList<>nil) then
    begin
      GlobalFreePtr(FList);
      FList:=nil;
      FCount:=0;
      FCapacity:=0;
    end;
    Exit;
  end;
  if Value = FCount then Exit;
  if Count =0 then
    OldCapacity:=0
  else OldCapacity:=Grow(Count);
  NewCapacity:=Grow(Value);
  if (OldCapacity<>NewCapacity) then
  begin
    if OldCapacity=0 then
      FList:=GlobalAllocPtr(GMEM_MOVEABLE,NewCapacity*NodeSize)
    else begin
      FList:=GlobalReAllocPtr(
        FList,
        NewCapacity*NodeSize,
        GMEM_MOVEABLE);
    end;
    if FList=nil then OutOfMemoryError
  end;
  if Value>Count then
    ZeroMemory(
      Pointer(LongInt(FList)+LongInt(Count*NodeSize)),
      (Value-Count)*NodeSize
    );
  FCapacity:=NewCapacity;
  FCount:=Value;
end;

procedure TKeyDateTimeDictionary.SetNames(Index: Integer; const Value: String);
begin
  if ValidIndex(Index)then
    List^[Index].Key:=Value;
end;

procedure TKeyDateTimeDictionary.SetObjects(Index: Integer;
  const Value: TObject);
begin
  if ValidIndex(Index)then
    List^[Index].Object_:=Value;
end;

procedure TKeyDateTimeDictionary.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted and (Count>1) then
        QuickSort(0,Count-1);
  end;
end;

procedure TKeyDateTimeDictionary.SetValues(Index: Integer;
  const Value: TDateTime);
begin
  if ValidIndex(Index)then
    List^[Index].Value:=Value;
end;

procedure TKeyDateTimeDictionary.Sort;
begin
  if not Sorted then
    Sorted:=True;
end;

function TKeyDateTimeDictionary.ValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index>=0)and(Index<Count);
end;

function TKeyDateTimeDictionary.ValueByName(Name: string):TDateTime;
const
  Const_Default_DateTime=1890-12-31;
var
  Index:Integer;
begin
  Result:=Const_Default_DateTime;
  if Find(Name,Index)then
    Result:=Values[Index];
end;



end.

