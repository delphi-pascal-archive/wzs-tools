{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsOraProcExecutor;


interface

uses
  SysUtils, Classes, Oracle, Controls, Dialogs, OracleTypes,
  ExtCtrls, u_wzsToolsCommon {$ifdef ver150}, Variants {$endif};

type
  TPipeMsgProc = procedure (Sender: TOracleEvent; const Msg: Variant) of Object;
  TLogTableQueryProc = procedure (LogTableQuery: TOracleQuery;
      Stamp: TDateTime; Num: integer; Str: String; Dat: TDateTime) of Object;
  TEventModes = (emNone, emPipe, emLogTable);

  TwzsOraProcExecutor = class(TComponent)
  private
    FAbout: TwzsAboutInfo;

    FProcName: string;
    FPackageName: string;
    //FLogTableName: string;

    FSession: TOracleSession;
    FProcQuery: TOracleQuery;
    FLogTableSession: TOracleSession;
    FLogTableQuery: TOracleQuery;
    FLogTableTimer: TTimer;
    FOracleEvent: TOracleEvent;

    FOnThreadFinished: TOracleQueryEvent;
    FOnThreadError: TThreadErrorEvent;
    FOnStart: TOracleQueryEvent;
    FOnThreadPipeMsg: TPipeMsgProc;
    FOnThreadLogTableQuery: TLogTableQueryProc;

    FResultVariable: string;
    FEventMode: TEventModes;
    FSessionID: string;
    FUniqPipeName: boolean;
    FAutodetectParams: boolean;
    FStopEventsOnFinish: boolean;
    function ReadyState: boolean;
    procedure SetSession(Value: TOracleSession);
    function MakeSQL: TStrings;
    function GetVariables: TVariables;
    procedure SetVariables(const Value: TVariables);
    function GetCursor: TCursor;
    procedure SetCursor(const Value: TCursor);
    function GetThreaded: boolean;
    procedure SetThreaded(Value: boolean);
    procedure SetProcName(const Value: string);
    //procedure SetLogTableName(Value: string);
    procedure OracleEventOnEvent(Sender: TOracleEvent; const ObjectName: String;
       const Info: Variant);
    procedure ProcQueryAfterQuery(Sender: TOracleQuery);
    procedure LogTableOnTimer(Sender: TObject);
    procedure SetEventMode(Value: TEventModes);
    function GetThreadIsRunning: boolean;
    procedure SetLogTableInterval(Value: integer);
    function GetLogTableInterval: integer;
    procedure SetPipeName(value: string);
    function GetPipeName: string;
    procedure SetUniqPipeName(value: boolean);
    procedure SetResultVariable(Value: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute;
    function GetVariable(VarName: string): Variant;
    procedure DeclareAndSet(VarName: string; VarType: Integer; VarValue: Variant);
    procedure Clear;
    procedure BreakThread;
    procedure ReadVariables;
    property ThreadIsRunning: boolean read GetThreadIsRunning;
    procedure SetVariable(VarName: string; Value: Variant);
    property ProcQuery: TOracleQuery read FProcQuery;    
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Session: TOracleSession read FSession write SetSession;
    property ProcName: string read FProcName write SetProcName;
    property PackageName: string read FPackageName write FPackageName;
    //property LogTableName: string read FLogTableName write SetLogTableName;
    property Variables: TVariables read GetVariables write SetVariables;
    property ResultVariable: string read FResultVariable write SetResultVariable;
    property Cursor: TCursor read GetCursor write SetCursor default crAppStart;
    property EventMode: TEventModes read FEventMode write SetEventMode default emNone;
    property Threaded: boolean read GetThreaded write SetThreaded default false;
    property LogTableInterval: integer read GetLogTableInterval write SetLogTableInterval default 500;
    property PipeName: string read GetPipeName write SetPipeName;
    property UniqPipeName: boolean read FUniqPipeName write SetUniqPipeName default true;
    property AutodetectParams: boolean read FAutodetectParams write FAutodetectParams default true;
    property StopEventsOnFinish: boolean read FStopEventsOnFinish write FStopEventsOnFinish default true;
    property SessionID: string read FSessionID;

    property OnThreadFinished: TOracleQueryEvent read FOnThreadFinished write FOnThreadFinished;
    property OnThreadError: TThreadErrorEvent read FOnThreadError write FOnThreadError;
    property OnStart: TOracleQueryEvent read FOnStart write FOnStart;
    property OnThreadPipeMsg: TPipeMsgProc read FOnThreadPipeMsg write FOnThreadPipeMsg;
    property OnThreadLogTableQuery: TLogTableQueryProc read FOnThreadLogTableQuery
      write FOnThreadLogTableQuery;
  end;

procedure Register;

implementation

uses qStrings, u_wzsOraDBToolsCommon;

procedure Register;
begin
  RegisterComponents('wzsTools', [TwzsOraProcExecutor]);
end;

{ TwzsOraProcExecutor }

procedure TwzsOraProcExecutor.BreakThread;
begin
 if FProcQuery.ThreadIsRunning then
  begin
   FLogTableTimer.Enabled:=false;
   FProcQuery.BreakThread;
   FProcQuery.Session.Rollback;
  end;
end;

procedure TwzsOraProcExecutor.Clear;
begin
  if ReadyState then
   begin
    FProcQuery.Clear;
    FLogTableTimer.Enabled:=false;
   end;
end;

constructor TwzsOraProcExecutor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FEventMode:=emNone;

  FProcQuery:=TOracleQuery.Create(self);
  FProcQuery.Threaded:=false;
  FProcQuery.ThreadSynchronized:=true;
  FProcQuery.Cursor:=crAppStart;

  FLogTableQuery:=TOracleQuery.Create(self);
  FLogTableQuery.Threaded:=false;
  FLogTableQuery.ThreadSynchronized:=true;

  FLogTableSession:=TOracleSession.Create(self);

  FOracleEvent:=TOracleEvent.Create(self);
  FOracleEvent.ObjectType:=otPipe;

  FOracleEvent.Synchronized:=true;

  FLogTableTimer:=TTimer.Create(self);
  FLogTableTimer.Enabled:=false;

  FLogTableTimer.Interval:=500;

  FUniqPipeName:=true;
  FAutodetectParams:=true;
  FStopEventsOnFinish:=true;

    
end;

procedure TwzsOraProcExecutor.DeclareAndSet(VarName: string;
  VarType: Integer; VarValue: Variant);
begin
  FProcQuery.DeclareAndSet(VarName, VarType, VarValue);
end;

procedure TwzsOraProcExecutor.Execute;
begin
  if ReadyState then
  begin
    FSessionID:=GetSessionID(FSession);
      
    FProcQuery.SQL.Clear;

    FProcQuery.SQL:=MakeSQL;

    //showmessage(FOracleQuery.SQL.Text);

    case FEventMode of
     emPipe:
      begin
       if not FOracleEvent.Started then
       begin
         if FUniqPipeName then
           //FOracleEvent.ObjectNames:=GetDBMSUniqSessionID(FSession);
           FOracleEvent.ObjectNames:=FSession.DBMS_Pipe.Unique_Session_Name;

         FOracleEvent.Start;
       end;
      end;
     emLogTable:
      begin
       FLogTableSession.LogonUsername:=FSession.LogonUsername;
       FLogTableSession.LogonPassword:=FSession.LogonPassword;
       FLogTableSession.LogonDatabase:=FSession.LogonDatabase;
       FLogTableSession.Connected:=true;
       FLogTableQuery.Session:=FLogTableSession;

       FLogTableTimer.Enabled:=true;
      end;
    end; //case

    FProcQuery.Execute;
   end;
end;

function TwzsOraProcExecutor.GetCursor: TCursor;
begin
  result:=FProcQuery.Cursor;
end;

{
function TwzsOraProcExecutor.GetSequenceValue: integer;
begin
  result:=-1;
  if (FSequenceQuery.Session<>nil) and (FSequenceSession.Connected) and
     (FSequenceName<>'') then
   begin
    FSequenceQuery.SQL.Clear;
    FSequenceQuery.SQL.Add(
      'select last_number from user_sequences where sequence_name=upper('''+FSequenceName+''') '
      );
    FSequenceQuery.Execute;

    if FSequenceQuery.RowCount>0 then
     result:=FSequenceQuery.Field('last_number');
   end;
end;
}

function TwzsOraProcExecutor.GetThreaded: boolean;
begin
  result:=FProcQuery.Threaded;
end;

function TwzsOraProcExecutor.GetVariable(VarName: string): Variant;
begin
  result:=FProcQuery.GetVariable(VarName);
end;

function TwzsOraProcExecutor.GetVariables: TVariables;
begin
  result:=FProcQuery.Variables;
end;

procedure TwzsOraProcExecutor.LogTableOnTimer(Sender: TObject);
begin

  FLogTableQuery.SQL.Text:='select * from ope_log where rownum=1 and '+
        'sid = '+FSessionID;

  FLogTableQuery.Execute;

  if FLogTableQuery.RowCount>0 then
  begin
    if assigned(FOnThreadLogTableQuery) then
      FOnThreadLogTableQuery(FLogTableQuery,
        FLogTableQuery.FieldAsDate('pk'),
        FLogTableQuery.FieldAsInteger('num'),
        FLogTableQuery.FieldAsString('str'),
        FLogTableQuery.FieldAsDate('dat'));
  end;

end;

procedure TwzsOraProcExecutor.Loaded;
begin
  inherited Loaded;

  if assigned(FOnThreadFinished) then
   FProcQuery.OnThreadFinished:=FOnThreadFinished;

  if assigned(FOnThreadError) then
   FProcQuery.OnThreadError:=FOnThreadError;

  if assigned(FOnStart) then
   FProcQuery.BeforeQuery:=FOnStart;

  FProcQuery.AfterQuery:=ProcQueryAfterQuery;
  FOracleEvent.OnEvent:=OracleEventOnEvent;
  FLogTableTimer.OnTimer:=LogTableOnTimer;

  
end;

function TwzsOraProcExecutor.MakeSQL: TStrings;
var
  i: integer;
  resultStr, paramStr: string;
begin
  result:=TStringList.Create;
  resultStr:='';
  paramStr:='';

  result.Add('begin');

  if FProcQuery.VariableCount>0 then
   begin
    for i:=0 to FProcQuery.VariableCount-1 do
     if FProcQuery.VariableIndex(FResultVariable) <> i then
      paramStr:=paramStr+FProcQuery.VariableName(i)+', ';

    Q_ReplaceLastStr(paramStr, ',', '');

    if trim(paramStr)<>'' then
      paramStr:='('+paramStr+')';
   end;

  if FResultVariable<>'' then
   resultStr:=FResultVariable+':=';

  result.Add(resultStr+FPackageName+'.'+FProcName+paramStr+';');
  result.Add('end;');

  //showmessage(result.Text);
end;

procedure TwzsOraProcExecutor.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  case Operation of
   opRemove:
     begin
       if AComponent = FSession then
          FSession:=nil;
     end;
  end;
end;

procedure TwzsOraProcExecutor.OracleEventOnEvent(Sender: TOracleEvent;
  const ObjectName: String; const Info: Variant);
var
  i: integer;
begin
 if (FEventMode=emPipe) then
  begin
    if VarIsArray(Info) then
      for i := 0 to VarArrayHighBound(Info, 1) do
       begin
        if assigned(FOnThreadPipeMsg) then
         FOnThreadPipeMsg(sender, info[i]);
       end;
  end;
end;

procedure TwzsOraProcExecutor.ReadVariables;
const
  cutWords=';,procedure,function,(,), out, return';

var
 list: TStringList;
 s, paramLine, varName, varType: string;
 i, doaVarType: integer;
begin
 if (FSession<>nil) and (FPackageName<>'') and
    (FProcName<>'') and (FSession.Connected) then
  begin
    {
    list:=GetFieldData(FSession,
     'select text from user_source where name='''+upperCase(FPackageName)+
     ''' and type=''PACKAGE'' and upper(text) like ''%'+upperCase(FProcName)+'%''');

    s:=list.Strings[0];
    }
    
    list:=GetFieldData(FSession,
      'select a.text from user_source a where 1=1'+
      ' and a.name='''+upperCase(FPackageName)+''' and a.type=''PACKAGE'''+
      ' and a.line<='+
      ' (select line from user_source b where 1=1'+
      ' and b.name = a.name and b.type = b.type'+
      ' and b.text like ''%;%'' and rownum=1 and b.line >='+
      ' (select c.line from user_source c where'+
      ' c.name=b.name and c.type=b.type and upper(c.text) like ''%'+upperCase(FProcName)+'%'')'+
      ' )'+
      ' and a.line >='+
      ' (select d.line from user_source d where'+
      ' d.name=a.name and d.type=a.type and upper(d.text) like ''%'+upperCase(FProcName)+'%'')');

    s:=list.text;
    
    //showmessage(s);

    if trim(s)<>'' then
     begin
       FProcQuery.DeleteVariables;

       for i:=1 to 100 do
        s:=q_ReplaceText(s, q_GetWordN(i, cutWords, ','), '');

       s:=trim(q_ReplaceText(s, FProcName, ''));

       paramLine:=s;

       while paramLine<>'' do
        begin
         s:=trim(q_strTok(paramLine, ','));

         varName:=q_GetWordN(1, s, ' ');
         varType:=q_GetWordN(2, s, ' ');

         doaVarType:=otSubst;

         if varType = 'varchar2' then
          doaVarType:=otString;
         if (varType = 'number') or (varType='integer') then
          doaVarType:=otInteger;
         if varType = 'date' then
          doaVarType:=otDate;

         FProcQuery.DeclareVariable(varName, doaVarType);
        end;
     end;
  end;

end;

function TwzsOraProcExecutor.ReadyState: boolean;
begin
  result:=false;
  if (FSession<>nil) and (not FProcQuery.ThreadIsRunning) and
     (FPackageName<>'') and (FProcName<>'') and (FSession.Connected) then
   result:=true;
end;

procedure TwzsOraProcExecutor.SetCursor(const Value: TCursor);
begin
  FProcQuery.Cursor:=Value;
end;

procedure TwzsOraProcExecutor.SetEventMode(Value: TEventModes);
begin
 FEventMode:=Value;
 if FEventMode <> emNone then
  FProcQuery.Threaded:=true;
end;

procedure TwzsOraProcExecutor.SetProcName(const Value: string);
begin
  if Value<>FProcName then
  begin
    FProcName:=Value;
    if FAutodetectParams then
      ReadVariables;
  end;
end;

procedure TwzsOraProcExecutor.SetSession(Value: TOracleSession);
begin
 FSession:=Value;

 FProcQuery.Session:=FSession;
 FOracleEvent.Session:=FSession;
end;

procedure TwzsOraProcExecutor.SetThreaded(Value: boolean);
begin
  FProcQuery.Threaded:=Value;

  if not Value then
   FEventMode:=emNone;
end;

procedure TwzsOraProcExecutor.SetVariables(const Value: TVariables);
begin
 FProcQuery.Variables:=Value;
end;

procedure TwzsOraProcExecutor.ProcQueryAfterQuery(Sender: TOracleQuery);
begin
 FLogTableTimer.Enabled:=false;

 if (FStopEventsOnFinish) and (FOracleEvent.Started) then
   FOracleEvent.Stop;

 if Assigned(FOnThreadFinished) and (not Threaded) then
   FOnThreadFinished(FProcQuery);
end;

function TwzsOraProcExecutor.GetThreadIsRunning: boolean;
begin
  result:=FProcQuery.ThreadIsRunning;
end;

function TwzsOraProcExecutor.GetLogTableInterval: integer;
begin
 result:=FLogTableTimer.Interval;
end;

procedure TwzsOraProcExecutor.SetLogTableInterval(Value: integer);
begin
 FLogTableTimer.Interval:=Value;
end;

procedure TwzsOraProcExecutor.SetVariable(VarName: string; Value: Variant);
begin
 FProcQuery.SetVariable(VarName, Value);
end;

procedure TwzsOraProcExecutor.SetPipeName(value: string);
begin
 FOracleEvent.ObjectNames:=value;
end;

function TwzsOraProcExecutor.GetPipeName: string;
begin
 result:=FOracleEvent.ObjectNames;
end;

procedure TwzsOraProcExecutor.SetUniqPipeName(value: boolean);
begin
  FUniqPipeName:=value;
end;

procedure TwzsOraProcExecutor.SetResultVariable(Value: string);
begin
  if FProcQuery.VariableIndex(Value) >= 0 then
  begin
    FResultVariable:=UpperCase(Value);

    if pos(':', FResultVariable)=0 then
      FResultVariable:=':'+FResultVariable;
  end
  else
    showmessage(ClassName+': Variable '+Value+' does not exists');

end;

end.
