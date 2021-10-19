object FormCreateTask: TFormCreateTask
  Left = 0
  Top = 0
  AutoSize = True
  Caption = 'Auftrag Erstellen'
  ClientHeight = 509
  ClientWidth = 345
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 20
  Padding.Top = 20
  Padding.Right = 20
  Padding.Bottom = 20
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object lbTitle: TLabel
    Left = 36
    Top = 20
    Width = 224
    Height = 25
    Caption = 'Neuen Auftrag Erstellen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 25
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbErrorNoBooking: TLabel
    Left = 23
    Top = 450
    Width = 202
    Height = 39
    AutoSize = False
    Caption = 'Kunde hat offene Rechnungen Neue Buchungen deaktiviert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object btCreateCustomer: TButton
    Left = 234
    Top = 378
    Width = 89
    Height = 25
    Hint = 'Neuen Kunden anlegen'
    Caption = 'Neuer Kunde'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = btCreateCustomerClick
  end
  object Panel1: TPanel
    Left = 20
    Top = 59
    Width = 305
    Height = 313
    AutoSize = True
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    TabOrder = 1
    object lbTitleComment: TLabel
      Left = 17
      Top = 162
      Width = 200
      Height = 16
      Caption = 'Auftrags-Beschreibung/Kommentar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTitleCustomer: TLabel
      Left = 17
      Top = 16
      Width = 35
      Height = 16
      Caption = 'Kunde'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbNoCustomer: TLabel
      Left = 79
      Top = 16
      Width = 151
      Height = 16
      Caption = 'Keinen Kunden gew'#228'hlt'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Label1: TLabel
      Left = 17
      Top = 81
      Width = 83
      Height = 16
      Caption = 'Rechnungsart:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbCharError: TLabel
      Left = 17
      Top = 142
      Width = 140
      Height = 19
      Caption = #39' und " nicht verwendbar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object cbCustomerChoise: TComboBox
      Left = 16
      Top = 38
      Width = 273
      Height = 24
      Hint = 'Name des Kunden'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'cbCustomerChoise'
      OnChange = cbCustomerChoiseChange
    end
    object memBeschreibung: TMemo
      Left = 16
      Top = 184
      Width = 273
      Height = 113
      Hint = 'Nennenswerte Informationen zum Auftrag.'
      BiDiMode = bdLeftToRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'Kommentar')
      MaxLength = 500
      ParentBiDiMode = False
      ParentFont = False
      ParentShowHint = False
      ScrollBars = ssVertical
      ShowHint = False
      TabOrder = 1
      OnKeyPress = memBeschreibungKeyPress
    end
    object cbBillStatus: TComboBox
      Left = 16
      Top = 103
      Width = 224
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'cbBillStatus'
    end
  end
  object btCreateTaskWBooking: TButton
    Left = 23
    Top = 378
    Width = 148
    Height = 25
    Hint = 'Diesem Auftrag direkt eine Buchung hinzuf'#252'gen.'
    Caption = 'Erstellen mit Buchung'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = btCreateTaskWBookingClick
  end
  object btCreateTask: TButton
    Left = 23
    Top = 419
    Width = 148
    Height = 25
    Hint = 'Auftrag wird sofort erstellt. R'#252'ckkehr zum Hauptfenster.'
    Caption = 'Erstellen ohne Buchung'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btCreateTaskClick
  end
  object btAbort: TButton
    Left = 234
    Top = 419
    Width = 89
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 4
    OnClick = btAbortClick
  end
end
