{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBLookupCheckBox;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, CheckLst,
  Messages, DB, DBCtrls, Dialogs,
  u_wzsToolsCommon, u_wzsComponentsCommon {$ifdef ver150}, Variants {$endif};

type

  TwzsDBLookupCheckBox = class(TCheckListBox)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsAdditional;
    FDataLink: TFieldDataLink;
    FKeyField: string;
    FKeyValuesDelimiter: string;
    function GetListSource: TDataSource;
    function GetListField: string;
    procedure SetListSource(Value: TDataSource);
    procedure SetListField(Value: string);
    procedure ActiveChange(Sender: TObject);
    //procedure DataChange(Sender: TObject);
    function GetKeyValues: Variant;
    function GetKeyValuesString: string;
    function GetSelListValues: string;
  protected
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CMMouseEnter(var Message: TMessage); message cm_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message cm_MOUSELEAVE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;    
    procedure RefreshItems;
    property DataLink: TFieldDataLink read FDataLink write FDataLink;
    property KeyValues: Variant read GetKeyValues;
    property KeyValuesString: string read GetKeyValuesString;
    property SelListValuesString: string read GetSelListValues;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsAdditional read FAdditional write FAdditional;
    property ListSource: TDataSource read GetListSource write SetListSource;
    property ListField: string read GetListField write SetListField;
    property KeyField: string read FKeyField write FKeyField;
    property KeyValuesDelimiter: string read FKeyValuesDelimiter write FKeyValuesDelimiter;
  end;

procedure Register;

implementation

uses qStrings;

procedure Register;
begin
  RegisterComponents('wzsTools', [TwzsDBLookupCheckBox]);
end;

{ TwzsDBLookupCheckBox }

procedure TwzsDBLookupCheckBox.ActiveChange(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
    RefreshItems;
end;

constructor TwzsDBLookupCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  ControlStyle := ControlStyle + [csReplicatable];
  
  FDataLink:=TFieldDataLink.Create;
  FDataLink.Control:=self;
  FDataLink.OnActiveChange := ActiveChange;
  //FDataLink.OnDataChange := DataChange;
  FAdditional:=TwzsAdditional.Create(self);

  FKeyValuesDelimiter:=',';

  //BorderStyle:=bsNone;
  //BevelKind:=bkFlat;

end;

{
procedure TwzsDBLookupCheckBox.DataChange(Sender: TObject);
begin
  FillItems;
end;
}

procedure TwzsDBLookupCheckBox.RefreshItems;
var
  i: integer;
begin
  Items.Clear;

  if (FDataLink.DataSet<>nil) and (FDataLink.DataSet.Active) and
    (FDataLink.DataSet.FindField(ListField)<>nil) then
    begin
      FDataLink.DataSet.DisableControls;
      FDataLink.DataSet.First;

      for i:=0 to FDataLink.Dataset.RecordCount-1 do
      begin
        Items.Add(FDataLink.DataSet.FindField(ListField).AsString);
        FDataLink.DataSet.Next;
      end;

      FDataLink.DataSet.EnableControls;
    end;
end;

function TwzsDBLookupCheckBox.GetListField: string;
begin
  result:=FDataLink.FieldName;
end;

function TwzsDBLookupCheckBox.GetListSource: TDataSource;
begin
  result:=FDataLink.DataSource;
end;

procedure TwzsDBLookupCheckBox.SetListField(Value: string);
begin
  if Value<>FDataLink.FieldName then
  begin
    FDataLink.FieldName:=Value;
    RefreshItems;
  end;
end;

procedure TwzsDBLookupCheckBox.SetListSource(Value: TDataSource);
begin
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
    FDataLink.DataSource := Value;
end;

function TwzsDBLookupCheckBox.GetKeyValues: Variant;
var
  i: integer;
begin

  result:=VarArrayCreate([0, Items.Count-1], varVariant);

  for i:=0 to Items.Count-1 do
  begin
    if State[i]=cbChecked then
       result[i]:=FDataLink.DataSet.Lookup(ListField, Items[i], FKeyField);

  end;
end;

function TwzsDBLookupCheckBox.GetKeyValuesString: string;
var
  i: integer;
begin
  for i:=0 to VarArrayHighBound(KeyValues, 1) do
    if not VarIsEmpty(KeyValues[i]) then
      result:=result+VarToStr(KeyValues[i])+FKeyValuesDelimiter;

  q_ReplaceLastStr(result, FKeyValuesDelimiter, '');
end;

destructor TwzsDBLookupCheckBox.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;

  inherited Destroy;
end;

function TwzsDBLookupCheckBox.GetSelListValues: string;
var
  i: integer;
begin
  for i:=0 to Items.Count-1 do
    if Checked[i] then
      result:=result+Items[i]+FKeyValuesDelimiter+' ';

  q_ReplaceLastStr(result, FKeyValuesDelimiter, '');
  result:=Trim(result);
end;

procedure TwzsDBLookupCheckBox.CMMouseEnter(var Message: TMessage);
begin

  if FAdditional.Styler<>nil then
    FAdditional.Styler.DrawFrame(self, message, true);

end;

procedure TwzsDBLookupCheckBox.CMMouseLeave(var Message: TMessage);
begin
  if FAdditional.Styler<>nil then
    FAdditional.Styler.DrawFrame(self, message, true);
end;

procedure TwzsDBLookupCheckBox.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  case Operation of
   opRemove:
     begin
       if AComponent = FAdditional.Styler then
         FAdditional.Styler:=nil;
     end;
  end;

end;

procedure TwzsDBLookupCheckBox.WMNCPaint(var Message: TWMNCPaint);
begin
  if FAdditional.Styler<>nil then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), true);
    message.Result:=0;
  end
    else
  inherited;

end;

end.
