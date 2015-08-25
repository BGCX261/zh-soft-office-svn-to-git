unit ZhVersionImpl;

interface

uses
  Windows, Classes, SysUtils;

type
  { define a generic exception class for version info, and an exception
    to indicate that no version info is available. }
  EVersionError = class(Exception);
  EVerInfoError = class(EVersionError);
  ENoVerInfoError = class(EVersionError);
  ENoFixedVerInfo = class(EVersionError);

  // define enum type representing different types of version info
  TVerInfoType = (
    viCompanyName,
    viFileDescription,
    viFileVersion,
    viInternalName,
    viLegalCopyright,
    viLegalTrademarks,
    viOriginalFileName,
    viProductName,
    viProductVersion,
    viComments);

const
  // define an array constant of strings representing the pre-defined
  // version information keys.
  VerNameArray: array[viCompanyName..viComments] of string[20] = (
    'CompanyName',
    'FileDescription',
    'FileVersion',
    'InternalName',
    'LegalCopyright',
    'LegalTrademarks',
    'OriginalFileName',
    'ProductName',
    'ProductVersion',
    'Comments');

type
  // Define the version info class
  TVerInfoRes = class
  private
    Handle: DWORD;
    Size: Integer;
    RezBuffer: string;
    TransTable: PLongint;
    FixedFileInfoBuf: PVSFixedFileInfo;
    FFileFlags: TStringList;
    FFileName: string;
    procedure FillFixedFileInfoBuf;
    procedure FillFileVersionInfo;
    procedure FillFileMaskInfo;
  protected
    function GetFileVersion: string;
    function GetProductVersion: string;
    function GetFileDescription: string;
    function GetFileOS: string;
  public
    constructor Create(AFileName: string);
    destructor Destroy; override;
    function GetPreDefKeyString(AVerKind: TVerInfoType): string;
    function GetUserDefKeyString(AKey: string): string;
    property FileVersion: string read GetFileVersion;
    property FileDescription: string read GetFileDescription;
    property ProductVersion: string read GetProductVersion;
    property FileFlags: TStringList read FFileFlags;
    property FileOS: string read GetFileOS;
  end;

  // 获取文件版本号
  function GetFileVersion(FileName: string): string;
  // 获取文件描述信息
  function GetFileDescription(FileName: string): string;

implementation

const
  // strings that must be fed to VerQueryValue() function
  SFInfo  = '\StringFileInfo\';
  VerTranslation: PChar = '\VarFileInfo\Translation';
  FormatStr = '%s%.4x%.4x\%s%s';

function VersionString(Ms, Ls: LongInt): string;
begin
  Result:= Format('%d.%d.%d.%d', [HIWORD(Ms), LOWORD(Ms), HIWORD(Ls), LOWORD(Ls)]);
end;

function GetFileVersion(FileName: string): string;
begin
  try
    with TVerInfoRes.Create(FileName) do
    begin
      Result:= FileVersion;
    end;
  except
    on E: EVersionError do
      Result:= '0';
    {
    on E: EVerInfoError do
      Result:= '0.0.0.0';
    on E: ENoVerInfoError do
      Result:= '0.0.0.0';
    on E: ENoFixedVerInfo do
      Result:= '0.0.0.0';
    }
  end;
end;

function GetFileDescription(FileName: string): string;
begin
  try
    with TVerInfoRes.Create(FileName) do
    begin
      Result:= FileDescription;
    end;
  except
    on E: EVersionError do
      Result:= '';
  end;
end;

{ TVerInfoRes }

constructor TVerInfoRes.Create(AFileName: string);
begin
  FFileName:= AFileName;
  FFileFlags:= TStringList.Create;
  // Get the file version information
  FillFileVersionInfo;
  // Get the fixed file info
  FillFixedFileInfoBuf;
  // Get the file mask values
  FillFileMaskInfo;
end;

destructor TVerInfoRes.Destroy;
begin
  FFileFlags.Free;
  inherited;
end;

procedure TVerInfoRes.FillFileVersionInfo;
var
  SBSize: UInt;
begin
  // Determine size of version information
  Size:= GetFileVersionInfoSize(PChar(FFileName), Handle);
  if Size <= 0 then
    raise ENoVerInfoError.Create('No Version Info Available');
  // Set the length accordingly
  SetLength(RezBuffer, Size);
  // Fill the buffer with version information, raise exception on error
  if not GetFileVersionInfo(PChar(FFileName), Handle, Size, PChar(RezBuffer)) then
    raise EVerInfoError.Create('Cannot obtain version info');
  // Get translation info, raise exception on error
  if not VerQueryValue(PChar(RezBuffer), VerTranslation, pointer(TransTable), SBSize) then
    raise EVerInfoError.Create('No language info.');
end;

procedure TVerInfoRes.FillFileMaskInfo;
begin
  with FixedFileInfoBuf^ do
  begin
    if (dwFileFlagsMask and dwFileFlags and VS_FF_PRERELEASE) <> 0 then
      FFileFlags.Add('Pre-release');
    if (dwFileFlagsMask and dwFileFlags and VS_FF_PRIVATEBUILD) <> 0 then
      FFileFlags.Add('Private build');
    if (dwFileFlagsMask and dwFileFlags and VS_FF_SPECIALBUILD) <> 0 then
      FFileFlags.Add('Special build');
    if (dwFileFlagsMask and dwFileFlags and VS_FF_DEBUG) <> 0 then
      FFileFlags.Add('Debug');
  end;
end;

procedure TVerInfoRes.FillFixedFileInfoBuf;
var
  Size: Cardinal;
begin
  if VerQueryValue(PChar(RezBuffer), '\', pointer(FixedFileInfoBuf), Size) then
  begin
    if Size < sizeof(TVSFixedFileInfo) then
      raise ENoFixedVerInfo.Create('No fixed file info');
  end
  else
    raise ENoFixedVerInfo.Create('No fixed file info');
end;

function TVerInfoRes.GetFileOS: string;
begin
  with FixedFileInfoBuf^ do
    case dwFileOS of
      VOS_UNKNOWN: // Same as VOS_BASE
        Result:= 'Unknown';
      VOS_DOS:
        Result:= 'Designed for MS-DOS';
      VOS_OS216:
        Result:= 'Designed for 16-it OS/2';
      VOS_OS232:
        Result:= 'Desinged for 32-bit OS/2';
      VOS_NT:
        Result:= 'Desgined for Windows/NT';
      VOS__WINDOWS16:
        Result:= 'Designed for 16-bit Windows';
      VOS__PM16:
        Result:= 'Desgined for 16-bit PM';
      VOS__PM32:
        Result:= 'Desgined for 32-bit PM';
      VOS__WINDOWS32:
        Result:= 'Desgined for 32-bit Windows';
      VOS_DOS_WINDOWS16:
        Result:= 'Desgined for 16-bit Windows, running on MS-DOS';
      VOS_DOS_WINDOWS32:
        Result:= 'Desgined for Win32 API, running on MS-DOS';
      VOS_OS216_PM16:
        Result:= 'Desgined for 16-bit PM, running on 16-bit OS/2';
      VOS_OS232_PM32:
        Result:= 'Desgined for 32-bit PM, running on 32-bit OS/2';
      VOS_NT_WINDOWS32:
        Result:= 'Desgined for Win32API, running on Windows/NT';
    else
      Result:= 'Unknown';
    end;
end;

function TVerInfoRes.GetFileVersion: string;
begin
  with FixedFileInfoBuf^ do
    Result:= VersionString(dwFileVersionMS, dwFileVersionLS);
end;

function TVerInfoRes.GetPreDefKeyString(AVerKind: TVerInfoType): string;
var
  P: PChar;
  S: UInt;
begin
  Result:= Format(FormatStr, [SfInfo, LoWord(TransTable^), HiWord(TransTable^),
    VerNameArray[AVerKind], #0]);
  // get and return version query info, return empty string on error
  if VerQueryValue(PChar(RezBuffer), @Result[1], Pointer(P), S) then
    Result:= StrPas(P)
  else
    Result:= '';
end;

function TVerInfoRes.GetProductVersion: string;
begin
  with FixedFileInfoBuf^ do
    Result:= VersionString(dwProductVersionMS, dwProductVersionLS);
end;

function TVerInfoRes.GetUserDefKeyString(AKey: string): string;
var
  P: PChar;
  S: UInt;
begin
  Result:= Format(FormatStr, [SfInfo, LoWord(TransTable^), HiWord(TransTable^),
    AKey, #0]);
  // get and return version query info, return empty string on error
  if VerQueryValue(PChar(RezBuffer), @Result[1], Pointer(P), S) then
    Result:= StrPas(P)
  else
    Result:= '';
end;

function TVerInfoRes.GetFileDescription: string;
begin
  Result:= GetPreDefKeyString(viFileDescription);
end;

end.