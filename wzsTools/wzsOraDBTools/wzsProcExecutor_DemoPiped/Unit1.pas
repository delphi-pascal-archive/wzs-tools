unit Unit1;

interface

uses
  Windows, Messages, SysUtils, {$ifdef ver150} Variants, {$endif} Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Oracle, ExtCtrls, u_wzsOraProcExecutor, ComCtrls;

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
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure wzsOraProcExecutor1PipeMsg(Sender: TOracleEvent;
      const Msg: Variant);
    procedure wzsOraProcExecutor1Start(Sender: TOracleQuery);
    procedure wzsOraProcExecutor1Finished(Sender: TOracleQuery);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure wzsOraProcExecutor1SequenceMsg(Sender: TObject;
      const SequenceValue, IncrementedValue: Integer);
    procedure wzsOraProcExecutor1Error(Sender: TOracleQuery;
      ErrorCode: Integer; const ErrorMessage: String);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

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


procedure TForm1.wzsOraProcExecutor1PipeMsg(Sender: TOracleEvent;
  const Msg: Variant);
begin

  if Sender.Owner=wzsOraProcExecutor1 then
    case VarType(msg) of
      varDouble: ProgressBar1.Position:=msg;
      varOleStr, varString: memo1.Lines.Add(varToStr(msg));
    end;

  if Sender.Owner=wzsOraProcExecutor2 then
    case VarType(msg) of
      varDouble: ProgressBar2.Position:=msg;
      varOleStr, varString: memo2.Lines.Add(varToStr(msg));
    end;

end;

procedure TForm1.wzsOraProcExecutor1Start(Sender: TOracleQuery);
begin
  ProgressBar1.Position:=0;
  ProgressBar2.Position:=0;

  if Sender.Owner=wzsOraProcExecutor1 then
    memo1.Lines.Add('Stored proc '+wzsOraProcExecutor1.ProcName+' started...');

  if Sender.Owner=wzsOraProcExecutor2 then
    memo2.Lines.Add('Stored proc '+wzsOraProcExecutor2.ProcName+' started...');
end;

procedure TForm1.wzsOraProcExecutor1Finished(Sender: TOracleQuery);
begin

  if Sender.Owner=wzsOraProcExecutor1 then
  begin
    memo1.Lines.Add('Stored proc '+wzsOraProcExecutor1.ProcName+' finished...');
    memo1.Lines.Add('...return value: '+inttostr(wzsOraProcExecutor1.GetVariable('var1')));
    memo1.Lines.Add('out value: '+wzsOraProcExecutor1.GetVariable('p_out'));
  end;

  if Sender.Owner=wzsOraProcExecutor2 then
  begin
    memo2.Lines.Add('Stored proc '+wzsOraProcExecutor2.ProcName+' finished...');
    memo2.Lines.Add('...return value: '+inttostr(wzsOraProcExecutor2.GetVariable('var1')));
    memo2.Lines.Add('out value: '+wzsOraProcExecutor2.GetVariable('p_out'));
  end;

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
  if Sender.Owner=wzsOraProcExecutor1 then
    memo1.Lines.Add('Thread error: '+ErrorMessage);

  if Sender.Owner=wzsOraProcExecutor2 then
    memo2.Lines.Add('Thread error: '+ErrorMessage);
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

end.
