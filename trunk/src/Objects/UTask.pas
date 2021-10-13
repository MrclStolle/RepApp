unit UTask;

interface

uses UCustomer, UComponent, System.Generics.Collections, System.Classes, sysutils, UTaskStatus, UBooking,
  UCustomerDictionary;

type
  container = class(Tobject)
    name: String;
    count: integer;
  public
    constructor Create(name: string; count: integer);
  end;

type
  TTask = class(Tobject)
    ID, Kommentar: String;
    CustomerID: String;
    BookingList: TObjectDictionary<string, TBooking>;
    BookingOrderList: TStringList;
    ComponentBalanceDictionary: TObjectDictionary<String, container>;
    // normale TDictionary erzeugt wieder blöde, nicht einfach lösbare memory-leaks, daher TObjectDictionary mit container-klasse
    Status: TStatus;
    Hours: double;
    function GetCustomer: TCustomer;
    /// <summary>Überprüft die ComponentBalanceDictionary auf einen ausgeglichenen Warenfluss in diesem Auftrag.
    /// Ist dieser ausgeglichen, oder die ComponentBalanceDictionary = nil, wird 'true' zurück gegeben.
    /// </summary>
    function isBalanced: Boolean;
  private

  public
    constructor Create(Row: TStringList; CustomerID: String);
    procedure Free; reintroduce;
    procedure AddBooking(Row: TStringList);
    /// <summary>Adds a component and its count to the Dictionary,
    /// if dictionary already contains this component, the count-value will just be
    /// added
    /// </summary>
    /// <param name="name"> (string) </param>
    /// <param name="count"> (Integer) </param>
    procedure AddToCompBalanceDict(name: string; count: integer);
    function GetNewStatus: integer;
    procedure Clear;
    /// <summary> Searches trought Bookings and compares their Date with Parameter-Dates.
    /// If a booking contains a date inbetween parameters, result will be true.
    /// If there are no Bookings, result will be false;
    /// if minDT=0 and maxDt=datetimeMax, result will be true(no filter);
    /// </summary>
    /// <param name="minDT"> (TDateTime) </param>
    /// <param name="maxDT"> (TDateTime) </param>
    function InBetweenDate(minDT: TDatetime; maxDT: TDatetime): Boolean;
  end;

implementation

constructor TTask.Create(Row: TStringList; CustomerID: String);
begin
  inherited Create;
  self.BookingList := nil;
  self.ComponentBalanceDictionary := nil;
  Hours := 0;
  ID := Row[0];
  // self.Customer := Customer;
  // StatusID := StrToInt(Row[2]);
  self.CustomerID := CustomerID;
  Kommentar := Row[3];
  Status.Create(StrToInt(Row[2]), StrToInt(Row[4]), StrToInt(Row[5]));

end;

procedure TTask.AddBooking(Row: TStringList);
var
  booking: TBooking;
begin

  if self.BookingList = nil then
    self.BookingList := TObjectDictionary<string, TBooking>.Create([doOwnsValues]);
  if BookingOrderList = nil then
    BookingOrderList := TStringList.Create;
  try
    booking := TBooking.Create(Row);
    BookingList.Add(booking.Book_PosID, booking);
    BookingOrderList.Add(booking.Book_PosID);
    Hours := Hours + booking.hoursDez;

    if not booking.noBalance then
      case booking.bookTypeID of
        1, 3:
          self.AddToCompBalanceDict(booking.getComponent.name, -booking.count);
        0, 2:
          self.AddToCompBalanceDict(booking.getComponent.name, booking.count);
      end;
  finally

  end;

end;

procedure TTask.AddToCompBalanceDict(name: string; count: integer);
begin
  if ComponentBalanceDictionary <> nil then
  begin
    if ComponentBalanceDictionary.count <> 0 then
    // if dict exists, check if it contains name, else add name(key) and value
    begin
      if ComponentBalanceDictionary.ContainsKey(name) then
        ComponentBalanceDictionary[name].count := ComponentBalanceDictionary[name].count + count
      else
        ComponentBalanceDictionary.Add(name, container.Create(name, count));
    end
  end
  else // else create dict and add name(key) and value
  begin
    self.ComponentBalanceDictionary := TObjectDictionary<String, container>.Create([doOwnsValues]);
    self.ComponentBalanceDictionary.Add(name, container.Create(name, count));
  end;

end;

procedure TTask.Clear;
begin
  if ComponentBalanceDictionary <> nil then
    ComponentBalanceDictionary.Clear;
  if BookingList <> nil then
    BookingList.Clear;
  if BookingOrderList <> nil then
    BookingOrderList.Clear;
end;

procedure TTask.Free;
// var
// key: string;
begin
  if ComponentBalanceDictionary <> nil then
  begin
    // ComponentBalanceDictionary.Clear;
    ComponentBalanceDictionary.Free;
  end;

  if self.BookingList <> nil then
    BookingList.Free;

  if BookingOrderList <> nil then
    BookingOrderList.Free;

  Inherited Free;
end;

function TTask.GetCustomer: TCustomer;
begin
  result := CustomerDictionary.GetCustomer(CustomerID);
end;

function TTask.GetNewStatus: integer;
var
  WAopen, WEopen: Boolean;
  value: container;
begin
  WAopen := false;
  WEopen := false;
  if ComponentBalanceDictionary <> nil then
  begin
    for value in ComponentBalanceDictionary.Values do
    begin
      if value.count > 0 then
        WAopen := true
      else if value.count < 0 then
        WEopen := true;
    end;

    if (WAopen and WEopen) then
      result := 3 // WE u. WA offen
    else if WAopen then
      result := 2 // WA offen
    else if WEopen then
      result := 1 // WE offen
    else
      result := 0; // ausgeglichen
  end
  else
    // result := self.Status.WareStatusInt // if dictionary is nil, return old status
    result := 0

end;

function TTask.InBetweenDate(minDT: TDatetime; maxDT: TDatetime): Boolean;
var
  booking: TBooking;
begin
  result := false;
  if minDT <> 0 then
    minDT := minDT - 1;

  if (minDT <> 0) or (maxDT <> MaxDateTime) then
  begin
    if BookingList <> nil then
      for booking in BookingList.Values do
      begin
        if (booking.date <= maxDT) and (booking.date >= minDT) then
        begin
          result := true;
          break;
        end;
      end
    else
      result := false;
  end
  else
    result := true;
  // else
  // result := true;
  // if both are nil, just return false
end;

function TTask.isBalanced: Boolean;
var
  cont: container;
begin
  result := true;
  if ComponentBalanceDictionary <> nil then
    for cont in ComponentBalanceDictionary.Values do
    begin
      if cont.count <> 0 then
        result := false;
    end;
end;

constructor container.Create(name: string; count: integer);
begin
  inherited Create;
  self.name := name;
  self.count := count;
end;

end.
