unit FrTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, System.Generics.Collections,
  FoCreateBooking, UOracleDB, FoEditTask, FoTaskHistory, FrBooking, moreUtils, UCustomer, UTask, Vcl.Imaging.pngimage,
  Generics.Collections, UBooking, UTaskDictionary, Vcl.Buttons;

type
  TFrameTask = class(TFrame)
    lbTitleStatus: TLabel;
    lbWareStatus: TLabel;
    memComment: TMemo;
    imgWareStatus: TImage;
    pnlBookBalance: TPanel;
    lbTitleBilanz: TLabel;
    lbBil: TLabel;
    lbTaskID: TLabel;
    lbTaskStatus: TLabel;
    imgTaskStatus: TImage;
    imgBillStatus: TImage;
    lbBillStatus: TLabel;
    lbZahlrueckstand: TLabel;
    btAddBooking: TBitBtn;
    btEditTask: TBitBtn;
    btHistory: TBitBtn;

    procedure btAddBookingClick(Sender: TObject);
    procedure btEditTaskClick(Sender: TObject);
    procedure btHistoryClick(Sender: TObject);
  private
    { Private-Deklarationen }
    inputOpen, outputOpen: Boolean;
    Task: TTask;
    procedure CreateFrBookings;
  public
    TaskID: String;
    // Kunde: TCustomer;
    // StatusID: String;
    // AufRechn: String;
    // Zeitaufw: string;
    // comment: string;
    // TaskComponentDict: TDictionary<String, Integer>;

    constructor Create(PParent: TWinControl; TaskID: String; TaskNr: Integer); reintroduce;

    /// <summary>Checks for balance of components in this Task and prints all not
    /// balanced components  in this frTask
    /// </summary>
    procedure PrintNotBalanced;
    procedure RefreshTaskStatus;
    // erfasst alle eingetragenen komponenten und überwacht bilanz
    { Public-Deklarationen }
  end;

implementation

uses
  FoRepAppMain;

{$R *.dfm}

constructor TFrameTask.Create(PParent: TWinControl; TaskID: String; TaskNr: Integer);
begin
  inherited Create(PParent);
  self.TaskID := TaskID;
  inputOpen := false;
  outputOpen := false;

  Parent := PParent;

  Task := TaskDictionary.GetTask(TaskID);
  // AuftragID := Task.ID;
  Name := 'frameT' + Task.id;
  color := AssignColor(2, TaskNr);

  lbTaskID.Caption := lbTaskID.Caption + TaskID;

  if Task.GetCustomer.Zahlrueckstand then
  begin
    btAddBooking.Enabled := false;
    lbZahlrueckstand.Show;
    // btAddBooking.hint := 'Kunde hat zu viele Zahlungsrückstände. Buchungen erstellen ist derzeit deaktiviert';
    // nicht sichtbar, wenn button disabled
  end;

  if Task.Status.TaskStatusNr = '0' then // disable add-Bookings_button on closed tasks, because Task is closed
  begin
    btAddBooking.Enabled := false;
  end;

  if Task.Kommentar = '' then
    memComment.hide
  else
  begin
    memComment.text := Task.Kommentar;
    memComment.color := color;
  end;

  RefreshTaskStatus;

  CreateFrBookings;

  pnlBookBalance.Top := self.Height - pnlBookBalance.Height;
  memComment.Height := self.Height - memComment.Top - 15;

  // gbFrameBookings.Height := self.Height - pnlBookBalance.Height;

  // hebt die schrift des Status-texts hervor, wenn die Buchung ausgeglichen ist, aber der Status nicht Abgeschlossen
  // if (lbBil.Caption = 'ausgeglichen') and (StatusID <> '0') then
  // lbStatus.Font.color := clMaroon;

end;

procedure TFrameTask.btAddBookingClick(Sender: TObject);
var
  createBooking: TFormCreateBooking;
begin
  createBooking := TFormCreateBooking.Create(GetParentForm(self), false, Task.id);
  createBooking.ShowModal;

  if createBooking.ModalResult = mrOK then
  begin
    RepApp.SetStatusBar('Neue Buchung wurde einem Auftrag hinzugefügt hinzugefügt');
    RepApp.RefreshTaskTables; // kein abstrakter fehler durch Free, da der button wiederhergestellt/erneut erstellt wird
  end;
  // createBooking.Free;

end;

procedure TFrameTask.btEditTaskClick(Sender: TObject);
var
  EditTask: TFormEditTask;
begin
  // EditTask := nil;
  if LockTaskRow(Task.id) then
  // try
  begin

    EditTask := TFormEditTask.Create(GetParentForm(self), Task.id);
    EditTask.ShowModal;

    if EditTask.ModalResult = mrOK then
    begin
      RepApp.RefreshTaskTables;
      RepApp.SetStatusBar('Auftrag wurde bearbeitet');
    end;

    // finally
    // ReleaseTaskRow(Task.id);
    // try
    /// /        EditTask.Free;
    // except
    // on E: EAccessViolation do
    // // nothing
    // end;
  end

end;

procedure TFrameTask.btHistoryClick(Sender: TObject);
var
  FormHistory: TFormTaskHistory;
begin
  FormHistory := TFormTaskHistory.Create(self, Task.id);
  FormHistory.ShowModal;
  // FormHistory.Free;
end;

procedure TFrameTask.PrintNotBalanced;
var
  key: String;
  value: container;
  topAnchor: Integer;
  leftAnchor: Integer;
  lbBillBalance: TLabel;
  FCount: Integer;
  isBalanced: Boolean;
  // collection: TEnumerable<String>;
begin
  lbBillBalance := nil;
  // checks for unbalanced components
  if Task.ComponentBalanceDictionary <> nil then
  begin
    isBalanced := true;
    for value in Task.ComponentBalanceDictionary.Values do
    begin
      if value.count >= 1 then
      begin
        isBalanced := false;
        outputOpen := true
      end
      else if value.count <= -1 then
      begin
        isBalanced := false;
        inputOpen := true
      end;

    end;

    if not isBalanced then
    begin
      // prepare
      topAnchor := lbTitleBilanz.Top;
      leftAnchor := lbTitleBilanz.Left + lbTitleBilanz.Width + 10;
      pnlBookBalance.color := clWebOrangeRed;
      FCount := 0;
      lbBil.Free;
      for key in Task.ComponentBalanceDictionary.Keys do
      begin
        value := Task.ComponentBalanceDictionary[key];
        // if balance is not 0, create label to present
        if value.count <> 0 then
        begin
          lbBillBalance := TLabel.Create(self);
          lbBillBalance.name := 'lb' + IntToStr(topAnchor);
          lbBillBalance.Parent := pnlBookBalance;
          lbBillBalance.Top := topAnchor;
          lbBillBalance.Left := leftAnchor;
          lbBillBalance.Font.Style := [];
          lbBillBalance.Font.Height := -15;
          if value.count > 0 then
            lbBillBalance.Caption := IntToStr(value.count) + 'x ''' + key + ''' zum Kunden'
          else
            lbBillBalance.Caption := IntToStr(-value.count) + 'x ''' + key + ''' von Kunde';

          topAnchor := topAnchor + lbBillBalance.Height;
          Inc(FCount);

        end;

      end; // end of for loop
      // vergößere FrTask
      self.Height := self.Height + (FCount - 1) * lbBillBalance.Height;
      pnlBookBalance.Height := lbBillBalance.Height * FCount + 10;
    end;
  end;

end;

procedure TFrameTask.RefreshTaskStatus;
begin
  lbTaskStatus.Caption := Task.Status.TaskStatusString;
  lbWareStatus.Caption := Task.Status.WareStatusString;
  lbBillStatus.Caption := Task.Status.BillStatusString;

  RepApp.imgLTaskStatus.GetIcon(Task.Status.TaskStatusInt, imgTaskStatus.Picture.Icon);
  RepApp.ImgLWareStatus.GetIcon(Task.Status.WareStatusInt, imgWareStatus.Picture.Icon);

end;

procedure TFrameTask.CreateFrBookings;
var
  value: TBooking;
  frBook: TFrameBooking;
  bookingCount: Integer;
begin
  // für jede buch_pos von aufträgen, die zu diesem auftrag gehören, erstelle ein frBooking in frTask
  frBook := nil;
  bookingCount := 0;
  if TaskDictionary.GetTask(TaskID).BookingList <> nil then
    for value in TaskDictionary.GetTask(TaskID).BookingList.Values do
    begin
      // create frBook
      // frBook := TFrameBooking.Create(gbFrameBookings, Task, value);
      frBook := TFrameBooking.Create(self, Task, value);
      frBook.Top := bookingCount * frBook.Height + 1;
      frBook.color := color;
      Inc(bookingCount);
    end
    // else
    // gbFrameBookings.hide
      ;
  if frBook <> nil then
    // bei mehr als 4 buchungen vergrößere FrTask
    if bookingCount > 4 then
      Height := Height + frBook.Height * (bookingCount - 4) + 5;

  PrintNotBalanced;
end;

end.
