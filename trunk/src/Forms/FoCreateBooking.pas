unit FoCreateBooking;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, UOracleDB,
  oracle, Vcl.Imaging.pngimage, Vcl.ExtCtrls, FoComponentEditor, Vcl.Grids,
  uLevenshtein, System.StrUtils, FrCompBox, UTask, moreUtils, FoTemplaceServiceMail, UComponentDictionary,
  UTaskDictionary, UUser;

type
  TFormCreateBooking = class(TForm)
    lbTitle: TLabel;
    btAddOneGroup: TButton;
    btRemoveOneGroup: TButton;
    lberror: TLabel;
    ScrollBox1: TScrollBox;
    lbCompCount: TLabel;
    btAddFiveGroup: TButton;
    btRemoveFiveGroup: TButton;
    pnlSearchcomponent: TPanel;
    lbTitleSearchComp: TLabel;
    btNewComponent: TButton;
    etSearchComp: TEdit;
    ListBox1: TListBox;
    btClearScrollbox: TButton;
    lbTitleSearch: TLabel;
    lbTitleResult: TLabel;
    Panel1: TPanel;
    lbcomment: TLabel;
    Image1: TImage;
    lbTitlePackageID: TLabel;
    lbTitleBookType: TLabel;
    lbTitleDate: TLabel;
    cbTypeID: TComboBox;
    DateTimePicker1: TDateTimePicker;
    EdPackageID: TEdit;
    MeComment: TMemo;
    btok: TButton;
    btAbort: TButton;
    lbTitleErrorSerNr: TLabel;
    etHours: TEdit;
    Label1: TLabel;
    etMinutes: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    lbErrorNoDezimal: TLabel;
    btServiceMail: TButton;
    pnlTaskMemo: TPanel;
    lbTaskMemo: TLabel;
    memTaskMemo: TMemo;

    procedure btAbortClick(Sender: TObject);
    procedure btAddGroupsClick(Sender: TObject);
    procedure btNewComponentClick(Sender: TObject);
    procedure btokClick(Sender: TObject);
    procedure btRemoveGroupsClick(Sender: TObject);
    procedure cbTypeIDChange(Sender: TObject);
    procedure btClearScrollboxClick(Sender: TObject);
    procedure etSearchCompChange(Sender: TObject);
    procedure btServiceMailClick(Sender: TObject);
    procedure etHoursClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);

  private
    auftrID: string;
    CompCount: Integer;
    CompCountMax: Integer;
    wait: Boolean;
    Task: TTask;
    tempTaskMemo: String;
    tempCustomerName: String;
    OQ: TOracleQuery;
    procedure RefillCBComp(CompNameList: TStringList);
    procedure AddComponentFrCB;
    procedure cbComp(Sender: TObject);
    procedure cbSerNr(Sender: TObject);
    procedure RemoveComponent;

  public
    querystring: string;
    constructor Create(AOwner: TComponent; extQuery: Boolean; auftrID: String); reintroduce;

  end;

var
  FormCreateBooking: TFormCreateBooking;

implementation

uses FoRepAppMAIN, FoCreateTask;

{$R *.dfm}

constructor TFormCreateBooking.Create(AOwner: TComponent; extQuery: Boolean; auftrID: String);
begin
  inherited Create(AOwner);
  wait := extQuery;
  self.auftrID := auftrID;
  if TaskDictionary.ContainsID(auftrID) then
  begin
    Task := TaskDictionary.GetTask(auftrID);
    tempTaskMemo := Task.Kommentar;
    tempCustomerName := Task.GetCustomer.Name;
  end
  else
  begin // wenn auftrag noch nicht existiert/gerade erst erstellt wird
    tempTaskMemo := TFormCreateTask(Owner).memBeschreibung.Text;
    tempCustomerName := TFormCreateTask(Owner).Customer.Name;
  end;
  memTaskMemo.Text := tempTaskMemo;

  Caption := Caption + ' für Auftrags-ID: ' + auftrID;
  if extQuery then
    Caption := Caption + ' (Pre Selected)';
  Caption := Caption + '   für Kunde: ' + tempCustomerName;

end;

procedure TFormCreateBooking.FormCreate(Sender: TObject);
var
  bookType: string;
begin
  // prepare
  MeComment.Clear;
  cbTypeID.Clear;
  DateTimePicker1.date := date;
  CompCount := 0;
  CompCountMax := 50;

  // fill cb BookingType
  cbTypeID.Items.BeginUpdate;
  for bookType in BookingTypeArray do
    cbTypeID.Items.Add(bookType);
  cbTypeID.ItemIndex := 0;
  if Task <> nil then
    if Task.Status.WareStatusInt = 2 then
      cbTypeID.ItemIndex := 1;

  cbTypeID.Items.EndUpdate;

  cbTypeIDChange(cbTypeID);

  btNewComponent.enabled := User.admin;

end;

// abort btn
procedure TFormCreateBooking.btAbortClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

// create component
procedure TFormCreateBooking.btNewComponentClick(Sender: TObject);
var
  FormComponentEditor: TFormComponentEditor;
begin
  FormComponentEditor := TFormComponentEditor.Create(self);
  FormComponentEditor.ShowModal;
  if FormComponentEditor.ModalResult = mrOK then
  begin
    componentDictionary.RefreshFromDatabase;
    RefillCBComp(componentDictionary.GetSortedNameList);
  end;
  // FormComponentEditor.Free;

end;

procedure TFormCreateBooking.cbTypeIDChange(Sender: TObject);
var
  key: String;
  I: Integer;
begin
  // erstellen von Komponenten-Feldern, wenn in der dictionary einträge vorhanden sind

  // autofill CompBoxes with values from bookedCompontenDict and change Icon
  with Sender as TComboBox do
    if (ItemIndex = 0) or (ItemIndex = 2) then
    begin
      // Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WEIcon.png');
      RepApp.imgLBookTypeID.GetIcon(0, Image1.Picture.Icon);
      if Task <> nil then
        if not Task.isBalanced then
        begin
          btClearScrollboxClick(nil);
          for key in Task.ComponentBalanceDictionary.Keys do
          begin
            if Task.ComponentBalanceDictionary[key].count < 0 then
            begin
              if componentDictionary.GetComponent(key).NeedSerialNumber then
                for I := 0 to -Task.ComponentBalanceDictionary[key].count - 1 do
                begin
                  AddComponentFrCB;
                  TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).cbComponent.Text := key;
                  cbComp(TComboBox(TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).Controls[3]));
                  TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).eCount.Text := '1';
                end
              else
              begin
                AddComponentFrCB;
                TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).cbComponent.Text := key;
                cbComp(TComboBox(TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).Controls[3]));
                TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).eCount.Text :=
                  IntToStr(-Task.ComponentBalanceDictionary[key].count);
              end;
            end;
          end; // end loop
        end;
    end
    else // if item index is 1 or 3
    begin
      // Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WAIcon.png');
      RepApp.imgLBookTypeID.GetIcon(1, Image1.Picture.Icon);
      if Task <> nil then
        if not Task.isBalanced then
        begin
          btClearScrollboxClick(nil);
          for key in Task.ComponentBalanceDictionary.Keys do
          begin
            if Task.ComponentBalanceDictionary[key].count > 0 then
            begin
              if componentDictionary.GetComponent(key).NeedSerialNumber then
                for I := 0 to Task.ComponentBalanceDictionary[key].count - 1 do
                begin
                  AddComponentFrCB;
                  TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).cbComponent.Text := key;
                  cbComp(TComboBox(TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).Controls[3]));
                  TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).eCount.Text := '1';
                end
              else
              begin
                AddComponentFrCB;
                TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).cbComponent.Text := key;
                cbComp(TComboBox(TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).Controls[3]));
                TFrameComponentBox(ScrollBox1.Controls[CompCount - 1]).eCount.Text :=
                  IntToStr(Task.ComponentBalanceDictionary[key].count);
              end;
            end;
          end // end loop
        end;

    end; // end if componentdict <> nil

  if ScrollBox1.ControlCount < 1 then
    AddComponentFrCB;
end;

procedure TFormCreateBooking.btRemoveGroupsClick(Sender: TObject); // remove a group btn
var
  removeBoxCount, I: Integer;
begin
  btAddOneGroup.enabled := true;
  btAddFiveGroup.enabled := true;
  removeBoxCount := StrToInt((Sender as TButton).Caption[2]); // get number from button.caption

  if ScrollBox1.ComponentCount - removeBoxCount <= 0 then
  begin
    btRemoveOneGroup.enabled := false;
    btRemoveFiveGroup.enabled := false;
    removeBoxCount := ScrollBox1.ComponentCount;
  end;

  for I := 1 to removeBoxCount do
    RemoveComponent();

end;

procedure TFormCreateBooking.cbComp(Sender: TObject);
begin
  try
    with Sender as TComboBox do
    begin
      if componentDictionary.GetComponent(Text).NeedSerialNumber then // component need a serial number
      begin
        TEdit((TComboBox(Sender).Parent).Controls[4]).enabled := false; // TEdit count
        TEdit((TComboBox(Sender).Parent).Controls[4]).Text := '1'; // TEdit count
        TComboBox((TComboBox(Sender).Parent).Controls[6]).enabled := true; // TCombobox SerialNumber
        TLabel((TComboBox(Sender).Parent).Controls[2]).enabled := true; // TLabel SerialNumber
      end
      else // component does NOT need a serial number
      begin
        TEdit((TComboBox(Sender).Parent).Controls[4]).enabled := true;
        TEdit((TComboBox(Sender).Parent).Controls[4]).Text := '1';
        TComboBox((TComboBox(Sender).Parent).Controls[6]).enabled := false;
        TComboBox((TComboBox(Sender).Parent).Controls[6]).Text := '';
        TLabel((TComboBox(Sender).Parent).Controls[2]).enabled := false;
      end;

    end;
  except
    on E: Exception do
      // nothing
  end;

end;

procedure TFormCreateBooking.cbSerNr(Sender: TObject);
begin
  lberror.hide;
end;

procedure TFormCreateBooking.RemoveComponent;
begin
  // delete gb in scrollbox
  ScrollBox1.Components[ScrollBox1.ComponentCount - 1].Free;
  CompCount := CompCount - 1;
  lbCompCount.Caption := IntToStr(CompCount) + '/' + IntToStr(CompCountMax);
  EdPackageID.enabled := false;
end;

procedure TFormCreateBooking.etSearchCompChange(Sender: TObject);
var
  Element: String;
begin
  ListBox1.Clear;
  if Length((Sender as TEdit).Text) >= 0 then // ab einer länge von x Zeichen
  begin
    // für jedes TArray<String> in CompDict
    for Element in componentDictionary.GetSortedNameList do
    begin
      if (StringSimilarityRatio(Element, etSearchComp.Text, true) > 0.75) or
        ((ContainsStr(LowerCase(Element), LowerCase(etSearchComp.Text))) and (Length(etSearchComp.Text) >= 2)) then
        ListBox1.Items.Add(Element); // wenn ähnlichkeit >75% oder (exakter wortlauf vorkommt und eingabe-länge >=2)
    end;

  end
  else
    ListBox1.Clear;

end;

// OK_send button
procedure TFormCreateBooking.btokClick(Sender: TObject);
var
  FrComponent: TFrameComponentBox;
  compID: String;
  CompCount: String;
  compSN: String;
  oneway: Boolean;
  I: Integer;
  allSerNrExists: Boolean;
  hours, minutes: Integer;
  HourDez: double;
  checkInsSerNr: Boolean;
begin
  allSerNrExists := true;
  checkInsSerNr := false;

  for I := 0 to ScrollBox1.ComponentCount - 1 do
  // prüft, ob alle angegebenen Komponenten eine Seriennummer zugewisen bekommen haben(falls nötig) und prüft, ob die seriennummern im system existieren
  begin
    FrComponent := ScrollBox1.Components[I] as TFrameComponentBox;
    if TComboBox(FrComponent.Controls[6]).enabled then
      if TComboBox(FrComponent.Controls[6]).Text = '' then
      begin
        lberror.Visible := true;
        allSerNrExists := false;
        break;
      end
      else if componentDictionary.GetSerNrList.IndexOf(TComboBox(FrComponent.Controls[6]).Text) = -1 then
      // if SerNumber not exists(=-1) in SerNrList
      begin
        if MessageDlg('Die Seriennummer ''' + TComboBox(FrComponent.Controls[6]).Text +
          ''' existiert noch nicht in der Datenbank. Soll diese Nummer wirklich erstellt werden?', mtConfirmation,
          [mbyes, mbno], 0, mbyes) = mrYes then
          checkInsSerNr := true
        else
        begin
          allSerNrExists := false;
          lbTitleErrorSerNr.Show;
          break;
        end;

      end;
  end;

  if (tryStrToInt(etHours.Text, hours)) and (tryStrToInt(etMinutes.Text, minutes)) then
  begin
    ConvertHourMinToHourDez(hours, minutes, HourDez);
    if allSerNrExists then
    begin
      // create transaction for buchungen und buchpos
      OQ := nil;
      OQ := TOracleQuery.Create(self);

      OQ.SQL.Text := 'begin ';
      // insert into buchungen
      OQ.SQL.Text := OQ.SQL.Text + 'Insert into buchungen values (SEQ_BUCH_ID.nextval, ' + auftrID + ', ' +
        IntToStr(cbTypeID.ItemIndex) + ', ''' + FormatDateTime('dd-mm-yy', DateTimePicker1.date) + ''', ''' +
        EdPackageID.Text + ''', ' + User.ID + ', ''' + MeComment.Text + ''', ' + StringReplace(FloatToStr(HourDez), ',',
        '.', [rfReplaceAll]) + ');';

      ModalResult := mrOK;

      for I := 0 to ScrollBox1.ComponentCount - 1 do
      begin
        FrComponent := ScrollBox1.Components[I] as TFrameComponentBox;
        if (TEdit(FrComponent.Controls[1]).Text <> '') and (TEdit(FrComponent.Controls[4]).Text <> '') then
        begin
          compID := componentDictionary.GetComponent(TComboBox(FrComponent.Controls[3]).Text).ID;
          CompCount := TEdit(FrComponent.Controls[4]).Text;
          compSN := TComboBox(FrComponent.Controls[6]).Text;
          oneway := TCheckBox(FrComponent.Controls[5]).Checked;

          OQ.SQL.Text := OQ.SQL.Text +
            'Insert into buchpos_teile values (SEQ_BUCHPOS_ID.nextval, (Select MAX(BUCHID) from buchungen), ' + compID +
            ', ' + CompCount + ', ''' + compSN + ''', ' + BoolToNumber(oneway) + '); ';

        end
        else
        begin
          // if Groupbox's combobox.text is empty, show error label
          lberror.Visible := true;
          ModalResult := mrNone;
          break;
        end;
      end;

      OQ.SQL.Text := OQ.SQL.Text + 'end;';
      querystring := OQ.SQL.Text;

      if ModalResult = mrOK then
      begin
        if not wait then // only send querry, if booking is not handled in FoCreateTask
        begin
          ExecuteDMLQuery(querystring);
          // überprüft und ersetzt den status in der datenbank, hier ab auf basis alter werte
          // I := Task.GetNewStatus;
          // if (StrToInt(Task.StatusID) - 2) <= 3 then // taskStatus (2..5) - 2
          // if StrToInt(Task.StatusID) <> I then
          // UpdateTaskTable(Task.ID, IntToStr(Task.GetNewStatus), Task.AufRechnung, Task.Zeitaufwand, Task.Kommentar);

        end;
        Close; // changes ModalResult to mrCancel
        OQ.Free;
        ModalResult := mrOK;
        if checkInsSerNr then
          componentDictionary.RefreshSerNrList;
      end;
    end;
  end
  else
    lbErrorNoDezimal.Show;

end;

procedure TFormCreateBooking.RefillCBComp(CompNameList: TStringList);
var
  I: Integer;
  FrCB: TFrameComponentBox;
begin
  // fill combobox in each groupbox
  for I := 0 to ScrollBox1.ComponentCount - 1 do
  begin
    FrCB := ScrollBox1.Components[I] as TFrameComponentBox;
    TComboBox(FrCB.Controls[3]).Clear;
    TComboBox(FrCB.Controls[3]).Items.AddStrings(CompNameList);
  end;
end;

procedure TFormCreateBooking.AddComponentFrCB;
var
  compBox: TFrameComponentBox;
begin
  compBox := TFrameComponentBox.Create(ScrollBox1, componentDictionary.GetSortedNameList,
    componentDictionary.GetSerNrList);

  compBox.Name := 'cmb' + IntToStr(CompCount);
  compBox.Parent := ScrollBox1;
  compBox.Top := 5 + (CompCount div (ScrollBox1.Width div (compBox.Width + 15))) * (compBox.Height + 5) -
    ScrollBox1.VertScrollBar.ScrollPos;
  compBox.Left := 10 + (CompCount mod (ScrollBox1.Width div (compBox.Width + 15)) * (compBox.Width + 10));
  CompCount := CompCount + 1;
  (compBox.Controls[3] as TComboBox).OnChange := cbComp;
  (compBox.Controls[6] as TComboBox).OnChange := cbSerNr;
  lbCompCount.Caption := IntToStr(CompCount) + '/' + IntToStr(CompCountMax);

  btRemoveOneGroup.enabled := true;
  btRemoveFiveGroup.enabled := true;
  EdPackageID.enabled := true;
end;

procedure TFormCreateBooking.btAddGroupsClick(Sender: TObject);
var
  I, addBoxCount: Integer;
begin
  // btRemoveOneGroup.Enabled := true;
  // btRemoveFiveGroup.Enabled := true;

  addBoxCount := StrToInt((Sender as TButton).Caption[2]); // get number from button.caption

  if (ScrollBox1.ComponentCount + addBoxCount) >= CompCountMax then
  begin
    btAddOneGroup.enabled := false;
    btAddFiveGroup.enabled := false;
    addBoxCount := CompCountMax - ScrollBox1.ComponentCount;
  end;

  for I := 1 to addBoxCount do
    AddComponentFrCB();

end;

procedure TFormCreateBooking.btClearScrollboxClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ScrollBox1.ComponentCount - 1 do
    RemoveComponent;
  btRemoveOneGroup.enabled := false;
  btRemoveFiveGroup.enabled := false;
  btAddOneGroup.enabled := true;
  btAddFiveGroup.enabled := true;

end;

procedure TFormCreateBooking.btServiceMailClick(Sender: TObject);
var
  FTempMail: TFormTemplateServMail;
  FrComponent: TFrameComponentBox;
  I: Integer;
  bereich: String;
  myarray: TArray<String>;
  // = ['AERO', 'TOP', 'HIT', 'MDE', 'FLOWPICK', 'ASS200', 'ASS'];
begin
  bereich := '<Bereich>';
  myarray := TArray<string>.Create('AERO', 'TOP', 'HIT', 'MDE', 'FLOWPICK', 'ASS200', 'ASS');
  // sollte eines der Stichworte im Auftrags-Kommentar vorkommen, wird <Bereich> automatisch mit diesen ausgetauscht
  for I := 0 to Length(myarray) - 1 do
    if ContainsStr(Task.Kommentar, myarray[I]) then
    begin
      bereich := myarray[I];
      break;
    end;

  // FTempMail := nil;
  // try
  FTempMail := TFormTemplateServMail.Create(self);

  // betreffzeile
  FTempMail.etBetreff.Text := tempCustomerName + ' , <Bezugsperson> , ' + bereich + ' , <Problembeschreibung> , ' +
    etHours.Text + 'h ' + etMinutes.Text + 'min';

  // Buchungsabschnitt
  FTempMail.MemBody.Clear;
  FTempMail.MemBody.Text := '<Buchung, ' + cbTypeID.Text + '>' + sLineBreak;
  if MeComment.Text <> '' then
    FTempMail.MemBody.Text := FTempMail.MemBody.Text + MeComment.Text + sLineBreak + sLineBreak;
  for I := 0 to ScrollBox1.ComponentCount - 1 do
  begin
    FrComponent := ScrollBox1.Components[I] as TFrameComponentBox;
    FTempMail.MemBody.Text := FTempMail.MemBody.Text + FrComponent.toString + sLineBreak;
  end;
  FTempMail.MemBody.Text := FTempMail.MemBody.Text + sLineBreak;

  // auftragsabschnitt
  FTempMail.MemBody.Text := FTempMail.MemBody.Text + '<Auftrag ID:' + auftrID + '>';
  if tempTaskMemo <> '' then
    FTempMail.MemBody.Text := FTempMail.MemBody.Text + sLineBreak + tempTaskMemo
    // else
    // FTempMail.MemBody.Text := FTempMail.MemBody.Text + '<keine Auftragsbeschreibung>';
      ;
  FTempMail.ShowModal;
  // finally
  // if FTempMail <> nil then
  // FTempMail.Free;
  // end;

end;

procedure TFormCreateBooking.etHoursClick(Sender: TObject);
begin
  lbErrorNoDezimal.hide;
  TEdit(Sender).SelectAll;
end;

procedure TFormCreateBooking.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
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

procedure TFormCreateBooking.FormResize(Sender: TObject);
var
  FrComponent: TFrameComponentBox;
  I: Integer;
begin
  if ScrollBox1.Width >= 250 then
    for I := 0 to ScrollBox1.ComponentCount - 1 do
    begin
      FrComponent := ScrollBox1.Components[I] as TFrameComponentBox;
      with FrComponent do
      begin
        Top := 5 + (I div (ScrollBox1.Width div (Width + 15))) * (Height + 5) - ScrollBox1.VertScrollBar.ScrollPos;
        Left := 10 + (I mod (ScrollBox1.Width div (Width + 15)) * (Width + 10));
      end;
    end;
end;

// doublecklick a value in ListBox copies the value into the next empty Component-Combobox and calls its OnChange
procedure TFormCreateBooking.ListBox1DblClick(Sender: TObject);
var
  resultlist: TListBox;
  I: Integer;
  tempstring: String;
  FrCB: TFrameComponentBox;
begin
  resultlist := Sender as TListBox;

  // checks which value has been clicked on
  for I := 0 to resultlist.Items.count - 1 do
  begin
    if resultlist.Selected[I] then
    begin
      tempstring := resultlist.Items[I];
      // break;
    end;
  end;

  // searches for next still empty ComboBox
  for I := 0 to ScrollBox1.ComponentCount - 1 do
  begin
    FrCB := ScrollBox1.Components[I] as TFrameComponentBox;
    if TComboBox(FrCB.Controls[3]).Text = '' then
    begin
      TComboBox(FrCB.Controls[3]).Text := tempstring;
      cbComp(TComboBox(FrCB.Controls[3]));
      break;
    end;
  end;
  // resultlist.Free;
end;

end.
