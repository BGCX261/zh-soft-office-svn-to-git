unit uFunc;

interface
uses
  SysUtils,SysConst,Windows,StrUtils,Variants,VarUtils,Classes,DBClient,
  Controls,DB,uFieldItemImpl,dxmdaset,dmMain,Forms;

function ApplyUpdates(ADetla: Variant;
  ATableName, AKeyFields: string): Boolean;
function GetSql(ADelta: OleVariant; const ATableName,
  AKeyFields: string): string;
function IIF(lExp: boolean; vExp1,vExp2: variant): variant;
function ChooseDepositHeader(Const AWhereStr:string;AMultiSelect:boolean;var ARstData:TdxMemData):Boolean;
function SplitString(const source, ch: string): TStringList;
procedure MessageError(const Msg: string);
procedure MessageInform(const Msg: string);
function MessageConfirm(const Msg: string): Boolean;
implementation
uses
  uChooseFrm;

procedure MessageError(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), '错误', MB_ICONERROR);
end;

procedure MessageInform(const Msg: string);
begin
  Application.MessageBox(PChar(Msg), '信息', MB_ICONINFORMATION);
end;

function MessageConfirm(const Msg: string): Boolean;
begin
  Result := Application.MessageBox(PChar(Msg), '询问',
    MB_OKCANCEL + MB_ICONQUESTION + MB_DEFBUTTON2) = ID_OK;
end;


function IIF(lExp: boolean; vExp1, vExp2: variant): variant;
begin
  if lExp then Result := vExp1
  else Result := vExp2;
end;
function ApplyUpdates(ADetla: Variant;
  ATableName, AKeyFields: string): Boolean;
var
  ASql: string;
begin
  Result := False;
  try

    ASql := GetSql(ADetla, ATableName, AKeyFields);
    if ASql = EmptyStr then
      Exit;

    if not dm.ExecSql(ASql) then
      Exit;
  except
    on E: Exception do
    begin
      //SetLogTxt(e.Message);
      Exit;
    end;

  end;
  Result := True;
end;

function GetSql(ADelta: OleVariant; const ATableName,
  AKeyFields: string): string;
  function VarToSql(value: Variant): string;
  var
    s: string;
  begin
    if (VarIsNull(Value)) or (VarIsEmpty(Value)) then
      Result := EmptyStr
    else
      case Vartype(value) of
        varDate:
          begin
            s := FormatDateTime('yyyy-mm-dd hh:mm:ss', VartoDatetime(Value));
            Result := Quotedstr(s);
          end;
        varString, varOlestr:
          Result := Quotedstr(Trim(Vartostr(Value)));
        varBoolean:
          begin
            if Value then
              Result := '1'
            else
              Result := '0';
          end;
        varSmallint, varInteger, varDouble, varShortInt, varInt64, varLongWord,
          varCurrency:
          begin
            Result := Trim(Vartostr(Value));
          end;
      else
        Result := Quotedstr(Trim(Vartostr(Value)));
      end;
  end;
var
  i, j: integer;
  s1, s2: string;
  Cmdstr: string;
  FieldList, Keylist: TstringList;
  Cdsupdate: TClientDataSet;
  sqlstr: WideString;
  ADataSet: TClientDataSet;
begin
  sqlstr := EmptyStr;
  if VarIsNull(ADelta) then
    Exit;
  Cdsupdate := TClientDataSet.Create(nil);
  ADataSet := TClientDataSet.Create(nil);
  Cdsupdate.data := ADelta;
  if not Cdsupdate.Active then
    Cdsupdate.Open;
  try
    FieldList := TstringList.Create;
    Keylist := TstringList.Create;
    Keylist.Delimiter := ',';
    Keylist.DelimitedText := AKeyFields;

    try

      dm.SelectSql(Format('SELECT * FROM %s WHERE 1=0', [ATableName]),ADataSet);
      ADataSet.GetFieldNames(FieldList);
    finally
      if ADataSet <> nil then
        ADataSet.Free;
    end;

    for i := 1 to FieldList.Count do
      if Cdsupdate.FindField(FieldList[i - 1]) <> nil then
        Cdsupdate.FindField(FieldList[i - 1]).tag := 1;
    FreeAndNil(FieldList);

    if Cdsupdate.RecordCount > 0 then
    begin
      Cdsupdate.First;
      s1 := '';
      s2 := '';
      while not Cdsupdate.Eof do
      begin
        Cmdstr := '';

        case Cdsupdate.UpdateStatus of
          usUnmodified: //从原数据行取得修改条件
            begin
              s2 := '';
              for j := 1 to Keylist.Count do
              begin
                if s2 = '' then
                  s2 := Keylist[j - 1] + '=' + vartosql(Cdsupdate[Keylist[j -
                    1]])
                else
                  s2 := s2 + ' and ' + Keylist[j - 1] + '=' +
                    vartosql(Cdsupdate[Keylist[j - 1]]);
              end;
            end;

          usModified:
            begin
              s1 := '';
              for i := 1 to Cdsupdate.FieldCount do
              begin
                if (not Cdsupdate.Fields[i - 1].isNull) and (Cdsupdate.Fields[i
                  - 1].tag = 1) then
                begin
                  if s1 = '' then
                    s1 := Trim(Cdsupdate.Fields[i - 1].FieldName) + ' = ' +
                      vartosql(Cdsupdate.Fields[i - 1].value)
                  else
                    s1 := s1 + ',' + Trim(Cdsupdate.Fields[i - 1].FieldName) +
                      ' = ' + vartosql(Cdsupdate.Fields[i - 1].value);
                end;
              end;
              if s1 <> '' then
                Cmdstr := Format('UPDATE %s SET %s WHERE %s', [ATableName, s1,
                  s2]);
            end;

          usInserted:
            begin
              s1 := '';
              s2 := '';
              for i := 1 to Cdsupdate.FieldCount do
                if (not Cdsupdate.Fields[i - 1].isNull) and (Cdsupdate.Fields[i
                  - 1].tag = 1) then
                begin
                  if s1 = '' then
                  begin
                    s1 := Trim(Cdsupdate.Fields[i - 1].FieldName);
                    s2 := vartosql(Cdsupdate.Fields[i - 1].value);
                  end
                  else
                  begin
                    s1 := s1 + ',' + Trim(Cdsupdate.Fields[i - 1].FieldName);
                    s2 := s2 + ',' + vartosql(Cdsupdate.Fields[i - 1].value);
                  end;
                end;
              if s1 <> '' then
                Cmdstr := Format('INSERT INTO %s(%s) VALUES(%s)', [ATableName,
                  s1, s2]);
            end;
          usDeleted:
            begin
              s2 := '';
              for j := 1 to Keylist.Count do
              begin
                if s2 = '' then
                  s2 := Keylist[j - 1] + '=' + vartosql(Cdsupdate[Keylist[j -
                    1]])
                else
                  s2 := s2 + ' and ' + Keylist[j - 1] + '=' +
                    vartosql(Cdsupdate[Keylist[j - 1]]);
              end;
              Cmdstr := Format('DELETE FROM %s WHERE %s', [ATableName, s2]);
            end;
        end;
        if Cmdstr <> '' then
          sqlstr := sqlstr + Cmdstr + '#' ;
          //sqlstr := sqlstr + Cmdstr + ';' ;
        Cdsupdate.Next;
      end;
    end;
  finally
    FreeAndNil(Cdsupdate);
    FreeAndNil(keylist);
  end;
  Result := sqlstr;
end;

function ChooseDepositHeader(Const AWhereStr:string;AMultiSelect:boolean;var ARstData:TdxMemData):Boolean;
var

  ASql:string ;
  ADataSet:TClientDataSet ;
  AFieldItems:TFieldItems ;
begin
  ADataSet := TClientDataSet.Create(nil);
  AFieldItems := TFieldItems.Create(nil);
  try
     AFieldItems.Sorted :=  False;
     TFieldsImpl.AddField(AFieldItems,'DepositID','DepositID',True,False,False,0);
     TFieldsImpl.AddField(AFieldItems,'DepositCode','订单代码',False,True,False,90);
     TFieldsImpl.AddField(AFieldItems,'RevDeptName','订货单位',False,True,False,130);
     TFieldsImpl.AddField(AFieldItems,'DepositTime','订货时间',False,True,False,120);
     TFieldsImpl.AddField(AFieldItems,'TotalAmount','订单总金额',False,True,False,90);
     TFieldsImpl.AddField(AFieldItems,'RevUserName','联系人',False,True,False,80);
     TFieldsImpl.AddField(AFieldItems,'RevUserPhone','联系电话',False,True,False,80);
     TFieldsImpl.AddField(AFieldItems,'RevUserAddr','联系地址',False,True,False,100);
     TFieldsImpl.AddField(AFieldItems,'SendTime','送货时间',False,True,False,120);
     TFieldsImpl.AddField(AFieldItems,'SendDeptName','送货单位',False,True,False,150);
     ASql := Format('SELECT * FROM DepositHeader dh WHERE 1=1 AND %s',[AWhereStr]);
     if not dm.SelectSql(ASql,ADataSet) then Exit;
     Result := TChooseImpl.ShowChoose('预订单',ADataSet,AFieldItems,ARstData,AMultiSelect,True,False);
  finally
    if ADataSet <> nil then ADataSet.Free;
    if AFieldItems <> nil then AFieldItems.Free;
  end;

end;

function SplitString(const source, ch: string): TStringList;
var
  temp, t2: string;
  i: integer;
begin
  result := TStringList.Create;
  temp := source;
  i := pos(ch, source);
  while i <> 0 do
  begin
    t2 := copy(temp, 0, i - 1);
    if (t2 <> '') then
      result.Add(t2);
    delete(temp, 1, i - 1 + Length(ch));
    i := pos(ch, temp);
  end;
  result.Add(temp);
end;




end.
