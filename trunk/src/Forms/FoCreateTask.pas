unit FoCreateTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FoCreateCustomer,
  UOracleDB, UCustomer, FoCreateBooking, moreUtils, Vcl.ExtCtrls, UCustomerDictionary, UUSer, UTaskStatus;

type
  TFormCreateTask = class(TForm)
    btCreateCustomer: TButton;
    lbTitle: TLabel;
    lbErrorNoBooking: TLabel;
    Panel1: TPanel;
    lbTitleComment: TLabel;
    lbTitleCustomer: TLabel;
    lbNoCustomer: TLabel;
    Label1: TLabel;
    cbCustomerChoise: TComboBox;
    memBeschreibung: TMemo;
    cbBillStatus: TComboBox;
    btCreateTaskWBooking: TButton;
    btCreateTask: TButton;
    btAbort: TButton;

    procedure FormCreate(Sender: TObject);
    procedure btCreateCustomerClick(Sender: TObject);
    procedure btCreateTaskClick(Sender: TObject);
    procedure btCreateTaskWBookingClick(Sender: TObject);
    procedure btAbortClick(Sender: TObject);

    procedure cbCustomerChoiseChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private

  public
    Customer: TCustomer;
    constructor Create(AOwner: TComponent; PCustomer: TCustomer); Reintroduce;
  end;

var
  FormCreateTask: TFormCreateTask;

implementation

{$R *.dfm}

uses FoRepAppMain;

// >>Form Create
constructor TFormCreateTask.Create(AOwner: TComponent; PCustomer: TCustomer);
begin
  inherited Create(AOwner);
  Customer := PCustomer;
end;

procedure TFormCreateTask.FormCreate(Sender: TObject);

begin
  memBeschreibung.Lines.Clear;

  cbBillStatus.Items.Add('Rechnung wurde gestellt');
  cbBillStatus.Items.Add('Rechnung muss gestellt werden');
  cbBillStatus.Items.Add('Rechnungsstatus unklar');
  cbBillStatus.ItemIndex := 1;

  // fill Status-ComboBox
  cbCustomerChoise.Clear;

  // fills ComboBox Customers with values, sets index on same customer
  cbCustomerChoise.Items.AddStrings(RepApp.cbCustomerChoise.Items.ToStringArray);
  cbCustomerChoise.Items.Delete(0);
  if Customer <> nil then
  begin
    cbCustomerChoise.Text := Customer.name;
    // btCreateTaskWBooking.Enabled := not Customer.Zahlrueckstand;
    // lbErrorNoBooking.Visible := Customer.Zahlrueckstand;
    if Customer.FullService then
    begin
      cbBillStatus.Items.Add('Full Service');
      cbBillStatus.ItemIndex := 3;
    end;
  end
  else
    cbCustomerChoise.Text := '';

end;

procedure TFormCreateTask.btCreateCustomerClick(Sender: TObject);
var
  FormCreateCustomer: TFormCreateCustomer;
begin

  FormCreateCustomer := TFormCreateCustomer.Create(nil);
  FormCreateCustomer.ShowModal;

  if FormCreateCustomer.ModalResult = mrOK then
  begin
    CustomerDictionary.RefreshFromDatabase;
    // fills ComboBox Customers with values, sets index on same customer
    cbCustomerChoise.Items.AddStrings(RepApp.cbCustomerChoise.Items.ToStringArray);
    cbCustomerChoise.Items.Delete(0); // deletes first item "alle Kunden" from other ComboBox
    cbCustomerChoise.Text := FormCreateCustomer.ETName.Text;
    FormCreateCustomer.Free;
  end;

end;

procedure TFormCreateTask.btCreateTaskClick(Sender: TObject);
var
  billStatus: String;
begin
  if cbCustomerChoise.Text <> '' then
  begin
    if Customer.FullService then
      billStatus := '3'
    else
      billStatus := '1';

    InsertIntoTask(CustomerDictionary.GetCustomer(cbCustomerChoise.Text).id, '1', memBeschreibung.Text, '3',
      billStatus);

    // if (Sender as TButton).name = 'btCreateTask' then
    // InsertIntoAuftrProt('(Select MAX(AUFTRID) from AUFTRAG)', User.id, '1', FormatDateTime('dd-mm-yy', Now), '0',
    // memBeschreibung.Text, '0', billStatus);

    // default auftragsstatus bei erstellung ist nun 3 ("beide richtugnen offen") um die automatische
    // status-anpassung unter TTaskDictionary.CheckForTaskStatusDifferences zu triggern
    // und damit gleich einen eintrag in AUFTRAGPROTOKOLL zu triggern

    RepApp.cbCustomerChoise.Text := self.cbCustomerChoise.Text;
    close;
    ModalResult := mrOK;
  end
  else
    lbNoCustomer.Show;
end;

procedure TFormCreateTask.btCreateTaskWBookingClick(Sender: TObject);
var
  fBooking: TFormCreateBooking;
begin
  if cbCustomerChoise.Text <> '' then

  begin
    fBooking := TFormCreateBooking.Create(self, True, GetNextSeqIDFrom('''SEQ_AUFTR_ID'''));
    fBooking.ShowModal;

    if fBooking.ModalResult = (mrNone or mrCancel) then // if booking is not finished/not successful
      // ShowMessage('Auftragserstellung abgebrochen.')
    else
    begin
      // erst die Creat-Task-Querry über den CreateTask-Button abschicken, dann die Querry der Buchung abschicken
      btCreateTaskClick(Sender);
      ExecuteDMLQuery(fBooking.querystring); // send transaktion w/booking and booking_pos
      // fBooking.Free;
      close;
      ModalResult := mrOK;
    end;

  end
  else
    lbNoCustomer.Show;
end;

procedure TFormCreateTask.btAbortClick(Sender: TObject);
begin
  close;
end;

procedure TFormCreateTask.cbCustomerChoiseChange(Sender: TObject);
begin
  try
    Customer := CustomerDictionary.GetCustomer(cbCustomerChoise.Text);
    btCreateTaskWBooking.Enabled := not Customer.Zahlrueckstand;
    lbErrorNoBooking.Visible := Customer.Zahlrueckstand;
    lbNoCustomer.Hide;
  except
    on E: Exception do
      // nothing
  end;
end;

procedure TFormCreateTask.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    close;
end;

end.
