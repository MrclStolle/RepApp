unit UReadTextAsTime;

interface

uses System.SysUtils, System.Character, StrUtils;

type
  TReadTextAsTime = class

  const
    UrPattern: array [1 .. 6] of string = ('ZTZD', 'ZTZZD', 'ZDZ', 'ZDLZ', 'ZB', 'ZD');
    // D:Doppelpunkt oder h, T:Komma/Punkt, B:Buchstabe, Z:Zahl, L:Lerzeichen
  private
    constructor Create;
    class function GetContainingPatternType(Text: string): Integer; static;
    class function Transform(Text: string): string; static;
    class procedure ZDZPattern(Text: string; Pos: Integer; out hour, min: Integer); static;
    class procedure ZTZPattern(Text: String; Pos: Integer; out hour, min: Integer); static;
    class procedure ZBPattern(Text: String; Pos: Integer; out min: Integer); static;
    class procedure ZDPattern(Text: String; Pos: Integer; out hour: Integer); static;

  public
    /// <summary>Sucht nach einer Zeitangabe(nicht Uhrzeit) innerhalb des übergebenen
    /// Textes und gibt diese in Stunden + Minuten aus
    /// </summary>
    /// <returns>Erfolgreiches Auslesen einer Zeitangabe (Boolean)
    /// </returns>
    /// <param name="Text">Zu durchsuchender Text (String) </param>
    /// <param name="hour">Ausgabe Stunden (Integer) </param>
    /// <param name="min">Ausgabe Minuten (Integer) </param>
    class function TransformToHMin(Text: String; out hour, min: Integer): Boolean; static;
  end;

implementation

constructor TReadTextAsTime.Create;
begin
  inherited;
  // leer
end;

class function TReadTextAsTime.TransformToHMin(Text: String; out hour, min: Integer): Boolean;
var
  CryptText: string;
  patternType, patternPos: Integer;
  z: Integer;
begin
  // temptext := StringReplace(Text, ' ', '', [rfReplaceAll]); // remove spaces
  CryptText := Transform(Text); // transform to pattern
  // ExtractTime(Text, GetContainingPatternType(CryptText), hour, min);
  patternType := GetContainingPatternType(CryptText);
  if patternType <> 0 then
  begin
    patternPos := Pos(UrPattern[patternType], CryptText);
    case patternType of
      1, 2:
        ZTZPattern(Text, patternPos, hour, min);
      3, 4:
        ZDZPattern(StringReplace(Text, ' ', '', [rfReplaceAll]), patternPos, hour, min);
      5:
        begin
          if lowercase(Copy(Text, patternPos + 1, 1)) = 'm' then
          begin
            ZBPattern(Text, patternPos, min);
            hour := 0;
          end;
        end;
      6:
        begin
          if lowercase(Copy(Text, patternPos + 1, 1)) = 'h' then
          begin
            ZDPattern(Text, patternPos, hour);
            min := 0;
          end;
        end;
      // 0:
      // ;
    end;

    if min >= 60 then
    begin
      z := min div 60;
      min := min - (60 * z);
      hour := hour + z;
    end;
    result := true;

  end
  else
    result := false;
end;

// transforms text into a Latter-Pattern
class function TReadTextAsTime.Transform(Text: string): string;
var
  I: Integer;
begin
  for I := 1 to Length(Text) do
  begin
    if IsNumber(Text[I]) then // Zahl?
      Text[I] := 'Z'
    else if charinset(Text[I], [':', 'h', 'H']) then // Doppelpunkt oder h?
      Text[I] := 'D'
    else if charinset(Text[I], [',', '.']) then // anderes Trennzeichen?
      Text[I] := 'T'
    else if isletter(Text[I]) then // Buchstabe?
      Text[I] := 'B'
    else if Text[I] = ' ' then // Leerzeichen?
      Text[I] := 'L'
    else
      Text[I] := 'X'; // sonstiges
  end;
  result := Text;
end;

// checks Patterned-Text for specific patterns and returns Integer of pattern-type
class function TReadTextAsTime.GetContainingPatternType(Text: string): Integer;
var
  I: Integer;
begin
  // Text := Transform(Text);
  for I := 1 to Length(UrPattern) + 1 do
  begin
    if ContainsText(Text, UrPattern[I]) then
    begin
      result := I;
      break;
    end
    else
      result := 0;
  end;
end;

class procedure TReadTextAsTime.ZDZPattern(Text: string; Pos: Integer; out hour, min: Integer);
var
  value: Integer;
begin
  value := 0;
  min := 0;

  if trystrtoint(Text[Pos + 3], value) then
  begin
    min := value;
    min := min + StrToInt(Text[Pos + 2]) * 10;
  end
  else
    min := min + StrToInt(Text[Pos + 2]);

  hour := StrToInt(Text[Pos]);
  if Pos > 0 then
  begin
    trystrtoint(Text[Pos - 1], value);
    hour := hour + (value * 10);
  end;
end;

class procedure TReadTextAsTime.ZTZPattern(Text: String; Pos: Integer; out hour, min: Integer);
var
  value: Integer;
  dezmin: double;
begin
  value := 0;
  dezmin := 0;
  if Length(Text) >= (Pos + 3) then
  begin
    if trystrtoint(Text[Pos + 3], value) then
    begin
      dezmin := value;
    end
  end;

  trystrtoint(Text[Pos + 2], value);
  dezmin := dezmin + (value * 10);

  min := Round((dezmin / 100) * 60);

  hour := StrToInt(Text[Pos]);
  if Pos > 0 then
  begin
    if trystrtoint(Text[Pos - 1], value) then
      hour := hour + (value * 10);
  end;

end;

class procedure TReadTextAsTime.ZBPattern(Text: String; Pos: Integer; out min: Integer);
var
  value: Integer;
begin
  min := StrToInt(Text[Pos]);
  if trystrtoint(Text[Pos - 1], value) then
    min := min + (value * 10);
end;

class procedure TReadTextAsTime.ZDPattern(Text: String; Pos: Integer; out hour: Integer);
var
  value: Integer;
begin
  hour := StrToInt(Text[Pos]);
  if Pos > 0 then
  begin
    if trystrtoint(Text[Pos - 1], value) then
      hour := hour + (value * 10);
  end;
end;

end.
