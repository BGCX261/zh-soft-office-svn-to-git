unit SqlServerProvider;

interface

uses Windows, Forms, ComObj, ActiveX,Variants,DataAccessProvider;
type

  TSQLServerProvider = class(TAbstractConnectProvider)
  private
    FLastError: string;
  protected
    function  Get_MaxFieldCount: Integer; override;
    function  Get_MaxTableCount: Integer; override;
    function  Get_LastError: WideString; override;
    function  GetFieldDefSQL(const FieldName: WideString; FieldType: Integer; FieldSize: Integer;
                             DotLen: Integer; CanNull: WordBool; Data: OleVariant;
                             IsPrimaryKey: WordBool): WideString; overload; override;
    function  GetCreateIndexSQL(const TableName: WideString; Fields: OleVariant;
                                const IndexName: WideString; IndexType: Integer;
                                Data: OleVariant;Unique: WordBool): WideString; override;
    function  GetRenameTableSQL(const OldTableName: WideString; const NewTableName: WideString): WideString; override;
    function  GetDropFieldSQL(const TableName: WideString; const FieldNames: WideString): WideString; override;
    function  GetCreateTableName(const TableName: WideString): WideString; override;
    function  GetTopSelectSQL(const Fields: WideString; const TableName: WideString; 
                              const WhereCondition: WideString; const OrderCondition: WideString): WideString; override;
    function  GetDate: WideString; override;
    function  GetTableName(const TableName: WideString): WideString;override;
    function  GetIndexName(const IndexName: WideString): WideString; override;
    function  GetDataBaseSQL: WideString; override;
    function  TableExists(const ATableName,ASchema: WideString): WideString; override;
    function ProcedureExists(const AProcedureName:WideString; const ASchema: WideString): WideString; override;
    function  ReNameTable(const AOldName: WideString; const ANewName: WideString): WideString; override;
    function  GetDropTableSQL(const ATableName: WideString): WideString; override;
    function  GetFieldName(const AFieldName: WideString): WideString; override;
    function  GetFieldValue(FieldType: Integer; Data: OleVariant): OleVariant; override;
    function  GetFieldStringValue(FieldType: Integer;Data: OleVariant): WideString; override;
    function  GetDropIndexSQL(const AIndexName: WideString; const ATableName: WideString): WideString; override;
    function  GetAddFieldSQL(const AFieldName: WideString; AFieldType: Integer; 
                             AFieldSize: Integer; AFieldPrecision: Integer): WideString; override;
		function  GetResetFiledSizeSQL(const AFieldName: WideString; AFieldSize: SYSINT): WideString; override;
		function  Get_NeedReStructTable: WordBool; override;
    function  GetAddFieldConnSQL(const ATableName: WideString;const ASQL: WideString): WideString; override;
		function  GetIndexExistsSQL(const AIndexName: WideString): WideString; override;
		function  GetUpdateFieldLengthSQL(const ATableName: WideString; const AFieldName: WideString; 
																			AOldLength: Integer; ANewLength: Integer): WideString; override;
    function  FieldExists(const ATableName,AField: WideString): WideString; override;
		function  GetAlterFieldSQL(const ATableName: WideString; const AFieldName: WideString;
															 AOleType: Integer; ANewType: Integer;
															 AFieldLength: Integer; AIsNull: WordBool): WideString; override;
		function  GetUpdateVarcharToDate(const ATableName: WideString; const AFieldName: WideString): WideString; override;
    function  GetUpdateDateToVarcharSQL(const ATableName: WideString; const AFieldName: WideString;
    				AFieldSize: Integer): WideString; override;
		function  GetUpdateVarCharToNumSQL(const ATableName: WideString; const AFieldName: WideString): WideString; override;
    function  GetSetFieldNullSQL(const ATableName: WideString; const AFieldName: WideString): WideString; override;

  public

    destructor Destroy; override;
	end;

implementation
uses
  ComServ, SysUtils, DB, Controls,ProviderConst;
const
	SQL_TopSelectFormatStr  = 'SELECT TOP 1 %s FROM %s %s %s';
	SQL_GetCurrentDateTime  = 'SELECT GETDATE() AS CURRENTDATETIME';
	SQL_GetDBList					  = 'SELECT NAME FROM MASTER..SYSDATABASES';
	SQL_TABLEEXISTS				  = 'SELECT NAME AS TABLENAME FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N''[DBO].[%s]'')'+
													' AND OBJECTPROPERTY(ID, N''ISUSERTABLE'') = 1';
	SQL_PROCEDUREEXISTS			= 'SELECT NAME AS TABLENAME FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N''[DBO].[%s]'')'+
													' AND OBJECTPROPERTY(ID, N''ISPROCEDURE'') = 1';                          
	SQL_FIELDEXISTS				  ='SELECT NAME FROM DBO.SYSCOLUMNS WHERE ID = OBJECT_ID(N''[dbo].[%s]'') '+
                          ' AND OBJECTPROPERTY(ID, N''ISUSERTABLE'') = 1 AND NAME =''%s''' ;                        
	SQL_RENAMETABLE				  = 'EXEC SP_RENAME %s,%s';
	SQL_DROPTABLE					  = 'DROP TABLE %s';
	SQL_DROPINDEX					  = 'DROP INDEX %s.%s';
	SQL_DROPFIELD					  = 'ALTER TABLE %s DROP COLUMN %s';
	SQL_ADDFIELD					  = '%s,';
	SQL_ADDFIELDCONNSTR		  = 'ALTER TABLE %s ADD %s';
	SQL_UPDATEFIELDLENGTH	  = 'UPDATE %s SET %1:s=SUBSTRING(%1:s, %d, %d)';
	SQL_UPDATEVARCHARTODATE = 'UPDATE %s SET %1:s=NULL WHERUPDATE %s SET %1:s=CONVERT(VARCHAR(%d), '+
													 'CAST(%1:s AS DATETIME), 126) WHERE ISDATE(%1:s)=1E ISDATE(%1:s)=0 ';
	SQL_UPDATEDATETOVARCHAR	= '';
	SQL_UPDATEVARCHARTONUM	= 'UPDATE %s SET %1:s=NULL WHERE ISNUMERIC(%1:s)=0';
	SQL_ALTERFIELDSQL			  = 'ALTER TABLE %s ALTER COLUMN %s';
	SQL_SETFIELDNULL				= 'UPDATE %s SET %s=null';
  SQL_WHERECONDITIONSIGN  = ' WHERE ';
  SQL_ORDERCONDITIONSIGN  = ' ORDER BY';



function TSQLServerProvider.Get_MaxFieldCount: Integer;
begin
  Result := Int_Max_Field_Count;
end;

function TSQLServerProvider.Get_MaxTableCount: Integer;
begin
  Result := Int_Max_Table_Count;
end;





function TSQLServerProvider.Get_LastError: WideString;
begin
  Result := FLastError;
end;

function TSQLServerProvider.GetFieldDefSQL(const FieldName: WideString;
  FieldType, FieldSize, DotLen: Integer; CanNull: WordBool;
  Data: OleVariant;IsPrimaryKey: WordBool): WideString;
const
  NS: array[False..True] of string = ('NOT NULL', 'NULL');
var
	KeyStr : string;      //add by lijun  2004-3-26
begin
  //得到创建表时字段的SQL描述
  Result := '';
  case TFieldType(FieldType) of
    ftString,ftwidestring:
      Result := Format('VARCHAR(%d)', [FieldSize]);
		ftFixedChar :
			Result := Format('CHAR(%d)',[FieldSize]);
    ftSmallint, ftInteger, ftWord:
      Result := 'INT';
    ftBoolean:
      Result := 'BIT';
    ftFloat, ftBCD:
      Result := Format('FLOAT', [DotLen]);
    ftCurrency:
      Result := 'MONEY';
    ftDate, ftTime, ftDateTime:
      Result := 'DATETIME';
    ftAutoInc:
      Result := 'INT IDENTITY(1,1)';
    ftBlob, ftGraphic:
      Result := 'IMAGE';
    ftMemo:
      Result := 'TEXT';
  end;
  KeyStr := '';            //add by lijun 2004-3-26 增加判断是否主键
  if IsPrimaryKey then
    KeyStr := PrimaryKeyStr;
  Result := Format('[%s] %s %s %s', [FieldName, Result,KeyStr, NS[CanNull]]);
  												//add by lijun end;
end;

function TSQLServerProvider.GetCreateIndexSQL(const TableName: WideString;
  Fields: OleVariant; const IndexName: WideString; IndexType: Integer;
  Data: OleVariant;Unique: WordBool): WideString;
var
  S: string;
  I: Integer;
  SUnique:string;
begin
  S := '';
  for I := VarArrayLowBound(Fields, 1) to VarArrayHighBound(Fields, 1) do
    S := S+'['+Fields[I]+'],';
  if Length(S) > 0 then
    Delete(S, Length(S), 1);
  SUnique := '';				//add by lijun    2004-3-29 索引增加唯一标识
  if Unique then
  	SUnique := UNIQUESQLTAG;
  case IndexType of  {1:主键；0：索引}
    1 :  Result := 'ALTER TABLE '+TableName+' WITH NOCHECK ADD '+
            'CONSTRAINT ['+IndexName+'] PRIMARY KEY  CLUSTERED '+
            '('+S+')  ON [PRIMARY]';
    0 :  Result := 'CREATE '+SUnique+' INDEX '+IndexName+
                ' ON '+TableName+'('+S+')';
  end;
                      //add by lijun end;

end;

function TSQLServerProvider.GetRenameTableSQL(const OldTableName,
  NewTableName: WideString): WideString;
begin
  Result := Format('EXEC SP_RENAME %s,%s', [OldTableName, NewTableName]);
  {
  case ConnType of
    ctSQLServer:
    begin
      Result := Format('EXEC SP_RENAME %s,%s', [OldName, NewName]);
    end;
    ctDB2	:
    begin
    	Result := Format('RENAME TABLE %s TO %s', [OldName, NewName]);
    end;         　
  end;
 }
end;

function TSQLServerProvider.GetDropFieldSql(
	const TableName: WideString; const FieldNames: WideString): WideString;
begin
	Result := Format(SQL_DROPFIELD,[TableName,FieldNames]);
end;

function TSQLServerProvider.GetCreateTableName(
  const TableName: WideString): WideString;
begin
  if Pos('DBO.', UpperCase(Trim(TableName)))<> 1 then
    Result := '[dbo].['+Trim(TableName)+']'
  else
    Result := TableName;
end;


destructor TSQLServerProvider.Destroy;
begin
  inherited;
end;


function TSQLServerProvider.GetTopSelectSQL(const Fields,
  TableName: WideString;const WhereCondition: WideString; const OrderCondition: WideString): WideString;
var
	sWhere,sOrder:WideString;
begin
	if Trim(WhereCondition)='' then
  	sWhere := ''
  Else sWhere := SQL_WHERECONDITIONSIGN + WhereCondition;

	if Trim(OrderCondition)='' then
  	sOrder := ''
  Else sOrder := SQL_ORDERCONDITIONSIGN + OrderCondition;

	result := format(SQL_TopSelectFormatStr,[Fields,TableName,sWhere,sOrder]);
end;


function TSQLServerProvider.GetDate: WideString;
begin
	  result := SQL_GetCurrentDateTime;
end;


function TSQLServerProvider.GetTableName(
  const TableName: WideString): WideString;
begin
	Result := TableName;
end;


function TSQLServerProvider.GetIndexName(
  const IndexName: WideString): WideString;
begin
	Result := IndexName;
end;


function TSQLServerProvider.GetDataBaseSQL: WideString;
begin
  Result := SQL_GetDBList;
end;


function TSQLServerProvider.TableExists(
	const ATableName,ASchema: WideString): WideString;
begin
	Result := format(SQL_TABLEEXISTS,[ATableName]);
end;


function TSQLServerProvider.ReNameTable(const AOldName,
  ANewName: WideString): WideString;
begin
  Result := format(SQL_RENAMETABLE,[UpperCase(AOldName),UpperCase(ANewName)]);
end;


function TSQLServerProvider.GetDropTableSQL(
	const ATableName: WideString): WideString;
begin
	Result := Format(SQL_DROPTABLE,[ATableName]);
end;


function TSQLServerProvider.GetFieldName(
  const AFieldName: WideString): WideString;
begin
	Result := AFieldName;
end;

function TSQLServerProvider.GetFieldValue(FieldType: Integer;
  Data: OleVariant): OleVariant;
begin
	Result := Data;
  case TFieldType(FieldType) of
    ftBoolean:
    	if Data then
        Result := '1'
      else Result := '0';
		else  Result := Data;
  end;
end;

function TSQLServerProvider.GetFieldStringValue(FieldType: Integer;
  Data: OleVariant): WideString;
begin
	Result := Data;
end;

function TSQLServerProvider.GetAddFieldSQL(const AFieldName: WideString; AFieldType: Integer;
                             AFieldSize: Integer; AFieldPrecision: Integer): WideString;
begin
	Result := Format(SQL_ADDFIELD,[GetFieldDefSQL(AFieldName,AFieldType,
																AFieldSize,AFieldPrecision,True,Null,False)]);
end;

function TSQLServerProvider.GetDropIndexSQL(
  const AIndexName: WideString; const ATableName: WideString): WideString;
begin
	Result := Format(SQL_DROPINDEX,[ATableName,AIndexName]);
end;

function TSQLServerProvider.GetResetFiledSizeSQL(const AFieldName: WideString;
  AFieldSize: SYSINT): WideString;
begin

end;

function TSQLServerProvider.Get_NeedReStructTable: WordBool;
begin
	Result := False;
end;

function TSQLServerProvider.GetAddFieldConnSQL(
	const ATableName: WideString;const ASQL: WideString): WideString;
begin
	Result := Format(SQL_ADDFIELDCONNSTR,[ATableName,ASQL]);
end;

function TSQLServerProvider.GetIndexExistsSQL(
  const AIndexName: WideString): WideString;
begin
 //	Result := Format();
end;

function TSQLServerProvider.GetUpdateFieldLengthSQL(const ATableName,
  AFieldName: WideString; AOldLength, ANewLength: Integer): WideString;
begin
	Result := Format(SQL_UPDATEFIELDLENGTH,[ATableName,AFieldName,AOldLength,ANewLength]);
end;

function TSQLServerProvider.GetAlterFieldSQL(const ATableName,
	AFieldName: WideString; AOleType, ANewType: Integer; AFieldLength: Integer;
	AIsNull: WordBool): WideString;
begin
	Result := Format(SQL_ALTERFIELDSQL,[ATableName,
			GetFieldDefSQL(AFieldName,ANewType,AFieldLength,0,AIsNull,null,False)]);
end;

function TSQLServerProvider.GetUpdateVarcharToDate(const ATableName,
  AFieldName: WideString): WideString;
begin
  Result := Format(SQL_UPDATEVARCHARTODATE,[ATableName,AFieldName]);
end;

function TSQLServerProvider.GetUpdateDateToVarcharSQL(const ATableName,
  AFieldName: WideString;AFieldSize: Integer): WideString;
begin
	Result := Format(SQL_UPDATEDATETOVARCHAR,[ATableName,AFieldName,AFieldSize]);
end;

function TSQLServerProvider.GetUpdateVarCharToNumSQL(const ATableName,
	AFieldName: WideString): WideString;
begin
	Result := Format(SQL_UPDATEVARCHARTONUM,[ATableName,AFieldName]);
end;

function TSQLServerProvider.GetSetFieldNullSQL(const ATableName,
	AFieldName: WideString): WideString;
begin
	Result := Format(	SQL_SETFIELDNULL,[ATableName,AFieldName]);
end;

  
function TSQLServerProvider.FieldExists(const ATableName,
  AField: WideString): WideString;
begin
  Result := format(SQL_FIELDEXISTS,[ATableName,AField]);
end;

function TSQLServerProvider.ProcedureExists(const AProcedureName:WideString;const ASchema: WideString): WideString;
begin
	Result := format(SQL_PROCEDUREEXISTS,[AProcedureName]);
end;

end.
