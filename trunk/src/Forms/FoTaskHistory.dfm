object FormTaskHistory: TFormTaskHistory
  Left = 700
  Top = 395
  Caption = 'Auftragsverlauf ID: '
  ClientHeight = 361
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object lbNoHistory: TLabel
    Left = 100
    Top = 25
    Width = 162
    Height = 18
    Caption = 'Keine Historie Vorhanden'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ScrollBoxHistory: TScrollBox
    Left = 0
    Top = 0
    Width = 971
    Height = 361
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Align = alClient
    Color = clMedGray
    ParentColor = False
    TabOrder = 0
  end
end
