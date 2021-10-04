unit UEmployee;

interface

type
  TEmployee = class(TObject)
    ID, Name, NameShort: String;
  public
    constructor Create(pID, pName, pNameShort: string); overload;
    constructor Create; overload;
  end;

implementation

constructor TEmployee.Create(pID, pName, pNameShort: string);
begin
  inherited Create;
  self.ID := pID;
  self.Name := pName;
  self.NameShort := pNameShort;
end;

constructor TEmployee.Create;
begin
  inherited Create;

end;

end.
