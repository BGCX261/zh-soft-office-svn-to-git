unit DataAccessProvider;

interface

uses Classes,SysUtils,Variants;

type

  IConnectProvider=interface
  ['{8A42E5EB-953E-4BFD-B4E0-12C239B779A2}']
    function Get_MaxFieldCount: Integer;
    function Get_MaxTableCount: Integer;
    function Get_LastError: WideString;
    function GetFieldDefSQL(const FieldName: WideString; FieldType: Integer; FieldSize: Integer; 
                            DotLen: Integer; CanNull: WordBool; Data: OleVariant; 
                            IsPrimaryKey: WordBool): WideString; 
    function GetCreateIndexSQL(const TableName: WideString; Fields: OleVariant; 
                               const IndexName: WideString; IndexType: Integer; Data: OleVariant; 
                               Unique: WordBool): WideString;
    function GetRenameTableSQL(const OldTableName: WideString; const NewTableName: WideString): WideString;
    function GetDropFieldSQL(const TableName: WideString; const FieldNames: WideString): WideString;
    function GetCreateTableName(const TableName: WideString): WideString;
    function GetTopSelectSQL(const Fields: WideString; const TableName: WideString; 
                             const WhereCondition: WideString; const OrderCondition: WideString): WideString;
    function GetDate: WideString;
    function GetTableName(const TableName: WideString): WideString;
    function GetIndexName(const IndexName: WideString): WideString;
    function GetDataBaseSQL: WideString;
    function TableExists(const ATableName: WideString; const ASchema: WideString): WideString;
    function ProcedureExists(const AProcedureName:WideString; const ASchema: WideString): WideString;
    function FieldExists(const ATableName: WideString; const AField: WideString): WideString;
    function ReNameTable(const AOldName: WideString; const ANewName: WideString): WideString;
    function GetDropTableSQL(const ATableName: WideString): WideString;
    function GetFieldName(const AFieldName: WideString): WideString;
    function GetFieldValue(FieldType: Integer; Data: OleVariant): OleVariant;
    function GetFieldStringValue(FieldType: Integer; Data: OleVariant): WideString;
    function GetDropIndexSQL(const AIndexName: WideString; const ATableName: WideString): WideString;
    function GetAddFieldSQL(const AFieldName: WideString; AFieldType: Integer; AFieldSize: Integer; 
                            AFieldPrecision: Integer): WideString;
    function GetResetFiledSizeSQL(const AFieldName: WideString; AFieldSize: Integer): WideString;
    function Get_NeedReStructTable: WordBool;
    function GetAddFieldConnSQL(const ASQL: WideString; const ATableName: WideString): WideString;
    function GetIndexExistsSQL(const AIndexName: WideString): WideString;
    function GetUpdateFieldLengthSQL(const ATableName: WideString; const AFieldName: WideString;
                                     AOldLength: Integer; ANewLength: Integer): WideString;
    function GetAlterFieldSQL(const ATableName: WideString; const AFieldName: WideString;
                              AOleType: Integer; ANewType: Integer; AFieldLength: Integer; 
                              AIsNull: WordBool): WideString;
    function GetUpdateVarcharToDate(const ATableName: WideString; const AFieldName: WideString): WideString;
    function GetUpdateDateToVarcharSQL(const ATableName: WideString; const AFieldName: WideString;
                                       AFieldSize: Integer): WideString;
    function GetUpdateVarCharToNumSQL(const ATableName: WideString; const AFieldName: WideString): WideString;
    function GetSetFieldNullSQL(const ATableName: WideString; const AFieldName: WideString): WideString;
        property MaxFieldCount: Integer read Get_MaxFieldCount;
    property MaxTableCount: Integer read Get_MaxTableCount;
    property LastError: WideString read Get_LastError;
    property NeedReStructTable: WordBool read Get_NeedReStructTable;
  end;

  TAbstractConnectProvider=class(TInterfacedObject,IConnectProvider)
  protected
    function Get_MaxFieldCount: Integer;virtual;
    function Get_MaxTableCount: Integer;virtual;
    function Get_LastError: WideString;virtual;
    function GetFieldDefSQL(const FieldName: WideString; FieldType: Integer; FieldSize: Integer; 
                            DotLen: Integer; CanNull: WordBool; Data: OleVariant; 
                            IsPrimaryKey: WordBool): WideString ;virtual;
    function GetCreateIndexSQL(const TableName: WideString; Fields: OleVariant; 
                               const IndexName: WideString; IndexType: Integer; Data: OleVariant; 
                               Unique: WordBool): WideString;virtual;
    function GetRenameTableSQL(const OldTableName: WideString; const NewTableName: WideString): WideString;virtual;
    function GetDropFieldSQL(const TableName: WideString; const FieldNames: WideString): WideString;virtual;
    function GetCreateTableName(const TableName: WideString): WideString;virtual;

    function GetTopSelectSQL(const Fields: WideString; const TableName: WideString;
                             const WhereCondition: WideString; const OrderCondition: WideString): WideString; virtual;
    function GetDate: WideString;  virtual;
    function GetTableName(const TableName: WideString): WideString; virtual;
    function GetIndexName(const IndexName: WideString): WideString; virtual;
    function GetDataBaseSQL: WideString;  virtual;
    function TableExists(const ATableName: WideString; const ASchema: WideString): WideString; virtual;
    function ProcedureExists(const AProcedureName:WideString; const ASchema: WideString): WideString; virtual;
    function FieldExists(const ATableName: WideString; const AField: WideString): WideString; virtual;
    function ReNameTable(const AOldName: WideString; const ANewName: WideString): WideString; virtual;
    function GetDropTableSQL(const ATableName: WideString): WideString; virtual;
    function GetFieldName(const AFieldName: WideString): WideString; virtual;
    function GetFieldValue(FieldType: Integer; Data: OleVariant): OleVariant;virtual;
    function GetFieldStringValue(FieldType: Integer; Data: OleVariant): WideString;virtual;
    function GetDropIndexSQL(const AIndexName: WideString; const ATableName: WideString): WideString; virtual;
    function GetAddFieldSQL(const AFieldName: WideString; AFieldType: Integer; AFieldSize: Integer;
                            AFieldPrecision: Integer): WideString;virtual;
    function GetResetFiledSizeSQL(const AFieldName: WideString; AFieldSize: Integer): WideString;virtual;
    function Get_NeedReStructTable: WordBool; virtual;
    function GetAddFieldConnSQL(const ASQL: WideString; const ATableName: WideString): WideString;virtual;
    function GetIndexExistsSQL(const AIndexName: WideString): WideString;virtual;
    function GetUpdateFieldLengthSQL(const ATableName: WideString; const AFieldName: WideString; 
                                     AOldLength: Integer; ANewLength: Integer): WideString;virtual;
    function GetAlterFieldSQL(const ATableName: WideString; const AFieldName: WideString;
                              AOleType: Integer; ANewType: Integer; AFieldLength: Integer;
                              AIsNull: WordBool): WideString;virtual;
    function GetUpdateVarcharToDate(const ATableName: WideString; const AFieldName: WideString): WideString;virtual;
    function GetUpdateDateToVarcharSQL(const ATableName: WideString; const AFieldName: WideString;
                                       AFieldSize: Integer): WideString;virtual;
    function GetUpdateVarCharToNumSQL(const ATableName: WideString; const AFieldName: WideString): WideString; virtual;
    function GetSetFieldNullSQL(const ATableName: WideString; const AFieldName: WideString): WideString;virtual;
    property MaxFieldCount: Integer read Get_MaxFieldCount;
    property MaxTableCount: Integer read Get_MaxTableCount;
    property LastError: WideString read Get_LastError;
    property NeedReStructTable: WordBool read Get_NeedReStructTable;
  public
    destructor Destroy;override;
  end;
  

implementation



destructor TAbstractConnectProvider.Destroy;
begin
  inherited;
end;

function TAbstractConnectProvider.Get_LastError: WideString;
begin
 
end;

function TAbstractConnectProvider.Get_MaxFieldCount: Integer;
begin
  Result:=0;
end;

function TAbstractConnectProvider.Get_MaxTableCount: Integer;
begin
  Result:=0;
end;

function TAbstractConnectProvider.Get_NeedReStructTable: WordBool;
begin
  Result:=False;
end;

function TAbstractConnectProvider.GetAddFieldConnSQL(const ASQL,
  ATableName: WideString): WideString;
begin
end;

function TAbstractConnectProvider.GetAddFieldSQL(const AFieldName: WideString;
  AFieldType, AFieldSize, AFieldPrecision: Integer): WideString;
begin

end;

function TAbstractConnectProvider.GetAlterFieldSQL(const ATableName,
  AFieldName: WideString; AOleType, ANewType, AFieldLength: Integer;
  AIsNull: WordBool): WideString;
begin

end;


function TAbstractConnectProvider.GetCreateIndexSQL(const TableName: WideString;
  Fields: OleVariant; const IndexName: WideString; IndexType: Integer;
  Data: OleVariant; Unique: WordBool): WideString;
begin

end;

function TAbstractConnectProvider.GetCreateTableName(
  const TableName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetDataBaseSQL: WideString;
begin

end;

function TAbstractConnectProvider.GetDate: WideString;
begin

end;

function TAbstractConnectProvider.GetDropFieldSQL(const TableName,
  FieldNames: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetDropIndexSQL(const AIndexName,
  ATableName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetDropTableSQL(
  const ATableName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetFieldDefSQL(const FieldName: WideString;
  FieldType, FieldSize, DotLen: Integer; CanNull: WordBool;
  Data: OleVariant; IsPrimaryKey: WordBool): WideString;

begin

end;

function TAbstractConnectProvider.GetFieldName(
  const AFieldName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetFieldStringValue(FieldType: Integer;
  Data: OleVariant): WideString;
begin

end;

function TAbstractConnectProvider.GetFieldValue(FieldType: Integer;
  Data: OleVariant): OleVariant;
begin

end;

function TAbstractConnectProvider.GetIndexExistsSQL(
  const AIndexName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetIndexName(
  const IndexName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetRenameTableSQL(const OldTableName,
  NewTableName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetResetFiledSizeSQL(
  const AFieldName: WideString; AFieldSize: Integer): WideString;
begin

end;

function TAbstractConnectProvider.GetSetFieldNullSQL(const ATableName,
  AFieldName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetTableName(
  const TableName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetTopSelectSQL(const Fields, TableName,
  WhereCondition, OrderCondition: WideString): WideString;

begin

end;

function TAbstractConnectProvider.GetUpdateDateToVarcharSQL(const ATableName,
  AFieldName: WideString; AFieldSize: Integer): WideString;
begin

end;

function TAbstractConnectProvider.GetUpdateFieldLengthSQL(const ATableName,
  AFieldName: WideString; AOldLength, ANewLength: Integer): WideString;
begin

end;

function TAbstractConnectProvider.GetUpdateVarcharToDate(const ATableName,
  AFieldName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.GetUpdateVarCharToNumSQL(const ATableName,
  AFieldName: WideString): WideString;
begin

end;



function TAbstractConnectProvider.ReNameTable(const AOldName,
  ANewName: WideString): WideString;
begin

end;

function TAbstractConnectProvider.TableExists(const ATableName,
  ASchema: WideString): WideString;
begin

end;
function TAbstractConnectProvider.FieldExists(const ATableName,
  AField: WideString): WideString;
begin

end;


function TAbstractConnectProvider.ProcedureExists(const AProcedureName:WideString ;
  const ASchema: WideString): WideString;
begin

end;

end.
