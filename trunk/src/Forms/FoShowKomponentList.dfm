object FoCompList: TFoCompList
  Left = 0
  Top = 0
  Caption = 'Komponenten-Liste'
  ClientHeight = 386
  ClientWidth = 754
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    754
    386)
  PixelsPerInch = 96
  TextHeight = 13
  object ComponentGrid: TStringGrid
    Left = 8
    Top = 8
    Width = 738
    Height = 370
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 3
    FixedCols = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    ParentFont = False
    TabOrder = 0
    OnKeyPress = FormKeyPress
    ColWidths = (
      298
      117
      280)
  end
end
