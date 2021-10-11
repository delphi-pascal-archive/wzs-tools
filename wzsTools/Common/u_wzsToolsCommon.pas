{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}


unit u_wzsToolsCommon;

interface

{$R 'wzsToolsCommon.dcr'}

uses Windows, Messages, Dialogs, SysUtils, Classes, Controls, Graphics, ShellAPI,
     {$ifdef ver150} Variants, {$endif}
     Registry, DB, ActnList;

const
  ver='1.2';
  authTitle='© Serg Protasov';
  urlMail='mailto: wzonnet@kemcity.ru';
  urlFirst='http://wzonnet.blogspot.com';
  urlSecnd='http://wzff.livejournal.com';

type
  TwzsAboutInfo = string;
  
  TAppliedProcOnControl = procedure(var obj: TControl) of object;
  TAppliedProcOnComponent = procedure(var obj: TComponent) of object;
  TAppliedProcOnAction = procedure(var actn: TAction) of object;


  TwzsFilterExprBuilder = class(TComponent)
  { Builds filter expression for using with TDataset by given field list }
  public
    Fields: TStrings;
    PartialOnStrings: boolean;
    constructor Create(AOwner: TComponent); override;
    procedure AddField(Field: TField; FilterExpr: string);
    function GetFieldFilterStr(Field: TField; FilterExpr: string): string;
    function GetFieldsFilterStr: string;
  end;


function GetComponentsList(ParentComponent: TComponent; OfClass: TClass): TStrings;
function LoadControlGlyph(Control: TControl; ThemeNum: integer): TBitmap;
procedure ShellOpen(command: string);
//вызывает указанную процедуру для всех контролов класса в к-л контейнере
function ApplyProcOnControl(container: TWinControl; proc: TAppliedProcOnControl;
                             ofClass: TClass; nameMask: string): integer;
//вызывает указанную процедуру для всех компонент класса в к-л контейнере
function ApplyProcOnComponent(container: TComponent; proc: TAppliedProcOnComponent;
                             ofClass: TClass; nameMask: string): integer;
procedure ApplyProcOnActionCategory(ActionList: TActionList; category: string;
       proc: TAppliedProcOnAction);

implementation

uses qStrings;

const
 FilterOperChars='<>=';


function LoadControlGlyph(Control: TControl; ThemeNum: integer): TBitmap;
var
 cname: string;
 bitmap: TBitmap;
begin
 cname:=Control.name;
 bitmap:=TBitmap.Create;
 bitmap.LoadFromResourceName(HInstance, 'bmp'+copy(cname,4,255)+'_'+inttostr(ThemeNum));
 result:=bitmap;
end;

function GetComponentsList(ParentComponent: TComponent; OfClass: TClass): TStrings;
var
 i: integer;
 c: TComponent;
 list: TStrings;

begin
   list:=TStringList.Create;

   for i:=0 to ParentComponent.ComponentCount-1 do
    begin
     if (ParentComponent.Components[i].ClassType = OfClass) then
      begin
       c:=ParentComponent.Components[i];
       list.AddObject(c.Name, c);
      end;
    end;

   result:=list;
end;


procedure ShellOpen(command: string);
begin
 ShellExecute(0, 'Open', PChar(command), nil, nil, SW_SHOWNORMAL);
end;

{ TwzsFilterExprBuilder }

procedure TwzsFilterExprBuilder.AddField(Field: TField;
  FilterExpr: string);
{Adds another field and its filter expression value to expr builder
array. If field is lookup field, procedure tries to retrieve corresponding
lookup key value from lookup-dataset and build expression like
.......}
var
  keyvalues: Variant;
  keyfields: TStrings;
  j: integer;
begin

   keyfields:=TStringList.Create;

   if (Field<>nil) and (Field.Visible) and (FilterExpr<>'') then
     case Field.FieldKind of
       fkLookup:
       begin
         if Field.LookupDataSet<>nil then
         begin
          keyvalues:=Field.LookupDataSet.Lookup(
            Field.LookupResultField, FilterExpr, Field.LookupKeyFields);

          //keyfields.CommaText:=q_replaceStr(Field.LookupKeyFields, ';', ',');
          keyfields.CommaText:=q_replaceStr(Field.KeyFields, ';', ',');

          {d7 code
          keyfields.Delimiter:=';';
          keyfields.DelimitedText:=Field.LookupKeyFields;
          }
          
          if not VarIsNull(keyvalues) then
          begin
            for j:=0 to keyfields.Count-1 do
             if VarIsArray(keyvalues) then
              Fields.AddObject(VarToStr(keyvalues[j]),
                 Field.DataSet.FindField(keyfields[j]))
             else
              Fields.AddObject(VarToStr(keyvalues),
                 Field.DataSet.FindField(keyfields[j]));
          end;
         end;
       end;

       fkData:
        Fields.AddObject(FilterExpr, Field);

     end; //case

   keyfields.Free;
   
end;

constructor TwzsFilterExprBuilder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Fields:=TStringList.Create;
  PartialOnStrings:=false;
end;

function TwzsFilterExprBuilder.GetFieldFilterStr(Field: TField;
    FilterExpr: string): string;
var
 resStr, operStr, valStr: string;

begin
  resStr:='';

  operStr:=FilterExpr;
  valStr:=FilterExpr;
  q_KeepChars(operStr, FilterOperChars);
  q_DelChars(valStr, FilterOperChars);

  if operStr='' then
    operStr:='=';

  if (PartialOnStrings) and (Field.DataType = ftString) then
     valStr:='*'+valStr+'*';

  case Field.DataType of
    ftString, ftDate, ftTime, ftDateTime:
    valStr:=''''+valStr+'''';
  end;

  resStr:=resStr+'('+Field.FieldName+' '+operStr+' '+valStr+')';

  result:=resStr;
end;

function TwzsFilterExprBuilder.GetFieldsFilterStr: string;
var
  i: integer;
  resStr: string;

begin
  resStr:='';

  for i:=0 to Fields.Count-1 do
  begin
   resStr:=resStr+GetFieldFilterStr(Fields.Objects[i] as TField, Fields[i]);
   resStr:=q_replaceText(resStr, ')(', ') and (');
  end;

  result:=resStr;
end;

function ApplyProcOnControl(container: TWinControl; proc: TAppliedProcOnControl;
                          ofClass: TClass; nameMask: string): integer;
//Функция для групповой обработки объектов внутри контейнера
var
 i: integer;
 o: TControl;
 cnt: integer;
begin
  cnt:=0;
  for i:=0 to container.ControlCount-1 do
  begin

    o:=container.Controls[i];

    if o is ofClass then
      if (q_testWildText(o.Name, nameMask)) then
       begin
        proc(o);
        inc(cnt);
       end;

  end;
  result:=cnt;
end;

function ApplyProcOnComponent(container: TComponent;
  proc: TAppliedProcOnComponent; ofClass: TClass;
  nameMask: string): integer;
//Функция для групповой обработки объектов внутри контейнера
var
 i: integer;
 o: TComponent;
 cnt: integer;

begin
  cnt:=0;
  for i:=0 to container.ComponentCount-1 do
  begin

    o:=container.Components[i];

    if o is ofClass then
      if (q_testWildText(o.Name, nameMask)) then
       begin
        proc(o);
        inc(cnt);
       end;

  end;
  result:=cnt;

end;


procedure ApplyProcOnActionCategory(ActionList: TActionList; category: string;
       proc: TAppliedProcOnAction);
var
  i: integer;
  a: TAction;
begin
  for i:=0 to ActionList.ActionCount-1 do
  begin
    a:= ActionList.Actions[i] as TAction;
    if LowerCase(a.Category)=category then
      proc(a);
  end;
end;

end.


