unit FoLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UOracleDB,
  Generics.Collections, USettings, UUser, UEmployee, Vcl.ExtCtrls, Vcl.Buttons;

type
  TFormLogin = class(TForm)
    btChangeLogon: TButton;
    pnlLogIn: TPanel;
    lbLoginTitle: TLabel;
    lbError: TLabel;
    etPW: TEdit;
    etUser: TEdit;
    ckbremMe: TCheckBox;
    ckbremPW: TCheckBox;
    pnlChangeDB: TPanel;
    bt_Abort: TButton;
    bt_Login: TButton;
    lbTitleServName: TLabel;
    etServName: TEdit;
    lbTitleServUserName: TLabel;
    etUserName: TEdit;
    lbTitlePW: TLabel;
    etUserPW: TEdit;
    btConnect: TButton;
    lbTitleInfo: TLabel;
    lbconn: TLabel;
    btSaveConn: TButton;
    Label1: TLabel;
    Label2: TLabel;

    procedure btConnectClick(Sender: TObject);
    procedure bt_AbortClick(Sender: TObject);
    procedure cb_MA_NamesChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btChangeLogonClick(Sender: TObject);
    procedure bt_LoginClick(Sender: TObject);
    procedure btSaveConnClick(Sender: TObject);
    procedure etOnChange(Sender: TObject);
  private

    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent); reintroduce;
  end;

var
  FormLogin: TFormLogin;
  cb_MA_Names: TComboBox;

  currentMAID: string;
  ShowDBConSettings: boolean = false;

implementation

uses FoRepAppMain;

{$R *.dfm}

constructor TFormLogin.Create(AOwner: TComponent);
var
  LastUser: TUser;
begin
  inherited Create(AOwner);
  if SessionConnected then // if connection is established
  begin
    LastUser := nil;

    if User = nil then // wenn bisher kein User eingeloggt ist
    begin // nehme werte vom letzten eingeloggten User
      USettings.GetLastUser(LastUser);
      etUser.Text := LastUser.Name;
      etPW.Text := LastUser.PW;
      ckbremMe.Checked := LastUser.rememberMe;
      ckbremPW.Checked := LastUser.rememberPW;

      if ckbremMe.Checked and ckbremPW.Checked then
      begin
        bt_LoginClick(bt_Login);
      end;
    end
    else
    begin
      etUser.Text := User.Name;
      etPW.Text := User.PW;
      ckbremMe.Checked := User.rememberMe;
      ckbremPW.Checked := User.rememberPW;
    end;

    if LastUser <> nil then
      LastUser.Free;

  end
  else // connection not etablished
  begin
    lbError.Caption := 'Keine Verbindung zum Server';
    lbError.show;
    bt_Login.Enabled := false;
  end;

end;

procedure TFormLogin.btConnectClick(Sender: TObject);
begin
  if TestConnection(etServName.Text, etUserName.Text, etUserPW.Text) then
  begin
    lbconn.Caption := 'Test Erfolgreich!';
    btSaveConn.Enabled := true;

  end
  else
  begin
    lbconn.Caption := 'Verbindung fehlgeschlagen';
  end;
end;

procedure TFormLogin.bt_AbortClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TFormLogin.btChangeLogonClick(Sender: TObject);
begin
  ShowDBConSettings := not ShowDBConSettings;
  if ShowDBConSettings then
  begin
    (Sender as TButton).Caption := 'Datenbank Wechseln <-';
    // self.Width := pnlChangeDB.Left + pnlChangeDB.Width + 25;
  end
  else
  begin
    (Sender as TButton).Caption := 'Datenbank Wechseln ->';
    // self.Width := pnlLogIn.Left + pnlLogIn.Width + 25;
  end;
  pnlChangeDB.Visible := not pnlChangeDB.Visible;
end;

procedure TFormLogin.btSaveConnClick(Sender: TObject);
begin
  SetCurrentSession(etServName.Text, etUserName.Text, etUserPW.Text);
  SafeConnection(etServName.Text, etUserName.Text, etUserPW.Text);
  bt_Login.Enabled := true;
  btSaveConn.Enabled := false;
  RepApp.RefreshTaskTables;

end;

procedure TFormLogin.bt_LoginClick(Sender: TObject);
var
  tempTable: TList;
  I: integer;
begin
  { TODO -ostolle -cGeneral : login-möglichkeit mit klein geschriebenen Namen/Initialen, änderung auch bei erstellen eines Nutzers }
  try
    tempTable := nil;
    tempTable := TList.Create;
    // requests a table depending on input (name and password)
    SelectXFromYWhereZOrderBy('MAID, NAME, KURZ, admin', 'mitarbeiter', '(NAME=''' + etUser.Text + ''' OR KURZ=''' +
      etUser.Text + ''') and PW=''' + etPW.Text + '''', '', tempTable);

    if tempTable.Count = 1 then // if table.count =0, no name and pw match has been found -> no login
    begin
      if User <> nil then
        User.Free;

      User := TUser.Create(TStringList(tempTable[0])[0], TStringList(tempTable[0])[1], TStringList(tempTable[0])[2],
        etPW.Text, ckbremMe.Checked, ckbremPW.Checked, StrToBool(TStringList(tempTable[0])[3]));
      SaveUser(User);
      Close;
      ModalResult := mrOK;
    end
    else
    begin
      lbError.Caption := 'Name oder Password falsch';
      lbError.show;
    end;

  finally
    // free Temptable
    for I := 0 to tempTable.Count - 1 do
      if TStringList(tempTable[I]) <> nil then
        TStringList(tempTable[I]).Free;
    tempTable.Free;
  end;

end;

// to change names fast
procedure TFormLogin.cb_MA_NamesChange(Sender: TObject);
begin
  with Sender as TComboBox do
    etUser.Text := Text
end;

procedure TFormLogin.etOnChange(Sender: TObject);
begin
  lbError.hide;
end;

procedure TFormLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) { escape } then
    Close;

end;

end.
