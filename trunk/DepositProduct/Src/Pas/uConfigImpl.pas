unit uConfigImpl;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  csIniDBConfigSection = 'DBConfig';

  {Section: DBConfig}
  csIniDBConfigConnectionString = 'ConnectionString';

type
  TIniOptions = class(TObject)
  private
    {Section: DBConfig}
    FDBConfigConnectionString: string;
  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    {Section: DBConfig}
    property DBConfigConnectionString: string read FDBConfigConnectionString write FDBConfigConnectionString;
  end;

var
  IniOptions: TIniOptions = nil;

implementation

procedure TIniOptions.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: DBConfig}
    FDBConfigConnectionString := Ini.ReadString(csIniDBConfigSection, csIniDBConfigConnectionString, EmptyStr);

  end;
end;

procedure TIniOptions.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    {Section: DBConfig}
    Ini.WriteString(csIniDBConfigSection, csIniDBConfigConnectionString, FDBConfigConnectionString);
  end;
end;

procedure TIniOptions.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  if FileExists(FileName) then
  begin
    Ini := TIniFile.Create(FileName);
    try
      LoadSettings(Ini);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TIniOptions.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

initialization
  IniOptions := TIniOptions.Create;

finalization
  IniOptions.Free;

end.

