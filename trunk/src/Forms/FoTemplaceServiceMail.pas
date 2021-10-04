unit FoTemplaceServiceMail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormTemplateServMail = class(TForm)
    etBetreff: TEdit;
    MemBody: TMemo;
    lbBetreff: TLabel;
    lbBody: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormTemplateServMail: TFormTemplateServMail;

implementation

{$R *.dfm}

procedure TFormTemplateServMail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    close;
end;

end.
