object FormTemplateServMail: TFormTemplateServMail
  Left = 0
  Top = 0
  Caption = 'Vorlage Service Mail'
  ClientHeight = 438
  ClientWidth = 775
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  DesignSize = (
    775
    438)
  PixelsPerInch = 96
  TextHeight = 13
  object lbBetreff: TLabel
    Left = 32
    Top = 16
    Width = 45
    Height = 18
    Caption = 'Betreff'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbBody: TLabel
    Left = 32
    Top = 88
    Width = 31
    Height = 18
    Caption = 'Text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object etBetreff: TEdit
    Left = 32
    Top = 40
    Width = 714
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnKeyPress = FormKeyPress
    ExplicitWidth = 481
  end
  object MemBody: TMemo
    Left = 32
    Top = 112
    Width = 714
    Height = 305
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'MemBody')
    ParentFont = False
    TabOrder = 1
    OnKeyPress = FormKeyPress
    ExplicitWidth = 481
  end
end
