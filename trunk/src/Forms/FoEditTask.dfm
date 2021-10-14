object FormEditTask: TFormEditTask
  Left = 549
  Top = 309
  AutoSize = True
  Caption = 'Auftrag ID: '
  ClientHeight = 497
  ClientWidth = 407
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
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lbTitle: TLabel
    Left = 32
    Top = 15
    Width = 178
    Height = 25
    Caption = 'Auftrag Bearbeiten'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 25
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btOK: TButton
    Left = 32
    Top = 457
    Width = 81
    Height = 25
    Caption = 'Best'#228'tigen'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btOKClick
  end
  object btAbort: TButton
    Left = 136
    Top = 457
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btAbortClick
  end
  object Panel1: TPanel
    Left = 15
    Top = 54
    Width = 377
    Height = 389
    AutoSize = True
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    TabOrder = 2
    object lbTitleComment: TLabel
      Left = 17
      Top = 247
      Width = 147
      Height = 16
      Caption = 'Beschreibung/Kommentar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbCustomerName: TLabel
      Left = 17
      Top = 34
      Width = 297
      Height = 38
      AutoSize = False
      Caption = '-Name des Kunden-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object lbTitleTaskStatus: TLabel
      Left = 17
      Top = 82
      Width = 89
      Height = 16
      Caption = 'Auftrags-Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTitleBillStatus: TLabel
      Left = 17
      Top = 134
      Width = 103
      Height = 16
      Caption = 'Rechnungs-Status'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
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
    object eTimeConsumption: TLabel
      Left = 16
      Top = 219
      Width = 90
      Height = 17
      Hint = 'Bisheriger gesamter Aufwand zum Auftrag in Stunden (z.B 1,5)'
      Caption = 'xxx h xxx min'
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lbTitleTime: TLabel
      Left = 17
      Top = 197
      Width = 162
      Height = 16
      Caption = 'Gesamtaufwand in Stunden:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object cbStatus: TComboBox
      Left = 17
      Top = 104
      Width = 216
      Height = 24
      Hint = 'Status des Auftrags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object memBeschreibung: TMemo
      Left = 16
      Top = 269
      Width = 345
      Height = 104
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
    end
    object cbBillStatus: TComboBox
      Left = 17
      Top = 156
      Width = 216
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
end
