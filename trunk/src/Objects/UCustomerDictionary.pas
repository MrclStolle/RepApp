unit UCustomerDictionary;

interface

uses SysUtils, generics.collections, UCustomer, System.classes, UOracleDB, moreUtils;

type
  /// <summary>TCustomerDictionary ist ein Objekt, welches alle Kunden von der Datenbank abrufen, diese speichern und ausgeben kann.
  /// Dazu beinhaltet es eine sortierte Liste aller Kunden-Namen.
  /// </summary>
  TCustomerDictionary = class(TObject)
    CustDict: TObjectDictionary<String, TCustomer>;
    CustDictInv_LowerC: TObjectDictionary<String, TCustomer>;
    CustNameList: TStringList;
  private
  public
    /// <summary>Erstellt ein neues Dictionary-Objekt für TCustomer.
    /// </summary>
    /// <param name="refresh"> (Boolean) Angabe, ob das Objekt direkt aus der Datenbank
    /// befüllt werden soll.</param>
    constructor create(refresh: Boolean);
    /// <summary>Fügt der CustomerDictionary einen Kunden hinzu. Doppelte ID's sind nicht möglich.
    /// </summary>
    /// <param name="Customer"> (TCustomer) </param>
    procedure Add(Customer: TCustomer);
    procedure Clear; reintroduce;
    /// <summary>Prüft, ob die CustomerDictionary
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    /// <param name="custname"> (string) </param>
    function ContainsName(custname: string): Boolean;
    /// <summary>Gibt die Menge an gespeicherten Kunden zurück.
    /// </summary>
    /// <returns> Integer
    /// </returns>
    function Count: Integer;
    procedure Free; reintroduce;
    /// <summary>Gibt einen Kunden zurück, wenn der String als ID oder Kunden-Name gefunden wurde.
    /// Bei keinem Ergebnis wird nil zurück gegeben.
    /// </summary>
    /// <returns> TCustomer
    /// </returns>
    /// <param name="str"> ID oder name der gesuchten Kunden(string) </param>
    function GetCustomer(str: string): TCustomer;
    /// <summary>Gibt eine sortierte Liste aller Kunden-Namen zurück
    /// </summary>
    /// <returns> TStringList
    /// </returns>
    function GetSortedNameList: TStringList;
    procedure RefreshFromDatabase;
  end;

var
  CustomerDictionary: TCustomerDictionary;

implementation

constructor TCustomerDictionary.create(refresh: Boolean);
begin
  inherited create;

  self.CustDict := TObjectDictionary<String, TCustomer>.create([doOwnsValues]);
  self.CustDictInv_LowerC := TObjectDictionary<String, TCustomer>.create;
  self.CustNameList := TStringList.create;

  if refresh then
    self.RefreshFromDatabase;
end;

procedure TCustomerDictionary.Add(Customer: TCustomer);
begin
  CustDict.Add(Customer.ID, Customer);
  CustDictInv_LowerC.Add(lowercase(Customer.Name), Customer);
  CustNameList.Add(Customer.Name);
end;

procedure TCustomerDictionary.Clear;
begin
  if CustDict <> nil then
    CustDict.Clear;
  if CustDictInv_LowerC <> nil then
    CustDictInv_LowerC.Clear;
  if CustNameList <> nil then
  begin
    CustNameList.Clear;
    CustNameList.Sorted := false;
  end;
end;

function TCustomerDictionary.ContainsName(custname: string): Boolean;
begin
  Result := CustDictInv_LowerC.ContainsKey(lowercase(custname));

end;

function TCustomerDictionary.Count: Integer;
begin
  Result := CustDict.Count;

end;

procedure TCustomerDictionary.Free;
begin
  if CustDict <> nil then
    CustDict.Free;
  if CustDictInv_LowerC <> nil then
    CustDictInv_LowerC.Free;
  if CustNameList <> nil then
    CustNameList.Free;
  inherited;
end;

function TCustomerDictionary.GetCustomer(str: string): TCustomer;
begin
  if CustDictInv_LowerC.ContainsKey(lowercase(str)) then
    Result := CustDictInv_LowerC[lowercase(str)]
  else if CustDict.ContainsKey(str) then
    Result := CustDict[str]
  else
  begin
    Result := nil;
  end;
end;

function TCustomerDictionary.GetSortedNameList: TStringList;
begin
  if not CustNameList.Sorted then
  begin
    CustNameList.Sort;
    CustNameList.Sorted := true;
  end;

  Result := CustNameList;

end;

procedure TCustomerDictionary.RefreshFromDatabase;
var
  TempTList: TList;
  I: Integer;
  row: TStringList;
begin
  TempTList := TList.create;
  SelectXFromYWhereZOrderBy('*', 'KUNDEN', '', 'name', TempTList);

  self.Clear;

  for I := 0 to TempTList.Count - 1 do
  begin
    row := TStringList(TempTList[I]);
    self.Add(TCustomer.create(row[0], row[1], NumbertoBool(row[2]), NumbertoBool(row[3])));
  end;

  for I := 0 to TempTList.Count - 1 do
  begin
    TStringList(TempTList[I]).Free;
  end;
  TempTList.Free;

end;

end.
