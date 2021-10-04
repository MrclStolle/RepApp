object FormSearchSerNr: TFormSearchSerNr
  Left = 549
  Top = 386
  Caption = 'Seriennummer-Suche'
  ClientHeight = 536
  ClientWidth = 423
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Padding.Left = 15
  Padding.Top = 15
  Padding.Right = 15
  Padding.Bottom = 15
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyPress = FormKeyPress
  DesignSize = (
    423
    536)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 15
    Top = 15
    Width = 393
    Height = 506
    Anchors = [akLeft, akTop, akRight, akBottom]
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      393
      506)
    object lbTitleSerNr: TLabel
      Left = 16
      Top = 16
      Width = 49
      Height = 16
      Caption = 'Suchfeld'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTitleResult: TLabel
      Left = 16
      Top = 76
      Width = 54
      Height = 16
      Caption = 'Ergebnis:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbDescription: TLabel
      Left = 16
      Top = 463
      Width = 361
      Height = 34
      AutoSize = False
      Caption = 'Doppelklick auf eine Seriennumer zeigt dessen Verlaufs-Historie.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object eSearchText: TEdit
      Left = 16
      Top = 38
      Width = 137
      Height = 24
      Hint = 'Zu suchende Seriennummer eingeben.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = eSearchTextChange
    end
    object lbxSerNrList: TListBox
      Left = 16
      Top = 98
      Width = 361
      Height = 351
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnDblClick = lbSerNrListDblClick
    end
  end
end
