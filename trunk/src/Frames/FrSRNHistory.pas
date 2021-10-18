unit FrSRNHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  UComponentDictionary, UCustomerDictionary, UEmployeeDictionary;

type
  TFrameSRNHistory = class(TFrame)
    lbCompName: TLabel;
    lbBuchtyp: TLabel;
    lbDate: TLabel;
    lbMAName: TLabel;
    lbCustName: TLabel;
    Panel1: TPanel;
    Image1: TImage;
  private
    { Private-Deklarationen }
  public
    constructor Create(const Row: TStringList; const FrParent: TWinControl; const FrTop: Integer); reintroduce;
    { Public-Deklarationen }
  end;

var
  BookTypeID: Integer;

implementation

uses FoRepAppMain;

{$R *.dfm}

constructor TFrameSRNHistory.Create(const Row: TStringList; const FrParent: TWinControl; const FrTop: Integer);
begin
  inherited Create(nil);
  parent := FrParent;
  top := FrTop;
  left := 0;
  lbCompName.Caption := componentDictionary.GetComponent(Row[2]).Name;

  BookTypeID := StrToInt(Row[8]);
  lbBuchtyp.Caption := BookingTypeArray[BookTypeID];

  case BookTypeID of
    0, 2:
      RepApp.imgLBookTypeID.GetIcon(0, Image1.Picture.Icon);
    // Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WEIcon.png');
    1, 3:
      RepApp.imgLBookTypeID.GetIcon(1, Image1.Picture.Icon);
    // Image1.Picture.LoadFromFile(ExtractFilePath(Application.ExeName) + '\images\WAIcon.png');

  end;

  lbDate.Caption := Row[9];
  lbMAName.Caption := EmployeeDictionary[Row[11]].Name;
  lbCustName.Caption := CustomerDictionary.GetCustomer(Row[15]).Name;
  // Row.Free;
end;

end.
