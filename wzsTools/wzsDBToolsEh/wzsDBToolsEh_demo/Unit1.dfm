object Form1: TForm1
  Left = 293
  Top = 184
  Width = 736
  Height = 603
  VertScrollBar.ButtonSize = 10
  VertScrollBar.Smooth = True
  VertScrollBar.Size = 10
  VertScrollBar.Style = ssHotTrack
  VertScrollBar.ThumbSize = 10
  VertScrollBar.Tracking = True
  Caption = 'wzsDBToolsEh demo (DOA version)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 279
    Width = 728
    Height = 297
    Align = alBottom
    Caption = ' TwzsDBGrid (TDBGridEh) '
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentBackground = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      728
      297)
    object Label6: TLabel
      Left = 16
      Top = 272
      Width = 225
      Height = 13
      Caption = 'F8 - show filter/focus current column in filter row'
    end
    object Label7: TLabel
      Left = 256
      Top = 272
      Width = 66
      Height = 13
      Caption = 'F9 - clear filter'
    end
    object Label11: TLabel
      Left = 360
      Top = 272
      Width = 312
      Height = 13
      Caption = 
        'Operators like (>, <, >=, <=, <>) and masks (*) are accepted in ' +
        'filter'
    end
    object Panel1: TPanel
      Left = 1
      Top = 14
      Width = 726
      Height = 27
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object CheckBox3: TCheckBox
        Left = 16
        Top = 8
        Width = 97
        Height = 17
        Caption = 'dataset active'
        TabOrder = 0
        OnClick = CheckBox3Click
      end
      object CheckBox1: TCheckBox
        Left = 248
        Top = 8
        Width = 113
        Height = 17
        Caption = 'highlight columns'
        TabOrder = 1
        OnClick = CheckBox1Click
      end
      object CheckBox4: TCheckBox
        Left = 360
        Top = 8
        Width = 97
        Height = 17
        Caption = 'use default filter'
        TabOrder = 2
        OnClick = CheckBox4Click
      end
      object CheckBox5: TCheckBox
        Left = 464
        Top = 8
        Width = 97
        Height = 17
        Caption = 'filter lookup flds'
        TabOrder = 3
        OnClick = CheckBox5Click
      end
      object CheckBox6: TCheckBox
        Left = 576
        Top = 8
        Width = 121
        Height = 17
        Caption = 'filter fields value list'
        TabOrder = 4
        OnClick = CheckBox6Click
      end
    end
    object wzsDBGrid1: TwzsDBGrid
      Left = 16
      Top = 48
      Width = 697
      Height = 209
      Additional.ColumnsHighlight.ReadOnlyTitleFontColor = clGray
      Additional.ColumnsHighlight.ReadOnlyColFontColor = clWindowText
      Additional.ColumnsHighlight.ReadOnlyColColor = clWindow
      Additional.ColumnsHighlight.ReqTitleFontColor = clWindowText
      Additional.ColumnsHighlight.ReqColFontColor = clWindowText
      Additional.ColumnsHighlight.ReqColColor = clWindow
      Additional.ColumnsHighlight.NotReqTitleFontColor = 15496704
      Additional.ColumnsHighlight.NotReqColFontColor = clWindowText
      Additional.ColumnsHighlight.NotReqColColor = clWindow
      Additional.DefaultFilter = True
      Additional.FilterShortCut = 119
      Additional.ClearFilterShortCut = 120
      Additional.SearchShortCut = 114
      Additional.FilterLookupList = True
      Additional.Styler = wzsStyler1
      Anchors = [akLeft, akTop, akRight, akBottom]
      ColumnDefValues.HighlightRequired = True
      ColumnDefValues.Title.TitleButton = True
      ColumnDefValues.ToolTips = True
      Ctl3D = True
      DataSource = dsEmp
      Flat = True
      FooterColor = clWindow
      FooterFont.Charset = DEFAULT_CHARSET
      FooterFont.Color = clWindowText
      FooterFont.Height = -11
      FooterFont.Name = 'MS Sans Serif'
      FooterFont.Style = []
      Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      OptionsEh = [dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight, dghColumnResize, dghColumnMove]
      ParentCtl3D = False
      RowHeight = 16
      STFilter.Visible = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 728
    Height = 97
    Align = alTop
    Caption = ' Global style parameters '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Label8: TLabel
      Left = 224
      Top = 16
      Width = 52
      Height = 13
      Caption = 'frame color'
    end
    object Label9: TLabel
      Left = 352
      Top = 16
      Width = 41
      Height = 13
      Caption = 'hot color'
    end
    object Label10: TLabel
      Left = 480
      Top = 16
      Width = 78
      Height = 13
      Caption = 'frame inner color'
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 32
      Width = 193
      Height = 17
      Caption = 'controls are Flat and using Styler'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox2Click
    end
    object ColorBox1: TColorBox
      Left = 224
      Top = 32
      Width = 113
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Ctl3D = True
      ItemHeight = 16
      ParentCtl3D = False
      TabOrder = 1
      OnChange = ColorBox1Change
    end
    object ColorBox2: TColorBox
      Left = 352
      Top = 32
      Width = 113
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Ctl3D = True
      ItemHeight = 16
      ParentCtl3D = False
      TabOrder = 2
      OnChange = ColorBox2Change
    end
    object ColorBox3: TColorBox
      Left = 480
      Top = 32
      Width = 113
      Height = 22
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Ctl3D = True
      ItemHeight = 16
      ParentCtl3D = False
      TabOrder = 3
      OnChange = ColorBox3Change
    end
    object ComboBox1: TComboBox
      Left = 224
      Top = 64
      Width = 113
      Height = 21
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Ctl3D = True
      ItemHeight = 13
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 4
      Text = 'fsFlat'
      OnChange = ComboBox1Change
      Items.Strings = (
        'fsFlat'
        'fsFlatSmooth'
        'fsFlatRounded')
    end
    object CheckBox7: TCheckBox
      Left = 360
      Top = 64
      Width = 137
      Height = 17
      Caption = 'smooth frame corners'
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 5
      OnClick = CheckBox7Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 97
    Width = 728
    Height = 182
    Align = alClient
    Caption = ' Ehlib editors with styler assigned '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 61
      Height = 26
      Caption = 'TwzsDBEdit '#13'(TDBEditEh)'
    end
    object Label2: TLabel
      Left = 16
      Top = 88
      Width = 94
      Height = 26
      Caption = 'TwzsDBComboBox '#13'(TDBComboBoxEh)'
    end
    object Label3: TLabel
      Left = 208
      Top = 24
      Width = 104
      Height = 26
      Caption = 'TwzsDBDateTimeEdit'#13'TDBDateTimeEditEh'
    end
    object Label4: TLabel
      Left = 208
      Top = 88
      Width = 96
      Height = 26
      Caption = 'TwzsDBNumberEdit'#13'(TDBNumberEditEh)'
    end
    object Label5: TLabel
      Left = 392
      Top = 24
      Width = 127
      Height = 26
      Caption = 'TwzsDBLookupCombobox'#13'(TDBLookupComboboxEh)'
    end
    object wzsDBEdit1: TwzsDBEdit
      Left = 16
      Top = 56
      Width = 121
      Height = 19
      Additional.Styler = wzsStyler1
      Ctl3D = True
      DataField = 'JOB'
      DataSource = dsEmp
      EditButtons = <>
      Flat = True
      ParentCtl3D = False
      ShowHint = True
      TabOrder = 0
      Visible = True
    end
    object wzsDBComboBox1: TwzsDBComboBox
      Left = 16
      Top = 120
      Width = 121
      Height = 19
      Additional.Styler = wzsStyler1
      Ctl3D = True
      DataField = 'COMM'
      DataSource = dsEmp
      EditButtons = <>
      Flat = True
      ParentCtl3D = False
      ShowHint = True
      TabOrder = 1
      Visible = True
    end
    object wzsDBDateTimeEdit1: TwzsDBDateTimeEdit
      Left = 208
      Top = 56
      Width = 120
      Height = 19
      Additional.Styler = wzsStyler1
      Ctl3D = True
      DataField = 'HIREDATE'
      DataSource = dsEmp
      EditButtons = <
        item
        end>
      Flat = True
      Kind = dtkDateEh
      ParentCtl3D = False
      ShowHint = True
      TabOrder = 2
      Visible = True
    end
    object wzsDBNumberEdit1: TwzsDBNumberEdit
      Left = 208
      Top = 120
      Width = 121
      Height = 19
      Additional.Styler = wzsStyler1
      AlwaysShowBorder = True
      Ctl3D = True
      DataField = 'MGR'
      DataSource = dsEmp
      EditButtons = <>
      Flat = True
      ParentCtl3D = False
      ShowHint = True
      TabOrder = 3
      Visible = True
    end
    object wzsDBLookupCombobox1: TwzsDBLookupCombobox
      Left = 392
      Top = 56
      Width = 129
      Height = 19
      Additional.Styler = wzsStyler1
      Ctl3D = True
      DataField = 'lkDept'
      DataSource = dsEmp
      EditButtons = <>
      Flat = True
      ListField = 'dname'
      ParentCtl3D = False
      ShowHint = True
      TabOrder = 4
      Visible = True
    end
    object GroupBox4: TGroupBox
      Left = 384
      Top = 88
      Width = 185
      Height = 73
      Caption = '3rd level parent'
      TabOrder = 5
      object wzsDBEdit3: TwzsDBEdit
        Left = 24
        Top = 32
        Width = 121
        Height = 19
        Additional.Styler = wzsStyler1
        Ctl3D = True
        EditButtons = <>
        Flat = True
        ParentCtl3D = False
        ShowHint = True
        TabOrder = 0
        Text = 'wzsDBEdit3'
        Visible = True
      end
    end
  end
  object OracleSession1: TOracleSession
    LogonUsername = 'scott'
    LogonPassword = 'tiger'
    LogonDatabase = 'ORCL'
    Connected = True
    Left = 16
    Top = 512
  end
  object odsEmp: TOracleDataSet
    SQL.Strings = (
      'select a.*, a.rowid from scott.emp a'
      ''
      '')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      040000000800000005000000454D504E4F01000000000005000000454E414D45
      010000000000030000004A4F42010000000000030000004D4752010000000000
      0800000048495245444154450100000000000300000053414C01000000000004
      000000434F4D4D01000000000006000000444550544E4F010000000000}
    Session = OracleSession1
    Active = True
    FilterOptions = [foCaseInsensitive]
    AfterOpen = OracleDataSet1AfterOpen
    Left = 80
    Top = 512
    object odsEmpEMPNO: TIntegerField
      DisplayWidth = 10
      FieldName = 'EMPNO'
      Required = True
    end
    object odsEmpENAME: TStringField
      DisplayWidth = 10
      FieldName = 'ENAME'
      Size = 10
    end
    object odsEmpJOB: TStringField
      DisplayWidth = 9
      FieldName = 'JOB'
      Size = 9
    end
    object odsEmpMGR: TIntegerField
      DisplayWidth = 10
      FieldName = 'MGR'
    end
    object odsEmpHIREDATE: TDateTimeField
      DisplayWidth = 10
      FieldName = 'HIREDATE'
    end
    object odsEmpSAL: TFloatField
      DisplayWidth = 10
      FieldName = 'SAL'
    end
    object odsEmpCOMM: TFloatField
      DisplayWidth = 10
      FieldName = 'COMM'
    end
    object odsEmpDEPTNO: TIntegerField
      DisplayWidth = 10
      FieldName = 'DEPTNO'
    end
    object odsEmplkDept: TStringField
      DisplayLabel = 'DeptName lookup'
      DisplayWidth = 20
      FieldKind = fkLookup
      FieldName = 'lkDept'
      LookupDataSet = odsDept
      LookupKeyFields = 'DEPTNO'
      LookupResultField = 'DNAME'
      KeyFields = 'DEPTNO'
      Lookup = True
    end
  end
  object odsDept: TOracleDataSet
    SQL.Strings = (
      'select * from scott.dept')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      040000000300000006000000444550544E4F01000000000005000000444E414D
      45010000000000030000004C4F43010000000000}
    Session = OracleSession1
    Active = True
    Left = 176
    Top = 512
  end
  object dsEmp: TDataSource
    DataSet = odsEmp
    Left = 112
    Top = 512
  end
  object dsDept: TDataSource
    DataSet = odsDept
    Left = 208
    Top = 512
  end
  object wzsStyler1: TwzsStyler
    FrameStyle = fsFlatSmooth
    SmoothCorners = False
    Left = 656
    Top = 32
  end
end
