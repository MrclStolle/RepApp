unit UTaskStatus;

interface

uses
  System.SysUtils, Vcl.Dialogs, Vcl.ExtCtrls, System.Classes;

type
  TTaskStatus = (Geschlossen, Offen);
  TWareStatus = (Ausgeglichen, WEOffen, WAOffen, WEWAOffen);
  TBillStatus = (gezahlt, RechnOffen, pruefen, fullService);

type
  TStatus = record

  private

  public
    TaskStatus: TTaskStatus;
    WareStatus: TWareStatus;
    BillStatus: TBillStatus;
    constructor Create(PTaskStatus, PWareStatus, PBillStatus: Integer); overload;
    constructor Create(PTaskStatus: TTaskStatus; PWareStatus: TWareStatus; PBillStatus: TBillStatus); overload;
    function BillStatusString: string;
    function TaskStatusString: string;
    function WareStatusString: string;
    function TaskStatusInt: Integer;
    function WareStatusInt: Integer;
    function BillStatusInt: Integer;
    function TaskStatusNr: String;
    function WareStatusNr: String;
    function BillStatusNr: String;
    procedure SetTaskStatus(Status: Integer);
    procedure SetWareStatus(Status: Integer);
    procedure SetBillStatus(Status: Integer);

  end;

implementation

constructor TStatus.Create(PTaskStatus, PWareStatus, PBillStatus: Integer);
begin
  inherited;
  SetTaskStatus(PTaskStatus);
  SetWareStatus(PWareStatus);
  SetBillStatus(PBillStatus);
end;

constructor TStatus.Create(PTaskStatus: TTaskStatus; PWareStatus: TWareStatus; PBillStatus: TBillStatus);
begin
  inherited;
  TaskStatus := PTaskStatus;
  WareStatus := PWareStatus;
  BillStatus := PBillStatus;
end;

function TStatus.TaskStatusString: string;
begin
  case TaskStatus of
    Offen:
      Result := 'Offen';
    Geschlossen:
      Result := 'Abgeschlossen';
  end;
end;

function TStatus.WareStatusString: string;
begin
  case WareStatus of
    Ausgeglichen:
      Result := 'Ausgeglichen';
    WEOffen:
      Result := 'Wareneingang Offen';
    WAOffen:
      Result := 'Warenausgang Offen';
    WEWAOffen:
      Result := 'Warenein- und Ausgang Offen';
  end;
end;

function TStatus.BillStatusString: string;
begin
  case BillStatus of
    gezahlt:
      Result := 'Rechnung wurde gestellt';
    RechnOffen:
      Result := 'Rechnung muss gestellt werden';
    pruefen:
      Result := 'Rechnungsstatus unklar';
    fullService:
      Result := 'Full Service';
  end;
end;

function TStatus.TaskStatusNr: String;
begin
  Result := IntToStr(TaskStatusInt);
end;

function TStatus.WareStatusNr: String;
begin
  Result := IntToStr(WareStatusInt);
end;

function TStatus.BillStatusNr: String;
begin
  Result := IntToStr(BillStatusInt);
end;

function TStatus.TaskStatusInt: Integer;
begin
  Result := ord(TaskStatus)
end;

function TStatus.WareStatusInt: Integer;
begin
  Result := ord(WareStatus)
end;

function TStatus.BillStatusInt: Integer;
begin
  Result := ord(BillStatus)
end;

procedure TStatus.SetTaskStatus(Status: Integer);
begin
  try
    TaskStatus := TTaskStatus(Status);
  except
    on E: Exception do
      ShowMessage('ID des Auftrags-Status war nicht in Reichweite. ID: ' + IntToStr(Status));
  end;
end;

procedure TStatus.SetWareStatus(Status: Integer);
begin
  try
    WareStatus := TWareStatus(Status);
  except
    on E: Exception do
      ShowMessage('ID des Waren-Status war nicht in Reichweite. ID: ' + IntToStr(Status));
  end;
end;

procedure TStatus.SetBillStatus(Status: Integer);
begin
  try
    BillStatus := TBillStatus(Status);
  except
    on E: Exception do
      ShowMessage('ID des Rechnungs-Status war nicht in Reichweite. ID: ' + IntToStr(Status));
  end;
end;

end.
