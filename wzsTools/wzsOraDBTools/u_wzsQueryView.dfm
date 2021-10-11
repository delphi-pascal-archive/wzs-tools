object wzsQueryView: TwzsQueryView
  Left = 287
  Top = 331
  Width = 684
  Height = 424
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'wzsOraDBTools\wzsQueryView'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object mmQueryView: TMemo
    Left = 0
    Top = 0
    Width = 676
    Height = 397
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'mmQueryView')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object ActionList1: TActionList
    Left = 200
    Top = 64
    object GetQuery: TAction
      Caption = 'Получить запрос'
      Hint = 'Получить запрос из датасета'
      OnExecute = GetQueryExecute
    end
  end
end
