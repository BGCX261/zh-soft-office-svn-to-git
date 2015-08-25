unit ZhTreeImpl;

interface

uses
  Classes, SysUtils;

type
  TNode = class;
  TErrorObject = class(Exception);

  TTree = class
  private
    FRemoveAll: boolean;
    FIndex: Integer;
    FRootNode: TNode;
    FNodes: TList;
    function GetItems(Index: Integer): TNode;
    function GetCount: Integer;
  protected
    function CreateNode: TNode; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function AddNode(ParentNode: TNode; AText: string): TNode; virtual;
    procedure RemoveNode(ANode: TNode);
    procedure Clear; virtual;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure Assign(ATree: TTree);

    property Count: Integer read GetCount;
    property RootNode: TNode read FRootNode;
    property Items[Index: Integer]: TNode read GetItems;
  end;

  TNode = class
  private
    FTree: TTree;
    FIndex: Integer;
    FRelIndex: Integer;
    FLevel: Integer;
    FData: Pointer;
    FChildren: TList;
    FParent: TNode;
    FText: string;
    function GetNode(Index: Integer): TNode;
    function GetCount: Integer;
    function GetNextSibling: TNode;
    function GetFirstSibling: TNode;
  protected
    procedure SaveMe(Stream: TStream);virtual;
    procedure LoadMe(Stream: TStream);virtual;
  public
    constructor Create(ATree: TTree);
    destructor Destroy; override;
    procedure Clear;
    procedure Save(Stream: TStream);//参数为文件或流
    procedure Load(Stream: TStream);

    property Tree: TTree read FTree;
    property AbsoluteIndex: Integer read FIndex;
    property RelativeIndex: Integer read FRelIndex;
    property Level: Integer read FLevel;
    property Count: Integer read GetCount;
    property Text: string read FText write FText;
    property Data: Pointer read FData write FData;
    property Children[Index: Integer]: TNode read GetNode;
    property NextSibling: TNode read GetNextSibling;
    property FirstSibling: TNode read GetFirstSibling;
    property Parent: TNode read FParent;
  end;

  procedure RaiseError(const msg: string);
  procedure StreamWriteInteger(Stream: TStream; Value: Integer);
  function StreamReadInteger(Stream: TStream): Integer;
  procedure StreamWriteByte(Stream: TStream; Value: Byte);
  function StreamReadByte(Stream: TStream): Byte;
  procedure StreamWriteString(Stream: TStream; Value: string);
  function StreamReadString(Stream: TStream): string;

implementation

procedure StreamWriteInteger(Stream: TStream; Value: Integer);
begin
  Stream.Write(Value, sizeof(Integer));
end;

function StreamReadInteger(Stream: TStream): Integer;
begin
  Stream.Read(Result, sizeof(Integer));
end;

procedure StreamWriteByte(Stream: TStream; Value: Byte);
begin
  Stream.Write(Value, sizeof(Byte));
end;

function StreamReadByte(Stream: TStream): Byte;
begin
  Stream.Read(Result, sizeof(Byte));
end;

procedure StreamWriteString(Stream: TStream; Value: string);
begin
  StreamWriteInteger(Stream, Length(Value));
  Stream.Write(Value[1], Length(Value));
end;

function StreamReadString(Stream: TStream): string;
var
  C: Integer;
begin
  C:= StreamReadInteger(Stream);
  SetLength(Result, C);
  Stream.Read(Result[1], C);
end;

function TTree.GetCount: Integer;
begin
  Result := FNodes.Count;
end;

function TTree.GetItems(Index: Integer): TNode;
begin
  Result := nil;
  if (Index >= 0) and (Index < FNodes.Count) then
    Result := TNode(FNodes[Index])
else
  RaiseError('Range Out of Bounds');
end;

procedure TTree.Clear;
var
  I: Integer;
  Node: TNode;
begin
  FRemoveAll := True;
  FIndex := 1;
  for I := 1 to FNodes.Count - 1 do
  begin
    Node := TNode(FNodes[I]);
    FreeAndNil(Node);
  end;
  FNodes.clear;
  FRootNode.FChildren.Clear;
  FNodes.Add(FRootNode);
  FRemoveAll := False;
end;

constructor TNode.Create(ATree: TTree);
begin
  FTree := ATree;
  FIndex := FTree.FIndex;  // Absolute Index
  Inc(FTree.FIndex);
  FChildren := TList.Create;// Children Nodes
  FData := nil;
end;

destructor TNode.Destroy;
var
  I: Integer;
  Node: TNode;
begin
  if FTree.FRemoveAll = False then
  begin
    FTree.FNodes.Remove(Self);
    for I := 0 to FChildren.Count - 1 do
    begin
      Node := TNode(FChildren[I]);
      FreeAndNil(Node);
    end;
    FreeAndNil(FChildren);
  end;
  FTree := nil;
  FParent := nil;
  FData := nil;
  inherited;
end;

function TNode.GetCount: Integer;
begin
  Assert(FChildren <> nil);
  Result := FChildren.Count;
end;

function TNode.GetNode(Index: Integer): TNode;
begin
  Result := nil;
  if (Index >= 0) and (Index < FChildren.Count) then
     Result := FChildren[Index]
  else
    RaiseError('Range Out of Bounds');
end;

{ 算法：从父节点的孩子中查找，自己的下一个就是兄弟 }
function TNode.GetNextSibling: TNode;
var
  I: Integer;
begin
  Result := nil;
  if FParent <> nil then
  begin
    for I := 0 to FParent.Count - 2 do
      if FParent.Children[I] = Self then
      begin
        Result:= FParent.FChildren[I + 1];
        Break;
      end;
  end;
end;

function TNode.GetFirstSibling: TNode;
begin
  if FParent <> nil then
    Result := FParent.FChildren[0]
  else
    Result := Self;
end;

procedure TNode.Clear;
var
  I: Integer;
  Node: TNode;
begin
  for I := 0 to FChildren.Count - 1 do
  begin
    Node := TNode(FChildren[I]);
    FreeAndNil(Node);
  end;
  FChildren.Clear;
  FRelIndex := 1;
end;

constructor TTree.Create;
begin
  FIndex := 0;
  FRemoveAll := False;

  FRootNode:= CreateNode;
  FRootNode.FParent := nil;
  FRootNode.FLevel := 0;

  FNodes := TList.Create;
  FNodes.Add(FRootNode);
end;

destructor TTree.destroy;
begin
  Clear;
  FRemoveAll := True;
  FreeAndNil(FRootNode);
  FreeAndNil(FNodes);
  inherited;
end;

function TTree.AddNode(ParentNode: TNode; AText: string): TNode;
begin
  if ParentNode = nil then
    RaiseError('Invalid Parent Node');

  Result := CreateNode;
  Result.FParent := ParentNode;
  ParentNode.FChildren.Add(Result);
  Result.FRelIndex := ParentNode.FChildren.IndexOf(Result);
  Result.FLevel := ParentNode.FLevel + 1;
  Result.Text:= AText;
  FNodes.Add(Result);
end;

procedure TTree.RemoveNode(ANode: TNode);
var
  I: Integer;
begin
  if ANode = FRootNode then
    RaiseError('Cannot remove root node');

  // 先删除所有子点
  for I:= ANode.Count - 1 downto 0 do
  begin
    RemoveNode(ANode.Children[I]);
  end;
  // 再删除自己
  ANode.FParent.FChildren.Remove(ANode);
  FNodes.Remove(ANode);
  FreeAndNil(ANode);
end;

procedure RaiseError(const msg: string);
begin
  raise TErrorObject.Create(msg);
end;

procedure TTree.LoadFromStream(Stream: TStream);
var
  I, C: Integer;
  node:TNode;
begin
  Clear;
  // 获取根结点文本(实际为根目录)
  FRootNode.Text:= StreamReadString(Stream);
  // 得到子节点的数目;
  C:= StreamReadInteger(Stream);
  for i:= 0 to C - 1 do
  begin
    Node:= AddNode(FRootNode, '');
    Node.Load(Stream);  
  end;
end;

procedure TTree.SaveToStream(Stream: TStream);
var
  I:integer;
begin
  // 保存根结点文本(实际为根目录
  StreamWriteString(Stream, FRootNode.Text);
  // 保存子节点的数量
  StreamWriteInteger(Stream, FRootNode.Count);
  for I:= 0 to FRootNode.Count - 1 do
    FRootNode.Children[I].Save(Stream);
end;

procedure TNode.Load(Stream: TStream);
var
  I, C:integer;
  node:TNode;
begin
  Loadme(Stream);//取数据
  C:= StreamReadInteger(Stream); //得到了节点的数目
  for I:= 0 to C - 1 do
  begin
    Node:= FTree.AddNode(Self, '');
    Node.Load(Stream);
  end;
end;

procedure TNode.Save(Stream: TStream);
var
  I:integer;
begin
  SaveMe(Stream);
  StreamWriteInteger(Stream, Count); //保存子节点的数量
  for I:= 0 to count - 1 do
    Children[I].Save(Stream);
end;

procedure TNode.LoadMe(Stream: TStream);
begin
  // 加载节点数据
end;

procedure TNode.SaveMe(Stream: TStream);
begin
  // 保存节点数据
end;

function TTree.CreateNode: TNode;
begin
  FRootNode := TNode.Create(Self);
end;

procedure TTree.Assign(ATree: TTree);
var
  Stream: TStream;
begin
  Assert(ATree <> nil);
  Stream:= TMemoryStream.Create;
  try
    ATree.SaveToStream(Stream);
    SaveToStream(Stream);
    Stream.Position:= 0;
    Self.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;


end.

