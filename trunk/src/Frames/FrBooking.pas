unit FrBooking;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.StdCtrls, moreUtils, UTask, UBooking, UComponentDictionary, UEmployeeDictionary;

type
  TFrameBooking = class(TFrame)
    lbBType: TLabel;
    img: TImage;
    lbCompCountAndName: TLabel;
    lbDate: TLabel;
    lbMAName: TLabel;
    lbSerialNr: TLabel;
    pnlBooking: TPanel;
    procedure PanelClick(Sender: TObject);
  private
    { Private-Deklarationen }
    booking: TBooking;
  public
    BuchPosID: String;
    BuchID: string;
    BuchTypID: Integer;
    BuchTypText: String;
    datum: string;
    paketID: String;
    MAID: String;
    MAName: String;
    MANameShort: String;
    comment: String;
    TeilID: String;
    TeilName: String;
    TeilSN: string;
    menge: Integer;
    nobalance: boolean;
    constructor Create(PParent: TWinControl; PTask: TTask; booking: TBooking); reintroduce;

  public
    { Public-Deklarationen }
  end;

implementation

uses FoRepAppMAIN, FrTask, FoShowBooking;

{$R *.dfm}

constructor TFrameBooking.Create(PParent: TWinControl; PTask: TTask; booking: TBooking);
begin
  inherited Create(PParent);
  Parent := PParent;
  self.booking := booking;
  Name := 'frameB' + booking.Book_PosID;

  // fill fields of frBook
  BuchPosID := booking.Book_PosID;
  BuchID := booking.BookingID;
  TeilID := booking.componentID;
  TeilName := componentDictionary.GetComponent(TeilID).Name;
  menge := booking.count;
  TeilSN := booking.SerNr;
  nobalance := booking.nobalance;
  BuchTypID := booking.bookTypeID;
  datum := FormatDateTime('dd.mm.yyyy', booking.date);
  paketID := booking.packageID;
  MAID := booking.employeeID;
  MAName := EmployeeDictionary[MAID].Name;
  MANameShort := EmployeeDictionary[MAID].NameShort;
  comment := booking.comment;

  lbCompCountAndName.Caption := IntToStr(menge) + 'x ' + TeilName;
  lbDate.Caption := datum;
  lbMAName.Caption := MANameShort;
  lbMAName.Hint := MAName;

  BuchTypText := BookingTypeArray[BuchTypID];

  case BuchTypID of
    0: // case of 'Wareneingang'
      begin
        lbBType.Caption := 'WE';

        if nobalance then
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID + 2, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WEonewayIcon.png');
          img.Hint := 'Wareneingang ohne Rückbuchung';
        end
        else
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WEIcon.png');
          img.Hint := 'Wareneingang';
          // PTask.AddToCompDict(TeilName, menge);
        end;
      end;
    1: // case of 'Warenausgang'
      begin
        lbBType.Caption := 'WA';
        lbBType.Hint := 'Wareneingang';
        if nobalance then
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID + 2, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WAonewayIcon.png');
          img.Hint := 'Warenausgang ohne Rückbuchung';
        end
        else
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WAIcon.png');
          img.Hint := 'Warenausgang';
          // PTask.AddToCompDict(TeilName, -menge);
        end;

      end;
    2: // case of 'Persönlich Abgeholt'
      begin
        lbBType.Caption := 'PA';
        if nobalance then
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WEonewayIcon.png');
          img.Hint := 'Wareneingang (persönlich abgeholt) ohne Rückbuchung';
        end
        else
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID - 2, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WEIcon.png');
          img.Hint := 'Wareneingang (persönlich abgeholt)';
          // PTask.AddToCompDict(TeilName, menge);
        end;
      end;
    3: // case of 'Persönlich Übergeben'
      begin
        lbBType.Caption := 'PÜ';
        if nobalance then
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WAonewayIcon.png');
          img.Hint := 'Warenausgang (persönlich übergeben) ohne Rückbuchung';
        end
        else
        begin
          RepApp.imgLBookTypeID.GetIcon(BuchTypID - 2, img.Picture.icon);
          // img.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WAIcon.png');
          img.Hint := 'Warenausgang (persönlich übergeben)';
          // PTask.AddToCompDict(TeilName, -menge);
        end;

      end;

  end;
  lbBType.Hint := img.Hint;

  // if component needs a SerialNumber, lbSerialNr will be visibe
  if componentDictionary.GetComponent(TeilID).NeedSerialNumber then
  begin
    lbSerialNr.Show;
    lbSerialNr.Caption := 'SN:' + TeilSN;
  end;

  // depending on lenght of label.captions and space between labels, label.captions will be shorten
  // and label.hint with full name will be available
  if ((lbCompCountAndName.Left + lbCompCountAndName.Width) >= lbSerialNr.Left) and (lbSerialNr.visible) then
  begin
    lbCompCountAndName.Hint := lbCompCountAndName.Caption;
    lbCompCountAndName.ShowHint := true;
    lbCompCountAndName.Caption := copy(lbCompCountAndName.Caption, 0, 13) + '...';

    if (lbSerialNr.Left + lbSerialNr.Width) > lbDate.Left then
    begin
      lbSerialNr.Hint := lbSerialNr.Caption;
      lbSerialNr.ShowHint := true;
      lbSerialNr.Caption := copy(lbSerialNr.Caption, 0, 13) + '...';
    end;
  end
  else if lbCompCountAndName.Left + lbCompCountAndName.Width >= lbDate.Left then
  begin
    lbCompCountAndName.Hint := lbCompCountAndName.Caption;
    lbCompCountAndName.ShowHint := true;
    lbCompCountAndName.Caption := copy(lbCompCountAndName.Caption, 0, 35) + '...';
  end;
  // Row.Free;  //global from tasktable, cant free
end;

procedure TFrameBooking.PanelClick(Sender: TObject);
var
  ShowBooking: TShowBooking;
begin
  // try
  ShowBooking := TShowBooking.Create(self, booking);
  ShowBooking.ShowModal;
  if ShowBooking.ModalResult = mrok then
    RepApp.RefreshTaskTables;
  // finally
  // try
  // ShowBooking.Free;
  // // FreeAndNil(ShowBooking);
  // except
  // on E: EAccessViolation do
  // // nothing; fängt Fehler ab, wenn parent vor diesem Object freigegeben wird
  // end;
  // end;

end;

end.
