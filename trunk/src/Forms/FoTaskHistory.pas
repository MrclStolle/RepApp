unit FoTaskHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FrTaskHistory, Vcl.StdCtrls,
  Vcl.ExtCtrls, UOracleDB;

type
  TFormTaskHistory = class(TForm)
    lbNoHistory: TLabel;
    ScrollBoxHistory: TScrollBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure FormResize(Sender: TObject);
  public

    constructor Create(AOwner: TComponent; TaskID: String); reintroduce;
    { Public-Deklarationen }
  published
  end;

var
  FormTaskHistory: TFormTaskHistory;

implementation

uses FoRepAppMAIN;

{$R *.dfm}

constructor TFormTaskHistory.Create(AOwner: TComponent; TaskID: String);
var
  I, TopAnchor: Integer;
  Table: TList;

  Frame: TFrameTaskHistory;

begin
  inherited Create(AOwner);
  TopAnchor := 0;
  Table := nil;
  try
    Table := TList.Create;

    GetTaskHistory(TaskID, Table);
    caption := caption + TaskID;

    if Table.count > 0 then
      for I := 0 to Table.count - 1 do
      begin
        Frame := TFrameTaskHistory.Create(ScrollBoxHistory, Table[I]);
        Frame.Name := 'FrTH' + IntToStr(I);

        Frame.Top := TopAnchor;
        Frame.Left := 0;
        Frame.Parent := self.ScrollBoxHistory;
        Frame.Width := self.ScrollBoxHistory.Width;

        Frame.Anchors := [akLeft, akTop, akRight];
        Frame.Show;

        TopAnchor := TopAnchor + Frame.Height + 1;

      end
    else
    begin
      ScrollBoxHistory.Free;
    end;
  finally
    for I := 0 to Table.count - 1 do
      TStringList(Table[I]).Free;
    Table.Free;
  end;

end;

procedure TFormTaskHistory.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    close;
end;

procedure TFormTaskHistory.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
var
  LTopLeft, LTopRight, LBottomLeft, LBottomRight: SmallInt;
  LPoint: TPoint;
begin
  inherited;
  LPoint := ScrollBoxHistory.ClientToScreen(Point(0, 0));

  LTopLeft := LPoint.X;
  LTopRight := LTopLeft + ScrollBoxHistory.Width;

  LBottomLeft := LPoint.Y;
  LBottomRight := LBottomLeft + ScrollBoxHistory.Width;

  if (MousePos.X >= LTopLeft) and (MousePos.X <= LTopRight) and (MousePos.Y >= LBottomLeft) and
    (MousePos.Y <= LBottomRight) then
  begin
    ScrollBoxHistory.VertScrollBar.Position := ScrollBoxHistory.VertScrollBar.Position - WheelDelta;

    Handled := true;
  end;

end;

procedure TFormTaskHistory.FormResize(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ScrollBoxHistory.ControlCount - 1 do
    TFrameTaskHistory(ScrollBoxHistory.Controls[I]).Width := ScrollBoxHistory.Width;

end;

end.
