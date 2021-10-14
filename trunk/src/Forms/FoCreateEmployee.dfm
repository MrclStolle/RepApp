object FormCreateEmployee: TFormCreateEmployee
  Left = 760
  Top = 478
  AutoSize = True
  BorderStyle = bsSingle
  Caption = 'Mitarbeiter Editor'
  ClientHeight = 386
  ClientWidth = 637
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
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object btClose: TButton
    Left = 213
    Top = 346
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Schlie'#223'en'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btCloseClick
  end
  object pnlNewEmployee: TPanel
    Left = 308
    Top = 15
    Width = 314
    Height = 323
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    TabOrder = 1
    object lbTitleInitHint: TLabel
      Left = 149
      Top = 132
      Width = 148
      Height = 16
      Caption = 'Zwischen 2 und 4 Zeichen'
    end
    object lbTitleName: TLabel
      Left = 22
      Top = 61
      Width = 114
      Height = 16
      Caption = 'Vor- und Nachname'
    end
    object lbTitleInit: TLabel
      Left = 22
      Top = 110
      Width = 177
      Height = 16
      Caption = 'Initialien(generiert, anpassbar)'
    end
    object lbTitleNewEmplPW: TLabel
      Left = 22
      Top = 168
      Width = 52
      Height = 16
      Caption = 'Passwort'
    end
    object lbTitleNewEmplPW2: TLabel
      Left = 22
      Top = 217
      Width = 115
      Height = 16
      Caption = 'Passwort best'#228'tigen'
    end
    object lbTitleNewEmployee: TLabel
      Left = 22
      Top = 16
      Width = 176
      Height = 28
      Caption = 'Neuer Mitarbeiter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbMissName: TLabel
      Left = 22
      Top = 263
      Width = 4
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btCreate: TButton
      Left = 22
      Top = 282
      Width = 75
      Height = 25
      Caption = 'Erstellen'
      TabOrder = 5
      OnClick = btCreateClick
    end
    object eName: TEdit
      Left = 22
      Top = 80
      Width = 163
      Height = 24
      TabOrder = 0
      OnChange = eNameChange
    end
    object eShort: TEdit
      Left = 22
      Top = 129
      Width = 121
      Height = 24
      Hint = 
        'Initialien des Mitarbeiters. (Vorschlag entspricht jeweils dem e' +
        'rsten Buchstaben des Vor- und Nachnamen)'
      TabOrder = 2
    end
    object etPW: TEdit
      Left = 22
      Top = 187
      Width = 121
      Height = 24
      PasswordChar = '*'
      TabOrder = 3
      TextHint = 'Passwort'
    end
    object etPWcheck: TEdit
      Left = 22
      Top = 236
      Width = 121
      Height = 24
      PasswordChar = '*'
      TabOrder = 4
      TextHint = 'Passwort'
      OnKeyPress = etPWcheckKeyPress
    end
    object chbAdmin: TCheckBox
      Left = 200
      Top = 84
      Width = 97
      Height = 17
      Caption = 'Admin'
      TabOrder = 1
    end
  end
  object pnlChangePW: TPanel
    Left = 15
    Top = 15
    Width = 273
    Height = 323
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = True
    ParentFont = False
    TabOrder = 0
    object Label7: TLabel
      Left = 22
      Top = 16
      Width = 173
      Height = 28
      Caption = 'Password '#228'ndern'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 22
      Top = 162
      Width = 90
      Height = 16
      Caption = 'neues Passwort'
    end
    object Label9: TLabel
      Left = 22
      Top = 214
      Width = 153
      Height = 16
      Caption = 'neues Passwort best'#228'tigen'
    end
    object Label10: TLabel
      Left = 22
      Top = 110
      Width = 83
      Height = 16
      Caption = 'altes Passwort'
    end
    object Label11: TLabel
      Left = 22
      Top = 58
      Width = 103
      Height = 16
      Caption = 'aktueller Benutzer'
    end
    object lbPWError: TLabel
      Left = 22
      Top = 264
      Width = 4
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object etPwNew: TEdit
      Left = 22
      Top = 184
      Width = 121
      Height = 24
      PasswordChar = '*'
      TabOrder = 2
      TextHint = 'Passwort'
    end
    object etPwNewCheck: TEdit
      Left = 22
      Top = 236
      Width = 121
      Height = 24
      PasswordChar = '*'
      TabOrder = 3
      TextHint = 'Passwort'
      OnKeyPress = etPwNewCheckKeyPress
    end
    object etPwOld: TEdit
      Left = 23
      Top = 132
      Width = 121
      Height = 24
      PasswordChar = '*'
      TabOrder = 1
      TextHint = 'Passwort'
    end
    object btChangePW: TButton
      Left = 22
      Top = 282
      Width = 75
      Height = 25
      Caption = 'Best'#228'tigen'
      TabOrder = 4
      OnClick = btChangePWClick
    end
    object etName2: TEdit
      Left = 24
      Top = 80
      Width = 151
      Height = 24
      Hint = 'Name des aktuellen Nutzers.'
      Enabled = False
      TabOrder = 0
    end
  end
end
