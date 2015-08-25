{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2006 CnPack 开发组                       }
{                   ------------------------------------                       }
{                                                                              }
{            本开发包是开源的自由软件，您可以遵照 CnPack 的发布协议来修        }
{        改和重新发布这一程序。                                                }
{                                                                              }
{            发布这一开发包的目的是希望它有用，但没有任何担保。甚至没有        }
{        适合特定目的而隐含的担保。更详细的情况请参阅 CnPack 发布协议。        }
{                                                                              }
{            您应该已经和开发包一起收到一份 CnPack 发布协议的副本。如果        }
{        还没有，可访问我们的网站：                                            }
{                                                                              }
{            网站地址：http://www.cnpack.org                                   }
{            电子邮件：master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit ZhIni;
{* |<PRE>
================================================================================
* 软件名称：开发包基础库
* 单元名称：扩展的INI访问单元
* 单元作者：周劲羽 (zjy@cnpack.org)
* 备    注：该单元编写时参考了 RxLib 2.75 中的 RxIni.pas
* 开发平台：PWin2000Pro + Delphi 5.0
* 兼容测试：PWin9X/2000/XP + Delphi 5/6
* 本 地 化：该单元中的字符串均符合本地化处理方式
* 单元标识：$Id: CnIni.pas,v 1.3 2006/01/13 12:41:33 passion Exp $
* 修改记录：2002.10.20 V1.0
*               创建单元
================================================================================
|</PRE>}

interface

//{$I CnPack.inc}

uses
  Windows, Classes, SysUtils, Forms, IniFiles, Graphics, ZhIniStrUtils, ZhStream;

type

//==============================================================================
// 扩展的 INI 访问类
//==============================================================================
   
{ TCnIniFile }

  TCnIniFile = class(TCustomIniFile)
  {* 扩展的 INI 访问类，使用 Wrap 模式对 TCustomIniFile 进行扩展。定义两个构造器
     既可当普通的文件型 INI 类操作，又可仅仅作为其它 TCustomIniFile 对象的包装外
     壳进行扩展的操作。}
  private
    FIni: TCustomIniFile;
    FOwned: Boolean;
    function GetFileName: string;
  protected
    property Owned: Boolean read FOwned;
    property Ini: TCustomIniFile read FIni;
  public
    constructor Create(AIni: TCustomIniFile; AOwned: Boolean = False); overload;
    {* 包装构造器，使用该构造器创建实例，对已有的 TCustomIniFile 对象进行功能扩展
       对象的所有方法都转到原 INI 对象中执行
     |<PRE>
       AIni: TCustomIniFile    - 被包装的 INI 对象
       AOwned: Boolean         - 在该对象释放时是否同时释放被包装的 INI 对象
     |</PRE>}
    constructor Create(const FileName: string; MemIniFile: Boolean = True); overload;
    {* 普通 INI 文件构造器，使用该构造器创建实例，将实例当普通的 INI 对象使用。
     |<PRE>
       FileName: string        - INI 文件名
       MemIniFile: Boolean     - 是否使用内存缓冲方式操作 INI，即内部使用 TMemIniFile 对象。
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
    {* 读取颜色}
    procedure WriteColor(const Section, Ident: string; Value: TColor);
    {* 写入颜色}
    function ReadFont(const Section, Ident: string; Font: TFont): TFont;
    {* 读取字体}
    procedure WriteFont(const Section, Ident: string; Font: TFont);
    {* 写入字体}
    function ReadRect(const Section, Ident: string; const Default: TRect): TRect;
    {* 读取 Rect}
    procedure WriteRect(const Section, Ident: string; const Value: TRect);
    {* 写入 Rect}
    function ReadPoint(const Section, Ident: string; const Default: TPoint): TPoint;
    {* 读取 Point}
    procedure WritePoint(const Section, Ident: string; const Value: TPoint);
    {* 写入 Point}
    function ReadStrings(const Section, Ident: string; Strings: TStrings): TStrings; overload;
    {* 从一行文本中读取字符串列表}
    function ReadStrings(const Section: string; Strings: TStrings): TStrings; overload;
    {* 从单独的节中读取字符串列表}
    procedure WriteStrings(const Section, Ident: string; Strings: TStrings); overload;
    {* 写入字符串列表到一行文本中}
    procedure WriteStrings(const Section: string; Strings: TStrings); overload;
    {* 写入字符串列表到单独的节中}
    property FileName: string read GetFileName;
    {* INI 文件名}
  end;

//==============================================================================
// 支持流操作的 IniFile 类
//==============================================================================
   
{ TCnStreamIniFile }

  TCnStreamIniFile = class (TMemIniFile)
  {* 支持流操作的 IniFile 类，提供了 LoadFromStream、SaveToStream 允许从流中读取
     Ini 数据。 }
  private
    FFileName: string;
  protected

  public
    constructor Create(const FileName: string = '');
    {* 类构造器，参数为 INI 文件名，如果该文件存在则会自动装载文件 }
    destructor Destroy; override;
    {* 类析构器 }
    function LoadFromFile(const FileName: string): Boolean;
    {* 从文件中装载 INI 数据 }
    function LoadFromStream(Stream: TStream): Boolean; virtual;
    {* 从流中装载 INI 数据 }
    function SaveToFile(const FileName: string): Boolean;
    {* 保存 INI 数据到文件 } 
    function SaveToStream(Stream: TStream): Boolean; virtual;
    {* 保存 INI 数据到流 }
    procedure UpdateFile; override;
    {* 更新当前 INI 数据到文件 }

    property FileName: string read FFileName;
    {* 创建对象时传递的文件名，只读属性 }
  end;

//==============================================================================
// 支持内容 Xor 加密及流操作的 IniFile 类
//==============================================================================

{ TCnXorIniFile }

  TCnXorIniFile = class (TCnStreamIniFile)
  {* 支持内容 Xor 加密及流操作的 IniFile 类，允许对 INI 数据进行 Xor 加密。 }
  private
    FXorStr: string;
  protected

  public
    constructor Create(const FileName: string; const XorStr: string);
    {* 类构造器。
     |<PRE>
       FileName: string     - INI 文件名，如果文件存在将自动加载
       XorStr: string       - 用于 Xor 操作的字符串
     |</PRE>}
    function LoadFromStream(Stream: TStream): Boolean; override;
    {* 从流中装载 INI 数据，流中的数据将用 Xor 解密 }
    function SaveToStream(Stream: TStream): Boolean; override;
    {* 保存 INI 数据到流，流中的数据将用 Xor 加密 }
  end;

implementation

uses
  CnCommon;

//==============================================================================
// 扩展的 INI 访问类
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
// 扩展的 INI 访问方法
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
// 调用被包装的 INI 访问方法
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
// 支持流操作的 IniFile 类
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
// 支持文本 Xor 加密及流操作的 IniFile 类
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
