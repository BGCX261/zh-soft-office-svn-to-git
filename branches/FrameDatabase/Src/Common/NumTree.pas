unit NumTree;

interface

uses
  SysUtils, Classes, ShareSys, ShareWin;

type
  TNumberNode=Integer;
  TNumberTree=class;
  TNumberGroup=class;
  TCheckState=(csUnchecked,csChecked,csGrayed);
  TNumNodeDealMethod=procedure (NumNode:TNumberNode;NumGroup,ChildGroup:TNumberGroup;Param:Integer) of object;
  TNumNodeChangeEvent=procedure (ChgGroup:TNumberGroup;ChgIndex:Integer) of object;

  ENumberTree=class(Exception);
  TNumberGroup=class
  protected
    FOwnTree:TNumberTree;
    FOwnerNode:TNumberNode;
    FOwnerLevel:Integer;
    FOwnerGroup:TNumberGroup;
    procedure SetTree(const Value:TNumberTree);
    function GetOwnerIndex():Integer;
  public
    function IsDescendantOf(NumNode:TNumberNode):Boolean;overload;
    function IsDescendantOf(NumGroup:TNumberGroup):Boolean;overload;
    function GetCommonParent(OtherGroup:TNumberGroup):TNumberGroup;

    property OwnTree:TNumberTree read FOwnTree;
    property OwnerNode:TNumberNode read FOwnerNode;
    property OwnerGroup:TNumberGroup read FOwnerGroup;
    property OwnerLevel:Integer read FOwnerLevel;
    property OwnerIndex:Integer read GetOwnerIndex;
  private
    function GetCaption(Index:Integer):string;
    function GetImageIndex(Index:Integer):Integer;
    function GetState(Index:Integer):TCheckState;
    function GetData(Index:Integer):Pointer;
    function GetHint(Index:Integer):string;
  public
    property Caption[Index:Integer]:string read GetCaption;
    property ImageIndex[Index:Integer]:Integer read GetImageIndex;
    property State[Index:Integer]:TCheckState read GetState;
    property Data[Index:Integer]:Pointer read GetData;
    property Hint[Index:Integer]:string read GetHint;
  protected
    function  GetChildCount():Integer;virtual;abstract;
    function  GetChild(Index:Integer):TNumberNode;virtual;abstract;
    function  DoInsertChild(Index:Integer;NumNode:TNumberNode):Boolean;virtual;abstract;
    function  DoDeleteChild(Index:Integer):Boolean;virtual;abstract;
    function  DoRemoveChildren():Integer;virtual;

    function  FindChildGroup(NumNode:TNumberNode):TNumberGroup;virtual;abstract;
    function  DoCreateChildGroup(NumNode:TNumberNode):TNumberGroup;virtual;abstract;
    function  DoDestroyChildGroup(ChildGroup:TNumberGroup):Boolean;virtual;abstract;
  public
    constructor Create;virtual;
    destructor Destroy;override;

    function  AddChild(NumNode:TNumberNode):Integer;virtual;
    function  InsertChild(Index:Integer;NumNode:TNumberNode):Boolean;virtual;
    function  DeleteChild(Index:Integer):Boolean;virtual;
    function  RemoveChild(NumNode:TNumberNode):Boolean;virtual;
    function  RemoveChildren():Integer;virtual;
    function  MoveChild(Index:Integer;DestGroup:TNumberGroup;DestIndex:Integer):Boolean;virtual;abstract;
    function  ExchangeChild(Index1,Index2:Integer):Boolean;virtual;

    function  GetChildIndex(NumNode:TNumberNode):Integer;virtual;
    function  GetChildGroup(Index:Integer;DoCreate:Boolean=False):TNumberGroup;virtual;
    function  GetNextChildGroup(ChildGroup:TNumberGroup):TNumberGroup;virtual;
    function  GetNextBrotherGroup():TNumberGroup;

    property Count:Integer read GetChildCount;
    property Child[Index:Integer]:TNumberNode read GetChild;
  private
    FExpanded:Boolean;
    FFamilyCount,FShowIndex,FEFamilyCount:Integer;
  protected
    procedure SetExpanded(Value:Boolean);virtual;
  public
    procedure Expand(LevelCount:Integer=1);//0:All,1:Child
    procedure Collapse(LevelCount:Integer=1);//0:All,1:Child

    function  GetTreeIndex():Integer;//virtual;
    function  GetShowIndex():Integer;//virtual;
    function  GetFamilyCount():Integer;//virtual;
    function  GetShowFamilyCount():Integer;//virtual;
    function  GetMaxLevel():Integer;
    function  GetMaxShowLevel():Integer;

    function  FindNode(NumNode:TNumberNode;var NodeGroup:TNumberGroup;var NodeIndex:Integer):Boolean;virtual;
    function  GetChildShowIndex(Index:Integer):Integer;//virtual;
    function  FindNodeByShowIndex(ShowIndex:Integer;var NodeGroup:TNumberGroup;var NodeIndex:Integer):Boolean;

    property Expanded:Boolean read FExpanded write SetExpanded;
  public
    procedure CopyNodes(Source:TNumberGroup;Recurse:Boolean);virtual;
    procedure ForAll(DoWork:TNumNodeDealMethod;Recurse:Boolean=True;Param:Integer=0);
    procedure ForAllExpanded(DoWork:TNumNodeDealMethod;Param:Integer=0);
    procedure ForAllChildGroup(DoWork:TNumNodeDealMethod;LevelCount:Integer;Param:Integer=0);
    procedure ForSubLevelChild(DoWork:TNumNodeDealMethod;LevelCount:Integer;Param:Integer=0);
  end;

  TNumberTree=class
  private
    FRoot:TNumberGroup;
    procedure SetRoot(const Value: TNumberGroup);
  public
    property Root:TNumberGroup read FRoot write SetRoot;
  private
    FUpdateCount:Integer;
    FNeedPend:Boolean;
    FPendGroup:TNumberGroup;
    FOnChange:TNumNodeChangeEvent;//Caption,ImageIndex,Data等变化
    FOnInsert:TNumNodeChangeEvent;
    FOnDelete:TNumNodeChangeEvent;
    FOnShowChange:TNumNodeChangeEvent;
    procedure ResetShowIndex(FromGroup:TNumberGroup;FromIndex:Integer);
  protected
    function GetMaxShowCaption():Integer;virtual;
    procedure ScrollNotify(TopGroup:TNumberGroup;TopIndex:Integer;ViewCount:Integer;var MaxViewCaption:Integer);virtual;
    procedure NodeChanged(NumNode:TNumberNode);virtual;
    procedure DoStructChange(ChgGroup:TNumberGroup;ChgIndex:Integer);
  public
    procedure BeginUpdate;
    procedure EndUpdate;
    function Updating:Boolean;

    class function GroupCanShow(AGroup:TNumberGroup):Boolean;
    class function GetNextGroup(AGroup:TNumberGroup;Shown:Boolean):TNumberGroup;
    class function GetPriorGroup(AGroup:TNumberGroup;Shown:Boolean):TNumberGroup;
    class function DestroyEmptyGroup(NodeGroup:TNumberGroup):Boolean;
    class procedure ExpandGroup(AGroup:TNumberGroup);

    procedure ChangeNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);virtual;
    procedure InsertNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);virtual;
    procedure DeleteNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);virtual;
    procedure ShowChangeNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);virtual;
    function FindNode(NumNode:TNumberNode;var NodeIndex:Integer):TNumberGroup;

    property MaxShowCaption:Integer read GetMaxShowCaption;

    property OnChange:TNumNodeChangeEvent read FOnChange write FOnChange;
    property OnInsert:TNumNodeChangeEvent read FOnInsert write FOnInsert;
    property OnDelete:TNumNodeChangeEvent read FOnDelete write FOnDelete;
    property OnShowChange:TNumNodeChangeEvent read FOnShowChange write FOnShowChange;
  public
    function  GetNodeCaption(NumNode:TNumberNode):string;virtual;
    procedure SetNodeCaption(NumNode:TNumberNode;const Value:string);virtual;
    function  GetNodeState(NumNode:TNumberNode):TCheckState;virtual;
    procedure SetNodeState(NumNode:TNumberNode;Value:TCheckState);virtual;
    function  GetNodeImageIndex(NumNode:TNumberNode):Integer;virtual;
    procedure SetNodeImageIndex(NumNode:TNumberNode;Value:Integer);virtual;
    function  GetNodeStateIndex(NumNode:TNumberNode):Integer;virtual;
    procedure SetNodeStateIndex(NumNode:TNumberNode;Value:Integer);virtual;
    function  GetNodeData(NumNode:TNumberNode):Pointer;virtual;
    procedure SetNodeData(NumNode:TNumberNode;Value:Pointer);virtual;
    function  GetNodeHint(NumNode:TNumberNode):string;virtual;
  private
    procedure DoModifyNodeState(NumNode:TNumberNode;NumGroup,ChildGroup:TNumberGroup;Param:Integer);
    procedure DoInvertNodeState(NumNode:TNumberNode;NumGroup,ChildGroup:TNumberGroup;Param:Integer);
  public
    procedure ClearNodesState;virtual;
    procedure ModifyNodeState(NodeGroup:TNumberGroup;NodeIndex:Integer;AState:TCheckState;LevelCount:Integer);virtual;
    procedure InvertNodeState(NodeGroup:TNumberGroup;NodeIndex:Integer;LevelCount:Integer);virtual;
  end;

  TNodeGroupLCG=class(TNumberGroup)
  private
    FFirstChildGroup:TNodeGroupLCG;
    FNextBrotherGroup:TNodeGroupLCG;
    procedure DestroyChildGroups();
  protected
    procedure InsertChildGroup(ChildGroup:TNumberGroup);
    function  DeleteChildGroup(ChildGroup:TNumberGroup):Boolean;
    function  DoRemoveChildren():Integer;override;

    function  FindChildGroup(NumNode:TNumberNode):TNumberGroup;override;
    function  DoCreateChildGroup(NumNode:TNumberNode):TNumberGroup;override;
    function  DoDestroyChildGroup(ChildGroup:TNumberGroup):Boolean;override;
  public
    function  GetNextChildGroup(ChildGroup:TNumberGroup):TNumberGroup;override;

    function  MoveChild(Index:Integer;DestGroup:TNumberGroup;DestIndex:Integer):Boolean;override;
    procedure ExchangeChildrenTree(Index1,Index2:Integer);
  end;

  TFNodeGroup=class(TNodeGroupLCG)
  protected
    FNodes:TCommon32bArray;
    function  GetChildCount():Integer;override;
    procedure SetChildCount(const Value:Integer);
    function  GetChild(Index:Integer):TNumberNode;override;
    procedure SetChild(Index:Integer;const Value:Integer);
    function  DoInsertChild(Index:Integer;NumNode:TNumberNode):Boolean;override;
    function  DoDeleteChild(Index:Integer):Boolean;override;
    function  DoRemoveChildren():Integer;override;
  public
    constructor Create;override;
    destructor Destroy;override;

    function  GetChildIndex(NumNode:TNumberNode):Integer;override;

    property Count:Integer read GetChildCount write SetChildCount;
    property Child[Index:Integer]:TNumberNode read GetChild write SetChild;
  end;

  TLargeNodeGroup=class(TNumberGroup)
  private
    FGroupInfo:Pointer;
    FNodes:TCommon32bArray;
    FChilds:TCommon32bArray;
    FNodesData:TCommon32bArray;
    FChildIndex1:TCommon32bArray;
    FChildIndex2:TCommon32bArray;
    function GetCapacity: Integer;
    procedure SetCapacity(const Value: Integer);
    procedure SetChildCount(const Value:Integer);
    procedure SetChild(Index:Integer;const Value:TNumberNode);
    function  GetData(Index:Integer):Pointer;
    procedure SetData(Index:Integer;const Value:Pointer);
  protected
    function  GetChildCount():Integer;override;
    function  GetChild(Index:Integer):TNumberNode;override;
    function  DoInsertChild(Index:Integer;NumNode:TNumberNode):Boolean;override;
    function  DoDeleteChild(Index:Integer):Boolean;override;

    function  FindChildGroup(NumNode:TNumberNode):TNumberGroup;override;
    function  DoCreateChildGroup(NumNode:TNumberNode):TNumberGroup;override;
    function  DoDestroyChildGroup(ChildGroup:TNumberGroup):Boolean;override;
    function  DoRemoveChildren():Integer;override;
  public
    constructor Create;override;
    destructor Destroy;override;

    function  GetChildGroup(Index:Integer;DoCreate:Boolean=False):TNumberGroup;override;
    function  GetNextChildGroup(ChildGroup:TNumberGroup):TNumberGroup;override;
    procedure CreateChildGroupIndex;
    procedure DestructChildGroups;
    procedure SetChildren(const Value:TCommon32bArray);
    procedure SetGroupInfo(Value:Pointer;Recurse:Boolean);

    procedure CopyNodes(Source:TNumberGroup;Recurse:Boolean);override;
    function  MoveChild(Index:Integer;DestGroup:TNumberGroup;DestIndex:Integer):Boolean;override;
    function  GetChildIndex(NumNode:TNumberNode):Integer;override;

    property Count:Integer read GetChildCount write SetChildCount;
    property Capacity:Integer read GetCapacity write SetCapacity;
    property Child[Index:Integer]:TNumberNode read GetChild write SetChild;
    property GroupInfo:Pointer read FGroupInfo write FGroupInfo;
    property NodeData[Index:Integer]:Pointer read GetData write SetData;
  end;

  function InvertState(AState:TCheckState):TCheckState;

implementation

function InvertState(AState:TCheckState):TCheckState;
begin
  if(AState=csUnchecked)then Result:=cschecked
  else Result:=csUnchecked;
end;

{ TNumberTree }

procedure TNumberTree.SetRoot(const Value: TNumberGroup);
begin
  if(FRoot<>nil)then FRoot.SetTree(nil);
  FRoot := Value;
  if(FRoot<>nil)then
  begin
    FRoot.SetTree(Self);
    {FRoot.FOwnerNode:=-1;
    FRoot.FOwnerLevel:=0;
    FRoot.FOwnerGroup:=nil;}
    FRoot.Expanded:=True;
  end;

  FNeedPend:=False;
  FPendGroup:=nil;
  //StructChange(
end;

function TNumberTree.GetMaxShowCaption():Integer;
begin
  Result:=10;
end;

procedure TNumberTree.ScrollNotify(TopGroup:TNumberGroup;TopIndex:Integer;ViewCount:Integer;var MaxViewCaption:Integer);
begin
  //???
end;

procedure TNumberTree.NodeChanged(NumNode:TNumberNode);
var
  Index:Integer;
  Group:TNumberGroup;
begin
  if(Root.FindNode(NumNode,Group,Index))then
    ChangeNotify(Group,Index);
end;

procedure TNumberTree.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TNumberTree.EndUpdate;
var
  Group:TNumberGroup;
begin
  Assert(FUpdateCount>0);
  Dec(FUpdateCount);
  if(FUpdateCount=0)and(FNeedPend)then
  begin
    Group:=FPendGroup;
    while(Group<>nil)do
    begin
      Group.FFamilyCount:=-1;
      Group.FEFamilyCount:=-1;
      Group:=Group.OwnerGroup;
    end;

    if(FPendGroup<>nil)then
      ResetShowIndex(FPendGroup.OwnerGroup,FPendGroup.OwnerIndex);

    //For ALL Children of Group
    if(FPendGroup=nil)then Group:=Root
    else Group:=GetNextGroup(FPendGroup,False);
    while(Group<>nil)do
    begin
      if(FPendGroup<>nil)and(not Group.IsDescendantOf(FPendGroup))then Break;

      Group.FFamilyCount:=-1;
      Group.FEFamilyCount:=-1;
      Group.FShowIndex:=-1;

      Group:=GetNextGroup(Group,False);
    end;

    if(Assigned(OnShowChange))then OnShowChange(nil,-1);
    FNeedPend:=False;
    FPendGroup:=nil;
  end;
end;

function TNumberTree.Updating:Boolean;
begin
  Result:=FUpdateCount>0;
end;

procedure TNumberTree.ResetShowIndex(FromGroup:TNumberGroup;FromIndex:Integer);
var
  I:Integer;
  Group:TNumberGroup;
begin
  if(FromGroup=nil)then Exit;

  Group:=nil;
  if(FromIndex>=0)and(FromIndex<FromGroup.Count)
      and(FromGroup.GetNextChildGroup(nil)<>nil)then
  begin
    Group:=FromGroup.GetChildGroup(FromIndex);
    if(Group=nil)then
    begin
      for I:=FromIndex to FromGroup.Count-1 do
      begin
        Group:=FromGroup.GetChildGroup(I);
        if(Group<>nil)then Break;
      end;
    end;
  end;
  if(Group=nil)then Group:=GetNextGroup(FromGroup,True);

  while(Group<>nil)do
  begin
    Group.FShowIndex:=-1;
    Group:=GetNextGroup(Group,True);
  end;
end;

class function TNumberTree.GroupCanShow(AGroup:TNumberGroup):Boolean;
begin
  repeat
    if(not AGroup.Expanded)then
    begin
      Result:=False;Exit;
    end;
    AGroup:=AGroup.OwnerGroup;
  until(AGroup=nil);
  Result:=True;
end;

class function TNumberTree.GetNextGroup(AGroup:TNumberGroup;Shown:Boolean):TNumberGroup;
var
  Child,Brother:TNumberGroup;
begin
  if(Shown)and(not AGroup.Expanded)then Child:=nil
  else Child:=AGroup.GetNextChildGroup(nil);

  if(Child<>nil)then
    Result:=Child
  else begin
    Brother:=AGroup.GetNextBrotherGroup();
    while(Brother=nil)and(AGroup.OwnerGroup<>nil)do
    begin
      AGroup:=AGroup.OwnerGroup;
      Brother:=AGroup.GetNextBrotherGroup();
    end;
    Result:=Brother;
  end;
end;

class function TNumberTree.GetPriorGroup(AGroup:TNumberGroup;Shown:Boolean):TNumberGroup;
var
  I:Integer;
  Parent,Brother,Child:TNumberGroup;
begin
  Result:=nil;
  Parent:=AGroup.OwnerGroup;
  for I:=AGroup.OwnerIndex-1 downto 0 do
  begin
    Brother:=Parent.GetChildGroup(I);
    if(Brother<>nil)then
    begin
      Result:=Brother;Break;
    end;
  end;

  if(Result=nil)then
    Result:=Parent
  else begin
    Brother:=Result;
    while(True)do
    begin
      if(Shown)and(not Brother.Expanded)then
        Child:=nil
      else Child:=Brother.GetNextChildGroup(nil);
      if(Child=nil)then
      begin
        Result:=Brother;
        Break;
      end else
      while(Child<>nil)do
      begin
        Brother:=Child;
        Child:=Child.GetNextBrotherGroup();
      end;
    end;
  end;
end;

class function TNumberTree.DestroyEmptyGroup(NodeGroup:TNumberGroup):Boolean;
begin
  if(NodeGroup=nil)or(NodeGroup.Count>0)
      or(NodeGroup.OwnTree<>nil)and(NodeGroup=NodeGroup.OwnTree.Root)then
  begin
    Result:=False;Exit;
  end;
  if(NodeGroup.OwnerGroup=nil)then NodeGroup.Destroy
  else NodeGroup.OwnerGroup.DoDestroyChildGroup(NodeGroup);
  Result:=True;
end;

class procedure TNumberTree.ExpandGroup(AGroup:TNumberGroup);
var
  Stack:TCommon32bArray;
begin
  Stack:=TCommon32bArray.Create(10);
  try
    while(AGroup<>nil)do
    begin
      Stack.Push3(AGroup);
      AGroup:=AGroup.OwnerGroup;
    end;

    while(not Stack.IsEmpty)do
    begin
      AGroup:=Stack.Pop3();
      AGroup.Expanded:=True;
    end;
  finally
    Stack.Free;
  end;
end;

procedure TNumberTree.ChangeNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  if(FUpdateCount>0)then
  begin
    //if(not FNeexPend)then FPendGroup:=ChgGroup
    //else FPendGroup:=ChgGroup.GetCommonParent(FPendGroup);
    FNeedPend:=True;
    Exit;
  end;

  if(Assigned(OnChange))then OnChange(ChgGroup,ChgIndex);
end;

procedure TNumberTree.ShowChangeNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);
var
  Parent:TNumberGroup;
begin
  if(FUpdateCount>0)then
  begin
    if(not FNeedPend)then FPendGroup:=ChgGroup
    else FPendGroup:=ChgGroup.GetCommonParent(FPendGroup);
    FNeedPend:=True;
    Exit;
  end;

  Parent:=ChgGroup;
  while(Parent<>nil)and(Parent.Expanded)do
  begin
    Parent.FEFamilyCount:=-1;
    Parent:=Parent.OwnerGroup;
  end;

  ResetShowIndex(ChgGroup,ChgIndex);

  if(Assigned(OnShowChange))then OnShowChange(ChgGroup,ChgIndex);
end;

procedure TNumberTree.InsertNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  DoStructChange(ChgGroup,ChgIndex);
  if(Assigned(OnInsert))then OnInsert(ChgGroup,ChgIndex);
end;

procedure TNumberTree.DeleteNotify(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  if(FPendGroup=ChgGroup)then FPendGroup:=nil;
  DoStructChange(ChgGroup,ChgIndex);
  if(Assigned(OnDelete))then OnDelete(ChgGroup,ChgIndex);
end;

procedure TNumberTree.DoStructChange(ChgGroup:TNumberGroup;ChgIndex:Integer);
var
  Parent:TNumberGroup;
begin
  if(FUpdateCount>0)then
  begin
    if(not FNeedPend)then FPendGroup:=ChgGroup
    else FPendGroup:=ChgGroup.GetCommonParent(FPendGroup);
    FNeedPend:=True;
    Exit;
  end;

  Parent:=ChgGroup;
  while(Parent<>nil)and(Parent.Expanded)do
  begin
    Parent.FEFamilyCount:=-1;
    Parent:=Parent.OwnerGroup;
  end;
  Parent:=ChgGroup;
  while(Parent<>nil)do
  begin
    Parent.FEFamilyCount:=-1;
    Parent.FFamilyCount:=-1;
    Parent:=Parent.OwnerGroup;
  end;

  if(ChgGroup<>nil)and(ChgGroup.Expanded)then
    ResetShowIndex(ChgGroup,ChgIndex);
end;

function TNumberTree.FindNode(NumNode:TNumberNode;var NodeIndex:Integer):TNumberGroup;
begin
  if(not Root.FindNode(NumNode,Result,NodeIndex))then Result:=nil;
end;

function  TNumberTree.GetNodeCaption(NumNode:TNumberNode):string;
begin
  Result:=IntToStr(NumNode);
end;

procedure TNumberTree.SetNodeCaption(NumNode:TNumberNode;const Value:string);
begin
  NodeChanged(NumNode);
end;

function  TNumberTree.GetNodeState(NumNode:TNumberNode):TCheckState;
begin
  Result:=csUnchecked;
end;

procedure TNumberTree.SetNodeState(NumNode:TNumberNode;Value:TCheckState);
begin
  NodeChanged(NumNode);
end;

procedure TNumberTree.DoModifyNodeState(NumNode:TNumberNode;NumGroup,ChildGroup:TNumberGroup;Param:Integer);
begin
  SetNodeState(NumNode,TCheckState(Param));
end;

procedure TNumberTree.DoInvertNodeState(NumNode:TNumberNode;NumGroup,ChildGroup:TNumberGroup;Param:Integer);
begin
  SetNodeState(NumNode,InvertState(GetNodeState(NumNode)));
end;

procedure TNumberTree.ClearNodesState;
begin
  BeginUpdate;
  try
    Root.ForAll(DoModifyNodeState,True,Integer(csUnchecked));
  finally
    EndUpdate;
  end;
end;

procedure TNumberTree.ModifyNodeState(NodeGroup:TNumberGroup;NodeIndex:Integer;AState:TCheckState;LevelCount:Integer);
var
  More:Boolean;
  Children:TNumberGroup;
begin
  SetNodeState(NodeGroup.Child[NodeIndex],AState);
  Children:=NodeGroup.GetChildGroup(NodeIndex);
  if(Children=nil)or(LevelCount<0)then Exit;

  More:=Children.GetFamilyCount>20;
  if(More)then BeginUpdate;
  try
    Children.ForSubLevelChild(DoModifyNodeState,LevelCount,Integer(AState));
  finally
    if(More)then EndUpdate;
  end;
end;

procedure TNumberTree.InvertNodeState(NodeGroup:TNumberGroup;NodeIndex:Integer;LevelCount:Integer);
var
  More:Boolean;
  NumNode:TNumberNode;
  Children:TNumberGroup;
begin
  NumNode:=NodeGroup.Child[NodeIndex];
  SetNodeState(NumNode,InvertState(GetNodeState(NumNode)));
  Children:=NodeGroup.GetChildGroup(NodeIndex);
  if(Children=nil)or(LevelCount<0)then Exit;

  More:=Children.GetFamilyCount>20;
  if(More)then BeginUpdate;
  try
    Children.ForSubLevelChild(DoInvertNodeState,LevelCount);
  finally
    if(More)then EndUpdate;
  end;
end;

function  TNumberTree.GetNodeImageIndex(NumNode:TNumberNode):Integer;
begin
  Result:=-1;
end;

procedure TNumberTree.SetNodeImageIndex(NumNode:TNumberNode;Value:Integer);
begin
  NodeChanged(NumNode);
end;

function  TNumberTree.GetNodeStateIndex(NumNode:TNumberNode):Integer;
begin
  Result:=-1;
end;

procedure TNumberTree.SetNodeStateIndex(NumNode:TNumberNode;Value:Integer);
begin
  NodeChanged(NumNode);
end;

function  TNumberTree.GetNodeData(NumNode:TNumberNode):Pointer;
begin
  Result:=nil;
end;

procedure TNumberTree.SetNodeData(NumNode:TNumberNode;Value:Pointer);
begin
  NodeChanged(NumNode);
end;

function  TNumberTree.GetNodeHint(NumNode:TNumberNode):string;
begin
  Result:=GetNodeCaption(NumNode);
end;

{ TNumberGroup }

constructor TNumberGroup.Create;
begin
  inherited Create;
  FShowIndex:=-1;
  FFamilyCount:=-1;
  FEFamilyCount:=-1;
end;

destructor TNumberGroup.Destroy;
begin
  RemoveChildren();
  if(OwnTree<>nil)and(OwnTree.FPendGroup=Self)then
    OwnTree.FPendGroup:=nil;
  inherited;
end;

procedure TNumberGroup.SetTree(const Value:TNumberTree);
var
  Group:TNumberGroup;
begin
  FOwnTree:=Value;
  
  Group:=GetNextChildGroup(nil);
  while(Group<>nil)do
  begin
    Group.FOwnTree:=Value;
    Group:=TNumberTree.GetNextGroup(Group,False);
  end;
end;

function TNumberGroup.GetOwnerIndex():Integer;
begin
  if(OwnerGroup=nil)then Result:=0
  else Result:=OwnerGroup.GetChildIndex(OwnerNode);
end;

function TNumberGroup.IsDescendantOf(NumNode:TNumberNode):Boolean;
var
  Group:TNumberGroup;
begin
  Group:=Self.OwnerGroup;
  while(Group<>nil)and(Group.OwnerNode<>NumNode)do
    Group:=Group.OwnerGroup;
  Result:=Group<>nil;
end;

function TNumberGroup.IsDescendantOf(NumGroup:TNumberGroup):Boolean;
var
  Group:TNumberGroup;
begin
  if(NumGroup=nil)then
    Result:=False
  else begin
    Group:=Self.OwnerGroup;
    while(Group<>nil)and(Group<>NumGroup)do
      Group:=Group.OwnerGroup;
    Result:=Group<>nil;
  end;
end;

function TNumberGroup.GetCommonParent(OtherGroup:TNumberGroup):TNumberGroup;
var
  Group:TNumberGroup;
  Level1,Level2:Integer;
begin
  if(Self=nil)or(OtherGroup=nil)then
  begin
    Result:=nil;Exit;
  end;
  
  Group:=Self;
  Level1:=Group.OwnerLevel;
  Level2:=OtherGroup.OwnerLevel;

  while(Level1>Level2)do
  begin
    Group:=Group.OwnerGroup;
    if(Group=nil)then Break;
    Level1:=Group.OwnerLevel;
  end;
  while(Level2>Level1)do
  begin
    OtherGroup:=OtherGroup.OwnerGroup;
    if(OtherGroup=nil)then Break;
    Level2:=OtherGroup.OwnerLevel;
  end;

  while(Group<>nil)and(OtherGroup<>nil)and(Group<>OtherGroup)do
  begin
    Group:=Group.OwnerGroup;
    OtherGroup:=OtherGroup.OwnerGroup;
  end;
  if(Group=OtherGroup)then Result:=Group
  else Result:=nil;
end;

function TNumberGroup.GetCaption(Index:Integer):string;
begin
  if(OwnTree=nil)then Result:=''
  else Result:=OwnTree.GetNodeCaption(Child[Index]);
end;

function TNumberGroup.GetImageIndex(Index:Integer):Integer;
begin
  if(OwnTree=nil)then Result:=-1
  else Result:=OwnTree.GetNodeImageIndex(Child[Index]);
end;

function TNumberGroup.GetState(Index:Integer):TCheckState;
begin
  if(OwnTree=nil)then Result:=csUnchecked
  else Result:=OwnTree.GetNodeState(Child[Index]);
end;

function TNumberGroup.GetData(Index:Integer):Pointer;
begin
  if(OwnTree=nil)then Result:=nil
  else Result:=OwnTree.GetNodeData(Child[Index]);
end;

function TNumberGroup.GetHint(Index:Integer):string;
begin
  if(OwnTree=nil)then Result:=''
  else Result:=OwnTree.GetNodeHint(Child[Index]);
end;

function  TNumberGroup.AddChild(NumNode:TNumberNode):Integer;
begin
  Result:=Count;
  InsertChild(Result,NumNode);
end;

function  TNumberGroup.InsertChild(Index:Integer;NumNode:TNumberNode):Boolean;
begin
  {if(GetChildIndex(NumNode)>=0)then
    raise ENumberTree.CreateFmt('节点(%d)已经存在',[NumNode]);}
  if(Index<0)or(Index>Count)then
    raise ENumberTree.CreateFmt('节点序号(%d)错误',[Index]);
  
  Result:=DoInsertChild(Index,NumNode);
  if(OwnTree<>nil)and(Result)then OwnTree.InsertNotify(Self,Index);
end;
                          
function  TNumberGroup.DeleteChild(Index:Integer):Boolean;
var
  Node:TNumberNode;
  Group:TNumberGroup;
begin
  if(Index<0)or(Index>Count)then
    raise ENumberTree.CreateFmt('节点序号(%d)错误',[Index]);

  Node:=Child[Index];
  Group:=FindChildGroup(Node);
  if(Group<>nil)then
  begin
    Group.RemoveChildren;
    DoDestroyChildGroup(Group);
  end;
  Result:=DoDeleteChild(Index);
  if(Result)and(OwnTree<>nil)then
    OwnTree.DeleteNotify(Self,Index);
end;

function  TNumberGroup.RemoveChild(NumNode:TNumberNode):Boolean;
var
  cIndex:Integer;
begin
  cIndex:=GetChildIndex(NumNode);
  if(cIndex>=0)then Result:=DeleteChild(cIndex)
  else Result:=False;
end;

function  TNumberGroup.DoRemoveChildren():Integer;
var
  I,C:Integer;
begin
  C:=Count;
  for I:=Count-1 downto 0 do
    DeleteChild(I);
  Result:=C-Count;
end;

function  TNumberGroup.RemoveChildren():Integer;
begin
  if(OwnTree=nil)then
    Result:=DoRemoveChildren()
  else begin
    OwnTree.BeginUpdate;
    try
      Result:=DoRemoveChildren();
      OwnTree.DeleteNotify(Self,-1);
    finally
      OwnTree.EndUpdate;
    end;
  end;
{var
  SaveTree:TNumberTree;
begin
  SaveTree:=OwnTree;
  SetTree(nil);//Disable more Notify

  Result:=DoRemoveChildren();

  if(SaveTree<>nil)then begin
    FOwnTree:=SaveTree;
    SaveTree.DeleteNotify(Self,-1);
  end;}
end;

function  TNumberGroup.ExchangeChild(Index1,Index2:Integer):Boolean;
var
  T:Integer;
begin
  if(Index1=Index2)then
  begin
    Result:=False;Exit;
  end;
  if(Index1>Index2)then
  begin
    T:=Index1;Index1:=Index2;Index2:=T;
  end;
  Result:=MoveChild(Index1,Self,Index2);
  if(Result)and(Index2-1>Index1)then
    Result:=MoveChild(Index2-1,Self,Index1);
end;

function  TNumberGroup.GetChildIndex(NumNode:TNumberNode):Integer;
var
  I:Integer;
begin
  for I:=0 to Count-1 do
    if(Child[I]=NumNode)then
    begin
      Result:=I;Exit;
    end;
  Result:=-1;
end;

function  TNumberGroup.GetChildGroup(Index:Integer;DoCreate:Boolean):TNumberGroup;
var
  NumNode:TNumberNode;
begin
  NumNode:=Child[Index];
  Result:=FindChildGroup(NumNode);
  if(Result=nil)and(DoCreate)then
  begin
    Result:=DoCreateChildGroup(NumNode);
    Result.FOwnTree:=OwnTree;
  end;
end;

function  TNumberGroup.GetNextBrotherGroup():TNumberGroup;
begin
  if(OwnerGroup=nil)then Result:=nil
  else Result:=OwnerGroup.GetNextChildGroup(Self);
end;

function  TNumberGroup.GetNextChildGroup(ChildGroup:TNumberGroup):TNumberGroup;
var
  I:Integer;
  IsWant:Boolean;
  Group:TNumberGroup;
begin
  IsWant:=ChildGroup=nil;
  for I:=0 to Count-1 do
  begin
    Group:=FindChildGroup(Child[I]);
    if(Group=nil)then Continue;
    if(IsWant)then
    begin
      Result:=Group;
      Exit;
    end;
    IsWant:=Group=ChildGroup;
  end;
  Result:=nil;
end;

procedure TNumberGroup.SetExpanded(Value:Boolean);
begin
  if(OwnTree<>nil)and(Self=OwnTree.Root)then Value:=True;
  if(FExpanded<>Value)then
  begin
    FExpanded:=Value;
    if(OwnTree<>nil)then OwnTree.ShowChangeNotify(OwnerGroup,OwnerIndex);
  end;
end;

procedure TNumberGroup.Expand(LevelCount:Integer);
var
  Group:TNumberGroup;
begin
  if(LevelCount<>1)and(OwnTree<>nil)then OwnTree.BeginUpdate;
  try
    Expanded:=True;
    if(LevelCount=0)then begin
      Group:=GetNextChildGroup(nil);
      while(Group<>nil)do
      begin
        Group.Expand(LevelCount);
        Group:=GetNextChildGroup(Group);
      end;
    end else if(LevelCount>1)then begin
      Group:=GetNextChildGroup(nil);
      while(Group<>nil)do
      begin
        Group.Expand(LevelCount-1);
        Group:=GetNextChildGroup(Group);
      end;
    end;
  finally
    if(LevelCount<>1)and(OwnTree<>nil)then OwnTree.EndUpdate;
  end;
end;

procedure TNumberGroup.Collapse(LevelCount:Integer);
var
  Group:TNumberGroup;
begin
  if(LevelCount<>1)and(OwnTree<>nil)then OwnTree.BeginUpdate;
  try
    if(LevelCount=0)then begin
      Group:=GetNextChildGroup(nil);
      while(Group<>nil)do
      begin
        Group.Collapse(LevelCount);
        Group:=GetNextChildGroup(Group);
      end;
    end else if(LevelCount>1)then begin
      Group:=GetNextChildGroup(nil);
      while(Group<>nil)do
      begin
        Group.Collapse(LevelCount-1);
        Group:=GetNextChildGroup(Group);
      end;
    end;
    Expanded:=False;
  finally
    if(LevelCount<>1)and(OwnTree<>nil)then OwnTree.EndUpdate;
  end;
end;

function  TNumberGroup.GetTreeIndex():Integer;
var
  I:Integer;
  Node:TNumberNode;
  Group:TNumberGroup;
begin
  if(OwnerGroup=nil)then Result:=1
  else begin
    Result:=OwnerGroup.GetTreeIndex;
    for I:=0 to OwnerGroup.Count-1 do
    begin
      Node:=OwnerGroup.Child[I];
      Inc(Result);
      if(Node=OwnerNode)then Break;
      Group:=OwnerGroup.FindChildGroup(Node);
      if(Group<>nil)then
        Inc(Result,Group.GetFamilyCount);
    end;
  end;
end;

function  TNumberGroup.GetShowIndex():Integer;
var
  I:Integer;
  Node:TNumberNode;
  Group:TNumberGroup;
begin
  if(OwnerGroup=nil)then
    Result:=OwnerIndex
  else begin
    if(FShowIndex>=0)then
    begin
      Result:=FShowIndex;
      Exit;
    end;

    Assert(OwnerGroup.Expanded);

    Result:=OwnerGroup.GetShowIndex;
    for I:=0 to OwnerGroup.Count-1 do
    begin
      Node:=OwnerGroup.Child[I];
      Inc(Result);
      if(Node=OwnerNode)then Break;
      Group:=OwnerGroup.FindChildGroup(Node);
      if(Group<>nil)and(Group.Expanded)then
        Inc(Result,Group.GetShowFamilyCount);
    end;

    FShowIndex:=Result;
  end;
end;

function  TNumberGroup.GetFamilyCount():Integer;
var
  Group:TNumberGroup;
begin
  if(FFamilyCount>=0)then
  begin
    Result:=FFamilyCount;
    Exit;
  end;

  Result:=Count;
  Group:=GetNextChildGroup(nil);
  while(Group<>nil)do
  begin
    Inc(Result,Group.GetFamilyCount);
    Group:=GetNextChildGroup(Group);
  end;
  FFamilyCount:=Result;
end;

function  TNumberGroup.GetShowFamilyCount():Integer;
var
  Group:TNumberGroup;
begin
  if(not Expanded)then
    Result:=0
  else begin
    if(FEFamilyCount>=0)then
    begin
      Result:=FEFamilyCount;
      Exit;
    end;

    Result:=Count;
    Group:=GetNextChildGroup(nil);
    while(Group<>nil)do
    begin
      if(Group.Expanded)then
        Inc(Result,Group.GetShowFamilyCount);
      Group:=GetNextChildGroup(Group);
    end;

    FEFamilyCount:=Result;
  end;
end;

function  TNumberGroup.GetMaxLevel():Integer;
var
  Group:TNumberGroup;
begin
  Result:=OwnerLevel;
  Group:=GetNextChildGroup(nil);
  while(Group<>nil)do
  begin
    if(Group.OwnerLevel>Result)then
      Result:=Group.OwnerLevel;
    Group:=TNumberTree.GetNextGroup(Group,False);
  end;
end;

function  TNumberGroup.GetMaxShowLevel():Integer;
var
  Group:TNumberGroup;
begin
  Result:=OwnerLevel;
  Group:=GetNextChildGroup(nil);
  while(Group<>nil)do
  begin
    if(Group.OwnerLevel>Result)then
      Result:=Group.OwnerLevel;
    Group:=TNumberTree.GetNextGroup(Group,True);
  end;
end;

function  TNumberGroup.FindNode(NumNode:TNumberNode;var NodeGroup:TNumberGroup;var NodeIndex:Integer):Boolean;
var
  Index:Integer;
  Group:TNumberGroup;
begin
  Index:=GetChildIndex(NumNode);
  if(Index>=0)then
  begin
    NodeGroup:=Self;NodeIndex:=Index;
    Result:=True;
  end else begin
    Group:=GetNextChildGroup(nil);
    while(Group<>nil)do
    begin
      if(Group.FindNode(NumNode,NodeGroup,NodeIndex))then
      begin
        Result:=True;Exit;
      end;
      Group:=GetNextChildGroup(Group);
    end;
    //NodeGroup:=nil;NodeIndex:=-1;
    Result:=False;
  end;
end;

function TNumberGroup.GetChildShowIndex(Index:Integer):Integer;
var
  I:Integer;
  Group:TNumberGroup;
begin
  Result:=GetShowIndex+Index;
  for I:=0 to Index-1 do
  begin
    Group:=FindChildGroup(Child[I]);
    if(Group<>nil)and(Group.Expanded)then
      Inc(Result,Group.GetShowFamilyCount);
  end;
end;

function  TNumberGroup.FindNodeByShowIndex(ShowIndex:Integer;var NodeGroup:TNumberGroup;var NodeIndex:Integer):Boolean;
var
  Index,Count:Integer;
  Group,SubGroup:TNumberGroup;
begin
  Dec(ShowIndex,Self.GetShowIndex());

  Group:=Self;Index:=0;
  SubGroup:=Group.GetNextChildGroup(nil);
  while(ShowIndex>0)do
  begin
    if(ShowIndex>=Group.GetShowFamilyCount())then Break;

    Dec(ShowIndex);
    if(SubGroup<>nil)and(SubGroup.OwnerNode=Group.Child[Index])then
    begin
      Count:=SubGroup.GetShowFamilyCount;
      if(ShowIndex>=Count)then
      begin
        Dec(ShowIndex,Count);
        SubGroup:=Group.GetNextChildGroup(SubGroup);
      end else begin
        Group:=SubGroup;Index:=-1;
        SubGroup:=Group.GetNextChildGroup(nil);
      end;
    end;
    Inc(Index);
  end;
  if(ShowIndex=0)and(Index<Group.Count)then
  begin
    NodeGroup:=Group;NodeIndex:=Index;
    Result:=True;
  end else begin
    NodeGroup:=nil;NodeIndex:=-1;
    Result:=False;
  end;
end;

procedure TNumberGroup.CopyNodes(Source:TNumberGroup;Recurse:Boolean);
var
  I:Integer;
  Group:TNumberGroup;
begin
  if(OwnTree<>nil)then OwnTree.BeginUpdate;
  try
    if(Count>0)then RemoveChildren;
    for I:=0 to Source.Count-1 do
      AddChild(Source.Child[I]);
    if(Recurse)then
    begin
      Group:=Source.GetNextChildGroup(nil);
      while(Group<>nil)do
      begin
        GetChildGroup(Group.OwnerIndex,True).CopyNodes(Group,True);
        Group:=Source.GetNextChildGroup(Group);
      end;
    end;
  finally
    if(OwnTree<>nil)then OwnTree.EndUpdate;
  end;
end;

procedure TNumberGroup.ForAll(DoWork:TNumNodeDealMethod;Recurse:Boolean;Param:Integer);
var
  I:Integer;
  Node:TNumberNode;
  Group:TNumberGroup;
begin
  for I:=0 to Count-1 do begin
    Node:=Child[I];
    Group:=FindChildGroup(Node);
    DoWork(Node,Self,Group,Param);
    if(Recurse)and(Group<>nil)then
      Group.ForAll(DoWork,True,Param);
  end;
end;

procedure TNumberGroup.ForAllExpanded(DoWork:TNumNodeDealMethod;Param:Integer);
var
  I:Integer;
  Node:TNumberNode;
  Group:TNumberGroup;
begin
  for I:=0 to Count-1 do begin
    Node:=Child[I];
    Group:=FindChildGroup(Node);
    DoWork(Node,Self,Group,Param);
    if(Group<>nil)and(Group.Expanded)then
      Group.ForAllExpanded(DoWork,Param);
  end;
end;

procedure TNumberGroup.ForAllChildGroup(DoWork:TNumNodeDealMethod;LevelCount:Integer;Param:Integer=0);
var
  Group:TNumberGroup;
begin
  Group:=GetNextChildGroup(nil);
  while(Group<>nil)do
  begin
    DoWork(Group.OwnerNode,Self,Group,Param);
    if(LevelCount=0)then
      Group.ForAllChildGroup(DoWork,LevelCount,Param);
    if(LevelCount>1)then
      Group.ForAllChildGroup(DoWork,LevelCount-1,Param);
    Group:=GetNextChildGroup(Group);
  end;
end;

procedure TNumberGroup.ForSubLevelChild(DoWork:TNumNodeDealMethod;LevelCount:Integer;Param:Integer);
var
  I:Integer;
  Node:TNumberNode;
  Group:TNumberGroup;
begin
  Assert(LevelCount>=0);
  for I:=0 to Count-1 do begin
    Node:=Child[I];
    Group:=FindChildGroup(Node);
    DoWork(Node,Self,Group,Param);
    if(LevelCount>1)and(Group<>nil)then
      Group.ForSubLevelChild(DoWork,LevelCount-1,Param)
    else if(LevelCount=0)and(Group<>nil)then
      Group.ForSubLevelChild(DoWork,LevelCount,Param)
  end;
end;

{ TNodeGroupLCG }

procedure TNodeGroupLCG.InsertChildGroup(ChildGroup:TNumberGroup);
var
  Index:Integer;
  Node:TNumberNode;
  Prior,Group:TNumberGroup;
begin
  Index:=0;
  Node:=Child[Index];
  Prior:=nil;Group:=GetNextChildGroup(nil);
  while(Node<>ChildGroup.OwnerNode)and(Group<>nil)do
  begin
    while(Node<>ChildGroup.OwnerNode)and(Node<>Group.OwnerNode)do
    begin
      Inc(Index);
      if(Index>=Count)then
        raise ENumberTree.CreateFmt('找不到子节点(%d)',[ChildGroup.OwnerNode]);
      Node:=Child[Index];
    end;
    if(Node=Group.OwnerNode)then
    begin
      if(Node=ChildGroup.OwnerNode)then
        raise ENumberTree.CreateFmt('子节点集(%d)已经创建',[ChildGroup.OwnerNode]);
      Prior:=Group;Group:=GetNextChildGroup(Group);
    end;
  end;

  ChildGroup.FOwnTree:=OwnTree;
  ChildGroup.FOwnerGroup:=Self;
  ChildGroup.FOwnerLevel:=OwnerLevel+1;
  if(Prior=nil)then
  begin
    TNodeGroupLCG(ChildGroup).FNextBrotherGroup:=FFirstChildGroup;
    FFirstChildGroup:=ChildGroup as TNodeGroupLCG;
  end else begin
    TNodeGroupLCG(Prior).FNextBrotherGroup:=ChildGroup as TNodeGroupLCG;
    TNodeGroupLCG(ChildGroup).FNextBrotherGroup:=Group as TNodeGroupLCG;
  end;
end;

function  TNodeGroupLCG.DeleteChildGroup(ChildGroup:TNumberGroup):Boolean;
var
  Prior,Group:TNodeGroupLCG;
begin
  Prior:=nil;Group:=FFirstChildGroup;
  while(Group<>nil)and(ChildGroup<>Group)do
  begin
    Prior:=Group;Group:=Prior.FNextBrotherGroup;
  end;
  if(Group=nil)or(Group<>ChildGroup)then
  begin
    raise ENumberTree.CreateFmt('找不到子节点集(%d)',[ChildGroup.OwnerNode]);
    Result:=False;
  end else begin
    if(Prior=nil)then
      FFirstChildGroup:=Group.FNextBrotherGroup
    else
      Prior.FNextBrotherGroup:=Group.FNextBrotherGroup;

    ChildGroup.FOwnTree:=nil;
    ChildGroup.FOwnerGroup:=nil;
    ChildGroup.FOwnerLevel:=0;
    Result:=True;
  end;
end;

function  TNodeGroupLCG.DoCreateChildGroup(NumNode:TNumberNode):TNumberGroup;
begin
  Result:=TNumberGroup(Self.NewInstance);
  Result.Create();
  Result.FOwnerNode:=NumNode;
  //Result.OwnTree:=OwnTree;
  //Result.FOwnerGroup:=Self;
  //Result.FOwnerLevel:=OwnerLevel+1;

  try
    InsertChildGroup(Result);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function  TNodeGroupLCG.DoDestroyChildGroup(ChildGroup:TNumberGroup):Boolean;
begin
  Result:=DeleteChildGroup(ChildGroup);
  if(Result)then ChildGroup.Free;
end;

function TNodeGroupLCG.FindChildGroup(NumNode: TNumberNode): TNumberGroup;
var
  Group:TNodeGroupLCG;
begin
  Group:=FFirstChildGroup;
  while(Group<>nil)do
  begin
    if(Group.OwnerNode=NumNode)then
    begin
      Result:=Group;Exit;
    end;
    Group:=Group.FNextBrotherGroup;
  end;
  Result:=nil;
end;


function  TNodeGroupLCG.GetNextChildGroup(ChildGroup:TNumberGroup):TNumberGroup;
begin
  if(ChildGroup=nil)then Result:=FFirstChildGroup
  else Result:=TNodeGroupLCG(ChildGroup).FNextBrotherGroup;
end;

procedure TNodeGroupLCG.DestroyChildGroups();
var
  Group:TNodeGroupLCG;
begin
  while(FFirstChildGroup<>nil)do
  begin
    Group:=FFirstChildGroup;
    FFirstChildGroup:=FFirstChildGroup.FNextBrotherGroup;
    Group.Free;
  end;
end;

function  TNodeGroupLCG.DoRemoveChildren():Integer;
begin
  DestroyChildGroups();
  Result:=inherited DoRemoveChildren();
end;

function  TNodeGroupLCG.MoveChild(Index:Integer;DestGroup:TNumberGroup;DestIndex:Integer):Boolean;
var
  NumNode:TNumberNode;
  Group:TNumberGroup;
  Children:TNodeGroupLCG;
begin
  Assert(DestGroup is TNodeGroupLCG,'same class node needed');

  NumNode:=Child[Index];
  if(DestGroup=Self)and(Index=DestIndex)then
  begin
    Result:=False;
    Exit;
  end;

  if(OwnTree<>nil)then OwnTree.BeginUpdate;
  try
    Children:=FindChildGroup(NumNode) as TNodeGroupLCG;
    if(Children<>nil)then DeleteChildGroup(Children);
    DeleteChild(Index);

    //if(DestGroup=Self)and(DestIndex>Index)then Inc(DestIndex);
    Result:=DestGroup.InsertChild(DestIndex,NumNode);
    if(Result)then
    begin
      if(Children<>nil)then
      begin
        TNodeGroupLCG(DestGroup).InsertChildGroup(Children);

        Group:=Children;
        while(Group<>nil)do
        begin
          if(Children<>Group)and(not Group.IsDescendantOf(Children))then Break;
          Group.FShowIndex:=-1;
          Group:=TNumberTree.GetNextGroup(Group,False);
        end;
        if(OwnTree<>nil)then OwnTree.InsertNotify(Children,-1);
      end;
    end else
    begin  //Failure Restore
      InsertChild(Index,NumNode);
      if(Children<>nil)then
        InsertChildGroup(Children);
      raise ENumberTree.CreateFmt('无法移动节点(%d)到(%d)',[NumNode,DestGroup.OwnerNode]);
    end;
  finally
    if(OwnTree<>nil)then OwnTree.EndUpdate;
  end;
end;

procedure TNodeGroupLCG.ExchangeChildrenTree(Index1,Index2:Integer);
var
  Group1,Group2:TNumberGroup;
begin
  if(Index1=Index2)then Exit;

  if(OwnTree<>nil)then OwnTree.BeginUpdate;
  try
    Group1:=GetChildGroup(Index1);
    Group2:=GetChildGroup(Index2);
    if(Group1<>nil)then DeleteChildGroup(Group1);
    if(Group2<>nil)then DeleteChildGroup(Group2);

    if(Group1<>nil)then Group1.FOwnerNode:=Child[Index2];
    if(Group2<>nil)then Group2.FOwnerNode:=Child[Index1];

    if(Group1<>nil)then InsertChildGroup(Group1);
    if(Group2<>nil)then InsertChildGroup(Group2);

    if(OwnTree<>nil)then
    begin
      OwnTree.ChangeNotify(Self,MinInteger(Index1,Index2));
      OwnTree.ShowChangeNotify(Self,MinInteger(Index1,Index2));
    end;
  finally
    if(OwnTree<>nil)then OwnTree.EndUpdate;
  end;
end;

{ TFNodeGroup }

constructor TFNodeGroup.Create;
begin
  inherited Create;

  FNodes:=TCommon32bArray.Create;
end;

destructor TFNodeGroup.Destroy;
begin
  inherited;
  FNodes.Free;
end;

function TFNodeGroup.DoInsertChild(Index:Integer;NumNode:TNumberNode):Boolean;
begin
  FNodes.Insert2(Index,1,NumNode);
  Result:=True;
end;

function TFNodeGroup.DoDeleteChild(Index:Integer):Boolean;
begin
  FNodes.Delete(Index,1);
  Result:=True;
end;

function TFNodeGroup.GetChildCount:Integer;
begin
  Result:=FNodes.Count;
end;

procedure TFNodeGroup.SetChildCount(const Value: Integer);
var
  OldCount:Integer;
begin
  OldCount:=Count;
  if(OldCount<>Value)then
  begin
    FNodes.Count:=Value;
    if(OwnTree<>nil)then begin
      if(OldCount>Count)then
        OwnTree.DeleteNotify(Self,-1)
      else
        OwnTree.InsertNotify(Self,-1);
    end;
  end;
end;

function TFNodeGroup.GetChild(Index:Integer):TNumberNode;
begin
  Result:=FNodes.Elems2[Index];
end;

procedure TFNodeGroup.SetChild(Index: Integer; const Value: Integer);
begin
  if(FNodes.Elems2[Index]<>Value)then
  begin
    {//$IFOPT D+}//only peform this check in debug version
    if(FindChildGroup(FNodes.Elems2[Index])<>nil)then
      raise ENumberTree.CreateFmt('子节点集(%d)已创建，不能修改',[FNodes.Elems2[Index]]);
    if(FindChildGroup(Value)<>nil)then
      raise ENumberTree.CreateFmt('子节点集(%d)已创建，不能修改',[Value]);
    {//$ENDIF}

    FNodes.Elems2[Index]:=Value;
    if(OwnTree<>nil)then OwnTree.ChangeNotify(Self,Index);
  end;
end;

function TFNodeGroup.GetChildIndex(NumNode: TNumberNode): Integer;
begin
  Result:=FNodes.IndexOf2(NumNode);
end;

function  TFNodeGroup.DoRemoveChildren():Integer;
begin
  Result:=FNodes.Count;
  DestroyChildGroups;
  FNodes.Clear;
end;

{ TLargeNodeGroup }

constructor TLargeNodeGroup.Create;
begin
  inherited;
  FNodes:=TCommon32bArray.Create;
  FChilds:=TCommon32bArray.Create;
end;

destructor TLargeNodeGroup.Destroy;
begin
  inherited;
  FChildIndex1.Free;
  FChildIndex2.Free;
  FNodes.Free;
  FChilds.Free;
  FNodesData.Free;
end;

function TLargeNodeGroup.GetCapacity: Integer;
begin
  Result:=FNodes.Capacity;
end;

procedure TLargeNodeGroup.SetCapacity(const Value: Integer);
begin
  FNodes.Capacity:=Value;
  FChilds.Capacity:=Value;
  if(FNodesData<>nil)then FNodesData.Capacity:=Value;
end;

function  TLargeNodeGroup.GetChildCount():Integer;
begin
  Result:=FNodes.Count;
end;

procedure TLargeNodeGroup.SetChildCount(const Value:Integer);
begin
  FNodes.Count:=Value;
  FChilds.Count:=Value;
  if(FNodesData<>nil)then FNodesData.Count:=Value;
end;

function  TLargeNodeGroup.GetChildIndex(NumNode:TNumberNode):Integer;
begin
  Result:=FNodes.IndexOf2(NumNode);
end;

function  TLargeNodeGroup.GetChild(Index:Integer):TNumberNode;
begin
  Result:=FNodes[Index];
end;

procedure TLargeNodeGroup.SetChild(Index:Integer;const Value:Integer);
begin
  FNodes[Index]:=Value;
  if(FChilds.Elems4[Index]<>nil)then
    TLargeNodeGroup(FChilds.Elems4[Index]).FOwnerNode:=Value;
  if(OwnTree<>nil)then OwnTree.ChangeNotify(Self,Index);
end;

function  TLargeNodeGroup.GetData(Index:Integer):Pointer;
begin
  if(FNodesData=nil)then Result:=nil
  else Result:=FNodesData.Elems3[Index];
end;

procedure TLargeNodeGroup.SetData(Index:Integer;const Value:Pointer);
begin
  if(FNodesData=nil)then
  begin
    FNodesData:=TCommon32bArray.Create(Count);
    FNodesData.Count:=Count;
  end;
  FNodesData.Elems3[Index]:=Value;
end;


function  TLargeNodeGroup.DoInsertChild(Index:Integer;NumNode:TNumberNode):Boolean;
begin
  FNodes.Insert2(Index,1,NumNode);
  FChilds.Insert3(Index,1,nil);
  if(FNodesData<>nil)then FNodesData.Insert3(Index,1,nil);
  Result:=True;
end;

function  TLargeNodeGroup.DoDeleteChild(Index:Integer):Boolean;
begin
  FNodes.Delete(Index,1);
  FChilds.Delete(Index,1);
  if(FNodesData<>nil)then FNodesData.Delete(Index,1);
  Result:=True;
end;

function  TLargeNodeGroup.FindChildGroup(NumNode:TNumberNode):TNumberGroup;
var
  Index:Integer;
begin
  Index:=FNodes.IndexOf2(NumNode);
  if(Index>=0)then Result:=FChilds.Elems3[Index] else Result:=nil;
end;

function  TLargeNodeGroup.DoCreateChildGroup(NumNode:TNumberNode):TNumberGroup;
var
  Index:Integer;
begin
  Index:=FNodes.IndexOf2(NumNode);
  if(Index>=0)then
  begin
    Result:=TLargeNodeGroup.Create;
    Result.FOwnTree:=OwnTree;
    Result.FOwnerGroup:=Self;
    Result.FOwnerNode:=NumNode;
    Result.FOwnerLevel:=OwnerLevel+1;
    FChilds.Elems3[Index]:=Result;
  end else
    Result:=nil;
end;

function  TLargeNodeGroup.DoDestroyChildGroup(ChildGroup:TNumberGroup):Boolean;
var
  Index:Integer;
  Node:TObject;
begin
  Index:=FNodes.IndexOf2(ChildGroup.OwnerNode);
  if(Index>=0)then
  begin
    Node:=FChilds.Elems3[Index];
    FChilds.Elems4[Index]:=nil;
    Node.Free;
  end;
  Result:=Index>=0;
end;

function  TLargeNodeGroup.DoRemoveChildren():Integer;
begin
  FreeAndnil(FChildIndex1);
  FreeAndnil(FChildIndex2);

  Result:=FNodes.Count;
  FNodes.Clear;
  while(not FChilds.IsEmpty)do
    FChilds.Pop4.Free;
  FreeAndNil(FNodesData);
end;

procedure TLargeNodeGroup.DestructChildGroups;
var
  I:Integer;
  Group:TLargeNodeGroup;
begin
  FreeAndnil(FChildIndex1);
  FreeAndnil(FChildIndex2);

  if(OwnTree<>nil)then OwnTree.BeginUpdate;
  try
    for I:=0 to FChilds.Count-1 do
    begin
      Group:=FChilds.Elems4[I] as TLargeNodeGroup;
      FChilds.Elems4[I]:=nil;
      Group.Free;
    end;
    FChilds.Clear;
  finally
    if(OwnTree<>nil)then OwnTree.EndUpdate;
  end;
end;

procedure TLargeNodeGroup.SetChildren(const Value:TCommon32bArray);
begin
  if(FChildIndex1<>nil)then 
  begin
    FreeAndnil(FChildIndex1);
    FreeAndnil(FChildIndex2);
  end;
  FNodes.Reset;
  FNodes.Capacity:=Value.Count;
  FNodes.Assign(Value);
  FChilds.Reset;
  FChilds.Capacity:=Value.Count;
  FChilds.Count:=Value.Count;
  FreeAndnil(FNodesData);
end;

procedure TLargeNodeGroup.SetGroupInfo(Value:Pointer;Recurse:Boolean);
var
  I:Integer;
  Group:TLargeNodeGroup;
begin
  FGroupInfo:=Value;
  if(Recurse)then
    for I:=0 to FChilds.Count-1 do
    begin
      Group:=FChilds.Elems4[I] as TLargeNodeGroup;
      if(Group<>nil)then Group.SetGroupInfo(Value,True);
    end;
end;

function  TLargeNodeGroup.GetChildGroup(Index:Integer;DoCreate:Boolean=False):TNumberGroup;
begin
  Result:=TNumberGroup(FChilds.Elems3[Index]);
  if(Result=nil)and(DoCreate)then
  begin
    Result:=DoCreateChildGroup(FNodes[Index]);
    Result.FOwnTree:=OwnTree;
  end;
end;

function  TLargeNodeGroup.GetNextChildGroup(ChildGroup:TNumberGroup):TNumberGroup;
var
  I,Index:Integer;
begin
  if(ChildGroup=nil)then Index:=-1
  else begin
    if(FChildIndex1=nil)then
      Index:=FChilds.IndexOf3(ChildGroup)
    else begin
      if(FChildIndex1.Find3(ChildGroup,Index))then
        Index:=FChildIndex2[Index]
      else Index:=-1;
    end;
  end;
  if(ChildGroup<>nil)and(Index<0)then
    Result:=nil
  else begin
    for I:=Index+1 to FChilds.Count-1 do
    begin
      Result:=FChilds.Elems3[I];
      if(Result<>nil)then Exit;
    end;
    Result:=nil;
  end;
end;

procedure TLargeNodeGroup.CopyNodes(Source:TNumberGroup;Recurse:Boolean);
var
  HasIndex:Boolean;
  I:Integer;
  Group:TNumberGroup;
begin
  HasIndex:=(FChildIndex1<>nil);
  if(HasIndex)then 
  begin
    FreeAndnil(FChildIndex1);
    FreeAndnil(FChildIndex2);
  end;
  if(Source is TLargeNodeGroup)then
  begin
    if(OwnTree<>nil)then OwnTree.BeginUpdate;
    try
      if(Count>0)then DoRemoveChildren;
      FNodes.Assign(TLargeNodeGroup(Source).FNodes);
      if(Recurse)then
      begin
        for I:=0 to Count-1 do
        begin
          Group:=Source.GetChildGroup(I);
          if(Group<>nil)then GetChildGroup(I,True).CopyNodes(Group,True);
        end;
      end;
      if(OwnTree<>nil)then OwnTree.InsertNotify(Self,-1);
    finally
      if(OwnTree<>nil)then OwnTree.EndUpdate;
    end;
  end else
    inherited;
  if(HasIndex)then CreateChildGroupIndex;
end;

function  TLargeNodeGroup.MoveChild(Index:Integer;DestGroup:TNumberGroup;DestIndex:Integer):Boolean;
begin
  raise ENumberTree.CreateFmt('无法移动节点(%d)到(%d)',[Child[Index],DestGroup.OwnerNode]);
end;


procedure TLargeNodeGroup.CreateChildGroupIndex;
var
  Obj:TObject;
  I,Index:Integer;
begin
  if(FChildIndex1<>nil)then Exit;
  FChildIndex1:=TCommon32bArray.Create(Count);
  FChildIndex2:=TCommon32bArray.Create(Count);

  for I:=0 to FChilds.Count-1 do
  begin
    Obj:=FChilds.Elems4[I];
    if(Obj<>nil)then
    begin
      FChildIndex1.Find3(obj,Index);
      FChildIndex1.Insert3(Index,1,Obj);
      FChildIndex2.Insert2(Index,1,I);
    end;
  end;
end;

end.
