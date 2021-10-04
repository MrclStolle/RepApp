unit FoComponentEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UOracleDB, Vcl.Imaging.pngimage, Vcl.ExtCtrls, moreUtils,
  FoShowKomponentList, UComponentDictionary, UUser;

type
  TFormComponentEditor = class(TForm)
    etCrComp: TEdit;
    BTOK: TButton;
    lbMissName: TLabel;
    chbCrCompSerNr: TCheckBox;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    cbSource: TComboBox;
    cbMat: TComboBox;
    imgArrow: TImage;
    btMerge: TButton;
    BTAbort: TButton;
    Panel3: TPanel;
    Label3: TLabel;
    lbEditMissName: TLabel;
    btEditComp: TButton;
    ChbEditCompSerNr: TCheckBox;
    etEditCompName: TEdit;
    cbEditComp: TComboBox;
    lbCrCompMessage: TLabel;
    lbMergCompMessage: TLabel;
    lbEdCompMessage: TLabel;
    Button1: TButton;
    eTWINr: TEdit;
    Label4: TLabel;
    Label6: TLabel;
    Panel4: TPanel;
    Image1: TImage;
    lbMergeSerNrMessage: TLabel;
    cbSerNrSource: TComboBox;
    cbSerNrMat: TComboBox;
    btMergeSerNr: TButton;
    Label2: TLabel;
    Label5: TLabel;
    lbTitleMerge: TLabel;
    lbTitleMergeSerNr: TLabel;
    btInfoMerge: TPanel;
    btInfoMergeSerNr: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure BTClickOK(Sender: TObject);
    procedure BTClickAbort(Sender: TObject);
    procedure btEditCompClick(Sender: TObject);
    procedure btMergeClick(Sender: TObject);
    procedure btInfoMergeClick(Sender: TObject);
    procedure cbEditCompChange(Sender: TObject);
    procedure btInfoMergeSerNrClick(Sender: TObject);
    procedure btMergeSerNrClick(Sender: TObject);
    procedure btInfoMergeSerNrMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure btInfoMergeSerNrMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure cbSourceChange(Sender: TObject);
    procedure cbSerNrSourceChange(Sender: TObject);
    procedure etCrCompChange(Sender: TObject);
    procedure etEditCompNameChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    procedure RefillCBComp;
    procedure RefillCBSerNr;

  public
    /// <summary>
    /// Statusbar-Text, wenn eine der Funktionen im COmpponentEditor genutzt wurde.
    /// </summary>
    CompChanged: String;
    constructor Create(AOwner: TComponent); reintroduce;
    { Public-Deklarationen }
  end;

var
  FormComponentEditor: TFormComponentEditor;

implementation

{$R *.dfm}

constructor TFormComponentEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TFormComponentEditor.FormCreate(Sender: TObject);
begin
  RefillCBComp;
  RefillCBSerNr;
  CompChanged := '';
end;

procedure TFormComponentEditor.BTClickOK(Sender: TObject);
begin
  if etCrComp.Text = '' then
  begin
    lbMissName.show;
    lbMissName.Caption := 'Der Name fehlt!';
  end
  else if Application.MessageBox(pWideChar('Erstelle neues Teil mit' + #13#10 + 'Name: "' + etCrComp.Text + '"' + #13#10
    + 'Bauart hat Seriennummer: ' + BoolToYN(chbCrCompSerNr.Checked)), 'Bestätigung', MB_OKCANCEL) = IDOK then
  begin
    if componentDictionary.ContainsName(etCrComp.Text) then
      lbCrCompMessage.Caption := 'Dieses Object existiert bereits!'
    else
    begin
      try
        InsertIntoComp(etCrComp.Text, chbCrCompSerNr.Checked, User.ID, eTWINr.Text);

        CompChanged := 'Komponente wurde erstellt!';
        // lbMissName.Hide;
        lbCrCompMessage.Caption := etCrComp.Text + ' wurde erstellt!';

        etCrComp.Text := '';
        chbCrCompSerNr.Checked := false;

        componentDictionary.RefreshFromDatabase;
        RefillCBComp;
      except
        on E: Exception do
          lbCrCompMessage.Caption := 'Fehler bei erstellung';
      end;
    end;
  end;
end;

procedure TFormComponentEditor.BTClickAbort(Sender: TObject);
begin
  // ModalResult := mrCancel;
  Close;
end;

procedure TFormComponentEditor.btEditCompClick(Sender: TObject);
begin
  if etEditCompName.Text = '' then
  begin
    lbEditMissName.show;
    lbEditMissName.Caption := 'Der Name fehlt!';
  end
  else if not componentDictionary.ContainsName(cbEditComp.Text) then
    lbEdCompMessage.Caption := 'Diese Komponente existiert nicht in der Datenbank'
  else if Application.MessageBox(pWideChar('Ändere Teil zu' + #13#10 + 'Name: "' + etEditCompName.Text + '"' + #13#10 +
    'Bauart hat Seriennummer: ' + BoolToYN(ChbEditCompSerNr.Checked)), 'Bestätigung', MB_OKCANCEL) = IDOK then
  begin
    if componentDictionary.ContainsName(etEditCompName.Text) and (cbEditComp.Text <> etEditCompName.Text) then
      lbEdCompMessage.Caption := 'Dieses Object existiert bereits!'
    else
    begin
      try
        ExecuteDMLQuery('Update TEILE set NAME=''' + etEditCompName.Text + ''', SNPFLICHT=' +
          BoolToNumber(ChbEditCompSerNr.Checked) + 'WHERE TEILID=' + componentDictionary.GetComponent
          (cbEditComp.Text).ID);

        CompChanged := 'Komponente wurde geändert!';

        lbEditMissName.Hide;
        lbEdCompMessage.Caption := etCrComp.Text + ' wurde geändert!';
        cbEditComp.Text := etEditCompName.Text;
        etEditCompName.Text := '';
        chbCrCompSerNr.Checked := false;

        componentDictionary.RefreshFromDatabase;
        RefillCBComp;
      except
        on E: Exception do
        begin
          lbEdCompMessage.Caption := 'Fehler bei Änderung';
          // ShowMessage(E.ToString);
        end;
      end;
    end;
  end;
end;

procedure TFormComponentEditor.btMergeClick(Sender: TObject);
var
  compID1, compID2: String;
begin
  if (cbSource.Text <> '') and (cbMat.Text <> '') then
  begin
    compID1 := componentDictionary.GetComponent(cbSource.Text).ID;
    compID2 := componentDictionary.GetComponent(cbMat.Text).ID;
    if Application.MessageBox(pWideChar('Verschmelze "' + cbSource.Text + '"' + #13#10 + 'mit "' + cbMat.Text + '"' +
      #13#10 + 'Korrekt?'), 'Bestätigung', MB_OKCANCEL) = IDOK then
      try
        ExecuteDMLQuery('Update BUCHPOS_TEILE set TEILID=''' + compID1 + ''' where TEILID=''' + compID2 + '''');
        ExecuteDMLQuery('Delete from TEILE where TEILID=''' + compID2 + '''');

        CompChanged := 'Komponenten wurden verschmolzen!';
        lbMergCompMessage.Caption := '"' + cbMat.Text + '" wurde zu "' + cbSource.Text + '" geändert';
        cbMat.Text := '';

        componentDictionary.RefreshFromDatabase;
        RefillCBComp;

      except
        on E: Exception do
        begin
          ShowMessage(E.ToString);
          lbMergCompMessage.Caption := 'Fehler beim Verschmelzen'
        end;
      end;
  end
  else
    lbMergCompMessage.Caption := 'Komponenten nicht gewählt!';
end;

procedure TFormComponentEditor.btMergeSerNrClick(Sender: TObject);
begin
  if Application.MessageBox(pWideChar('Verschmelze "' + cbSource.Text + '"' + #13#10 + 'mit "' + cbSerNrMat.Text + '"' +
    #13#10 + 'Korrekt?'), 'Bestätigung', MB_OKCANCEL) = IDOK then
    try
      UpdateSerNr(cbSource.Text, cbSerNrMat.Text);
      lbMergeSerNrMessage.Caption := '"' + cbSerNrMat.Text + '" wurde zu "' + cbSerNrSource.Text + '" geändert';
      CompChanged := 'Seriennummern wurden verschmolzen!';
    except
      on E: Exception do
      begin
        ShowMessage(E.ToString);
        lbMergeSerNrMessage.Caption := 'Fehler beim Verschmelzen'
      end;
    end;
end;

procedure TFormComponentEditor.btInfoMergeClick(Sender: TObject);
begin
  ShowMessage
    ('Das Mergen(Verschmelzen) dient dem sicheren Bereinigen der Datenbank bei doppelt eingetragene Komponenten. ' +
    ' Hierbei nimmt das untere Teil die Eigeschaften des Obenren an und wird anschließend gelöscht.');
end;

procedure TFormComponentEditor.btInfoMergeSerNrClick(Sender: TObject);
begin
  ShowMessage
    ('Das Mergen(Verschmelzen) dient dem sicheren Bereinigen der Datenbank bei doppelt eingetragenen Serien-Nummern. ' +
    ' Hierbei nimmt das untere Teil die Eigeschaften des Obenren an und wird anschließend gelöscht.');
end;

procedure TFormComponentEditor.btInfoMergeSerNrMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvLowered;
end;

procedure TFormComponentEditor.btInfoMergeSerNrMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  TPanel(Sender).BevelOuter := bvRaised;
end;

procedure TFormComponentEditor.Button1Click(Sender: TObject);
var
  FCompList: TFoCompList;
begin
  // FCompList := nil;
  // try
  FCompList := TFoCompList.Create(self);
  FCompList.ShowModal;
  // finally
  // if FCompList <> nil then
  // FCompList.Free;
  // end;

end;

procedure TFormComponentEditor.cbEditCompChange(Sender: TObject);
begin
  if componentDictionary.GetComponent(cbEditComp.Text) <> nil then
  begin
    etEditCompName.Text := cbEditComp.Text;
    if componentDictionary.GetComponent(cbEditComp.Text).NeedSerialNumber then
      ChbEditCompSerNr.Checked := true
    else
      ChbEditCompSerNr.Checked := false;
  end;

end;

procedure TFormComponentEditor.cbSerNrSourceChange(Sender: TObject);
begin
  if (cbSerNrSource.Text <> '') and (cbSerNrMat.Text <> '') and (cbSerNrSource.Text <> cbSerNrMat.Text) then
    if (componentDictionary.GetSerNrList.IndexOf(cbSerNrSource.Text) >= 0) and
      (componentDictionary.GetSerNrList.IndexOf(cbSerNrMat.Text) >= 0) then
      btMergeSerNr.Enabled := true
    else
      btMergeSerNr.Enabled := false
  else
    btMergeSerNr.Enabled := false;

end;

procedure TFormComponentEditor.cbSourceChange(Sender: TObject);
begin
  lbMergCompMessage.Caption := '';

  if (cbSource.Text <> '') and (cbMat.Text <> '') and (cbSource.Text <> cbMat.Text) then
    if (componentDictionary.ContainsName(cbSource.Text)) and (componentDictionary.ContainsName(cbMat.Text)) then
      btMerge.Enabled := true
    else
      btMerge.Enabled := false
  else
    btMerge.Enabled := false;
end;

procedure TFormComponentEditor.etCrCompChange(Sender: TObject);
begin
  lbMissName.Visible := false;
end;

procedure TFormComponentEditor.etEditCompNameChange(Sender: TObject);
begin
  lbEditMissName.Visible := false;
end;

procedure TFormComponentEditor.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    Close;
end;

procedure TFormComponentEditor.RefillCBComp;
begin
  cbSource.Items.Clear;
  cbSource.Items.AddStrings(componentDictionary.GetSortedNameList);

  cbMat.Items.Clear;
  cbMat.Items := cbSource.Items;
  cbEditComp.Items.Clear;
  cbEditComp.Items := cbSource.Items;
end;

procedure TFormComponentEditor.RefillCBSerNr;
begin
  cbSerNrSource.Items := componentDictionary.GetSerNrList;
  cbSerNrMat.Items := cbSerNrSource.Items;
end;

end.
