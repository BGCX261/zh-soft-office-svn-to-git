unit NTrView;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Mask,
  CommCtrl, Dialogs, StdCtrls, Imglist, Extctrls, ComCtrls, Forms,
  ClipBrd, NumTree;

const
  NTVHorzSpace          = 2;
  NTVVertSpace          = 1;
  CheckBoxWidth         = 13;
  CheckBoxHeight        = 13;
  
  NTVChangeTimer        = 111;
  NTVSearchTimer        = 112;
  NTVShowHintTimer      = 113;
  NTVHideHintTimer      = 114;
  NTVDragScrollTimer    = 115;
  NTVDragExpandTimer    = 116;

  NTVSearchWaitTime     = 1000;
  NTVShowHintWaitTime   = 400;
  NTVHideHintWaitTime   = 6000;
  NTVDragScrollWaitTime = 150;
  NTVDragExpandWaitTime = 500;

  sCaretReturn          = #13#10;
  
type
  TNumTreeView=class;
  TNTVEditor = class(TCustomMaskEdit)
  private
    FClickTime: Integer;
    FTreeView:TNumTreeView;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure BoundsChanged;
    procedure Hide;
    procedure Invalidate;override;
    procedure Show(const BR:TRect);
    procedure SetFocus;override;
    procedure SelectNone;
    //function  Visible: Boolean;
  published
    property AutoSelect;
    property AutoSize;
    property CharCase;
    property EditMask;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ReadOnly;
    property Text;

    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TNumTreeState = (ntsNormal, ntsEditing, ntsNodeDown, ntsNodeDragging);
  TNumTreeNodePos = (thpCaption,thpIcon,thpStateImage,thpCheckBox,thpIndent,thpSpace);

  TNTVChangingNodeEnvet=procedure (Sender:TObject;ChgGroup:TNumberGroup;ChgIndex:Integer;var AllowChange:Boolean) of object;
  TNTVChangeNodeEnvet=procedure (Sender:TObject;ChgGroup:TNumberGroup;ChgIndex:Integer) of object;
  TNTVEditingNodeEvent=procedure (Sender:TObject;EditGroup:TNumberGroup;EditIndex:Integer;var AllowEdit:Boolean) of object;
  TNTVEditNodeEvent=procedure (Sender:TObject;EditGroup:TNumberGroup;EditIndex:Integer;var EditText:string;var AllowUpdate:Boolean) of object;
  TNTVDragNodeEvent=procedure (Sender:TObject;DragGroup:TNumberGroup;DragIndex:Integer;var AllowDrag:Boolean) of object;
  TNTVDropOverNodeEvent=procedure (Sender:TObject;DragGroup,DropGroup:TNumberGroup;DragIndex,DropIndex:Integer;var AllowDrop:Boolean) of object;
  TNTVDropNodeEvent=procedure (Sender:TObject;DragGroup,DropGroup:TNumberGroup;DragIndex,DropIndex:Integer) of object;


  ENumTreeView=class(Exception);
  TNumberTreeHacker=class(TNumberTree);
  TNumTreeView=class(TCustomControl)
  private
    FAutoDrag: Boolean;
    FAutoExpand: Boolean;
    FBorderStyle: TBorderStyle;
    FChangeDelay: Integer;
    FCheckBoxes: Boolean;
    FHotTrack: Boolean;
    FImageChangeLink: TChangeLink;
    FImages: TCustomImageList;
    FStateImages: TCustomImageList;
    FIndent: Integer;
    FReadOnly: Boolean;
    FRowSelect: Boolean;
    FScrollBars: TScrollStyle;
    FShowButtons: Boolean;
    FShowStruct: Boolean;
    FShowLines: Boolean;
    FShowRoot: Boolean;
    FToolTips: Boolean;
    FRightClick: Boolean;
    procedure SetAutoDrag(Value: Boolean);
    procedure SetAutoExpand(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetChangeDelay(Value: Integer);
    procedure SetCheckBoxes(Value: Boolean);
    procedure SetHotTrack(Value: Boolean);
    procedure SetImages(Value: TCustomImageList);
    procedure SetStateImages(Value: TCustomImageList);
    procedure SetIndent(Value: Integer);
    procedure SetReadOnly(Value: Boolean);
    procedure SetRightClick(const Value: Boolean);
    procedure SetRowSelect(Value: Boolean);
    procedure SetScrollBars(Value: TScrollStyle);
    procedure SetShowButtons(Value: Boolean);
    procedure SetShowLines(Value: Boolean);
    procedure SetShowRoot(Value: Boolean);
    procedure SetShowStruct(Value: Boolean);
    procedure SetToolTips(Value: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams);override;

    property AutoDrag: Boolean read FAutoDrag write SetAutoDrag default False;
    property AutoExpand: Boolean read FAutoExpand write SetAutoExpand default False;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property ChangeDelay: Integer read FChangeDelay write SetChangeDelay default 0;
    property CheckBoxes: Boolean read FCheckBoxes write SetCheckBoxes default False;
    property HotTrack: Boolean read FHotTrack write SetHotTrack default False;
    property Images: TCustomImageList read FImages write SetImages;
    property StateImages: TCustomImageList read FStateImages write SetStateImages;
    property Indent: Integer read FIndent write SetIndent default 19;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default True;
    property RightClick: Boolean read FRightClick write SetRightClick default False;
    property RowSelect: Boolean read FRowSelect write SetRowSelect default False;
    property ScrollBars: TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property ShowButtons: Boolean read FShowButtons write SetShowButtons default True;
    property ShowLines: Boolean read FShowLines write SetShowLines default True;
    property ShowRoot: Boolean read FShowRoot write SetShowRoot default True;
    property ShowStruct: Boolean read FShowStruct write SetShowStruct default True;
    property ToolTips: Boolean read FToolTips write SetToolTips default True;
  private
    FState:TNumTreeState;
    
    FUpdateCount:Integer;
    FFontHeight:Integer;
    FLeftOffset,FMaxCaption:Integer;
    FRowHeight:Integer;
    FViewCount,FShowCount:Integer;
    
    FTopRow:Integer;
    FTopIndex:Integer;
    FTopGroup:TNumberGroup;

    FCurRow:Integer;
    FCurIndex:Integer;
    FCurGroup:TNumberGroup;
    FCurChildren:TNumberGroup;

    FSearching:Boolean;
    FSearchText:string;
    FSaveRow:Integer;
    FSaveIndex:Integer;
    FSaveGroup:TNumberGroup;
    FSaveChildren:TNumberGroup;
    FRightClickGroup:TNumberGroup;
    FRightClickIndex:Integer;

    FChangeTimer:Integer;
    FHintWindow: THintWindow;
    FShowHintTimer:Integer;
    FHideHintTimer:Integer;
    FSearchTimer:Integer;
    FEditor:TNTVEditor;

    FHotGroup:TNumberGroup;
    FHotIndex:Integer;
    // DragDrop
    FDragObject: TDragObject;
    FDragImageList: TDragImageList;
    FDragGroup: TNumberGroup;
    FDragIndex: Integer;
    FDragPos: TPoint;
    FDragSaveoffset: Integer;
    FDragSaveTopRow: Integer;
    FDragOverGroup: TNumberGroup;
    FDragOverIndex: Integer;
    FDragScrollTimer: Integer;
    FDragScrollDelta: Integer;
    FDragExpandTimer: Integer;

    FOnChanging:TNTVChangingNodeEnvet;
    FOnChange:TNTVChangeNodeEnvet;
    FOnEditingNode:TNTVEditingNodeEvent;
    FOnEditNode:TNTVEditNodeEvent;
    FOnDragNode:TNTVDragNodeEvent;
    FOnDragNodeOver:TNTVDropOverNodeEvent;
    FOnDropNode:TNTVDropNodeEvent;

    procedure CMCancelMode(var Msg: TMessage); message CM_CANCELMODE;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMDrag(var Message: TCMDrag); message CM_DRAG;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMWantSpecialKey(var Msg: TCMWantSpecialKey); message CM_WANTSPECIALKEY;

    procedure WMCancelMode(var Msg: TMessage); message WM_CANCELMODE;
    procedure WMDestroy(var Msg: TWMDestroy); message WM_DESTROY;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMIMEStartComp(var Message: TMessage); message WM_IME_STARTCOMPOSITION;
    procedure WMKillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMNCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMTimer(var Msg: TWMTimer); message WM_TIMER;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;

    function  GetCaptionWidth(const Caption:string):Integer;
    procedure SetLeftOffset(const Value:Integer);
    procedure SetTopRow(const Value:Integer);
    procedure SetCurRow(Value:Integer);
    procedure CheckCurrentHidden(CollapseGroup:TNumberGroup);

    procedure OnNodeChange(ChgGroup:TNumberGroup;ChgIndex:Integer);
    procedure OnNodeInsert(ChgGroup:TNumberGroup;ChgIndex:Integer);
    procedure OnNodeDelete(ChgGroup:TNumberGroup;ChgIndex:Integer);
    procedure DoTreeShowChange(ChgGroup:TNumberGroup;ChgIndex:Integer);

  protected
    FHitTest: TPoint;
    procedure Paint;override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;

    procedure ChangeImmediate;
    procedure FreeChangeTimer;
    procedure ImageListChange(Sender:TObject);
    procedure ShowHint(Immediate:Boolean);
    procedure CancelHintShow;
    procedure ShowEditor;
    procedure HideEditor(Update:Boolean);

    procedure DoChange;dynamic;
    procedure ResetSearchTimer;
    procedure StartSearch(ClearSearch:Boolean);
    procedure DoSearch(const SearchText:string;UpSearch:Boolean);
    procedure EndSearch;

    procedure CheckHotTrackPos(const X,Y:Integer);
    procedure HideHotTrack();
    procedure CancelMode;
    // DragDrop Nodes
    function IsTopNode(Group:TNumberGroup;Index:Integer): Boolean;
    function IsLastNode(Group:TNumberGroup;Index:Integer): Boolean;

    procedure SetDragObject(Value: TDragObject);
    procedure UpdateDragging;
    procedure RestoreDragOverTop;
    function  DoBeginDragNode(Group:TNumberGroup;Index:Integer):Boolean; virtual;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    procedure DoStartDrag(var DragObject: TDragObject); override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure CreateDragNodeImage(Group:TNumberGroup;Index:Integer); virtual;
    function GetDragImages: TDragImageList; override;
    procedure DoCheckNode(NodeGroup:TNumberGroup;NodeIndex:Integer;ShiftDown:Boolean);

    procedure UpdateScrollRange;
    procedure UpdateHorzScrollRange;
    procedure UpdateVertScrollRange;
    procedure UpdateHorzScrollPos;
    procedure UpdateVertScrollPos;

    function  DrawRoot():Boolean;
    procedure DrawTreeNode(const RowRect:TRect;NodeGroup:TNumberGroup;NodeIndex:Integer);virtual;

    property OnChanging:TNTVChangingNodeEnvet read FOnChanging write FOnChanging;
    property OnChange:TNTVChangeNodeEnvet read FOnChange write FOnChange;
    property OnEditingNode:TNTVEditingNodeEvent read FOnEditingNode write FOnEditingNode;
    property OnEditNode:TNTVEditNodeEvent read FOnEditNode write FOnEditNode;
    property OnDragNode:TNTVDragNodeEvent read FOnDragNode write FOnDragNode;
    property OnDragNodeOver:TNTVDropOverNodeEvent read FOnDragNodeOver write FOnDragNodeOver;
    property OnDropNode:TNTVDropNodeEvent read FOnDropNode write FOnDropNode;
    //property On:T read F write F;
  public
    property TopRow:Integer read FTopRow write SetTopRow;
    property RowHeight:Integer read FRowHeight;
    property ViewCount:Integer read FViewCount;
    property ShowCount:Integer read FShowCount;
    property LeftOffset:Integer read FLeftOffset write SetLeftOffset;

    property CurRow:Integer read FCurRow write SetCurRow;
    property CurIndex:Integer read FCurIndex;
    property CurGroup:TNumberGroup read FCurGroup;
    property CurChildren:TNumberGroup read FCurChildren;

    property RightClickGroup:TNumberGroup read FRightClickGroup;
    property RightClickIndex:Integer read FRightClickIndex;
  private
    FNumTree: TNumberTree;
    procedure SetNumTree(Value:TNumberTree);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function  Updating:Boolean;reintroduce;
    procedure BeginUpdate;
    procedure EndUpdate;

    function SetCurrent(NodeGroup:TNumberGroup;NodeIndex:Integer):Boolean;
    function SetCurrentNode(NumNode:TNumberNode):Boolean;
    function  GetTextRect(NodeGroup:TNumberGroup;NodeIndex:Integer):TRect;
    function  GetNodeRect(NodeGroup:TNumberGroup;NodeIndex:Integer;FullRow:Boolean=False):TRect;
    procedure UpdateNode(NodeGroup:TNumberGroup;NodeIndex:Integer;FullRow:Boolean=False);
    procedure UpdateCurrent;

    procedure ScrollInView(NodeGroup:TNumberGroup;NodeIndex:Integer;ShowIndex:Integer=-1);
    procedure ScrollCurChildrenInView;
    function  GetHitPos(X,Y:Integer;var NodeGroup:TNumberGroup;var NodeIndex:Integer;var HitPos:TNumTreeNodePos):Boolean;
    function  FindNodeAt(X,Y:Integer;var NodeGroup:TNumberGroup;var NodeIndex:Integer):Boolean;

    procedure CollapseBrothers(AGroup:TNumberGroup;AIndex:Integer);
    procedure DragDrop(Source: TObject; X, Y: Integer); override;

    property Canvas;
    property Editor:TNTVEditor read FEditor;
    property NumTree:TNumberTree read FNumTree write SetNumTree;
  protected
    procedure GetNodeString(NodeID:LongInt;NodeGroup,SubNodes:TNumberGroup;Param:Integer);
  public
    procedure ListTreeStrings(OutStrings:TStrings;ListRoot:TNumberGroup=nil;
        RankLmt:Integer=0;Expand:Boolean=True);

  end;

  TFTreeView=class(TNumTreeView)
  published
    property Align;
    property AutoDrag;
    property AutoExpand;
    property BorderStyle;
    property ChangeDelay;
    property CheckBoxes;
    property Color;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HotTrack;
    property Images;
    property Indent;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClick;
    property RowSelect;
    property ScrollBars;
    property ShowButtons;
    property ShowLines;
    property ShowRoot;
    property StateImages;
    property ToolTips;
    property ShowStruct;

    property OnChanging;
    property OnChange;
    property OnEditingNode;
    property OnEditNode;
    property OnDragNode;
    property OnDropNode;
    property OnDragNodeOver;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure DrawTreeViewLine(DC:HDC;DrawRect:TRect);overload;
procedure DrawTreeViewLine(DC:HDC;DrawRect:TRect;HasButton,IsLast:Boolean);overload;
procedure DrawTreeViewButton(DC:HDC;DrawRect:TRect;Expanded:Boolean);

implementation

procedure DrawTreeViewButton(DC:HDC;DrawRect:TRect;Expanded:Boolean);
var
  X,Y,I,M,B:Integer;
begin
  X:=(DrawRect.Left+DrawRect.Right+1) div 2;
  Y:=(DrawRect.Top+DrawRect.Bottom+1) div 2;

  B:=DrawRect.Right-X-1;
  I:=DrawRect.Bottom-Y-1;
  if(I<B)then B:=I;
  B:=B*2 div 3;B:=B and not $1;

  for I:=X-B to X+B do
  begin
    Windows.SetPixel(DC, I, Y-B, clGray);
    Windows.SetPixel(DC, I, Y+B, clGray);
  end;
  for I:=Y-B+1 to Y+B-1 do
  begin
    Windows.SetPixel(DC, X-B, I, clGray);
    Windows.SetPixel(DC, X+B, I, clGray);
  end;
  if(B<7)then begin
    M:=B*2 div 3;
    for I:=X-M to X+M do
      Windows.SetPixel(DC, I, Y, clBlack);

    if(Expanded)then Exit;

    for I:=Y-M to Y+M do
      Windows.SetPixel(DC, X, I, clBlack);
  end else begin
    M:=B*2 div 3;
    for I:=X-M to X+M do
    if(I<>X)then begin
      Windows.SetPixel(DC, I, Y-1, clBlack);
      Windows.SetPixel(DC, I, Y+1, clBlack);
    end;
    Windows.SetPixel(DC, X-M, Y, clBlack);
    Windows.SetPixel(DC, X+M, Y, clBlack);

    if(Expanded)then
    begin
      Windows.SetPixel(DC, X, Y-1, clBlack);
      Windows.SetPixel(DC, X, Y+1, clBlack);
      Exit;
    end;

    for I:=Y-M to Y+M do
    if(I<>Y)then begin
      Windows.SetPixel(DC, X-1, I, clBlack);
      Windows.SetPixel(DC, X+1, I, clBlack);
    end;
    Windows.SetPixel(DC, X, Y-M, clBlack);
    Windows.SetPixel(DC, X, Y+M, clBlack);
  end;
end;

procedure DrawTreeViewLine(DC:HDC;DrawRect:TRect);
var
  I,X,Y:Integer;
begin
  X:=(DrawRect.Left+DrawRect.Right+1) div 2;
  Y:=(DrawRect.Top+DrawRect.Bottom+1) div 2;

  I:=Y;
  while(I>=DrawRect.Top)do
  begin
    Windows.SetPixel(DC, X, I, clGray);
    Dec(I,2);
  end;
  I:=Y+2;
  while(I<DrawRect.Bottom)do
  begin
    Windows.SetPixel(DC, X, I, clGray);
    Inc(I,2);
  end;
end;

procedure DrawTreeViewLine(DC:HDC;DrawRect:TRect;HasButton,IsLast:Boolean);
var
  X,Y,I,B:Integer;
begin
  X:=(DrawRect.Left+DrawRect.Right+1) div 2;
  Y:=(DrawRect.Top+DrawRect.Bottom+1) div 2;

  B:=DrawRect.Right-X-1;
  I:=DrawRect.Bottom-Y-1;
  if(I<B)then B:=I;
  B:=B*2 div 3;B:=B and not $1;

  I:=X;
  while(I<DrawRect.Right)do
  begin
    if(not HasButton)or(I-X>B)then
      Windows.SetPixel(DC, I, Y, clGray);
    Inc(I,2);
  end;
  I:=Y-2;
  while(I>=DrawRect.Top)do
  begin
    if(not HasButton)or(Y-I>B)then
      Windows.SetPixel(DC, X, I, clGray);
    Dec(I,2);
  end;
  if(IsLast)then Exit;
  I:=Y+2;
  while(I<DrawRect.Bottom)do
  begin
    if(not HasButton)or(I-Y>B)then
      Windows.SetPixel(DC, X, I, clGray);
    Inc(I,2);
  end;
end;

type
  TWinControlHacker=class(TWinControl);

function IsActiveControl(Ctrl:TWinControl): Boolean;
var
  H: Hwnd;
begin
  Result := False;
  begin
    H := GetFocus;
    while IsWindow(H) and (Result = False) do
    begin
      if H = TWinControlHacker(Ctrl).WindowHandle then
        Result := True
      else
        H := GetParent(H);
    end;
  end;
end;

{ TNTVEditor }

constructor TNTVEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsSingle;
  Ctl3D := False;
  ControlStyle := ControlStyle+[csNoDesignVisible];
  ParentCtl3D := False;
  TabStop := False;
  Visible := False;
end;

procedure TNTVEditor.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE;
end;

procedure TNTVEditor.CMShowingChanged(var Message: TMessage);
begin
  { Ignore showing using the Visible property }
end;

procedure TNTVEditor.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if(GetParentForm(Self)=nil)or(GetParentForm(Self).SetFocusedControl(FTreeView))then Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      begin
        if GetMessageTime - FClickTime < Integer(GetDoubleClickTime) then
          Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

procedure TNTVEditor.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    FTreeView.KeyDown(Key, Shift);
    Key := 0;
  end;
  procedure ParentEvent;
  var
    OnKeyDown: TKeyEvent;
  begin
    OnKeyDown := FTreeView.OnKeyDown;
    if Assigned(OnKeyDown) then OnKeyDown(FTreeView, Key, Shift);
  end;

begin
  case Key of
    VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_ESCAPE, VK_RETURN: SendToParent;
    VK_INSERT:
      if Shift = [] then SendToParent;
    VK_F2:
      begin
        ParentEvent;
        if Key = VK_F2 then
        begin
          SelectNone;
          Exit;
        end;
      end;
    VK_TAB: if not (ssAlt in Shift) then SendToParent;
  end;
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;

procedure TNTVEditor.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  {if(Key=#13)then FTreeView.HideEditor(True) else
  if(Key=#27)then FTreeView.HideEditor(False);}
end;

procedure TNTVEditor.BoundsChanged;
var
  TR: TRect;
begin
  TR := Rect(2, 2, Width - 2, Height);
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@TR));
  SendMessage(Handle, EM_SCROLLCARET, 0, 0);
end;

procedure TNTVEditor.Hide;
begin
  if HandleAllocated and IsWindowVisible(Handle) then
  begin
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOZORDER or
      SWP_NOREDRAW);
    if Focused then Windows.SetFocus(FTreeView.Handle);
  end;
end;

procedure TNTVEditor.Invalidate;
var
  Client: TRect;
begin
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  Windows.GetClientRect(Handle, Client);
  MapWindowPoints(Handle, FTreeView.Handle, Client, 2);
  ValidateRect(FTreeView.Handle, @Client);
  InvalidateRect(FTreeView.Handle, @Client, False);
end;

procedure TNTVEditor.SelectNone;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, Longint($FFFFFFFF));
end;

procedure TNTVEditor.SetFocus;
begin
  if IsWindowVisible(Handle) then
    Windows.SetFocus(Handle);
end;

procedure TNTVEditor.Show(const BR:TRect);
begin
  if IsRectEmpty(BR) then Hide
  else begin
    CreateHandle;
    SetWindowPos(Handle,HWND_TOP,
                 BR.Left,BR.Top,BR.Right-BR.Left,BR.Bottom-BR.Top,
                 SWP_SHOWWINDOW or SWP_NOREDRAW);
    BoundsChanged;
    if FTreeView.Focused then
      Windows.SetFocus(Handle);
    Invalidate;
  end;
end;

{ TNumTreeView }

constructor TNumTreeView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csCaptureMouse] + [csDisplayDragImage];
  Width := 121;
  Height := 97;
  TabStop := True;
  ParentColor := False;
  FBorderStyle := bsSingle;
  FDragSaveTopRow := -1;
  FIndent := 19;
  FReadOnly := True;
  FScrollBars := ssBoth;
  FShowButtons := True;
  FShowStruct := True;
  FShowLines := True;
  FShowRoot := True;
  FToolTips := True;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
end;

destructor TNumTreeView.Destroy;
begin
  CancelHintShow;
  NumTree:=nil;
  FreeAndNil(FHintWindow);
  FStateImages:=nil;
  FImageChangeLink:=nil;

  FImageChangeLink.Free;
  inherited Destroy;
end;

procedure TNumTreeView.SetAutoDrag(Value: Boolean);
begin
  if FAutoDrag <> Value then
  begin
    FAutoDrag := Value;

  end;
end;

procedure TNumTreeView.SetAutoExpand(Value: Boolean);
begin
  if FAutoExpand <> Value then
  begin
    FAutoExpand := Value;

  end;
end;

procedure TNumTreeView.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TNumTreeView.SetChangeDelay(Value: Integer);
begin
  if FChangeDelay <> Value then
  begin
    FChangeDelay := Value;
    
  end;
end;

procedure TNumTreeView.SetCheckBoxes(Value: Boolean);
begin
  if FCheckBoxes <> Value then
  begin
    FCheckBoxes := Value;
    UpdateScrollRange;
  end;
end;

procedure TNumTreeView.SetHotTrack(Value: Boolean);
begin
  if FHotTrack <> Value then
  begin
    FHotTrack := Value;
    UpdateNode(FHotGroup,FHotIndex);
  end;
end;

procedure TNumTreeView.SetImages(Value: TCustomImageList);
begin
  if Images <> nil then
    Images.UnRegisterChanges(FImageChangeLink);
  FImages := Value;
  if Images <> nil then
  begin
    Images.RegisterChanges(FImageChangeLink);
    Images.FreeNotification(Self);
  end;
  UpdateScrollRange;
end;

procedure TNumTreeView.SetStateImages(Value: TCustomImageList);
begin
  if StateImages <> nil then
    StateImages.UnRegisterChanges(FImageChangeLink);
  FStateImages := Value;
  if StateImages <> nil then
  begin
    StateImages.RegisterChanges(FImageChangeLink);
    StateImages.FreeNotification(Self);
  end;
  UpdateScrollRange;
end;

procedure TNumTreeView.SetIndent(Value: Integer);
begin
  if(FIndent<>Value)and(Value>0)then
  begin
    FIndent := Value;
    Invalidate;
    UpdateScrollRange;
  end;
end;

procedure TNumTreeView.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;

  end;
end;

procedure TNumTreeView.SetRightClick(const Value: Boolean);
begin
  if FRightClick <> Value then
  begin
    FRightClick := Value;
    if(FRightClickGroup<>nil)then
    begin
      UpdateNode(FRightClickGroup,FRightClickIndex);
      FRightClickGroup:=nil;
    end;
  end;
end;

procedure TNumTreeView.SetRowSelect(Value: Boolean);
begin
  if FRowSelect <> Value then
  begin
    if(FRowSelect)then UpdateCurrent;
    FRowSelect := Value;
    if(FRowSelect)then UpdateCurrent;
  end;
end;

procedure TNumTreeView.SetScrollBars(Value: TScrollStyle);
begin
  if FScrollBars <> Value then
  begin
    FScrollBars := Value;
    RecreateWnd;
  end;
end;

procedure TNumTreeView.SetShowButtons(Value: Boolean);
begin
  if FShowButtons <> Value then
  begin
    FShowButtons := Value;
    Invalidate;
    UpdateScrollRange;
  end;
end;

procedure TNumTreeView.SetShowStruct(Value: Boolean);
begin
  if FShowStruct <> Value then
  begin
    FShowStruct := Value;

  end;
end;

procedure TNumTreeView.SetShowLines(Value: Boolean);
begin
  if FShowLines <> Value then
  begin
    FShowLines := Value;
    Invalidate;
    UpdateScrollRange;
  end;
end;

procedure TNumTreeView.SetShowRoot(Value: Boolean);
begin
  if FShowRoot <> Value then
  begin
    FShowRoot := Value;
    Invalidate;
    UpdateScrollRange;
  end;
end;

procedure TNumTreeView.SetToolTips(Value: Boolean);
begin
  if FToolTips <> Value then
  begin
    FToolTips := Value;

  end;
end;

procedure TNumTreeView.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    WindowClass.style:=CS_DBLCLKS;
    if FBorderStyle = bsSingle then
    begin
      if(NewStyleControls and Ctl3D)then
      begin
        Style:=Style and not WS_BORDER;
        ExStyle:=ExStyle or WS_EX_CLIENTEDGE;
      end else
        Style:=Style or WS_BORDER;
    end;
    if FScrollBars in [ssVertical, ssBoth] then Style := Style or WS_VSCROLL;
    if FScrollBars in [ssHorizontal, ssBoth] then Style := Style or WS_HSCROLL;
  end;
end;


procedure TNumTreeView.ChangeImmediate;
begin
  if(FChangeTimer<>0)then
  begin
    KillTimer(Handle,FChangeTimer);
    FChangeTimer:=0;
    DoChange;
  end;
end;

procedure TNumTreeView.FreeChangeTimer;
begin
  if(FChangeTimer<>0)then
  begin
    KillTimer(Handle,FChangeTimer);
    FChangeTimer:=0;
  end;
end;

procedure TNumTreeView.ImageListChange(Sender:TObject);
begin
  if(HandleAllocated)and((Sender=Images)or(Sender=StateImages))then
    UpdateScrollRange();
end;

procedure TNumTreeView.ShowHint(Immediate:Boolean);
var
  Pt,cPt:TPoint;
  ShowRect:TRect;
  NodeHint:string;
  Count,Index:Integer;
  Children,Group:TNumberGroup;
begin
  CancelHintShow;
  if(FState=ntsNodeDragging)then Exit;
  if(not ToolTips)and(not ShowStruct)then Exit;
  
  if(not Immediate)then
    FShowHintTimer:=SetTimer(Handle,NTVShowHintTimer,NTVShowHintWaitTime,nil)
  else begin
    GetCursorPos(Pt);
    cPt:=ScreenToClient(Pt);
    if(not FindNodeAt(cPt.X,cPt.Y,Group,Index))then Exit;

    if(FHintWindow=nil)then
    begin
      FHintWindow:=THintWindow.Create(nil);
      FHintWindow.Color:=clInfoBk;
    end;

    if(ToolTips)then
      NodeHint:=FNumTree.GetNodeHint(Group.Child[Index])
    else NodeHint:='';
    if(ShowStruct)then
    begin
      Children:=Group.GetChildGroup(Index);
      if(Children<>nil)then
      begin
        if(NodeHint<>'')then NodeHint:=NodeHint+sCaretReturn;
        Count:=Children.GetFamilyCount();
        if(Count=Children.Count)then
          NodeHint:=NodeHint+Format('>%d',[Count])
        else
          NodeHint:=NodeHint+Format('>%d>%d',[Children.Count,Count]);
      end;
    end;
    ShowRect:=FHintWindow.CalcHintRect(Screen.DesktopWidth,NodeHint,nil);
    OffsetRect(ShowRect,Pt.X+20,Pt.Y);
    FHintWindow.ActivateHint(ShowRect,NodeHint);
    
    FHideHintTimer:=SetTimer(Handle,NTVHideHintTimer,NTVHideHintWaitTime,nil);
  end;
end;

procedure TNumTreeView.CancelHintShow;
begin
  if(FShowHintTimer<>0)then
  begin
    KillTimer(Handle,FShowHintTimer);
    FShowHintTimer:=0;
  end;
  if(FHideHintTimer<>0)then
  begin
    KillTimer(Handle,FHideHintTimer);
    FHideHintTimer:=0;
  end;
  if(FHintWindow<>nil)then
  begin
    SetWindowPos(FHintWindow.Handle,0,0,0,0,0,
      SWP_HIDEWINDOW or SWP_NOACTIVATE or SWP_NOZORDER or SWP_NOSIZE or SWP_NOMOVE);
    FHintWindow.Hide;
  end;
end;

procedure TNumTreeView.ShowEditor;
var
  OX:Integer;
  Allow:Boolean;
  NodeRect:TRect;
begin
  if(FState<>ntsNormal)or(ReadOnly)or(FCurGroup=nil)then Exit;
  Allow:=True;
  if(Assigned(OnEditingNode))then OnEditingNode(Self,FCurGroup,FCurIndex,Allow);
  if(not Allow)then Exit;

  ScrollInView(FCurGroup,FCurIndex,FCurRow);
  if(FEditor=nil)then
  begin
    FEditor:=TNTVEditor.Create(Self);
    FEditor.FTreeView:=Self;
    FEditor.Parent:=Self;
  end;
  FEditor.Text:=FNumTree.GetNodeCaption(FCurGroup.Child[FCurIndex]);
  NodeRect:=GetTextRect(FCurGroup,FCurIndex);
  Inc(NodeRect.Right,FFontHeight);
  if(NodeRect.Right>ClientWidth)then
  begin
    OX:=NodeRect.Right-ClientWidth;
    if(OX>NodeRect.Left)then OX:=NodeRect.Left;
    LeftOffset:=LeftOffset+OX;
    Dec(NodeRect.Left,OX);
    Dec(NodeRect.Right,OX);
  end;

  if(NodeRect.Right-NodeRect.Left>ClientWidth)then
    NodeRect.Right:=NodeRect.Left+ClientWidth;
  FEditor.Show(NodeRect);
  FEditor.SelectAll;
  FState:=ntsEditing;
end;

procedure TNumTreeView.HideEditor(Update:Boolean);
var
  NewCaption:string;
  AllowUpdate:Boolean;
begin
  if(FEditor=nil)then Exit;
  FState:=ntsNormal;
  FEditor.Hide;

  if(Update)and(FEditor.Modified)and(FCurGroup<>nil)then
  begin
    NewCaption:=FEditor.Text;
    AllowUpdate:=True;
    if(Assigned(OnEditNode))then OnEditNode(Self,FCurGroup,FCurIndex,NewCaption,AllowUpdate);
    if(AllowUpdate)then
      FNumTree.SetNodeCaption(FCurGroup.Child[FCurIndex],NewCaption);
  end;
end;

procedure TNumTreeView.CheckHotTrackPos(const X,Y:Integer);
var
  Index:Integer;
  Group:TNumberGroup;
begin
  Group:=nil;
  if(not FindNodeAt(X,Y,Group,Index))then Group:=nil;
  if(Group<>FHotGroup)or(Index<>FHotIndex)then
  begin
    if(HotTrack)and(FHotGroup<>nil)then UpdateNode(FHotGroup,FHotIndex);

    FHotGroup:=Group;FHotIndex:=Index;
    if(HotTrack)and(FHotGroup<>nil)then UpdateNode(FHotGroup,FHotIndex);
  end;
end;

procedure TNumTreeView.HideHotTrack();
begin
  if(FHotGroup<>nil)then UpdateNode(FHotGroup,FHotIndex);
  FHotGroup:=nil;
end;

procedure TNumTreeView.CancelMode;
begin
  try
    case FState of
      ntsEditing:
        begin
          HideEditor(False);
        end;
      ntsNodeDown:
        begin

        end;
      ntsNodeDragging:
        begin
          EndDrag(False);
        end;
    end;
    CancelHintShow;
  finally
    FState := ntsNormal;
  end;
end;

procedure TNumTreeView.CMCancelMode(var Msg: TMessage);
begin
  inherited;
  if(Msg.LParam<>Integer(Self))and(Msg.LParam<>Integer(FEditor))then
    CancelMode;
end;

procedure TNumTreeView.CMCtl3DChanged(var Message: TMessage);
begin
  inherited;
  RecreateWnd;
end;

procedure TNumTreeView.CMDrag(var Message: TCMDrag);
begin
  DragCursor := crDrag;
  inherited;
  with Message, DragRec^ do
    case DragMessage of
      dmDragEnter: SetDragObject(TDragObject(Source));
      dmDragLeave,
      dmDragDrop: SetDragObject(nil);
    end;
end;

procedure TNumTreeView.SetDragObject(Value: TDragObject);
var
  PrevDragObject: TDragObject;
begin
  if FDragObject <> Value then
  begin
    PrevDragObject := FDragObject;
    FDragObject := Value;
    if (FDragObject = nil) and (PrevDragObject <> nil) then
      PrevDragObject.HideDragImage;
    UpdateDragging;
    if (FDragObject <> nil) then
      FDragObject.ShowDragImage;
  end;
  if (FDragObject = nil) and (FDragOverGroup <> nil) then
  begin
    if(FDragOverGroup<>nil)then UpdateNode(FDragOverGroup,FDragOverIndex);
    FDragOverGroup := nil;
  end;
end;

procedure TNumTreeView.UpdateDragging;
begin
  UpdateWindow(Handle);
end;

procedure TNumTreeView.RestoreDragOverTop;
var
  SaveTop:Integer;
begin
  if(FDragSaveTopRow>=0)then
  begin
    if (FDragObject <> nil) then FDragObject.HideDragImage;
    SaveTop:=FDragSaveTopRow;
    FDragSaveTopRow:=-1;
    LeftOffset:=FDragSaveoffset;
    TopRow:=SaveTop;
  end;
end;

function  TNumTreeView.DoBeginDragNode(Group:TNumberGroup;Index:Integer):Boolean;
begin
  Result:=DragKind=dkDrag;
  if(Assigned(OnDragNode))then OnDragNode(Self,Group,Index,Result);
end;

procedure TNumTreeView.DoEndDrag(Target: TObject; X, Y: Integer);
begin
  inherited DoEndDrag(Target, X, Y);
  FDragGroup:=nil;
  SetDragObject(nil); {+++}
  FState:=ntsNormal;
  FreeAndNil(FDragImageList);
end;

procedure TNumTreeView.DoStartDrag(var DragObject: TDragObject);
var
  Pt: TPoint;
begin
  ChangeImmediate;
  HideHotTrack;
  CancelHintShow;
  inherited DoStartDrag(DragObject);
  if FDragGroup = nil then
  begin
    GetCursorPos(Pt);
    Pt:=ScreenToClient(Pt);
    if(not FindNodeAt(Pt.X,Pt.Y,FDragGroup,FDragIndex))then FDragGroup:=nil;
  end;
  if(FDragGroup=nil)or(not DoBeginDragNode(FDragGroup,FDragIndex))then
  begin
    CancelDrag;
    FDragGroup:=nil;
    Exit;
  end;
  if(FDragGroup<>nil)then
  begin
    CreateDragNodeImage(FDragGroup,FDragIndex);
    FState:=ntsNodeDragging;
  end;
end;

procedure TNumTreeView.DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
  Index:Integer;
  Group:TNumberGroup;
begin
  inherited;
  if(FDragSaveTopRow<0)then
  begin
    FDragSaveTopRow:=TopRow;
    FDragSaveoffset:=FLeftOffset;
  end;

  if(not FindNodeAt(X,Y,Group,Index))then
  begin
    Group:=nil;Index:=-1;
  end;
  if(Group<>FDragOverGroup)or(Index<>FDragOverIndex)then
  begin
    if(FDragExpandTimer<>0)then
    begin
      KillTimer(Handle,FDragExpandTimer);
      FDragExpandTimer:=0;
    end;
    if(Group<>nil)and(Group.GetChildGroup(Index)<>nil)then
      FDragExpandTimer:=SetTimer(Handle,NTVDragExpandTimer,NTVDragExpandWaitTime,nil);

    if FDragObject <> nil then FDragObject.HideDragImage;
    if(FDragOverGroup<>nil)then UpdateNode(FDragOverGroup,FDragOverIndex);
    FDragOverGroup:=Group;FDragOverIndex:=Index;
    if(FDragOverGroup<>nil)then
    begin
      ScrollInView(FDragOverGroup,FDragOverIndex);
      UpdateNode(FDragOverGroup,FDragOverIndex,True);
    end;
    UpdateDragging;
    if FDragObject <> nil then FDragObject.ShowDragImage;
  end;

  FDragScrollDelta:=0;
  if(Group<>nil)and(IsTopNode(Group,Index))then
    FDragScrollDelta:=-1 else
  if(Group<>nil)and(IsLastNode(Group,Index))then
    FDragScrollDelta:=1 else
  if(Y<=1)then
    FDragScrollDelta:=-ShowCount div 10 else
  if(Y<RowHeight div 2)then
    FDragScrollDelta:=-1 else
  if(Y>=ClientHeight)then
    FDragScrollDelta:=ShowCount div 10 else
  if(Y+RowHeight div 2>=ClientHeight)then
    FDragScrollDelta:=1;
  if(FDragScrollDelta<>0)then
  begin
    if(FDragScrollTimer=0)then
      FDragScrollTimer:=SetTimer(Handle,NTVDragScrollTimer,NTVDragScrollWaitTime,nil);
  end else
  if(FDragScrollTimer<>0)then
  begin
    KillTimer(Handle,FDragScrollTimer);
    FDragScrollTimer:=0;
  end;

  if(Dragging)and(FDragGroup<>nil)and(not Assigned(OnDragOver) or  Accept)then
  begin
    Accept:=(FDragOverGroup<>nil)and(FDragGroup<>FDragOverGroup)or(FDragIndex<>FDragOverIndex);
    if(Assigned(OnDragNodeOver))then
      OnDragNodeOver(Self,FDragGroup,FDragOverGroup,FDragIndex,FDragOverIndex,Accept);
  end;
  if(State=dsDragLeave)then RestoreDragOverTop();
end;

procedure TNumTreeView.DragDrop(Source: TObject; X, Y: Integer);
var
  Index:Integer;
  Group:TNumberGroup;
begin
  inherited;
  //FDragOverGroup 已经清除
  if(not FindNodeAt(X,Y,Group,Index))then
  begin
    Group:=nil;Index:=-1;
  end;
  if(Source=Self)and(FDragGroup<>nil)and(Assigned(OnDropNode))then
    OnDropNode(Self,FDragGroup,Group,FDragIndex,Index);
  RestoreDragOverTop();
end;

procedure TNumTreeView.CheckCurrentHidden(CollapseGroup:TNumberGroup);
begin
  if(FCurGroup=nil)then Exit;
  if(FCurGroup=CollapseGroup)or(FCurGroup.IsDescendantOf(CollapseGroup))then
  begin
    FCurGroup:=nil;
    SetCurrent(CollapseGroup.OwnerGroup,CollapseGroup.OwnerIndex);
  end;
end;

procedure TNumTreeView.CollapseBrothers(AGroup:TNumberGroup;AIndex:Integer);
var
  Group:TNumberGroup;
begin
  if(AGroup=nil)then Exit;
  Group:=AGroup.GetNextChildGroup(nil);
  while(Group<>nil)do
  begin
    if(Group.OwnerIndex<>AIndex)then Group.Collapse(0);
    Group:=Group.GetNextBrotherGroup();
  end;
end;

procedure TNumTreeView.CreateDragNodeImage(Group:TNumberGroup;Index:Integer);
var
  Bmp: TBitmap;
  ii: Integer;
  S: string;
  R, R1: TRect;
begin
  Bmp := TBitmap.Create;
  try
    R:=GetNodeRect(Group,Index);
    S:=FNumTree.GetNodeCaption(Group.Child[Index]);
    ii:=FNumTree.GetNodeImageIndex(Group.Child[Index]);

    // draw bitmap
    with Bmp, Canvas do
    begin
      Width := R.Right - R.Left + Indent;
      Height := R.Bottom - R.Top;
      Font.Assign(Self.Font);
      Brush.Color := Self.Color;
      R := Rect(0, 0, Bmp.Width, Bmp.Height);
      FillRect(R);
      R1 := R; Inc(R1.Left, Indent);
      if(FImages<>nil)then
      begin
        R1.Right := R1.Left + FImages.Width;
        if(Index>=0)and(Index<FImages.Count)then
          FImages.Draw(Canvas,(R1.Left+R1.Right-FImages.Width+1) div 2,
                              (R1.Top+R1.Bottom-FImages.Height+1) div 2,ii);
        R1.Left := R1.Right + NTVHorzSpace;
      end;
      // Draw text
      R1.Right := R.Right;
      SetBkMode(Handle, Windows.TRANSPARENT);
      DrawText(Handle, PChar(S), Length(S), R1, DT_LEFT or DT_VCENTER
                or DT_SINGLELINE or DT_NOPREFIX or DT_END_ELLIPSIS);
    end;
    // check image list
    if FDragImageList = nil then
      FDragImageList := TImageList.CreateSize(Bmp.Width, Bmp.Height)
    else FDragImageList.Clear;
    FDragImageList.AddMasked(Bmp, Self.Color);
  finally
    Bmp.Free;
  end;
end;

function TNumTreeView.GetDragImages: TDragImageList;
begin
  Result:=FDragImageList;
end;

procedure TNumTreeView.DoCheckNode(NodeGroup:TNumberGroup;NodeIndex:Integer;ShiftDown:Boolean);
var
  AState:TCheckState;
begin
  AState:=InvertState(FNumTree.GetNodeState(NodeGroup.Child[NodeIndex]));
  FNumTree.ModifyNodeState(NodeGroup,NodeIndex,AState,-Ord(ShiftDown));
end;

function TNumTreeView.IsLastNode(Group:TNumberGroup;Index:Integer) : Boolean;
begin
  Result:=Group.GetChildShowIndex(Index)=TopRow+ViewCount-1;
end;

function TNumTreeView.IsTopNode(Group:TNumberGroup;Index:Integer) : Boolean;
begin
  Result :=(Group=FTopGroup)and(Index=FTopIndex);
end;

function  TNumTreeView.GetCaptionWidth(const Caption:string):Integer;
begin
  Result:=(FFontHeight*Length(Caption)+1) div 2+NTVHorzSpace;
end;

procedure TNumTreeView.CMFontChanged(var Message: TMessage);
begin
  inherited;
  FFontHeight:=Abs(Font.Height);
  UpdateScrollRange;
end;

procedure TNumTreeView.CMMouseEnter(var Message: TMessage);
var
  Pt: TPoint;
begin
  if(HotTrack)then
  begin
    GetCursorPos(Pt);
    Pt:=ScreenToClient(Pt);
    CheckHotTrackPos(Pt.X,Pt.Y);
  end;
  inherited;
end;

procedure TNumTreeView.CMMouseLeave(var Message: TMessage);
begin
  if(HotTrack)then HideHotTrack();
  CancelHintShow();
  inherited;
end;

procedure TNumTreeView.CMWantSpecialKey(var Msg: TCMWantSpecialKey);
begin
  inherited;
  if(Char(Msg.CharCode)=#13)then Msg.Result:=1;
end;

procedure TNumTreeView.WMCancelMode(var Msg: TMessage);
begin
  CancelMode;
  if Assigned(FEditor) then FEditor.WndProc(Msg);
  inherited;
end;

procedure TNumTreeView.WMDestroy(var Msg: TWMDestroy); 
begin
  CancelHintShow;
  inherited;
end;

procedure TNumTreeView.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result:=Msg.Result or DLGC_WANTARROWS or DLGC_WANTCHARS;;
end;

procedure TNumTreeView.WMSize(var Msg: TWMSize);
begin
  inherited;
  UpdateScrollRange;
end;

procedure TNumTreeView.WMTimer(var Msg: TWMTimer);
var
  Group:TNumberGroup;
begin
  if (Msg.TimerId = FChangeTimer) then
  begin
    FreeChangeTimer;
    DoChange;
  end else
  if (Msg.TimerId = FSearchTimer) then
  begin
    KillTimer(Handle,FSearchTimer);
    FSearchTimer:=0;
    EndSearch();
  end else
  if (Msg.TimerId = FShowHintTimer) then
  begin
    KillTimer(Handle,FShowHintTimer);
    FShowHintTimer:=0;
    ShowHint(True);
  end else
  if (Msg.TimerId = FHideHintTimer) then
  begin
    KillTimer(Handle,FHideHintTimer);
    FHideHintTimer:=0;
    if(FHintWindow<>nil)then
      FHintWindow.Hide;
  end else
  if (Msg.TimerId = FDragScrollTimer) then
  begin
    KillTimer(Handle,FDragScrollTimer);
    FDragScrollTimer:=0;
    if FDragObject <> nil then FDragObject.HideDragImage;
    TopRow:=TopRow+FDragScrollDelta;
    UpdateDragging;
    if FDragObject <> nil then FDragObject.ShowDragImage;
  end else
  if (Msg.TimerId = FDragExpandTimer) then
  begin
    KillTimer(Handle,FDragExpandTimer);
    FDragExpandTimer:=0;
    if(FDragOverGroup<>nil)then
    begin
      Group:=FDragOverGroup.GetChildGroup(FDragOverIndex);
      if(Group<>nil)then Group.Expanded:=True;
    end;
  end;
end;

procedure TNumTreeView.WMHScroll(var Msg: TWMHScroll);
var
  ScrollInfo:TScrollInfo;
begin
  case Msg.ScrollCode of
    SB_TOP:
      LeftOffset:=0;
    SB_BOTTOM:
      LeftOffset:=FMaxCaption;
    SB_LINEUP:
      LeftOffset:=LeftOffset-FFontHeight;
    SB_LINEDOWN:
      LeftOffset:=LeftOffset+FFontHeight;
    SB_PAGEUP:
      LeftOffset:=LeftOffset-ClientWidth;
    SB_PAGEDOWN:
      LeftOffset:=LeftOffset+ClientWidth;
    SB_THUMBPOSITION:
      LeftOffset:=GetScrollPos(Handle,SB_HORZ);
    SB_THUMBTRACK:
      begin
        ScrollInfo.cbSize:=SizeOf(ScrollInfo);
        ScrollInfo.fMask:=SIF_ALL;
        GetScrollInfo(Handle,SB_HORZ,ScrollInfo);
        LeftOffset:=ScrollInfo.nTrackPos;
      end;
  end;
end;

procedure TNumTreeView.WMIMEStartComp(var Message: TMessage);
begin
  inherited;
  ShowEditor;
end;

procedure TNumTreeView.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if(FEditor<>nil)and(Msg.FocusedWnd=FEditor.Handle)
      then Exit;

  if(FEditor<>nil)and(Msg.FocusedWnd<>FEditor.Handle)
      then HideEditor(True);
  UpdateCurrent;
end;

procedure TNumTreeView.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
  if FEditor<>nil then FEditor.FClickTime:=GetMessageTime;
end;

procedure TNumTreeView.WMMouseWheel(var Message: TWMMouseWheel);
begin
  TopRow:=TopRow-Message.WheelDelta div 120;
end;

procedure TNumTreeView.WMNCHitTest(var Msg:TWMNCHitTest);
begin
  DefaultHandler(Msg);
  FHitTest:=ScreenToClient(SmallPointToPoint(Msg.Pos));
end;

procedure TNumTreeView.WMSetCursor(var Msg: TWMSetCursor);
var
  NodeIndex:Integer;
  NodeGroup:TNumberGroup;
  HitPos:TNumTreeNodePos;
begin
  if(HotTrack)and(Msg.HitTest=HTCLIENT)and(FState in [ntsNormal,ntsEditing])
      and(GetHitPos(FHitTest.X,FHitTest.Y,NodeGroup,NodeIndex,HitPos))
      and((HitPos=thpCaption)or(HitPos=thpIcon))then
  begin
    SetCursor(Screen.Cursors[crHandPoint]);
    Exit;
  end;
  inherited;
end;

procedure TNumTreeView.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  UpdateCurrent;
end;

procedure TNumTreeView.WMVScroll(var Msg: TWMVScroll);
var
  ScrollInfo:TScrollInfo;
begin
  case Msg.ScrollCode of
    SB_TOP:
      TopRow:=0;
    SB_BOTTOM:
      TopRow:=TopRow+ShowCount;
    SB_LINEUP:
      TopRow:=TopRow-1;
    SB_LINEDOWN:
      TopRow:=TopRow+1;
    SB_PAGEUP:
      TopRow:=TopRow-ViewCount;
    SB_PAGEDOWN:
      TopRow:=TopRow+ViewCount;
    SB_THUMBPOSITION:
      TopRow:=GetScrollPos(Handle,SB_VERT);
    SB_THUMBTRACK:
      begin
        ScrollInfo.cbSize:=SizeOf(ScrollInfo);
        ScrollInfo.fMask:=SIF_ALL;
        GetScrollInfo(Handle,SB_VERT,ScrollInfo);
        TopRow:=ScrollInfo.nTrackPos;
      end;
  end;
end;

procedure TNumTreeView.UpdateHorzScrollPos;
begin
  if(not HandleAllocated)then Exit;
  if(ScrollBars<>ssHorizontal)and(ScrollBars<>ssBoth)then Exit;

  if(FState=ntsEditing)then HideEditor(True);
  if(GetScrollPos(Handle,SB_HORZ)<>LeftOffset)then
    SetScrollPos(Handle,SB_HORZ,LeftOffset,True);
end;

procedure TNumTreeView.UpdateVertScrollPos;
begin
  if(not HandleAllocated)then Exit;
  if(ScrollBars<>ssVertical)and(ScrollBars<>ssBoth)then Exit;

  if(FState=ntsEditing)then HideEditor(True);
  if(GetScrollPos(Handle,SB_VERT)<>TopRow)then
    SetScrollPos(Handle,SB_VERT,TopRow,True);
end;

procedure TNumTreeView.UpdateScrollRange;
var
  SaveWidth:Integer;
  SaveScroll:TScrollStyle;
begin
  if(ScrollBars=ssNone)or(not HandleAllocated)then Exit;
  
  Inc(FUpdateCount);
  try
    SaveScroll:=ScrollBars;
    try
      FScrollBars:=ssNone;

      SaveWidth:=ClientWidth;
      if(SaveScroll=ssHorizontal)or(SaveScroll=ssBoth)then
        UpdateHorzScrollRange;
      if(SaveScroll=ssVertical)or(SaveScroll=ssBoth)then
        UpdateVertScrollRange;
      if((SaveScroll=ssHorizontal)or(SaveScroll=ssBoth))and(SaveWidth<>ClientWidth)then
        UpdateHorzScrollRange;
    finally
      FScrollBars:=SaveScroll;
    end;
    UpdateHorzScrollPos;
    UpdateVertScrollPos;
  finally
    Dec(FUpdateCount);
  end;
  if(not Updating)then
  begin
    ValidateRect(Handle,nil);
    InvalidateRect(Handle,nil,True);
  end;
end;

procedure TNumTreeView.UpdateHorzScrollRange;
var
  Extent:Integer;
begin
  if(FNumTree=nil)then
    Extent:=0
  else begin
    Extent:=(FNumTree.Root.GetMaxShowLevel()+Ord(DrawRoot()))*Indent;
    if(CheckBoxes)then Inc(Extent,CheckBoxWidth+NTVHorzSpace);
    if(FStateImages<>nil)then Inc(Extent,FStateImages.Width+NTVHorzSpace);
    if(FImages<>nil)then Inc(Extent,FImages.Width+NTVHorzSpace);
    FMaxCaption:=FNumTree.MaxShowCaption;
    Inc(Extent,(FFontHeight*FMaxCaption+1) div 2+NTVHorzSpace);
    Extent:=FFontHeight*((Extent+FFontHeight-1) div FFontHeight)-ClientWidth;
  end;
  if(Extent>0)then
    SetScrollRange(Handle,SB_HORZ,0,Extent,True)
  else
    SetScrollRange(Handle,SB_HORZ,0,0,True);
  if(Extent<0)then Extent:=0;
  if(LeftOffset>Extent)then LeftOffset:=Extent;
end;

procedure TNumTreeView.UpdateVertScrollRange;
begin
  FRowHeight:=Abs(Font.Height)+2*NTVVertSpace;
  if(CheckBoxes)and(CheckBoxHeight+NTVVertSpace>FRowHeight)then
    FRowHeight:=CheckBoxHeight+NTVVertSpace;
  if(FStateImages<>nil)and(FStateImages.Height>FRowHeight)then
    FRowHeight:=FStateImages.Height;
  if(FImages<>nil)and(FImages.Height>FRowHeight)then
    FRowHeight:=FImages.Height;
  if(FRowHeight mod 2=1)then Inc(FRowHeight);

  FViewCount:=ClientHeight div FRowHeight;
  if(FViewCount=0)then Inc(FViewCount);

  if(FNumTree=nil)then
    FShowCount:=0
  else
    FShowCount:=FNumTree.Root.GetShowFamilyCount();
  if(FShowCount>ViewCount)then
    SetScrollRange(Handle,SB_VERT,0,FShowCount-ViewCount,True)
  else
    SetScrollRange(Handle,SB_VERT,0,0,True);
  if(TopRow+ViewCount>ShowCount)then
    TopRow:=ShowCount-ViewCount+1
  else //<节点收缩是需要更新TopGroup>if(FTopGroup=nil)then
    TopRow:=TopRow;
end;

procedure TNumTreeView.SetLeftOffset(const Value:Integer);
var
  Old,Min,Max:Integer;
begin
  GetScrollRange(Handle,SB_HORZ,Min,Max);
  Old:=FLeftOffset;
  FLeftOffset:=Value;
  if(FLeftOffset<Min)then FLeftOffset:=Min;
  if(FLeftOffset>Max)then FLeftOffset:=Max;

  if(not Updating)and(Old<>LeftOffset)then
  begin
    ScrollWindow(Handle,Old-LeftOffset,0,nil,nil);
    //InvalidateRect(Handle, nil, True);
  end;
  UpdateHorzScrollPos;
end;

procedure TNumTreeView.SetTopRow(const Value:Integer);
var
  Old,Min,Max:Integer;
begin
  if(HandleAllocated)then
    GetScrollRange(Handle,SB_VERT,Min,Max)
  else begin Min:=0;Max:=0;end;
  Old:=TopRow;FTopRow:=Value;
  if(FTopRow<Min)then FTopRow:=Min;
  if(FTopRow>Max)then FTopRow:=Max;
  if(FNumTree=nil)or(TopRow>=ShowCount)then
  begin
    FTopRow:=0;
    FTopGroup:=nil;FTopIndex:=-1;
  end else begin
    if(not FNumTree.Root.FindNodeByShowIndex(TopRow,FTopGroup,FTopIndex))then
    begin
      Assert(False,'showindex error, cannot find node');
      FTopRow:=0;
      FTopGroup:=FNumTree.Root;FTopIndex:=0;
    end;
    TNumberTreeHacker(FNumTree).ScrollNotify(FTopGroup,FTopIndex,ViewCount+1,Max);
    if(Max>FMaxCaption)then
      UpdateScrollRange;
  end;

  if(not Updating)and(Old<>TopRow)then
  begin
    ScrollWindow(Handle,0,(Old-TopRow)*RowHeight,nil,nil);
    //InvalidateRect(Handle, nil, True);
  end;
  UpdateVertScrollPos;
end;

function  TNumTreeView.Updating:Boolean;
begin
  Result:=(FUpdateCount>0)or(FNumTree<>nil)and(FNumTree.Updating);
end;

procedure TNumTreeView.BeginUpdate;
begin
  if(FNumTree=nil)then Exit;
  Inc(FUpdateCount);
  FNumTree.BeginUpdate;
end;

procedure TNumTreeView.EndUpdate;
begin
  Dec(FUpdateCount);
  FNumTree.EndUpdate;
end;

procedure TNumTreeView.SetNumTree(Value:TNumberTree);
begin
  FLeftOffset:=0;FMaxCaption:=0;
  FTopRow:=0;
  FTopGroup:=nil;
  FTopIndex:=-1;

  FCurRow:=-1;
  FCurGroup:=nil;
  FCurChildren:=nil;

  FHotGroup:=nil;
  FSaveRow:=-1;
  FSaveGroup:=nil;
  FSaveChildren:=nil;
  FDragGroup:=nil;
  FDragOverGroup:=nil;
  FRightClickGroup:=nil;

  if(FNumTree<>nil)then
  begin
    FNumTree.OnChange:=nil;
    FNumTree.OnInsert:=nil;
    FNumTree.OnDelete:=nil;
    FNumTree.OnShowChange:=nil;
  end;

  FNumTree:=Value;
  if(FNumTree<>nil)then
  begin
    { TODO : 如何实现多视图事件广播 }
    FTopGroup:=Value.Root;
    FTopIndex:=0;
    FNumTree.Root.Expanded:=True;
    FNumTree.OnChange:=OnNodeChange;
    FNumTree.OnInsert:=OnNodeInsert;
    FNumTree.OnDelete:=OnNodeDelete;
    FNumTree.OnShowChange:=DoTreeShowChange;
  end;

  UpdateScrollRange;
end;

procedure TNumTreeView.OnNodeChange(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  if(FNumTree.MaxShowCaption>FMaxCaption)then
    UpdateScrollRange
  else if(ChgGroup<>nil)and(ChgIndex>=0)then
    UpdateNode(ChgGroup,ChgIndex,True)
  else if(HandleAllocated)and(not Updating)then begin
    ValidateRect(Handle,nil);
    InvalidateRect(Handle,nil,True);
  end;
end;

procedure TNumTreeView.OnNodeInsert(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  if(ChgIndex>=0)then
  begin
    if(FTopGroup=ChgGroup)and(FTopIndex>=ChgIndex)then Inc(FTopIndex);
    if(FCurGroup=ChgGroup)and(FCurIndex>=ChgIndex)then Inc(FCurIndex);
    if(FHotGroup=ChgGroup)and(FHotIndex>=ChgIndex)then Inc(FHotIndex);
    if(FSaveGroup=ChgGroup)and(FSaveIndex>=ChgIndex)then Inc(FSaveIndex);
    if(FDragGroup=ChgGroup)and(FDragIndex>=ChgIndex)then Inc(FDragIndex);
    if(FDragOverGroup=ChgGroup)and(FDragOverIndex>=ChgIndex)then Inc(FDragOverIndex);
    if(FRightClickGroup=ChgGroup)and(FRightClickIndex>=ChgIndex)then Inc(FRightClickIndex);
  end;
  DoTreeShowChange(ChgGroup,ChgIndex);
end;

procedure TNumTreeView.OnNodeDelete(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  if(ChgIndex<0)then
  begin
    if(FTopGroup<>nil)and((FTopGroup=ChgGroup)or(FTopGroup.IsDescendantOf(ChgGroup)))then
      FTopGroup:=nil;
    if(FCurGroup<>nil)and((FCurGroup=ChgGroup)or(FCurGroup.IsDescendantOf(ChgGroup)))then
      FCurGroup:=nil;
    if(FHotGroup<>nil)and((FHotGroup=ChgGroup)or(FHotGroup.IsDescendantOf(ChgGroup)))then
      FHotGroup:=nil;
    if(FSaveGroup<>nil)and((FSaveGroup=ChgGroup)or(FSaveGroup.IsDescendantOf(ChgGroup)))then
      FSaveGroup:=nil;
    if(FDragGroup<>nil)and((FDragGroup=ChgGroup)or(FDragGroup.IsDescendantOf(ChgGroup)))then
      FDragGroup:=nil;
    if(FDragOverGroup<>nil)and((FDragOverGroup=ChgGroup)or(FDragOverGroup.IsDescendantOf(ChgGroup)))then
      FDragOverGroup:=nil;
    if(FRightClickGroup<>nil)and((FRightClickGroup=ChgGroup)or(FRightClickGroup.IsDescendantOf(ChgGroup)))then
      FRightClickGroup:=nil;
  end else begin
    if(FTopGroup=ChgGroup)and(FTopIndex=ChgIndex)then FTopGroup:=nil;
    if(FTopGroup=ChgGroup)and(FTopIndex>ChgIndex)then Dec(FTopIndex);
    if(FCurGroup=ChgGroup)and(FCurIndex=ChgIndex)then FCurGroup:=nil;
    if(FCurGroup=ChgGroup)and(FCurIndex>ChgIndex)then Dec(FCurIndex);
    if(FHotGroup=ChgGroup)and(FHotIndex=ChgIndex)then FHotGroup:=nil;
    if(FHotGroup=ChgGroup)and(FHotIndex>ChgIndex)then Dec(FHotIndex);
    if(FSaveGroup=ChgGroup)and(FSaveIndex=ChgIndex)then FSaveGroup:=nil;
    if(FSaveGroup=ChgGroup)and(FSaveIndex>ChgIndex)then Dec(FSaveIndex);
    if(FDragGroup=ChgGroup)and(FDragIndex=ChgIndex)then FDragGroup:=nil;
    if(FDragGroup=ChgGroup)and(FDragIndex>ChgIndex)then Dec(FDragIndex);
    if(FDragOverGroup=ChgGroup)and(FDragOverIndex=ChgIndex)then FDragOverGroup:=nil;
    if(FDragOverGroup=ChgGroup)and(FDragOverIndex>ChgIndex)then Dec(FDragOverIndex);
    if(FRightClickGroup=ChgGroup)and(FRightClickIndex=ChgIndex)then FRightClickGroup:=nil;
    if(FRightClickGroup=ChgGroup)and(FRightClickIndex>ChgIndex)then Dec(FRightClickIndex);
  end;
  if(FCurGroup=nil)then FCurChildren:=nil;
  DoTreeShowChange(ChgGroup,ChgIndex);
end;

procedure TNumTreeView.DoTreeShowChange(ChgGroup:TNumberGroup;ChgIndex:Integer);
begin
  if(not Updating)then UpdateScrollRange;
end;

function  TNumTreeView.GetTextRect(NodeGroup:TNumberGroup;NodeIndex:Integer):TRect;
var
  ShowIndex:Integer;
begin
  if(RowSelect)then
  begin
    Result.Left:=0;Result.Right:=ClientWidth;
  end else begin
    Result.Left:=(NodeGroup.OwnerLevel+Ord(DrawRoot()))*Indent;
    if(CheckBoxes)then Inc(Result.Left,CheckBoxWidth+NTVHorzSpace);
    if(FStateImages<>nil)then Inc(Result.Left,FStateImages.Width+NTVHorzSpace);
    if(FImages<>nil)then Inc(Result.Left,FImages.Width+NTVHorzSpace);
    Dec(Result.Left,LeftOffset);
    Result.Right:=Result.Left+GetCaptionWidth(FNumTree.GetNodeCaption(NodeGroup.Child[NodeIndex]));
  end;
  
  ShowIndex:=NodeGroup.GetChildShowIndex(NodeIndex);
  if(ShowIndex<TopRow)or(ShowIndex>TopRow+ViewCount)then
  begin
    Result.Top:=0;Result.Bottom:=0;
  end else begin
    Result.Top:=RowHeight*(ShowIndex-TopRow);
    Result.Bottom:=Result.Top+FRowHeight;//FFontHeight+2*NTVVertSpace;
  end;
end;

function  TNumTreeView.GetNodeRect(NodeGroup:TNumberGroup;NodeIndex:Integer;FullRow:Boolean):TRect;
var
  ShowIndex:Integer;
begin
  if(RowSelect)or(FullRow)then
  begin
    Result.Left:=0;Result.Right:=ClientWidth;
  end else begin
    Result.Left:=(NodeGroup.OwnerLevel+Ord(DrawRoot()))*Indent;
    Dec(Result.Left,LeftOffset);
    Result.Right:=Result.Left;
    if(CheckBoxes)then Inc(Result.Right,CheckBoxWidth+NTVHorzSpace);
    if(FStateImages<>nil)then Inc(Result.Right,FStateImages.Width+NTVHorzSpace);
    if(FImages<>nil)then Inc(Result.Right,FImages.Width+NTVHorzSpace);
    Inc(Result.Right,GetCaptionWidth(FNumTree.GetNodeCaption(NodeGroup.Child[NodeIndex])));
  end;

  if(not NumTree.GroupCanShow(NodeGroup))then
    ShowIndex:=-1
  else
    ShowIndex:=NodeGroup.GetChildShowIndex(NodeIndex);
  if(ShowIndex<TopRow)or(ShowIndex>TopRow+ViewCount)then
  begin
    Result.Top:=0;Result.Bottom:=0;
  end else begin
    Result.Top:=RowHeight*(ShowIndex-TopRow);
    Result.Bottom:=Result.Top+FRowHeight;//FFontHeight+2*NTVVertSpace;
  end;
end;

procedure TNumTreeView.UpdateNode(NodeGroup:TNumberGroup;NodeIndex:Integer;FullRow:Boolean);
var
  NRc:TRect;
begin
  if(HandleAllocated)and(NodeGroup<>nil)and(not Updating)
        and(NumTree.GroupCanShow(NodeGroup))then
  begin
    NRc:=GetNodeRect(NodeGroup,NodeIndex,FullRow);
    InvalidateRect(Handle,@NRc,True);
  end;
end;

procedure TNumTreeView.UpdateCurrent;
begin
  if(FCurGroup<>nil)then
    UpdateNode(FCurGroup,FCurIndex);
end;

procedure TNumTreeView.ScrollInView(NodeGroup:TNumberGroup;NodeIndex:Integer;ShowIndex:Integer);
var
  LX,NW:Integer;
begin
  if(ShowIndex<0)then ShowIndex:=NodeGroup.GetChildShowIndex(NodeIndex);

  if(ShowIndex>=0)and(ShowIndex<TopRow)then TopRow:=ShowIndex
  else if(ViewCount>0)and(ShowIndex>=TopRow+ViewCount)then
    TopRow:=ShowIndex-ViewCount+1;

  if(NodeGroup<>nil)then
  begin
    LX:=(NodeGroup.OwnerLevel+Ord(DrawRoot()))*Indent;
    NW:=GetCaptionWidth(FNumTree.GetNodeCaption(NodeGroup.Child[NodeIndex]));
    if(CheckBoxes)then Inc(NW,CheckBoxWidth+NTVHorzSpace);
    if(FStateImages<>nil)then Inc(NW,FStateImages.Width+NTVHorzSpace);
    if(FImages<>nil)then Inc(NW,FImages.Width+NTVHorzSpace);

    if(LeftOffset>LX)then
      LeftOffset:=LX
    else
    if(LX+NW-LeftOffset>ClientWidth)then begin
      NW:=LX+NW-ClientWidth;
      if(NW<LX)then LeftOffset:=NW
      else LeftOffset:=LX;
    end;
  end;
end;

procedure TNumTreeView.ScrollCurChildrenInView;
var
  NewTop,Count:Integer;
begin
  if(FCurChildren=nil)then Exit;
  Count:=FCurChildren.GetShowFamilyCount();
  if(CurRow+Count>=TopRow+ViewCount)then
  begin
    NewTop:=CurRow+Count+1-ViewCount;
    if(NewTop>CurRow)then NewTop:=CurRow;
    if(NewTop<>TopRow)then TopRow:=NewTop;
  end;
end;

function  TNumTreeView.GetHitPos(X,Y:Integer;var NodeGroup:TNumberGroup;
    var NodeIndex:Integer;var HitPos:TNumTreeNodePos):Boolean;
var
  L,R,Index:Integer;
begin
  if(FNumTree=nil)then
  begin
    Result:=False;
    Exit;
  end;
  Index:=TopRow+Y div RowHeight;
  Result:=FNumTree.Root.FindNodeByShowIndex(Index,NodeGroup,NodeIndex);
  if(Result)then
  begin
    R:=(NodeGroup.OwnerLevel+Ord(DrawRoot()))*Indent-LeftOffset;
    L:=R-Indent;
    if(X>L)and(X<R)then
    begin
      HitPos:=thpIndent;
      Exit;
    end;
    L:=R;
    if(CheckBoxes)then
      R:=L+CheckBoxWidth+NTVHorzSpace;
    if(X>L)and(X<R)then
    begin
      HitPos:=thpCheckBox;
      Exit;
    end;
    L:=R;
    if(FStateImages<>nil)then
      R:=L+FStateImages.Width+NTVHorzSpace;
    if(X>L)and(X<R)then
    begin
      HitPos:=thpStateImage;
      Exit;
    end;
    L:=R;
    if(FImages<>nil)then
      R:=L+FImages.Width+NTVHorzSpace;
    if(X>L)and(X<R)then
    begin
      HitPos:=thpIcon;
      Exit;
    end;
    L:=R;
    R:=L+GetCaptionWidth(FNumTree.GetNodeCaption(NodeGroup.Child[NodeIndex]));
    if(X>L)and(X<R)then
    begin
      HitPos:=thpCaption;
      Exit;
    end;
    HitPos:=thpSpace;
  end;
end;

function  TNumTreeView.FindNodeAt(X,Y:Integer;var NodeGroup:TNumberGroup;var NodeIndex:Integer):Boolean;
var
  HitPos:TNumTreeNodePos;
begin
  Result:=GetHitPos(X,Y,NodeGroup,NodeIndex,HitPos);
  Result:=Result and (RowSelect or (HitPos in [thpCaption,thpIcon]));
end;

procedure TNumTreeView.Paint;
var
  ARow:Integer;
  RowRect:TRect;
  Index:Integer;
  SubGroup,Group:TNumberGroup;
begin
  if(FNumTree=nil)then
  begin
    inherited;
    Exit;
  end;

  RowRect.Left:=0;RowRect.Right:=ClientWidth;
  RowRect.Bottom:=0;

  ARow:=TopRow;
  Index:=FTopIndex;Group:=FTopGroup;
  while(Group<>nil)and(Index<Group.Count)and(ARow<=TopRow+ViewCount)do
  begin
    RowRect.Top:=RowRect.Bottom;
    RowRect.Bottom:=RowRect.Top+RowHeight;
    if(RectVisible(Canvas.Handle,RowRect))then
      DrawTreeNode(RowRect,Group,Index);

    SubGroup:=Group.GetChildGroup(Index);
    if(SubGroup<>nil)and(SubGroup.Expanded)and(SubGroup.Count>0)then
    begin
      Group:=SubGroup;Index:=0;
    end else begin
      while(Group<>nil)and(Index=Group.Count-1)do
      begin
        Index:=Group.OwnerIndex;
        Group:=Group.OwnerGroup;
      end;
      Inc(Index);
    end;
    Inc(ARow);
  end;
end;

function  TNumTreeView.DrawRoot():Boolean;
begin
  Result:=ShowRoot and (ShowLines or ShowButtons);
end;

procedure TNumTreeView.DrawTreeNode(const RowRect:TRect;NodeGroup:TNumberGroup;NodeIndex:Integer);
const
  CheckStates:array[TCheckState] of Integer=
    (0,DFCS_CHECKED,DFCS_CHECKED or DFCS_INACTIVE);
var
  DR:TRect;
  ANode:TNumberNode;
  Group:TNumberGroup;
  NodeCaption:string;
  LX,CX,SX,IX,TX,TW:Integer;
  StateIndex,ImageIndex:Integer;
begin
  ANode:=NodeGroup.Child[NodeIndex];
  NodeCaption:=FNumTree.GetNodeCaption(ANode);
  StateIndex:=FNumTree.GetNodeStateIndex(ANode);
  ImageIndex:=FNumTree.GetNodeImageIndex(ANode);

  DR.Top:=RowRect.Top;DR.Bottom:=RowRect.Bottom;
  CX{Line}:=(NodeGroup.OwnerLevel+Ord(DrawRoot()))*Indent-LeftOffset;
  LX:=CX-Indent;
  if(not CheckBoxes)then SX:=CX
  else SX:=CX+CheckBoxWidth+NTVHorzSpace;
  if(FStateImages=nil)then IX:=SX
  else IX:=SX+FStateImages.Width+NTVHorzSpace;
  if(FImages=nil)then TX:=IX
  else TX:=IX+FImages.Width+NTVHorzSpace;
  TW:=GetCaptionWidth(NodeCaption);

  Canvas.Font.Assign(Font);
  if(NodeGroup=FCurGroup)and(NodeIndex=FCurIndex)then
  begin
    if(RowSelect)then
    begin
      DR.Left:=RowRect.Left;DR.Right:=RowRect.Right;
    end else begin
      DR.Left:=TX;DR.Right:=DR.Left+TW;
    end;
    if(Focused)then
    begin
      Canvas.Brush.Color:=clHighlight;
      Canvas.Font.Color:=clHighlightText;
    end else begin
      Canvas.Brush.Color:=clBtnFace;
      Canvas.Font.Color:=clBtnText;
    end;
    Canvas.Brush.Style:=bsSolid;
    Canvas.FillRect(DR);
    if(Focused)and(not RowSelect)then
    begin
      Canvas.Brush.Color:=clBtnShadow;
      Canvas.FrameRect(DR);
    end;
  end else
  if(HotTrack)and(NodeGroup=FHotGroup)and(NodeIndex=FHotIndex)then
  begin
    Canvas.Font.Color:=clBlue;
    Canvas.Font.Style:=Canvas.Font.Style+[fsUnderline];
  end else
  if(NodeGroup=FRightClickGroup)and(NodeIndex=FRightClickIndex)
    or(NodeGroup=FDragOverGroup)and(NodeIndex=FDragOverIndex)then
  begin
    if(RowSelect)then
    begin
      DR.Left:=RowRect.Left;DR.Right:=RowRect.Right;
    end else begin
      DR.Left:=TX;DR.Right:=DR.Left+TW;
    end;
    Canvas.Font.Color:=clBlue;
    Canvas.Brush.Color:=clPurple;
    Canvas.FrameRect(DR);
  end;

  DR.Left:=LX;
  if(ShowLines)then
  begin
    Group:=NodeGroup;
    while(DR.Left>0)and(Group<>nil)do
    begin
      DR.Right:=DR.Left;DR.Left:=DR.Right-Indent;
      if(Group.OwnerGroup<>nil)and(Group.OwnerIndex<Group.OwnerGroup.Count-1)then
        DrawTreeViewLine(Canvas.Handle,DR);
      Group:=Group.OwnerGroup;
    end;
  end;

  Group:=NodeGroup.GetChildGroup(NodeIndex);
  if(Group<>nil)and(Group.Count=0)then Group:=nil;
  DR.Left:=LX;DR.Right:=DR.Left+Indent;
  if(DR.Right>0)and(ShowLines)then
    DrawTreeViewLine(Canvas.Handle,DR,(ShowButtons)and(Group<>nil),NodeIndex=NodeGroup.Count-1);
  if(DR.Right>0)and(ShowButtons)and(Group<>nil)then
    DrawTreeViewButton(Canvas.Handle,DR,Group.Expanded);

  if(CheckBoxes)then
  begin
    DR.Left:=CX;DR.Right:=DR.Left+CheckBoxWidth;
    DR.Top:=(RowRect.Bottom+RowRect.Top-CheckBoxHeight) div 2;
    DR.Bottom:=DR.Top+CheckBoxHeight;
    DrawFrameControl(Canvas.Handle,DR,DFC_BUTTON,
        DFCS_FLAT or DFCS_BUTTONCHECK 
        or CheckStates[FNumTree.GetNodeState(ANode)]);
    DR.Top:=RowRect.Top;DR.Bottom:=RowRect.Bottom;
  end;
  if(FStateImages<>nil)and(StateIndex>=0)and(StateIndex<FStateImages.Count)then
  begin
    ImageList_DrawEx(FStateImages.Handle,StateIndex,Canvas.Handle,
        SX,(RowRect.Bottom+RowRect.Top-FStateImages.Height) div 2,0,0,
        clNone,clNone,ILD_Transparent);
  end;
  if(FImages<>nil)and(ImageIndex>=0)and(ImageIndex<FImages.Count)then
  begin
    ImageList_DrawEx(FImages.Handle,ImageIndex,Canvas.Handle,
        IX,(RowRect.Bottom+RowRect.Top-FImages.Height) div 2,0,0,
        clNone,clNone,ILD_Transparent);
  end;

  Canvas.Brush.Style:=bsClear;
  Canvas.TextOut(TX+NTVHorzSpace div 2,
                (RowRect.Bottom+RowRect.Top-FFontHeight+1) div 2,NodeCaption);
end;

procedure TNumTreeView.KeyDown(var Key: Word; Shift: TShiftState);
var
  SL:Integer;
begin
  inherited KeyDown(Key, Shift);
  if(FNumTree=nil)then Exit;

  if Key = VK_ESCAPE then
  begin
    CancelMode;
    if(FSearching)then EndSearch;
    Exit;
  end;
  if (FState = ntsEditing) and (Key in
      [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_TAB, VK_RETURN]) then
  begin
    HideEditor(True);
    if(Key=VK_RETURN)then Key := 0;
  end;

  if (Key = VK_F3) and (FSearchText <> '')then
    StartSearch(False);
  if FSearching and (Key in [VK_F3, VK_DELETE, VK_BACK]) then
  begin
    case Key of
      VK_F3: DoSearch(FSearchText, ssShift in Shift);
      VK_DELETE: FSearchText := '';
      VK_BACK:
        begin
          SL:=Length(FSearchText);
          if(ByteType(FSearchText,SL)=mbTrailByte)then
            Delete(FSearchText, SL-1, 2)
          else Delete(FSearchText, SL, 1);
        end;
    end;
    Key:=0;
  end;

  case Key of
    VK_F2:
      if(Shift=[])then
      begin
        ShowEditor();
        Key:=0;
      end;
    VK_SPACE:
      if([ssAlt,ssCtrl]*Shift=[])then begin
        if(FChangeTimer<>0)then
        begin
          FreeChangeTimer;
          DoChange;
        end;
        if(CheckBoxes)and(FCurGroup<>nil)then
          DoCheckNode(FCurGroup,FCurIndex,[ssShift,ssCtrl]*Shift<>[]);
        Key:=0;
      end;
    VK_RETURN:
      if([ssAlt,ssCtrl]*Shift=[])then begin
        if(FChangeTimer<>0)then
        begin
          FreeChangeTimer;
          DoChange;
        end;
        if(not ReadOnly)then ShowEditor else
        if(CheckBoxes)and(FCurGroup<>nil)then
          DoCheckNode(FCurGroup,FCurIndex,[ssShift,ssCtrl]*Shift<>[]);
      end;
    VK_HOME:
      begin
        if(Shift=[ssCtrl])then
        begin
          TopRow:=0;
          Key:=0;
        end else
        if(Shift=[])then
        begin
          CurRow:=0;
          Key:=0;
        end;
      end;
    VK_END:
      begin
        if(Shift=[ssCtrl])then
        begin
          TopRow:=ShowCount-ViewCount;
          Key:=0;
        end else
        if(Shift=[])then
        begin
          CurRow:=ShowCount-1;
          Key:=0;
        end;
      end;
    VK_PRIOR:
      begin
        if(Shift=[ssCtrl])then
        begin
          TopRow:=TopRow-ViewCount;
          Key:=0;
        end else
        if(Shift=[])then
        begin
          CurRow:=CurRow-ViewCount;
          Key:=0;
        end;
      end;
    VK_NEXT:
      begin
        if(Shift=[ssCtrl])then
        begin
          TopRow:=TopRow+ViewCount;
          Key:=0;
        end else
        if(Shift=[])then
        begin
          CurRow:=CurRow+ViewCount;
          Key:=0;
        end;
      end;
    VK_UP:
      begin
        if(Shift=[ssCtrl])then
        begin
          TopRow:=TopRow-1;
          Key:=0;
        end else
        if(Shift=[])then
        begin
          CurRow:=CurRow-1;
          Key:=0;
        end;
      end;
    VK_DOWN:
      begin
        if(Shift=[ssCtrl])then
        begin
          TopRow:=TopRow+1;
          Key:=0;
        end else
        if(Shift=[])then
        begin
          CurRow:=CurRow+1;
          Key:=0;
        end;
      end;
    VK_LEFT:
      begin
        if(FCurGroup<>nil)and((Shift=[])or(Shift=[ssShift]))then begin
          if(FCurChildren<>nil)and(FCurChildren.Expanded)then
          begin
            FCurChildren.Collapse(1-Ord(ssShift in Shift));
            //CheckCurrentHidden(FCurChildren);
          end else if(FCurGroup<>nil)and(FCurGroup<>NumTree.Root)then
            SetCurrent(FCurGroup.OwnerGroup,FCurGroup.OwnerIndex);
          Key:=0;
        end else
        if(Shift=[ssCtrl])then begin
          LeftOffset:=LeftOffset-FFontHeight;
          Key:=0;
        end;
      end;
    VK_RIGHT:
      begin
        if(FCurChildren<>nil)and((Shift=[])or(Shift=[ssShift]))then begin
          if(not FCurChildren.Expanded)then
          begin
            FCurChildren.Expand(1-Ord(ssShift in Shift));
            ScrollCurChildrenInView;
          end else
            SetCurrent(FCurChildren,0);
          Key:=0;
        end else
        if(Shift=[ssCtrl])then begin
          LeftOffset:=LeftOffset+FFontHeight;
          Key:=0;
        end;
      end;
  end;
end;

procedure TNumTreeView.KeyPress(var Key: Char);
  function ShiftDown():Boolean;
  begin
    Result:=GetKeyState(VK_Shift) and $80000000<>0;
  end;
  function ControlorAltDown: Boolean;
  begin
    Result := (GetKeyState(VK_CONTROL) <> 0) and
      (GetKeyState(VK_MENU) <> 0);
  end;
begin
  {if(FState=ntsEditing)then
  begin
    if(Key=#13)then HideEditor(True) else
    if(Key=#27)then HideEditor(False);
    Exit;
  end;}
  inherited KeyPress(Key);
  if(FNumTree=nil)then Exit;

  if(not FSearching)then
    case Key of
      ^X:;{ TODO : Do Cut }
      ^C:if(ReadOnly)and(FCurGroup<>nil)then
         begin
           if(ShiftDown)then
             Clipboard.SetTextBuf(PChar(FNumTree.GetNodeHint(FCurGroup.Child[FCurIndex])))
           else
             Clipboard.SetTextBuf(PChar(FNumTree.GetNodeCaption(FCurGroup.Child[FCurIndex])))
         end else
           ;{ TODO : Do Copy }
      ^V:begin
           { TODO : Do Paste }
           Key:=#0;
         end;
      ^F:StartSearch(True);
      '+':
        begin
          if(FCurChildren<>nil)then begin
            ScrollInView(FCurGroup,FCurIndex,FCurRow);
            FCurChildren.Expand(1-Ord(ShiftDown));
            ScrollCurChildrenInView;
          end;
          Key:=#0;
        end;
      '-':
        begin
          if(FCurChildren<>nil)then begin
            ScrollInView(FCurGroup,FCurIndex,FCurRow);
            FCurChildren.Collapse(1-Ord(ShiftDown));
            //CheckCurrentHidden(FCurChildren);
          end;
          Key:=#0;
        end;
      '*':
        begin
          if(FCurChildren<>nil)then begin
            ScrollInView(FCurGroup,FCurIndex,FCurRow);
            if(FCurChildren.Expanded)then
            begin
              FCurChildren.Collapse(0);
              //CheckCurrentHidden(FCurChildren);
            end else begin
              FCurChildren.Expand(0);
              ScrollCurChildrenInView;
            end;
          end;
          Key:=#0;
        end;
    end;
  if(FSearching)and(Key=^V)then
  begin
    FSearchText:=FSearchText+ClipBoard.AsText;
    DoSearch(FSearchText, False);
  end;
  if (Key in [#32..#255]) and not ControlorAltDown then
  begin
    if(not FSearching)then StartSearch(True);
    FSearchText := FSearchText + Key;
    DoSearch(FSearchText, False);
  end;
end;

procedure TNumTreeView.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Index:Integer;
  Group,Children:TNumberGroup;
  HitPos:TNumTreeNodePos;
  AlreadyFocused:Boolean;
begin
  if(FNumTree=nil)then
  begin
    inherited MouseDown(Button, Shift, X, Y);
    Exit;
  end;
  if(FState=ntsEditing)then HideEditor(True);
  FState:=ntsNormal;

  AlreadyFocused:=Focused;
  if CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    if not IsActiveControl(Self) then
    begin
      MouseCapture := False;
      Exit;
    end;
  end;

  if(Button=mbRight)then
  begin
    if(RightClick)and(GetHitPos(X,Y,Group,Index,HitPos))then
    begin
      FRightClickGroup:=Group;
      FRightClickIndex:=Index;
      UpdateNode(FRightClickGroup,FRightClickIndex);
    end;
  end else
  if(Button=mbLeft)then
  begin
    if(GetHitPos(X,Y,Group,Index,HitPos))then
    begin
      if(RowSelect)and(HitPos=thpSpace)then HitPos:=thpCaption;
      Children:=Group.GetChildGroup(Index);
      case HitPos of
        thpIndent:
          begin
            if(Children<>nil)then begin
              if(Children.Expanded)then
                Children.Collapse(1-Ord(ssShift in Shift))
              else begin
                Children.Expand(1-Ord(ssShift in Shift));
                ScrollInView(Children,Children.Count-1);
                ScrollInView(Group,Index);
              end;
              CheckCurrentHidden(Children);
            end;
          end;
        thpCheckBox:
          DoCheckNode(Group,Index,[ssShift,ssCtrl]*Shift<>[]);
        thpIcon,thpCaption:
          begin
            if(FCurGroup=Group)and(FCurIndex=Index)then
            begin
              if(ssDouble in Shift)and(Children<>nil)then
              begin
                if(Children.Expanded)then
                  Children.Collapse(1-Ord(ssShift in Shift))
                else Children.Expand(1-Ord(ssShift in Shift));
                CheckCurrentHidden(Children);
              end else begin
                if(AlreadyFocused)then ShowEditor();
              end;
            end else
              SetCurrent(Group,Index);
            if(AutoExpand)then
            begin
              if(Children<>nil)then
              begin
                Children.Expanded:=not Children.Expanded;
                if(Children.Expanded)then
                  ScrollCurChildrenInView;
              end;
              CollapseBrothers(FCurGroup,FCurIndex);
            end;
            if(not(ssDouble in Shift))then
            begin
              FState:=ntsNodeDown;
              FDragPos.X:=X;FDragPos.Y:=Y;
            end;
          end;
      end;
    end;
  end;

  try
    inherited MouseDown(Button, Shift, X, Y);
  except
    CancelMode;
    raise
  end;
end;

procedure TNumTreeView.MouseMove(Shift:TShiftState;X,Y:Integer);
var
  Index:Integer;
  Group:TNumberGroup;
begin
  if(FNumTree=nil)then
  begin
    inherited MouseMove(Shift, X, Y);
    Exit;
  end;

  if(ssLeft in Shift)and(AutoDrag)and(FState=ntsNodeDown)then
  begin
    if(FindNodeAt(X,Y,Group,Index))and((Abs(FDragPos.X-X)>3)or(Abs(FDragPos.Y-Y)>3))then
    begin
      if(Group=FCurGroup)and(Index=FCurIndex)then
      begin
        BeginDrag(True);
      end;
    end;
  end;

  Index:=FHotIndex;
  Group:=FHotGroup;
  CheckHotTrackPos(X, Y);
  if(Group<>FHotGroup)or(Index<>FHotIndex)then
    ShowHint(False);

  try
    inherited MouseMove(Shift, X, Y);
  except
    CancelMode;
    raise
  end;
end;

procedure TNumTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if(FNumTree=nil)then
  begin
    inherited MouseUp(Button, Shift, X, Y);
    Exit;
  end;

  UpdateNode(FRightClickGroup,FRightClickIndex);
  FRightClickGroup:=nil;
  FRightClickIndex:=0;

  try
    inherited MouseUp(Button, Shift, X, Y);
  except
    CancelMode;
    raise
  end;
end;

procedure TNumTreeView.SetCurRow(Value:Integer);
var
  Index:Integer;
  T,Group:TNumberGroup;
begin
  if(Value<0)then Value:=0;
  if(Value>=ShowCount)then Value:=ShowCount-1;
  Group:=nil;
  if(Value=FCurRow)then
  begin
    Group:=FCurGroup;
    Index:=FCurIndex;
  end else
  if(Value=FCurRow+1)then
  begin
    if(FCurChildren<>nil)and(FCurChildren.Expanded)then
    begin
      Group:=FCurChildren;
      Index:=0;
    end else
    if(FCurGroup<>nil)and(FCurIndex<FCurGroup.Count-1)then begin
      Group:=FCurGroup;
      Index:=FCurIndex+1;
    end;
  end else
  if(Value=FCurRow-1)then
  begin
    if(FCurGroup<>nil)and(FCurIndex>0)then begin
      Group:=FCurGroup;
      Index:=FCurIndex-1;
      T:=Group.GetChildGroup(Index);
      while(T<>nil)and(T.Expanded)do
      begin
        Group:=T;
        Index:=Group.Count-1;
        T:=Group.GetChildGroup(Index);
      end;
    end;
  end;
  if(Group=nil)then
    FNumTree.Root.FindNodeByShowIndex(Value,Group,Index);
    
  if(Group<>nil)then SetCurrent(Group,Index);
end;

function TNumTreeView.SetCurrent(NodeGroup:TNumberGroup;NodeIndex:Integer):Boolean;
begin
  Result:=True;
  if(Assigned(OnChanging))then OnChanging(Self,NodeGroup,NodeIndex,Result);
  if(Result)then
  begin
    FreeChangeTimer;

    UpdateCurrent;

    if(NodeGroup<>nil)then
    begin
      NumTree.ExpandGroup(NodeGroup);
      FCurGroup:=NodeGroup;
      FCurIndex:=NodeIndex;
      FCurChildren:=FCurGroup.GetChildGroup(NodeIndex);
      FCurRow:=FCurGroup.GetChildShowIndex(NodeIndex);
      ScrollInView(FCurGroup,FCurIndex,FCurRow);
      UpdateCurrent;
    end else begin
      FCurGroup:=nil;
      FCurIndex:=-1;
      FCurChildren:=nil;
      FCurRow:=-1;
      UpdateCurrent;
    end;
    if(ChangeDelay=0)then DoChange
    else FChangeTimer:=SetTimer(Handle,NTVChangeTimer,ChangeDelay,nil);
  end;
end;

function TNumTreeView.SetCurrentNode(NumNode:TNumberNode):Boolean;
var
  Index:Integer;
  Group:TNumberGroup;
begin
  if(NumTree.Root.FindNode(NumNode,Group,Index))then
    Result:=SetCurrent(Group,Index)
  else Result:=False;
end;

procedure TNumTreeView.DoChange;
begin
  if(Assigned(OnChange))then OnChange(Self,FCurGroup,FCurIndex);
end;

procedure TNumTreeView.ResetSearchTimer;
begin
  if FSearchTimer <> 0 then
  begin
    KillTimer(Handle,FSearchTimer);
    FSearchTimer:=0;
  end;
  FSearchTimer:=SetTimer(Handle,NTVSearchTimer,NTVSearchWaitTime,nil);
end;

procedure TNumTreeView.StartSearch(ClearSearch:Boolean);
begin
  FSearching:=True;
  if(ClearSearch)then FSearchText:='';
  ResetSearchTimer;
end;

procedure TNumTreeView.DoSearch(const SearchText:string;UpSearch:Boolean);
begin
  { TODO : Do Text search ??? }
  //OnSearchText:=FNumTree.DoSearchText;
  //if(Assigned(OnSearchText))then OnSearchText(Self,CurGroup,CurIndex,SearchText,UpSearch);
  ResetSearchTimer;
end;

procedure TNumTreeView.EndSearch;
begin
  FSearching:=False;
end;


type
  PListStringRec=^TListStringRec;
  TListStringRec=record
    //TmpZdm  :PChar;
    Expand  :Boolean;
    MaxRank :Integer;
    DotRank :Integer;
    OutStrings:TStrings;
  end;

procedure TNumTreeView.ListTreeStrings(OutStrings:TStrings;ListRoot:TNumberGroup;
        RankLmt:Integer;Expand:Boolean);
var
  ListRec:TListStringRec;
begin
  OutStrings.BeginUpdate;
  try
    OutStrings.Clear;
    //ListRec.TmpZdm:=StrAlloc(TQYTree(NumTree).DataEnv.ZDMLength+1);
    try
      ListRec.Expand:=Expand;
      ListRec.OutStrings:=OutStrings;
      if(ListRoot=nil)or(ListRoot.OwnerGroup=nil)then begin
        ListRoot:=NumTree.Root;
        ListRec.DotRank:=1;
        if(RankLmt>0)then Inc(RankLmt);
      end else begin
        ListRec.DotRank:=ListRoot.OwnerLevel;
        GetNodeString(ListRoot.OwnerNode,ListRoot.OwnerGroup,ListRoot,Integer(@ListRec));
      end;
      if(RankLmt=0)then ListRec.MaxRank:=0
      else ListRec.MaxRank:=ListRoot.OwnerLevel+RankLmt;

      if(RankLmt>0)then
        ListRoot.ForSubLevelChild(GetNodeString,RankLmt,Integer(@ListRec))
      else if(Expand)then
        ListRoot.ForAll(GetNodeString,True,Integer(@ListRec))
      else
        ListRoot.ForAllExpanded(GetNodeString,Integer(@ListRec));
    finally
      //StrDispose(ListRec.TmpZdm);
    end;
  finally
    OutStrings.EndUpdate;
  end;
end;

procedure TNumTreeView.GetNodeString(NodeID:LongInt;NodeGroup,SubNodes:TNumberGroup;Param:Integer);
var
  I:Integer;
  sHead:string;
  ListRec:PListStringRec;
begin
  ListRec:=Pointer(Param);

  sHead:='';
  for I:=ListRec.DotRank to NodeGroup.OwnerLevel do
    sHead:=sHead+'·';//'　';
  if(SubNodes=nil)then sHead:=sHead+'ｏ'
  else if((ListRec.Expand)or(SubNodes.Expanded))
        and((ListRec.MaxRank=0)or(SubNodes.OwnerLevel<ListRec.MaxRank))then
    sHead:=sHead+'◇'
  else sHead:=sHead+'⊙';
  ListRec.OutStrings.Add(sHead+NumTree.GetNodeCaption(NodeID));
end;

end.
