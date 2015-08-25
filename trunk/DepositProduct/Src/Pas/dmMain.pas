unit dmMain;

interface

uses
  SysUtils, Classes, DB, ADODB, DBClient,Forms,Windows,Dialogs, Provider,
  JvSplit,JvSplitter,StrUtils,FileCtrl;

type
  Tdm = class(TDataModule)
    dsMain: TClientDataSet;
    qryMain: TADOQuery;
    conMain: TADOConnection;
    dtstprvdr: TDataSetProvider;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function SelectSql(ASelectSql:string;var ADataSet:TClientDataSet):Boolean;
    function IsExistSql(ASelectSql:string):Boolean;
    function ExecSql(AExecSql:string):Boolean;
    function ConnectionString:string;
    function IsConnected:Boolean;
  end;

var
  dm: Tdm;

implementation

uses
  uFunc,uConfigImpl;

{$R *.dfm}

function Tdm.SelectSql(ASelectSql:string;var ADataSet:TClientDataSet):Boolean;
begin
  //
  if ADataSet = nil  then
  ADataSet := TClientDataSet.Create(nil);
  try
    conMain.Connected:=false;
    conMain.Connected:=true;
    dsMain.Active:=false;
    dsMain.CommandText:=ASelectSql;
    dsMain.Active:=true;
    ADataSet.Data:=dsMain.Data;
    ADataSet.Active := True;
    dsMain.Active:=false;
    Result := True;
  except
    Result := False;
  end;

end;

function Tdm.IsExistSql(ASelectSql:string):Boolean;
begin
  //
  try
    conMain.Connected:=false;
    conMain.Connected:=true;
    dsMain.Active:=false;
    dsMain.CommandText:=ASelectSql;
    dsMain.Active:=true;
    Result := dsMain.RecordCount > 0;
    dsMain.Active:=false;

  except
    Result := False;
  end;
end;

function Tdm.ExecSql(AExecSql:string):Boolean;
var
  list :TStrings;
  i:Integer;
  execSql:string;
begin
  //
  list := TStringList.Create;

  try
    conMain.Connected:=false;
    conMain.Connected:=true;
    dsMain.Active:=false;
    list := SplitString(AExecSql,'#');
    if list.Count = 1 then
    begin
      execSql := list[0];
      dsMain.CommandText:=execSql;
      dsMain.Execute;
    end
    else
    begin
      for i:=0 to list.Count - 2 do
      begin
        execSql := list[i] ;
        dsMain.CommandText:=execSql;
        dsMain.Execute;
      end;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function Tdm.ConnectionString:string;
begin
  Result := conMain.ConnectionString;
end;
function Tdm.IsConnected:Boolean;
begin
  conMain.ConnectionString := IniOptions.DBConfigConnectionString;
  conMain.LoginPrompt := False;
  conMain.CommandTimeout := 30;
  conMain.KeepConnection := True;
  try
    conMain.Open ;
    Result := conMain.Connected;
  except
    Result := False;
  end;

end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin

  IniOptions.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\AppConfig.ini');
  if not IsConnected then
  begin
    MessageError('数据连接失败!');
    Application.Terminate;
  end;
end;

end.
