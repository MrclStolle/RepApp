object FormTransfer: TFormTransfer
  Left = 0
  Top = 0
  Caption = 'FormTransfer'
  ClientHeight = 575
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    635
    575)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 384
    Top = 425
    Width = 101
    Height = 13
    Caption = 'number of customers'
  end
  object Label2: TLabel
    Left = 384
    Top = 444
    Width = 110
    Height = 13
    Caption = 'number of components'
  end
  object ProgressBar1: TProgressBar
    Left = 368
    Top = 393
    Width = 150
    Height = 17
    TabOrder = 0
  end
  object Button1: TButton
    Left = 200
    Top = 393
    Width = 113
    Height = 25
    Caption = 'Insert Values to DB'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 393
    Width = 129
    Height = 25
    Caption = 'Read Values from Excel'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 619
    Height = 163
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 16
    Top = 209
    Width = 611
    Height = 163
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object Button3: TButton
    Left = 16
    Top = 432
    Width = 297
    Height = 25
    Caption = 'Clean Values in table '#39'teile_copy_copy'#39' to Table '#39'teile_copy'#39
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 463
    Width = 297
    Height = 25
    Caption = 'Clean and update db values '#39'Teile_Imported'#39
    TabOrder = 6
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 200
    Top = 528
    Width = 113
    Height = 25
    Caption = 'read Teile table'
    TabOrder = 7
    OnClick = Button5Click
  end
end
