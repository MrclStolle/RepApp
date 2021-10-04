unit FoCreateEmployee;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UOracleDB, Vcl.ExtCtrls, UUser, UEmployeeDictionary;

type
  TFormCreateEmployee = class(TForm)
    eName: TEdit;
    eShort: TEdit;
    lbTitleInitHint: TLabel;
    btCreate: TButton;
    btClose: TButton;
    lbMissName: TLabel;
    etPW: TEdit;
    etPWcheck: TEdit;
    lbTitleName: TLabel;
    lbTitleInit: TLabel;
    lbTitleNewEmplPW: TLabel;
    lbTitleNewEmplPW2: TLabel;
    lbTitleNewEmployee: TLabel;
    pnlNewEmployee: TPanel;
    pnlChangePW: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    etPwNew: TEdit;
    Label9: TLabel;
    etPwNewCheck: TEdit;
    Label10: TLabel;
    etPwOld: TEdit;
    btChangePW: TButton;
    Label11: TLabel;
    etName2: TEdit;
    lbPWError: TLabel;
    chbAdmin: TCheckBox;
    procedure btCloseClick(Sender: TObject);
    procedure btChangePWClick(Sender: TObject);
    procedure btCreateClick(Sender: TObject);
    procedure eNameChange(Sender: TObject);
    procedure etPWcheckKeyPress(Sender: TObject; var Key: Char);
    procedure etPwNewCheckKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private-Deklarationen }
  public
    constructor Create(const AOwner: TComponent; CurrentUser: TUser); reintroduce;
    { Public-Deklarationen }
  end;

var
  FormCreateEmployee: TFormCreateEmployee;
  ID: String;

implementation

uses FoRepAppMain;
{$R *.dfm}

{ TODO -ostolle -cGeneral : möglichkeit einen anderen bestehenden Mitarbeiter/Nutzer zu ändern }
constructor TFormCreateEmployee.Create(const AOwner: TComponent; CurrentUser: TUser);
begin
  inherited Create(AOwner);
  etName2.Text := CurrentUser.Name;
  ID := CurrentUser.ID;
  pnlNewEmployee.visible := User.admin; // nur als admin wird die erstellung von mitarbeitern angezeigt
  if pnlNewEmployee.visible then
    btClose.Left := pnlNewEmployee.Left + pnlNewEmployee.Width - btClose.Width;
end;

procedure TFormCreateEmployee.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormCreateEmployee.btChangePWClick(Sender: TObject);
var
  tempTable: TList;
  I: Integer;
begin
  if (etPwOld.Text = '') or (etPwNew.Text = '') or (etPwNewCheck.Text = '') then
    lbPWError.Caption := 'Bitte alle Felder ausfüllen'
  else if (etPwNew.Text <> etPwNewCheck.Text) then
    lbPWError.Caption := 'Passwörter nicht identisch'
  else if Application.MessageBox(pWideChar('Password ändern für ' + #13#10 + '"' + etName2.Text + '"'), 'Bestätigung',
    MB_OKCANCEL) = IDOK then
  begin
    try
      if tempTable <> nil then
        tempTable := nil;
      tempTable := TList.Create;

      SelectXFromYWhereZOrderBy('*', 'mitarbeiter', 'NAME=''' + etName2.Text + ''' and PW=''' + etPwOld.Text + '''', '',
        tempTable);

      if tempTable.Count = 1 then
      begin
        ExecuteDMLQuery('Update MITARBEITER set PW=''' + etPwNewCheck.Text + ''' WHERE MAID=' + ID);
        lbPWError.Caption := 'Password geändert!';
        RepApp.SetStatusBar(lbPWError.Caption);
        etPwOld.Text := '';
        etPwNew.Text := '';
        etPwNewCheck.Text := '';
      end
      else
        lbPWError.Caption := 'Fehler beim Login';
    finally
      for I := 0 to tempTable.Count - 1 do
        TStringList(tempTable[I]).Free;
      tempTable.Free;
    end;

  end;
end;

procedure TFormCreateEmployee.btCreateClick(Sender: TObject);
begin
  if (eName.Text = '') or (eShort.Text = '') or (etPW.Text = '') then
    lbMissName.Caption := 'Bitte alle Felder ausfüllen'
  else if (etPWcheck.Text <> etPW.Text) then
    lbMissName.Caption := 'Passwörter nicht identisch'
  else if Application.MessageBox(pWideChar('Erstelle neuen Mitarbeiter mit' + #13#10 + 'Name: "' + eName.Text + '"' +
    #13#10 + 'Initialien: ' + eShort.Text), 'Bestätigung', MB_OKCANCEL) = IDOK then
  begin
    try
      InsertIntoEmployee(eName.Text, eShort.Text, etPW.Text, chbAdmin.Checked);
      Close;
      ModalResult := mrOK;
      EmployeeDictionary.Refresh;
    except
      on E: Exception do
        lbMissName.Caption := 'Die Initialien sind bereits vergeben';
    end;

  end;
end;

procedure TFormCreateEmployee.eNameChange(Sender: TObject);
var
  temptext: string;
begin
  temptext := '';
  temptext := Trim(TEdit(Sender).Text);

  if Length(temptext) = 0 then
  begin
    eShort.Text := '';
  end
  else
  begin
    eShort.Text := temptext[1];
    if Pos(' ', temptext) > 0 then
      eShort.Text := eShort.Text + temptext[Pos(' ', temptext) + 1]
  end;
end;

procedure TFormCreateEmployee.etPWcheckKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btCreateClick(btCreate);

end;

procedure TFormCreateEmployee.etPwNewCheckKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btChangePWClick(btChangePW);
end;

procedure TFormCreateEmployee.FormCreate(Sender: TObject);
begin
  eShort.MaxLength := 5;
end;

procedure TFormCreateEmployee.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    Close;
end;

end.
