unit UBooking;

interface

uses UComponent, UEmployee, System.Classes, Sysutils, moreUtils, UComponentDictionary, UEmployeeDictionary;

type
  TBooking = class(TObject)
    BookingID, Book_PosID: String;
    componentID: String;
    count: Integer;
    SerNr: String;
    noBalance: boolean;
    bookTypeID: Integer;
    // date: String;
    date: TDatetime;
    packageID: String;
    employeeID: String;
    comment: String;
    hoursStr: String;
    hoursDez: double;
    function GetComponent: TComp;
  private
  public
    constructor Create(Row: TStringList);

  end;

  // var
  // BookingTypeArray: array [0 .. 3] of string = (
  // 'Wareneingang',
  // 'Warenausgang',
  // 'Persönlich abgeholt',
  // 'Persönlich übergeben'
  // );

implementation

constructor TBooking.Create(Row: TStringList);
begin
  inherited Create;
  Book_PosID := Row[0];
  BookingID := Row[1];
  componentID := Row[2];
  count := StrToInt(Row[3]);
  SerNr := Row[4];
  noBalance := NumberToBool(Row[5]);
  bookTypeID := StrToInt(Row[8]);
  date := StrToDateTime(Row[9]);
  packageID := Row[10];
  employeeID := Row[11];
  comment := UTF8Encode(Row[12]);
  hoursStr := Row[13];
  hoursDez := StrToFloat(hoursStr);

end;

function TBooking.GetComponent: TComp;
begin
  Result := ComponentDictionary.GetComponent(componentID);
end;

end.
