unit FrameDataAccessImpl;

interface

uses Classes,SysUtils,Db,AdoDb,DbClient,CoreImpl;

type
  TFrameDataAccessImpl=class(TObject)
  public
    class procedure LoadModuleFromDatabase(AModuleSearcher:TModuleSearcher);
    class procedure LoadTableFromDatabase(AModuleItem:TModuleItem);
    class procedure LoadFieldFromDatabase(ATableItem:TTableItem);
    class procedure AddField(ATableItem:TTableItem;
            AFieldName:string;
            ADisplayLabel:string ;
            ADataType:TDataType;
            ACalcType:TCalcType;
            ASize:Integer ;
            AIsKey:Boolean ;
            AIsUnique:Boolean ;
            AIsShow:Boolean ;
            AIsEdit:Boolean ;
            AAllowNull:Boolean ;
            AIsPassword:Boolean ;
            AColIndex:Integer ;
            AShowWidth:Integer;
            AisDefault:Boolean ;
            ADefaultValue:Variant ;
            ADisplayFormat:string ;
            AEditFormat:string ;
            AFooter:TFooterType ;
            ATabOrder:Integer;
            ADictionary:string ;
            AShowField:string ;
            ALinkFieldName:string ;
            AKeyFieldName:string;
            AIsLinkMaster:boolean ;
            AMasterField:string               
            );overload ; 

    class procedure AddField(AFieldItems:TFieldItems ;
        AFieldName: string;
        ADisplayLabel: string;
        AIsKey:Boolean ;
        AIsShow: Boolean;
        AIsBrowseShow : Boolean;
        AShowWidth:integer
        ) ;overload ;

    class procedure AddField(ATableItem:TTableItem;
        AFieldName: string;
        ADisplayLabel: string;
        AIsKey:Boolean ;
        AIsShow: Boolean;
        AColIndex:integer;
        AShowWidth:integer
        ) ;overload ;           
  end;
implementation
uses EnvironmentImpl;
{ TFrameDataAccessImpl }


class procedure TFrameDataAccessImpl.AddField(ATableItem: TTableItem;
  AFieldName, ADisplayLabel: string; ADataType: TDataType;
  ACalcType: TCalcType; ASize: Integer; AIsKey,AIsUnique, AIsShow, AIsEdit,
  AAllowNull, AIsPassword: Boolean; AColIndex, AShowWidth: Integer;
  AisDefault:Boolean ;ADefaultValue: Variant; ADisplayFormat, AEditFormat: string;
  AFooter: TFooterType; ATabOrder: Integer; ADictionary, AShowField,
  ALinkFieldName, AKeyFieldName: string;
  AIsLinkMaster:boolean ;AMasterField:string);
var
  Item:TFieldItem;
begin
  Item:=ATableItem.CreateFieldItem(ATableItem);
  Item.Table:=ATableItem.Code ;
  Item.FieldName:=AFieldName;
  Item.DisplayLabel:=ADisplayLabel ;
  Item.DataType:=ADataType;
  Item.CalcType:=ACalcType;
  Item.Size:=ASize ;
  Item.IsKey:=AIsKey ;
  Item.IsUnique:=AIsUnique ;
  Item.IsShow:=AIsShow ;
  Item.IsEdit:=AIsEdit ;
  Item.AllowNull:=AAllowNull ;
  Item.IsPassword:=AIsPassword ;
  Item.ColIndex:=AColIndex ;
  Item.ShowWidth:=AShowWidth;
  Item.isDefault:=AisDefault ;
  Item.DefaultValue:=ADefaultValue ;
  Item.DisplayFormat:=ADisplayFormat ;
  Item.EditFormat:=AEditFormat ;
  Item.Footer:=AFooter ;
  Item.TabOrder:=ATabOrder ;
  Item.Dictionary:=ADictionary ;
  Item.ShowField:=AShowField ;
  Item.LinkFieldName:=ALinkFieldName ;
  Item.KeyFieldName:=AKeyFieldName ;
  Item.IsLinkMaster:= AIsLinkMaster;
  Item.MasterField:= AMasterField;
  ATableItem.FieldItems.Add(Item.FieldName,Item.DisplayLabel,Item);

end;



class procedure TFrameDataAccessImpl.AddField(AFieldItems: TFieldItems;
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

class procedure TFrameDataAccessImpl.AddField(ATableItem: TTableItem;
  AFieldName, ADisplayLabel: string; AIsKey, AIsShow:boolean;
  AColIndex,AShowWidth: integer);
var
  FieldItem:TFieldItem ;
begin
  FieldItem:=ATableItem.CreateFieldItem(ATableItem);
  FieldItem.FieldName:=AFieldName ;
  FieldItem.DisplayLabel:=ADisplayLabel;
  FieldItem.IsKey := AIsKey ;
  FieldItem.IsShow:=AIsShow;
  FieldItem.ColIndex :=AColIndex ;
  FieldItem.ShowWidth :=AShowWidth ;
  FieldItem.DataType:=dtString ;

  ATableItem.FieldItems.Add(FieldItem.FieldName,FieldItem.DisplayLabel,FieldItem);
end;

class procedure TFrameDataAccessImpl.LoadFieldFromDatabase(
  ATableItem: TTableItem);
const
  Select_Field_Sql='select vc_fieldcode, vc_tablecode, vc_fieldname, i_resid,'
    +' ti_datatype, i_fieldsize, vc_describe, ti_decimal, vc_default,'
    +' b_key, b_unique, b_allownull, b_autoincrement, i_autoincrementstep, '
    +' vc_calctype, vc_formula, vc_displayformat, vc_editformat, vc_ctrltype,'
    +' vc_dictcode, vc_showfield, vc_LinkField, vc_KeyField, b_password, b_showed,'
    +' b_browseshow, b_edit, b_tabstop, i_taborder, i_foottype, i_row, i_column,'
    +' i_width, b_standardout, vc_linkmodule,vc_sheet,b_linkmaster,vc_masterfield from us_fields '
    +' where vc_tablecode=''%s''';
var
  Item:TFieldItem;
  DataSet:TClientDataSet;
begin
  ATableItem.FieldItems.Clear;
  
  with _Environment.DataAccess do
  begin
    SelectSql(Format(Select_Field_Sql,[ATableItem.Code]),DataSet);
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        Item:=ATableItem.CreateFieldItem(ATableItem);
        Item.FieldName:=DataSet.FieldByName('vc_fieldname').AsString;
        Item.Table:=DataSEt.FieldByName('vc_tablecode').AsString;
        Item.DisplayLabel:=DataSet.FieldByName('vc_DisplayLabel').AsString;
        Item.ResId:=DataSet.FieldByName('i_resid').AsInteger;
        Item.DataType:=TDataType(DataSet.FieldByName('ti_datatype').AsInteger);
        Item.Size:=DataSet.FieldByName('i_fieldsize').AsInteger;
        Item.Describe:=DataSet.FieldByName('vc_describe').AsString;
        Item.Decimal:=DataSet.FieldByName('ti_decimal').AsInteger;
        Item.DefaultValue:=DataSet.FieldByName('vc_default').Value;
        Item.IsKey:=DataSet.FieldByName('b_key').AsBoolean;
        Item.IsUnique:=DataSet.FieldByName('b_unique').AsBoolean;
        Item.AllowNull:=DataSet.FieldByName('b_allownull').AsBoolean;
        Item.AutoIncrement:=DataSet.FieldByName('b_autoincrement').AsBoolean;
        Item.AutoIncrementStep:=DataSet.FieldByName('i_autoincrementstep').AsInteger;
        Item.CtrlType:=TVirtualCtrlType(DataSet.FieldByName('vc_ctrltype').AsInteger);
        Item.Formula:=DataSet.FieldByName('vc_formula').AsString;
        Item.CalcType:=TCalcType(DataSet.FieldByName('vc_calctype').asInteger);
        Item.DisplayFormat:=DataSEt.FieldByName('vc_displayformat').AsString;
        Item.EditFormat:=dataSEt.FieldByName('vc_editformat').AsString;
        Item.Dictionary:=DataSet.FieldByName('vc_dictcode').AsString;
        Item.ShowField:=DataSet.FieldByname('vc_showfield').AsString;
        Item.LinkFieldName:=DataSet.FieldByName('vc_LinkField').AsString;
        Item.KeyFieldName:=DataSet.FieldByName('vc_KeyField').AsString;
        Item.IsPassword:=DataSet.FieldByName('b_password').AsBoolean;
        Item.IsShow:=DataSet.FieldByName('b_showed').AsBoolean;
        Item.IsBrowseShow:=DataSet.FieldByName('b_browseshow').AsBoolean;
        Item.IsEdit:=DataSet.FieldByName('b_edit').AsBoolean;
        Item.TabStop:=DataSet.FieldByName('b_tabstop').AsBoolean;
        Item.TabOrder:=DataSet.FieldByName('i_taborder').AsInteger;
        Item.Footer:=TFooterType(DataSet.FieldByName('i_foottype').AsInteger);
        Item.RowIndex:=DataSet.FieldByName('i_row').AsInteger;
        Item.ColIndex:=DataSet.FieldByName('i_column').AsInteger;
        Item.ShowWidth:=DataSet.FieldByname('i_width').AsInteger;
        Item.IsStandOut:=DataSet.FieldByName('b_standardout').AsBoolean;
        Item.LinkModule:=DataSet.FieldByName('vc_linkmodule').AsString;
        Item.IsLinkMaster:=DataSet.FieldByName('b_linkmaster').AsBoolean;
        Item.MasterField:=DataSet.FieldByName('vc_masterfield').AsString;
        ATableItem.FieldItems.Add(Item.FieldName,Item.DisplayLabel,Item);
        DataSet.Next;
      end;
    finally
      DataSet.Free;
    end;
  end;  
end;

class  procedure TFrameDataAccessImpl.LoadModuleFromDatabase(
  AModuleSearcher: TModuleSearcher);
const
  Select_Module_Sql='select  vc_modulecode, vc_templetcode, vc_categorycode,'
    +' vc_factcode, vc_modulename, vc_username2, vc_mnemonic, i_resid, b_isfunction,'
    +' b_shortcutshow, b_toolbarshow, vc_plugIn, vc_icon, i_program, vc_describe, '
    +' vc_version, vc_systemic, bi_funcowner,vc_sheetOrder from us_modules';
var
  Item:TModuleItem;
  DataSet:TClientDataSet;
begin
  AModuleSearcher.Clear;
  with _Environment.DataAccess do
  begin
    SelectSql(Select_Module_Sql,DataSet);
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        Item:=TModuleItem.Create;
        Item.Code:=DataSet.FieldByName('vc_modulecode').AsString;
        Item.Name:=DataSet.FieldByName('vc_modulename').AsString;
        Item.Templet:=DataSet.FieldByName('vc_templetcode').AsString;
        Item.Category:=DataSet.FieldByName('vc_templetcode').AsString;
        Item.Command:=DataSet.FieldByName('vc_factcode').AsString;
        Item.Name2:=DataSet.FieldByName('vc_username2').AsString;
        Item.Mnemonic:=DataSet.FieldByName('vc_mnemonic').AsString;
        Item.ResId:=DataSet.FieldByName('i_resid').AsInteger;
        Item.IsFunc:=DataSet.FieldByName('b_isfunction').AsBoolean;
        Item.IsShowShortCut:=DataSet.FieldByName('b_shortcutshow').AsBoolean;
        Item.IsToolBar:=DataSet.FieldByName('b_toolbarshow').AsBoolean;
        Item.AddIn:=DataSet.FieldByName('vc_plugIn').AsString;
        Item.Icon:=DataSet.FieldByName('vc_icon').AsString;
        Item.Describe:=DataSet.FieldByName('vc_describe').AsString;
        Item.Version:=DataSet.FieldByName('vc_version').AsString;
        Item.BelongSys:=DataSet.FieldByName('i_program').AsInteger;
        Item.IsSystemic:=DataSet.FieldByName('vc_systemic').AsBoolean;
        Item.ChildFunc:=DataSet.fieldByname('bi_funcowner').AsInteger;
        AModuleSearcher.Add(Item.Code,Item.Name,Item);
        DataSet.Next;
      end;
    finally
      DataSet.Free;
    end;
  end;
end;


class procedure TFrameDataAccessImpl.LoadTableFromDatabase(
  AModuleItem: TModuleItem);
const
  Select_Table_Sql='select vc_tablecode, vc_factcode, vc_tablename, vc_tabletype, '
  +' vc_attribute, vc_describe, vc_adapt, i_resid from us_tables where vc_factcode=''%s''';
var
  Item:TTableItem;
  DataSet:TClientDataSet;
begin
  if(AModuleItem.Initialized)then Exit;
  AModuleItem.TableItems.Clear;
  with _Environment.DataAccess do
  begin
    SelectSql(Format(Select_Table_Sql,[AModuleItem.Command]),DataSet);
    try
      DataSet.First;
      while not DataSet.Eof do
      begin
        Item:=AModuleItem.CreateTableItem(AModuleItem);
        Item.Code:=DataSet.FieldByname('vc_tablecode').AsString;
        Item.Module:=DataSet.FieldByName('vc_factcode').AsString;
        Item.Name:=DataSet.FieldByName('vc_tablename').AsString;
        Item.TableType:=TTableType(DataSet.FieldByName('vc_tabletype').AsInteger);
        Item.ResId:=DataSet.FieldByName('i_resid').AsInteger;
        Item.Attribute:=TTableAttribute(DataSet.FieldByName('vc_attribute').AsInteger);
        Item.Describe:=DataSet.FieldByName('vc_describe').AsString;
        Item.Condition:=DataSet.FieldByname('vc_adapt').AsString;
        AModuleItem.TableItems.Add(Item.Code,Item.Name,Item);
        LoadFieldFromDatabase(Item);
        AModuleItem.Initialized:=True;
        DataSet.Next;
      end;
    finally
      DataSet.Free;
    end;
  end;
end;

end.
