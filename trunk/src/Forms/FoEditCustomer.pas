unit FoEditCustomer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UOracleDB, UCustomer, Vcl.ExtCtrls, UCustomerDictionary;

type
  TFormEditCustomer = class(TForm)
    lbTitle: TLabel;
    btOK: TButton;
    btAbort: TButton;
    pnl: TPanel;
    lbName: TLabel;
    lbMissName: TLabel;
    ETName: TEdit;
    chbService: TCheckBox;
    chbDeclineBookings: TCheckBox;
    cbChooseCustomer: TComboBox;
    Label1: TLabel;
    procedure btAbortClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);

    procedure cbChooseCustomerChange(Sender: TObject);
  private
    Customer: TCustomer;
    function BoolToString(b: bool): String;
  public
    constructor Create(const AOwner: TComponent); reintroduce;

  end;

implementation

uses
  FoRepAppMAIN;

{$R *.dfm}

{ DONE -ostolle -cGeneral : Kundenauswahl hinzufügen -> mit auto ausfüllen von Name, Full Service und zahlungsrückstand }
constructor TFormEditCustomer.Create(const AOwner: TComponent);
begin
  inherited Create(AOwner);
  cbChooseCustomer.Items := RepApp.cbCustomerChoise.Items;
  cbChooseCustomer.Items.Delete(0);
  if RepApp.cbCustomerChoise.ItemIndex <> 0 then
    // cbChooseCustomer.ItemIndex := RepApp.cbCustomerChoise.ItemIndex - 1
    cbChooseCustomer.text := RepApp.cbCustomerChoise.text
  else
    cbChooseCustomer.text := '';

  cbChooseCustomerChange(cbChooseCustomer);


  // ETName.Text := Customer.Name;
  // chbService.Checked := Customer.FullService;
  // chbDeclineBookings.Checked := Customer.Zahlrueckstand;

  hint := caption;
end;

procedure TFormEditCustomer.btAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TFormEditCustomer.btOKClick(Sender: TObject);
begin
  if not CustomerDictionary.ContainsName(cbChooseCustomer.text) then
    lbMissName.Visible := true
  else if MessageDlg('Ändere Kunden zu' + #13#10 + 'Name: "' + ETName.text + '"' + #13#10 + 'Hat Service: ' +
    BoolToString(chbService.Checked) + #13#10 + 'Hat Zahlungsrückstände: ' + BoolToString(chbDeclineBookings.Checked),
    mtConfirmation, [mbok, mbcancel], 0) = mrOk then
  begin
    UpdateCustomerTable(Customer.ID, ETName.text, chbService.Checked, chbDeclineBookings.Checked);
    Close;
    ModalResult := mrOk;

  end;
end;

// returns "ja" or "nein" interpreted from bool true or false
function TFormEditCustomer.BoolToString(b: bool): String;
begin
  if b then
    Result := 'ja'
  else
    Result := 'nein';
end;

procedure TFormEditCustomer.cbChooseCustomerChange(Sender: TObject);
begin
  lbMissName.Hide;
  try
    Customer := CustomerDictionary.GetCustomer(cbChooseCustomer.text);
  except
    on e: Exception do
      // nothing
  end;
  if Customer <> nil then
  begin
    ETName.text := Customer.Name;
    chbService.Checked := Customer.FullService;
    chbDeclineBookings.Checked := Customer.Zahlrueckstand;
    caption := ETName.text + '    ID: ' + Customer.ID;
  end

end;

end.
