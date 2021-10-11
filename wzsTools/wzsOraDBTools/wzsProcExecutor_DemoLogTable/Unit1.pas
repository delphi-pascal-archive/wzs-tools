{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru

TwzsOraProcExecutor demo (log table mode)
}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, {$ifdef ver150} Variants, {$endif} Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Oracle, ExtCtrls, u_wzsOraProcExecutor, ComCtrls, u_wzsOraDBToolsCommon;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button3: TButton;
    Button6: TButton;
    Button4: TButton;
    Label1: TLabel;
    wzsOraProcExecutor1: TwzsOraProcExecutor;
    ProgressBar1: TProgressBar;
    os2: TOracleSession;
    wzsOraProcExecutor2: TwzsOraProcExecutor;
    Button2: TButton;
    Button5: TButton;
    ProgressBar2: TProgressBar;
    Memo2: TMemo;
    os1: TOracleSession;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure wzsOraProcExecutor1Start(Sender: TOracleQuery);
    procedure wzsOraProcExecutor1Finished(Sender: TOracleQuery);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wzsOraProcExecutor1SequenceMsg(Sender: TObject;
      const SequenceValue, IncrementedValue: Integer);
    procedure wzsOraProcExecutor1Error(Sender: TOracleQuery;
      ErrorCode: Integer; const ErrorMessage: String);
    procedure wzsOraProcExecutor2Start(Sender: TOracleQuery);
    procedure wzsOraProcExecutor2ThreadError(Sender: TOracleQuery;
      ErrorCode: Integer; const ErrorMessage: String);
    procedure wzsOraProcExecutor2ThreadFinished(Sender: TOracleQuery);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure wzsOraProcExecutor1ThreadLogTableQuery(
      LogTableQuery: TOracleQuery; Stamp: TDateTime; Num: Integer;
      Str: String; Dat: TDateTime);
    procedure wzsOraProcExecutor2ThreadLogTableQuery(
      LogTableQuery: TOracleQuery; Stamp: TDateTime; Num: Integer;
      Str: String; Dat: TDateTime);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

var
  sid1, sid2: string;

{$R *.dfm}

procedure TForm1.Button3Click(Sender: TObject);
begin
// wzsOraProcExecutor1.Threaded:=CheckBox1.Checked;
 wzsOraProcExecutor1.Execute;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 wzsOraProcExecutor1.BreakThread;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  wzsOraProcExecutor1.PackageName:='test_package';
  wzsOraProcExecutor1.ProcName:='test_loop';
  wzsOraProcExecutor1.Clear;
  wzsOraProcExecutor1.DeclareAndSet('p1', otString, 'ANOTHER_STRING');
  wzsOraProcExecutor1.DeclareAndSet('res', otString, 0);
  wzsOraProcExecutor1.ResultVariable:=':res';
  wzsOraProcExecutor1.Execute;
end;

{
procedure TForm1.wzsOraProcExecutor1PipeMsg(Sender: TOracleEvent;
  const ObjectName: String; const Info: Variant);
var i: integer;
begin

  if VarIsArray(Info) then
    for i := 0 to VarArrayHighBound(Info, 1) do Memo1.Lines.Add(Info[i])
  else
   Memo1.Lines.Add(varToStr(Info[i]));

end;
}

procedure TForm1.wzsOraProcExecutor1Start(Sender: TOracleQuery);
begin
 sid1:=GetSessionID(os1);
 ProgressBar1.Position:=0;
 memo1.Lines.Add('Stored proc '+wzsOraProcExecutor1.ProcName+' started...');
end;

procedure TForm1.wzsOraProcExecutor1Finished(Sender: TOracleQuery);
begin
 memo1.Lines.Add('Stored proc '+wzsOraProcExecutor1.ProcName+' finished...');
 memo1.Lines.Add('...return value: '+inttostr(wzsOraProcExecutor1.GetVariable('var1')));
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if (wzsOraProcExecutor1.ThreadIsRunning) or
    (wzsOraProcExecutor2.ThreadIsRunning) then
  begin
   showmessage('Proc is still running, cant close!');
   action:=caNone;
  end;
end;

procedure TForm1.wzsOraProcExecutor1SequenceMsg(Sender: TObject;
  const SequenceValue, IncrementedValue: Integer);
begin
 memo1.Lines.Add(inttostr(IncrementedValue));
 ProgressBar1.Position:=IncrementedValue;
end;

procedure TForm1.wzsOraProcExecutor1Error(Sender: TOracleQuery;
  ErrorCode: Integer; const ErrorMessage: String);
begin
 memo1.Lines.Add('Thread error: '+ErrorMessage);
end;

procedure TForm1.wzsOraProcExecutor2Start(Sender: TOracleQuery);
begin
 sid2:=GetSessionID(os2);

 ProgressBar2.Position:=0;
 memo2.Lines.Add('Stored proc '+wzsOraProcExecutor2.ProcName+' started...');
end;

procedure TForm1.wzsOraProcExecutor2ThreadError(Sender: TOracleQuery;
  ErrorCode: Integer; const ErrorMessage: String);
begin
  memo2.Lines.Add('Thread error: '+ErrorMessage);
end;

procedure TForm1.wzsOraProcExecutor2ThreadFinished(Sender: TOracleQuery);
begin
  memo2.Lines.Add('Stored proc '+wzsOraProcExecutor2.ProcName+' finished...');
  memo2.Lines.Add('...return value: '+inttostr(wzsOraProcExecutor2.GetVariable('var1')));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
// wzsOraProcExecutor2.Threaded:=CheckBox2.Checked;
 wzsOraProcExecutor2.Execute;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
 wzsOraProcExecutor2.BreakThread;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //showmessage(GetSessionID(os1));
  showmessage(wzsOraProcExecutor1.SessionID);
end;

procedure TForm1.wzsOraProcExecutor1ThreadLogTableQuery(
  LogTableQuery: TOracleQuery; Stamp: TDateTime; Num: Integer; Str: String;
  Dat: TDateTime);
begin
  memo1.Lines.Add(Str+' '+DateTimeToStr(Stamp));
  ProgressBar1.Position:=Num;
end;

procedure TForm1.wzsOraProcExecutor2ThreadLogTableQuery(
  LogTableQuery: TOracleQuery; Stamp: TDateTime; Num: Integer; Str: String;
  Dat: TDateTime);
begin
  memo2.Lines.Add(Str+' '+DateTimeToStr(Stamp));
  ProgressBar2.Position:=Num;
end;

end.
