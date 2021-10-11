object Form1: TForm1
  Left = 287
  Top = 192
  Width = 666
  Height = 498
  Caption = 'TwzsOraProcExecutor demo (log table mode)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
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
    Height = 249
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
    Height = 247
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object Button1: TButton
    Left = 144
    Top = 8
    Width = 137
    Height = 25
    Caption = 'Get session id'
    TabOrder = 9
    OnClick = Button1Click
  end
  object wzsOraProcExecutor1: TwzsOraProcExecutor
    Session = os1
    ProcName = 'TEST_LOOP'
    PackageName = 'TEST_LOGTABLE_PKG'
    Variables.Data = {
      0300000002000000030000003A5031050000000000000000000000050000003A
      56415231050000000000000000000000}
    ResultVariable = ':VAR1'
    EventMode = emLogTable
    Threaded = True
    LogTableInterval = 100
    PipeName = 'qwe'
    OnThreadFinished = wzsOraProcExecutor1Finished
    OnThreadError = wzsOraProcExecutor1Error
    OnStart = wzsOraProcExecutor1Start
    OnThreadLogTableQuery = wzsOraProcExecutor1ThreadLogTableQuery
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
    PackageName = 'TEST_LOGTABLE_PKG'
    Variables.Data = {
      0300000002000000030000003A5031050000000000000000000000050000003A
      56415231050000000000000000000000}
    ResultVariable = ':VAR1'
    EventMode = emLogTable
    Threaded = True
    OnThreadFinished = wzsOraProcExecutor2ThreadFinished
    OnThreadError = wzsOraProcExecutor2ThreadError
    OnStart = wzsOraProcExecutor2Start
    OnThreadLogTableQuery = wzsOraProcExecutor2ThreadLogTableQuery
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
