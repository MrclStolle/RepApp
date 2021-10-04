unit FoShowKomponentList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, UComponent, moreUtils, Vcl.StdCtrls, Vcl.DBGrids, Vcl.ComCtrls,
  Vcl.ExtCtrls, UComponentDictionary, UEmployeeDictionary;

type
  TFoCompList = class(TForm)
    ComponentGrid: TStringGrid;

    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FoCompList: TFoCompList;

implementation

uses FoRepAppMAIN;

{$R *.dfm}

procedure TFoCompList.FormCreate(Sender: TObject);
var
  name: String;
  row: Integer;
begin
  row := 1;
  ComponentGrid.Cols[0].Add('Name');
  ComponentGrid.Cols[1].Add('Ser.-Nr.-Pflichtig');
  ComponentGrid.Cols[2].Add('Ersteller');
  ComponentGrid.RowCount := componentDictionary.Count;

  for name in componentDictionary.GetSortedNameList do
  begin
    ComponentGrid.Cells[0, row] := name;
    ComponentGrid.Cells[1, row] := BoolToYN(componentDictionary.GetComponent(name).NeedSerialNumber);
    ComponentGrid.Cells[2, row] := EmployeeDictionary[componentDictionary.GetComponent(name).CreatorMAID].name;

    inc(row);
  end;
end;

procedure TFoCompList.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    GetParentForm(ComponentGrid).close;
end;

end.
