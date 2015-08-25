unit Serialize;

interface


uses Classes,SysUtils,Windows,TypInfo,Variants,SyncObjs;

const
  FluidizerSignature:LongInt=$3F89572A;

type
  TValueType = (vaNull, vaList, vaInt8, vaInt16, vaInt32, vaExtended,
    vaString, vaIdent, vaFalse, vaTrue, vaBinary, vaSet, vaLString,
    vaNil, vaCollection, vaSingle, vaCurrency, vaDate, vaWString,
    vaInt64, vaUTF8String,vaArray);

  EFluidizerError=class(Exception);

  ISerialize=interface
  ['{4B974894-7091-4C0D-B06B-0645D98B1435}']
    procedure Write(Instance:TPersistent;Stream:TStream);
  end;

  IDeserialize=interface
  ['{45944774-CA0B-4538-B902-EB3DBA26D2A6}']
    function Read(Stream:TStream):TPersistent;overload;
    function Read(Instance:TPersistent;Stream:TStream):TPersistent;overload;
  end;

  TSerializedPersistent=class(TPersistent)
  public
    procedure Initialize;virtual;abstract;
  end;
  
  PClassItem=^TClassItem;
  TClassItem=record
    ClassName:string;
    _Class:TPersistentClass;
  end;
  PClassItemList=^TClassItemList;
  TClassItemList=array[0..Maxint div SizeOf(TClassItem)-1]of TClassItem;

   TClassItems=class(TComponent)
  private
    FList: PClassItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    function GetCount: Integer;
    function GetItems(Index: Integer): TClassItem;
    function GetNames(Index: Integer): String;
    function GetValues(Index: Integer): TPersistentClass;
    procedure SetNames(Index: Integer; const Value: String);
    procedure SetValues(Index: Integer; const Value: TPersistentClass);
    function GetSorted: Boolean;
    procedure SetSorted(const Value: Boolean);
    procedure SetCount(const Value: Integer);
    procedure InsertItem(Index:Integer;const AName:string;const AValue:TPersistentClass);
    function GetNodeSize: Integer;
  protected
    function Grow(const NewCount:Integer):Integer;virtual;
    function ValidIndex(Index:Integer):Boolean;
    procedure QuickSort(L,R:Integer);
    function CompareStrings(const S1, S2: string): Integer;
    property NodeSize:Integer read GetNodeSize;
    property List:PClassItemList read FList;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;virtual;
    procedure Sort;
    function Add(const Name:string;const Value:TPersistentClass):Integer;
    procedure Insert(Index:Integer;const Name:string;const Value:TPersistentClass);
    procedure Delete(Index:Integer);
    procedure Exchange(const OneIndex,TwoIndex:Integer);
    procedure Move(const OldIndex,NewIndex:Integer);
    function IndexOf(const Name:string):Integer;
    function Find(const Name:string;var Index:Integer):Boolean;
    function ValueByName(Name:string):TPersistentClass;
    property Count:Integer read GetCount;
    property Items[Index:Integer]:TClassItem read GetItems;default;
    property Names[Index:Integer]:String read GetNames write SetNames;
    property Values[Index:Integer]:TPersistentClass read GetValues write SetValues;
    property Sorted:Boolean read GetSorted write SetSorted;
    property CaseSensitive:Boolean read FCaseSensitive write FCaseSensitive;
  end;

  
  TClassSearcher=class(TObject)
  private
    ClassItems:TClassItems;
    FLock:TCriticalSection;
    function GetClassCount: Integer;
  protected
    procedure Lock;
    procedure UnLock;
    property ClassCount:Integer read GetClassCount;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Register(Class_:TPersistentClass);
    procedure UnRegister(Class_:TPersistentClass);overload;
    procedure UnRegister(ClassName:string);overload;
    function Search(ClassName:String):TPersistentClass;

  end;


  TFluidizer=class(TInterfacedObject)
  protected
    FPropPath:string;
    FStream:TStream;
    procedure FlushBuffer; virtual; abstract;
  end;

  TSerializeWriter=class(TFluidizer,ISerialize)
  private
    function GetPosition: Longint;
    procedure SetPosition(const Value: Longint);
  protected
    procedure FlushBuffer; override;
    procedure WriteMinStr(const LocaleStr: string; const UTF8Str: UTF8String);
    procedure WritePersistent(Instance:TPersistent);
    procedure WriteProperty(Instance: TPersistent; PropInfo: PPropInfo);
    procedure WriteProperties(Instance: TPersistent);
    procedure WritePropName(const PropName: string);
    procedure WriteValue(Value: TValueType);
    procedure Write(const Buf; Count: Longint);overload;
    procedure WriteBoolean(Value: Boolean);
    procedure WriteChar(Value: Char);
    procedure WriteFloat(const Value: Extended);
    procedure WriteSingle(const Value: Single);
    procedure WriteCurrency(const Value: Currency);
    procedure WriteDate(const Value: TDateTime);
    procedure WriteIdent(const Ident: string);
    procedure WriteInteger(Value: Longint); overload;
    procedure WriteInteger(Value: Int64); overload;
    procedure WriteCollection(Value: TCollection);
    procedure WriteListBegin;
    procedure WriteListEnd;
    procedure WriteSignature;
    procedure WriteStr(const Value: string);
    procedure WriteString(const Value: string);
    procedure WriteWideString(const Value: WideString);
    procedure WriteVariant(const Value: Variant);
    property Position: Longint read GetPosition write SetPosition;
  public
    procedure Write(Instance:TPersistent;Stream:TStream);overload;

  end;

  TDeserializeReader=class(TFluidizer,IDeserialize)
  protected
    FPropName:string;
    procedure PropValueError;
    procedure PropertyError;
    procedure ReadPropertys(AInstance: TPersistent);
    procedure ReadProperty(AInstance: TPersistent);
    procedure ReadPropValue(Instance: TPersistent; PropInfo: Pointer);
    function ReadSet(SetType: Pointer): Integer;
    procedure CheckValue(Value: TValueType);
    function EndOfList: Boolean;
    procedure FlushBuffer; override;
    function NextValue: TValueType;
    procedure Read(var Buf; Count: Longint);overload;
    procedure ReadCollection(Collection: TCollection);
    function ReadPersistent(Instance: TPersistent): TPersistent;
    function ReadBoolean: Boolean;
    function ReadChar: Char;
    function ReadFloat: Extended;
    function ReadSingle: Single;
    function ReadCurrency: Currency;
    function ReadDate: TDateTime;
    function ReadIdent: string;
    function ReadInteger: Longint;
    function ReadInt64: Int64;
    procedure ReadListBegin;
    procedure ReadListEnd;
    procedure ReadSignature;
    function ReadStr: string;
    function ReadString: string;
    function ReadWideString: WideString;
    function ReadValue: TValueType;
    function ReadVariant: Variant;
    procedure SkipValue;
    procedure SkipSetBody;
    procedure SkipBytes(Count: Integer);
    procedure SkipProperty;
  public
    function Read(Stream:TStream):TPersistent;overload;
    function Read(Instance:TPersistent;Stream:TStream):TPersistent;overload;
  end;


  procedure VariantToStream(const Data:Variant;Stream:TStream);
  procedure StreamToVariant(Stream:TStream;var Data:Variant);
  

var
  ClassSearcher:TClassSearcher;
    
implementation

uses RTLConsts;


procedure VariantToStream(const Data:Variant;Stream:TStream);
var
  P:Pointer;
  Len:Integer;
begin
  Stream.Size:=0;
  if VarIsNull(Data)or VarIsEmpty(Data)or VarIsEmptyParam(Data)then Exit;
  Len:=VarArrayHighBound(Data,1)+1;
  P:=VarArrayLock(Data);
  try
    Stream.Write(P^,Len);
  finally
    VarArrayUnlock(Data);
  end;
end;

procedure StreamToVariant(Stream:TStream;var Data:Variant);
var
  P:Pointer;
begin
  Data:=Null;
  if Stream.Size<=0then Exit;
  Data:=VarArrayCreate([0,Stream.Size-1],varByte);
  P:=VarArrayLock(Data);
  try
    Stream.Position:=0;
    Stream.Read(P^,Stream.size);
  finally
    VarArrayUnlock(Data);
  end;
end;  
{ TSerializeWriter }


procedure TSerializeWriter.FlushBuffer;
begin
  inherited FlushBuffer;
end;

function TSerializeWriter.GetPosition: Longint;
begin
  Result := FStream.Position;
end;

procedure TSerializeWriter.SetPosition(const Value: Longint);
begin
  FStream.Position:=Value;
end;

procedure TSerializeWriter.Write(const Buf; Count: Integer);
begin
  FStream.Write(Buf,Count);
end;


procedure TSerializeWriter.Write(Instance: TPersistent; Stream: TStream);
begin
  if Instance=nil then Exit;
  FPropPath:='';
  FStream:=Stream;
  WriteSignature;
  WritePersistent(Instance);
end;

procedure TSerializeWriter.WriteBoolean(Value: Boolean);
begin
  if Value then
    WriteValue(vaTrue)
  else
    WriteValue(vaFalse);
end;


procedure TSerializeWriter.WriteChar(Value: Char);
begin
  WriteString(Value);
end;

procedure TSerializeWriter.WriteCollection(Value: TCollection);
var
  I: Integer;
begin
  WriteValue(vaCollection);
  if Value <> nil then
    for I := 0 to Value.Count - 1 do
    begin
      WriteListBegin;
      WriteProperties(Value.Items[I]);
      WriteListEnd;
    end;
  WriteListEnd;
end;

procedure TSerializeWriter.WriteCurrency(const Value: Currency);
begin
  WriteValue(vaCurrency);
  Write(Value, SizeOf(Currency));
end;

procedure TSerializeWriter.WriteDate(const Value: TDateTime);
begin
  WriteValue(vaDate);
  Write(Value, SizeOf(TDateTime));
end;

procedure TSerializeWriter.WriteFloat(const Value: Extended);
begin
  WriteValue(vaExtended);
  Write(Value, SizeOf(Extended));
end;

procedure TSerializeWriter.WriteIdent(const Ident: string);
begin
  if SameText(Ident, 'False') then WriteValue(vaFalse) else
  if SameText(Ident ,'True') then WriteValue(vaTrue) else
  if SameText(Ident ,'Null') then WriteValue(vaNull) else
  if SameText(Ident, 'nil') then WriteValue(vaNil) else
  begin
    WriteValue(vaIdent);
    WriteStr(Ident);
  end;
end;

procedure TSerializeWriter.WriteInteger(Value: Integer);
begin
  if (Value >= Low(ShortInt)) and (Value <= High(ShortInt)) then
  begin
    WriteValue(vaInt8);
    Write(Value, SizeOf(Shortint));
  end else
  if (Value >= Low(SmallInt)) and (Value <= High(SmallInt)) then
  begin
    WriteValue(vaInt16);
    Write(Value, SizeOf(Smallint));
  end
  else
  begin
    WriteValue(vaInt32);
    Write(Value, SizeOf(Integer));
  end;
end;

procedure TSerializeWriter.WriteInteger(Value: Int64);
begin
  if (Value >= Low(Integer)) and (Value <= High(Integer)) then
    WriteInteger(Longint(Value))
  else
  begin
    WriteValue(vaInt64);
    Write(Value, Sizeof(Int64));
  end;
end;

procedure TSerializeWriter.WriteListBegin;
begin
  WriteValue(vaList);
end;

procedure TSerializeWriter.WriteListEnd;
begin
  WriteValue(vaNull);
end;

procedure TSerializeWriter.WriteMinStr(const LocaleStr: string;
  const UTF8Str: UTF8String);
var
  L: Integer;
begin
  if LocaleStr <> UTF8Str then
  begin
    L := Length(UTF8Str);
    WriteValue(vaUtf8String);
    Write(L, SizeOf(Integer));
    Write(Pointer(UTF8Str)^, L);
  end
  else
  begin
    L := Length(LocaleStr);
    if L <= 255 then
    begin
      WriteValue(vaString);
      Write(L, SizeOf(Byte));
    end else
    begin
      WriteValue(vaLString);
      Write(L, SizeOf(Integer));
    end;
    Write(Pointer(LocaleStr)^, L);
  end;
end;

procedure TSerializeWriter.WritePersistent(Instance: TPersistent);
begin
  WriteStr(Instance.ClassName);
  WriteProperties(Instance);
  WriteListEnd;
end;

procedure TSerializeWriter.WriteProperties(Instance: TPersistent);
var
  I, Count: Integer;
  PropInfo: PPropInfo;
  PropList: PPropList;
begin
  Count := TypInfo.GetTypeData(Instance.ClassInfo)^.PropCount;
  if Count > 0 then
  begin
    GetMem(PropList, Count * SizeOf(Pointer));
    try
      GetPropInfos(Instance.ClassInfo, PropList);
      for I := 0 to Count - 1 do
      begin
        PropInfo := PropList^[I];
        if PropInfo = nil then  Break;
        if IsStoredProp(Instance, PropInfo) then
          WriteProperty(Instance, PropInfo);
      end;
    finally
      FreeMem(PropList, Count * SizeOf(Pointer));
    end;
  end;
end;

procedure TSerializeWriter.WriteProperty(Instance: TPersistent;
  PropInfo: PPropInfo);
var
  PropType: PTypeInfo;
  procedure WritePropPath;
  begin
    WritePropName(PPropInfo(PropInfo)^.Name);
  end;

  procedure WriteSet(Value: Longint);
  var
    I: Integer;
    BaseType: PTypeInfo;
  begin
    BaseType := GetTypeData(PropType)^.CompType^;
    WriteValue(vaSet);
    for I := 0 to SizeOf(TIntegerSet) * 8 - 1 do
      if I in TIntegerSet(Value) then WriteStr(GetEnumName(BaseType, I));
    WriteStr('');
  end;

  procedure WriteIntProp(IntType: PTypeInfo; Value: Longint);
  var
    Ident: string;
    IntToIdent: TIntToIdent;
  begin
    IntToIdent := FindIntToIdent(IntType);
    if Assigned(IntToIdent) and IntToIdent(Value, Ident) then
      WriteIdent(Ident)
    else
      WriteInteger(Value);
  end;

  procedure WriteCollectionProp(Collection: TCollection);
  var
    SavePropPath: string;
  begin
    //WritePropPath;
    SavePropPath := FPropPath;
    try
      FPropPath := '';
      WriteCollection(Collection);
    finally
      FPropPath := SavePropPath;
    end;
  end;

  procedure WriteOrdProp;
  var
    Value: Longint;
  begin
    Value := GetOrdProp(Instance, PropInfo);
    WritePropPath;
    case PropType^.Kind of
      tkInteger:
        WriteIntProp(PPropInfo(PropInfo)^.PropType^, Value);
      tkChar:
        WriteChar(Chr(Value));
      tkSet:
        WriteSet(Value);
      tkEnumeration:
        WriteIdent(GetEnumName(PropType, Value));
    end;
  end;

  procedure WriteFloatProp;
  var
    Value: Extended;
  begin
    Value := GetFloatProp(Instance, PropInfo);
    WritePropPath;
    WriteFloat(Value);
  end;

  procedure WriteInt64Prop;
  var
    Value: Int64;
  begin
    Value := GetInt64Prop(Instance, PropInfo);
    WritePropPath;
    WriteInteger(Value);
  end;

  procedure WriteStrProp;
  var
    Value: WideString;
  begin
    Value := GetWideStrProp(Instance, PropInfo);
    WritePropPath;
    WriteWideString(Value);
  end;
  procedure WriteObjectProp;
  var
    Value: TPersistent;
    SavePath:string;
  begin
    if(TObject(GetOrdProp(Instance,PropInfo)) is TPersistent)then
    begin
      Value:=TPersistent(GetOrdProp(Instance,PropInfo));
      if Value=nil then
      begin
        WritePropPath;
        WriteValue(vaNil);
      end else
      begin
        WritePropPath;
        SavePath:=FPropPath;
        try
          FPropPath:=FPropPath+PropInfo^.Name + '.';
          if Value is TCollection then
            WriteCollectionProp(TCollection(Value));
          WriteProperties(Value);{Abc.abc}
          {WriteListEnd;}
        finally
          FPropPath:=SavePath;
        end;
      end;
    end;
  end;

  procedure WriteVariantProp;
  var
    Value: Variant;
  begin
    Value := GetVariantProp(Instance, PropInfo);
    WritePropPath;
    WriteVariant(Value);
  end;

begin

  if (PropInfo^.GetProc <> nil) and
     ((PropInfo^.SetProc <> nil) or
     ((PropInfo^.PropType^.Kind = tkClass) and
     (TObject(GetOrdProp(Instance, PropInfo)) is TPersistent))) then
  begin
    PropType := PropInfo^.PropType^;
    case PropType^.Kind of
      tkInteger, tkChar, tkEnumeration, tkSet:WriteOrdProp;
      tkFloat:WriteFloatProp;
      tkString, tkLString, tkWString:WriteStrProp;
      tkClass:WriteObjectProp;// 这个地方要好好的思考一下
      tkVariant:WriteVariantProp;
      tkInt64:WriteInt64Prop;
    end;
  end;
end;

procedure TSerializeWriter.WritePropName(const PropName: string);
begin
  WriteStr(FPropPath+PropName);
end;

procedure TSerializeWriter.WriteSignature;
begin
  FStream.Write(FluidizerSignature,SizeOf(LongInt));
end;

procedure TSerializeWriter.WriteSingle(const Value: Single);
begin
  WriteValue(vaSingle);
  Write(Value, SizeOf(Single));
end;

procedure TSerializeWriter.WriteStr(const Value: string);

var
  L: Integer;
begin
  L := Length(Value);
  if L > 255 then L := 255;
  Write(L, SizeOf(Byte));
  Write(Value[1], L);
end;

procedure TSerializeWriter.WriteString(const Value: string);
begin
  WriteMinStr(Value, AnsiToUtf8(Value));
end;

procedure TSerializeWriter.WriteValue(Value: TValueType);
begin
  Write(Value, SizeOf(Value));
end;

procedure TSerializeWriter.WriteVariant(const Value: Variant);
const
  VarValue=Integer(vaUTF8String)+1;
var
  CustomType: TCustomVariantType;
  OuterStream, InnerStream: TMemoryStream;
  OuterWriter: TWriter;
  StreamSize: Integer;
  VarStreamer: IVarStreamable;
  LInt64: Int64;
  Size:Int64;
  P:Pointer;
begin
  if not VarIsArray(Value)then
  begin
    case VarType(Value) and varTypeMask of
      varEmpty:
        WriteValue(vaNil);
      varNull:
        WriteValue(vaNull);
      varOleStr:
        WriteWideString(Value);
      varString:
        WriteString(Value);
      varByte,varShortInt, varWord, varSmallInt, varInteger:
        WriteInteger(Value);
      varSingle:
        WriteSingle(Value);
      varDouble:
        WriteFloat(Value);
      varCurrency:
        WriteCurrency(Value);
      varDate:
        WriteDate(Value);
      varBoolean:
        if Value then
          WriteValue(vaTrue)
        else
          WriteValue(vaFalse);
      varLongWord, varInt64:
        begin
          LInt64 := Value;
          WriteInteger(LInt64);
        end;
      else
      try
        if not FindCustomVariantType(TVarData(Value).VType, CustomType) or
           not Supports(Value, IVarStreamable, VarStreamer) then
          WriteString(Value)
        else
        begin
          InnerStream := nil;
          OuterStream := TMemoryStream.Create;
          try
            InnerStream := TMemoryStream.Create;
            OuterWriter := TWriter.Create(OuterStream, 1024);
            try
              VarStreamer.StreamOut(TVarData(Value), InnerStream);
              StreamSize := InnerStream.Size;

              OuterWriter.WriteString(CustomType.ClassName);
              OuterWriter.Write(StreamSize, SizeOf(StreamSize));
              OuterWriter.Write(InnerStream.Memory^, StreamSize);
            finally
              OuterWriter.Free;
            end;
            StreamSize := OuterStream.Size;
            WriteValue(vaBinary);
            Write(StreamSize, SizeOf(StreamSize));
            Write(OuterStream.Memory^, StreamSize);
          finally
            InnerStream.Free;
            OuterStream.Free;
          end;
        end;
      except
        raise EFluidizerError.Create('写数据流错误');
      end;
    end;
  end else
  begin
    if VarArrayDimCount(Value)<>1 then
      raise EFluidizerError.Create('写数据流错误');
    WriteValue(vaArray);
    Size:=VarArrayHighBound(Value,1)-VarArrayLowBound(Value,1)+1;
    WriteInteger(Size);
    P:=VarArrayLock(Value);
    try
      Write(P^,Size);
    finally
      VarArrayUnlock(Value);
    end;
  end;
end;

procedure TSerializeWriter.WriteWideString(const Value: WideString);

var
  L: Integer;
  Utf8Str: UTF8String;
begin
  Utf8Str := Utf8Encode(Value);
  if Length(Utf8Str) < (Length(Value) * SizeOf(WideChar)) then
    WriteMinStr(Value, Utf8Str)
  else
  begin
    WriteValue(vaWString);
    L := Length(Value);
    Write(L, SizeOf(Integer));
    Write(Pointer(Value)^, L * 2);
  end;
end;

{ TDeserializeReader }

procedure TDeserializeReader.CheckValue(Value: TValueType);
begin
  if ReadValue <> Value then
  begin
    FStream.Position:=FStream.Position-SizeOf(TValueType);
    SkipValue;
    PropValueError;
  end;

end;



function TDeserializeReader.EndOfList: Boolean;
begin
  Result := ReadValue = vaNull;
  FStream.Position:=FStream.Position-SizeOf(TValueType);
end;

procedure TDeserializeReader.FlushBuffer;
begin
  inherited FlushBuffer;
end;

function TDeserializeReader.NextValue: TValueType;
begin
  Result := ReadValue;
  FStream.Position:=FStream.Position-SizeOf(TValueType);
end;

procedure TDeserializeReader.PropertyError;
begin
  raise EFluidizerError.Create('反序列化,存在无效的属性');
end;

procedure TDeserializeReader.PropValueError;
begin
  raise EFluidizerError.Create('读取数据流值错误');
end;

function TDeserializeReader.Read(Instance: TPersistent;
  Stream: TStream): TPersistent;
begin
  FStream:=Stream;
  FStream.Position:=0;
  ReadSignature;
  Result:=ReadPersistent(Instance);
end;

function TDeserializeReader.Read(Stream: TStream): TPersistent;
var
  OBJ:TPersistent;
begin
  OBJ:=nil;
  Result:=Read(OBJ,Stream);
end;




procedure TDeserializeReader.Read(var Buf; Count: Integer);
begin
  FStream.Read(Buf,Count);
end;

function TDeserializeReader.ReadBoolean: Boolean;
begin
  Result := ReadValue = vaTrue;
end;

function TDeserializeReader.ReadChar: Char;
var
  Temp: string;
begin
  Temp := ReadString;
  if Length(Temp) > 1 then
    PropValueError;
  Result := Temp[1];
end;

procedure TDeserializeReader.ReadCollection(Collection: TCollection);
var
  Item: TPersistent;
begin
  Collection.BeginUpdate;
  try
    if not EndOfList then
      Collection.Clear;
    while not EndOfList do
    begin
      if NextValue in [vaInt8, vaInt16, vaInt32] then ReadInteger;
      Item:=Collection.Add;
      ReadListBegin;
      while not EndOfList do
        ReadProperty(Item);
      ReadListEnd;
    end;
    ReadListEnd;
  finally
    Collection.EndUpdate;
  end;
end;

function TDeserializeReader.ReadCurrency: Currency;
begin
  if ReadValue = vaCurrency then
    Read(Result, SizeOf(Result))
  else
  begin
    FStream.Position:=FStream.Position-SizeOf(TVAlueType);
    Result := ReadInt64;
  end;
end;


function TDeserializeReader.ReadDate: TDateTime;
begin
  if ReadValue = vaDate then
    Read(Result, SizeOf(Result))
  else
  begin
    FStream.Position:=FStream.Position-SizeOf(TVAlueType);
    Result := ReadInt64;
  end;

end;

function TDeserializeReader.ReadFloat: Extended;
begin
  if ReadValue = vaExtended then
    Read(Result, SizeOf(Result))
  else
  begin
    FStream.Position:=FStream.Position-SizeOf(TVAlueType);
    Result := ReadInt64;
  end;
end;

function TDeserializeReader.ReadIdent: string;
var
  L: Byte;
begin
  case ReadValue of
    vaIdent:
      begin
        Read(L, SizeOf(Byte));
        SetString(Result, PChar(nil), L);
        Read(Result[1], L);
      end;
    vaFalse:
      Result := 'False';
    vaTrue:
      Result := 'True';
    vaNil:
      Result := 'nil';
    vaNull:
      Result := 'Null';
  else
    PropValueError;
  end;
end;

function TDeserializeReader.ReadInt64: Int64;
begin
  if NextValue = vaInt64 then
  begin
    ReadValue;
    Read(Result, SizeOf(Result));
  end
  else
    Result := ReadInteger;

end;

function TDeserializeReader.ReadInteger: Longint;
var
  S: Shortint;
  I: Smallint;
begin
  case ReadValue of
    vaInt8:
      begin
        Read(S, SizeOf(S));
        Result := S;
      end;
    vaInt16:
      begin
        Read(I, SizeOf(I));
        Result := I;
      end;
    vaInt32:
      Read(Result, SizeOf(Result));
  else
    PropValueError;
  end;
end;

procedure TDeserializeReader.ReadListBegin;
begin
  CheckValue(vaList);

end;

procedure TDeserializeReader.ReadListEnd;
begin
  CheckValue(vaNull);
end;

function TDeserializeReader.ReadPersistent(
  Instance: TPersistent): TPersistent;
var
  ClassName_:string;
  PersistentClass:TPersistentClass;
begin
  ClassName_:=ReadStr;
  if Instance=nil then
  begin
    PersistentClass:=ClassSearcher.Search(ClassName_);
    if(PersistentClass=nil)then
      raise EFluidizerError.Create('反序列化错误,没有注册相对应的类.');
    Result:=PersistentClass.Create;
    TSerializedPersistent(Result).Initialize;
  end else
    Result:=Instance;
  ReadPropertys(Result);
end;

procedure TDeserializeReader.ReadProperty(AInstance: TPersistent);
var
  I, J, L: Integer;
  Instance: TPersistent;
  PropInfo: PPropInfo;
  PropValue: TObject;
  PropPath: string;
begin
  try
    PropPath:=ReadStr;
    try
      I:=1;
      L:=Length(PropPath);
      Instance:=AInstance;
      while True do
      begin
        J:=I;
        while (I <= L) and (PropPath[I] <> '.') do Inc(I);
        FPropName:=Copy(PropPath, J, I - J);
        if I>L then Break;
        //Summary:
        // 处理有属性里面含有对象的类
        PropInfo := GetPropInfo(Instance.ClassInfo, FPropName);
        if PropInfo=nil then PropertyError;
        PropValue:=nil;
        if (PropInfo^.PropType^.Kind = tkClass) then
          PropValue := TObject(GetOrdProp(Instance, PropInfo));
        if PropValue=nil then PropertyError;
        if not (PropValue is TPersistent) then PropertyError;
        Instance:=TPersistent(PropValue); //OBJ.Connects;
        Inc(I);
      end;
      PropInfo := GetPropInfo(Instance.ClassInfo, FPropName);
      if PropInfo <> nil then
        ReadPropValue(Instance, PropInfo)
      else begin
        if FPropName <> '' then PropertyError;
      end;
    except
      on E:Exception do
      begin
        PropertyError;
      end;
    end;
  except
    on E:Exception do
    begin
      PropertyError;
    end;
  end;
end;

procedure TDeserializeReader.ReadPropertys(AInstance: TPersistent);
begin
  while not EndOfList do
    ReadProperty(AInstance);
  ReadListEnd;
end;

procedure TDeserializeReader.ReadPropValue(Instance: TPersistent;
  PropInfo: Pointer);
var
  PropType: PTypeInfo;
  procedure SetIntIdent(Instance: TPersistent; PropInfo: Pointer;
    const Ident: string);
  var
    V: Longint;
    IdentToInt: TIdentToInt;
  begin
    IdentToInt := FindIdentToInt(PPropInfo(PropInfo)^.PropType^);
    if Assigned(IdentToInt) and IdentToInt(Ident, V) then
      SetOrdProp(Instance, PropInfo, V)
    else
      PropValueError;
  end;


  procedure SetVariantReference;
  begin
    SetVariantProp(Instance, PropInfo, ReadVariant);
  end;



begin
  if PPropInfo(PropInfo)^.SetProc = nil then
    if not ((PPropInfo(PropInfo)^.PropType^.Kind = tkClass) and
      (TObject(GetOrdProp(Instance, PropInfo)) is TPersistent))then
      PropertyError;
  PropType := PPropInfo(PropInfo)^.PropType^;
  case PropType^.Kind of
    tkInteger:
      if NextValue = vaIdent then
        SetIntIdent(Instance, PropInfo, ReadIdent)
      else
        SetOrdProp(Instance, PropInfo, ReadInteger);
    tkChar:
      SetOrdProp(Instance, PropInfo, Ord(ReadChar));
    tkEnumeration:
      SetOrdProp(Instance, PropInfo, GetEnumValue(PropType, ReadIdent));
    tkFloat:
      SetFloatProp(Instance, PropInfo, ReadFloat);
    tkString, tkLString:
      SetStrProp(Instance, PropInfo, ReadString);
    tkWString:
      SetWideStrProp(Instance, PropInfo, ReadWideString);
    tkSet:
      SetOrdProp(Instance, PropInfo, ReadSet(PropType));
    tkClass:
    begin
      case NextValue of
        vaNil:ReadValue;
        vaCollection:
        begin
          ReadValue;
          ReadCollection(TCollection(GetOrdProp(Instance, PropInfo)));
        end
      end;
    end;
    tkVariant:SetVariantReference;
    tkInt64:SetInt64Prop(Instance, PropInfo, ReadInt64);
  end;
end;

function TDeserializeReader.ReadSet(SetType: Pointer): Integer;
var
  EnumType: PTypeInfo;
  EnumName: string;
  function EnumValue(EnumType: PTypeInfo; const EnumName: string): Integer;
  begin
    Result := GetEnumValue(EnumType, EnumName);
    if Result = -1 then PropValueError;
  end;
begin
  try
    if ReadValue <> vaSet then PropValueError;
    EnumType := GetTypeData(SetType)^.CompType^;
    Result := 0;
    while True do
    begin
      EnumName := ReadStr;
      if EnumName = '' then Break;
      Include(TIntegerSet(Result), EnumValue(EnumType, EnumName));
    end;
  except
    SkipSetBody;
    raise;
  end;
end;

procedure TDeserializeReader.ReadSignature;
var
  Signature:LongInt;
begin
  Read(Signature,SizeOf(LongInt));
  if(Signature<>FluidizerSignature)then
    EFluidizerError.Create('流格式不正确.');
end;

function TDeserializeReader.ReadSingle: Single;
begin
  if ReadValue = vaSingle then
    Read(Result, SizeOf(Result))
  else
  begin
    FStream.Position:=FStream.Position-SizeOf(TVAlueType);
    Result := ReadInt64;
  end;

end;

function TDeserializeReader.ReadStr: string;
var
  L: Byte;
begin
  Read(L, SizeOf(Byte));
  SetString(Result, PChar(nil), L);
  Read(Result[1], L);
end;

function TDeserializeReader.ReadString: string;
var
  L: Integer;
begin
  if NextValue in [vaWString, vaUTF8String] then
    Result := ReadWideString
  else
  begin
    L := 0;
    case ReadValue of
      vaString:
        Read(L, SizeOf(Byte));
      vaLString:
        Read(L, SizeOf(Integer));
    else
     PropValueError;
    end;
    SetLength(Result, L);
    Read(Pointer(Result)^, L);
  end;
end;

function TDeserializeReader.ReadValue: TValueType;
begin
  Read(Result, SizeOf(Result));
end;

function TDeserializeReader.ReadVariant: Variant;
var
  Size:Int64;
  P:Pointer;
  function ReadCustomVariant: Variant;
  var
    OuterStream, InnerStream: TMemoryStream;
    OuterReader: TReader;
    StreamSize: Integer;
    CustomType: TCustomVariantType;
    CustomTypeClassName: string;
    VarStreamer: IVarStreamable;
  begin
    CheckValue(vaBinary);

    InnerStream := nil;
    OuterStream := TMemoryStream.Create;
    try
      InnerStream := TMemoryStream.Create;

      Read(StreamSize, SizeOf(StreamSize));
      OuterStream.Size := StreamSize;
      Read(OuterStream.Memory^, StreamSize);

      OuterReader := TReader.Create(OuterStream, 1024);
      try
        CustomTypeClassName := OuterReader.ReadString;
        OuterReader.Read(StreamSize, SizeOf(StreamSize));
        InnerStream.Size := StreamSize;
        OuterReader.Read(InnerStream.Memory^, StreamSize);

        if not FindCustomVariantType(CustomTypeClassName, CustomType) or
           not Supports(CustomType, IVarStreamable, VarStreamer) then
          raise EFluidizerError.Create('反序列化错误.');
        TVarData(Result).VType := CustomType.VarType;
        VarStreamer.StreamIn(TVarData(Result), InnerStream);
      finally
        OuterReader.Free;
      end;
    finally
      InnerStream.Free;
      OuterStream.Free;
    end;
  end;

begin
  VarClear(Result);
  case NextValue of
    vaNil, vaNull:       if ReadValue <> vaNil then
                           Result := Variants.Null;
    vaInt8:              Result := Shortint(ReadInteger);
    vaInt16:             Result := Smallint(ReadInteger);
    vaInt32:             Result := ReadInteger;
    vaExtended:          Result := ReadFloat;
    vaSingle:            Result := ReadSingle;
    vaCurrency:          Result := ReadCurrency;
    vaDate:              Result := ReadDate;
    vaString, vaLString: Result := ReadString;
    vaWString,
    vaUTF8String:        Result := ReadWideString;
    vaFalse, vaTrue:     Result := (ReadValue = vaTrue);
    vaBinary:            Result := ReadCustomVariant;
    vaInt64:             Result := ReadInt64;
    vaArray:
    begin
      ReadValue;
      Size:=ReadInt64;
      Result:=VarArrayCreate([0,Size],VarByte);
      P:=VarArrayLock(Result);
      try
        Read(P^,Size)
      finally
        VarArrayUnlock(Result);
      end;
    end;
  else
    raise EReadError.CreateRes(@SReadError);
  end;
end;

function TDeserializeReader.ReadWideString: WideString;
var
  L: Integer;
  Temp: UTF8String;
begin
  if NextValue in [vaString, vaLString] then
    Result := ReadString
  else
  begin
    L := 0;
    case ReadValue of
      vaWString:
        begin
          Read(L, SizeOf(Integer));
          SetLength(Result, L);
          Read(Pointer(Result)^, L * 2);
        end;
      vaUTF8String:
        begin
          Read(L, SizeOf(Integer));
          SetLength(Temp, L);
          Read(Pointer(Temp)^, L);
          Result := Utf8Decode(Temp);
        end;
    else
      PropValueError;
    end;
  end;
end;



procedure TDeserializeReader.SkipBytes(Count: Integer);
var
  Bytes: array[0..255] of Char;
begin
  while Count > 0 do
    if Count > SizeOf(Bytes) then
    begin
      Read(Bytes, SizeOf(Bytes));
      Dec(Count, SizeOf(Bytes));
    end
    else
    begin
      Read(Bytes, Count);
      Count := 0;
    end;

end;

procedure TDeserializeReader.SkipProperty;
begin
  ReadStr; { Skips property name }
  SkipValue;
end;

procedure TDeserializeReader.SkipSetBody;
begin
  while ReadStr <> '' do
  begin
  end;
end;

procedure TDeserializeReader.SkipValue;
  procedure SkipList;
  begin
    while not EndOfList do SkipValue;
    ReadListEnd;
  end;

  procedure SkipBinary(BytesPerUnit: Integer);
  var
    Count: Longint;
  begin
    Read(Count, SizeOf(Count));
    SkipBytes(Count * BytesPerUnit);
  end;

  procedure SkipCollection;
  begin
    while not EndOfList do
    begin
      if NextValue in [vaInt8, vaInt16, vaInt32] then SkipValue;
      SkipBytes(1);
      while not EndOfList do SkipProperty;
      ReadListEnd;
    end;
    ReadListEnd;
  end;
  procedure SkipArray;
  var
    Size:Integer;
    P:Pointer;
    Data:Variant;
  begin
    Size:=ReadInt64;
    Data:=VarArrayCreate([0,Size],VarByte);
    P:=VarArrayLock(Data);
    try
      Read(P^,Size)
    finally
      VarArrayUnlock(Data);
      Data:=NULL;
    end;
  end;

begin
  case ReadValue of
    vaNull: { no value field, just an identifier };
    vaList: SkipList;
    vaInt8: SkipBytes(SizeOf(Byte));
    vaInt16: SkipBytes(SizeOf(Word));
    vaInt32: SkipBytes(SizeOf(LongInt));
    vaExtended: SkipBytes(SizeOf(Extended));
    vaString, vaIdent: ReadStr;
    vaFalse, vaTrue: { no value field, just an identifier };
    vaBinary: SkipBinary(1);
    vaSet: SkipSetBody;
    vaLString: SkipBinary(1);
    vaCollection: SkipCollection;
    vaSingle: SkipBytes(Sizeof(Single));
    vaCurrency: SkipBytes(SizeOf(Currency));
    vaDate: SkipBytes(Sizeof(TDateTime));
    vaWString: SkipBinary(Sizeof(WideChar));
    vaInt64: SkipBytes(Sizeof(Int64));
    vaUTF8String: SkipBinary(1);
    vaArray:SkipArray;
  end;
end;

{ TClassSearcher }

constructor TClassSearcher.Create;
begin
  inherited Create;
  ClassItems:=TClassItems.Create(nil);
  ClassItems.Sorted:=True;
  FLock:=TCriticalSection.Create;
end;

destructor TClassSearcher.Destroy;
begin
  FLock.Free;
  ClassItems.Free;
  inherited;
end;

function TClassSearcher.GetClassCount: Integer;
begin
  Result:=ClassItems.Count;
end;

procedure TClassSearcher.Lock;
begin
  FLock.Enter;
end;

procedure TClassSearcher.Register(Class_: TPersistentClass);
var
  Index:Integer;
begin
  Lock;
  try
    if not ClassItems.Find(Class_.ClassName,Index)then
      ClassItems.Add(Class_.ClassName,Class_);
  finally
    UnLock;
  end;
end;

function TClassSearcher.Search(ClassName: String): TPersistentClass;
var
  Index:Integer;
begin
  Lock;
  try
    Result:=nil;
    if ClassItems.Find(ClassName,Index)then
      Result:=ClassItems.Items[Index]._Class;
  finally
    UnLock;
  end;
end;

procedure TClassSearcher.UnRegister(Class_: TPersistentClass);
begin
  Lock;
  try
    UnRegister(Class_.ClassName);
  finally
    UnLock;
  end;
end;

procedure TClassSearcher.UnLock;
begin
  FLock.Leave;
end;

procedure TClassSearcher.UnRegister(ClassName: string);
var
  Index:Integer;
begin
  Lock;
  try
    if ClassItems.Find(ClassName,Index)then
      ClassItems.Delete(Index);
  finally
    UnLock;
  end;
end;




{ TClassItems }

function TClassItems.Add(const Name: string;
  const Value: TPersistentClass): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    Find(Name, Result);
  InsertItem(Result, Name, Value);
end;


procedure TClassItems.Assign(Source: TPersistent);
  procedure AddMaps(Maps:TClassItems);
  var
    I:Integer;
  begin
    for I:=0 to Maps.Count-1 do
      Add(Maps.Names[I],Maps.Values[I]);    
  end;
begin
  inherited;
  if Source is TClassItems then
  begin
    Clear;
    FSorted:=TClassItems(Source).Sorted;
    FCaseSensitive:=TClassItems(Source).CaseSensitive;
    AddMaps(TClassItems(Source));
  end;
end;


procedure TClassItems.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    SetCount(0);
  end;
end;

function TClassItems.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := AnsiCompareStr(S1, S2)
  else
    Result := AnsiCompareText(S1, S2);
end;

constructor TClassItems.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FCaseSensitive:=False;
  FCount:=0;
  FCapacity:=0;
end;

procedure TClassItems.Delete(Index: Integer);
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

destructor TClassItems.Destroy;
begin
  if FCount <> 0 then
    Finalize(FList^[0], FCount);
  SetCount(0);
  inherited;
end;

procedure TClassItems.Exchange(const OneIndex, TwoIndex: Integer);
var
  Temp:TClassItem;
begin
  if ValidIndex(OneIndex)and ValidIndex(TwoIndex)then
  begin
    Temp.ClassName:=FList^[oneIndex].ClassName;
    Temp._Class:=FList^[oneIndex]._Class;
    FList^[oneIndex].ClassName:=FList^[TwoIndex].ClassName;
    FList^[oneIndex]._Class:=FList^[TwoIndex]._Class;
    FList^[TwoIndex].ClassName:=Temp.ClassName;
    FList^[TwoIndex]._Class:=Temp._Class;
  end;
end;

function TClassItems.Find(const Name: string;
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
      c:=CompareStrings(Name,Items[M].ClassName);
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



function TClassItems.GetCount: Integer;
begin
  Result:=FCount;
end;

function TClassItems.GetItems(Index: Integer): TClassItem;
begin
  if ValidIndex(Index)then
    Result:=List^[Index];
end;

function TClassItems.GetNames(Index: Integer): String;
begin
  Result:='';
  if ValidIndex(Index)then
    Result:=Items[Index].ClassName;
end;

function TClassItems.GetNodeSize: Integer;
begin
  Result:=SizeOf(TClassItem);
end;


function TClassItems.GetSorted: Boolean;
begin
  Result:=FSorted;
end;

function TClassItems.GetValues(Index: Integer): TPersistentClass;
begin
  Result:=nil;
  if ValidIndex(Index)then
    Result:=Items[Index]._Class;
end;

function TClassItems.Grow(const NewCount: Integer): Integer;
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

function TClassItems.IndexOf(const Name: string): Integer;
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

procedure TClassItems.Insert(Index: Integer; const Name: string;
  const Value: TPersistentClass);
begin
  InsertItem(Index,Name,Value);
end;


procedure TClassItems.InsertItem(Index: Integer; const AName: string;
  const AValue: TPersistentClass);
begin
  SetCount(FCount+1);
  if(Index<FCount-1)then
    System.Move(FList^[Index],FList^[Index+1],
      (FCount-Index-1)*NodeSize);
  with FList^[Index] do
  begin
    Pointer(ClassName):=nil;
    Pointer(_Class):=nil;
    ClassName:=AName;
    _Class:=AValue;
  end;
end;

procedure TClassItems.Move(const OldIndex, NewIndex: Integer);
var
  Name:string;
  Value:TPersistentClass;
begin
  if OldIndex <> NewIndex then
  begin
    Name:=Names[OldIndex];
    Value:=Values[OldIndex];
    Delete(OldIndex);
    InsertItem(NewIndex,Name,Value);
  end;
end;

procedure TClassItems.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(Items[I].ClassName,Items[P].ClassName) < 0 do Inc(I);
      while CompareStrings(Items[J].ClassName, Items[P].ClassName) > 0 do Dec(J);
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



procedure TClassItems.SetCount(const Value: Integer);
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

procedure TClassItems.SetNames(Index: Integer; const Value: String);
begin
  if ValidIndex(Index)then
    List^[Index].ClassName:=Value;
end;


procedure TClassItems.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    FSorted := Value;
    if FSorted and (Count>1) then
        QuickSort(0,Count-1);
  end;
end;

procedure TClassItems.SetValues(Index: Integer;
  const Value: TPersistentClass);
begin
  if ValidIndex(Index)then
    List^[Index]._Class:=Value;
end;

procedure TClassItems.Sort;
begin
  if not Sorted then
    Sorted:=True;
end;

function TClassItems.ValidIndex(Index: Integer): Boolean;
begin
  Result:=(Index>=0)and(Index<Count);
end;

function TClassItems.ValueByName(Name: string): TPersistentClass;
var
  Index:Integer;
begin
  Result:=nil;
  if Find(Name,Index)then
    Result:=Values[Index];
end;

end.
