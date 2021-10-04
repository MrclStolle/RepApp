unit FrCompBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrameComponentBox = class(TFrame)
    cbComponent: TComboBox;
    eCount: TEdit;
    chbOneWay: TCheckBox;
    lbTitleComponent: TLabel;
    lbTitleCount: TLabel;
    lbTitleSerNr: TLabel;
    cbSerialNr: TComboBox;
  private
    { Private-Deklarationen }
  public
    constructor Create(AOwner: Tcomponent; compList, serNrList: TStringList); reintroduce;
    { Public-Deklarationen }
    function toString: string; reintroduce;
  end;

implementation

{$R *.dfm}

constructor TFrameComponentBox.Create(AOwner: Tcomponent; compList, serNrList: TStringList);
begin
  inherited Create(AOwner);
  cbComponent.Items.AddStrings(compList);
  cbSerialNr.Items := serNrList;

end;

function TFrameComponentBox.toString: string;
begin
  if cbComponent.ItemIndex >= 0 then
  begin
    Result := eCount.Text + 'x ' + cbComponent.Text;
    if cbSerialNr.Text <> '' then
      Result := Result + ' | Ser.-Nr.:' + cbSerialNr.Text;
    if chbOneWay.Checked then
      Result := Result + '  <ohne Rückbuchung>';
  end;
end;

end.
