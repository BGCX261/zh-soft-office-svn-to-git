unit ZhPubUtils;

interface

uses
  Windows, Classes, ComCtrls, SysUtils, ComStrs, TlHelp32, ZhFileTreeImpl;

  procedure StreamWriteInteger(Stream: TStream; Value: Integer);
  function StreamReadInteger(Stream: TStream): Integer;
  procedure StreamWriteByte(Stream: TStream; Value: Byte);
  function StreamReadByte(Stream: TStream): Byte;
  procedure StreamWriteString(Stream: TStream; Value: string);
  function StreamReadString(Stream: TStream): string;
  procedure StreamWriteResInfo(Stream: TStream; ResInfo: TResInfo);
  function StreamReadResInfo(Stream: TStream): TResInfo;
  procedure StreamWriteTreeNodes(Stream: TStream; TreeNodes: TTreeNodes);
  procedure StreamReadTreeNodes(Stream: TStream; TreeNodes: TTreeNodes);

  function FormatDirectoryName(Dir: string): string;
  function FileInUsing(FileName: string): Boolean;
  procedure KillProcess(ExeName: string);

implementation

procedure StreamWriteInteger(Stream: TStream; Value: Integer);
begin
  Stream.Write(Value, sizeof(Integer));
end;

function StreamReadInteger(Stream: TStream): Integer;
begin
  Stream.Read(Result, sizeof(Integer));
end;

procedure StreamWriteByte(Stream: TStream; Value: Byte);
begin
  Stream.Write(Value, sizeof(Byte));
end;

function StreamReadByte(Stream: TStream): Byte;
begin
  Stream.Read(Result, sizeof(Byte));
end;

procedure StreamWriteString(Stream: TStream; Value: string);
var
  Len: Integer;
begin
  Len:= Length(Value);
  StreamWriteInteger(Stream, Len);
  Stream.Write(Value[1], Len);
end;

function StreamReadString(Stream: TStream): string;
var
  Len: Integer;
begin
  Len:= StreamReadInteger(Stream);
  SetLength(Result, Len);
  Stream.Read(Result[1], Len);
end;

procedure StreamWriteResInfo(Stream: TStream; ResInfo: TResInfo);
begin
  with ResInfo do
  begin
    StreamWriteString(Stream, FileName);   // 包括相对路径(如MyDir\Myfile.exe)
    StreamWriteString(Stream, Description);// 描述信息
    StreamWriteInteger(Stream, FileSize);  // 文件大小　
    StreamWriteInteger(Stream, FileAttr);  // 文件属性
    StreamWriteString(Stream, Version);    // 版本号(IP地址格式)
    StreamWriteByte(Stream, Byte(ResType));// 资源文件类型
    StreamWriteString(Stream, DownloadURL);// 资源的相对下载路径
  end;
end;

function StreamReadResInfo(Stream: TStream): TResInfo;
begin
  with Result do
  begin
    FileName:= StreamReadString(Stream);   // 包括相对路径(如MyDir\Myfile.exe)
    Description:= StreamReadString(Stream);// 描述信息
    FileSize:=  StreamReadInteger(Stream); // 文件大小　
    FileAttr:= StreamReadInteger(Stream);  // 文件属性
    Version:= StreamReadString(Stream);    // 版本号(IP地址格式)
    ResType:= TResType(StreamReadByte(Stream)); // 资源文件类型
    DownloadURL:= StreamReadString(Stream); // 资源的相对下载路径
  end;
end;

procedure StreamWriteTreeNodes(Stream: TStream; TreeNodes: TTreeNodes);
const
  TabChar = #9;
  EndOfLine = #13#10;
var
  i: Integer;
  ANode: TTreeNode;
  NodeStr: string;
  ms: TStream;
begin
  ms:= TMemoryStream.Create;
  try
    if TreeNodes.Count > 0 then
    begin
      ANode := TreeNodes[0];
      while ANode <> nil do
      begin
        NodeStr := '';
        for i := 0 to ANode.Level - 1 do
          NodeStr := NodeStr + TabChar;
        NodeStr := NodeStr + ANode.Text + EndOfLine;
        ms.Write(Pointer(NodeStr)^, Length(NodeStr));
        ANode := ANode.GetNext;
      end;
    end;
    StreamWriteInteger(Stream, ms.Size);
    Stream.CopyFrom(ms, 0);
  finally
    ms.Free;
  end;
end;

procedure StreamReadTreeNodes(Stream: TStream; TreeNodes: TTreeNodes);

  function GetBufStart(Buffer: PChar; var Level: Integer): PChar;
  begin
    Level := 0;
    while Buffer^ in [' ', #9] do
    begin
      Inc(Buffer);
      Inc(Level);
    end;
    Result := Buffer;
  end;

var
  List: TStringList;
  ANode, NextNode: TTreeNode;
  ALevel, I, C: Integer;
  CurrStr: string;
  ms: TMemoryStream;
begin
  List := TStringList.Create;
  TreeNodes.BeginUpdate;
  try
    try
      TreeNodes.Clear;
      ms:= TMemoryStream.Create;
      try
        C:= StreamReadInteger(Stream);
        ms.CopyFrom(Stream, C);
        ms.Position:= 0;
        List.LoadFromStream(ms);
        ANode := nil;
        for I := 0 to List.Count - 1 do
        begin
          CurrStr := GetBufStart(PChar(List[I]), ALevel);
          if ANode = nil then
            ANode := TreeNodes.AddChild(nil, CurrStr)
          else if ANode.Level = ALevel then
            ANode := TreeNodes.AddChild(ANode.Parent, CurrStr)
          else if ANode.Level = (ALevel - 1) then
            ANode := TreeNodes.AddChild(ANode, CurrStr)
          else if ANode.Level > ALevel then
          begin
            NextNode := ANode.Parent;
            while NextNode.Level > ALevel do
              NextNode := NextNode.Parent;
            ANode := TreeNodes.AddChild(NextNode.Parent, CurrStr);
          end
          else
            raise ETreeViewError.CreateFmt(sInvalidLevelEx, [ALevel, CurrStr]);
        end;
      finally
        ms.Free;
      end;
    finally
      TreeNodes.EndUpdate;
      List.Free;
    end;
  except
    TreeNodes.Owner.Invalidate;  // force repaint on exception
    raise;
  end;
end;

function FormatDirectoryName(Dir: string): string;
begin
  if Dir[Length(Dir)] <> '\' then
    Result:= Dir + '\'
  else
    Result:= Dir;
end;

function FileInUsing(FileName: string): Boolean;
var
  F: Integer;
begin
  F:= FileOpen(FileName, fmOpenReadWrite or fmShareExclusive);
  if F = -1 then
    Result:= False
  else
  begin
    FileClose(F);
    Result:= True;
  end;
end;

procedure KillProcess(ExeName: string);
const
  PROCESS_TERMINATE = $0001; //进程的PROCESS_TERMINATE访问权限
var
  ContinueLoop: Boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  //获取系统所有进程快照
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  //调用Process32First前用Sizeof(FProcessEntry32)填充FProcessEntry32.dwSize
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  //获取快照中第一个进程信息并保存到FProcessEntry32结构体中
  ContinueLoop := Process32First(FSnapshotHandle,FProcessEntry32);
  while integer(ContinueLoop) <> 0 do //循环枚举快照中所有进程信息
  begin
    //找到要中止的进程名
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeName))
      or (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeName))) then
       TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),FProcessEntry32.th32ProcessID), 0);     //中止进程
    ContinueLoop := Process32Next(FSnapshotHandle,FProcessEntry32); //查找下一个符合条件进程
  end;
end;

end.
