

unit ZhCustomUtils;

interface

uses

  Windows, Messages, Classes, Graphics, Controls, Forms, SysUtils,
  ExtCtrls, Dialogs, Buttons, Registry, FileCtrl, ShlObj, ShellAPI,
  jpeg, ActiveX, ComObj, MMSystem, MPlayer, StdCtrls, LZExpand;

//_____________________________________________________________________//
//                                                                     //
//                       Moudle index                                  //
//_____________________________________________________________________//

{

1. CustomCursor ................. �Զ�����
2. ReadRegKey ................... ��ע����ֵ
3. WriteRegKey .................. дע����ֵ
4. GetExePath ................... ȡӦ�ó���·��
5. GetParameter ................. ȡ�����ļ�����
6. RebootExpires ................ ����������ʧЧ
7. RebootRestore ................ �ָ�������������
8. CloseExpires ................. ʹ���ڹرչ���ʧЧ
9. CloseRestore ................. �ָ����ڹرչ���
10. HideDesktop ................. ��������ͼ��
11. ShowDesktop ................. ��ʾ����ͼ��
12. ChangeWallPaper ............. ����ǽֽ
13. myGetWindowsDirectory ....... ȡWindowsĿ¼
14. myGetSystemDirectory ........ ȡϵͳĿ¼
15. myGetTempPath ............... ȡ��ʱ·��
16. myGetLogicalDrives .......... ȡ�߼�������
17. myGetUserName ............... ȡ�û���
18. myGetComputerName ........... ȡ�������
19. mySelectDirectory ........... ѡ��Ŀ¼
20. myClearDocument ............. �����ʼ�˵��ҵ��ĵ�����
21. SystemAbout ................. ����ϵͳ���ڶԻ���
22. SelectDir ................... ѡ��Ŀ¼
23. HideFormOnTask .............. �������������ش���
24. ConvertBMPtoJPG ............. ת��BMP��ʽΪJPG
25. ConvertJPGtoBMP ............. ת��JPG��ʽΪBMP
26. Replacing ................... �滻ĳһ�ַ���
27. SmallTOBig .................. ת������Ϊ��д����(1 - Ҽ)
28. CreateShortCut .............. ������ݷ�ʽ
29. myAddDocument ............... �����ļ�������򿪹����ĵ�
30. GetFileIcon ................. ȡ���ļ�ͼ��
31. GetCDROMNumber .............. ȡCDROM���к�
32. SetCDAutoRun ................ ���ù����Ƿ��Զ�����
33. OpenCDROM ................... �򿪹���
34. CloseCDROM .................. �رչ���
35. GetDiskSizeAvail ............ ȡ���������ֽ�����ʣ���ֽ���
36. GetDiskSize ................. ȡ���������ֽ�����ʣ���ֽ���
37. SystemBarCall ............... ϵͳ������幦�ܵ���
38. GetUserNameAPI .............. ȡ�û���(API��ʽ)
39. GetWindowsProductID ......... ȡWINDOWS��ƷID
40. HideTaskbar ................. ����������
41. ShowTaskbar ................. ��ʾ������
42. MakeTree .................... ��ȡĿ¼��
43. CreateDsn ................... ����DSN
44. CnToPY ...................... ת������Ϊƴ������ĸ
45. AddIcoToIE .................. ����Ӧ�ó���ͼ�굽IE
46. SetVolume ................... ���ô��̾��
47. FormatFloppy ................ ��ʽ������
48. IsAudioCD ................... �жϹ������Ƿ�ΪCD��
49. PlayAudioCD ................. ����CD��
50. DiskInDrive ................. �ж��������Ƿ����
51. CheckDriverType ............. �������������
52. IsFileInUse ................. �ж��ļ��Ƿ���ʹ��
53. CopyDir ..................... ����Ŀ¼������Ŀ¼
54. DeleteDir (No use) .......... ɾ��Ŀ¼������Ŀ¼
55. CreateTempFile .............. ������ʱ�ļ�
56. SearchFile .................. Ѱ���ļ�
57. GetProgramAssociation ....... ȡ��Ӧ�ó�����չ
58. myGetFileTime ............... ȡ�ļ�����ʱ��
59. SetFileDateTime ............. �����ļ�ʱ��
60. GetFileLastAccessTime ....... ȡ�ļ�������ʱ��
61. CreateDirectory ............. ����Ŀ¼
62. ChangeDirectory ............. �ı�Ŀ¼
63. GetDirectory ................ �õ�Ŀ¼
64. SetCurrentDirectory ......... ���õ�ǰĿ¼
65. RenameDirOrFile ............. ����Ŀ¼���ļ���
66. CreateMultiDir .............. �����༶Ŀ¼
67. DirExist .................... �ж�Ŀ¼�Ƿ����
68. ChangeFileExtension ......... �����ļ���չ��
69. GetFileExtension ............ ȡ�ļ���չ��
70. FileCopy1 ................... �ļ�����
71. FileCopy2 ................... �ļ�����
72. FileCopy3 ................... �ļ�����
73. SetFileAttribAPI ............ �����ļ�����(API��ʽ)
74. SetFileAttrib ............... �����ļ�����
75. GetFilePath1 ................ ȡ���ļ�·��(��'\'��β)
76. GetFilePath2 ................ ȡ���ļ�·��(û��'\'��β)
77. CopyDelRenMovFile ........... ������ɾ�����������ƶ��ļ�
78. GetPortUsed ................. �õ��ѱ�ʹ�ô����б�
79. SetMediaAudioOff ............ ��������ý���ļ�
80. SetMediaAudioOn ............. ��ý�岥���ļ�����
81. WaitExeFinish ............... �ȴ�ֱ����ִ���ļ�ִ�����
}

//_____________________________________________________________________//
//                                                                     //
//                 Declare function and procedure                      //
//_____________________________________________________________________//

//-------------------------------//
//1. Custom application cursors
//-------------------------------//
{
  Function:
    The procedure will use custom cursors replace default cursors
  Parameter:
    objControl: Object name
    iPosition: The cursors position which want to change
    iMode: Object type
    sFilePath: New cursors file path will be loading
  Return value:
    None
  Example:
    CustomCursor(frmMain, 1, 1, 'C:\test1.ico');
    CustomCursor(imgPhoto, 2, 1, 'C:\test2.ico');
    CustomCursor(pnlRecord, 3, 1, 'C:\test3.ico');
}
procedure CustomCursor(const objControl: TObject;const iPosition,
  iMode: integer;const sFilePath: string);

//-------------------------------//
//2. Read key from register
//-------------------------------//
{
  Function:
    The procedure's function is read register key value
  Parameter:
    iMode: Read value type
    sPath: Key path
    sKeyName: Key name
  Return value:
    The key value
  Example:
    ReadRegKey(1, '\Software\Microsoft\Windows\', 'Text');
    ReadRegKey(2, '\Software\Microsoft\Windows\', 'Numeric');
}
function ReadRegKey(const iMode: integer; const sPath,
  sKeyName: string): string;

//-------------------------------//
//3. Write key to regisiter
//-------------------------------//
{
  Function:
    Use the function to write the key and value into registry
  Parameter:
    iMode: Write value type
    sPath: Key path
    sKeyName: Key name
    sKeyValue: Key value which will been written
  Return value:
    Write result if success
  Example:
    WriteRegKey(1, '\Software\Microsoft\Windows\', 'Text', 'It's a test.');
    WriteRegKey(2, '\Software\Microsoft\Windows\', 'Numeric', '1');
}
function WriteRegKey(const iMode: integer; const sPath, sKeyName,
  sKeyValue: string): Boolean;

//-------------------------------//
//4. Get execute file path
//-------------------------------//
{
  Function:
    Obtain main execute file path
  Parameter:
    Null
  Return value:
    Execute file path
  Example:
    GetExePath();
}
function GetExePath(): string;

//-------------------------------//
//5. Get configure file parameter
//-------------------------------//
{
  Function:
    Get execute file configure parameter
  Parameter:
    FileName: Configure file name
  Return value:
    Configure parameter value
  Example:
    GetParameter('C:\Configure.ini');
}
function GetParameter(const FileName: string): WideString;

//-------------------------------//
//6. Set reboot expires(Alt+Ctrl+Del)
//-------------------------------//
{
  Function:
    Set computer reboot key expires
  Parameter:
    Null
  Return value:
    None
  Example:
    RebootExpires();
}
procedure RebootExpires();

//-------------------------------//
//7. Set reboot enabled restore(Alt+Ctrl+Del)
//-------------------------------//
{
  Function:
    Restore reboot enabled
  Parameter:
    Null
  Return value:
    None
  Example:
    RebootRestore();
}
procedure RebootRestore();

//-------------------------------//
//8. Set close form expires
//-------------------------------//
{
  Function:
    Set close form key expires
  Parameter:
    Null
  Return value:
    None
  Example:
    CloseExpires();
}
procedure CloseExpires();

//-------------------------------//
//9. Set close form enabled restore
//-------------------------------//
{
  Function:
    Restore close form enabled
  Parameter:
    Null
  Return value:
    None
  Example:
    CloseRestore();
}
procedure CloseRestore();

//-------------------------------//
//10. Hide desktop's icons
//-------------------------------//
{
  Function:
    All of icons on desktop will been hidden
  Parameter:
    Null
  Return value:
    None
  Example:
    HideDesktop();
}
procedure HideDesktop();

//-------------------------------//
//11. Show desktop's items
//-------------------------------//
{
  Function:
    All of desktop's icons will been shown
  Parameter:
    Null
  Return value:
    None
  Example:
    ShowDesktop();
}
procedure ShowDesktop();

//-------------------------------//
//12. Change desktop wall paper
//-------------------------------//
{
  Function:
    Set desktop wall paper use user refer to
  Parameter:
    sPath: Use this parameter to load a picture as wall paper
  Return value:
    false: Fail
    true: Success
  Example:
    ChangeWallPaper('C:\wallpaper.bmp');
}
function ChangeWallPaper(const sPath: string): Boolean;

//-------------------------------//
//13. Get windows directory
//-------------------------------//
{
  Function:
    Get windows directory
  Parameter:
    Null
  Return value:
    Windows directory like 'C:\WINNT' or 'C:\Windows' etc.
  Example:
    myGetWindowsDirectory();
}
function myGetWindowsDirectory(): string;

//-------------------------------//
//14. Get windows system directory
//-------------------------------//
{
  Function:
    Get windows system directory
  Parameter:
    Null
  Return value:
    Windows system directory as 'C:\Winnt\System32'
  Example:
    myGetSystemDirectory()
}
function myGetSystemDirectory(): string;

//-------------------------------//
//15. Get system temperory directory
//-------------------------------//
{
  Function:
    Get system temperory directory
  Parameter:
    Null
  Return value:
    Temperory path
  Example:
    myGetTempPath();
}
function myGetTempPath(): string;

//-------------------------------//
//16. Get logical drives
//-------------------------------//
{
  Function:
    Use the function to get logical drives
  Parameter:
    Null
  Return value:
    Drives value like 'ACD'
  Example:
    myGetLogicalDrives()
}
function myGetLogicalDrives(): string;

//-------------------------------//
//17. Get login user name
//-------------------------------//
{
  Function:
    Get login user name
  Parameter:
    Null
  Return value:
    User name which to login computer
  Example:
    myGetUserName()
}
function myGetUserName(): string;

//-------------------------------//
//18. Get computer name
//-------------------------------//
{
  Function:
    Get computer name
  Parameter:
    Null
  Return value:
    Computer name
  Example:
    myGetComputerName()
}
function myGetComputerName(): string;

//-------------------------------//
//19. Select directory
//-------------------------------//
{
  Function:
    Select directory where pointer to
  Parameter:
    sDescription: The text show for user
    sPath: Start position
  Return value:
    What directory to been selected
  Example:
    mySelectDirectory('Please select directory:', 'C:\');
}
function mySelectDirectory(const sDescription, sPath: string): string;

//-------------------------------//
//20. Clear document
//-------------------------------//
{
  Function:
    Clear document that recently access
  Parameter:
    Null
  Return value:
    None
  Example:
    myClearDocument()
}
procedure myClearDocument();

//-------------------------------//
//21. Call system about dialog
//-------------------------------//
{
  Function:
    Call system about dialog
  Parameter:
    sTitle: Infomation title
    sContent: Infomation content
  Return value:
    None
  Example:
    SystemAbout('POS system', 'Use the system for check out');
}
procedure SystemAbout(const sTitle, sContent: string);

//-------------------------------//
//22. Select directory or file
//-------------------------------//
{
  Function:
    Select directory or file
  Parameter:
    iMode: Meant select directory and file or only select directory
  Return value:
    Directory name or file name
  Example:
    SelectDir(1, 'Please select file:');
    SelectDir(2, 'Please select directory:');
}
function SelectDir(const iMode: integer; const sInfo: string): string;

//-------------------------------//
//23. Hide form on task
//-------------------------------//
{
  Function:
    Hide form on task
  Parameter:
    Null
  Return value:
    None
  Example:
    HideFormOnTask();
}
//Note: The procedure must been called when the main from create
procedure HideFormOnTask();

//-------------------------------//
//24. Convert BMP to JPG
//-------------------------------//
{
  Function:
    Convert BMP to JPG
  Parameter:
    sFileName: The bmp picture file what want to convert
    sToFileName: Converted file name and path
  Return value:
    None
  Example:
    ConvertBMPtoJPG('c:\a.bmp','d:\b');
}
procedure ConvertBMPtoJPG(const sFileName, sToFileName: string);

//-------------------------------//
//25. Convert JPG to BMP
//-------------------------------//
{
  Function:
    Convert JPG to BMP
  Parameter:
    sFileName: The jpg picture file what want to convert
    sToFileName: Converted file name and path
  Return value:
    None
  Example:
    ConvertJPGtoBMP('c:\a.jpg','d:\b');
}
procedure ConvertJPGtoBMP(const sFileName, sToFileName: string);

//-------------------------------//
//26. Replace string in source
//-------------------------------//
{
  Function:
    Replace string in source
  Parameter:
    S: String will been replaced
    source: Source sub-string
    target: Target sub-string
  Return value:
    Replaced result
  Example:
    Replacing(sTest, 'LiuJinXiong', 'Apollo');
}
function Replacing(S, source, target: string): string;

//-------------------------------//
//27. Change numeric to chinese string
//-------------------------------//
{
  Function:
    Change numeric to chinese string
  Parameter:
    small: Numeric what to be changed
    iPosition: Reserved long
  Return value:
    Result string
  Example:
    SmallTOBig(12345.78, -2);
}
function SmallTOBig(const small: real; const iPosition: integer): string;

//-------------------------------//
//28. Create short cut
//-------------------------------//
{
  Function:
    Create a short cut on desktop for program
  Parameter:
    sExePath: Files path and name
    sShortCutName: Short cut name
  Return value:
    None
  Example:
    CreateShortCut('D:\a.txt', '�����ļ�');
}
procedure CreateShortCut(const sPath: string; sShortCutName: WideString);

//-------------------------------//
//29. Add file to document
//-------------------------------//
{
  Function:
    Add file to document
  Parameter:
    sPath: File path and name
  Return value:
    None
  Example:
    myAddDocument('C:\test.doc');
}
procedure myAddDocument(const sPath: string);

//-------------------------------//
//30. Get files icon
//-------------------------------//
{
  Function:
    Get files icon
  Parameter:
    Filename: File path which icon will been gotten
    SmallIcon: If true will get 16*16 size icon, false will get 32*32 size icon
  Return value:
    Icon's handle
  Example:
    frmTest.Icon.Handle := GetFileIcon('d:\test.doc', true);
    image1.Picture.Icon.Handle := GetFileIcon('d:\test.doc', false);
}
function GetFileIcon(const Filename: string; SmallIcon: Boolean): HICON;

//-------------------------------//
//31.Get CDROM serial number
//-------------------------------//
{
  Function:
    Get CDROM serial number
  Parameter:
    Null
  Return value:
    CDROM serial number
  Example:
    GetCDROMNumber();
}
function GetCDROMNumber(): string;

//-------------------------------//
//32. Set CDROM auto run
//-------------------------------//
{
  Function:
    Set CDROM auto run
  Parameter:
    AAutoRun: if true CDROM will autorun, or not autorun
  Return value:
    None
  Example:
    SetCDAutoRun(true); //Autorun
    SetCDAutoRun(false); //No autorun
}
procedure SetCDAutoRun(AAutoRun: Boolean);

//-------------------------------//
//33. Open CDROM
//-------------------------------//
{
  Function:
    Open CDROM
  Parameter:
    Null
  Return value:
    None
  Example:
    OpenCDROM();
}
procedure OpenCDROM();

//-------------------------------//
//34. Close CDROM
//-------------------------------//
{
  Function:
    Close CDROM
  Parameter:
    Null
  Return value:
    None
  Example:
    CloseCDROM();
}
procedure CloseCDROM();

//-------------------------------//
//35. Get disk total bytes and total free
//-------------------------------//
{
  Function:
    Get disk total bytes and total free
  Parameter:
    TheDrive: What the disk  to be total
    TotalBytes: Total bytes
    TotalFree: Total free
  Return value:
    TotalBytes: Total bytes
    TotalFree: Total free
  Example:
    var
      TotalBytes: double;
      TotalFree: double;
    begin
      GetDiskSizeAvail('c:\', TotalBytes, TotalFree);
      ShowMessage(FloatToStr(TotalBytes));
      ShowMessage(FloatToStr(TotalFree));
}
//Note: Total bytes bigger than 2G
procedure GetDiskSizeAvail(TheDrive: PChar; var TotalBytes, TotalFree: double);

//-------------------------------//
//36. Close CDROM
//-------------------------------//
{
  Function:
    Close CDROM
  Parameter:
    Null
  Return value:
    None
  Example:
    CloseCDROM();
}
procedure GetDiskSize(const sDriver: string; var TotalBytes, TotalFree: double);

//-------------------------------//
//37. Close CDROM
//-------------------------------//
{
  Function:
    Close CDROM
  Parameter:
    Null
  Return value:
    None
  Example:
    CloseCDROM();
}
function SystemBarCall(const iNumber:integer):Boolean;

//-------------------------------//
//38. Get user name
//-------------------------------//
{
  Function:
    Get user name
  Parameter:
    Null
  Return value:
    User name
  Example:
    GetUserName();
}
function GetUserNameAPI(): AnsiString;

//-------------------------------//
//39. Get windows product ID
//-------------------------------//
{
  Function:
    Get windows product ID
  Parameter:
    Null
  Return value:
    Windows product ID
  Example:
    GetWindowsProductID();
}
function GetWindowsProductID(): string;

//-------------------------------//
//40. Hide task bar
//-------------------------------//
{
  Function:
    Hide task bar
  Parameter:
    Null
  Return value:
    None
  Example:
    HideTaskbar();
}
procedure HideTaskbar();

//-------------------------------//
//41. Show task bar
//-------------------------------//
{
  Function:
    Show task bar
  Parameter:
    Null
  Return value:
    None
  Example:
    ShowTaskbar();
}
procedure ShowTaskbar();

//-------------------------------//
//42. Make folder tree
//-------------------------------//
{
  Function:
    Make folder tree then add to list
  Parameter:
    iMode: Control type, 1 meant ListBox, 2 meant Memo
    objName: Object name
  Return value:
    None
  Example:
    Memo1.Clear;
    ChDir(Edit1.Text);
    MakeTree(2, Memo1);
    -------------------
    ListXox1.Clear;
    ChDir(Edit1.Text);
    MakeTree(1, ListBox1);
}
procedure MakeTree(const iMode: integer; const objName: TObject);

//-------------------------------//
//43. Create database DSN
//-------------------------------//
{
  Function:
    Create database DSN
  Parameter:
    sDsnName: DSN name
    sDbPath: Database path and name
    sDescription: About database describe
  Return value:
    True meant success, false meant fail
  Example:
    CreateDsn('Apollotest', 'C:\apollo.mdb', 'apollo test dsn');
}
function CreateDsn(const sDsnName, sDbPath, sDescription: string): Boolean;

//-------------------------------//
//44. Change Chinese to PinYin index
//-------------------------------//
{
  Function:
    Change Chinese to PinYin index
  Parameter:
    sChinese: A Chinsese string
  Return value:
    PinYin index
  Example:
    edtLove.Text := CnToPY('�Ұ�����');
}
function CnToPY(const sChinese: string): string;

//-------------------------------//
//45. Add program ico to IE
//-------------------------------//
{
  Function:
    Add program ico to IE
  Parameter:
    sExePath: Execute program path and name
    sShowText: Show text when mouse move over it
    sIcon: Show icons
    sOverIcon: Show icons when the mouse move over it
  Return value:
    true: Setup success
    false: Setup fail
  Example:
    AddIcoToIE('c:\HUBDOG.CHM', '�����ļ�', 'c:\1.ico', 'c:\2.ico');
}
procedure AddIcoToIE(const sExePath, sShowText, sIcon, sOverIcon: string);

//-------------------------------//
//46. Set disk volume
//-------------------------------//
{
  Function:
    Set disk volume
  Parameter:
    sDriver: Which driver want to change volume
    sLabel: Volume label
  Return value:
    true: Success
    false: fail
  Example:
    SetVolume('C:', 'System');
}
function SetVolume(const sDriver, sLabel: string): Boolean;

//-------------------------------//
//47. Format floppy
//-------------------------------//
{
  Function:
    Format floppy
  Parameter:
    Null
  Return value:
    None
  Example:
    FormatFloppy();
}
function FormatFloppy(): Boolean;

//-------------------------------//
//48. Judge if Audio CD in CDROM
//-------------------------------//
{
  Function:
    Judge if Audio CD in CDROM
  Parameter:
    Drive: CDROM
  Return value:
    true: Is Audio CD
    false: Isn't Audio CD
  Example:
    IsAudioCD('E');
}
function IsAudioCD(const Drive: Char): bool;

//-------------------------------//
//49. Play Audio CD
//-------------------------------//
{
  Function:
    Play Audio CD
  Parameter:
    Drive: CDROM
  Return value:
    true: Play okay
    false: Play fail
  Example:
    PlayAudioCD('E');
}
function PlayAudioCD(const Drive: Char): bool;

//-------------------------------//
//50. Check drive if ready
//-------------------------------//
{
  Function:
    Check drive if ready
  Parameter:
    Drive: Floppy, Harddisk or CDROM
  Return value:
    true: Okay
    false: No okay
  Example:
    DiskInDrive('A');
}
function DiskInDrive(Drive: Char): Boolean;

//-------------------------------//
//51. Check driver type
//-------------------------------//
{
  Function:
    Check driver type
  Parameter:
    sDriver: Disk
  Return value:
    Result about disk type
  Example:
    CheckDriverType('A');
}
function CheckDriverType(const sDriver: string): string;

//-------------------------------//
//52. Check file in use
//-------------------------------//
{
  Function:
    Check file in use
  Parameter:
    fName: File name
  Return value:
    true: In use
    false: No in use
  Example:
    IsFileInUse('C:\a.doc');
}
function IsFileInUse(const fName: string): Boolean;

//-------------------------------//
//53. Copy directory include sub-directory
//-------------------------------//
{
  Function:
    Copy directory include sub-directory
  Parameter:
    sDirName: Source directory name
    sToDirName: To directory
  Return value:
    true: Success
    false: fail
  Example:
    CopyDir('C:\a', 'D:\b');
}
function CopyDir(const sDirName, sToDirName: string): Boolean;

//-------------------------------//
//54. Close CDROM
//-------------------------------//
{
  Function:
    Close CDROM
  Parameter:
    Null
  Return value:
    None
  Example:
    CloseCDROM();
}
//function DeleteDir(const sDirName: string): Boolean;

//-------------------------------//
//55. Create temporery file
//-------------------------------//
{
  Function:
    Create temporery file
  Parameter:
    sPath: The files path
  Return value:
    Created position
  Example:
    CreateTempFile('C:\');
}
function CreateTempFile(const sPath: string): string;

//-------------------------------//
//56. Find files
//-------------------------------//
{
  Function:
    Find files
  Parameter:
    mainpath: The path what want to find
    filename: File name
    foundresult: Find result
  Return value:
    true: Found the files and store the list in foundresult
    false: Not found the file
  Example:
    var
      a: Tstrings;
      i: integer;
    begin
      a := TStringList.Create;
      try
        SearchFile('c:\', 'bird.ico', a);
        edit1.text := inttostr(a.count);
        for i := 0 to a.Count - 1 do
          listbox1.Items.Add(a.Strings[i]);
      finally
        a.Free;
      end;
    end;
}
function SearchFile(mainpath: string; filename: string; var foundresult: TStrings): Boolean;

//-------------------------------//
//57. Get program extension
//-------------------------------//
{
  Function:
    Get program exetention
  Parameter:
    Ext: Extension name like 'ico','exe','gif' etc.
  Return value:
    Extension execute program
  Example:
    GetProgramAssociation('html');
}
function GetProgramAssociation(Ext: string): string;

//-------------------------------//
//58. Get file time
//-------------------------------//
{
  Function:
    Get file time
  Parameter:
    Tf: File name
  Return value:
    Date and time
  Example:
    GetFileTime('C:\a.txt');
}
function myGetFileTime(const Tf: string): string;

//-------------------------------//
//59. Set file date and time
//-------------------------------//
{
  Function:
    Set file date and time
  Parameter:
    Tf: File path and name
    dCreateDate: Create file date
    tCreateTime: Create file time
    dModifyDate: Create file date
    tModifyTime: Create file time
  Return value:
    None
  Example:
    SetFileDateTime('c:\a.txt',DateTimePicker1.Date,
    DateTimePicker2.Time,DateTimePicker3.Date,DateTimePicker4.Time)
}
function SetFileDateTime(const Tf: string; const dCreateDate,
  tCreateTime, dModifyDate, tModifyTime: TDateTime): Boolean;

//-------------------------------//
//60. Get file last access time
//-------------------------------//
{
  Function:
    Get file last access time
  Parameter:
    FileName: File name and path
  Return value:
    Last access time
  Example:
    GetFileLastAccessTime('C:\a.txt');
}
function GetFileLastAccessTime(const FileName: PChar): string;

//-------------------------------//
//61. Create a empty directory
//-------------------------------//
{
  Function:
    Create a empty directory
  Parameter:
    sDirName: Directory name
  Return value:
    None
  Example:
    CreateDirectory('C:\apollo');
}
procedure CreateDirectory(const sDirName: string);

//-------------------------------//
//62. Change directory
//-------------------------------//
{
  Function:
    Change directory
  Parameter:
    sPath: Path
  Return value:
    None
  Example:
    ChangeDirectory('C:\apollo');
}
procedure ChangeDirectory(const sPath: string);

//-------------------------------//
//63. Get a disk current directory
//-------------------------------//
{
  Function:
    Get a disk current directory
  Parameter:
    iDrive: Disk code with integer value as 0, 1, 2 meant default, A, B
  Return value:
    A var meant current directory in a disk
  Example:
    var s: string;
    GetDirectory(0, s);
}
procedure GetDirectory(const iDrive: integer; var sPath: string);

//-------------------------------//
//64. Set current directory
//-------------------------------//
{
  Function:
    Set current directory
  Parameter:
    sPath: Path
  Return value:
    None
  Example:
    SetCurrentDirectory('C:\jessies');
}
procedure SetCurrentDirectory(const sPath: string);

//-------------------------------//
//65. Rename directory or file
//-------------------------------//
{
  Function:
    Rename directory or file
  Parameter:
    sFromName: Source name
    sToName: Destinition name
  Return value:
    None
  Example:
    RenameDirOrFile('c:\apollo', 'c:\jessies');
}
procedure RenameDirOrFile(const sFromName, sToName: string);

//-------------------------------//
//66. Create directory's tree
//-------------------------------//
{
  Function:
    Create directory's tree
  Parameter:
    sPath: Path
  Return value:
    None
  Example:
    sPath('C:\apollo\jessies');
}
procedure CreateMultiDir(const sPath: string);

//-------------------------------//
//67. Directory exists
//-------------------------------//
{
  Function:
    Directory exists
  Parameter:
    sDirName: Directory name and path
  Return value:
    true meant exists
    false meant not exists
  Example:
    DirExist('C:\apollo');
}
function DirExist(const sDirName: string): Boolean;

//-------------------------------//
//68. Change file extension
//-------------------------------//
{
  Function:
    Change file extension
  Parameter:
    sPath: File path and name
    sExtName: Extension name
  Return value:
    None
  Example:
    procedure TForm1.ConvertIcon2BitmapClick(Sender: TObject);
    var
      s : string;
      Icon: TIcon;
    begin
      OpenDialog1.DefaultExt := '.ICO';
      OpenDialog1.Filter := 'icons (*.ico)|*.ICO';
      OpenDialog1.Options := [ofOverwritePrompt, ofFileMustExist, ofHideReadOnly ];
      if OpenDialog1.Execute then
      begin
        Icon := TIcon.Create;
        try
          Icon.Loadfromfile(OpenDialog1.FileName);
          s:= ChangeFileExt(OpenDialog1.FileName,'.BMP');
          Image1.Width := Icon.Width;
          Image1.Height := Icon.Height;
          Image1.Canvas.Draw(0,0,Icon);
          Image1.Picture.SaveToFile(s);
          ShowMessage(OpenDialog1.FileName + ' Saved to ' + s);
        finally
          Icon.Free;
        end;
      end;
    end;
}
//Note: You must be create a new file to be saved
procedure ChangeFileExtension(const sPath, sExtName: string);

//-------------------------------//
//69. Get file extension name
//-------------------------------//
{
  Function:
    Get file extension name
  Parameter:
    sFileName: File name
  Return value:
    Extension name
  Example:
    GetFileExtension('C:\apollo.exe');
}
function GetFileExtension(const sFileName: string): string;

//-------------------------------//
//70. Copy file from source to target
//-------------------------------//
{
  Function:
    Copy file from source to target
  Parameter:
    sourcefilename: Source file
    targetfilename: Target file
  Return value:
    None
  Example:
    FileCopy('C:\apollo.txt', 'C:\jessies.txt');
}
procedure FileCopy1(const sourcefilename, targetfilename: string);

//-------------------------------//
//71. Copy file from source to target
//-------------------------------//
{
  Function:
    Copy file from source to target
  Parameter:
    FromFile: Source file
    ToFile: Target file
  Return value:
    None
  Example:
    FileCopy('C:\apollo.txt', 'C:\jessies.txt');
}
procedure FileCopy2(const FromFile, ToFile: string);

//-------------------------------//
//72. Copy file from source to target
//-------------------------------//
{
  Function:
    Copy file from source to target
  Parameter:
    FromFileName: Source file
    ToFileName: Target file
  Return value:
    None
  Example:
    FileCopy('C:\apollo.txt', 'C:\jessies.txt');
}
procedure FileCopy3(const FromFileName, ToFileName: string);

//-------------------------------//
//73. Set file attributes
//-------------------------------//
{
  Function:
    Set file attributes
  Parameter:
    iMode: Attributes type
    sFileName: File name
  Return value:
    None
  Example:
    SetFileAttribAPI(5, 'C:\apollo.txt');
}
procedure SetFileAttribAPI(const iMode: integer; const sFileName: PChar);

//-------------------------------//
//74. Set file attributes
//-------------------------------//
{
  Function:
    Set file attributes
  Parameter:
    iMode: Attributes type
    sFileName: File name
  Return value:
    None
  Example:
    SetFileAttrib(5, 'C:\apollo.txt');
}
procedure SetFileAttrib(const iMode: integer; const sFileName: string);

//-------------------------------//
//75. Get file path
//-------------------------------//
{
  Function:
    Get file path
  Parameter:
    sFileName: File name
  Return value:
    Path
  Example:
    GetFilePath1('C:\apollo\test\a.exe');
}
function GetFilePath1(const sFileName: string): string;

//-------------------------------//
//76. Get file path
//-------------------------------//
{
  Function:
    Get file path
  Parameter:
    sFileName: File name
  Return value:
    Path
  Example:
    GetFilePath2('C:\apollo\test\a.exe');
}
function GetFilePath2(const sFileName: string): string;

//-------------------------------//
//77. Copy or delete or rename or move files
//-------------------------------//
{
  Function:
    Copy or delete or rename or move files
  Parameter:
    iMode: Operate mode by 1, 2, 3, 4
    sSoure: Source files
    sDestination: Destination files
    blnAbortByUser: Check user if abort the operation
  Return value:
    -1: Mode error
    0 : Okay
    Other value: Abort by user
  Example:
    CopyDelRenMovFile(1, 'D:\mp3', 'D:\mp4' ,blnResult);
    CopyDelRenMovFile(2, 'D:\mp3\û��������ô��.mp3', '' ,blnResult);
    CopyDelRenMovFile(3, 'D:\mp3\û��������ô��.mp3', 'D:\mp3\a.mp3' ,blnResult);
    CopyDelRenMovFile(4, 'D:\mp3\û��������ô��.mp3', 'D:\mp4\û��������ô��.mp3' ,blnResult);
}
function CopyDelRenMovFile(const iMode: integer; const sSource,
  sDestination: string; var blnAbortByUser: boolean): integer;

//-------------------------------//
//78. Get used port list
//-------------------------------//
{
  Function:
    Get used port list
  Parameter:
    stComList: Used port list
  Return value:
    None
  Example:
    GetPortUsed(myList);
}
procedure GetPortUsed(var stComList: TStrings);

//-------------------------------//
//79. Set media audio off
//-------------------------------//
{
  Function:
    Set media audio off
  Parameter:
    DeviceID: Media device ID
  Return value:
    None
  Example:
    //Play AVI file silently
    MediaPlayer1.FileName := 'speedis.avi';
    MediaPlayer1.Display := Panel1;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    SetMediaAudioOff(MediaPlayer1.DeviceId);
}
procedure SetMediaAudioOff(const DeviceID: word);

//-------------------------------//
//80. Set media audio on
//-------------------------------//
{
  Function:
    Set media audio on
  Parameter:
    DeviceID: Media device ID
  Return value:
    None
  Example:
    //Play AVI with sound
    MediaPlayer1.FileName := 'speedis.avi';
    MediaPlayer1.Display := Panel1;
    MediaPlayer1.Open;
    MediaPlayer1.Play;
    SetMediaAudioOn(MediaPlayer1.DeviceId);
}
procedure SetMediaAudioOn(const DeviceID: word);

//-------------------------------//
//81. Wait until execute files finished
//-------------------------------//
{
  Function:
    Wait until execute files finished
  Parameter:
    sExeName: Execute files name
  Return value:
    None
  Example:
    WaitExeFinish('NotePad.exe');
}
procedure WaitExeFinish(const sExeName: string);

//_____________________________________________________________________//
//                                                                     //
//                        Constant define                              //
//_____________________________________________________________________//

const
  csRoot: string = '�ҵĵ���';

implementation

//_____________________________________________________________________//

//**************************************************
//Note:The files name no longer than 8 characters.
//     Position will rewrite with custom value.
//**************************************************

procedure CustomCursor(const objControl: TObject;const iPosition,
  iMode: integer;const sFilePath: string);
var
  tt: PChar;
  Size: integer;
  s: string;
begin
  tt := '';
  Size := 0;
  try
    Size := Length(sFilePath);
    GetMem(tt,size);
    s := sFilePath;
    StrpCopy(tt,s);
    Screen.Cursors[iPosition] := LoadCursorFromFile(tt);
    case iMode of
      1: (objControl as TForm).Cursor := iPosition; //Set form icon
      2: (objControl as TImage).Cursor := iPosition; //Set image icon
      3: (objControl as TPanel).Cursor := iPosition; //Set panel icon
    end;
  finally
    FreeMem(tt,Size);
  end;
end;

//_____________________________________________________________________//

function ReadRegKey(const iMode:integer; const sPath,
  sKeyName: string): string;
var
  rRegObject: TRegistry;
  sResult: string;
begin
  rRegObject := TRegistry.Create;
  try
    with rRegObject do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(sPath, True) then
      begin
        case iMode of
          1: sResult := ReadString(sKeyName);
          2: sResult := IntToStr(ReadInteger(sKeyName));
          //3: sResult := ReadBinaryData(sKeyName, Buffer, BufSize);
        end;
        Result := sResult;
      end
      else
        Result := '';
      CloseKey;
    end;
  finally
    rRegObject.Free;
  end;
end;

//_____________________________________________________________________//

function WriteRegKey(const iMode:integer; const sPath, sKeyName,
  sKeyValue: string): Boolean;
var
  rRegObject: TRegistry;
  bData: byte;
begin
  rRegObject := TRegistry.Create;
  try
    with rRegObject do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(sPath, True) then
      begin
        case iMode of
          1: WriteString(sKeyName, sKeyValue);
          2: WriteInteger(sKeyName, StrToInt(sKeyValue));
          3: WriteBinaryData(sKeyName, bData, 1 );
        end;
        Result := true;
      end
      else
        Result := false;
      CloseKey;
    end;
  finally
    rRegObject.Free;
  end;
end;

//_____________________________________________________________________//

function GetExePath():string;
var
  ExePath:string;
  iPos,Index:integer;
begin
   ExePath:=Application.ExeName;
   iPos := 0;
   for Index := 1 to Length(ExePath) do
    if ExePath[Index] = '\' then
     iPos := Index;
   Result := copy(ExePath,1,iPos - 1);
end;

//_____________________________________________________________________//

function GetParameter(const FileName:string):WideString;
var
  f: TextFile;
  sPath, sValue: string;
begin
  sPath := GetExePath() + '\' + FileName;//Get exe program path from ini file
try
  AssignFile(f,sPath);
  Reset(f);
  while not eof(f) do
    Readln(f, sValue);
  if sValue <> '' then
    Result := sValue
  else begin
    Result := '';
    Application.MessageBox('������ʾ','��ȡ�����ļ����󣬿������ļ��в�����ָ���Ĳ�����',MB_OK + MB_DEFBUTTON1 + MB_ICONERROR);
  end;
  CloseFile(f);
except
  Result := '';
  Application.MessageBox('������ʾ','û���ҵ������ļ��������½�����',MB_OK + MB_DEFBUTTON1 + MB_ICONERROR);
end;
end;

//_____________________________________________________________________//

procedure RebootExpires();
begin
  SystemParametersInfo(SPI_SCREENSAVERRUNNING, 1, nil, 0);
end;

//_____________________________________________________________________//

procedure RebootRestore();
begin
  SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, nil, 0);
end;

//_____________________________________________________________________//

procedure CloseExpires();
var
  Handle: THandle;
begin
  Handle := 0;
  EnableMenuItem(GetSystemMenu(Handle, FALSE), SC_CLOSE, MF_BYCOMMAND or MF_GRAYED);
end;

//_____________________________________________________________________//

procedure CloseRestore();
var
  Handle: THandle;
begin
  Handle := 0;
  EnableMenuItem(GetSystemMenu(Handle, FALSE), SC_CLOSE, MF_BYCOMMAND or MF_ENABLED);
end;

//_____________________________________________________________________//

procedure HideDesktop();
var
  h, hChild: HWND;
begin
  h := FindWindow(nil, 'Program Manager');
  if h > 0 then
  begin
    h := GetWindow(h, GW_CHILD);
    ShowWindow(h, SW_HIDE);
    hChild := GetWindow(h, GW_CHILD);
    ShowWindow(hChild, SW_HIDE);
    ShowWindow(h, SW_SHOW);
  end;
end;

//_____________________________________________________________________//

procedure ShowDesktop();
var
  h, hChild: HWND;
begin
  h := FindWindow(nil, 'Program Manager');
  if h > 0 then
  begin
    h := GetWindow(h, GW_CHILD);
    ShowWindow(h, SW_SHOW);
    hChild := GetWindow(h, GW_CHILD);
    ShowWindow(hChild, SW_SHOW);
  end;
end;

//_____________________________________________________________________//

function ChangeWallPaper(const sPath: string): Boolean;
begin
  Result := SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, pChar(sPath),SPIF_UPDATEINIFILE);
end;

//_____________________________________________________________________//

function myGetWindowsDirectory(): string;
var
  pcWindowsDirectory: PChar;
  dwWDSize: DWORD;
begin
  dwWDSize := MAX_PATH + 1;
  Result := '';
  GetMem(pcWindowsDirectory, dwWDSize);
  try
    if Windows.GetWindowsDirectory(pcWindowsDirectory, dwWDSize) <> 0 then
      Result := pcWindowsDirectory;
  finally
    FreeMem( pcWindowsDirectory );
  end;
end;

//_____________________________________________________________________//

function myGetSystemDirectory(): string;
var
  pcSystemDirectory: PChar;
  dwSDSize: DWORD;
begin
  dwSDSize := MAX_PATH + 1;
  Result := '';
  GetMem(pcSystemDirectory, dwSDSize);
  try
    if Windows.GetSystemDirectory(pcSystemDirectory, dwSDSize) <> 0 then
      Result := pcSystemDirectory;
  finally
    FreeMem(pcSystemDirectory);
  end;
end;

//_____________________________________________________________________//

function myGetTempPath(): string;
var
  nBufferLength: DWORD;
  lpBuffer: PChar;
begin
  nBufferLength := MAX_PATH + 1;
  GetMem(lpBuffer, nBufferLength);
  try
    if GetTempPath(nBufferLength, lpBuffer) <> 0 then
      Result := StrPas(lpBuffer)
    else
      Result := '';
  finally
     FreeMem(lpBuffer);
  end;
end;

//_____________________________________________________________________//

function myGetLogicalDrives(): string;
var
  drives: set of 0..25;
  drive: integer;
begin
  Result := '';
  DWORD( drives ) := Windows.GetLogicalDrives;
  for drive := 0 to 25 do
    if drive in drives then
      Result := Result + Chr(drive + Ord('A'));
end;

//_____________________________________________________________________//

function myGetUserName(): string;
var
  pcUser: PChar;
  dwUSize: DWORD;
begin
  dwUSize := 21; //�û������Ȳ�����20���ַ�
  Result := '';
  GetMem(pcUser, dwUSize);
  try
    if Windows.GetUserName(pcUser, dwUSize) then
      Result := pcUser;
  finally
    FreeMem(pcUser);
  end;
end;

//_____________________________________________________________________//

function myGetComputerName(): string;
var
  pcComputer: PChar;
  dwCSize: DWORD;
begin
  dwCSize := MAX_COMPUTERNAME_LENGTH + 1;
  Result := '';
  GetMem(pcComputer, dwCSize);
  try
    if Windows.GetComputerName(pcComputer, dwCSize) then
      Result := pcComputer;
  finally
    FreeMem(pcComputer);
  end;
end;

//_____________________________________________________________________//

function mySelectDirectory(const sDescription, sPath: string): string;
var
  sReturnPath: string;
begin
  if SelectDirectory(sDescription, sPath, sReturnPath) then
    Result := sReturnPath
  else
    Result := '';
end;

//_____________________________________________________________________//

procedure myClearDocument();
begin
  SHAddtoRecentDocs(SHARD_PATH, nil);
end;

//_____________________________________________________________________//

procedure SystemAbout(const sTitle, sContent: string);
begin
  ShellAbout(Application.Handle, PChar(sTitle), PChar(sContent), Application.Icon.Handle);
end;

//_____________________________________________________________________//

//���ȡ��ȡ����Ϊ�գ����򷵻�ѡ�е�·��
function SelectDir(const iMode: integer; const sInfo: string): string;
var
  Info: TBrowseInfo;
  IDList: pItemIDList;
  Buffer: PChar;
begin
  Result:='';
  Buffer := StrAlloc(MAX_PATH);
  with Info do
  begin
    hwndOwner := application.mainform.Handle;  //Ŀ¼�Ի��������Ĵ��ھ��
    pidlRoot := nil;                           //��ʼλ�ã�ȱʡΪ�ҵĵ���
    pszDisplayName := Buffer;                  //���ڴ��ѡ��Ŀ¼��ָ��
    lpszTitle := PChar(sInfo);                 //�Ի�����ʾ��Ϣ
    //ѡ��������˴���ʾ��ʾĿ¼���ļ������ֻ��ʾĿ¼�򽫺�һ��ȥ������
    if iMode = 1 then
      ulFlags := BIF_RETURNONLYFSDIRS or BIF_BROWSEINCLUDEFILES
    else
      ulFlags := BIF_RETURNONLYFSDIRS;
    lpfn := nil;                               //ָ���ص�����ָ��
    lParam := 0;                               //���ݸ��ص���������
    IDList := SHBrowseForFolder(Info);         //��ȡĿ¼��Ϣ
  end;
  if IDList <> nil then
  begin
      SHGetPathFromIDList(IDList, Buffer);     //��Ŀ¼��Ϣת��Ϊ·���ַ���
      Result := strpas(Buffer);
  end;
  StrDispose(buffer);
end;

//_____________________________________________________________________//

procedure HideFormOnTask();
begin
  SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW);
end;

//_____________________________________________________________________//

procedure ConvertBMPtoJPG(const sFileName, sToFileName: string);
var
  J: TJpegImage;
  I: TBitmap;
  S: string;
begin
  S := sFileName;
  J := TJpegImage.Create;
  try
    I := TBitmap.Create;
    try
      I.LoadFromFile(S);
      J.Assign(I);
    finally
      I.Free;
    end;
    S := ChangeFileExt(sToFileName, '.jpg');
    J.SaveToFile(S);
    Application.ProcessMessages;
  finally
    J.Free;
  end;
end;

//_____________________________________________________________________//

procedure ConvertJPGtoBMP(const sFileName, sToFileName: string);
var
  J: TJpegImage;
  I: TBitmap;
  S: string;
begin
  S := sFileName;
  I := TBitmap.Create;
  try
    J := TJpegImage.Create;
    try
      J.LoadFromFile(S);
      I.Assign(J);
    finally
      J.Free;
    end;
    S := ChangeFileExt(sToFileName, '.bmp');
    I.SaveToFile(S);
    Application.ProcessMessages;
  finally
    I.Free;
  end;
end;

//_____________________________________________________________________//

function Replacing(S, source, target: string): string;
var
  site,StrLen:integer;
begin
  {source��S�г��ֵ�λ��}
  site := pos(source, S);
  if site = 0 then
  begin
    Result := S;
    exit;
  end;
  {source�ĳ���}
  StrLen := length(source);
  {ɾ��source�ַ���}
  Delete(S, site, StrLen);
  {����target�ַ�����S��}
  Insert(target, S, site);
  {�����´�}
  Replacing := S;
end;

//_____________________________________________________________________//

function SmallTOBig(const small: real; const iPosition: integer): string;
var
  SmallMonth, BigMonth: string;
  wei1, qianwei1: string[2];
  qianwei, dianweizhi, qian: integer;
begin
  {------- �޸Ĳ�����ֵ����ȷ -------}
  qianwei := iPosition;{С������λ�ã���Ҫ�Ļ�Ҳ���ԸĶ�-2ֵ}
  Smallmonth := FormatFloat('0.00', small);{ת���ɻ�����ʽ����Ҫ�Ļ�С�����Ӷ༸����}
  {---------------------------------}
  dianweizhi := pos('.', Smallmonth);{С�����λ��}
  for qian := length(Smallmonth) downto 1 do{ѭ��Сд���ҵ�ÿһλ����Сд���ұ�λ�õ����}
  begin
    if qian <> dianweizhi then{��������Ĳ���С����ͼ���}
    begin
      case strtoint(copy(Smallmonth, qian, 1)) of{λ���ϵ���ת���ɴ�д}
        1: wei1 := 'Ҽ'; 2: wei1 := '��';
        3: wei1 := '��'; 4: wei1 := '��';
        5: wei1 := '��'; 6: wei1 := '½';
        7: wei1 := '��'; 8: wei1 := '��';
        9: wei1 := '��'; 0: wei1 := '��';
      end;
      case qianwei of{�жϴ�дλ�ã����Լ�������real���͵����ֵ}
        -3: qianwei1 := '��';
        -2: qianwei1 := '��';
        -1: qianwei1 := '��';
        0 : qianwei1 := 'Ԫ';
        1 : qianwei1 := 'ʰ';
        2 : qianwei1 := '��';
        3 : qianwei1 := 'ǧ';
        4 : qianwei1 := '��';
        5 : qianwei1 := 'ʰ';
        6 : qianwei1 := '��';
        7 : qianwei1 := 'ǧ';
        8 : qianwei1 := '��';
        9 : qianwei1 := 'ʮ';
        10: qianwei1 := '��';
        11: qianwei1 := 'ǧ';
      end;
      inc(qianwei);
      BigMonth := wei1 + qianwei1 + BigMonth;{��ϳɴ�д���}
    end;
  end;
  SmallTOBig := BigMonth;
end;

//_____________________________________________________________________//

procedure CreateShortCut(const sPath: string; sShortCutName: WideString);
var
  tmpObject: IUnknown;
  tmpSLink: IShellLink;
  tmpPFile: IPersistFile;
  PIDL: PItemIDList;
  StartupDirectory: array[0..MAX_PATH] of Char;
  StartupFilename: String;
  LinkFilename: WideString;
begin
  StartupFilename := sPath;
  tmpObject := CreateComObject(CLSID_ShellLink);//����������ݷ�ʽ�������չ
  tmpSLink := tmpObject as IShellLink;//ȡ�ýӿ�
  tmpPFile := tmpObject as IPersistFile;//��������*.lnk�ļ��Ľӿ�
  tmpSLink.SetPath(pChar(StartupFilename));//�趨notepad.exe����·��
  tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(StartupFilename)));//�趨����Ŀ¼
  SHGetSpecialFolderLocation(0, CSIDL_DESKTOPDIRECTORY, PIDL);//��������Itemidlist
  SHGetPathFromIDList(PIDL, StartupDirectory);//�������·��
  sShortCutName := '\' + sShortCutName + '.lnk';
  LinkFilename := StartupDirectory + sShortCutName;
  tmpPFile.Save(pWChar(LinkFilename), FALSE);//����*.lnk�ļ�
end;

//_____________________________________________________________________//

procedure myAddDocument(const sPath: string);
begin
  SHAddToRecentDocs(SHARD_PATH, pChar(sPath));
end;

//_____________________________________________________________________//

function GetFileIcon(const Filename: string; SmallIcon: Boolean): HICON;
var
  info: TSHFILEINFO;
  Flag: Integer;
begin
  if SmallIcon then
    Flag := (SHGFI_SMALLICON or SHGFI_ICON)
  else
    Flag := (SHGFI_LARGEICON or SHGFI_ICON);
  SHGetFileInfo(Pchar(Filename), 0, info, Sizeof(info), Flag);
  Result := info.hIcon;
end;

//_____________________________________________________________________//

function GetCDROMNumber(): string;
var
  mp: TMediaPlayer;
  msp: TMCI_INFO_PARMS;
  MediaString: array[0..255] of char;
  ret: longint;
begin
  mp := TMediaPlayer.Create(nil);
  try
    mp.Visible := false;
    mp.Parent := Application.MainForm;
    mp.Shareable := true;
    mp.DeviceType := dtCDAudio;
    mp.FileName := 'D:';
    mp.Open;
    Application.ProcessMessages;
    FillChar(MediaString, sizeof(MediaString), #0);
    FillChar(msp, sizeof(msp), #0);
    msp.lpstrReturn := @MediaString;
    msp.dwRetSize := 255;
    ret := mciSendCommand(Mp.DeviceId, MCI_INFO, MCI_INFO_MEDIA_IDENTITY, longint(@msp));
    if Ret <> 0 then
    begin
      MciGetErrorString(ret, @MediaString, sizeof(MediaString));
      Result := StrPas(MediaString);
    end
    else
      Result := StrPas(MediaString);
  finally
    mp.Close;
    Application.ProcessMessages;
    mp.free;
  end;
end;

//_____________________________________________________________________//

procedure SetCDAutoRun(AAutoRun: Boolean);
const
  DoAutoRun : array[Boolean] of Integer = (0,1);
var
  Reg:TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.KeyExists('System\CurrentControlSet\Services\Class\CDROM')
    then
    if
    Reg.OpenKey('System\CurrentControlSet\Services\Class\CDROM',FALSE) then
    //Reg.WriteBinaryData('AutoRun',DoAutoRun[AAutoRun],1);
  finally
    Reg.Free;
  end;
  if AAutoRun then
    Application.MessageBox('���ù����Զ�����������������Windows������������Ч��','��Ϣ',MB_IconInformation + MB_OK)
  else
    Application.MessageBox('��ֹ�����Զ�����������������Windows������������Ч��','��Ϣ',MB_IconInformation + MB_OK);
end;

//_____________________________________________________________________//

procedure OpenCDROM();
begin
  mciSendString('Set cdaudio door open wait', nil, 0, Application.Handle);
end;

//_____________________________________________________________________//

procedure CloseCDROM();
begin
  mciSendString('Set cdaudio door closed wait', nil, 0, Application.Handle);
end;

//_____________________________________________________________________//

function GetDiskFreeSpaceEx(lpDirectoryName: PAnsiChar; 
var lpFreeBytesAvailableToCaller: Integer;
var lpTotalNumberOfBytes: Integer;
var lpTotalNumberOfFreeBytes: Integer): bool;
stdcall;
external kernel32
name 'GetDiskFreeSpaceExA';


procedure GetDiskSizeAvail(TheDrive: PChar; var TotalBytes, TotalFree: double);
var
  AvailToCall: integer;
  TheSize: integer;
  FreeAvail: integer;
begin
  GetDiskFreeSpaceEx(TheDrive, AvailToCall, TheSize, FreeAvail);
  {$IFOPT Q+}
  {$DEFINE TURNOVERFLOWON}
  {$Q-}
  {$ENDIF}
  if TheSize >= 0 then
    TotalBytes := TheSize
  else if TheSize = -1 then
  begin
    TotalBytes := $7FFFFFFF;
    TotalBytes := TotalBytes * 2;
    TotalBytes := TotalBytes + 1;
  end
  else begin
    TotalBytes := $7FFFFFFF;
    TotalBytes := TotalBytes + abs($7FFFFFFF - TheSize);
  end;

  if AvailToCall >= 0 then
    TotalFree := AvailToCall
  else if AvailToCall = -1 then
  begin
    TotalFree := $7FFFFFFF;
    TotalFree := TotalFree * 2;
    TotalFree := TotalFree + 1;
  end
  else begin
    TotalFree := $7FFFFFFF;
    TotalFree := TotalFree + abs($7FFFFFFF - AvailToCall);
  end;
end;

//_____________________________________________________________________//

procedure GetDiskSize(const sDriver: string; var TotalBytes, TotalFree: double);
var
  sec1, byt1, cl1, cl2: LongWord;
begin
  GetDiskFreeSpace(PChar(sDriver), sec1, byt1, cl1, cl2);
  TotalFree := cl1 * sec1 * byt1;
  TotalBytes := cl2 * sec1 * byt1;
end;

//_____________________________________________________________________//

//**************************************************
//  Use the function to call system bar items
//**************************************************

function SystemBarCall(const iNumber:integer):Boolean;
begin
  try
    case iNumber of
      //Call dial-up network control
      1: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL InetCpl.cpl,,3',SW_SHOWNORMAL);
      //Call area and date set up
      2: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Intl.cpl,,4',SW_SHOWNORMAL);
      //Open control panel
      3: WinExec('RunDLL.exe Shell32.DLL,Control_RunDLL',SW_SHOWNORMAL);
      //Call ODBC connection
      4: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL ODBCCP32.CPL',SW_SHOWNORMAL);
      //Call BDE administrator
      5: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL BdeAdmin.CPL',SW_SHOWNORMAL);
      //Call internet properties
      6: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL InetCpl.cpl,,0', SW_SHOWNORMAL);
      //Call safety properties
      7: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL InetCpl.cpl,,1', SW_SHOWNORMAL);
      //Call content properties
      8: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL InetCpl.cpl,,2', SW_SHOWNORMAL);
      //Call program properties
      9: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL InetCpl.cpl,,4', SW_SHOWNORMAL);
      //Call advanced properties
      10: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL InetCpl.cpl,,5', SW_SHOWNORMAL);
      //Call phone dial-up properties
      11: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Telephon.cpl', SW_SHOWNORMAL);
      //Call power management properties
      12: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL PowerCfg.cpl', SW_SHOWNORMAL);
      //Call modem properties
      13: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Modem.cpl', SW_SHOWNORMAL);
      //Call mutil-media properties
      14: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Mmsys.cpl,,0', SW_SHOWNORMAL);
      //Call video properties
      15: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Mmsys.cpl,,1', SW_SHOWNORMAL);
      //Call MIDI properties
      16: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Mmsys.cpl,,2', SW_SHOWNORMAL);
      //Call CD properties
      17: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Mmsys.cpl,,3', SW_SHOWNORMAL);
      //Call fixture properties
      18: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Mmsys.cpl,,4', SW_SHOWNORMAL);
      //Call keyboard properties
      19: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL access.cpl,,1',SW_SHOWNORMAL);
      //Call sound properties
      20: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL access.cpl,,2', SW_SHOWNORMAL);
      //Call display properties
      21: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL access.cpl,,3', SW_SHOWNORMAL);
      //Call mouse properties
      22: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL access.cpl,,4', SW_SHOWNORMAL);
      //Call general properties
      23: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL access.cpl,,5', SW_SHOWNORMAL);
      //Call password properties
      24: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Password.cpl', SW_SHOWNORMAL);
      //Call area setup properties
      25: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Intl.cpl,,0', SW_SHOWNORMAL);
      //Call numberic properties
      26: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Intl.cpl,,1', SW_SHOWNORMAL);
      //Call currency properties
      27: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Intl.cpl,,2', SW_SHOWNORMAL);
      //Call time properties
      28: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Intl.cpl,,3', SW_SHOWNORMAL);
      //Call date properties
      29: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Intl.cpl,,4', SW_SHOWNORMAL);
      //Call date and time properties
      30: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL TimeDate.cpl,,0', SW_SHOWNORMAL);
      //Call time zone properties
      31: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL TimeDate.cpl,,1', SW_SHOWNORMAL);
      //Call mouse properties,no button and pointer and move items
      32: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Main.cpl', SW_SHOWNORMAL);
      //Call add/remove properties
      33: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL AppWiz.cpl,,1', SW_SHOWNORMAL);
      //Call windows setup properties
      34: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL AppWiz.cpl,,2', SW_SHOWNORMAL);
      //Call boot disk properties
      35: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL AppWiz.cpl,,3', SW_SHOWNORMAL);
      //Call network setup properties,no configure and sign and accessing control items
      36: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL NetCpl.cpl', SW_SHOWNORMAL);
      //Call general of system setup properties
      37: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL SysDm.cpl,,0', SW_SHOWNORMAL);
      //Call fixture management of system setup properties
      38: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL SysDm.cpl,,1', SW_SHOWNORMAL);
      //Call hardware configure file of system setup properties
      39: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL SysDm.cpl,,2', SW_SHOWNORMAL);
      //Call performance of system setup properties
      40: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL SysDm.cpl,,3', SW_SHOWNORMAL);
      //Call background of show setup properties
      41: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL desk.cpl,,0', SW_SHOWNORMAL);
      //Call screen savers of show setup properties
      42: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL desk.cpl,,1', SW_SHOWNORMAL);
      //Call appearance of show setup properties
      43: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL desk.cpl,,2', SW_SHOWNORMAL);
      //Call setup of show setup properties
      44: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL desk.cpl,,3', SW_SHOWNORMAL);
      //Call general of game controls properties
      45: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Joy.cpl,,0', SW_SHOWNORMAL);
      //Call advanced of game controls properties
      46: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL Joy.cpl,,1', SW_SHOWNORMAL);
      //Call scanner and numeric camera properties
      47: WinExec('RunDLL32.exe Shell32.dll,Control_RunDLL StiCpl.cpl', SW_SHOWNORMAL);
    end;
    Result := true;
  except
    Application.MessageBox('����ϵͳ�������ѡ���ʧ�ܣ�ȷ�����Ĳ���ϵͳ�Ƿ�ΪWindows 98��', 'ϵͳ����', MB_OK + MB_DEFBUTTON1 + MB_ICONWARNING);
    Result := false;
  end;
end;

//_____________________________________________________________________//

function GetUserNameAPI(): AnsiString;//ȡ���û�����
var
  lpName: PAnsiChar;
  lpUserName: PAnsiChar;
  lpnLength: DWORD;
begin
  Result := '';
  lpName := '';
  lpnLength := 0;
  WNetGetUser(nil, nil, lpnLength);// ȡ���ִ�����
  if lpnLength > 0 then
  begin
    GetMem(lpUserName, lpnLength);
    if WNetGetUser(lpName, lpUserName, lpnLength) = NO_ERROR then Result := lpUserName;
    FreeMem(lpUserName, lpnLength);
  end;
end;

//_____________________________________________________________________//

function GetWindowsProductID(): string;// ȡ�� Windows ��Ʒ���
var
  reg: TRegistry;
begin
  Result := '';
  reg := TRegistry.Create;
  with reg do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Microsoft\Windows\CurrentVersion', False);
    Result := ReadString('ProductID');
  end;
  reg.Free;
end;

//_____________________________________________________________________//

procedure HideTaskbar(); //����
var
  wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_HIDE);
End;

//_____________________________________________________________________//

procedure ShowTaskbar();
var
  wndHandle: THandle;
  wndClass: array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_RESTORE);
end;

//_____________________________________________________________________//

procedure MakeTree(const iMode: integer; const objName: TObject);
var
  Sr: TSearchRec;
  Err: Integer;
  FilePath: string;
begin
  if (iMode <> 1) and (iMode <> 2) then
  begin
    Application.MessageBox('ģʽѡ��������Χ�����飡', '��������', MB_OK + MB_DEFBUTTON1 + MB_ICONERROR);
    exit;
  end;
  Err := FindFirst('*.*', $37, Sr);   //$37Ϊ��Volumn ID Files��������ļ�
  //����ҵ��ļ�
  while (Err = 0) do
  begin
    if Sr.Name[1] <> '.' then
    begin
      //�ҵ��ļ�
      if (Sr.Attr and faDirectory) = 0 then
      begin

      end;
      //�ҵ���Ŀ¼
      if (Sr.Attr and faDirectory) = 16 then
      begin
        FilePath := ExpandFileName(Sr.Name);
        if iMode = 1 then
          (objName as TListBox).Items.Add(FilePath)
        else if iMode = 2 then
          (objName as TMemo).Lines.Add(FilePath);
        ChDir(Sr.Name);
        MakeTree(iMode, objName);
        ChDir('..');
      end;
    end;
    //�����ݹ�
    Err := FindNext(Sr);
  end;
end;

//_____________________________________________________________________//

function CreateDsn(const sDsnName, sDbPath, sDescription: string): Boolean;
var
  registerTemp : TRegistry;
  bData : array[ 0..0 ] of byte;
begin
  Result := false;
  registerTemp := TRegistry.Create; //����һ��Registryʵ��
  with registerTemp do
  begin
    RootKey:=HKEY_LOCAL_MACHINE;//���ø���ֵΪHKEY_LOCAL_MACHINE
    //�ҵ�Software\ODBC\ODBC.INI\ODBC Data Sources
    if OpenKey('Software\ODBC\ODBC.INI\ODBC Data Sources',True) then
      WriteString(sDsnName, 'Microsoft Access Driver (*.mdb)' )//ע��һ��DSN����
    else//������ֵʧ��
      exit;
    CloseKey;
    //�ҵ��򴴽�Software\ODBC\ODBC.INI\MyAccess,д��DSN������Ϣ
    if OpenKey('Software\ODBC\ODBC.INI\' + sDsnName, True) then
    begin
      WriteString( 'DBQ', sDbPath);//���ݿ�Ŀ¼
      WriteString( 'Description', sDescription );//����Դ����
      WriteString( 'Driver', myGetSystemDirectory() + '\odbcjt32.dll' );//��������DLL�ļ�
      WriteInteger( 'DriverId', 25 );//���������ʶ
      WriteString( 'FIL', 'Ms Access;' );//Filter����
      WriteInteger( 'SafeTransaction', 0 );//֧�ֵ����������Ŀ
      WriteString( 'UID', '' );//�û�����
      bData[0] := 0;
      WriteBinaryData( 'Exclusive', bData, 1 );//�Ƕ�ռ��ʽ
      WriteBinaryData( 'ReadOnly', bData, 1 );//��ֻ����ʽ
    end
    else//������ֵʧ��
      exit;
    CloseKey;
    //�ҵ��򴴽�Software\ODBC\ODBC.INI\MyAccess\Engines\Jet
    //д��DSN���ݿ�����������Ϣ
    if OpenKey('Software\ODBC\ODBC.INI\' + sDsnName + '\Engines\Jet',True) then
    begin
      WriteString( 'ImplicitCommitSync', 'Yes' );
      WriteInteger( 'MaxBufferSize', 512 );//��������С
      WriteInteger( 'PageTimeout', 10 );//ҳ��ʱ
      WriteInteger( 'Threads', 3 );//֧�ֵ��߳���Ŀ
      WriteString( 'UserCommitSync', 'Yes' );
    end
    else//������ֵʧ��
      exit;
    CloseKey;
    Free;
  end;
  Result := true;
end;

//_____________________________________________________________________//

// ��ȡָ�����ֵ�ƴ��������ĸ���磺��������������ĸ�ǡ�H��
function GetPYIndexChar(hzchar:string): char;
begin
  case WORD(hzchar[1]) shl 8 + WORD(hzchar[2]) of
    $B0A1..$B0C4 : result := 'A';
    $B0C5..$B2C0 : result := 'B';
    $B2C1..$B4ED : result := 'C';
    $B4EE..$B6E9 : result := 'D';
    $B6EA..$B7A1 : result := 'E';
    $B7A2..$B8C0 : result := 'F';
    $B8C1..$B9FD : result := 'G';
    $B9FE..$BBF6 : result := 'H';
    $BBF7..$BFA5 : result := 'J';
    $BFA6..$C0AB : result := 'K';
    $C0AC..$C2E7 : result := 'L';
    $C2E8..$C4C2 : result := 'M';
    $C4C3..$C5B5 : result := 'N';
    $C5B6..$C5BD : result := 'O';
    $C5BE..$C6D9 : result := 'P';
    $C6DA..$C8BA : result := 'Q';
    $C8BB..$C8F5 : result := 'R';
    $C8F6..$CBF9 : result := 'S';
    $CBFA..$CDD9 : result := 'T';
    $CDDA..$CEF3 : result := 'W';
    $CEF4..$D188 : result := 'X';
    $D1B9..$D4D0 : result := 'Y';
    $D4D1..$D7F9 : result := 'Z';
  else
    result := char(32);
  end;
end;

function CnToPY(const sChinese: string): string;
var
  I: Integer;
  PY: string;
  s: string;
begin
  s := '' ;
  I := 1;
  while I <= Length(sChinese) do
  begin
    PY := Copy(sChinese, I , 1);
    if PY >= Chr(128) then
    begin
      Inc(I);
      PY := PY + Copy(sChinese, I , 1);
      s := s + GetPYIndexChar(PY);
    end
    else
      s := s + PY;
    Inc(I);
  end;
  Result := s;
end;

//_____________________________________________________________________//

procedure AddIcoToIE(const sExePath, sShowText, sIcon, sOverIcon: string);
var
  rg: TRegistry;
begin
   rg := Tregistry.Create;
   try
     rg.RootKey := HKEY_LOCAL_MACHINE;
     rg.OpenKey('SOFTWARE\MICROSOFT\INTERNET EXPLORER\EXTENSIONS\{0713E8D2-850A-101B-AFC0-4210102A8DA7}',true);
     rg.WriteString('BUTTONTEXT', sShowText);
     rg.WriteString('CLSID', '{1FBA04EE-3024-11D2-8F1F-0000F87ABD16}');
     rg.WriteString('DEFAULT VISIBLE', 'YES');
     rg.WriteString('EXEC', sExePath);
     rg.WriteString('ICON', sIcon);
     rg.WriteString('HOTICON', sOverIcon);
     rg.CloseKey;
   finally
     rg.Free;
   end;
end;

//_____________________________________________________________________//

function SetVolume(const sDriver, sLabel: string): Boolean;
begin
  Result := SetVolumeLabel(PChar(sDriver), PChar(sLabel));
end;

//_____________________________________________________________________//

const
  SHFMT_ID_DEFAULT = $FFFF;
  // Formating options
  SHFMT_OPT_QUICKFORMAT = $0000;
  SHFMT_OPT_FULL = $0001;
  SHFMT_OPT_SYSONLY = $0002;
  // Error codes
  SHFMT_ERROR = $FFFFFFFF;
  SHFMT_CANCEL = $FFFFFFFE;
  SHFMT_NOFORMAT = $FFFFFFFD;

function SHFormatDrive(Handle: HWND; Drive, ID, Options: Word): LongInt;
stdcall; external 'shell32.dll' name 'SHFormatDrive';

function FormatFloppy(): Boolean;
var
  retCode: LongInt;
begin
  retCode := SHFormatDrive(Application.Handle, 0, SHFMT_ID_DEFAULT, SHFMT_OPT_QUICKFORMAT);
  if retCode < 0 then
    Result := false
  else
    Result := true;
end;

//_____________________________________________________________________//

function IsAudioCD(const Drive: Char): bool;
var
  DrivePath: string;
  MaximumComponentLength: DWORD;
  FileSystemFlags: DWORD;
  VolumeName: string;
begin
  Result := false;
  DrivePath := Drive + ':\';
  if GetDriveType(PChar(DrivePath)) <> DRIVE_CDROM then exit;
  SetLength(VolumeName, 64);
  GetVolumeInformation(PChar(DrivePath),
    PChar(VolumeName),
    Length(VolumeName),
    nil,
    MaximumComponentLength,
    FileSystemFlags,
    nil,
    0);
  if lStrCmp(PChar(VolumeName),'Audio CD') = 0 then result := true;
end;

//_____________________________________________________________________//

function PlayAudioCD(const Drive: Char): bool;
var
  mp: TMediaPlayer;
begin
  Result := false;
  Application.ProcessMessages;
  if not IsAudioCD(Drive) then exit;
  mp := TMediaPlayer.Create(nil);
  mp.Visible := false;
  mp.Parent := Application.MainForm;
  mp.Shareable := true;
  mp.DeviceType := dtCDAudio;
  mp.FileName := Drive + ':';
  mp.Shareable := true;
  mp.Open;
  Application.ProcessMessages;
  mp.Play;
  Application.ProcessMessages;
  mp.Close;
  Application.ProcessMessages;
  mp.free;
  Result := true;
end;

//_____________________________________________________________________//

function DiskInDrive(Drive: Char): Boolean;
var
  ErrorMode: word;
begin
  { make it upper case }
  if Drive in ['a'..'z'] then Dec(Drive, $20);
  { make sure it's a letter }
  if not (Drive in ['A'..'Z']) then
    raise EConvertError.Create('Not a valid drive ID');
  { turn off critical errors }
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    { drive 1 = a, 2 = b, 3 = c, etc. }
    if DiskSize(Ord(Drive) - $40) = -1 then
      Result := False
    else
      Result := True;
  finally
    { restore old error mode }
    SetErrorMode(ErrorMode);
  end;
end;

//_____________________________________________________________________//

function CheckDriverType(const sDriver: string): string;
var
  x: integer;
begin
  x := GetDriveType(PChar(sDriver + ':'));
  case x of
    2: Result := '���������ǿ��ƶ�������';
    3: Result := '���������ǹ̶�������';
    4: Result := '��������������������';
    5: Result := '����������CD-ROM������';
    6: Result := '��������������������';
  else
    Result := '����������Ч';
  end;
end;

//_____________________________________________________________________//

function IsFileInUse(const fName: string): Boolean;
var
  HFileRes: HFILE;
begin
  Result := false;
  if not FileExists(fName) then exit;
  HFileRes := CreateFile(pchar(fName), GENERIC_READ or GENERIC_WRITE,
    0 {this is the trick!}, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then CloseHandle(HFileRes);
end;

//_____________________________________________________________________//

//����Ŀ¼�ĵݹ鸨��������DoCopyDir
function DoCopyDir(const sDirName, sToDirName: string): Boolean;
var
  hFindFile: Cardinal;
  //hFindFile: TSearchRec;
  t, tfile: string;
  sCurDir: string[255];
  FindFileData: WIN32_FIND_DATA;
begin
  Result := false;
  //�ȱ��浱ǰĿ¼
  sCurDir := GetCurrentDir;
  ChDir(sDirName);
  hFindFile := FindFirstFile('*.*', FindFileData);
  if hFindFile <> INVALID_HANDLE_VALUE then
  begin
    if not DirectoryExists(sToDirName) then ForceDirectories(sToDirName);
    repeat
      tfile := FindFileData.cFileName;
      if (tfile = '.') or (tfile = '..') then Continue;
      if FindFileData.dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY then
      begin
        t := sToDirName + '\' + tfile;
        if not DirectoryExists(t) then ForceDirectories(t);
        if sDirName[Length(sDirName)] <> '\' then
          DoCopyDir(sDirName + '\' + tfile, t)
        else
          DoCopyDir(sDirName + tfile, sToDirName + tfile);
      end
      else begin
        t := sToDirName + '\' + tFile;
        CopyFile(PChar(tfile), PChar(t), True);
      end;
    until FindNextFile(hFindFile, FindFileData) = false;
    //FindClose(hFindFile);
  end
  else begin
    ChDir(sCurDir);
    exit;
  end;
  //�ص�ԭ����Ŀ¼��
  ChDir(sCurDir);
  Result := true;
end;

//����Ŀ¼�ĺ�����CopyDir
function CopyDir(const sDirName, sToDirName: string): Boolean;
begin
  Result := false;
  if Length(sDirName) <= 0 then exit;
  //����...
  Result := DoCopyDir(sDirName, sToDirName);
end;

//_____________________________________________________________________//

{
//ɾ��Ŀ¼�ĵݹ鸨��������DoRemoveDir
function DoRemoveDir(const sDirName: string): Boolean;
var
  hFindFile: Cardinal;
  tfile: string;
  sCurDir: string;
  bEmptyDir: Boolean;
  FindFileData: WIN32_FIND_DATA;
begin
  //���ɾ�����ǿ�Ŀ¼,����bEmptyDirΪTrue
  //��ʼʱ,bEmptyDirΪTrue
  bEmptyDir := True;
  //�ȱ��浱ǰĿ¼
  sCurDir := GetCurrentDir;
  SetLength(sCurDir, Length(sCurDir));
  ChDir(sDirName);
  hFindFile := FindFirstFile('*.*', FindFileData);
  if hFindFile <> INVALID_HANDLE_VALUE then
  begin
    repeat
      tfile := FindFileData.cFileName;
      if (tfile = '.') or (tfile = '..') then
      begin
        bEmptyDir := bEmptyDir and True;
        Continue;
      end;
      //���ǿ�Ŀ¼,��bEmptyDirΪFalse
      bEmptyDir := False;
      if FindFileData.dwFileAttributes = FILE_ATTRIBUTE_DIRECTORY then
      begin
        if sDirName[Length(sDirName)] <> '\' then
          DoRemoveDir(sDirName + '\' + tfile)
        else
          DoRemoveDir(sDirName + tfile);
        if not RemoveDirectory(PChar(tfile)) then
          Result := false
        else
          Result := true;
      end
      else begin
        if not DeleteFile(PChar(tfile)) then
          Result := false
        else
          Result := true;
      end;
    until FindNextFile(hFindFile, FindFileData) = false;
    //FindClose(hFindFile);
  end
  else begin
    ChDir(sCurDir);
    Result := false;
    exit;
  end;
  //����ǿ�Ŀ¼,��ɾ���ÿ�Ŀ¼
  if bEmptyDir then
  begin
    //������һ��Ŀ¼
    ChDir('..');
    //ɾ����Ŀ¼
    RemoveDirectory(PChar(sDirName));
  end;
  //�ص�ԭ����Ŀ¼��
  ChDir(sCurDir);
  Result := true;
end;

//ɾ��Ŀ¼�ĺ�����DeleteDir
function DeleteDir(const sDirName: string): Boolean;
begin
  Result := false;
  if Length(sDirName) <= 0 then exit;
  //ɾ��...
  Result := DoRemoveDir(sDirName) and RemoveDir(sDirName);
end;
}

//_____________________________________________________________________//

function CreateTempFile(const sPath: string): string;
var
  TempFileName: PChar;
  DriveName: PChar;
begin
  DriveName := PChar(sPath);
  GetMem(TempFileName, 256);
  GetTempFileName(DriveName, 'text', 0, TempFileName);
  Result := TempFileName;
end;

//_____________________________________________________________________//

{1�� ��������¼���ж��Ƿ�����Ŀ¼��}

function IsValidDir(SearchRec:TSearchRec):Boolean;
begin
  if (SearchRec.Attr=16) and (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
    Result:=True
  else
    Result:=False;
end;

{
2.���ǲ�ѯ���庯����

�������ܣ�

Mainpath�� ָ���Ĳ�ѯĿ¼��

Filename�� ����ѯ���ļ���

Foundresult�� ���صĺ�����·����ƥ���ļ��������ж������

�����ƥ���ļ�����������True�����򣬷���False;
}

function SearchFile(mainpath: string; filename: string; var foundresult: TStrings): Boolean;
var
  i: integer;
  Found: Boolean;
  subdir1: TStrings;
  searchRec: TsearchRec;
begin
  found := false;
  if Trim(filename) <> '' then
  begin
    subdir1 := TStringList.Create;//�ַ����б���붯̬����
    try
      //�ҳ������¼���Ŀ¼��
      if (FindFirst(mainpath + '*.*', faDirectory, SearchRec) = 0) then
      begin
        if IsValidDir(SearchRec) then
          subdir1.Add(SearchRec.Name);
        while (FindNext(SearchRec) = 0) do
        begin
          if IsValidDir(SearchRec) then
          subdir1.Add(SearchRec.Name);
        end;
      end;
      FindClose(SearchRec);
      //���ҵ�ǰĿ¼��
      if FileExists(mainpath + filename) then
      begin
        found := true;
        foundresult.Add(mainpath + filename);
      end;
      //���ǵݹ鲿�֣����Ҹ���Ŀ¼��
      for i := 0 to subdir1.Count - 1 do
      found := Searchfile(mainpath + subdir1.Strings[i] +
        '\', Filename, foundresult) or found;
    finally
      //��Դ�ͷŲ����ؽ����
      subdir1.Free;
    end;
  end;
  Result := found;
end;

//_____________________________________________________________________//


//uses
  {$IFDEF WIN32}
  //Registry; {We will get it from the registry}
  {$ELSE}
  //IniFiles; {We will get it from the win.ini file}
  {$ENDIF}


{$IFNDEF WIN32}
const MAX_PATH = 144;
{$ENDIF}

function GetProgramAssociation(Ext: string): string;
var
  {$IFDEF WIN32}
  reg: TRegistry;
  s: string;
  {$ELSE}
  WinIni: TIniFile;
  WinIniFileName: array[0..MAX_PATH] of char;
  s: string;
  {$ENDIF}
begin
  {$IFDEF WIN32}
  s := '';
  reg := TRegistry.Create;
  reg.RootKey := HKEY_CLASSES_ROOT;
  if reg.OpenKey('.' + ext + '\shell\open\command', false) <> false then
  begin
    {The open command has been found}
    s := reg.ReadString('');
    reg.CloseKey;
  end
  else begin
    {perhaps thier is a system file pointer}
    if reg.OpenKey('.' + ext, false) <> false then
    begin
      s := reg.ReadString('');
      reg.CloseKey;
      if s <> '' then
      begin
        {A system file pointer was found}
        if reg.OpenKey(s + '\shell\open\command', false) <> false then
          {The open command has been found}
          s := reg.ReadString('');
        reg.CloseKey;
      end;
    end;
  end;
  {Delete any command line, quotes and spaces}
  if Pos('%', s) > 0 then Delete(s, Pos('%', s), length(s));
  if ((length(s) > 0) and (s[1] = '"')) then Delete(s, 1, 1);
  if ((length(s) > 0) and (s[length(s)] = '"')) then
    Delete(s, Length(s), 1);
  while ((length(s) > 0) and ((s[length(s)] = #32) or (s[length(s)] = '"'))) do
    Delete(s, Length(s), 1);
  {$ELSE}
  GetWindowsDirectory(WinIniFileName, sizeof(WinIniFileName));
  StrCat(WinIniFileName, '\win.ini');
  WinIni := TIniFile.Create(WinIniFileName);
  s := WinIni.ReadString('Extensions', ext, '');
  WinIni.Free;
  {Delete any command line}
  if Pos(' ^', s) > 0 then
    Delete(s, Pos(' ^', s), length(s));
  {$ENDIF}
  Result := s;
end;

//_____________________________________________________________________//

function CovFileDate(Fd: _FileTime): TDateTime;
{ ת���ļ���ʱ���ʽ }
var
  Tct:_SystemTime;
  Temp:_FileTime;
begin
  FileTimeToLocalFileTime(Fd, Temp);
  FileTimeToSystemTime(Temp, Tct);
  CovFileDate := SystemTimeToDateTime(Tct);
end;

//��������ĺ���֧�֣����ǾͿ��Ի�ȡһ���ļ���ʱ����Ϣ�ˡ�������һ���򵥵����ӣ�
function myGetFileTime(const Tf: string): string;
{ ��ȡ�ļ�ʱ�䣬Tf��ʾĿ���ļ�·�������� }
const
  Model = 'yyyy/mm/dd,hh:mm:ss'; { �趨ʱ���ʽ }
var
  Tp: TSearchRec; { ����TpΪһ�����Ҽ�¼ }
  T1, T2, T3: string;
begin
  FindFirst(Tf, faAnyFile, Tp); { ����Ŀ���ļ� }
  T1 := FormatDateTime(Model, CovFileDate(Tp.FindData.ftCreationTime));
  { �����ļ��Ĵ���ʱ�� }
  T2 := FormatDateTime(Model, CovFileDate(Tp.FindData.ftLastWriteTime));
  { �����ļ����޸�ʱ�� }
  T3 := FormatDateTime(Model, Now);
  Result := t3;
  { �����ļ��ĵ�ǰ����ʱ�� }
  FindClose(Tp);
end;

//_____________________________________________________________________//

function SetFileDateTime(const Tf: string; const dCreateDate,
  tCreateTime, dModifyDate, tModifyTime: TDateTime): Boolean;
{ �����ļ�ʱ�䣬Tf��ʾĿ���ļ�·�������� }
var
  Dt1, Dt2: Integer;
  Fs: TFileStream;
  Fct, Flt: TFileTime;
begin
  Dt1 := DateTimeToFileDate(Trunc(dCreateDate) + Frac(tCreateTime));
  Dt2 := DateTimeToFileDate(Trunc(dModifyDate) + Frac(tModifyTime));
  { ת���û�������DataTimePicker�е���Ϣ }
  try
    FS := TFileStream.Create(Tf, fmOpenReadWrite);
    try
      if DosDateTimeToFileTime(LongRec(DT1).Hi, LongRec(DT1).Lo, Fct) and
        LocalFileTimeToFileTime(Fct, Fct) and
        DosDateTimeToFileTime(LongRec(DT2).Hi, LongRec(DT2).Lo, Flt) and
        LocalFileTimeToFileTime(Flt, Flt) then
          SetFileTime(FS.Handle, @Fct, @Flt, @Flt);
          { �����ļ�ʱ������ }
      Result := true;
    finally
      FS.Free;
    end;
  except
    Result := false;
    //MessageDlg('�����޸Ĳ���ʧ�ܣ�', mtError, [mbOk], 0);
    { ��ΪĿ���ļ����ڱ�ʹ�õ�ԭ�������ʧ�� }
  end;
end;

//_____________________________________________________________________//

function GetFileLastAccessTime(const FileName: PChar): string;
var
  CreateFT, LastAccessFT, LastWriteFT: TFileTime;
  ST: TSystemTime;
  F: Integer;
begin
  { ����Ҫ��Windows�ı�׼API�����Զ���ʽ���ļ� }
  F := CreateFile(FileName, GENERIC_READ, 0,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  //if F = INVALID_HANDLE_VALUE then exit;
  { ȡ�ļ�ʱ�� }
  if GetFileTime(F, @CreateFT, @LastAccessFT, @LastWriteFT) then
  begin
    { ת��Ϊϵͳʱ�䲢��ʾ }
    FileTimeToSystemTime(LastAccessFT, ST);
    Result := Format('%d-%d-%d, %d:%d:%d',
    [ST.wYear, ST.wMonth, ST.wDay + 1,
    ST.wHour, ST.wMinute, ST.wSecond]);
  end;
  CloseHandle(F); // ��ס�ر��ļ�
end;

//_____________________________________________________________________//

procedure CreateDirectory(const sDirName: string);
begin
  MkDir(sDirName);
end;

//_____________________________________________________________________//

procedure ChangeDirectory(const sPath: string);
begin
  ChDir(sPath);
end;

//_____________________________________________________________________//

{
Value	Drive
---------------
0	Default
1	A
2	B
3	C
}
procedure GetDirectory(const iDrive: integer; var sPath: string);
begin
  GetDir(iDrive, sPath);
end;

//_____________________________________________________________________//

procedure SetCurrentDirectory(const sPath: string);
begin
  SetCurrentDir(sPath);
end;

//_____________________________________________________________________//

procedure RenameDirOrFile(const sFromName, sToName: string);
begin
  RenameFile(sFromName, sToName);
end;

//_____________________________________________________________________//

procedure CreateMultiDir(const sPath: string);
begin
  ForceDirectories(sPath);
end;

//_____________________________________________________________________//

function DirExist(const sDirName: string): Boolean;
begin
  Result := DirectoryExists(sDirName);
end;

//_____________________________________________________________________//

procedure ChangeFileExtension(const sPath, sExtName: string);
begin
  ChangeFileExt(sPath, sExtName);
end;

//_____________________________________________________________________//

function GetFileExtension(const sFileName: string): string;
begin
  Result := ExtractFileExt(sFileName);
end;

//_____________________________________________________________________//

{This way uses a File stream.}
procedure FileCopy1(const sourcefilename, targetfilename: string);
var
  S, T: TFileStream;
begin
  S := TFileStream.Create( sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create( targetfilename, fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
end;

//_____________________________________________________________________//

{This way uses memory blocks for read/write.}
procedure FileCopy2(const FromFile, ToFile: string);
var
  FromF, ToF: file;
  NumRead, NumWritten: integer;
  Buf: array[1..2048] of Char;
begin
  AssignFile(FromF, FromFile);
  Reset(FromF, 1);      { Record size = 1 }
  AssignFile(ToF, ToFile);   { Open output file }
  Rewrite(ToF, 1);      { Record size = 1 }
  repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromF);
  CloseFile(ToF);
end;

//_____________________________________________________________________//

{This one uses LZCopy, which USES LZExpand.}
procedure FileCopy3(const FromFileName, ToFileName: string);
var
  FromFile, ToFile: file;
begin
  AssignFile(FromFile, FromFileName); { Assign FromFile to FromFileName }
  AssignFile(ToFile, ToFileName); { Assign ToFile to ToFileName }
  Reset(FromFile); { Open file for input }
  try
    Rewrite(ToFile); { Create file for output }
    try
      { copy the file an if a negative value is returned }
      { raise an exception }
      if LZCopy(TFileRec(FromFile).Handle, TFileRec(ToFile).Handle) < 0
      then
      raise EInOutError.Create('Error using LZCopy')
    finally
      CloseFile(ToFile); { Close ToFile }
    end;
  finally
    CloseFile(FromFile); { Close FromFile }
  end;
end;

//_____________________________________________________________________//

procedure SetFileAttribAPI(const iMode: integer; const sFileName: PChar);
begin
  case iMode of
    1: SetFileAttributes(sFileName, FILE_ATTRIBUTE_ARCHIVE);
    2: SetFileAttributes(sFileName, FILE_ATTRIBUTE_HIDDEN);
    3: SetFileAttributes(sFileName, FILE_ATTRIBUTE_NORMAL);
    4: SetFileAttributes(sFileName, FILE_ATTRIBUTE_OFFLINE);
    5: SetFileAttributes(sFileName, FILE_ATTRIBUTE_READONLY);
    6: SetFileAttributes(sFileName, FILE_ATTRIBUTE_SYSTEM);
    7: SetFileAttributes(sFileName, FILE_ATTRIBUTE_TEMPORARY);
  end;
end;

//_____________________________________________________________________//

procedure SetFileAttrib(const iMode: integer; const sFileName: string);
begin
  case iMode of
    1: FileSetAttr(sFileName, faArchive);
    2: FileSetAttr(sFileName, faHidden);
    3: FileSetAttr(sFileName, faAnyFile);
    4: FileSetAttr(sFileName, faVolumeID);
    5: FileSetAttr(sFileName, faReadOnly);
    6: FileSetAttr(sFileName, faSysFile);
    7: FileSetAttr(sFileName, faDirectory);
  end;
end;

//_____________________________________________________________________//

//'\'��β
function GetFilePath1(const sFileName: string): string;
begin
  Result := ExtractFilePath(sFileName);
end;

//_____________________________________________________________________//

//û��'\'��β
function GetFilePath2(const sFileName: string): string;
begin
  Result := ExtractFileDir(sFileName);
end;

//_____________________________________________________________________//

function CopyDelRenMovFile(const iMode: integer; const sSource,
  sDestination: string; var blnAbortByUser: boolean): integer;
var
  ShFileOpStruct: TShFileOpStruct;
begin
  blnAbortByUser := false;
  FillChar(ShFileOpStruct, sizeof(ShFileOpStruct), 0);  //��������
  with ShFileOpStruct do
  begin
    Wnd := Application.MainForm.Handle;      //�����ھ����ֵ
    case iMode of
      1: wFunc := FO_COPY;   //�����ļ�
      2: wFunc := FO_DELETE; //ɾ���ļ�
      3: wFunc := FO_RENAME; //�����ļ���
      4: wFunc := FO_MOVE;   //�ƶ��ļ�
      else begin
        Result := -1;
        exit;
      end;
    end;
    //sSourceΪԴ�ļ���
    pFrom := PChar(sSource);
    //sDestinationĿ���ļ�
    pTo := PChar(sDestination);
    //��������������ʾ���ȣ��ļ���
    fFlags := fFlags or FOF_ALLOWUNDO or FOF_SIMPLEPROGRESS;
      //or FOF_RENAMEONCOLLISION; //�������Զ�����

    //���ÿ������ȴ������
    lpszProgressTitle := (PChar('�� ' + sSource + ' �� ' + sDestination));
    //ִ������
    Result := ShFileOperation(ShFileOpStruct);
    //fAnyOperationsAborted��ʾ�Ƿ��û��жϿ���
    blnAbortByUser := fAnyOperationsAborted;
  end;
end;

//_____________________________________________________________________//

procedure GetPortUsed(var stComList: TStrings);
var
  reg: TRegistry;
  ts: TStrings;
  i: integer;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('hardware\devicemap\serialcomm',false);
    ts := TStringList.Create;
    try
      reg.GetValueNames(ts); //����Ӽ��µ�������
      stComList := TStringList.Create;
      for i := 0 to ts.Count - 1 do
        stComList.Add(reg.ReadString(ts.Strings[i]));
    finally
      ts.Free;
    end;
  finally
    reg.CloseKey;
    reg.free;
  end;
end;

//_____________________________________________________________________//

procedure SetMediaAudioOff(const DeviceID: word);
var
  SetParm: TMCI_SET_PARMS;
begin
  SetParm.dwAudio := MCI_SET_AUDIO_ALL;
  mciSendCommand(DeviceID,
  MCI_SET,
  MCI_SET_AUDIO or MCI_SET_OFF,
  Longint(@SetParm));
end;

//_____________________________________________________________________//

procedure SetMediaAudioOn(const DeviceID: word);
var
  SetParm: TMCI_SET_PARMS;
begin
  SetParm.dwAudio := MCI_SET_AUDIO_ALL;
  mciSendCommand(DeviceID,
  MCI_SET,
  MCI_SET_AUDIO or MCI_SET_ON,
  Longint(@SetParm));
end;

//_____________________________________________________________________//

procedure WaitExeFinish(const sExeName: string);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  //ShowMessage('Ready to launch NotePad...');
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  CreateProcess( nil, PChar(sExeName), nil, nil, False, 0,
    nil, nil, StartupInfo, ProcessInfo);
  with ProcessInfo do
  begin
    CloseHandle(hThread);
    WaitForSingleObject(hProcess, INFINITE);
    CloseHandle(hProcess);
  end;
  //ShowMessage('NotePad has terminated.');
end;

//_____________________________________________________________________//

end.
