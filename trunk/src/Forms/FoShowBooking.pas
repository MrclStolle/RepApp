unit FoShowBooking;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, FrBooking, UOracleDB, Vcl.Buttons, UBooking, UEmployeeDictionary, FoShowSRNHistory;

type
  TShowBooking = class(TForm)
    lbBookingType: TLabel;
    lbDate: TLabel;
    btClose: TButton;
    lbMAName: TLabel;
    Img: TImage;
    pnl: TPanel;
    lbTitlePackageID: TLabel;
    lbComment: TLabel;
    lbCompNameTitle: TLabel;
    lbTitleCompCount: TLabel;
    lbSerialNr: TLabel;
    etPackageID: TEdit;
    meComment: TMemo;
    etSerialNr: TEdit;
    btHistory: TButton;
    lbCompName: TLabel;
    lbCompCount: TLabel;
    Panel1: TPanel;
    rbOneWayNO: TRadioButton;
    rbOneWayYes: TRadioButton;
    btAcceptChange: TButton;
    btDeleteBooking: TBitBtn;
    procedure btCloseClick(Sender: TObject);
    procedure btAcceptChangeClick(Sender: TObject);
    procedure btHistoryClick(Sender: TObject);
    procedure btDeleteBookingClick(Sender: TObject);
    procedure meCommentKeyPress(Sender: TObject; var Key: Char);
    procedure rbOneWayNOClick(Sender: TObject);
  private
    Booking: TBooking;
    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent; Booking: TBooking); reintroduce;
    { Public-Deklarationen }
  end;

var
  ShowBooking: TShowBooking;

implementation

uses FoRepAppMain;
{$R *.dfm}

constructor TShowBooking.Create(AOwner: TComponent; Booking: TBooking);
begin
  { TODO -ostolle -cGeneral : bildchen für die entsprechende änderung (rückbuchung oder nicht) einfügen }
  inherited Create(AOwner);
  self.Booking := Booking;
  lbBookingType.Caption := BookingTypeArray[Booking.bookTypeID];
  lbDate.Caption := FormatDateTime('dd.mm.yyyy', Booking.date);
  Caption := Caption + '   ' + FormatDateTime('dd.mm.yyyy', Booking.date);
  etPackageID.Text := Booking.packageID;
  if etPackageID.Text = '' then
    etPackageID.Enabled := false;
  meComment.Text := Booking.comment;
  lbCompName.Caption := Booking.GetComponent.Name;
  lbCompCount.Caption := IntToStr(Booking.count);
  lbMAName.Caption := EmployeeDictionary[Booking.employeeID].Name;
  try
    Img.Picture.icon := TFrameBooking(AOwner).Img.Picture.icon;
  except
    on E: Exception do
      RepApp.imgLBookTypeID.GetIcon(Booking.bookTypeID, Img.Picture.icon);
  end;

  Panel1.Left := lbBookingType.Left + lbBookingType.Width + 20;
  btAcceptChange.Left := Panel1.Left + Panel1.Width + 30;

  if Booking.nobalance then
    rbOneWayYes.Checked := true
  else
    rbOneWayNO.Checked := true;

  if Booking.SerNr = '' then
  begin
    etSerialNr.Enabled := false;
    btHistory.Enabled := false
  end
  else
    etSerialNr.Text := Booking.SerNr;

  btAcceptChange.Enabled := false;

end;

procedure TShowBooking.btAcceptChangeClick(Sender: TObject);
begin
  if Booking.nobalance xor rbOneWayYes.Checked then
  begin
    UpdateBookPosNoBalance(Booking.Book_PosID, rbOneWayYes.Checked);
    btAcceptChange.Enabled := false;
    RepApp.SetStatusBar('Buchung wurde geändert');
  end;

  // close;
  ModalResult := mrOk;
end;

procedure TShowBooking.btCloseClick(Sender: TObject);
begin
  close;
end;

procedure TShowBooking.btDeleteBookingClick(Sender: TObject);
begin
  if MessageDlg('Sicher, dass diese Buchung gelöscht werden soll?', mtConfirmation, [mbyes, mbno], 0, mbyes) = mryes
  then
  begin
    DeleteBookPos(Booking.Book_PosID);
    close;
    ModalResult := mrOk;
  end;
end;

procedure TShowBooking.btHistoryClick(Sender: TObject);
var
  HistoryForm: TFormShowSRNHistory;
begin
  HistoryForm := TFormShowSRNHistory.Create(self, etSerialNr.Text);
  HistoryForm.ShowModal;
  // HistoryForm.Free;
end;

procedure TShowBooking.meCommentKeyPress(Sender: TObject; var Key: Char);
begin
  try
    if Key = chr(27) then
      GetParentForm(self, true).close;
  except
    on E: EAccessViolation do
      // nothing
  end;
end;

procedure TShowBooking.rbOneWayNOClick(Sender: TObject);
begin
  btAcceptChange.Enabled := not btAcceptChange.Enabled;
end;

end.
