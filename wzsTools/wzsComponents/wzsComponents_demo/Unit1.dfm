object Form1: TForm1
  Left = 439
  Top = 273
  Width = 232
  Height = 220
  Caption = 'wzComponents demo (DOA)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 125
    Height = 13
    Caption = 'TwzsDBLookupCheckBox'
  end
  object wzsDBLookupCheckBox1: TwzsDBLookupCheckBox
    Left = 8
    Top = 24
    Width = 209
    Height = 129
    ItemHeight = 13
    Items.Strings = (
      'SMITH'
      'ALLEN'
      'WARD'
      'JONES'
      'MARTIN'
      'BLAKE'
      'CLARK'
      'SCOTT'
      'KING'
      'TURNER'
      'ADAMS'
      'JAMES'
      'FORD'
      'MILLER')
    TabOrder = 0
    ListSource = DataSource1
    ListField = 'ENAME'
    KeyField = 'EMPNO'
    KeyValuesDelimiter = ','
  end
  object Button1: TButton
    Left = 8
    Top = 160
    Width = 209
    Height = 25
    Caption = 'Get selected KeyValues'
    TabOrder = 1
    OnClick = Button1Click
  end
  object OracleSession1: TOracleSession
    LogonUsername = 'scott'
    LogonPassword = 'tiger'
    LogonDatabase = 'ORCL'
    Connected = True
    Left = 80
    Top = 32
  end
  object OracleDataSet1: TOracleDataSet
    SQL.Strings = (
      'select * from scott.emp')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      040000000800000005000000454D504E4F01000000000005000000454E414D45
      010000000000030000004A4F42010000000000030000004D4752010000000000
      0800000048495245444154450100000000000300000053414C01000000000004
      000000434F4D4D01000000000006000000444550544E4F010000000000}
    Session = OracleSession1
    Active = True
    Left = 112
    Top = 32
  end
  object DataSource1: TDataSource
    DataSet = OracleDataSet1
    Left = 144
    Top = 32
  end
  object wzsStyler1: TwzsStyler
    FrameHotColor = clBlue
    Left = 80
    Top = 64
  end
end
