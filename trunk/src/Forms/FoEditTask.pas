unit FoEditTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UOracleDB, UTask, UUser, UTaskStatus, moreUtils, Vcl.ExtCtrls,
  UTaskDictionary;

type
  TFormEditTask = class(TForm)
    lbTitle: TLabel;
    btOK: TButton;
    btAbort: TButton;
    Panel1: TPanel;
    lbTitleComment: TLabel;
    lbCustomerName: TLabel;
    lbTitleTaskStatus: TLabel;
    lbTitleBillStatus: TLabel;
    Label1: TLabel;
    eTimeConsumption: TLabel;
    lbTitleTime: TLabel;
    cbStatus: TComboBox;
    memBeschreibung: TMemo;
    cbBillStatus: TComboBox;
    procedure btAbortClick(Sender: TObject);
    procedure btOKClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public-Deklarationen }

    constructor Create(AOwner: TComponent; TaskID: String); Reintroduce;
  end;

var
  FormEditTask: TFormEditTask;
  Task: TTask;

implementation

{$R *.dfm}

constructor TFormEditTask.Create(AOwner: TComponent; TaskID: String);
var
  hours, minutes: Integer;
begin
  { TODO -ostolle -cGeneral : anzeigen der entsprechenden Bildchen bei der wahl des status }
  inherited Create(AOwner);
  Task := TaskDictionary.GetTask(TaskID);
  caption := caption + TaskID;
  LockTaskRow(TaskID);

  lbCustomerName.caption := Task.GetCustomer.name;

  // manually added, missing way to itterate trought enum and get all names
  cbStatus.Items.Add('Abgeschlossen');
  cbStatus.Items.Add('Offen');
  cbStatus.itemindex := StrToInt(Task.Status.TaskStatusNr);

  cbBillStatus.Items.Add('Rechnung wurde gestellt');
  cbBillStatus.Items.Add('Rechnung muss gestellt werden');
  cbBillStatus.Items.Add('Rechnungsstatus unklar');
  cbBillStatus.itemindex := StrToInt(Task.Status.BillStatusNr);

  if Task.Status.BillStatusNr = '3' then
  begin
    // cbBillStatus.Enabled := false;
    cbBillStatus.Items.Add('Full Service');
    cbBillStatus.itemindex := 3;
  end;

  ConvertHourDezToHourMin(Task.hours, hours, minutes);
  eTimeConsumption.caption := inttostr(hours) + 'Std. ' + inttostr(minutes) + 'Min.';

  memBeschreibung.Text := Task.Kommentar;
end;

procedure TFormEditTask.btAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  close;
end;

procedure TFormEditTask.btOKClick(Sender: TObject);
begin
  begin
    // update DB
    UpdateTaskTable(Task.ID, inttostr(cbStatus.itemindex), memBeschreibung.Text, Task.Status.WareStatusNr,
      inttostr(cbBillStatus.itemindex));

    // Update local
    // änderung wird lokal durchgeführt, ohne die ganze scrollbox zu erneuern -> kein abstrakter fehler durch zu frühes freigeben
    Task.Kommentar := memBeschreibung.Text;
    Task.Status.SetBillStatus(cbBillStatus.itemindex);
    Task.Status.SetTaskStatus(cbStatus.itemindex);

    // insert change into AuftrProtokoll
    InsertIntoAuftrProt(Task.ID, User.ID, inttostr(cbStatus.itemindex), floattostr(Task.hours), memBeschreibung.Text,
      Task.Status.WareStatusNr, inttostr(cbBillStatus.itemindex));

    close;
    ModalResult := mrOK;
  end

end;

procedure TFormEditTask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ReleaseTaskRow(Task.ID);
end;

end.
