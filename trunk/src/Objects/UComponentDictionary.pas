unit UComponentDictionary;

interface

uses SysUtils, generics.collections, UComponent, System.classes, UOracleDB, moreUtils, FoSplashScreen;

type
  /// <summary>TComponentDictionary ist ein Objekt, welches alle Komponenten von der Datenbank abrufen, diese speichern und ausgeben kann.
  /// Dazu speichert dieses alle bisher verwendeten Seriennummern und eine sortierte Liste aller Komponenten-Namen.
  /// </summary>
  TComponentDictionary = class(TObject)
    CompDict: TObjectDictionary<String, TComp>;
    CompDictInv_LowerC: TObjectDictionary<String, TComp>;
    CompNameList: TStringList;
    SerNrList: TStringList;
  private

  public
    /// <summary>Erstellt ein neues TComponentDictionary-Objekt. Optional befüllt es sich sofort selbst über die Datenbank.
    /// </summary>
    /// <param name="refresh"> (Boolean) Angabe, ob das Objekt beim Erstellen direkt aus der Datenbank
    /// befüllt werden soll.</param>
    constructor create(refresh: Boolean);
    /// <summary>Fügt der ComponentDictionary die angegebene Komponente hinzu.
    /// </summary>
    /// <param name="comp"> (TComp) </param>
    procedure Add(comp: TComp);
    /// <summary>Leert die ComponentDictionary vollständig.
    /// </summary>
    procedure Clear; reintroduce;
    /// <summary>Sucht in der ComponentDictionary, ob der angegebene Komponenten-Name vorhanden/bekannt ist.
    /// </summary>
    /// <returns> True/False, ob vorhanden oder nicht (Boolean)
    /// </returns>
    /// <param name="compname"> Zu Suchender Name/Text (string) </param>
    function ContainsName(compname: string): Boolean;
    /// <summary>Gibt die Anzahl der gespeicherten Komponenten in der ComponentDictionary zurück.
    /// </summary>
    /// <returns> Integer
    /// </returns>
    function Count: Integer;
    /// <summary>Gibt den speicher frei, den die ComponentDictionary belegt.
    /// </summary>
    procedure Free; reintroduce;
    /// <summary>Gibt eine TComponent zurück, wenn der String als ID oder Komponenten-Name in der ComponentDictionary gefunden
    /// wurde. Bei keinem Ergebnis wird nil zurück gegeben.
    /// </summary>
    /// <returns> TComponent
    /// </returns>
    /// <param name="str"> ID oder name der gesuchten Komponente(string) </param>
    function GetComponent(str: string): TComp;
    /// <summary>Gibt eine sortierte Liste aller Kompnenten-namen zurück.
    /// </summary>
    /// <returns> TStringList
    /// </returns>
    function GetSortedNameList: TStringList;
    /// <summary>Gibt eine sortierte Liste aller in der Datenbank eingetragenen Seriennummern zurück.
    /// </summary>
    /// <returns> TStringList
    /// </returns>
    function GetSerNrList: TStringList;
    /// <summary>Lädr alle Komponenten-Daten neu von der Datenbank runter und speichert diese.
    /// </summary>
    procedure RefreshFromDatabase;
    procedure RefreshSerNrList;
  end;

var
  ComponentDictionary: TComponentDictionary;

implementation

constructor TComponentDictionary.create(refresh: Boolean);
begin
  inherited create;

  self.CompDict := TObjectDictionary<String, TComp>.create([doOwnsValues]);
  self.CompDictInv_LowerC := TObjectDictionary<String, TComp>.create;
  self.CompNameList := TStringList.create;
  self.SerNrList := TStringList.create;

  if refresh then
    self.RefreshFromDatabase;
end;

procedure TComponentDictionary.Add(comp: TComp);
begin
  CompDict.Add(comp.ID, comp);
  CompDictInv_LowerC.Add(lowercase(comp.Name), comp);
  CompNameList.Add(comp.Name);

end;

procedure TComponentDictionary.Clear;
begin
  if CompDict <> nil then
    CompDict.Clear;

  if CompDictInv_LowerC <> nil then
    CompDictInv_LowerC.Clear;

  if CompNameList <> nil then
  begin
    CompNameList.Clear;
    CompNameList.Sorted := false;
  end;

  if SerNrList <> nil then
    SerNrList.Clear;
end;

function TComponentDictionary.ContainsName(compname: string): Boolean;
begin
  Result := CompDictInv_LowerC.ContainsKey(lowercase(compname));

end;

function TComponentDictionary.Count: Integer;
begin
  Result := CompDict.Count;

end;

procedure TComponentDictionary.Free;
begin
  if CompDictInv_LowerC <> nil then
    CompDictInv_LowerC.Free;

  if CompDict <> nil then
    CompDict.Free;

  if CompNameList <> nil then
    CompNameList.Free;

  if SerNrList <> nil then
    SerNrList.Free;

  inherited;
end;

function TComponentDictionary.GetComponent(str: string): TComp;
begin
  if CompDictInv_LowerC.ContainsKey(lowercase(str)) then
    Result := CompDictInv_LowerC[lowercase(str)]
  else if CompDict.ContainsKey(str) then
    Result := CompDict[str]
  else
  begin
    Result := nil;
  end;
end;

function TComponentDictionary.GetSortedNameList: TStringList;
begin
  if not CompNameList.Sorted then
  begin
    CompNameList.Sort;
    CompNameList.Sorted := true;
  end;

  Result := CompNameList;

end;

function TComponentDictionary.GetSerNrList: TStringList;
begin
  Result := SerNrList;
end;

procedure TComponentDictionary.RefreshFromDatabase;
var
  TempTList: TList;
  I: Integer;
  TSL: TStringList;

begin

  // get all comonents from db
  TempTList := TList.create;
  SelectXFromYWhereZOrderBy('*', 'TEILE', '', 'NAME', TempTList);

  self.Clear; // leert alle collections

  for I := 0 to TempTList.Count - 1 do
  begin
    TSL := TStringList(TempTList[I]);
    self.Add(TComp.create(TSL[0], TSL[1], NumbertoBool(TSL[2]), TSL[3], TSL[4]));

  end;

  for I := 0 to TempTList.Count - 1 do
  begin
    TStringList(TempTList[I]).Free;
  end;
  TempTList.Free;
  RefreshSerNrList;

end;

procedure TComponentDictionary.RefreshSerNrList;
begin
  if SerNrList = nil then
    SerNrList := TStringList.create
  else
    SerNrList.Clear;
  GetAllSNumbers(SerNrList);
  SerNrList.Sort;
end;

end.
