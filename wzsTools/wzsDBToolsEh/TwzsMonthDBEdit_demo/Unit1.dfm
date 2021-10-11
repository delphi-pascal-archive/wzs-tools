object Form1: TForm1
  Left = 362
  Top = 347
  Width = 387
  Height = 180
  Caption = 'TwzsMonthDBEdit demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object MonthCalendar1: TMonthCalendar
    Left = 216
    Top = 8
    Width = 155
    Height = 136
    AutoSize = True
    Date = 40119.992009618060000000
    ShowToday = False
    ShowTodayCircle = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 176
    Top = 8
    Width = 33
    Height = 25
    Caption = '<'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 40
    Width = 33
    Height = 25
    Caption = '>'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 176
    Top = 72
    Width = 33
    Height = 25
    Caption = 'null'
    TabOrder = 3
    OnClick = Button3Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 128
    Width = 97
    Height = 17
    Caption = 'Def line visible'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object wzsMonthDBEdit1: TwzsMonthDBEdit
    Left = 8
    Top = 8
    Width = 145
    Height = 19
    MonthFormat = 'mmmm'
    YearFormat = 'yyyy'
    Delimiter = ','
    FormatType = ftMonthYear
    DefaultDate = 36831.000000000000000000
    DefaultLineText = '('#1090#1077#1082#1091#1097#1080#1081')'
    NullLineText = '('#1074#1089#1077' '#1087#1077#1088#1080#1086#1076#1099')'
    AlwaysShowBorder = True
    DropDownBox.Rows = 12
    EditButton.Hint = #1042#1099#1073#1088#1072#1090#1100' '#1084#1077#1089#1103#1094
    EditButton.Width = 16
    EditButtons = <
      item
        Hint = #1057#1083#1077#1076#1091#1102#1097#1080#1081'/'#1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1084#1077#1089#1103#1094' ('#1089#1090#1088#1077#1083#1082#1080' '#1042#1074#1077#1088#1093'/'#1042#1085#1080#1079')'
        Style = ebsUpDownEh
        Width = 16
      end>
    Flat = True
    ShowHint = True
    TabOrder = 5
    Visible = True
    OnChange = wzsMonthDBEdit1Change
  end
  object CheckBox2: TCheckBox
    Left = 104
    Top = 128
    Width = 97
    Height = 17
    Caption = 'Null line visible'
    Checked = True
    State = cbChecked
    TabOrder = 6
    OnClick = CheckBox2Click
  end
end
