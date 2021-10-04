unit UEmployeeDictionary;

interface

uses
  System.generics.collections, System.classes, UEmployee, UOracleDB;

type
  TEmployeeDictionary = class(TObjectDictionary<String, TEmployee>)
  public
    /// <summary>Sucht den passenden Mitarbeiter heraus entsprechend dem anegegbenem Parameter.
    /// Gesucht wird nach ID, Name und Initialien.
    /// Wenn kein passender Mitarbeiter gefunden wurde, wird nil zurück gegeben.
    /// </summary>
    /// <returns> TEmployee
    /// </returns>
    /// <param name="searchParam"> (string) </param>
    function GetEmployee(searchParam: string): TEmployee;
    /// <summary>Lädt alle Mitarbeiter von der Datenbank erneut runter.
    /// </summary>
    procedure Refresh;
  end;

var
  EmployeeDictionary: TEmployeeDictionary;

implementation

function TEmployeeDictionary.GetEmployee(searchParam: string): TEmployee;
var
  emplID: String;
begin
  result := nil;
  for emplID in EmployeeDictionary.Keys do
  begin
    if (emplID = searchParam) then
    begin
      result := EmployeeDictionary[emplID];
      exit;
    end
    else if EmployeeDictionary[emplID].Name = searchParam then
    begin
      result := EmployeeDictionary[emplID];
      exit
    end
    else if EmployeeDictionary[emplID].NameShort = searchParam then
    begin
      result := EmployeeDictionary[emplID];
      exit
    end;
  end;

end;

procedure TEmployeeDictionary.Refresh;
var
  TempTList: TList;
  I: Integer;
  ID, Name, NameShort: String;
begin
  TempTList := nil;
  // get all employee
  try
    TempTList := TList.create;
    SelectXFromY('MAID, NAME, KURZ', 'MITARBEITER', TempTList);

    if EmployeeDictionary = nil then
      EmployeeDictionary := TEmployeeDictionary.create([doOwnsValues])
    else
    begin
      EmployeeDictionary.clear; // als TObjectDictionary, EmployeeDictionary.clear genügt
    end;

    // refill EmployeeDictionary
    for I := 0 to TempTList.Count - 1 do
    begin
      ID := TStringList(TempTList[I])[0];
      Name := TStringList(TempTList[I])[1];
      NameShort := TStringList(TempTList[I])[2];

      if not EmployeeDictionary.ContainsKey(ID) then
        EmployeeDictionary.Add(ID, TEmployee.create(ID, name, NameShort));

    end;

  finally
    for I := 0 to TempTList.Count - 1 do
      TStringList(TempTList[I]).free;
    TempTList.free;
  end;

end;

end.
