object FrameTaskHistory: TFrameTaskHistory
  Left = 0
  Top = 0
  Width = 1035
  Height = 114
  Constraints.MinWidth = 900
  Color = clRed
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  DesignSize = (
    1035
    114)
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1035
    Height = 114
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clGradientInactiveCaption
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      1035
      114)
    object lbaufwand: TLabel
      Left = 17
      Top = 83
      Width = 62
      Height = 18
      Caption = '-stunden-'
    end
    object lbdate: TLabel
      Left = 17
      Top = 11
      Width = 58
      Height = 18
      Caption = '-datum-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbName: TLabel
      Left = 17
      Top = 35
      Width = 73
      Height = 18
      Caption = '-MA name-'
    end
    object lbstatus: TLabel
      Left = 391
      Top = 16
      Width = 50
      Height = 18
      Caption = '-status-'
    end
    object lbTitelaufw: TLabel
      Left = 17
      Top = 63
      Width = 139
      Height = 18
      Caption = 'Gesamt-Zeitaufwand:'
    end
    object lbTitlestatus: TLabel
      Left = 308
      Top = 16
      Width = 46
      Height = 18
      Caption = 'Status:'
    end
    object lbTitleWareStatus: TLabel
      Left = 266
      Top = 47
      Width = 88
      Height = 18
      Caption = 'Warenstatus:'
    end
    object lbWareStatus: TLabel
      Left = 391
      Top = 47
      Width = 50
      Height = 18
      Caption = '-status-'
    end
    object lbTitleBillStatus: TLabel
      Left = 245
      Top = 78
      Width = 109
      Height = 18
      Caption = 'Rechnungstatus:'
    end
    object lbBillStatus: TLabel
      Left = 391
      Top = 78
      Width = 50
      Height = 18
      Caption = '-status-'
    end
    object imgTaskStatus: TImage
      Left = 360
      Top = 14
      Width = 25
      Height = 25
    end
    object imgWareStatus: TImage
      Left = 360
      Top = 45
      Width = 25
      Height = 25
    end
    object imgBillStatus: TImage
      Left = 360
      Top = 76
      Width = 25
      Height = 25
    end
    object meComment: TMemo
      Left = 616
      Top = 13
      Width = 389
      Height = 83
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      HideSelection = False
      Lines.Strings = (
        'meComment')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      OnKeyPress = meCommentKeyPress
    end
  end
end
