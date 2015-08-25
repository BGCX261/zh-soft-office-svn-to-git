{****************************************************************************}
{ @@Copyright:SUNTOGETHER                                                    }
{ @@Summary:数据访问接口实现.                                                }
{ @@Description:                                                             }
{ @@Author: Suntogether                                                      }
{ @@Version:1.0                                                              }
{ @@Create:2007-01-15                                                        }
{ @@Remarks:                                                                 }
{ @@Modify:                                                                  }
{****************************************************************************}
unit DataAccessImpl;

interface


uses Classes,SysUtils,DBClient,DB,AdoDb,DataAccessInt,
  Provider,DataMainImpl;  


type
  TDataModuleClass =Class of TDataMain;

  TDataAccessFactoryImpl=class(TComponent,IDataAccessFactoryInt)
  private
    FCollection: TCollection;
  protected
    procedure Initialize;
    function Search(DataAccessType:string):TCollectionItem;
    function GetDataAccessInt(ADataAccessType:string):IDataAccessInt;
    property Collection:TCollection read FCollection;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure Add(ADataAccessType:string;ADataAccessClass:TDataModuleClass);
  end;





  
implementation

uses Forms,FrameCommon;


type
  TDataAccessItem=class(TCollectionItem)
  private
    FDataAccessType: string;
    FDataAccessClass: TDataModuleClass;
  public
    property DataAccessType:string read FDataAccessType write FDataAccessType;
    property DataAccessClass:TDataModuleClass read FDataAccessClass write FDataAccessClass;
  end;
  




{ TDataAccessFactoryImpl }

procedure TDataAccessFactoryImpl.Add(ADataAccessType: string;
  ADataAccessClass: TDataModuleClass);
var
  Item:TDataAccessItem;
begin
  Item:=TDataAccessItem(Collection.Add);
  Item.DataAccessType:=ADataAccessType;
  Item.DataAccessClass:=ADataAccessClass;
end;

constructor TDataAccessFactoryImpl.Create(AOwner: TComponent);
begin
  inherited;
  FCollection:=TCollection.Create(TDataAccessItem);
  Initialize;
end;

destructor TDataAccessFactoryImpl.Destroy;
begin
  FreeAndNil(FCollection);
  inherited;
end;

function TDataAccessFactoryImpl.GetDataAccessInt(
  ADataAccessType: string): IDataAccessInt;
begin
  if(DataMain=nil)then
  begin
    DataMain:=TDataMain.Create(Application);
  end;
  result:=DataMain as IDataAccessInt;
end;

procedure TDataAccessFactoryImpl.Initialize;
var
  Item:TDataAccessItem;
begin
  Item:=TDataAccessItem(Collection.Add);
  Item.DataAccessType:=LocalNetAccessTypeName;
  Item.DataAccessClass:=TDataMain;
end;

function TDataAccessFactoryImpl.Search(
  DataAccessType: string): TCollectionItem;
var
  Index:Integer;
begin
  Result:=nil;
  for Index:=0 to FCollection.Count-1 do
    if SameText(DataAccessType,TDataAccessItem(Collection.Items[Index]).DataAccessType)then
    begin
      Result:=Collection.Items[Index];
      Break;
    end;

end;
end.
