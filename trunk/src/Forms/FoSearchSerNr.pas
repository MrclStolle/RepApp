unit FoSearchSerNr;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FoShowSRNHistory, Vcl.Grids, Vcl.ExtCtrls, uLevenshtein, StrUtils,
  UComponentDictionary;

type
  TFormSearchSerNr = class(TForm)
    Panel1: TPanel;
    lbTitleSerNr: TLabel;
    eSearchText: TEdit;
    lbxSerNrList: TListBox;
    lbTitleResult: TLabel;
    lbDescription: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure eSearchTextChange(Sender: TObject);
    procedure lbSerNrListDblClick(Sender: TObject);
  private

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    constructor Create(AOwner: TComponent); reintroduce;
  end;

var
  FormSearchSerNr: TFormSearchSerNr;

implementation

{$R *.dfm}

constructor TFormSearchSerNr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  lbxSerNrList.Items := componentDictionary.GetSerNrList;
end;

procedure TFormSearchSerNr.eSearchTextChange(Sender: TObject);
var
  serNr: String;
begin
  if eSearchText.Text <> '' then
  begin
    lbxSerNrList.Clear;
    for serNr in componentDictionary.GetSerNrList do
    begin
      if (StringSimilarityRatio(serNr, eSearchText.Text, True) > 0.50) or (ContainsText(serNr, eSearchText.Text)) then
        lbxSerNrList.Items.Add(serNr)
    end
  end
  else
    lbxSerNrList.Items := componentDictionary.GetSerNrList;

end;

procedure TFormSearchSerNr.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    close;
end;

procedure TFormSearchSerNr.lbSerNrListDblClick(Sender: TObject);
var
  FoSSRNH: TFormShowSRNHistory;
  I: Integer;
begin
  FoSSRNH := nil;
  // try
  // checks which value has been clicked on
  for I := 0 to lbxSerNrList.Items.count - 1 do
  begin
    if lbxSerNrList.Selected[I] then
    begin
      FoSSRNH := TFormShowSRNHistory.Create(self, lbxSerNrList.Items[I]);
      break;
    end;
  end;

  FoSSRNH.ShowModal;
  // finally
  // if FoSSRNH <> nil then
  // FoSSRNH.Free;
  // end;

end;

end.
