object ShowBooking: TShowBooking
  Left = 740
  Top = 415
  Caption = 'Buchung'
  ClientHeight = 338
  ClientWidth = 574
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
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object lbBookingType: TLabel
    Left = 49
    Top = 23
    Width = 79
    Height = 21
    Caption = '-booktype-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbDate: TLabel
    Left = 21
    Top = 72
    Width = 39
    Height = 18
    Caption = '-date-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbMAName: TLabel
    Left = 133
    Top = 72
    Width = 70
    Height = 18
    Caption = '-maName-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Img: TImage
    Left = 18
    Top = 22
    Width = 25
    Height = 25
    Picture.Data = {
      0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
      00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
      0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
      724944415478DA6364A003600411FF81E09DACEAA825E45922F4F836C506239B
      37B096C0F8E45A88D5126C8A28B18C244B70F149B6E4AD8CCA7F6C0AD10D25C5
      5744F9841803F05946B125C45846354B900DC415B483DB2764C5C980A52EAAE7
      13BAE578BA945DC3B3A8A736186696D01A000092DFBC0EFFE7044A0000000049
      454E44AE426082}
  end
  object btClose: TButton
    Left = 478
    Top = 294
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Schlie'#223'en'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
    OnClick = btCloseClick
  end
  object pnl: TPanel
    Left = 18
    Top = 96
    Width = 535
    Height = 192
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    TabOrder = 0
    object lbTitlePackageID: TLabel
      Left = 283
      Top = 11
      Width = 157
      Height = 16
      Caption = 'Paket-ID/Sendungsnummer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbComment: TLabel
      Left = 283
      Top = 67
      Width = 66
      Height = 16
      Caption = 'Kommentar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbCompNameTitle: TLabel
      Left = 11
      Top = 11
      Width = 76
      Height = 16
      Caption = 'Bezeichnung:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTitleCompCount: TLabel
      Left = 11
      Top = 75
      Width = 43
      Height = 16
      Caption = 'Menge:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbSerialNr: TLabel
      Left = 11
      Top = 130
      Width = 90
      Height = 16
      Caption = 'Seriennummer:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbCompName: TLabel
      Left = 11
      Top = 27
      Width = 225
      Height = 42
      AutoSize = False
      Caption = ' m mmmmmmmmmm  mmmmmm mmmmmm mmmmmmmmmm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lbCompCount: TLabel
      Left = 11
      Top = 97
      Width = 24
      Height = 18
      Caption = '___'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object etPackageID: TEdit
      Left = 283
      Top = 33
      Width = 150
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object meComment: TMemo
      Left = 283
      Top = 86
      Width = 238
      Height = 95
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'meComment')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 3
      OnKeyPress = meCommentKeyPress
    end
    object etSerialNr: TEdit
      Left = 11
      Top = 150
      Width = 129
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object btHistory: TButton
      Left = 155
      Top = 149
      Width = 81
      Height = 25
      Hint = 'Ruft die Historie der Seriennummer auf.'
      Caption = '<- Historie'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btHistoryClick
    end
  end
  object Panel1: TPanel
    Left = 226
    Top = 10
    Width = 125
    Height = 52
    AutoSize = True
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    ParentColor = True
    TabOrder = 2
    object rbOneWayNO: TRadioButton
      Left = 6
      Top = 6
      Width = 113
      Height = 17
      Caption = 'mit R'#252'ckbuchung'
      TabOrder = 0
      OnClick = rbOneWayNOClick
    end
    object rbOneWayYes: TRadioButton
      Left = 6
      Top = 29
      Width = 113
      Height = 17
      Caption = 'ohne R'#252'ckbuchung'
      TabOrder = 1
      OnClick = rbOneWayNOClick
    end
  end
  object btAcceptChange: TButton
    Left = 403
    Top = 23
    Width = 153
    Height = 25
    Caption = #196'nderung '#220'bernehmen'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 3
    OnClick = btAcceptChangeClick
  end
  object btDeleteBooking: TBitBtn
    Left = 18
    Top = 295
    Width = 87
    Height = 25
    Caption = 'L'#246'schen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentDoubleBuffered = True
    ParentFont = False
    TabOrder = 4
    OnClick = btDeleteBookingClick
  end
end
