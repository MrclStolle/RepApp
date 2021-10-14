unit FoRepAppMAIN;

interface

uses Winapi.Windows, System.Classes, SysUtils, Vcl.Dialogs, Vcl.ImgList, Vcl.Controls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.Forms, Vcl.Menus, Vcl.StdActns, Vcl.ActnList, Vcl.ToolWin,
  System.TypInfo, FoCreateTask, FoCreateCustomer, FoComponentEditor, FoCreateEmployee, FoLogin, FoSearchSerNr, FrTask,
  FoCreateBooking, Generics.Collections, FoTransfer, FoEditCustomer, UOracleDB, USettings, UUser, UEmployee, UCustomer,
  UTask, UComponentDictionary, UCustomerDictionary, UTaskDictionary, UReadTextAsTime, UEmployeeDictionary,
  fosplashscreen, URepAppExcelWriter, UBooking, ImportXLSToDB;

type
  TRepApp = class(TForm)
    lbBilanz: TLabel;
    cbCustomerChoise: TComboBox;
    lbUsername: TLabel;
    btChangeUser: TButton;
    btTransfer: TButton;
    StatusBar: TStatusBar;
    ProgressBar: TProgressBar;
    btTestMem: TButton;
    Panel1: TPanel;
    rbOpenTasks: TRadioButton;
    rbOpenBills: TRadioButton;
    rbAllTasks: TRadioButton;
    imgLTaskStatus: TImageList;
    ImgLWareStatus: TImageList;
    imgLBillStatus: TImageList;
    imgLBookTypeID: TImageList;
    edTestReadTextAsTime: TEdit;
    lbTestReadTextAsTime: TLabel;
    Panel2: TPanel;
    DTPFrom: TDateTimePicker;
    chbTimeFrom: TCheckBox;
    chbTimeTo: TCheckBox;
    DTPTo: TDateTimePicker;
    btResetFilter: TButton;
    Label2: TLabel;
    Label3: TLabel;
    btInfoMerge: TPanel;
    btNewTask: TBitBtn;
    btEditCustomer: TBitBtn;
    btNewCustomer: TBitBtn;
    btSearchSerNr: TBitBtn;
    btCreateEmployee: TBitBtn;
    btNewComponent: TBitBtn;
    SaveDialog1: TSaveDialog;
    Button1: TBitBtn;

    procedure btChangeUserClick(Sender: TObject);
    procedure btCreateEmployeeClick(Sender: TObject);
    procedure cbCustomerChoiseChange(Sender: TObject);
    procedure btEditCustomerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btInfoMergeClick(Sender: TObject);
    procedure btInfoMergeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btNewTaskClick(Sender: TObject);
    procedure btInfoMergeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btNewCustomerClick(Sender: TObject);
    procedure btNewComponentClick(Sender: TObject);
    procedure btTransferClick(Sender: TObject);
    procedure btSearchSerNrClick(Sender: TObject);
    procedure cbCustomerChoiseKeyUp(Sender: TObject; var key: Word; Shift: TShiftState);
    procedure btTestMemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btResetFilterClick(Sender: TObject);
    procedure FilterTimeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);

    procedure edTestReadTextAsTimeChange(Sender: TObject);
    procedure DTPFromCloseUp(Sender: TObject);

    procedure DTPFromKeyPress(Sender: TObject; var key: Char);
    procedure lbOnClick(Sender: TObject);
    procedure DTPToCloseUp(Sender: TObject);

    procedure DTPToKeyPress(Sender: TObject; var key: Char);
    procedure rbClick(Sender: TObject);

    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);

  private
    ScrollBox1: TScrollBox;
    /// <summary>
    /// Vergleichswert, um einen Wechsel der Kunden in der sortierten Auftragsliste festzustelen.
    /// </summary>
    CustomerIDCompare: Integer;

    /// <summary>
    /// Öffnet das Login-Fenster und setzt den User beim Erfolgreichem login.
    /// </summary>
    procedure StartupLogin;
    /// <summary>Erstellt die für den Auftrag stellvertretende TaskFrame in der Scrollbox im RepAppMain.
    /// Die dazugehörenden Buchungen werden innerhalb des TaskFrames erstellt.
    /// </summary>
    /// <param name="Task_row"> (TStringList) Data of one Task</param>
    /// <param name="taskAnchorTop"> (Integer) Top-Position of this Frame</param>
    procedure CreateTaskFrame(TaskID: String; var taskAnchorTop, TaskNr: Integer);
    /// <summary>Setzt die Werte des Programms hinsichtlich des eingeloggten Nutzers
    /// z.B Name und Zugriffsrechte
    /// </summary>
    procedure SetCurrentUser;
    /// <summary>
    /// Aktualisiert den Inhat der ComboBox-CustomerChoise aus der TCustomerDictionary
    /// </summary>
    procedure RefillCBCustomerChoise;
    /// <summary>
    /// Tauscht die beiden DateTimePicker im Hauptfenster aus
    /// </summary>
    procedure SwapDateTimePicker();

  public
    /// <summary>Befüllt die Scrollbox in RepAppMainForm neu mit Aufträgen und Buchungen mit Kunden- und Datumsfilter
    /// aus den Task-, Component- und Customer-Dictionaries.
    /// </summary>
    procedure RefreshScrollbox;

    /// <summary>Just sets the Text in StatusBar in RepAppMainForm
    /// </summary>
    procedure SetStatusBar(text: string);
    /// <summary>Lädt alle Daten neu von der Datenbank und befüllt die Scrollbox auf RepAppMain mit den geladenen Daten.
    /// </summary>
    procedure RefreshTaskTables;

  end;

var
  RepApp: TRepApp;

  BookingTypeArray: array [0 .. 3] of string = (
    'Wareneingang',
    'Warenausgang',
    'Persönlich abgeholt',
    'Persönlich übergeben'
  );

implementation

{$R *.dfm}

procedure TRepApp.FormCreate(Sender: TObject);
begin
  InitialiseSettings;
  { DONE -ostolle -cGeneral : entdeckt in flussdiagramm -> logikablauf müsste abgeändert werden }
  { DONE -ostolle -cGeneral : wenn keine datenbank erreichbar ist -> führt zum buggen der app + nur schließbar über taskmanager
    (ggf abgefangen bei codeumstellung, muss überprüft werden) }
  { TODO -ostolle -cgimmick : Mit cklick auf lbUsername wird eine statustik aufgerufen mit werten, wieviel zeit investiert, anzahl buchungen/aufträge o.a.
    -> wäre so nur für jeden nutzer selbst ersichtlich }
  User := nil;

  StartupLogin;
  if User <> nil then // abfrage für den effektiven Erfolg des Logins
  begin
    SetCurrentUser;

    // create/fill Dictionaries
    EmployeeDictionary.Refresh;
    ComponentDictionary := TComponentDictionary.create(true);
    CustomerDictionary := TCustomerDictionary.create(true);
    RefillCBCustomerChoise;
    cbCustomerChoise.ItemIndex := 0;

    // debugmode settings  //debugmode wird in der DPR gesetzt
    lbTestReadTextAsTime.Visible := USettings.debugmode;
    edTestReadTextAsTime.Visible := USettings.debugmode;
    btTransfer.Visible := USettings.debugmode;
    btTestMem.Visible := USettings.debugmode;
    if debugmode then
      Caption := Caption + ' DEBUG-MODE';
    // debugmode settings end
    Caption := Caption + ' ' + connectedTo;

    btResetFilterClick(btResetFilter); // Filter default setzen
    Show;
  end
  else // Ist der Login abgebrochen und/oder kein User eingeloggt, dann wird das Programm geschlossen.
  begin
    FinalizeSettings;
    Application.Terminate;
  end
end;

// >>>New Task-Form
procedure TRepApp.btNewTaskClick(Sender: TObject);
var
  FormCreateTask: TFormCreateTask;
begin
  // if cbCustomerChoise.text <> 'alle Kunden' then
  FormCreateTask := TFormCreateTask.create(self, CustomerDictionary.GetCustomer(cbCustomerChoise.text));
  // else
  // FormCreateTask := TFormCreateTask.create(self, nil);
  FormCreateTask.ShowModal;
  if FormCreateTask.ModalResult = mrOK then
  begin
    RefreshTaskTables;
    SetStatusBar('Neuer Auftrag wurde hinzugefügt');
  end;
  // FormCreateTask.free;
end;

// >>>New Customer
procedure TRepApp.btNewCustomerClick(Sender: TObject);
var
  FormCreateCustomer: TFormCreateCustomer;
begin
  FormCreateCustomer := TFormCreateCustomer.create(self);
  FormCreateCustomer.ShowModal;
  if FormCreateCustomer.ModalResult = mrOK then
  begin
    CustomerDictionary.RefreshFromDatabase;
    cbCustomerChoise.text := FormCreateCustomer.ETName.text;
    cbCustomerChoiseChange(cbCustomerChoise);
    SetStatusBar('Neuer Kunde wurde hinzugefügt');
  end;
  // FormCreateCustomer.free;
end;

// >>>New Component-Form
procedure TRepApp.btNewComponentClick(Sender: TObject);
var
  FormCreateComponent: TFormComponentEditor;
begin

  FormCreateComponent := TFormComponentEditor.create(self);
  FormCreateComponent.ShowModal;
  if FormCreateComponent.CompChanged <> '' then
  begin
    RefreshTaskTables;
    SetStatusBar(FormCreateComponent.CompChanged);
  end;
  // FormCreateComponent.free;

end;

// Change User
procedure TRepApp.btChangeUserClick(Sender: TObject);
var
  LoginForm: TFormLogin;
begin
  LoginForm := TFormLogin.create(self);

  LoginForm.ShowModal;
  if LoginForm.ModalResult = mrOK then
  begin
    SetCurrentUser;
    SetStatusBar('Benutzer gewechselt');
    // RefreshTaskTables;
  end;
  // LoginForm.free;
end;

// >>>New Employee-Form
procedure TRepApp.btCreateEmployeeClick(Sender: TObject);
var
  TFCE: TFormCreateEmployee;
begin
  // TFCE := nil;
  // try
  TFCE := TFormCreateEmployee.create(self, User);
  TFCE.ShowModal;
  // if TFCE.ModalResult = mrOK then
  // SetStatusBar('Neuer Mitarbeiter wurde hinzugefügt');      //handled insote FormCreateEmployee
  // finally
  // if TFCE <> nil then
  // TFCE.free;
  // end;
end;

// >> Event on changed customer in ComboBox CustomerChoise
procedure TRepApp.cbCustomerChoiseChange(Sender: TObject);
begin
  if TComboBox(Sender).text = '' then
    TComboBox(Sender).ItemIndex := 0;
  try
    RefreshScrollbox();
  except
    on E: EListError do
    begin
      if debugmode then
        SetStatusBar('Dieser Kunde existiert nicht. <EList-Error>')
      else
        SetStatusBar('Dieser Kunde existiert nicht.')
    end;
    on EA: EAccessViolation do
      if debugmode then
        SetStatusBar('Dieser Kunde existiert nicht. <Access-Violation-Error>')
      else
        SetStatusBar('Dieser Kunde existiert nicht.')
  end;

end;

// -------------------------
procedure TRepApp.btEditCustomerClick(Sender: TObject);
var
  EditCustomer: TFormEditCustomer;
begin
  EditCustomer := TFormEditCustomer.create(self);
  EditCustomer.ShowModal;

  if EditCustomer.ModalResult = mrOK then
  begin
    CustomerDictionary.RefreshFromDatabase;
    RefillCBCustomerChoise;
    cbCustomerChoise.text := EditCustomer.ETName.text;
    RefreshScrollbox;

    SetStatusBar('Bestehender Kunde wurde bearbeitet');
  end;
  // EditCustomer.free;

end;

procedure TRepApp.btInfoMergeClick(Sender: TObject);
begin
  ShowMessage('Filtert die Aufträge heraus, welche Buchungen im angegebenen Zeitraum beinhalten. ' + sLineBreak +
    'Aufträge werden immer mit allen Buchungen angezeigt.' + sLineBreak +
    'Aufträge ohne Buchungen werd nicht angezeigt.');

end;

procedure TRepApp.btInfoMergeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvLowered;

end;
// -------------------------

procedure TRepApp.btInfoMergeMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvRaised;
end;

procedure TRepApp.StartupLogin;
var
  LoginForm: TFormLogin;
begin
  // LoginForm := nil;
  // try
  LoginForm := TFormLogin.create(self);
  if LoginForm.ModalResult <> mrOK then
    LoginForm.ShowModal;

  // finally
  // if LoginForm <> nil then
  // LoginForm.free;
  // end;

end;

// -------------------------
procedure TRepApp.btTransferClick(Sender: TObject);
var
  foT: TFormTransfer;
begin
  foT := TFormTransfer.create(self);
  foT.ShowModal;

  // foT.free;

end;

procedure TRepApp.btSearchSerNrClick(Sender: TObject);
var
  FoSSNr: TFormSearchSerNr;
begin
  // FoSSNr := nil;
  // try
  FoSSNr := TFormSearchSerNr.create(self);
  FoSSNr.ShowModal;
  // finally
  // if FoSSNr <> nil then
  // FoSSNr.free;
  // end;

end;

procedure TRepApp.btTestMemClick(Sender: TObject);
// var
// List: TComponentDictionary;
begin
  // ImportXLS;  //ausnutzen des nur im debug modus angezeigten buttons für importxls-tests
  // simple test to ceate leaks
  // List := TComponentDictionary.create(false);
  // List.Add(TComp.create('666', 'test', true, '22', 'sxe6rz78o2f'));
  // List.free;
end;

procedure TRepApp.btResetFilterClick(Sender: TObject);
begin
  chbTimeFrom.Checked := false;
  chbTimeTo.Checked := false;
  DTPFrom.DateTime := now;
  DTPTo.DateTime := now;
  cbCustomerChoise.ItemIndex := 0;
  rbOpenTasks.Checked := true; // triggers refresh scrollbox with rbClick-event
  // cbCustomerChoiseChange(cbCustomerChoise);
  RefreshTaskTables;

end;

procedure TRepApp.Button1Click(Sender: TObject);
var
  mindt, maxdt: tdatetime;
begin
  mindt := 0;
  maxdt := MaxDateTime;
  if chbTimeFrom.Checked then
    mindt := DTPFrom.date;
  if chbTimeTo.Checked then
    maxdt := DTPTo.date;
  if SaveDialog1.Execute then
  begin
    case SaveDialog1.FilterIndex of
      1: // xls
        try
          ExpToxls(SaveDialog1.FileName, mindt, maxdt);
          SetStatusBar('Daten erfolgrech als .xls exportiert');
        except
          on E: Exception do
          begin
            SetStatusBar('Fehler bei Export als .xls');
            ShowMessage(E.ToString);
          end;
        end;
      2: // csv
        try
          ExpToCSV(SaveDialog1.FileName, mindt, maxdt);
          SetStatusBar('Datenerfolgrech als .csv exportiert');
        except
          on E: Exception do
          begin
            SetStatusBar('Fehler bei Export als .csv');
            ShowMessage(E.ToString);
          end;
        end;
    end;
  end;

end;

procedure TRepApp.cbCustomerChoiseKeyUp(Sender: TObject; var key: Word; Shift: TShiftState);
begin
  // cbCustomerChoiseChange(Sender);
end;

procedure TRepApp.RefreshTaskTables;
var
  wheretaskStatus: String;
  // timespan: String;
begin
  wheretaskStatus := '';
  // timespan := '';
  try
    // set querry-task-status depending on checked radio-buttons
    if rbOpenTasks.Checked then
    begin
      wheretaskStatus := 'WHERE STATUSID !=0'; // all tasks except closed
    end
    else if rbOpenBills.Checked then
    begin
      wheretaskStatus := 'WHERE RECHNSTATUSID = 1 or RECHNSTATUSID = 2'; // tasks with open bills
    end;

    if TaskDictionary = nil then // erstellt die Dictionary, falls nicht vorhanden, befüllt ansonsten nur neu
    begin
      TaskDictionary := TTaskDictionary.create(wheretaskStatus);
    end
    else
      TaskDictionary.RefreshFromDatabase(wheretaskStatus);

  finally
    // nothing here
  end;

  RefreshScrollbox;
  if TaskDictionary.CheckForTaskStatusDifferences then
    RefreshScrollbox;
end;

procedure TRepApp.RefillCBCustomerChoise;
begin
  cbCustomerChoise.clear;
  cbCustomerChoise.Items.Add('alle Kunden');
  cbCustomerChoise.Items.AddStrings(CustomerDictionary.GetSortedNameList);
end;

procedure TRepApp.RefreshScrollbox;
var
  TaskID: String;
  countTasks, countCustomer: Integer;
  taskAnchorTop: Integer;
  tempscrollpos: Integer;
  lbCustomerTitle: TLabel;
  CustomerID: Integer;
  mindt, maxdt: tdatetime;
  // Splash: TFormSplashScreen;     //verursacht unangenehme vollständige markierung des combobox-textes, wodurch bei wieterer eingabe der text zurück gesetzt wird
begin
  // prepare
  taskAnchorTop := 10;
  CustomerIDCompare := 0;
  tempscrollpos := 0;
  countTasks := 0;
  countCustomer := 0;
  mindt := 0;
  maxdt := MaxDateTime;
  if chbTimeFrom.Checked then
    mindt := DTPFrom.date;
  if chbTimeTo.Checked then
    maxdt := DTPTo.date;
  SetStatusBar('Suche nach Aufträgen...');

  if ScrollBox1 <> nil then
  begin
    tempscrollpos := ScrollBox1.VertScrollBar.ScrollPos;
    FreeAndNil(ScrollBox1);
  end;
  // Splash := TFormSplashScreen.create('Lade Daten..');

  ScrollBox1 := TScrollBox.create(self);
  ScrollBox1.hide; // prevent repainting
  ScrollBox1.Parent := self;
  // ScrollBox1.Name := 'Scrollbox1';
  ScrollBox1.Top := lbBilanz.Top + lbBilanz.Height + 10;
  ScrollBox1.Left := lbBilanz.Left;
  ScrollBox1.Height := ScrollBox1.Parent.Height - ScrollBox1.Top - (ScrollBox1.Parent.Height - btNewComponent.Top) - 20;
  ScrollBox1.Width := ScrollBox1.Parent.Width - (2 * ScrollBox1.Left) - 17;
  ScrollBox1.Anchors := [akTop, akLeft, akRight, akBottom];
  ScrollBox1.HorzScrollBar.Visible := false;
  ScrollBox1.VertScrollBar.Tracking := true;
  ScrollBox1.VertScrollBar.Smooth := true;

  try
    if TaskDictionary.Count >= 1 then
    begin
      ProgressBar.Position := 0;
      ProgressBar.Max := TaskDictionary.Count - 1;
      // ProgressBar1.Step := 1;
    end
    else
      ProgressBar.Position := ProgressBar.Max;

    // für jeden Auftrag erstelle ein frTask in scrollbox
    for TaskID in TaskDictionary.SortedTasksList do
    begin
      // if combobox text == 'Alle Kunden' or chosen Customer == customer in current task (of loop)
      if ((cbCustomerChoise.text = 'alle Kunden') or (CustomerDictionary.GetCustomer(cbCustomerChoise.text)
        .ID = TaskDictionary.GetCustomer(TaskID).ID)) and TaskDictionary.GetTask(TaskID).InBetweenDate(mindt, maxdt)
      then
      begin
        CustomerID := strtoint(TaskDictionary.GetCustomer(TaskID).ID);

        // [by name sorted customers] on next customer, create a label + swap color
        if CustomerIDCompare <> CustomerID then
        begin
          inc(countCustomer);
          CustomerIDCompare := CustomerID;

          // create label as Header for next Customer
          lbCustomerTitle := TLabel.create(self);
          lbCustomerTitle.Parent := ScrollBox1;
          // lbCustomerTitle.Name := 'lbc' + TaskID;
          lbCustomerTitle.Left := 10;
          lbCustomerTitle.Top := taskAnchorTop;
          lbCustomerTitle.Font.Height := -31;
          // color := FrTask.AssignColor;
          lbCustomerTitle.Caption := TaskDictionary.GetCustomer(TaskID).Name;
          lbCustomerTitle.Font.Name := 'Arial';
          lbCustomerTitle.OnClick := lbOnClick;
          lbCustomerTitle.Cursor := crHandPoint;
          // lbCustomerTitle.Show;
          // add height for next object
          taskAnchorTop := taskAnchorTop + lbCustomerTitle.Height;
          // OnClick := lbOnClick;   // causes error on use
          // Cursor := crHandPoint;

        end;

        inc(countTasks);

        CreateTaskFrame(TaskID, taskAnchorTop, countTasks);
      end; // if Task will be shown in Scrollbox

      ProgressBar.Position := ProgressBar.Position + 1;
      // ProgressBar.Update;
      // Sleep(15);  // slow down to give progressbar a bit of time to refresh
    end;

    // show finalized scrollbox
    ScrollBox1.VertScrollBar.Position := tempscrollpos;

    ScrollBox1.Show;

  finally
    // Splash.Free;
  end;
  if countTasks > 0 then
    SetStatusBar('Insgesamt ' + IntToStr(countTasks) + ' Aufträge bei ' + IntToStr(countCustomer) + ' Kunde/n gefunden')
  else
    SetStatusBar('Keine Aufträge gefunden');

end;

// creates TaskFrame
procedure TRepApp.CreateTaskFrame(TaskID: String; var taskAnchorTop, TaskNr: Integer);
var
  FrTask: TFrameTask;
begin
  // create frame frTask
  FrTask := TFrameTask.create(ScrollBox1, TaskID, TaskNr);
  FrTask.Top := taskAnchorTop;
  FrTask.Left := 10;
  FrTask.Width := ScrollBox1.Width - FrTask.Left;
  // sets Top-Position for next TaskFrame/Object
  taskAnchorTop := taskAnchorTop + FrTask.Height + 20;

end;

procedure TRepApp.FilterTimeClick(Sender: TObject);
begin
  RefreshScrollbox;
end;

procedure TRepApp.DTPFromCloseUp(Sender: TObject); // DTP = DateTimePicker
begin
  if (DTPTo.DateTime < DTPFrom.DateTime) and (chbTimeFrom.Checked and chbTimeTo.Checked) then
    SwapDateTimePicker;
  if not chbTimeFrom.Checked then
    chbTimeFrom.Checked := true
  else
    FilterTimeClick(nil);
end;

procedure TRepApp.DTPFromKeyPress(Sender: TObject; var key: Char);
begin
  if key = #13 then
    DTPFromCloseUp(Sender);
end;

procedure TRepApp.DTPToCloseUp(Sender: TObject);
begin
  if (DTPTo.DateTime < DTPFrom.DateTime) and (chbTimeFrom.Checked and chbTimeTo.Checked) then
    SwapDateTimePicker;
  if not chbTimeTo.Checked then
    chbTimeTo.Checked := true
  else
    FilterTimeClick(nil);
end;

procedure TRepApp.DTPToKeyPress(Sender: TObject; var key: Char);
begin
  if key = #13 then
    DTPToCloseUp(Sender);
end;

procedure TRepApp.SwapDateTimePicker();
var
  dt: tdatetime;
  check: Boolean;
begin
  dt := DTPFrom.DateTime;
  DTPFrom.DateTime := DTPTo.DateTime;
  DTPTo.DateTime := dt;

  check := chbTimeFrom.Checked;
  chbTimeFrom.Checked := chbTimeTo.Checked;
  chbTimeTo.Checked := check;
end;

procedure TRepApp.edTestReadTextAsTimeChange(Sender: TObject);
var
  min, h: Integer;
  temptext: string;
begin
  min := 0;
  h := 0;
  temptext := edTestReadTextAsTime.text;
  if TReadTextAsTime.TransformToHMin(temptext, h, min) then
    lbTestReadTextAsTime.Caption := IntToStr(h) + 'h ' + IntToStr(min) + 'min'
  else
    lbTestReadTextAsTime.Caption := '';

end;

procedure TRepApp.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  try
    if TaskDictionary <> nil then
      TaskDictionary.Free;
    if CustomerDictionary <> nil then
      CustomerDictionary.Free;
    if ComponentDictionary <> nil then
      ComponentDictionary.Free;

    if EmployeeDictionary <> nil then
      EmployeeDictionary.Free;

    FinalizeSettings;
    if User <> nil then
      User.Free;
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;

end;

procedure TRepApp.lbOnClick(Sender: TObject);
begin

  cbCustomerChoise.ItemIndex := cbCustomerChoise.Items.IndexOf((Sender as TLabel).Caption);
  cbCustomerChoiseChange(cbCustomerChoise);

end;

procedure TRepApp.rbClick(Sender: TObject);
begin
  RefreshTaskTables;
end;

// makes Scrollbox scrollable
procedure TRepApp.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  LTopLeft, LTopRight, LBottomLeft, LBottomRight: SmallInt;
  LPoint: TPoint;
begin
  inherited;
  LPoint := ScrollBox1.ClientToScreen(Point(0, 0));

  LTopLeft := LPoint.X;
  LTopRight := LTopLeft + ScrollBox1.Width;

  LBottomLeft := LPoint.Y;
  LBottomRight := LBottomLeft + ScrollBox1.Width;

  if (MousePos.X >= LTopLeft) and (MousePos.X <= LTopRight) and (MousePos.Y >= LBottomLeft) and
    (MousePos.Y <= LBottomRight) then
  begin
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - WheelDelta;

    Handled := true;
  end;
end;

// -------------------------
procedure TRepApp.SetStatusBar(text: string);
begin
  StatusBar.Panels[0].text := text;
end;

procedure TRepApp.SetCurrentUser;
begin
  lbUsername.Caption := 'Benutzer: ' + User.Name;
  btChangeUser.Left := RepApp.lbUsername.Left + RepApp.lbUsername.Width + 16;

  btNewComponent.Enabled := User.admin;
  btNewCustomer.Enabled := User.admin;
  btEditCustomer.Enabled := User.admin;
  // adminrecht zum erstellen von Benutzern wird in FoCreateEmployee gesetzt

  RepApp.SetStatusBar('Login erfolgreich');

end;

initialization

Application.HintHidePause := 5000;

finalization

end.
