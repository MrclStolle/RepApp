unit UOracleDB;

interface

uses
  System.Classes, Vcl.Dialogs, oracle, sysutils, moreUtils, ansistrings, FoSplashScreen;

procedure SelectAllFrom(tableName: string; var Table: TList);

function GetSession: TOracleSession;

/// <summary>Creates connection to DB and inserts values into Table 'Mitarbeiter';
/// ID is generated with sequence, pw not used yet
/// </summary>
/// <param name="name"> Name of Employee (string) </param>
/// <param name="kurz"> Initials of Employee (string) </param>
/// <param name="pw"> Users Password (string) </param>
/// <param name="admin"> Admin Status (boolean) </param>
procedure InsertIntoEmployee(name, kurz, pw: string; admin: boolean);
procedure InsertIntoComp(name: string; BoolSerialN: boolean; UserID: String); overload;
procedure InsertIntoComp(name: string; BoolSerialN: boolean; UserID, twiNr: String); overload;
function InsertIntoCustomer(name: string; service: boolean): String;

/// <summary>Führt ein INSERT-Befehl in die AUFTRAG-Tabelle der DB mithilfe der angegebenen Parameter.
/// Optionaler Rückgabewert ist die für diesen Datensatz erstellte ID.
/// </summary>
/// <param name="customerID"> (string) </param>
/// <param name="statusID"> (string) </param>
/// <param name="timeExposure"> (string) </param>
/// <param name="comment"> (string) </param>
/// <param name="wareStatusID"> (string) </param>
/// <param name="billStatusID"> (string) </param>
function InsertIntoTask(customerID, statusID, comment, wareStatusID, billStatusID: string): String;
procedure SelectXFromY(column, tableName: string; var Table: TList);
function InsertIntoBooking(auftrID, buchtypID, datum, packageID, MAID, comment, hoursDez: string): String;
/// <summary>Führt eine Insert-Anweisung in die Tabelle BUCHPOS_TEILE aus.
/// </summary>
/// <param name="BuchID"> (string) </param>
/// <param name="TeilID"> (string) </param>
/// <param name="count"> (string) </param>
/// <param name="SerialNr"> (string) </param>
procedure InsertIntoBuchPos(BuchID, TeilID, count, SerialNr: string);
/// <summary>Führt die angegebene INSERT/UPDATE o.a. nicht-Select Anweisung aus.
/// </summary>
/// <param name="query"> Diekte Anweisung als String</param>
procedure ExecuteDMLQuery(query: string); overload;
/// <summary>Führt die angegebene INSERT/UPDATE o.a. nicht-Select Anweisung aus.
/// </summary>
/// <param name="query">Anweisung in einem TOracleQuery-Objekt</param>
procedure ExecuteDMLQuery(query: TOracleQuery); overload;
function GetNextSeqIDFrom(SeqName: string): String;
/// <summary>Führt die angegebene SELECT-Anweisung durch und gibt eine Tabelle als
/// TList, bestehend aus TStringlists, zurück.
/// </summary>
/// <param name="querystring"> Query-Befehl in String </param>
/// <param name="Table"> Die zu beschreibene TList (Tlist-TStringList-) </param>
procedure ExecuteDQLQuery(querystring: string; var Table: TList);

/// <summary><para> Executes a Select-Query with given parameters</para>
/// <para>-- SELECT 'column' FROM  'tableName'  WHERE  'where' ORDER BY 'orderby' --
/// </para></summary>
/// <returns> returns the tableName as TList with TStringList(Rows) as values
/// </returns>
/// <param name="column"> (string) Name of Column</param>
/// <param name="tableName"> (string) Name of tableName</param>
/// <param name="where"> (string) WHERE-clause, can be empty </param>
/// <param name="orderby"> (string) ORDER BY-clause, can be empty </param>
procedure SelectXFromYWhereZOrderBy(column, tableName, where, orderby: string; var Table: TList);

procedure UpdateTaskTable(auftrID, statusID, kommentar, wareStatusID, billStatusID: string);

procedure UpdateTaskTableWareStatusID(auftrID, wareStatusID: String);
procedure UpdateTaskTableBillStatusID(auftrID, billStatusID: String);

/// <summary> Führt ein INSERT in die AUFTRAGSPROTOKOLL-Tabelle aus.
/// Dies sollte bei jeder Auftrags-Änderung aufgeführt werden, um diese zu protkollieren.
/// </summary>
/// <param name="auftrID"> (string) </param>
/// <param name="MAID"> (string) </param>
/// <param name="statusID"> (string) </param>
/// <param name="datum"> (string) </param>
/// <param name="ZeitaufwSt"> (string) </param>
/// <param name="kommentar"> (string) </param>
/// <param name="wareStatusID"> (string) </param>
/// <param name="billStatusID"> (string) </param>
procedure InsertIntoAuftrProt(auftrID, MAID, statusID, datum, ZeitaufwSt, kommentar, wareStatusID,
  billStatusID: string);

procedure GetTaskHistory(TaskID: string; var Table: TList);

procedure UpdateCustomerTable(CustID, name: string; service, nopayment: boolean);

procedure SetCurrentSession(DBName, UserName, pw: string); overload;

function TestConnection(DBName, UserName, pw: string): boolean; overload;

procedure ExecuteTransaction(var QueryStringList: TStringList);

procedure GetAllSNumbers(var StringList: TStringList);

procedure UpdateSerNr(baseSerNr, matSerNr: String);

procedure CreateConnection(DBName, DBUser, DBPW: String);

procedure CloseConnection;

function LockTaskRow(ID: string): boolean;

procedure ReleaseTaskRow(ID: String);

procedure UpdateBookPosNoBalance(BookPosID: String; NoBalance: boolean);

procedure DeleteBookPos(BookPosID: String);

function SessionConnected: boolean;

implementation

uses USettings;

var
  OracleQuery: TOracleQuery;
  TransactionString: String;

procedure SelectXFromYWhereZOrderBy(column, tableName, where, orderby: string; var Table: TList);
var
  tempstring: string;
begin
  tempstring := 'Select ' + column + ' From ' + tableName;

  if Length(where) > 0 then
    tempstring := tempstring + ' where ' + where;

  if Length(orderby) > 0 then
    tempstring := tempstring + ' order by ' + orderby;

  ExecuteDQLQuery(tempstring, Table);
  tempstring := '';
end;

// select -column- from -tableName-
procedure SelectXFromY(column, tableName: string; var Table: TList);
begin
  SelectXFromYWhereZOrderBy(column, tableName, '', '', Table);
end;

// select * from -tableName-
procedure SelectAllFrom(tableName: string; var Table: TList);
begin
  SelectXFromY('*', tableName, Table);
end;

function SessionConnected: boolean;
begin
  Result := false;
  if OracleQuery <> nil then
    if OracleQuery.session <> nil then
      if OracleQuery.session.connected then
        Result := true;
end;

function GetSession: TOracleSession;
begin
  Result := OracleQuery.session;
end;

procedure InsertIntoEmployee(name, kurz: string; pw: string; admin: boolean);
begin
  ExecuteDMLQuery('Insert Into mitarbeiter values (SEQ_MA_ID.nextval, ''' + name + ''', ''' + kurz + ''',''' + pw +
    ''',' + BoolToNumber(admin) + ' )');
end;

procedure InsertIntoComp(name: string; BoolSerialN: boolean; UserID: String);
begin
  InsertIntoComp(name, BoolSerialN, UserID, '')
end;

procedure InsertIntoComp(name: string; BoolSerialN: boolean; UserID, twiNr: String);
begin
  ExecuteDMLQuery('Insert Into teile values (SEQ_TEIL_ID.nextval, ''' + name + ''', ''' + BoolToNumber(BoolSerialN) +
    ''', ''' + UserID + ''', ''' + twiNr + ''')');
end;

function InsertIntoCustomer(name: string; service: boolean): String;
begin
  Result := GetNextSeqIDFrom('''SEQ_KUNDEN_ID''');
  ExecuteDMLQuery('Insert Into kunden values (SEQ_KUNDEN_ID.nextval, ''' + name + ''', ''' + BoolToNumber(service) +
    ''', 0 )');
end;

function InsertIntoTask(customerID, statusID, comment, wareStatusID, billStatusID: string): String;
begin
  { DONE -ostolle -cGeneral : die methode die verwendete ID zurück geben lassen -> die nächste verwendete Nr vorher abfragen lassen und auf result setzen
    -> vereinfacht erstellung von eventuell drauf folgender Buchung }
  Result := GetNextSeqIDFrom('''SEQ_AUFTR_ID''');
  ExecuteDMLQuery('Insert Into AUFTRAG values (SEQ_AUFTR_ID.nextval, ' + customerID + ', ' + statusID + ', ''' + comment
    + ''', ' + wareStatusID + ', ' + billStatusID + ')');
end;

// insert into buchung
function InsertIntoBooking(auftrID, buchtypID, datum, packageID, MAID, comment, hoursDez: string): String;
begin
  Result := GetNextSeqIDFrom('''SEQ_BUCH_ID''');
  ExecuteDMLQuery('Insert Into BUCHUNGEN values (SEQ_BUCH_ID.nextval, ' + auftrID + ', ' + buchtypID + ', ''' + datum +
    ''', ''' + packageID + ''', ' + MAID + ', ''' + comment + ''', ' + StringReplace(hoursDez, ',', '.',
    [rfReplaceAll]) + ')');
end;

// insert into buchpos
procedure InsertIntoBuchPos(BuchID, TeilID, count, SerialNr: string);
begin
  ExecuteDMLQuery('Insert Into buchpos_teile values (SEQ_BUCHPOS_ID.nextval, ' + BuchID + ', ' + TeilID + ', ' + count +
    ', ''' + SerialNr + ''')');
end;

// insert into buchpos
procedure InsertIntoAuftrProt(auftrID, MAID, statusID, datum, ZeitaufwSt, kommentar, wareStatusID,
  billStatusID: string);
begin
  ExecuteDMLQuery('Insert Into AUFTRAGPROTOKOLL values (SEQ_AUFTRPROT_ID.nextval, ' + auftrID + ', ' + MAID + ', ' +
    statusID + ', ''' + datum + ''', ' + StringReplace(ZeitaufwSt, ',', '.', [rfReplaceAll]) + ', ''' + kommentar +
    ''', ' + wareStatusID + ', ' + billStatusID + ')');
end;

// execute Instert or Update query
procedure ExecuteDMLQuery(query: string);
begin
  OracleQuery.SQL.Clear;
  OracleQuery.SQL.Text := query;
  try
    OracleQuery.Execute;
  finally
    OracleQuery.close;
  end;

end;

procedure ExecuteDMLQuery(query: TOracleQuery);
begin
  try
    OracleQuery.SQL := query.SQL;
    OracleQuery.Execute;
  finally
    OracleQuery.close;
  end;

end;

function GetNextSeqIDFrom(SeqName: string): String;
var
  Table: TList;
  i: Integer;
begin
  try
    if Table <> nil then
      Table := nil;
    Table := TList.Create;

    SelectXFromYWhereZOrderBy('last_number', 'user_sequences', 'SEQUENCE_NAME = ' + SeqName, '', Table);
    Result := TStringList(Table[0])[0];
  finally
    for i := 0 to Table.count - 1 do
      TStringList(Table[i]).free;
    Table.free;
  end;
end;

procedure ExecuteDQLQuery(querystring: string; var Table: TList);
var
  Row: TStringList;
  count: Integer;
  Ifield: Integer;
begin
  OracleQuery.SQL.Clear;
  OracleQuery.SQL.Text := querystring;
  // if Row <> nil then
  // Row := nil;

  try
    OracleQuery.Execute;

    // read querystring
    count := OracleQuery.FieldCount;

    while not OracleQuery.Eof do
    begin
      Row := TStringList.Create;
      for Ifield := 0 to (count - 1) do
      begin
        Row.add(OracleQuery.FieldAsString(Ifield));
      end;

      OracleQuery.Next;
      Table.add(Row);
    end;

  finally

    OracleQuery.close;
  end;
end;

procedure UpdateTaskTable(auftrID, statusID, kommentar, wareStatusID, billStatusID: string);
begin
  ExecuteDMLQuery('update auftrag set statusid=''' + statusID + ''', kommentar=''' + kommentar + ''', warenstatusid=' +
    wareStatusID + ', rechnstatusid=' + billStatusID + ' where auftrid=' + auftrID);
end;

procedure UpdateTaskTableWareStatusID(auftrID, wareStatusID: String);
begin
  ExecuteDMLQuery('update auftrag set warenstatusid=' + wareStatusID + ' where auftrid=' + auftrID);
end;

procedure UpdateTaskTableBillStatusID(auftrID, billStatusID: String);
begin
  ExecuteDMLQuery('update auftrag set rechnstatusid=' + billStatusID + ' where auftrid=' + auftrID);
end;

procedure UpdateCustomerTable(CustID, name: string; service, nopayment: boolean);
begin
  ExecuteDMLQuery('update kunden set name=''' + name + ''', service=''' + BoolToNumber(service) +
    ''', ZAHLRUECKSTAND=''' + BoolToNumber(nopayment) + ''' where kundeid=' + CustID);
end;

procedure GetTaskHistory(TaskID: string; var Table: TList);
begin
  SelectXFromYWhereZOrderBy('*', 'Auftragprotokoll', 'AUFTRID=''' + TaskID + '''', 'APROTID', Table);
end;

procedure CreateConnection(DBName, DBUser, DBPW: String);
begin
  try
    OracleQuery := TOracleQuery.Create(nil);
    OracleQuery.session := TOracleSession.Create(nil);
    SetCurrentSession(DBName, DBUser, DBPW);

    OracleQuery.session.LogOn;
    connectedTo := 'Verbunden mit ' + DBName;
  except
    on E: EOracleError do
      ShowMessage(E.toString);
  end;
end;

procedure SetCurrentSession(DBName, UserName, pw: string);
begin
  OracleQuery.session.LogonDatabase := DBName;
  OracleQuery.session.LogonUsername := UserName;
  OracleQuery.session.LogonPassword := pw;
  OracleQuery.session.AutoCommit := true;

end;

function TestConnection(DBName, UserName, pw: string): boolean;
var
  SplashScreen: TFormSplashScreen;
  oraTestQuerry: TOracleQuery;
begin
  oraTestQuerry := nil;
  SplashScreen := nil;
  try
    SplashScreen := TFormSplashScreen.Create('Verbinde mit Datenbank..');
    SplashScreen.Subtitle('Erstelle Session');
    oraTestQuerry := TOracleQuery.Create(nil);
    oraTestQuerry.session := TOracleSession.Create(nil);
    SplashScreen.Subtitle('Setze Werte');
    oraTestQuerry.session.LogonDatabase := DBName;
    oraTestQuerry.session.LogonUsername := UserName;
    oraTestQuerry.session.LogonPassword := pw;

    try
      SplashScreen.Subtitle('Logging on');
      SplashScreen.SubTitle2(DBName);
      oraTestQuerry.session.LogOn;
      Result := true;
    except
      on E: EOracleError do
      begin
        ShowMessage(E.toString + ' <Verbindungsaufbau mit ' + DBName + ' Fehlgeschlagen>');
        Result := false;
        if SplashScreen <> nil then
        begin
          SplashScreen.free;
          SplashScreen := nil;
        end;
      end
    end;
  finally
    if SplashScreen <> nil then
    begin
      SplashScreen.free;
    end;
    if oraTestQuerry.session <> nil then
      oraTestQuerry.session.free;
    if oraTestQuerry <> nil then
      oraTestQuerry.free;
  end;

end;

procedure ExecuteTransaction(var QueryStringList: TStringList);
var
  qstring: string;
begin
  OracleQuery.SQL.Clear;

  OracleQuery.SQL.Append('begin');
  for qstring in QueryStringList do
  begin
    OracleQuery.SQL.Append(qstring);
  end;
  OracleQuery.SQL.Append('end');

  try
    OracleQuery.Execute;
  finally
    OracleQuery.close;
  end;
end;

procedure GetAllSNumbers(var StringList: TStringList);
var
  List: TList;
  i: Integer;
begin
  try
    List := TList.Create;
    ExecuteDQLQuery('select BUCHPOS_TEILE.SNR from BUCHPOS_TEILE where SNR is not NULL GROUP By SNR', List);

    for i := List.count - 1 downto 0 do
    begin
      StringList.add(TStringList(List[i])[0]);
      TStringList(List[i]).free;
    end;
  finally
    List.free;
  end;
end;

procedure UpdateSerNr(baseSerNr, matSerNr: String);
begin
  ExecuteDMLQuery('update BUCHPOS_TEILE SET SNR=' + baseSerNr + ' WHERE SNR=' + matSerNr);
end;

procedure CloseConnection;
begin
  if OracleQuery <> nil then
  begin
    if OracleQuery.session <> nil then
      OracleQuery.session.free;
    OracleQuery.free;
  end;
end;

function LockTaskRow(ID: string): boolean;
begin
  try
    OracleQuery.SQL.Clear;
    OracleQuery.SQL.Text := 'Select * from AUFTRAG where AUFTRID=' + ID + ' for update nowait';
    try
      OracleQuery.Execute;
      Result := true;
    except
      on E: EOracleError do
      begin
        if E.ErrorCode = 00054 then
        begin
          ShowMessage('Auftrag wird gerade von einer anderen Session bearbeitet.');
          Result := false;
        end;
        Result := false;
      end;
    end;
  finally
    OracleQuery.close;

  end;
end;

procedure ReleaseTaskRow(ID: String);
begin
  // ExecuteDMLQuery('Update AUFTRAG SET AUFTRID = AUFTRID where AUFTRID=' + ID);
  ExecuteDMLQuery('commit');

end;

procedure UpdateBookPosNoBalance(BookPosID: String; NoBalance: boolean);
begin
  ExecuteDMLQuery('Update BUCHPOS_TEILE set NOBALANCE=' + BoolToNumber(NoBalance) + ' where BUCHPOSID=' + BookPosID);
end;

procedure DeleteBookPos(BookPosID: String);
begin
  ExecuteDMLQuery('Delete From BUCHPOS_TEILE where BUCHPOSID=' + BookPosID);
end;

initialization

// OracleQuery := TOracleQuery.Create(nil);
// OracleQuery.session := TOracleSession.Create(nil);

finalization

end.
