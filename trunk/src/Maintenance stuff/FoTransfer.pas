unit FoTransfer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.OleAuto,
  UOracleDB, oracle, StrUtils, moreUtils;

type
  TFormTransfer = class(TForm)
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure GetHistory;
    procedure SendValues;
  private
    procedure CleanupTableTeile;
    function CleanValue(value: string): string;
    function DeleteRepeatedSpaces(const s: string): string;
    { Private-Deklarationen }
  public
    function Filter(value: string): Boolean;
    { Public-Deklarationen }
  end;

var
  FormTransfer: TFormTransfer;
  CustServiceList, CustNameList, CompSNList, CompNameList: TStringList;

implementation

uses FoRepAppMAIN;

{$R *.dfm}

// genutzt, um von einer kopierten teile-tabelle in der datenbank die daten zu bereinigen und in eine andere zu überführen
procedure TFormTransfer.CleanupTableTeile;
var
  Table: TList;
  I: Integer;
  Oquery: TOracleQuery;
begin
  // get table
  SelectXFromYWhereZOrderBy('name, snpflicht', 'teile_copy_copy', '', 'name', Table);

  Oquery := TOracleQuery.Create(self);
  // empty table
  // Oquery.SQL.Text := 'TRUNCATE table teile_copy';
  // ExecuteQueryInsUpd(Oquery);

  for I := 0 to Table.Count do
  begin
    // clean value of field
    try
      (TStringList(Table[I]))[0] := CleanValue((TStringList(Table[I]))[0]);
      Oquery.Clear;
      Oquery.SQL.Text := 'Insert Into teile_copy values (SEQ_TEIL_ID.nextval,''' + (TStringList(Table[I]))[0] + ''','''
        + (TStringList(Table[I]))[1] + ''')';
      ExecuteDMLQuery(Oquery);
    except
      on E: Exception do
    end;
  end;
  Oquery.free;
  Table.free;

end;

procedure TFormTransfer.Button1Click(Sender: TObject);
begin
  SendValues;
end;

procedure TFormTransfer.Button2Click(Sender: TObject);
begin
  GetHistory;
  Label1.Caption := IntToStr(CustNameList.Count);
  Label2.Caption := IntToStr(CompNameList.Count);
end;

procedure TFormTransfer.Button3Click(Sender: TObject);
begin
  CleanupTableTeile;
end;

procedure TFormTransfer.Button4Click(Sender: TObject);
// var
// tempstring: string;
// key: String;
begin
  // for key in CompDict.Keys do
  // begin
  // tempstring := DeleteRepeatedSpaces(CompDict[key].Name);
  // if (tempstring <> CompDict[key].Name) and (not CompDictInv_LowerC.ContainsKey(tempstring)) then
  // try
  // ExecuteDMLQuery('update TEILE_IMPORTED set name=''' + tempstring + ''' where TEILID=''' + key + '''');
  // except
  // on E: EOracleError do
  // // ExecuteQueryInsUpd('delete from TEILE_IMPORTED where TEILID=''' +
  // // key + '''');
  // end;
  // end;

end;

// auslesen der bereinigten Komponenten-Tabelle von Thomas Niegl
procedure TFormTransfer.Button5Click(Sender: TObject);
var
  Rows: Integer;
  Excel, XLSheet: Variant;
  filename: string;
  y: Integer;

  col_srNr, col_name, col_twiNr: Integer;

  val_srNr, val_name, val_twiNr: string;

begin
  // mmHistory.Clear;
  filename := 'C:\Users\Stolle\Desktop\Ersatzteile.xls';
  if not fileexists(filename) then
  begin
    exit;
  end;
  Excel := Unassigned;
  // FHandyHistory.Clear;
  // FHistoryErrors.Clear;

  try
    Excel := CreateOleObject('Excel.Application');

    CompNameList := TStringList.Create;
    CompNameList.Duplicates := dupIgnore;
    CustNameList := TStringList.Create;
    CustNameList.Duplicates := dupIgnore;

    CompSNList := TStringList.Create;
    CustServiceList := TStringList.Create;

    Excel.Visible := False;
    Excel.WorkBooks.Open(filename, 0, true);
    // fn, noupdate-links, readonly
    XLSheet := Excel.Worksheets[1];
    col_name := 2;
    col_srNr := 3;
    col_twiNr := 4;


    // Value of the 1st Cell [y,x]:

    // Cols := XLSheet.UsedRange.Columns.Count;
    Rows := XLSheet.UsedRange.Rows.Count;

    ProgressBar1.Max := Rows;
    ProgressBar1.Position := 0;

    Memo1.Clear;
    // durchsuche jede zeile in excel
    for y := 2 to Rows do
    begin
      val_name := Excel.Cells[y, col_name].value;
      val_srNr := Excel.Cells[y, col_srNr].value;
      val_twiNr := Excel.Cells[y, col_twiNr].value;

      if val_srNr = 'j' then
        val_srNr := '1'
      else
        val_srNr := '0';

      Memo1.Text := Memo1.Text + val_name + '  ' + val_srNr + '  ' + val_twiNr + sLineBreak;

      try
        InsertIntoComp(val_name, StrToBool(val_srNr), '-1', val_twiNr);
      except
        on E: Exception do
          // nothing
      end;

      ProgressBar1.Position := y;
    end;

  finally

    Excel.WorkBooks.Close;
    Excel.Quit;
    Excel := Unassigned;

  end;
  CompSNList.free;
  CustServiceList.free;
end;

procedure TFormTransfer.GetHistory;
var
  Rows: Integer;
  Excel, XLSheet: Variant;
  filename: string;
  y: Integer;

  col_in_cust, col_out_cust: Integer;
  col_in_part, col_out_part: Integer;
  col_in_sn, col_out_sn: Integer;
  col_serv: Integer;

  val_in_cust, val_out_cust: string;
  val_in_part, val_out_part: string;
  val_in_sn, val_out_sn: string;
  val_serv: string;
begin
  // mmHistory.Clear;
  filename := '\\twi30\Allgemein\Schwarzes Brett\REPARATUREN\Reparatur.xls';
  if not fileexists(filename) then
  begin
    exit;
  end;
  Excel := Unassigned;
  // FHandyHistory.Clear;
  // FHistoryErrors.Clear;

  try
    Excel := CreateOleObject('Excel.Application');

    CompNameList := TStringList.Create;
    CompNameList.Duplicates := dupIgnore;
    CustNameList := TStringList.Create;
    CustNameList.Duplicates := dupIgnore;

    CompSNList := TStringList.Create;
    CustServiceList := TStringList.Create;

    Excel.Visible := False;
    Excel.WorkBooks.Open(filename, 0, true);
    // fn, noupdate-links, readonly
    XLSheet := Excel.Worksheets[1];

    // col_in_date := 8;
    // col_out_date := 2;
    col_in_cust := 9;
    col_out_cust := 3;
    col_in_part := 11;
    col_out_part := 5;
    col_in_sn := 12;
    col_out_sn := 6;
    col_serv := 17;


    // Value of the 1st Cell [y,x]:

    // Cols := XLSheet.UsedRange.Columns.Count;
    Rows := XLSheet.UsedRange.Rows.Count;

    ProgressBar1.Max := Rows;
    ProgressBar1.Position := 0;

    // durchsuche jede zeile in excel
    for y := 1 to Rows do
    begin
      val_in_cust := Excel.Cells[y, col_in_cust].value;
      val_in_part := Excel.Cells[y, col_in_part].value;
      val_in_sn := Excel.Cells[y, col_in_sn].value;
      val_out_cust := Excel.Cells[y, col_out_cust].value;
      val_out_part := Excel.Cells[y, col_out_part].value;
      val_out_sn := Excel.Cells[y, col_out_sn].value;
      val_serv := Excel.Cells[y, col_serv].value;

      val_in_part := CleanValue(val_in_part);
      val_out_part := CleanValue(val_out_part);
      val_out_cust := CleanValue(val_out_cust);

      // // if comp-name dos not exists in list yet, it will be added, aswell parallel its SN
      // if Filter(val_in_part) then
      // if CompNameList.IndexOf(val_in_part) = -1 then
      // begin
      // CompNameList.Add(val_in_part);
      // CompSNList.Add(val_in_sn);
      // end;
      //
      // // if comp-name dos not exists in list yet, it will be added, aswell parallel its SN
      // if Filter(val_out_part) then
      // if CompNameList.IndexOf(val_out_part) = -1 then
      // begin
      // CompNameList.Add(val_out_part);
      // CompSNList.Add(val_out_sn);
      // end;

      // if cust-name dos not exists in list yet, it will be added, aswell parallel its service
      if val_out_cust <> '' then
        if CustNameList.IndexOf(val_out_cust) = -1 then
        begin
          CustNameList.Add(val_out_cust);
          CustServiceList.Add(val_serv);
        end;

      ProgressBar1.Position := y;
    end;

  finally
    // pb1.Visible := False;
    // ResetCursor();
    Excel.WorkBooks.Close;
    Excel.Quit;
    Excel := Unassigned;

  end;
  CompSNList.free;
  CustServiceList.free;
end;

procedure TFormTransfer.SendValues;
var
  OracleQ: TOracleQuery;
  hasSN: String;
  I: Integer;
begin
  OracleQ := TOracleQuery.Create(nil);

  // creates a query string to insert all values into Teile_copy and kunde_copy


  // for I := 0 to CompNameList.Count - 1 do
  // begin
  // if CompSNList[I] <> '' then
  // hasSN := '1'
  // else
  // hasSN := '0';
  // OracleQ.SQL.Clear;
  // OracleQ.SQL.Append
  // ('Insert Into TEILE_COPY (TEILID, NAME, SNPFLICHT) values ' +
  // '(SEQ_TEIL_ID.nextval, ''' + CompNameList[I] + ''', ''' + hasSN + ''') ');
  // Memo1.Lines.Add(OracleQ.SQL.GetText);
  // Memo1.Update;
  // UOracleDB.ExecuteQueryInsUpd(OracleQ);
  //
  // end;

  for I := 0 to CustNameList.Count - 1 do
  begin
    if CustServiceList[I] = 'j' then
      hasSN := '1'
    else
      hasSN := '0';
    OracleQ.SQL.Clear;
    OracleQ.SQL.Append('Insert into KUNDEN_COPY (KUNDEID, NAME, SERVICE) values ' + '(SEQ_KUNDEN_ID.nextval, ''' +
      CustNameList[I] + ''', ''' + hasSN + ''') ');
    Memo2.Lines.Add(OracleQ.SQL.GetText);
    Memo2.Update;
    UOracleDB.ExecuteDMLQuery(OracleQ);
  end;
  OracleQ.free;
end;

function TFormTransfer.CleanValue(value: string): string;
begin
  // prepare strings
  value := StringReplace(value, '''', '"', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, '"', '', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '#', '', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' = ', '=', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'l=', 'L=', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' - ', '-', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' -', '-', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '-.', '-', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '- ', '-', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ', ', ' ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '; ', ' ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' mm', 'mm', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'top', 'TOP', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'aero', 'AERO', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'win-', 'WIN-', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'win ', 'WIN ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'selo', 'S-ELO', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'elo', 'ELO', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'ass', 'ASS', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'ass 200', 'ASS200', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'ass-200', 'ASS200', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'ass200', 'ASS200', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'ass-', 'ASS200 ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'ass 200-', 'ASS200 ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'tas ', 'TAS ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' taster', ' Taster ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'pc', 'PC', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'top_cut', 'TOPCUT', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'topcut', 'TOPCUT', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'platten', 'platte', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'lfs', 'LFS', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'schienen', 'schniene', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'leisten', 'leiste', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'platinen', 'platine', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'sensoren', 'sensor', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'sensore', 'sensor', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'sensor ', 'Sensor ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'display', 'Display', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'type', 'Typ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'windows', 'WIN', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'druck-rechner', 'Druckrechner', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' als Ersatz', '', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' ps', ' PS', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'clable', 'Kabel', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, ' kabel', ' Kabel', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'sick', 'SICK', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'keyboard', 'Tastatur', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'industrial', 'industriell', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handy_', 'Handy ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handy', 'Handy ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'scanner', 'Scanner ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'HandScanner', 'Hand-Scanner ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'track', 'Track ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'track ball', 'Trackball', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'hit', 'HIT ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'rollerdrives', 'rollerdrive ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'rollerdrive', 'Rollerdrive ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'sn.', '', [rfReplaceAll, rfIgnoreCase]);

  result := Trim(value);
end;

function TFormTransfer.Filter(value: string): Boolean;
begin
  if (value <> '') and not(ContainsText(value, '+')) and not(ContainsText(value, 'neu')) and
    not(ContainsText(value, 'als')) and not(ContainsText(value, 'SN')) and not(ContainsText(value, 'repariert')) and
    not(ContainsText(value, '?')) and not(ContainsText(value, 'S.-N')) then
    result := true
  else
    result := False;
end;

function TFormTransfer.DeleteRepeatedSpaces(const s: string): string;
var
  I, j, State: Integer;
begin
  SetLength(result, Length(s));
  j := 0;
  State := 0;

  for I := 1 to Length(s) do
  begin

    if s[I] = ' ' then
      Inc(State)
    else
      State := 0;

    if State < 2 then
      result[I - j] := s[I]
    else
      Inc(j);

  end;

  if j > 0 then
    SetLength(result, Length(s) - j);
end;

end.
