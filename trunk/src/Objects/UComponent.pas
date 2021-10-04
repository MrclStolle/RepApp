unit UComponent;

interface

type
  TComp = class(TObject)
  public
    ID, Name, CreatorMAID, TWINr: String;
    NeedSerialNumber: boolean;
    constructor Create(ID, Name: string; NeedSerialNumber: boolean; CreatorMAID, TWINr: string);
  end;

implementation

constructor TComp.Create(ID, Name: string; NeedSerialNumber: boolean; CreatorMAID, TWINr: string);
begin
  inherited Create;
  self.ID := ID;
  self.Name := Name;
  self.NeedSerialNumber := NeedSerialNumber;
  self.CreatorMAID := CreatorMAID;
  self.TWINr := TWINr;
end;

end.
