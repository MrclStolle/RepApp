object FormComponentEditor: TFormComponentEditor
  Left = 686
  Top = 231
  AutoSize = True
  Caption = 'Komponenten Editor'
  ClientHeight = 591
  ClientWidth = 714
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
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 26
    Top = 15
    Width = 311
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'Neue Komponente erstellen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 381
    Top = 15
    Width = 313
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'Komponente bearbeiten'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbTitleMerge: TLabel
    Left = 26
    Top = 296
    Width = 309
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'Komponenten verschmelzen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbTitleMergeSerNr: TLabel
    Left = 381
    Top = 296
    Width = 313
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = 'Seriennummern verschmelzen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 15
    Top = 40
    Width = 327
    Height = 233
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 19
      Top = 14
      Width = 109
      Height = 16
      Caption = 'Name/Bezeichnung'
    end
    object lbMissName: TLabel
      Left = 134
      Top = 14
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
    object lbCrCompMessage: TLabel
      Left = 26
      Top = 181
      Width = 272
      Height = 33
      Alignment = taCenter
      AutoSize = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 17
      Top = 98
      Width = 137
      Height = 16
      Caption = 'TWI-Nummer (optional)'
    end
    object BTOK: TButton
      Left = 26
      Top = 150
      Width = 75
      Height = 25
      Caption = 'Erstellen!'
      TabOrder = 2
      OnClick = BTClickOK
    end
    object chbCrCompSerNr: TCheckBox
      Left = 26
      Top = 63
      Width = 150
      Height = 17
      Hint = 
        'Wenn markiert, wird f'#252'r dieses Teil immer eine Seriennummer abge' +
        'fragt und dessen Mengenangabe immer auf 1 gesetzt.'
      Caption = 'Nur mit Seriennummer'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object etCrComp: TEdit
      Left = 17
      Top = 36
      Width = 285
      Height = 24
      TabOrder = 0
      OnChange = etCrCompChange
    end
    object eTWINr: TEdit
      Left = 17
      Top = 120
      Width = 176
      Height = 24
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 15
    Top = 321
    Width = 327
    Height = 215
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    ParentFont = False
    TabOrder = 2
    object imgArrow: TImage
      Left = 138
      Top = 50
      Width = 50
      Height = 50
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000320000
        003208060000001E3F88B1000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
        594944415478DAEDD78B0D82301006E0B2870C027BC01E3088EEA17BC020BA07
        B6499B9CC8A3EDDD1988FF250D04E4F195F6AE16463F3ABFBD693EA4504634B6
        DDFD7E6BDBE38C90CAB66176ACB66D3C13E462DBD3EF872115865869DBEB0C10
        8718FDD60DA5D61F7743ACF1884A1AA30119FC8B3A4C9D70EE5010DAEBE5C279
        FAB544319290AB899B0714E3E64F7F2448E7212E623213CD68BD11A83112108A
        48A915B4C6B0315C08B76753BFA40A842238633D766EA940D66A456EB06B4C2E
        44A31E847BAEA56E7108EB813BE196355935261512C6B3CA32C3306A4C0A844E
        4AB555ACC94C22B110B1349981894AEB3110D1C29510499DB70791AA15B9113D
        9CB7202A8B3B066633C16C41B253A142ECA6FC62E7C22320426C76EC12242C17
        6243EAAFC094F0DBAF65D1FC25E8E43A32C4C5C7BCE5BCC424700FB1FB010208
        208000020820800002082080000208208000F22B8874FC37E40D879A8E331645
        D2720000000049454E44AE426082}
    end
    object lbMergCompMessage: TLabel
      Left = 26
      Top = 167
      Width = 265
      Height = 33
      Alignment = taCenter
      AutoSize = False
      WordWrap = True
    end
    object cbSource: TComboBox
      Left = 26
      Top = 20
      Width = 283
      Height = 24
      Hint = 'Zielkomponente der Verschmelzung.'
      Sorted = True
      TabOrder = 0
      OnChange = cbSourceChange
    end
    object cbMat: TComboBox
      Left = 26
      Top = 103
      Width = 283
      Height = 24
      Hint = 'Zu '#228'ndernde Komponente.'
      Sorted = True
      TabOrder = 1
      OnChange = cbSourceChange
    end
    object btMerge: TButton
      Left = 114
      Top = 136
      Width = 99
      Height = 25
      Caption = 'Verschmelzen!'
      Enabled = False
      TabOrder = 2
      OnClick = btMergeClick
    end
  end
  object BTAbort: TButton
    Left = 609
    Top = 551
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Schlie'#223'en'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = BTClickAbort
  end
  object Panel3: TPanel
    Left = 372
    Top = 40
    Width = 327
    Height = 233
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    ParentFont = False
    TabOrder = 1
    object Label3: TLabel
      Left = 17
      Top = 74
      Width = 147
      Height = 16
      Caption = 'Neuer Name/Bezeichnung'
    end
    object lbEditMissName: TLabel
      Left = 179
      Top = 74
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
    object lbEdCompMessage: TLabel
      Left = 26
      Top = 181
      Width = 283
      Height = 33
      Alignment = taCenter
      AutoSize = False
      WordWrap = True
    end
    object Label6: TLabel
      Left = 19
      Top = 14
      Width = 109
      Height = 16
      Caption = 'Name/Bezeichnung'
    end
    object btEditComp: TButton
      Left = 26
      Top = 150
      Width = 75
      Height = 25
      Caption = #196'ndern!'
      TabOrder = 3
      OnClick = btEditCompClick
    end
    object ChbEditCompSerNr: TCheckBox
      Left = 26
      Top = 126
      Width = 150
      Height = 17
      Hint = 
        'Wenn markiert, wird f'#252'r dieses Teil immer eine Seriennummer abge' +
        'fragt und dessen Mengenangabe immer auf 1 gesetzt.'
      Caption = 'Nur mit Seriennummer'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object etEditCompName: TEdit
      Left = 15
      Top = 96
      Width = 283
      Height = 24
      TabOrder = 1
      OnChange = etEditCompNameChange
    end
    object cbEditComp: TComboBox
      Left = 15
      Top = 36
      Width = 283
      Height = 24
      Sorted = True
      TabOrder = 0
      OnChange = cbEditCompChange
    end
  end
  object Button1: TButton
    Left = 41
    Top = 548
    Width = 130
    Height = 25
    Caption = 'Komponenten-Liste'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button1Click
  end
  object Panel4: TPanel
    Left = 372
    Top = 321
    Width = 327
    Height = 215
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    ParentFont = False
    TabOrder = 5
    object Image1: TImage
      Left = 134
      Top = 50
      Width = 50
      Height = 50
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000320000
        003208060000001E3F88B1000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
        594944415478DAEDD78B0D82301006E0B2870C027BC01E3088EEA17BC020BA07
        B6499B9CC8A3EDDD1988FF250D04E4F195F6AE16463F3ABFBD693EA4504634B6
        DDFD7E6BDBE38C90CAB66176ACB66D3C13E462DBD3EF872115865869DBEB0C10
        8718FDD60DA5D61F7743ACF1884A1AA30119FC8B3A4C9D70EE5010DAEBE5C279
        FAB544319290AB899B0714E3E64F7F2448E7212E623213CD68BD11A83112108A
        48A915B4C6B0315C08B76753BFA40A842238633D766EA940D66A456EB06B4C2E
        44A31E847BAEA56E7108EB813BE196355935261512C6B3CA32C3306A4C0A844E
        4AB555ACC94C22B110B1349981894AEB3110D1C29510499DB70791AA15B9113D
        9CB7202A8B3B066633C16C41B253A142ECA6FC62E7C22320426C76EC12242C17
        6243EAAFC094F0DBAF65D1FC25E8E43A32C4C5C7BCE5BCC424700FB1FB010208
        208000020820800002082080000208208000F22B8874FC37E40D879A8E331645
        D2720000000049454E44AE426082}
    end
    object lbMergeSerNrMessage: TLabel
      Left = 32
      Top = 167
      Width = 265
      Height = 33
      Alignment = taCenter
      AutoSize = False
      WordWrap = True
    end
    object cbSerNrSource: TComboBox
      Left = 22
      Top = 20
      Width = 283
      Height = 24
      Hint = 'Zielkomponente der Verschmelzung.'
      Sorted = True
      TabOrder = 0
      OnChange = cbSerNrSourceChange
    end
    object cbSerNrMat: TComboBox
      Left = 22
      Top = 103
      Width = 283
      Height = 24
      Hint = 'Zu '#228'ndernde Komponente.'
      Sorted = True
      TabOrder = 1
      OnChange = cbSerNrSourceChange
    end
    object btMergeSerNr: TButton
      Left = 110
      Top = 136
      Width = 99
      Height = 25
      Caption = 'Verschmelzen!'
      Enabled = False
      TabOrder = 2
      OnClick = btMergeSerNrClick
    end
  end
  object btInfoMerge: TPanel
    Left = 299
    Top = 298
    Width = 25
    Height = 17
    Cursor = crHandPoint
    Hint = 
      'Das Mergen(Verschmelzen) dient dem sicheren Bereinigen der Daten' +
      'bank bei doppelt eingetragene Komponenten.  Hierbei nimmt das un' +
      'tere Teil die Eigeschaften des Obenren an und wird anschlie'#223'end ' +
      'gel'#246'scht.'
    Caption = 'i'
    Color = clMenuHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = 18
    Font.Name = 'Corbel'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    TabStop = True
    OnClick = btInfoMergeClick
    OnMouseDown = btInfoMergeSerNrMouseDown
    OnMouseUp = btInfoMergeSerNrMouseUp
  end
  object btInfoMergeSerNr: TPanel
    Left = 652
    Top = 299
    Width = 25
    Height = 17
    Cursor = crHandPoint
    Hint = 
      'Das Mergen(Verschmelzen) dient dem sicheren Bereinigen der Daten' +
      'bank bei doppelt eingetragenen Serien-Nummern. Hierbei nimmt das' +
      ' untere Teil die Eigeschaften des Obenren an und wird anschlie'#223'e' +
      'nd gel'#246'scht.'
    Caption = 'i'
    Color = clMenuHighlight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = 18
    Font.Name = 'Corbel'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    TabStop = True
    OnClick = btInfoMergeSerNrClick
    OnMouseDown = btInfoMergeSerNrMouseDown
    OnMouseUp = btInfoMergeSerNrMouseUp
  end
end
