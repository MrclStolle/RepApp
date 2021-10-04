unit FoShowSRNHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrSRNHistory, UOracleDB;

type
  TFormShowSRNHistory = class(TForm)
    ScrollBox1: TScrollBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
  private
    // procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta:
    // Integer; MousePos: TPoint; var Handled: Boolean);
    { Private-Deklarationen }
  public
    constructor Create(const AOwner: TComponent; const SerialNr: string); reintroduce;
    { Public-Deklarationen }
  end;

var
  FormShowSRNHistory: TFormShowSRNHistory;

implementation

{$R *.dfm}

constructor TFormShowSRNHistory.Create(const AOwner: TComponent; const SerialNr: string);
var
  SNrHistoryTable: TList;
  AnchorTop: Integer;
  I: Integer;
  Frame: TFrameSRNHistory;
begin
  inherited Create(AOwner);
  AnchorTop := 0;
  try
    // if SNrHistoryTable <> nil then
    // for I := 0 to SNrHistoryTable.Count - 1 do
    // TStringList(SNrHistoryTable[I]).Free;

    if SNrHistoryTable <> nil then
    begin
      SNrHistoryTable := nil
    end;

    SNrHistoryTable := TList.Create;

    ExecuteDQLQuery('select * from BUCHPOS_TEILE ' + 'left join BUCHUNGEN on BUCHPOS_TEILE.BUCHID=BUCHUNGEN.BUCHID ' +
      'left join AUFTRAG on BUCHUNGEN.AUFTRID=AUFTRAG.AUFTRID ' + 'where SNR=''' + SerialNr +
      ''' order by BUCHUNGEN.BUCHID', SNrHistoryTable);
    Caption := Caption + SerialNr;

    for I := 0 to SNrHistoryTable.Count - 1 do
    begin
      Frame := TFrameSRNHistory.Create(TStringList(SNrHistoryTable[I]), ScrollBox1, AnchorTop);
      Frame.Show;
      AnchorTop := AnchorTop + Frame.Height + 1;
    end;

  finally
    for I := 0 to SNrHistoryTable.Count - 1 do
      TStringList(SNrHistoryTable[I]).Free;
    SNrHistoryTable.Free;

  end;
end;

procedure TFormShowSRNHistory.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    close;
end;

procedure TFormShowSRNHistory.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
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

procedure TFormShowSRNHistory.FormResize(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ScrollBox1.ControlCount - 1 do
    TFrameSRNHistory(ScrollBox1.Controls[I]).Width := ScrollBox1.Width;
end;

end.
