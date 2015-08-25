{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2006 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit ZhIni;
{* |<PRE>
================================================================================
* ������ƣ�������������
* ��Ԫ���ƣ���չ��INI���ʵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���õ�Ԫ��дʱ�ο��� RxLib 2.75 �е� RxIni.pas
* ����ƽ̨��PWin2000Pro + Delphi 5.0
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6
* �� �� �����õ�Ԫ�е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnIni.pas,v 1.3 2006/01/13 12:41:33 passion Exp $
* �޸ļ�¼��2002.10.20 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

//{$I CnPack.inc}

uses
  Windows, Classes, SysUtils, Forms, IniFiles, Graphics, ZhIniStrUtils, ZhStream;

type

//==============================================================================
// ��չ�� INI ������
//==============================================================================
   
{ TCnIniFile }

  TCnIniFile = class(TCustomIniFile)
  {* ��չ�� INI �����࣬ʹ�� Wrap ģʽ�� TCustomIniFile ������չ����������������
     �ȿɵ���ͨ���ļ��� INI ��������ֿɽ�����Ϊ���� TCustomIniFile ����İ�װ��
     �ǽ�����չ�Ĳ�����}
  private
    FIni: TCustomIniFile;
    FOwned: Boolean;
    function GetFileName: string;
  protected
    property Owned: Boolean read FOwned;
    property Ini: TCustomIniFile read FIni;
  public
    constructor Create(AIni: TCustomIniFile; AOwned: Boolean = False); overload;
    {* ��װ��������ʹ�øù���������ʵ���������е� TCustomIniFile ������й�����չ
       ��������з�����ת��ԭ INI ������ִ��
     |<PRE>
       AIni: TCustomIniFile    - ����װ�� INI ����
       AOwned: Boolean         - �ڸö����ͷ�ʱ�Ƿ�ͬʱ�ͷű���װ�� INI ����
     |</PRE>}
    constructor Create(const FileName: string; MemIniFile: Boolean = True); overload;
    {* ��ͨ INI �ļ���������ʹ�øù���������ʵ������ʵ������ͨ�� INI ����ʹ�á�
     |<PRE>
       FileName: string        - INI �ļ���
       MemIniFile: Boolean     - �Ƿ�ʹ���ڴ滺�巽ʽ���� INI�����ڲ�ʹ�� TMemIniFile ����
     |</PRE>}
    destructor Destroy; override;
    
    function ReadInteger(const Section, Ident: string; Default: Longint): Longint; override;
    procedure WriteInteger(const Section, Ident: string; Value: Longint); override;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; override;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); override;
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; override;
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; override;
    function ReadFloat(const Section, Name: string; Default: Double): Double; override;
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; override;
    procedure WriteDate(const Section, Name: string; Value: TDateTime); override;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); override;
    procedure WriteFloat(const Section, Name: string; Value: Double); override;
    procedure WriteTime(const Section, Name: string; Value: TDateTime); override;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    procedure EraseSection(const Section: string); override;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure UpdateFile; override;
    
    function ReadColor(const Section, Ident: string; Default: TColor): TColor;
    {* ��ȡ��ɫ}
    procedure WriteColor(const Section, Ident: string; Value: TColor);
    {* д����ɫ}
    function ReadFont(const Section, Ident: string; Font: TFont): TFont;
    {* ��ȡ����}
    procedure WriteFont(const Section, Ident: string; Font: TFont);
    {* д������}
    function ReadRect(const Section, Ident: string; const Default: TRect): TRect;
    {* ��ȡ Rect}
    procedure WriteRect(const Section, Ident: string; const Value: TRect);
    {* д�� Rect}
    function ReadPoint(const Section, Ident: string; const Default: TPoint): TPoint;
    {* ��ȡ Point}
    procedure WritePoint(const Section, Ident: string; const Value: TPoint);
    {* д�� Point}
    function ReadStrings(const Section, Ident: string; Strings: TStrings): TStrings; overload;
    {* ��һ���ı��ж�ȡ�ַ����б�}
    function ReadStrings(const Section: string; Strings: TStrings): TStrings; overload;
    {* �ӵ����Ľ��ж�ȡ�ַ����б�}
    procedure WriteStrings(const Section, Ident: string; Strings: TStrings); overload;
    {* д���ַ����б�һ���ı���}
    procedure WriteStrings(const Section: string; Strings: TStrings); overload;
    {* д���ַ����б������Ľ���}
    property FileName: string read GetFileName;
    {* INI �ļ���}
  end;

//==============================================================================
// ֧���������� IniFile ��
//==============================================================================
   
{ TCnStreamIniFile }

  TCnStreamIniFile = class (TMemIniFile)
  {* ֧���������� IniFile �࣬�ṩ�� LoadFromStream��SaveToStream ��������ж�ȡ
     Ini ���ݡ� }
  private
    FFileName: string;
  protected

  public
    constructor Create(const FileName: string = '');
    {* �๹����������Ϊ INI �ļ�����������ļ���������Զ�װ���ļ� }
    destructor Destroy; override;
    {* �������� }
    function LoadFromFile(const FileName: string): Boolean;
    {* ���ļ���װ�� INI ���� }
    function LoadFromStream(Stream: TStream): Boolean; virtual;
    {* ������װ�� INI ���� }
    function SaveToFile(const FileName: string): Boolean;
    {* ���� INI ���ݵ��ļ� } 
    function SaveToStream(Stream: TStream): Boolean; virtual;
    {* ���� INI ���ݵ��� }
    procedure UpdateFile; override;
    {* ���µ�ǰ INI ���ݵ��ļ� }

    property FileName: string read FFileName;
    {* ��������ʱ���ݵ��ļ�����ֻ������ }
  end;

//==============================================================================
// ֧������ Xor ���ܼ��������� IniFile ��
//==============================================================================

{ TCnXorIniFile }

  TCnXorIniFile = class (TCnStreamIniFile)
  {* ֧������ Xor ���ܼ��������� IniFile �࣬����� INI ���ݽ��� Xor ���ܡ� }
  private
    FXorStr: string;
  protected

  public
    constructor Create(const FileName: string; const XorStr: string);
    {* �๹������
     |<PRE>
       FileName: string     - INI �ļ���������ļ����ڽ��Զ�����
       XorStr: string       - ���� Xor �������ַ���
     |</PRE>}
    function LoadFromStream(Stream: TStream): Boolean; override;
    {* ������װ�� INI ���ݣ����е����ݽ��� Xor ���� }
    function SaveToStream(Stream: TStream): Boolean; override;
    {* ���� INI ���ݵ��������е����ݽ��� Xor ���� }
  end;

implementation

uses
  CnCommon;

//==============================================================================
// ��չ�� INI ������
//==============================================================================
   
{ TCnIniFile }

constructor TCnIniFile.Create(AIni: TCustomIniFile; AOwned: Boolean);
begin
  inherited Create('');
  Assert(Assigned(AIni));
  FIni := AIni;
  FOwned := AOwned;
end;

constructor TCnIniFile.Create(const FileName: string; MemIniFile: Boolean);
begin
  if MemIniFile then
    Create(TMemIniFile.Create(FileName), True)
  else
    Create(TIniFile.Create(FileName), True);
end;

destructor TCnIniFile.Destroy;
begin
  if FOwned then
    FreeAndNil(FIni);
  inherited;
end;

//------------------------------------------------------------------------------
// ��չ�� INI ���ʷ���
//------------------------------------------------------------------------------
   
function TCnIniFile.ReadColor(const Section, Ident: string;
  Default: TColor): TColor;
begin
  try
    Result := StringToColor(ReadString(Section, Ident,
      ColorToString(Default)));
  except
    Result := Default;
  end;
end;

procedure TCnIniFile.WriteColor(const Section, Ident: string; Value: TColor);
begin
  WriteString(Section, Ident, ColorToString(Value));
end;

function TCnIniFile.ReadRect(const Section, Ident: string; const Default: TRect): TRect;
begin
  Result := StrToRect(ReadString(Section, Ident, RectToStr(Default)), Default);
end;

procedure TCnIniFile.WriteRect(const Section, Ident: string; const Value: TRect);
begin
  WriteString(Section, Ident, RectToStr(Value));
end;

function TCnIniFile.ReadPoint(const Section, Ident: string; const Default: TPoint): TPoint;
begin
  Result := StrToPoint(ReadString(Section, Ident, PointToStr(Default)), Default);
end;

procedure TCnIniFile.WritePoint(const Section, Ident: string; const Value: TPoint);
begin
  WriteString(Section, Ident, PointToStr(Value));
end;

function TCnIniFile.ReadFont(const Section, Ident: string; Font: TFont): TFont;
begin
  Result := Font;
  try
    StringToFont(ReadString(Section, Ident, FontToString(Font)), Result);
  except
    { do nothing, ignore any exceptions }
  end;
end;

procedure TCnIniFile.WriteFont(const Section, Ident: string; Font: TFont);
begin
  WriteString(Section, Ident, FontToString(Font));
end;

function TCnIniFile.ReadStrings(const Section, Ident: string;
  Strings: TStrings): TStrings;
begin
  Result := Strings;
  Strings.Text := StrToLines(ReadString(Section, Ident, LinesToStr(Strings.Text)));
end;

function TCnIniFile.ReadStrings(const Section: string; Strings: TStrings): TStrings;
begin
  Result := Strings;
  if SectionExists(Section) then
    ReadStringsFromIni(Self, Section, Result);
end;

procedure TCnIniFile.WriteStrings(const Section, Ident: string; Strings: TStrings);
begin
  WriteString(Section, Ident, LinesToStr(Strings.Text));
end;

procedure TCnIniFile.WriteStrings(const Section: string; Strings: TStrings);
begin
  WriteStringsToIni(Self, Section, Strings);
end;

//------------------------------------------------------------------------------
// ���ñ���װ�� INI ���ʷ���
//------------------------------------------------------------------------------

procedure TCnIniFile.DeleteKey(const Section, Ident: String);
begin
  Ini.DeleteKey(Section, Ident);
end;

procedure TCnIniFile.EraseSection(const Section: string);
begin
  Ini.EraseSection(Section);
end;

function TCnIniFile.GetFileName: string;
begin
  Result := Ini.FileName;
end;

procedure TCnIniFile.ReadSection(const Section: string; Strings: TStrings);
begin
  Ini.ReadSection(Section, Strings);
end;

procedure TCnIniFile.ReadSections(Strings: TStrings);
begin
  Ini.ReadSections(Strings);
end;

procedure TCnIniFile.ReadSectionValues(const Section: string;
  Strings: TStrings);
begin
  Ini.ReadSectionValues(Section, Strings);
end;

function TCnIniFile.ReadString(const Section, Ident,
  Default: string): string;
begin
  Result := Ini.ReadString(Section, Ident, Default);
end;

procedure TCnIniFile.UpdateFile;
begin
  Ini.UpdateFile;
end;

procedure TCnIniFile.WriteString(const Section, Ident, Value: String);
begin
  Ini.WriteString(Section, Ident, Value);
end;

function TCnIniFile.ReadBool(const Section, Ident: string;
  Default: Boolean): Boolean;
begin
  Result := Ini.ReadBool(Section, Ident, Default);
end;

function TCnIniFile.ReadDate(const Section, Name: string;
  Default: TDateTime): TDateTime;
begin
  Result := Ini.ReadDate(Section, Name, Default);
end;

function TCnIniFile.ReadDateTime(const Section, Name: string;
  Default: TDateTime): TDateTime;
begin
  Result := Ini.ReadDateTime(Section, Name, Default);
end;

function TCnIniFile.ReadFloat(const Section, Name: string;
  Default: Double): Double;
begin
  Result := Ini.ReadFloat(Section, Name, Default);
end;

function TCnIniFile.ReadInteger(const Section, Ident: string;
  Default: Integer): Longint;
begin
  Result := Ini.ReadInteger(Section, Ident, Default);
end;

function TCnIniFile.ReadTime(const Section, Name: string;
  Default: TDateTime): TDateTime;
begin
  Result := Ini.ReadTime(Section, Name, Default);
end;

procedure TCnIniFile.WriteBool(const Section, Ident: string;
  Value: Boolean);
begin
  Ini.WriteBool(Section, Ident, Value);
end;

procedure TCnIniFile.WriteDate(const Section, Name: string;
  Value: TDateTime);
begin
  Ini.WriteDate(Section, Name, Value);
end;

procedure TCnIniFile.WriteDateTime(const Section, Name: string;
  Value: TDateTime);
begin
  Ini.WriteDateTime(Section, Name, Value);
end;

procedure TCnIniFile.WriteFloat(const Section, Name: string;
  Value: Double);
begin
  Ini.WriteFloat(Section, Name, Value);
end;

procedure TCnIniFile.WriteInteger(const Section, Ident: string;
  Value: Integer);
begin
  Ini.WriteInteger(Section, Ident, Value);
end;

procedure TCnIniFile.WriteTime(const Section, Name: string;
  Value: TDateTime);
begin
  Ini.WriteTime(Section, Name, Value);
end;

//==============================================================================
// ֧���������� IniFile ��
//==============================================================================

{ TCnStreamIniFile }

constructor TCnStreamIniFile.Create(const FileName: string);
begin
  inherited Create('');
  FFileName := FileName;
  if FileExists(FFileName) then
    LoadFromFile(FFileName);
end;

destructor TCnStreamIniFile.Destroy;
begin
  UpdateFile;
  inherited;
end;

function TCnStreamIniFile.LoadFromFile(const FileName: string): Boolean;
var
  Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;

function TCnStreamIniFile.LoadFromStream(Stream: TStream): Boolean;
var
  Strings: TStrings;
begin
  try
    Strings := TStringList.Create;
    try
      Strings.LoadFromStream(Stream);
      SetStrings(Strings);
    finally
      Strings.Free;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

function TCnStreamIniFile.SaveToFile(const FileName: string): Boolean;
var
  Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      Stream.Size := 0;
      Result := SaveToStream(Stream);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;

function TCnStreamIniFile.SaveToStream(Stream: TStream): Boolean;
var
  Strings: TStrings;
begin
  try
    Strings := TStringList.Create;
    try
      GetStrings(Strings);
      Strings.SaveToStream(Stream);
    finally
      Strings.Free;
    end;
    Result := True;
  except
    Result := False;
  end;
end;

procedure TCnStreamIniFile.UpdateFile;
begin
  if FileExists(FFileName) then
    SaveToFile(FFileName);
end;

//==============================================================================
// ֧���ı� Xor ���ܼ��������� IniFile ��
//==============================================================================

{ TCnXorIniFile }

constructor TCnXorIniFile.Create(const FileName, XorStr: string);
begin
  inherited Create(FileName);
  FXorStr := XorStr;
end;

function TCnXorIniFile.LoadFromStream(Stream: TStream): Boolean;
var
  XorStream: TCnXorStream;
begin
  XorStream := TCnXorStream.Create(Stream, FXorStr);
  try
    Result := inherited LoadFromStream(XorStream);
  finally
    XorStream.Free;
  end;
end;

function TCnXorIniFile.SaveToStream(Stream: TStream): Boolean;
var
  XorStream: TCnXorStream;
begin
  XorStream := TCnXorStream.Create(Stream, FXorStr);
  try
    Result := inherited SaveToStream(XorStream);
  finally
    XorStream.Free;
  end;
end;

end.
