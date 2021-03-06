unit uLevenshtein;

interface

function DamerauLevenshteinDistance(const Str1, Str2: String): Integer;
function StringSimilarityRatio(const Str1, Str2: String; IgnoreCase: Boolean): Double;

implementation

uses
  SysUtils, Math, system.classes;

function DamerauLevenshteinDistance(const Str1, Str2: String): Integer;
var
  LenStr1, LenStr2: Integer;
  I, J, T, Cost, PrevCost: Integer;
  pStr1, pStr2, S1, S2: PChar;
  D: TList;
begin
  LenStr1 := Length(Str1);
  LenStr2 := Length(Str2);
  D := nil;

  // to save some space, make sure the second index points to the shorter string
  if LenStr1 < LenStr2 then
  begin
    T := LenStr1;
    LenStr1 := LenStr2;
    LenStr2 := T;
    pStr1 := PChar(Str2);
    pStr2 := PChar(Str1);
  end
  else
  begin
    pStr1 := PChar(Str1);
    pStr2 := PChar(Str2);
  end;

  // to save some time and space, look for exact match
  while (LenStr2 <> 0) and (pStr1^ = pStr2^) do
  begin
    Inc(pStr1);
    Inc(pStr2);
    Dec(LenStr1);
    Dec(LenStr2);
  end;

  while (LenStr2 <> 0) and ((pStr1 + LenStr1 - 1)^ = (pStr2 + LenStr2 - 1)^) do
  begin
    Dec(LenStr1);
    Dec(LenStr2);
  end;

  if LenStr2 = 0 then
  begin
    result := LenStr1;
    Exit;
  end;

  // calculate the edit distance
  T := LenStr2 + 1;
  try
    D := TList.Create;

    for I := 0 to T - 1 do
      D.insert(I, Pointer(I));

    S1 := pStr1;
    for I := 1 to LenStr1 do
    begin
      PrevCost := I - 1;
      Cost := I;
      S2 := pStr2;
      for J := 1 to LenStr2 do
      begin
        if (S1^ = S2^) or ((I > 1) and (J > 1) and (S1^ = (S2 - 1)^) and (S2^ = (S1 - 1)^)) then
          Cost := PrevCost
        else
          Cost := 1 + MinIntValue([Cost, PrevCost, Integer(D[J])]);
        PrevCost := Integer(D[J]);
        D[J] := Pointer(Cost);

        Inc(S2);
      end;
      Inc(S1);
    end;
    result := Integer(D[LenStr2]);
  finally
    if D <> nil then
      for I := 0 to D.Count - 1 do
        D[I] := nil;
    D.free;
  end;

end;

function StringSimilarityRatio(const Str1, Str2: String; IgnoreCase: Boolean): Double;
var
  MaxLen: Integer;
  Distance: Integer;
begin
  result := 1.0;
  if Length(Str1) > Length(Str2) then
    MaxLen := Length(Str1)
  else
    MaxLen := Length(Str2);
  if MaxLen <> 0 then
  begin
    if IgnoreCase then
      Distance := DamerauLevenshteinDistance(AnsiUpperCase(Str1), AnsiUpperCase(Str2))
    else
      Distance := DamerauLevenshteinDistance(Str1, Str2);
    result := result - (Distance / MaxLen);
  end;
end;

end.
