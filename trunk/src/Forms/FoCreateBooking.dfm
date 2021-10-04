object FormCreateBooking: TFormCreateBooking
  Left = 500
  Top = 270
  Caption = 'Buchung Erstellen'
  ClientHeight = 791
  ClientWidth = 1126
  Color = clGradientInactiveCaption
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnCreate = FormCreate
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  DesignSize = (
    1126
    791)
  PixelsPerInch = 96
  TextHeight = 13
  object lbTitle: TLabel
    Left = 35
    Top = 23
    Width = 225
    Height = 25
    Caption = 'Neue Buchung Erstellen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 25
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lberror: TLabel
    Left = 344
    Top = 264
    Width = 286
    Height = 16
    Caption = 'Bei mind. einer Komponenten fehlt ein Wert!'
    Color = clMedGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object lbCompCount: TLabel
    Left = 398
    Top = 214
    Width = 26
    Height = 16
    BiDiMode = bdRightToLeft
    Caption = '0/50'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
  end
  object lbTitleErrorSerNr: TLabel
    Left = 49
    Top = 557
    Width = 209
    Height = 32
    Caption = 
      'Erstellung wurde nicht ausgef'#252'hrt: Seriennummer wurde nicht best' +
      #228'tigt'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object btAddOneGroup: TButton
    Left = 344
    Top = 233
    Width = 25
    Height = 25
    Hint = 'F'#252'gt ein weiteres Komponenten-Feld hinzu. '
    Caption = '+1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = btAddGroupsClick
  end
  object btRemoveOneGroup: TButton
    Left = 424
    Top = 233
    Width = 25
    Height = 25
    Hint = 'Entfernt die letzte eintragbare Komponente.'
    Caption = '-1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = btRemoveGroupsClick
  end
  object ScrollBox1: TScrollBox
    Left = 344
    Top = 286
    Width = 762
    Height = 484
    HorzScrollBar.Visible = False
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 10
  end
  object btAddFiveGroup: TButton
    Left = 375
    Top = 233
    Width = 25
    Height = 25
    Hint = 'F'#252'gt f'#252'nf weitere Kompoinenten-Felder hinzu. '
    Caption = '+5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btAddGroupsClick
  end
  object btRemoveFiveGroup: TButton
    Left = 455
    Top = 233
    Width = 25
    Height = 25
    Hint = 'Entfernt die letzten f'#252'nf eintragbaren Komponenten.'
    Caption = '-5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = btRemoveGroupsClick
  end
  object pnlSearchcomponent: TPanel
    Left = 344
    Top = 13
    Width = 762
    Height = 189
    Anchors = [akLeft, akTop, akRight]
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    ParentColor = True
    TabOrder = 4
    DesignSize = (
      762
      189)
    object lbTitleSearchComp: TLabel
      Left = 11
      Top = 11
      Width = 151
      Height = 21
      Caption = 'Komponentensucher'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTitleSearch: TLabel
      Left = 14
      Top = 37
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
      Left = 222
      Top = 19
      Width = 49
      Height = 16
      Caption = 'Ergebnis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btNewComponent: TButton
      Left = 14
      Top = 153
      Width = 137
      Height = 25
      Hint = #214'ffnet das Fenster zum Erstellen einer neuen Komponente.'
      Anchors = [akLeft, akBottom]
      Caption = 'Komponente erstellen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btNewComponentClick
    end
    object etSearchComp: TEdit
      Left = 12
      Top = 56
      Width = 185
      Height = 21
      Hint = 'Eingabefeld f'#252'r Komponentensucher.'
      TabOrder = 0
      OnChange = etSearchCompChange
    end
    object ListBox1: TListBox
      Left = 222
      Top = 41
      Width = 529
      Height = 137
      Hint = 
        'Auflistung aller '#228'hnlichen oder gleichen Komponenten wie im Eing' +
        'abefeld. Ein Doppelklick auf eine Komponente f'#252'gt Diese in das n' +
        #228'chste leere Komponenten-Feld ein.'
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnDblClick = ListBox1DblClick
    end
  end
  object btClearScrollbox: TButton
    Left = 506
    Top = 233
    Width = 73
    Height = 25
    Hint = 'Alle Komponenten-Felder entfernen.'
    Caption = 'Leeren'
    TabOrder = 9
    OnClick = btClearScrollboxClick
  end
  object Panel1: TPanel
    Left = 21
    Top = 59
    Width = 265
    Height = 414
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    AutoSize = True
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    ParentColor = True
    TabOrder = 0
    object lbcomment: TLabel
      Left = 19
      Top = 260
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
    object Image1: TImage
      Left = 18
      Top = 36
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
    end
    object lbTitlePackageID: TLabel
      Left = 18
      Top = 126
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
    object lbTitleBookType: TLabel
      Left = 18
      Top = 16
      Width = 80
      Height = 16
      Caption = 'Buchungs-Typ'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbTitleDate: TLabel
      Left = 18
      Top = 68
      Width = 37
      Height = 16
      Caption = 'Datum'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 19
      Top = 185
      Width = 70
      Height = 16
      Caption = 'Zeitaufwand'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 80
      Top = 212
      Width = 23
      Height = 16
      Caption = 'Std.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 189
      Top = 210
      Width = 24
      Height = 16
      Caption = 'Min.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbErrorNoDezimal: TLabel
      Left = 19
      Top = 237
      Width = 182
      Height = 16
      Caption = 'Nur Ganze Zahlen eintragen.'
      Color = clMedGray
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Visible = False
    end
    object cbTypeID: TComboBox
      Left = 49
      Top = 38
      Width = 186
      Height = 24
      Hint = 'Art der Buchung.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'cbTypeID'
      OnChange = cbTypeIDChange
    end
    object DateTimePicker1: TDateTimePicker
      Left = 16
      Top = 90
      Width = 186
      Height = 24
      Hint = 'Datum der Buchung.'
      Date = 44341.559955972230000000
      Time = 44341.559955972230000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object EdPackageID: TEdit
      Left = 16
      Top = 148
      Width = 185
      Height = 24
      Hint = 'Paket-ID oder Sendungsnummer. (optional)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object MeComment: TMemo
      Left = 16
      Top = 282
      Width = 233
      Height = 116
      Hint = 'Nennenswerte Informationen zu der/den Buchung/en.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'MeComment')
      MaxLength = 500
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object etHours: TEdit
      Left = 16
      Top = 207
      Width = 58
      Height = 24
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 4
      NumbersOnly = True
      ParentFont = False
      TabOrder = 3
      Text = '0'
      TextHint = 'Stunden'
      OnClick = etHoursClick
    end
    object etMinutes: TEdit
      Left = 125
      Top = 207
      Width = 58
      Height = 24
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 2
      NumbersOnly = True
      ParentFont = False
      TabOrder = 4
      Text = '0'
      TextHint = 'Minuten'
      OnClick = etHoursClick
    end
  end
  object btok: TButton
    Left = 63
    Top = 526
    Width = 75
    Height = 25
    Caption = 'Erstellen'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    OnClick = btokClick
  end
  object btAbort: TButton
    Left = 166
    Top = 526
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbrechen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
    OnClick = btAbortClick
  end
  object btServiceMail: TButton
    Left = 81
    Top = 484
    Width = 137
    Height = 25
    Hint = 'Erzeugt eine einfache Vorlage f'#252'r eine Service-Mail.'
    Caption = 'Vorlage Service-Mail'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btServiceMailClick
  end
  object pnlTaskMemo: TPanel
    Left = 35
    Top = 611
    Width = 251
    Height = 159
    Anchors = [akLeft, akTop, akBottom]
    ParentColor = True
    TabOrder = 11
    DesignSize = (
      251
      159)
    object lbTaskMemo: TLabel
      Left = 19
      Top = 7
      Width = 129
      Height = 16
      Caption = 'Auftragsbeschreibung:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object memTaskMemo: TMemo
      Left = 19
      Top = 29
      Width = 218
      Height = 113
      Hint = 'Nennenswerte Informationen zu der/den Buchung/en.'
      Anchors = [akLeft, akTop, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'MeComment')
      MaxLength = 500
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
