object FrameBooking: TFrameBooking
  Left = 0
  Top = 0
  Width = 503
  Height = 27
  ParentBackground = False
  TabOrder = 0
  object pnlBooking: TPanel
    Left = 3
    Top = 1
    Width = 496
    Height = 26
    Cursor = crHandPoint
    ParentColor = True
    TabOrder = 0
    OnClick = PanelClick
    object img: TImage
      Left = 0
      Top = 0
      Width = 25
      Height = 25
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
        00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC200000EC20115284A80000000
        764944415478DA63FC0F040C34068C204BDEC9AAD2CC02A1C7B787B32520414A
        01BA790367098C4FAE85582DC1A68812CB48B204179F644BDECAA860CD8CE886
        92E22BA27C428C01F82CA3D812622CA39A25C806E20ADAC1ED13B2E264C05217
        D5F309DD723C5DCAAEE159D4531B0C434B686603140000242AEDB65C04F14000
        00000049454E44AE426082}
      Proportional = True
      OnClick = PanelClick
    end
    object lbBType: TLabel
      Left = 29
      Top = 2
      Width = 22
      Height = 18
      Caption = 'WE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = PanelClick
    end
    object lbCompCountAndName: TLabel
      Left = 65
      Top = 2
      Width = 117
      Height = 18
      Caption = 'mmmmmmmmm'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = PanelClick
    end
    object lbDate: TLabel
      Left = 350
      Top = 2
      Width = 74
      Height = 18
      Caption = '23.05.2021'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = PanelClick
    end
    object lbMAName: TLabel
      Left = 444
      Top = 2
      Width = 43
      Height = 18
      Caption = '<MA>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = PanelClick
    end
    object lbSerialNr: TLabel
      Left = 199
      Top = 3
      Width = 103
      Height = 18
      Caption = 'SN:xxxxxxxxxx'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
      OnClick = PanelClick
    end
  end
end
