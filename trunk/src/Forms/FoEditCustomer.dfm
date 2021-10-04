object FormEditCustomer: TFormEditCustomer
  Left = 0
  Top = 0
  Caption = 'xxx bearbeiten'
  ClientHeight = 327
  ClientWidth = 377
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 25
  Padding.Top = 25
  Padding.Right = 25
  Padding.Bottom = 25
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object lbTitle: TLabel
    Left = 33
    Top = 22
    Width = 167
    Height = 25
    Caption = 'Kunde Bearbeiten'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 25
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btOK: TButton
    Left = 39
    Top = 270
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
    OnClick = btOKClick
  end
  object btAbort: TButton
    Left = 143
    Top = 270
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
    OnClick = btAbortClick
  end
  object pnl: TPanel
    Left = 28
    Top = 53
    Width = 324
    Height = 195
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    TabOrder = 0
    object lbName: TLabel
      Left = 11
      Top = 67
      Width = 141
      Height = 16
      Caption = 'Neuer Name des Kunden'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbMissName: TLabel
      Left = 63
      Top = 10
      Width = 179
      Height = 16
      Caption = 'Dieser Kunde existiert nicht'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Label1: TLabel
      Left = 11
      Top = 10
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
    object ETName: TEdit
      Left = 11
      Top = 89
      Width = 270
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TextHint = 'Name'
    end
    object chbService: TCheckBox
      Left = 11
      Top = 129
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
    object chbDeclineBookings: TCheckBox
      Left = 11
      Top = 161
      Width = 201
      Height = 17
      Hint = 
        'Kunde sol aufgrund von Zahlungsr'#252'ckst'#228'nden nicht beliefert werde' +
        'n.'
      Caption = 'Zahlungsr'#252'ckstand, nicht Liefern'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object cbChooseCustomer: TComboBox
    Left = 39
    Top = 82
    Width = 290
    Height = 24
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = 'cbChooseCustomer'
    OnChange = cbChooseCustomerChange
  end
end
