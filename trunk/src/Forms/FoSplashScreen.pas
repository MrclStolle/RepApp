unit FoSplashScreen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.GIFImg, Vcl.ExtCtrls;

type
  TFormSplashScreen = class(TForm)
    lbTitle: TLabel;
    lbSubTitle: TLabel;
    lbSubTitle2: TLabel;
  private
    { Private-Deklarationen }
  public
    constructor Create(Title: String); reintroduce;
    procedure Subtitle(Subtitle: String);
    procedure SubTitle2(Subtitle: String);
    { Public-Deklarationen }
  end;

  // procedure CreateSplash(Title: String);
  //
  // procedure SplashSub(Subtitle: String);

var
  FormSplashScreen: TFormSplashScreen;

implementation

{$R *.dfm}
// procedure CreateSplash(Title: String);
// begin
// FormSplashScreen := TFormSplashScreen.Create(Title);
// end;
//
// procedure SplashSub(Subtitle: String);
// begin
// FormSplashScreen.Subtitle(Subtitle);
// end;

constructor TFormSplashScreen.Create(Title: String);
begin
  inherited Create(nil);
  lbTitle.Caption := Title;
  lbSubTitle.Caption := '';
  lbSubTitle2.Caption := '';
  Show;
  Update;
  // sleep(500)
end;

procedure TFormSplashScreen.Subtitle(Subtitle: String);
begin
  lbSubTitle.Caption := Subtitle;
  Update;
  // sleep(500);
end;

procedure TFormSplashScreen.SubTitle2(Subtitle: String);
begin
  lbSubTitle2.Caption := Subtitle;
  Update;
  // sleep(500);
end;

end.
