unit UCustomer;

interface

type
  TCustomer = class(TObject)
    ID, Name: String;
    FullService, Zahlrueckstand: Boolean;

  public
    constructor Create(ID, Name: string; FullService, Zahlrueckstand: Boolean);
  end;

implementation

constructor TCustomer.Create(ID, Name: string; FullService, Zahlrueckstand: Boolean);
begin
  inherited Create;
  self.ID := ID;
  self.Name := name;
  self.FullService := FullService;
  self.Zahlrueckstand := Zahlrueckstand;
end;

end.
