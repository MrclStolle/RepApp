object FormLogin: TFormLogin
  Left = 617
  Top = 386
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Nutzer Login'
  ClientHeight = 362
  ClientWidth = 554
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 15
  Padding.Top = 15
  Padding.Right = 15
  Padding.Bottom = 15
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object lbTitleInfo: TLabel
    Left = 18
    Top = 279
    Width = 234
    Height = 68
    AutoSize = False
    Caption = 
      'Info: Wenn beide "Merken"-Hacken gesetzt sind, dann wird beim n'#228 +
      'chsten Start der App der Login automatisch ausgef'#252'hrt.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object btChangeLogon: TButton
    Left = 90
    Top = 15
    Width = 150
    Height = 25
    Caption = 'Datenbank wechseln ->'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btChangeLogonClick
  end
  object pnlLogIn: TPanel
    Left = 15
    Top = 46
    Width = 248
    Height = 227
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    ParentColor = True
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      248
      227)
    object lbLoginTitle: TLabel
      Left = 23
      Top = 22
      Width = 171
      Height = 30
      Caption = 'Einloggen als...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -25
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbError: TLabel
      Left = 29
      Top = 163
      Width = 39
      Height = 16
      Anchors = []
      Caption = 'lberror'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label1: TLabel
      Left = 29
      Top = 58
      Width = 190
      Height = 16
      Caption = 'Vor- und Nachname oder Initalen'
    end
    object Label2: TLabel
      Left = 29
      Top = 112
      Width = 52
      Height = 16
      Caption = 'Passwort'
    end
    object etPW: TEdit
      Left = 25
      Top = 134
      Width = 145
      Height = 24
      PasswordChar = '*'
      TabOrder = 2
      TextHint = 'Passwort'
      OnChange = etOnChange
    end
    object etUser: TEdit
      Left = 23
      Top = 80
      Width = 145
      Height = 24
      Hint = 'Benutzername oder Initalen'
      TabOrder = 0
      TextHint = 'Vollname oder Initalien'
      OnChange = etOnChange
    end
    object ckbremMe: TCheckBox
      Left = 174
      Top = 82
      Width = 58
      Height = 17
      Hint = 'Benutzernamen f'#252'r den n'#228'chsten Login merken.'
      Caption = 'Merken'
      TabOrder = 1
    end
    object ckbremPW: TCheckBox
      Left = 176
      Top = 136
      Width = 58
      Height = 17
      Hint = 'Passwort f'#252'r den n'#228'chsten Login merken.'
      Caption = 'Merken'
      TabOrder = 3
    end
    object bt_Abort: TButton
      Left = 128
      Top = 186
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Abbrechen'
      TabOrder = 5
      OnClick = bt_AbortClick
    end
    object bt_Login: TButton
      Left = 34
      Top = 186
      Width = 75
      Height = 25
      Caption = 'Login'
      Default = True
      TabOrder = 4
      OnClick = bt_LoginClick
    end
  end
  object pnlChangeDB: TPanel
    Left = 297
    Top = 46
    Width = 242
    Height = 275
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    ParentColor = True
    ParentFont = False
    TabOrder = 2
    Visible = False
    object lbTitleServName: TLabel
      Left = 21
      Top = 22
      Width = 71
      Height = 16
      Caption = 'ServerName'
    end
    object lbTitleServUserName: TLabel
      Left = 20
      Top = 126
      Width = 82
      Height = 16
      Caption = 'Benutzername'
    end
    object lbTitlePW: TLabel
      Left = 21
      Top = 74
      Width = 52
      Height = 16
      Caption = 'Passwort'
    end
    object lbconn: TLabel
      Left = 17
      Top = 223
      Width = 200
      Height = 34
      AutoSize = False
      WordWrap = True
    end
    object etServName: TEdit
      Left = 20
      Top = 44
      Width = 157
      Height = 24
      TabOrder = 0
    end
    object etUserName: TEdit
      Left = 21
      Top = 150
      Width = 156
      Height = 24
      TabOrder = 2
    end
    object etUserPW: TEdit
      Left = 20
      Top = 96
      Width = 157
      Height = 24
      PasswordChar = '*'
      TabOrder = 1
    end
    object btConnect: TButton
      Left = 21
      Top = 192
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 3
      OnClick = btConnectClick
    end
    object btSaveConn: TButton
      Left = 110
      Top = 192
      Width = 107
      Height = 25
      Caption = 'Verb. Speichern'
      Enabled = False
      TabOrder = 4
      OnClick = btSaveConnClick
    end
  end
end
