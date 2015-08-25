unit uFieldItemImpl;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,DBClient,KeyPairDictionary, StdCtrls, Buttons, ExtCtrls;

type

  TDataType=(dtBoolean,dtInteger,dtCurrency,dtDouble,dtString,dtWideString,dtMemo,dtDate,dtTime,dtDateTime,dtSmallint,dtBlob);

  TFieldItem=class(TPersistent)
  private
    FFieldName: string;
    FDisplayLabel: string;
    FIsKey:Boolean ;
    FIsShow: Boolean;
    FIsBrowseShow : Boolean;
    FShowWidth:integer;
    FDataType:TDataType;
  public
    procedure Assign(Source: TPersistent); override;
    function GetFieldSql:string;
    property FieldName:string read FFieldName write FFieldName;
    property DisplayLabel:string read FDisplayLabel write FDisplayLabel;
    property IsKey:Boolean read FIsKey write FIsKey;
    property IsShow:Boolean read FIsShow write FIsShow;
    property IsBrowseShow:Boolean read FIsBrowseShow write FIsBrowseShow;
    property ShowWidth:integer read FShowWidth write FShowWidth;
    property DataType:TDataType read FDataType write FDataType;
  end;

  TFieldItems=class(TKeyStringDictionary)
  private
    function GetFields(Index: Integer): TFieldItem;
  public
    constructor Create(AOwner:TComponent);override;
    procedure Clear;override;
    procedure Assign(Source: TKeyStringDictionary);
    property Fields[Index:Integer]:TFieldItem read GetFields;default;
  end;


  TFieldsImpl=class(TObject)
  public

    class procedure AddField(AFieldItems:TFieldItems ;
        AFieldName: string;
        ADisplayLabel: string;
        AIsKey:Boolean ;
        AIsShow: Boolean;
        AIsBrowseShow : Boolean;
        AShowWidth:integer
        )  ;
  end;



implementation

{ TFieldsImpl }

class procedure TFieldsImpl.AddField(AFieldItems: TFieldItems;
  AFieldName, ADisplayLabel: string;AIsKey, AIsShow, AIsBrowseShow: Boolean;
  AShowWidth: integer);
var
  AFieldItem:TFieldItem ;
begin
  AFieldItem:=TFieldItem.Create ;
  AFieldItem.FieldName:=AFieldName ;
  AFieldItem.DisplayLabel:=ADisplayLabel;
  AFieldItem.IsKey := AIsKey ;
  AFieldItem.IsShow:=AIsShow;
  AFieldItem.IsBrowseShow:=AIsBrowseShow ; 
  AFieldItem.ShowWidth :=AShowWidth ;
  AFieldItem.DataType:=dtString ;
  try
    AFieldItems.Add(AFieldItem.FieldName,AFieldItem.DisplayLabel,AFieldItem) ;
  except
    on e:exception do
    begin
    end ;
  end;

end;

{ TFieldItem }

procedure TFieldItem.Assign(Source: TPersistent);
begin
  if(Source is TFieldItem)then
  begin
    FIsShow:=TFieldItem(Source).IsShow;
    FFieldName:= TFieldItem(Source).FieldName;
    FDisplayLabel:= TFieldItem(Source).DisplayLabel;
    FIsKey:= TFieldItem(Source).IsKey;
    FIsBrowseShow:= TFieldItem(Source).IsBrowseShow;
    FShowWidth:= TFieldItem(Source).ShowWidth;
  end;
end;

function TFieldItem.GetFieldSql: string;
begin
  Result:=EmptyStr;
end;

{ TFieldItems }

procedure TFieldItems.Clear;
var
  Index:Integer;
  Obj:TObject;
begin
  for Index:=0 to inherited Count -1 do
  begin
    Obj:=inherited Objects[Index];
    if Obj<>nil then
      FreeAndNIl(Obj);
  end;
  inherited;
end;

procedure TFieldItems.Assign(Source: TKeyStringDictionary);
var
  Item:TFieldItem;
  i:integer ;
begin
  if not (Source is TFieldItems)then exit ;
  Clear ;
  for i:=0 to TFieldItems(Source).Count -1 do
  begin
    Item:=TFieldItem.Create;
    Item.Assign(TFieldItems(Source).Fields[i]) ;
    Add(Item.FieldName,Item.DisplayLabel,Item); 
  end ;
end;

constructor TFieldItems.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;



function TFieldItems.GetFields(Index: Integer): TFieldItem;
begin
  Result:=(inherited Objects[Index])as TFieldItem;
end;

end.
 