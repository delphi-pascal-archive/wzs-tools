inherited wzsDBSearchEditDesForm: TwzsDBSearchEditDesForm
  Left = 402
  Top = 230
  Height = 430
  Caption = 'wzsDBSearchEditDesForm'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMain: TPanel
    Height = 349
    object sbDrop: TSpeedButton [0]
      Left = 40
      Top = 32
      Width = 89
      Height = 22
      Caption = 'Drop field label'
      OnClick = sbDropClick
    end
    inherited pnlStatus: TPanel
      Top = 310
    end
  end
  inherited pnlBottom: TPanel
    Top = 349
    inherited lbAuthor: TLabel
      Left = 120
      Top = 36
    end
    inherited lbUrl1: TLabel
      Top = 36
      Width = 156
    end
    inherited lbUrl2: TLabel
      Left = 438
      Top = 36
    end
  end
end
