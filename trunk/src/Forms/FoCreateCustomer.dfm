object FormCreateCustomer: TFormCreateCustomer
  Left = 0
  Top = 0
  Caption = 'Kunden Erstellen'
  ClientHeight = 250
  ClientWidth = 391
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object lbTitle: TLabel
    Left = 32
    Top = 24
    Width = 225
    Height = 25
    Caption = 'Neuen Kunden Erstellen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 25
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object BTOK: TButton
    Left = 48
    Top = 190
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
    TabOrder = 1
    OnClick = BTClickOK
  end
  object BTAbort: TButton
    Left = 144
    Top = 192
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
    TabOrder = 2
    OnClick = BTClickAbort
  end
  object Panel1: TPanel
    Left = 33
    Top = 66
    Width = 312
    Height = 105
    ParentColor = True
    TabOrder = 0
    object lbMissName: TLabel
      Left = 142
      Top = 18
      Width = 101
      Height = 16
      Caption = 'Der Name fehlt!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object lbName: TLabel
      Left = 15
      Top = 18
      Width = 103
      Height = 16
      Caption = 'Name des Kunden'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ETName: TEdit
      Left = 15
      Top = 40
      Width = 225
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TextHint = 'Name'
      OnKeyPress = ETNameKeyPress
    end
    object CBService: TCheckBox
      Left = 21
      Top = 78
      Width = 97
      Height = 17
      Caption = 'Full Service'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
end
