unit moreUtils;

interface

uses sysutils, Vcl.Graphics;

/// <summary>Gibt true/false als 1/0 (string) zurück
/// </summary>
/// <returns> String
/// </returns>
/// <param name="b"> (boolean) </param>
function BoolToNumber(b: boolean): String;
function NumberToBool(Number: String): boolean;
/// <summary>Gibt true/false als 1/0(Integer) zurück
/// </summary>
/// <returns> Integer
/// </returns>
/// <param name="b"> (boolean) </param>
function BoolToInt(b: boolean): Integer;
/// <summary>Gibt 1/2 als true/false zurück
/// </summary>
/// <returns> boolean
/// </returns>
/// <param name="i"> (Integer) </param>
function IntToBool(i: Integer): boolean;
/// <summary>Gibt true/false als "Ja" / "Nein" (string) zurück
/// </summary>
/// <returns> String
/// </returns>
/// <param name="b"> (boolean) </param>
function BoolToYN(b: boolean): String;
function AssignColor(nrOfColors, IndexNumber: Integer): TColor;

procedure ConvertHourDezToHourMin(HourDez: double; var ResHours, ResMinutes: Integer);
procedure ConvertHourMinToHourDez(Hours, Minutes: Integer; var ResHourDez: double);
function HasDigit(const value: string): boolean;

implementation

function BoolToNumber(b: boolean): String;
begin
  if b then
    result := '1'
  else
    result := '0';
end;

function NumberToBool(Number: String): boolean;
begin
  if Number = '0' then
    result := false
  else if Number = '1' then
    result := true
  else
    raise EArgumentOutOfRangeException.Create('Parameter(String) not ''1'' or ''0''');
end;

function BoolToInt(b: boolean): Integer;
begin
  case b of
    true:
      result := 1;
  else
    result := 0;

  end;
end;

function IntToBool(i: Integer): boolean;
begin
  case i of
    1:
      result := true;
    0:
      result := false;
  else
    raise EArgumentOutOfRangeException.Create('Parameter(Integer) not 1 or 0');
  end;
end;

function BoolToYN(b: boolean): String;
begin
  if b then
    result := 'ja'
  else
    result := 'nein';
end;

function StrToBool(const str: string): boolean;
begin
  if (str = 'true') or (str = '1') then
    result := true
  else if (str = 'false') or (str = '0') then
    result := false
  else
    raise Exception.Create('StrToBool could not transform ' + str + ' to a boolean');
end;

function AssignColor(nrOfColors, IndexNumber: Integer): TColor;
begin
  case IndexNumber mod nrOfColors of
    0:
      begin
        // result := clCream
        // result := clWebLemonChiffon;
        // result := clWebLightgrey;
        result := clWebSeashell;

      end;
    1:
      begin
        // result := clInfoBk;
        // result := clWebLinen;
        // result := clWebGainsboro;
        result := clWebBlanchedAlmond

      end
  else
    result := AssignColor(nrOfColors mod 2, IndexNumber);

  end;
end;

procedure ConvertHourDezToHourMin(HourDez: double; var ResHours, ResMinutes: Integer);
begin
  ResHours := trunc(HourDez);
  ResMinutes := trunc((HourDez - ResHours) * 60)
end;

procedure ConvertHourMinToHourDez(Hours, Minutes: Integer; var ResHourDez: double);
begin
  ResHourDez := (Hours + trunc(Minutes * 100 / 60) / 100)
end;

function HasDigit(const value: string): boolean;
var
  i: Integer;
begin
  for i := 1 to length(value) do
  begin
    if value[i] in ['0' .. '9'] then
    begin
      result := true;
      Exit;
    end;
  end;
  result := false;
end;

end.
