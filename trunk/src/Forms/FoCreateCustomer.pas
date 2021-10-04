unit FoCreateCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UOracleDB, Oracle, Vcl.ExtCtrls;

type
  TFormCreateCustomer = class(TForm)
    lbTitle: TLabel;
    BTOK: TButton;
    BTAbort: TButton;
    Panel1: TPanel;
    lbMissName: TLabel;
    ETName: TEdit;
    lbName: TLabel;
    CBService: TCheckBox;

    procedure BTClickOK(Sender: TObject);
    procedure BTClickAbort(Sender: TObject);
    procedure ETNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormCreateCustomer: TFormCreateCustomer;

implementation

uses FoRepAppMain;
{$R *.dfm}

// returns "ja" or "nein" interpreted from bool true or false
function BoolToString(b: bool): String;
begin
  if b then
    result := 'ja'
  else
    result := 'nein';
end;

procedure TFormCreateCustomer.BTClickOK(Sender: TObject);
begin
  if ETName.Text = '' then
    lbMissName.Visible := true
  else if Application.MessageBox(pWideChar('Erstelle neuen Kunden mit' + #13#10 + 'Name: "' + ETName.Text + '"' + #13#10
    + 'Hat Service: ' + BoolToString(CBService.Checked)), 'Bestätigung', MB_OKCANCEL) = IDOK then
  begin
    InsertIntoCustomer(ETName.Text, CBService.Checked);
    Close;
    ModalResult := mrOK;
  end;

end;

procedure TFormCreateCustomer.BTClickAbort(Sender: TObject);
begin
  Close;
end;

procedure TFormCreateCustomer.ETNameKeyPress(Sender: TObject; var Key: Char);
begin
  lbMissName.Visible := false;
end;

procedure TFormCreateCustomer.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    BTClickAbort(Sender);
end;

end.
