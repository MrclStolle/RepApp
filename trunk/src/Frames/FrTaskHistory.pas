unit FrTaskHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, UTaskStatus, moreutils, UEmployeeDictionary;

type
  TFrameTaskHistory = class(TFrame)
    lbName: TLabel;
    lbstatus: TLabel;
    lbaufwand: TLabel;
    lbdate: TLabel;
    meComment: TMemo;
    lbTitelaufw: TLabel;
    lbTitlestatus: TLabel;
    Panel1: TPanel;
    lbTitleWareStatus: TLabel;
    lbWareStatus: TLabel;
    lbTitleBillStatus: TLabel;
    lbBillStatus: TLabel;
    imgTaskStatus: TImage;
    imgWareStatus: TImage;
    imgBillStatus: TImage;
    procedure meCommentKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent; Row: TStringList); reintroduce;
    { Public-Deklarationen }
  end;

implementation

uses
  // FoTaskHistory,
  FoRepAppMAIN;

{$R *.dfm}

constructor TFrameTaskHistory.Create(AOwner: TComponent; Row: TStringList);
var
  Status: TStatus;
  hours, minutes: integer;
begin
  inherited Create(AOwner);

  lbName.Caption := EmployeeDictionary[Row[2]].Name;
  Status := TStatus.Create(StrToInt(Row[3]), StrToInt(Row[7]), StrToInt(Row[8]));
  lbstatus.Caption := Status.TaskStatusString;
  lbWareStatus.Caption := Status.WareStatusString;
  lbBillStatus.Caption := Status.BillStatusString;
  RepApp.imgLTaskStatus.GetIcon(Status.TaskStatusInt, imgTaskStatus.Picture.Icon);
  RepApp.ImgLWareStatus.GetIcon(Status.WareStatusInt, imgWareStatus.Picture.Icon);
  RepApp.ImgLBillStatus.GetIcon(0, imgBillStatus.Picture.Icon);
  lbdate.Caption := Row[4];
  // lbaufwand.Caption := Row[5] + ' Stunden';
  ConvertHourDezToHourMin(StrToFloat(Row[5]), hours, minutes);
  lbaufwand.Caption := inttostr(hours) + ' Stunden ' + inttostr(minutes) + ' Minuten';
  meComment.Text := Row[6];
end;

procedure TFrameTaskHistory.meCommentKeyPress(Sender: TObject; var Key: Char);
begin
  try
    if Key = chr(27) then
      (GetParentForm(self, true) as TForm).Close;
  except
    on E: EAccessViolation do
      // nothing
  end;
end;

end.
