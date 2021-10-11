object Form1: TForm1
  Left = 231
  Top = 197
  Width = 870
  Height = 450
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 16
    Top = 96
    Width = 793
    Height = 265
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBNavigator1: TDBNavigator
    Left = 288
    Top = 56
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object DataSource1: TDataSource
    DataSet = wzsOracleDataset1
    Left = 192
    Top = 40
  end
  object OracleSession1: TOracleSession
    LogonUsername = 'vdp'
    LogonPassword = 'vdp'
    LogonDatabase = 'ORCL'
    Connected = True
    Left = 128
    Top = 40
  end
  object wzsOracleDataset1: TwzsOracleDataset
    SQL.Strings = (
      'select a.*, a.rowid from vdp.spuser a')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      04000000060000000300000055535201000000000003000000524F4C01000000
      0000040000004E414D4501000000000006000000414354495645010000000000
      070000004953545F52454501000000000003000000505744010000000000}
    Session = OracleSession1
    Active = True
    Additional.KeepBookmark = True
    Additional.RefreshAfterPost = True
    Left = 160
    Top = 40
  end
end
