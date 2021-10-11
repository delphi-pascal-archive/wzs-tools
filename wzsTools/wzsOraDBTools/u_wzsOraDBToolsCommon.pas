{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsOraDBToolsCommon;

interface

{$R wzsOraDBTools.dcr}

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Oracle, OracleData {$ifdef ver150}, Variants {$endif};

const
 PackageVer='2.5';

type TStringPropertyProc = procedure (const S: String) of Object;

function GetFieldData(Session: TOracleSession; QueryStr: string): TStringList;
procedure FillStringPropertyList(Session: TOracleSession;
      Query: string; Proc: TStringPropertyProc);
function GetFinalSQL(DatasetOrQuery: TComponent): string;
//function GetFinalSQLQry(Query: TOracleQuery): string;
function GetSessionID(Session: TOracleSession): string;
function GetDBMSUniqSessionID(Session: TOracleSession): string;

implementation

uses qStrings;

function GetFieldData(Session: TOracleSession; QueryStr: string): TStringList;
var
 oq: TOracleQuery;

begin
 result:=TStringList.Create;

 if (Session<>nil) and (Session.Connected) then
  begin
   oq:=TOracleQuery.Create(nil);
   oq.Session:=Session;

   oq.SQL.Add(QueryStr);
   oq.Execute;

   while not oq.Eof do
    begin
     result.Add(oq.Field(0));
     oq.Next
    end;

   oq.Free;
  end;
end;

procedure FillStringPropertyList(Session: TOracleSession;
      Query: string; Proc: TStringPropertyProc);

var
 i: Integer;
 list: TStringList;

begin

 list:=TStringList.Create;

 if (Session<>nil) and (Session.connected) then
  begin
    list:=GetFieldData(Session, Query);

    for i := 0 to list.Count - 1 do
     Proc(list[i]);

  end;

end;

//получение окончательного текста запроса датасета,
//С ПОДСТАВЛЕННЫМИ ЗНАЧЕНИЯМИ ВСЕХ ПЕРЕМЕННЫХ
function GetFinalSQL(DatasetOrQuery: TComponent): string;
var
  i: integer;
  value: string;

begin
  if DatasetOrQuery is TOracleDataset then
    with DatasetOrQuery as TOracleDataset do
    begin
      result:=sql.text;

      for i:=0 to VariableCount-1 do
      begin
        value:=GetVariable(VariableName(i));

        case VariableType(i) of
         otString, otDate, otChar: value:=''''+value+'''';
        end;

        result:=q_ReplaceText(result,
              VariableName(i),
              value);

      end;
    end;

  if DatasetOrQuery is TOracleQuery then
    with DatasetOrQuery as TOracleQuery do
    begin
      result:=sql.text;

      for i:=0 to VariableCount-1 do
      begin
        value:=GetVariable(VariableName(i));

        case VariableType(i) of
         otString, otDate, otChar: value:=''''+value+'''';
        end;

        result:=q_ReplaceText(result,
              VariableName(i),
              value);

      end;
    end;

  result:=q_spaceCompress(result);
end;

function GetSessionID(Session: TOracleSession): string;
var
 oq: TOracleQuery;

begin
 if (Session<>nil) and (Session.Connected) then
  begin
   oq:=TOracleQuery.Create(nil);
   oq.Session:=Session;

   oq.SQL.Add('select SYS_CONTEXT(''USERENV'', ''SESSIONID'') sid from dual');
   oq.Execute;

   if oq.RowCount > 0 then
     result:=oq.Field('sid')
   else
     result:='';

   oq.Free;
  end;
end;

function GetDBMSUniqSessionID(Session: TOracleSession): string;
var
 oq: TOracleQuery;

begin
 if (Session<>nil) and (Session.Connected) then
  begin
   oq:=TOracleQuery.Create(nil);
   oq.Session:=Session;

   oq.SQL.Add('select ope_pipe.GET_PIPENAME pipename from dual');
   oq.Execute;

   if oq.RowCount > 0 then
     result:=oq.Field('pipename')
   else
     result:='';

   oq.Free;
  end;
end;

end.
