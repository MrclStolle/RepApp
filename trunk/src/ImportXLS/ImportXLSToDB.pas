unit ImportXLSToDB;

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections, Vcl.OleAuto, UOracleDB, StrUtils,
  moreUtils, UReadTextAsTime, UEmployeeDictionary, UCustomerDictionary, UComponentdictionary, FoSplashScreen;

function CleanValue(value: string): string;
procedure ImportXLS;

function ContentFilterTeil(Text: String; out OutText: String): boolean;

var
  CustServiceList, CustNameList, CompSNList, CompNameList: TStringList;

implementation

procedure ImportXLS;
var
  Rows: Integer;
  Excel, XLSheet: Variant;
  path: String;
  y: Integer;
  // xlsLine: TXLSLine;
  // Lines: TObjectList<TXLSLine>;

  Status, WAKunde, WATeil, WASRN, WATWI: String;
  WEKunde, WETeil, WESRN, WETWI: String;
  WADDate, WEDDate: TDatetime;
  WASt, WESt: Integer;
  REP, Time, Mat, Re: String;
  Service: boolean;

  h, min: Integer;
  List: TStringList;
  splScreen: TFormSplashScreen;
  BoolWETeil, BoolWATeil: boolean;

  taskid, bookid: string;
  I: Integer;
begin
  Excel := Unassigned;
  try
    List := TStringList.create;
    splScreen := TFormSplashScreen.create('exportiere nach csv testweise');
    splScreen.Subtitle('erstelle ole-object excel');
    Excel := CreateOleObject('Excel.Application');

    Excel.Visible := False;
    splScreen.Subtitle('öffne excel Reparatur');
    path := '\\twi30\Allgemein\Schwarzes Brett\REPARATUREN\Reparatur.xls';
    // path := 'C:\Users\Stolle\Desktop\Kopie von Reparatur (reduziert auf serNr.xls';
    Excel.WorkBooks.Open(path, 0, true);
    XLSheet := Excel.Worksheets[1];

    // Cols := XLSheet.UsedRange.Columns.Count;
    Rows := XLSheet.UsedRange.Rows.Count;
    splScreen.Subtitle('lese excel');

    // durchsuche jede zeile in excel
    for y := 3 to Rows do
    begin
      splScreen.Subtitle('lese excel Zeile ' + inttostr(y) + ' von ' + inttostr(Rows));
      BoolWATeil := ContentFilterTeil(Excel.Cells[y, 5].value, WATeil);
      BoolWETeil := ContentFilterTeil(Excel.Cells[y, 11].value, WETeil);
      if (BoolWATeil and HasDigit(Excel.Cells[y, 6].value)) or (BoolWETeil and HasDigit(Excel.Cells[y, 12].value))
      // or ((Excel.Cells[y, 1].value = '') and (containstext(Excel.Cells[y, 17].value, 'j') or
      // containstext(Excel.Cells[y, 17].value, 'n')))
      then // prüft auf existierende seriennummern oder offenem status

      begin
        // RECHNUNSSTATUS
        if lowercase(Excel.Cells[y, 17].value) = 'j' then
        begin
          Re := '3';
          Service := true // fullservice
        end
        else
        begin
          if (Excel.Cells[y, 18].value = 'n') then
            Re := '1' // rechnung offen
          else
            Re := '0'; // rechnung geschlossen
          Service := False;
        end;

        // ZUSTAND erledigt/nicht erledigt
        if lowercase(Excel.Cells[y, 1].value) = 'x' then
          Status := '0' // erledigt
        else
          Status := '1';

        // WA-SEITE nur verarbeiten, wenn das seriennummer-feld eine zahl beinhaltet
        if HasDigit(Excel.Cells[y, 6].value)
        // or (Excel.Cells[y, 1].value = '')
        then
        begin
          // versuche wert in DATETIME umzuwandeln, wenn nicht, versuche den wert aus WE, wenn nicht, setze wert auf 0
          if not trystrtodate(Excel.Cells[y, 2].value, WADDate) then
            if not trystrtodate(Excel.Cells[y, 8].value, WADDate) then
              WADDate := 0;
          splScreen.SubTitle2('WADDate=' + datetimetostr(WADDate));

          if y = 378 then
            sleep(0);

          // suche KUNDE (mit und ohne vermerk) in kundenListe, wenn nicht vorhanden, erstelle neuen kunden mit vermerk
          if Length(Excel.Cells[y, 3].value) > 0 then
            WAKunde := Excel.Cells[y, 3].value
          else
            WAKunde := Excel.Cells[y, 9].value;
          splScreen.SubTitle2('WAKunde(1)=' + WAKunde);

          if CustomerDictionary.ContainsName(WAKunde) then
            WAKunde := CustomerDictionary.GetCustomer(WAKunde).ID
          else if CustomerDictionary.ContainsName(WAKunde + ' (Import von Rep-Liste)') then
            WAKunde := CustomerDictionary.GetCustomer(WAKunde + ' (Import von Rep-Liste)').ID
          else
          begin
            WAKunde := InsertIntoCustomer(WAKunde + ' (Import von Rep-Liste)', Service);
            CustomerDictionary.RefreshFromDatabase;
            splScreen.SubTitle2('WAKunde(2)=' + WAKunde);
          end;
          // KOMPONENTE
          // WATeil := Excel.Cells[y, 5].value;
          if ComponentDictionary.ContainsName(WATeil) then
            WATeil := ComponentDictionary.GetComponent(WATeil).ID;
          splScreen.SubTitle2('WATeil =' + WATeil);

          // SERIENNUMMER
          WASRN := CleanValue(Excel.Cells[y, 6].value);
          if containstext(WASRN, '(') then
            WASRN := trim(SplitString(WASRN, '(')[0]);
          splScreen.SubTitle2('WASRN =' + WASRN);

          // holt nur der tatsächliche MENGENWART, ohne den 'teil von' wert; zB 5(8)
          if not HasDigit(Excel.Cells[y, 4].value) then
            WASt := Length(SplitString(WASRN, '('))
          else
            WASt := strtoint(trim(SplitString(SplitString(Excel.Cells[y, 4].value, '(')[0], ' ')[0]));
          splScreen.SubTitle2('WASt =' + inttostr(WASt));

          // MITARBEITER
          if EmployeeDictionary.GetEmployee(Excel.Cells[y, 7].value) <> nil then
            WATWI := EmployeeDictionary.GetEmployee(Excel.Cells[y, 7].value).ID
          else
            WATWI := '-1';
          splScreen.SubTitle2('WATWI =' + WATWI);
          // setzt den wert auf die ID des Mitarbeiters, welche in der DB eingetragen werden muss
          splScreen.SubTitle2('End WA');
        end
        else // FALLS KEIN SERIENNUMMERN-WART IM WA VORHANDEN IST
        begin
          splScreen.SubTitle2('Place zero/null values');
          WADDate := 0;
          WAKunde := '';
          WASt := 0;
          WATeil := '';
          WASRN := '';
          WATWI := '';
        end;
        splScreen.SubTitle2('Start WE');
        if y = 293 then
          sleep(0);
        // WE
        if HasDigit(Excel.Cells[y, 12].value)
        // or (Excel.Cells[y, 1].value = '')
        then
        begin
          // DATETIME
          if not trystrtodate(Excel.Cells[y, 8].value, WEDDate) then
            if not trystrtodate(Excel.Cells[y, 2].value, WEDDate) then
              WEDDate := 0;
          splScreen.SubTitle2('WEDate=' + datetimetostr(WEDDate));

          // suche KUNDE (mit und ohne vermerk) in kundenListe, wenn nicht vorhanden, erstelle neuen kunden mit vermerk
          if Length(Excel.Cells[y, 9].value) > 0 then
            WEKunde := Excel.Cells[y, 9].value
          else
            WEKunde := WAKunde;
          splScreen.SubTitle2('WEKunde(1)=' + WEKunde);

          if CustomerDictionary.ContainsName(WEKunde) then
            WEKunde := CustomerDictionary.GetCustomer(WEKunde).ID
          else if CustomerDictionary.ContainsName(WEKunde + ' (Import von Rep-Liste)') then
            WEKunde := CustomerDictionary.GetCustomer(WEKunde + ' (Import von Rep-Liste)').ID
          else
          begin
            WEKunde := InsertIntoCustomer(WEKunde + ' (Import von Rep-Liste)', Service);
            CustomerDictionary.RefreshFromDatabase;
          end;
          splScreen.SubTitle2('WEKunde(2)=' + WEKunde);

          // TEIL
          // WETeil := Excel.Cells[y, 11].value;
          if ComponentDictionary.ContainsName(WETeil) then
            WETeil := ComponentDictionary.GetComponent(WETeil).ID;
          splScreen.SubTitle2('WETeil=' + WETeil);

          // SERIENNUMMER
          WESRN := CleanValue(Excel.Cells[y, 12].value);
          if containstext(WESRN, '(') then
            WESRN := trim(SplitString(WESRN, '(')[0]);
          splScreen.SubTitle2('WESRN=' + WESRN);

          // MENGE
          if not HasDigit(Excel.Cells[y, 10].value) then
            WESt := Length(SplitString(WESRN, '('))
          else
            WESt := strtoint(trim(SplitString(SplitString(Excel.Cells[y, 10].value, '(')[0], ' ')[0]));
          splScreen.SubTitle2('WESt =' + inttostr(WESt));

          // MITARBEITER
          if EmployeeDictionary.GetEmployee(Excel.Cells[y, 13].value) <> nil then
            WETWI := EmployeeDictionary.GetEmployee(Excel.Cells[y, 13].value).ID
          else
            WETWI := '-1';
          // setzt den wert auf die ID des Mitarbeiters, welche in der DB eingetragen werden muss

        end
        else // WANN SERIENNUMER-WART LEER IST
        begin
          WEDDate := 0;
          WEKunde := '';
          WESt := 0;
          WETeil := '';
          WESRN := '';
          WETWI := '';
        end;

        // RESTLICHE WERTE
        REP := Excel.Cells[y, 14].value;
        if HasDigit(Excel.Cells[y, 15].value) then
        begin
          // TReadTextAsTime.TransformToHMin(Excel.Cells[y, 15].value, min, h);
          // Time := floattostr(h + trunc(min * 100 / 60) / 100);
          Time := Excel.Cells[y, 15].value;
        end
        else
          Time := '0';

        Mat := Excel.Cells[y, 16].value;



        // transaktion oder einzelne befehle?  eher transaktion


        // wenn eins der beiden seriennummern felder gefüllt ist oder der auftrag noch offen
        { TODO -ostolle -cGeneral : schnelleres direktes rauslesen? }

        // übertragen der werte (in dieser schleife bearbeitete zeile in excel) in die datenbank

        // LISTE FÜR CSV
        // splScreen.SubTitle2('füge liste hinzu');
        // List.Add(Status + ';' + datetimetostr(WADDate) + ';' + WAKunde + ';' + WATeil + ';' + inttostr(WASt) + ';' +
        // WASRN + ';' + WATWI + ';' + datetimetostr(WEDDate) + ';' + WEKunde + ';' + WETeil + ';' + inttostr(WESt) + ';'
        // + WESRN + ';' + WETWI + ';' + REP + ';' + Time + ';' + Mat + ';' + Re + ';' + BoolToNumber(Service));

        // insert into database
        splScreen.Subtitle('Sende zur Datenbank');
        taskid := InsertIntoTask(WAKunde, Status, REP + '   ' + Mat, '0', Re);

        bookid := InsertIntoBooking(taskid, '1', datetimetostr(WADDate), '', WATWI, '', '0');
        splScreen.SubTitle2('Task: ' + taskid + ' buchung: ' + bookid);
        if (WADDate <> 0) and (WASt >= 1) then
        begin
          for I := 0 to WASt - 1 do
          begin
            InsertIntoBuchPos(bookid, WATeil, '1', SplitString(WASRN, ' ')[I]);
          end;
        end;

        bookid := InsertIntoBooking(taskid, '0', datetimetostr(WEDDate), '', WETWI, '', '');
        splScreen.SubTitle2('Task: ' + taskid + ' buchung: ' + bookid);
        if (WEDDate <> 0) and (WESt >= 1) then
        begin
          for I := 0 to WESt - 1 do
          begin
            InsertIntoBuchPos(bookid, WETeil, '1', SplitString(WESRN, ' ')[I]);
          end;
        end;

      end;
      // ende if, ob behandelt werden soll

    end; // ende der schleife
    splScreen.SubTitle2('schreibe in csv');
    List.SaveToFile('C:\Users\Stolle\Desktop\exptestzeugausperliste.csv', TEncoding.UTF8);
  finally
    // pb1.Visible := False;
    // ResetCursor();
    Excel.WorkBooks.Close;
    Excel.Quit;
    Excel := Unassigned;

    CompSNList.Free;
    CustServiceList.Free;

    List.Free;
    List := nil;
    // splScreen.Free;
    // splScreen := nil;
  end;
  if List <> nil then
    List.Free;
  if CompSNList <> nil then
    CompSNList.Free;
  if CustServiceList <> nil then
    CustServiceList.Free;
  // if splScreen <> nil then
  // splScreen.Free;
end;

function CleanValue(value: string): string; // angepasst an reinem handy/mde/memor-filter
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
  while containstext(value, ';') do
    value := StringReplace(value, ';', ' ', [rfReplaceAll, rfIgnoreCase]);
  while containstext(value, ',') do
  begin
    // value := StringReplace(value, ', ', ' ', [rfReplaceAll, rfIgnoreCase]);
    value := StringReplace(value, ',', ' ', [rfReplaceAll, rfIgnoreCase]);
  end;
  value := StringReplace(value, '/', ' ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '!', '', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, '+', ' ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'u.', ' ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'und', ' ', [rfReplaceAll, rfIgnoreCase]);
  while containstext(value, '  ') do
    value := StringReplace(value, '  ', ' ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, ' mm', 'mm', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'top', 'TOP', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'aero', 'AERO', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'win-', 'WIN-', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'win ', 'WIN ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'selo', 'S-ELO', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'elo', 'ELO', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'ass', 'ASS', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'ass 200', 'ASS200', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'ass-200', 'ASS200', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'ass200', 'ASS200', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'ass-', 'ASS200 ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'ass 200-', 'ASS200 ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'tas ', 'TAS ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, ' taster', ' Taster ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'pc', 'PC', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'top_cut', 'TOPCUT', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'topcut', 'TOPCUT', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'platten', 'platte', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'lfs', 'LFS', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'schienen', 'schniene', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'leisten', 'leiste', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'platinen', 'platine', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'sensoren', 'sensor', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'sensore', 'sensor', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'sensor ', 'Sensor ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'display', 'Display', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'type', 'Typ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'windows', 'WIN', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'druck-rechner', 'Druckrechner', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, ' als Ersatz', '', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, ' ps', ' PS', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'clable', 'Kabel', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, ' kabel', ' Kabel', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'sick', 'SICK', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'keyboard', 'Tastatur', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'industrial', 'industriell', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'hansy', 'Handy', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handie', 'Handy', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handiy', 'Handy', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handies', 'Handy', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handys', 'Handy', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handy_', 'Handy ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'handy ', 'Handy ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'scanner', 'Scanner ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'HandScanner', 'Hand-Scanner ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'track', 'Track ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'track ball', 'Trackball', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'hit', 'HIT ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'rollerdrives', 'rollerdrive ', [rfReplaceAll, rfIgnoreCase]);
  // value := StringReplace(value, 'rollerdrive', 'Rollerdrive ', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'sn.', '', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'SN:', '', [rfReplaceAll, rfIgnoreCase]);
  value := StringReplace(value, 'SN', '', [rfReplaceAll, rfIgnoreCase]);

  result := trim(value);
end;

function ContentFilterTeil(Text: String; out OutText: String): boolean;
begin
  // clean and lowercase text
  Text := lowercase(CleanValue(Text));

  result := False;
  Text := copy(Text, 0, 12);
  if containstext(Text, 'handy') then
  begin
    result := true;
    OutText := 'Handy'
    // if containstext(Text, 'handy 6') or containstext(Text, 'handy_6') or containstext(Text, 'handy6') then
    // OutText := 'Handy 6'
    // else if containstext(Text, 'handy 3') or containstext(Text, 'handy_3') or containstext(Text, 'handy3') then
    // OutText := 'Handy 3'
    // else if containstext(Text, 'handy 5') or containstext(Text, 'handy_5') or containstext(Text, 'handy5') then
    // OutText := 'Handy 5'
  end
  else if containstext(Text, 'memor') or containstext(Text, 'memeor') or containstext(Text, 'mde') or
    containstext(Text, 'mc95') or containstext(Text, 'mc 95') then
  begin
    result := true;
    if containstext(Text, 'x3') then
      OutText := 'Memor X3'
    else if containstext(Text, '10') then
      OutText := 'Memor 10'
    else if containstext(Text, ' k') then
      OutText := 'Memor K'
    else
      OutText := 'Memor';
  end
  // else
  // OutText := Text;

end;

end.
