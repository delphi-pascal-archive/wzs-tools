object Form1: TForm1
  Left = 287
  Top = 192
  Width = 666
  Height = 398
  Caption = 'TwzsOraProcExecutor demo (piped mode)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 176
    Width = 195
    Height = 13
    Caption = 'Messages && progress of stored procedure'
  end
  object Label2: TLabel
    Left = 336
    Top = 176
    Width = 195
    Height = 13
    Caption = 'Messages && progress of stored procedure'
  end
  object Label3: TLabel
    Left = 8
    Top = 40
    Width = 305
    Height = 57
    Alignment = taCenter
    AutoSize = False
    Caption = 'Stored proc thread in session 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 336
    Top = 40
    Width = 305
    Height = 57
    Alignment = taCenter
    AutoSize = False
    Caption = 'Stored proc thread in session 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Memo1: TMemo
    Left = 8
    Top = 216
    Width = 313
    Height = 145
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button3: TButton
    Left = 8
    Top = 112
    Width = 313
    Height = 25
    Caption = 'Run proc'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button6: TButton
    Left = 8
    Top = 144
    Width = 313
    Height = 25
    Caption = 'Stop proc'
    TabOrder = 2
    OnClick = Button6Click
  end
  object Button4: TButton
    Left = 8
    Top = 8
    Width = 129
    Height = 25
    Caption = 'Custom execute'
    TabOrder = 3
    OnClick = Button4Click
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 192
    Width = 313
    Height = 16
    Smooth = True
    TabOrder = 4
  end
  object Button2: TButton
    Left = 336
    Top = 112
    Width = 313
    Height = 25
    Caption = 'Run proc'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button5: TButton
    Left = 336
    Top = 144
    Width = 313
    Height = 25
    Caption = 'Stop proc'
    TabOrder = 6
    OnClick = Button5Click
  end
  object ProgressBar2: TProgressBar
    Left = 336
    Top = 192
    Width = 313
    Height = 16
    Smooth = True
    TabOrder = 7
  end
  object Memo2: TMemo
    Left = 336
    Top = 216
    Width = 313
    Height = 145
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object wzsOraProcExecutor1: TwzsOraProcExecutor
    Session = os1
    ProcName = 'TEST_LOOP'
    PackageName = 'TEST_PIPE_PKG'
    Variables.Data = {
      0300000003000000050000003A505F494E050000000000000000000000060000
      003A505F4F5554050000000000000000000000050000003A5641523105000000
      0000000000000000}
    ResultVariable = ':VAR1'
    EventMode = emPipe
    Threaded = True
    StopEventsOnFinish = False
    OnThreadFinished = wzsOraProcExecutor1Finished
    OnThreadError = wzsOraProcExecutor1Error
    OnStart = wzsOraProcExecutor1Start
    OnThreadPipeMsg = wzsOraProcExecutor1PipeMsg
    Left = 152
    Top = 272
  end
  object os2: TOracleSession
    LogonUsername = 'scott'
    LogonPassword = 'tiger'
    LogonDatabase = 'ORCL'
    ThreadSafe = True
    Connected = True
    Left = 376
    Top = 272
  end
  object wzsOraProcExecutor2: TwzsOraProcExecutor
    Session = os2
    ProcName = 'TEST_LOOP'
    PackageName = 'TEST_PIPE_PKG'
    Variables.Data = {
      0300000003000000050000003A505F494E050000000000000000000000060000
      003A505F4F5554050000000000000000000000050000003A5641523105000000
      0000000000000000}
    ResultVariable = ':VAR1'
    EventMode = emPipe
    Threaded = True
    StopEventsOnFinish = False
    OnThreadFinished = wzsOraProcExecutor1Finished
    OnThreadError = wzsOraProcExecutor1Error
    OnStart = wzsOraProcExecutor1Start
    OnThreadPipeMsg = wzsOraProcExecutor1PipeMsg
    Left = 408
    Top = 272
  end
  object os1: TOracleSession
    LogonUsername = 'scott'
    LogonPassword = 'tiger'
    LogonDatabase = 'ORCL'
    ThreadSafe = True
    Connected = True
    Left = 120
    Top = 272
  end
end
