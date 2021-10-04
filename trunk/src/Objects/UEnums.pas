unit UEnums;

interface

type
  TTaskStatus = class
  type
    TEnumStatus = (Offen, Geschlossen);
  public   
    Status: TEnumStatus;
    /// <summary>Gibt den Status in Textform zurück (für UI)
    /// </summary>
    /// <returns> Text als String
    /// </returns>
    function ToString: String;
    /// <summary>Gibt den Status als Nummer (String) zurück (für Eintrag in Datenbank)
    /// </summary>
    /// <returns> Nummer als String
    /// </returns>
    function ToStrNumber: String;
  end;

type
  TWareStatus = class
  type
    TEnumWareStatus = (Ausgeglichen, WEOffen, WAOffen, WEWAOffen);
  public
    Status: TEnumWareStatus;
    /// <summary>Gibt den Waren-Status in Textform zurück (für UI)
    /// </summary>
    /// <returns> Text als String
    /// </returns>
    function ToString: String;
    /// <summary>Gibt den Waren-Status als Nummer (String) zurück (für Eintrag in
    /// Datenbank)
    /// </summary>
    /// <returns> Nummer als String
    /// </returns>
    function ToStrNumber: String;
  end;

type
  TRechnStatus = class
  type
    TEnumRechnStatus = (gezahlt, RechnOffen, pruefen);
  public
    Status: TEnumRechnStatus;
    /// <summary>Gibt den Rechnungs-Status in Textform zurück (für UI)
    /// </summary>
    /// <returns> Text als String
    /// </returns>
    function ToString: String;
    /// <summary>Gibt den Rechnungs-Status als Nummer (String) zurück (für Eintrag in
    /// Datenbank)
    /// </summary>
    /// <returns> Nummer als String
    /// </returns>
    function ToStrNumber: String;
  end;

implementation

function TTaskStatus.ToString: String;
begin
  case Status of
    Offen:
      result := 'Offen';
    Geschlossen:
      result := 'Abgeschlossen';
  end;

end;

function TTaskStatus.ToStrNumber: String;
begin
  case Status of
    Offen:
      result := '1';
    Geschlossen:
      result := '0';
  end;

end;

function TWareStatus.ToString: String;
begin
  case Status of
    Ausgeglichen:
      result := 'Ausgeglichen';
    WEOffen:
      result := 'Wareneingang Offen';
    WAOffen:
      result := 'Warenausgang Offen';
    WEWAOffen:
      result := 'Warenein- und Ausgang Offen';
  end;
end;

function TWareStatus.ToStrNumber: String;
begin
  case Status of
    Ausgeglichen:
      result := '0';
    WEOffen:
      result := '1';
    WAOffen:
      result := '2';
    WEWAOffen:
      result := '3';
  end;
end;

function TRechnStatus.ToString: String;
begin
  case Status of
    gezahlt:
      result := 'Gezahlt';
    RechnOffen:
      result := 'Rechnung Offen';
    pruefen:
      result := 'Prüfen';
  end;
end;

function TRechnStatus.ToStrNumber: String;
begin
  case Status of
    gezahlt:
      result := '0';
    RechnOffen:
      result := '1';
    pruefen:
      result := '2';
  end;
end;

end.
