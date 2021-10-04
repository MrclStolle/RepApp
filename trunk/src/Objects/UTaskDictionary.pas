unit UTaskDictionary;

interface

uses
  generics.collections, System.classes, sysutils, UTask, UOracleDB, UCustomerDictionary,
  UCustomer, UBooking, UUser;

type
  /// <summary>TTaskDictionary ist ein Object, welches alle Aufträge von der Datenbank abrufen, diese speichern und ausgeben kann.
  /// </summary>
  TTaskDictionary = class(TObject)
    TaskDict: TObjectDictionary<String, TTask>; // key=TaskID
    TaskorderByCust: TStringList; // List of TaskID's, order by Customer-ID's(default by querry)
  public
    /// <summary>Erstellt die TaskDictionary und füllt sie sofort mit Werten aus der
    /// angegebenen Datenbank. Mit dem 'whereFilter'-Parameter kann eine entsprechende
    /// Klausel für die Select-Anweisung angegeben werden.
    /// </summary>
    /// <param name="whereFilter">z.B.  "where STATUSID !=0" (String) </param>
    constructor Create(whereFilter: String); overload;
    /// <summary>Fügt der Dictionary einen bestimmten Auftrag hinzu
    /// </summary>
    /// <param name="Task"> (TTask) </param>
    procedure Add(Task: TTask);
    /// <summary>Leert die Dictionary und alle dazugehörigen Aufträge.
    /// </summary>
    procedure Clear;
    /// <summary>Abfrage, ob eine bestimmte Auftrags-ID in der Dictionary vorhanden ist.
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="TaskID"> (String) </param>
    function ContainsID(TaskID: String): Boolean;
    /// <summary>Gibt die Menge an gespeicherten Aufträgen in der Dictionary zurück.
    /// </summary>
    /// <returns> Integer
    /// </returns>
    function Count: Integer;
    /// <summary>Gibt sich selbst und alle zugehörigen Speicherplätze frei.
    /// </summary>
    procedure Free;
    /// <summary>Gibt den zugehörigen Kunden zur angegbenen Auftrags-ID zurück.
    /// </summary>
    /// <returns> TCustomer
    /// </returns>
    /// <param name="TaskID">ID des Auftrags (String) </param>
    function GetCustomer(TaskID: String): TCustomer;
    /// <summary>Gibt den Task aus dieser Dictionary zurück, welcher die entsprechende ID enthält.
    /// </summary>
    /// <returns> TTask
    /// </returns>
    /// <param name="TaskID"> ID des gesuchten Auftrags (String) </param>
    function GetTask(TaskID: String): TTask;
    /// <summary>Befüllt die TTaskDictionary erneut mit frischen Werten aus der
    /// hinterlegten Datenbank.
    /// Tables: AUFTRAG, BUCHPOS_TEILE, BUCHUNGEN
    /// </summary>
    /// <param name="whereFilter">Filter-Klausel für die Select-Abfrage. zB. "WHERE
    /// AUFTID=56"</param>
    procedure RefreshFromDatabase(whereFilter: String);
    /// <summary>Gibt die nach Kunden-ID sortierte Auftrags-ID-Liste (TStringList)
    /// zurück.
    /// </summary>
    /// <returns> TStringList mit Auftrags-ID's
    /// </returns>
    function SortedTasksList: TStringList;
    /// <summary>Überprüft, ob die "Warenein- und Warenausgang"-Balance mit dem Waren-Status aller geladenen Tasks überein stimmt.
    /// Wenn differenzen existieren, wird true zurück gegeben.
    /// </summary>
    function CheckForTaskStatusDifferences: Boolean;
  end;

var
  TaskDictionary: TTaskDictionary;

implementation

constructor TTaskDictionary.Create(whereFilter: String);
begin
  inherited Create;
  self.RefreshFromDatabase(whereFilter);
end;

procedure TTaskDictionary.Add(Task: TTask);
begin
  TaskDict.Add(Task.ID, Task);
  TaskorderByCust.Add(Task.ID); // Tasks sorted by CustomerID's, default sorted by querry
end;

procedure TTaskDictionary.Clear;
var
  ETask: TTask;
begin
  if TaskDict <> nil then
  begin
    for ETask in TaskDict.Values do
    begin
      ETask.Clear;
    end;
    TaskDict.Clear;
  end;

  if TaskorderByCust <> nil then
    TaskorderByCust.Clear;
end;

function TTaskDictionary.ContainsID(TaskID: String): Boolean;
begin
  Result := TaskDict.ContainsKey(TaskID);

end;

function TTaskDictionary.Count: Integer;
begin
  Result := TaskDict.Count;
end;

procedure TTaskDictionary.Free;
var
  Task: TTask;
begin
  if TaskDict <> nil then
    for Task in self.TaskDict.Values do
    begin
      if Task <> nil then
        Task.Free;
    end;

  TaskDict.Free;

  if TaskorderByCust <> nil then
    TaskorderByCust.Free;
  inherited Free;
end;

function TTaskDictionary.GetCustomer(TaskID: String): TCustomer;
begin
  Result := TaskDict[TaskID].GetCustomer;

end;

function TTaskDictionary.GetTask(TaskID: String): TTask;
begin
  Result := TaskDict[TaskID];

end;

procedure TTaskDictionary.RefreshFromDatabase(whereFilter: String);
var
  BookPosTable: TList;
  I: Integer;
  I2: Integer;
  Task: TTask;
  TaskTable: TList;
begin
  TaskTable := TList.Create;
  BookPosTable := TList.Create;

  if TaskDict <> nil then
    for Task in TaskDict.Values do
    begin
      Task.Free;
    end;
  TaskDict.Free;

  TaskDict := TObjectDictionary<String, TTask>.Create;

  if TaskorderByCust <> nil then
    TaskorderByCust.Free;
  TaskorderByCust := TStringList.Create;

  // if (whereFilter <> '') xor (timespan <> '') then
  // whereFilter := 'where ' + whereFilter + timespan
  // else if (whereFilter <> '') and (timespan <> '') then
  // whereFilter := 'where ' + whereFilter + ' and ' + timespan;

  ExecuteDQLQuery('select * from AUFTRAG ' + 'left join BUCHUNGEN on BUCHUNGEN.AUFTRID=AUFTRAG.AUFTRID ' + whereFilter +
    ' order by KUNDEID, DATUM', TaskTable);

  // if whereFilter <> '' then
  // whereFilter := 'where ' + whereFilter
  // else
  // whereFilter := '';

  ExecuteDQLQuery('select * from BUCHPOS_TEILE ' + 'left join BUCHUNGEN on BUCHPOS_TEILE.BUCHID=BUCHUNGEN.BUCHID ' +
    'left join AUFTRAG on BUCHUNGEN.AUFTRID=AUFTRAG.AUFTRID ' + whereFilter + ' order by DATUM', BookPosTable);

  for I := 0 to TaskTable.Count - 1 do
  begin
    if not TaskDict.ContainsKey(TStringList(TaskTable[I])[0]) then
    begin
      Task := TTask.Create(TaskTable[I], TStringList(TaskTable[I])[1]);

      for I2 := BookPosTable.Count - 1 downto 0 do
      begin
        if Task.ID = TStringList(BookPosTable[I2])[7] then
        begin
          Task.AddBooking(BookPosTable[I2]);
          // eintrag entfernen für schnellere bearbeitung um nächsten TaskTable-loop
          TStringList(BookPosTable[I2]).Free;
          BookPosTable.Delete(I2);
        end;
      end;

      TaskDict.Add(Task.ID, Task);
      TaskorderByCust.Add(Task.ID); // List of TaskID's sorted by Customer-ID's(default by querry)

    end;
  end;

  // free both tables
  for I := 0 to TaskTable.Count - 1 do
    TStringList(TaskTable[I]).Free;
  TaskTable.Free;

  for I := 0 to BookPosTable.Count - 1 do
    TStringList(BookPosTable[I]).Free;
  BookPosTable.Free;

end;

function TTaskDictionary.SortedTasksList: TStringList;
begin
  Result := TaskorderByCust;
end;

function TTaskDictionary.CheckForTaskStatusDifferences: Boolean;
var
  Task: TTask;
  NewWareStatus: Integer;
begin
  Result := false;

  for Task in TaskDictionary.TaskDict.Values do
  begin
    NewWareStatus := Task.GetNewStatus;
    if strtoint(Task.Status.WareStatusNr) <> NewWareStatus then
    begin
      // update in db
      UpdateTaskTableWareStatusID(Task.ID, IntToStr(NewWareStatus));
      // update locally
      Task.Status.SetWareStatus(NewWareStatus);

      // insert change into AuftrProtokoll from local
      InsertIntoAuftrProt(Task.ID, User.ID, Task.Status.TaskStatusNr, FormatDateTime('dd-mm-yy', now),
        floattostr(Task.Hours), Task.Kommentar, Task.Status.WareStatusNr, Task.Status.BillStatusNr);

      Result := true;
    end;
  end;

end;

end.
