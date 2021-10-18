unit URepAppExcelWriter;

interface

uses
  Vcl.Oleauto, Vcl.Forms, system.Classes, system.Generics.Collections, math, SysUtils, variants, StrUtils,
  UEmployeeDictionary,
  UTaskDictionary, UTask, UBooking, FoSplashScreen, UTaskStatus, moreUtils;

type
  /// <summary>Dient nur zur struckturierten Erstellung von CSV's
  /// </summary>
  TTaskBookLists = class
    CustName: String;
    MaShort: String;
    WEBooks, WABooks: TObjectList<TBooking>;
    procedure AddWA(Booking: TBooking);
    procedure AddWE(Booking: TBooking);
    procedure Free;
    /// <summary>Gibt den Wareneingang und -ausgang nebeneinanderliegend als csv-formatierten Text aus,
    /// mit lineNr wir die Zeine angegeben, zum durch-itterieren
    /// händelt auch ungleiche mengen und nil
    /// (verbesserungswürdig)
    /// </summary>
    /// <returns> String
    /// </returns>
    /// <param name="lineNr"> (Integer) </param>
    function GetLine(lineNr: Integer): String;
    function WABooksCount: Integer;
    function WEBooksCount: Integer;
  end;

procedure ExpToxls(Path: String; dtfrom, dtto: TDatetime);
procedure WriteWA(Date: TDatetime; Kunde: string; stk: Integer; teil, SN, MaShort: string; WArowNr: Integer);
procedure WriteWE(Date: TDatetime; Kunde: string; stk: Integer; teil, SN, MaShort: string; WERowNr: Integer);

procedure WriteXLSCellAndSubTitle(value: String; rowNr, colNr: Integer);

procedure ExpToCSV(Path: String; dtfrom, dtto: TDatetime);

implementation

var
  ExcelApplication, ExcelWorkbook, ExcelWorksheet: Variant;
  SplashScreenExp: TFormSplashScreen;

procedure ExpToxls(Path: String; dtfrom, dtto: TDatetime);
var
  Task: TTask;
  Booking: TBooking;
  counter, maxcount: Integer;
  WARow: Integer;
  WERow: Integer;
begin
  counter := 1;
  WARow := 3;
  WERow := 3;
  SplashScreenExp := TFormSplashScreen.Create('Exportiere nach Excel(.xls)..');
  if not ContainsText(Path, '.xls') then
    Path := Path + '.xls';

  ExcelApplication := Null;
  ExcelWorkbook := Null;
  ExcelWorksheet := Null;

  try
    // ExpToExcel Excel OLE
    SplashScreenExp.Subtitle('Öffne Excel');
    ExcelApplication := CreateOleObject('Excel.Application');
  except
    ExcelApplication := Null;
    // add error/exception handling code as desired
  end;

  If not VarIsNull(ExcelApplication) then
  begin
    try
      ExcelApplication.Visible := false; // set dtto False if you do not want dtto see the activity in the background
      ExcelApplication.DisplayAlerts := false;
      // ensures message dialogs do not interrupt the flow of your automation process. May be helpful dtto set dtto True during testing and debugging.
      // Open Excel Workbook
      try
        if FileExists(ExpandFileName(ExtractFileDir(Application.ExeName)) + '\bin\ReparaturVorlage.xls') then
        // if vorlage liegt im /bin
        begin
          SplashScreenExp.Subtitle('Lade Vorlage');
          ExcelWorkbook := ExcelApplication.WorkBooks.open(ExpandFileName(ExtractFileDir(Application.ExeName)) +
            '\bin\ReparaturVorlage.xls')
        end
        else if FileExists(ExpandFileName(ExtractFileDir(Application.ExeName)) + '\ReparaturVorlage.xls') then
          // if vorlage liegt bei .exe
          ExcelWorkbook := ExcelApplication.WorkBooks.open(ExpandFileName(ExtractFileDir(Application.ExeName)) +
            '\ReparaturVorlage.xls')
        else // wenn keine Vorlage vorliegt, erstelle leeres excel
        begin
          ExcelWorkbook := ExcelApplication.WorkBooks.Add(-4167);
          { TODO -ostolle -cGeneral : ohne vorlage fehlt dem sheet die columns, die müssen zusätzlich eingetragen werden
            array mit columns, dann mit range von-bis zellen ausfüllen? }
        end;

      except
        ExcelWorkbook := Null;
        // add error/exception handling code as desired
      end;

      If not VarIsNull(ExcelWorkbook) then
      begin
        // connect to Excel Worksheet using either the ExcelApplication or ExcelWorkbook handle
        try
          ExcelWorksheet := ExcelWorkbook.WorkSheets[1]; // [1] specifies the first worksheet
        except
          ExcelWorksheet := Null;
          // add error/exception handling code as desired
        end;

        If not VarIsNull(ExcelWorksheet) then
        begin
          ExcelWorksheet.Select;
          SplashScreenExp.Subtitle('Schreibe in Datei');
          if TaskDictionary.TaskDict.Count > 0 then
          begin
            maxcount := TaskDictionary.TaskDict.Count;
            for Task in TaskDictionary.TaskDict.Values do
            begin
              SplashScreenExp.Subtitle('Schreibe in Datei | Verarbeite Auftrag ' + inttostr(counter) + ' von ' +
                inttostr(maxcount));
              if Task.BookingList <> nil then
              begin
                if Task.InBetweenDate(dtfrom, dtto) then
                  for Booking in Task.BookingList.Values do
                  begin
                    if Task.Status.TaskStatus = TTaskStatus.Geschlossen then
                      ExcelWorksheet.Cells[WARow, 1] := '''X';
                    // mit '' wird das 'X' als buchstabe geschrieben, sonst(seltsamerweise) als zahl, in Fall 'X' 88
                    if Task.GetCustomer.FullService then
                      ExcelWorksheet.Cells[WARow, 17] := '''J'
                    else
                    begin
                      ExcelWorksheet.Cells[WARow, 17] := '''N';
                      if Task.Status.BillStatusInt = 0 then
                        ExcelWorksheet.Cells[WARow, 18] := '''J';
                    end;
                    if (Booking.bookTypeID = 0) or (Booking.bookTypeID = 2) then
                    { TODO -ostolle -cGeneral : schreiben in excel sollte in array form + range geschrieben werden, damit die schreibgeschwindigkeit höher ist,
                      bei vielen daten dauert es zu lange, jede zelle einzeln zu beschreiben
                      ähnlich wie : http://www.scalabium.com/faq/dct0144.htm }
                    begin
                      WriteWE(Booking.Date, Task.GetCustomer.Name, Booking.Count, Booking.GetComponent.Name,
                        Booking.SerNr, EmployeeDictionary[Booking.employeeID].NameShort, WERow);
                      WERow := WERow + 1;
                    end
                    else
                    begin
                      WriteWA(Booking.Date, Task.GetCustomer.Name, Booking.Count, Booking.GetComponent.Name,
                        Booking.SerNr, EmployeeDictionary[Booking.employeeID].NameShort, WARow);
                      WARow := WARow + 1;
                    end;

                  end;
                // setzt beide zähler auf die gleiche ebene +1 (für abstand zwischen den aufträgen, rein optische sache)
                if WERow >= WARow then
                begin
                  WERow := WERow + 1;
                  WARow := WERow;
                end
                else
                begin
                  WARow := WARow + 1;
                  WERow := WARow;
                end;
                counter := counter + 1;
              end;
            end;
          end;
          SplashScreenExp.Subtitle('Speichere Datei in ' + Path);
          ExcelWorkbook.SaveAs(Path);
          // or
          // ExcelApplication.WorkBooks[1].SaveAs(NewExcelFileName);
          // Note: If a file with the new name already exists, it overwrites it. Write additional code dtto address as desired.
          // reference
          // https://docs.microsoft.com/en-us/office/vba/api/excel.workbook.saveas
        end;
      end;
    finally
      SplashScreenExp.Subtitle('Schließe Excel');
      ExcelApplication.WorkBooks.Close;
      ExcelApplication.DisplayAlerts := true;
      ExcelApplication.Quit; // erstmal nicht schließen

      ExcelWorksheet := Unassigned;
      ExcelWorkbook := Unassigned;
      ExcelApplication := Unassigned;
      SplashScreenExp.Free;
    end;
  end;

end;

procedure WriteWA(Date: TDatetime; Kunde: string; stk: Integer; teil, SN, MaShort: string; WArowNr: Integer);
begin
  WriteXLSCellAndSubTitle(FormatDateTime('dd.mm.yyyy', Date), WArowNr, 2);
  WriteXLSCellAndSubTitle(Kunde, WArowNr, 3);
  WriteXLSCellAndSubTitle(inttostr(stk), WArowNr, 4);
  WriteXLSCellAndSubTitle(teil, WArowNr, 5);
  WriteXLSCellAndSubTitle(SN, WArowNr, 6);
  WriteXLSCellAndSubTitle(MaShort, WArowNr, 7);
end;

procedure WriteWE(Date: TDatetime; Kunde: string; stk: Integer; teil, SN, MaShort: string; WERowNr: Integer);
begin
  WriteXLSCellAndSubTitle(FormatDateTime('dd.mm.yyyy', Date), WERowNr, 8);
  WriteXLSCellAndSubTitle(Kunde, WERowNr, 9);
  WriteXLSCellAndSubTitle(inttostr(stk), WERowNr, 10);
  WriteXLSCellAndSubTitle(teil, WERowNr, 11);
  WriteXLSCellAndSubTitle(SN, WERowNr, 12);
  WriteXLSCellAndSubTitle(MaShort, WERowNr, 13);
end;

procedure WriteXLSCellAndSubTitle(value: String; rowNr, colNr: Integer);
begin
  if SplashScreenExp <> nil then
    SplashScreenExp.SubTitle2(value);
  ExcelWorksheet.Cells[rowNr, colNr] := value;
end;

procedure ExpToCSV(Path: String; dtfrom, dtto: TDatetime);
var
  Task: TTask;
  Booking: TBooking;
  counter, maxcount, maxcountbooks: Integer;
  // writer: TTextWriter;
  TaskBookLists: TTaskBookLists;
  I: Integer;
  TStat, RStat1, RStat2: String;
  list: TStrings;
begin

  counter := 1;
  try
    SplashScreenExp := TFormSplashScreen.Create('Exportiere CSV..');
    SplashScreenExp.Subtitle('Erstelle Datei');
    // writer := TStreamWriter.Create(TFilestream.Create(Path, fmcreate), TEncoding.UTF8);
    // writer := TStreamWriter.Create(Path);
    list := TStringList.Create; // list.SaveToFile(path, TEncoding.UTF8);
    if TaskDictionary.TaskDict.Count > 0 then
    begin
      maxcount := TaskDictionary.TaskDict.Count;
      SplashScreenExp.Subtitle('Schreibe in CSV-Datei');
      // writer.WriteLine
      // ('OK;DATUM;KUNDE;STK;TEIL;SN;TWI;DATUM;KUNDE;STK;TEIL;SN;TWI;REPARATUR;ZEIT;MATERIAL;SERVICE;RE;'); // columns
      list.Add('OK;DATUM;KUNDE;STK;TEIL;SN;TWI;DATUM;KUNDE;STK;TEIL;SN;TWI;REPARATUR;ZEIT;MATERIAL;SERVICE;RE;');
      for Task in TaskDictionary.TaskDict.Values do
      begin
        SplashScreenExp.Subtitle('Schreibe in CSV-Datei | Verarbeite Auftrag ' + inttostr(counter) + ' von ' +
          inttostr(maxcount));
        if Task.BookingList <> nil then
        begin
          if Task.InBetweenDate(dtfrom, dtto) then
          begin
            // erstelle TaskBookLists aud diesem Task, um werte strukturiert ausgeben zu können
            try
              begin
                TaskBookLists := TTaskBookLists.Create;
                TaskBookLists.CustName := Task.GetCustomer.Name;

                for Booking in Task.BookingList.Values do
                begin
                  TaskBookLists.MaShort := EmployeeDictionary[Booking.employeeID].NameShort;
                  // je nach typ in eine der listen eintragen
                  case Booking.bookTypeID of
                    0, 2:
                      TaskBookLists.AddWE(Booking);
                    1, 3:
                      TaskBookLists.AddWA(Booking);
                  end;
                end;

                if Task.Status.TaskStatus = TTaskStatus.Geschlossen then
                  TStat := 'X;'
                else
                  TStat := ';';

                if Task.GetCustomer.FullService then
                begin
                  RStat1 := 'J;';
                end
                else
                begin
                  RStat1 := 'N;';
                  if Task.Status.BillStatusInt = 0 then
                    RStat2 := 'J;'
                  else
                    RStat2 := ';';
                end;

                maxcountbooks := max(TaskBookLists.WABooksCount, TaskBookLists.WEBooksCount);
                for I := 0 to maxcountbooks - 1 do
                begin
                  list.Add(TStat + TaskBookLists.GetLine(I) + ';;;' + RStat1 + RStat2);
                  // writer.WriteLine(TStat + TaskBookLists.GetLine(I) + ';;;' + RStat1 + RStat2);
                  // entspricht der Tabelle aus der Vorlage
                end;
                // writer.WriteLine; // extra Zeile, um Buchungen auftragsweise zu separieren
                list.Add('');

              end
            finally
              TaskBookLists.Free;
            end;

          end;
        end;
        counter := counter + 1;
      end;
    end;
  finally
    list.SaveToFile(Path, TEncoding.UTF8);
    list.Free;
    // writer.Close;
    // writer.Free;
    SplashScreenExp.Free;
  end;

end;

procedure TTaskBookLists.AddWA(Booking: TBooking);
begin
  if WABooks = nil then
    WABooks := TObjectList<TBooking>.Create(false);
  WABooks.Add(Booking);
end;

procedure TTaskBookLists.AddWE(Booking: TBooking);
begin
  if WEBooks = nil then
    WEBooks := TObjectList<TBooking>.Create(false);
  WEBooks.Add(Booking);
end;

procedure TTaskBookLists.Free;
begin
  if WEBooks <> nil then
    WEBooks.Free;
  if WABooks <> nil then
    WABooks.Free;
  inherited Free;
end;

function TTaskBookLists.GetLine(lineNr: Integer): String;
var
  Book: TBooking;
begin
  if WEBooks <> nil then
  begin
    if lineNr <= WEBooks.Count - 1 then
    begin
      Book := WEBooks[lineNr];
      result := FormatDateTime('dd.mm.yyyy', Book.Date) + ';' + (CustName) + ';' + inttostr(Book.Count) + ';' +
        (Book.GetComponent.Name) + ';' + Book.SerNr + ';' + MaShort + ';';
    end
    else
      result := ';;;;;;';
  end
  else
    result := ';;;;;;';

  if WABooks <> nil then
  begin
    if lineNr <= WABooks.Count - 1 then
    begin
      Book := WABooks[lineNr];
      result := result + FormatDateTime('dd.mm.yyyy', Book.Date) + ';' + (CustName) + ';' + inttostr(Book.Count) + ';' +
        (Book.GetComponent.Name) + ';' + Book.SerNr + ';' + MaShort + ';';
    end

    else
      result := result + ';;;;;;';
  end
  else
    result := result + ';;;;;;';
end;

function TTaskBookLists.WABooksCount: Integer;
begin
  if WABooks = nil then
    result := 0
  else
    result := WABooks.Count;

end;

function TTaskBookLists.WEBooksCount: Integer;
begin
  if WEBooks = nil then
    result := 0
  else
    result := WEBooks.Count;

end;

end.
