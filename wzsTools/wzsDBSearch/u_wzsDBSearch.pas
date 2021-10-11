{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBSearch;


interface

uses
  Windows, Messages, SysUtils, {$ifdef ver150} Variants, {$endif} Classes, Graphics, Controls, Forms,
  Dialogs, Mask, Buttons, Menus, DB, StdCtrls, DBCtrls,
  u_wzsToolsCommon, u_wzsDBSearchCommon;

{$ifdef ver130}
const
  CS_DROPSHADOW = $20000;
{$endif}

type
  TStyles = (styUltraFlat, stySoftFlat, stySoftBorder, styDefault, styFlatEhlib);
  TListPositions = (lpFirst, lpPrev, lpNext, lpLast);
  //SearchRecordOption = (srForward, srBackward, srFromCurrent, srFromBeginning, srFromEnd, srIgnoreCase, srIgnoreTime, srPartialMatch);
  //SearchRecordOptions = set of SearchRecordOption;

  TwzsDBSearchEdit = class;

  { TwzsDBLookupListBox }
  TwzsCustomPopupLookupListBox = class(TDBLookupListBox)
  private
    FDropShadow: boolean;
  protected
    //procedure CloseUp; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure Paint; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure WMMouseActivare(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
  public
    constructor Create(AOwner: TComponent); override;
    procedure MoveListTo(ListPos: TListPositions);
    property DropShadow: boolean read FDropShadow write FDropShadow;
  published
  end;

  TwzsSearchEditDropDownBox = class(TwzsCustomPopupLookupListBox)
  private
    FSearchEdit: TwzsDBSearchEdit;
  protected
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
  end;

  { TwzsDBLookupListBoxOptions }

  TwzsDropDownBoxOptions = class(TPersistent)
  private
    FSearchEditDropDownBox: TwzsCustomPopupLookupListBox;
    function GetRowCount: integer;
    procedure SetRowCount(Value: integer);
    function GetDropShadow: boolean;
    procedure SetDropShadow(Value: boolean);
  protected
  public
    constructor Create(ADropDownBox: TwzsCustomPopupLookupListBox);
  published
    property RowCount: integer read GetRowCount write SetRowCount default 7;
    property DropShadow: boolean read GetDropShadow write SetDropShadow default false;
  end;

  { TwzsEditButtonOptions }

  TwzsEditButtonOptions = class(TPersistent)
  private
    FSearchEdit: TwzsDBSearchEdit;
    FEditButton: TSpeedButton;
    FShortCut: TShortCut;
    function  GetTransparent: boolean;
    procedure SetTransparent(const Value: boolean);
    function  GetVisible: boolean;
    procedure SetVisible(const Value: boolean);
    function  GetFlat: boolean;
    procedure SetFlat(const Value: boolean);
    function  GetGlyph: TBitmap;
    procedure SetGlyph(const Value: TBitmap);
    function  GetCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
    function  GetWidth: integer;
    procedure SetWidth(const Value: integer);
    function  GetHint: string;
    procedure SetHint(const Value: string);
  protected
  public
    constructor Create(AOwner: TwzsDBSearchEdit; AEditButton: TSpeedButton);
  published
    property Width: integer read GetWidth write SetWidth default 17;
    property Visible: boolean read GetVisible write SetVisible;
    property Flat: boolean read GetFlat write SetFlat default true;
    property Glyph: TBitmap read GetGlyph write SetGlyph;
    property Caption: TCaption read GetCaption write SetCaption;
    property Transparent: boolean read GetTransparent write SetTransparent;
    property Hint: string read GetHint write SetHint;
    property ShortCut: TShortCut read FShortCut write FShortCut;
  end;

  TwzsDBSearchEngine = class;

  { TwzsDBSearchEngine }

  TwzsDBSearchEngine = class(TComponent)
  private
    FAbout: TwzsAboutInfo;
    FDataLink: TDataLink;
    FLocateOptions: TLocateOptions;
    FFilterOptions: TFilterOptions;
    //FSearchRecordOptions: SearchRecordOptions;
    FOnLocated: TNotifyEvent;
    FPartialOnStrings: boolean;
    FFilterExpr: TwzsFilterExprBuilder;
    procedure SetDataSource(Value: TDatasource);
    function GetDataSource: TDataSource;
    function GetPartialOnStrings: boolean;
    procedure SetPartialOnStrings(Value: boolean);

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Filter;
    procedure ClearFilter;
    function Locate(KeyFields: string; KeyValues: Variant): boolean;
    procedure ClearGroup;
    procedure AddFieldsOnGroup;
    property DataLink: TDataLink read FDataLink write FDataLink;
    property FilterExpr: TwzsFilterExprBuilder read FFilterExpr write FFilterExpr;
  published
    property About: TwzsAboutInfo read FAbout write FAbout stored false;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property LocateOptions: TLocateOptions read FLocateOptions write FLocateOptions;
    property FilterOptions: TFilterOptions read FFilterOptions write FFilterOptions;
    //property SearchRecordOptions: SearchRecordOptions read FSearchRecordOptions write FSearchRecordOptions;
    property PartialOnStrings: boolean read GetPartialOnStrings write SetPartialOnStrings default False;
    property OnLocated: TNotifyEvent read FOnLocated write FOnLocated;
  end;

  { TwzsCustomSearchEngineButton }

  TwzsCustomSearchEngineButton = class(TSpeedButton)
  private
    FAbout: TwzsAboutInfo;
    FSearchEngine: TwzsDBSearchEngine;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout stored false;
    property Flat nodefault;
    property SearchEngine: TwzsDBSearchEngine read FSearchEngine write FSearchEngine;
    property OnClick;
  end;

  { TwzsGroupFilterButton }

  TwzsGroupFilterButton = class(TwzsCustomSearchEngineButton)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
  end;

  { TwzsGroupClearButton }

  TwzsGroupClearButton = class(TwzsCustomSearchEngineButton)
  private
    procedure DoClear;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
  end;


  { TwzsDBSearchEdit }

  TwzsDBSearchEdit = class(TCustomEdit)
  private
    FAbout: TwzsAboutInfo;
    FDataField: string;
    FLocateButton: TSpeedButton;
    FFilterButton: TSpeedButton;
    FClearButton: TSpeedButton;
    FDropDownButton: TSpeedButton;
    FLocateButtonOptions: TwzsEditButtonOptions;
    FFilterButtonOptions: TwzsEditButtonOptions;
    FClearButtonOptions: TwzsEditButtonOptions;
    FDropDownButtonOptions: TwzsEditButtonOptions;
    FDynamicLocate: boolean;
    FStyle: TStyles;
    FSearchEngine: TwzsDBSearchEngine;
    FClearText: boolean;
    FDropDownBox: TwzsSearchEditDropDownBox;
    FDropDownBoxOptions: TwzsDropDownBoxOptions;
    FKeyValue: Variant;
    //FButtonsWidth: integer;
    procedure SetDataField(const Value: string);
    procedure LocateButtonClick(Sender: TObject);
    procedure FilterButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DropDownButtonClick(Sender: TObject);
    function CreateEditButton: TSpeedButton;
    procedure SetButtonsPos;
    procedure SetStyle(Value: TStyles);
    procedure SetButtonsProps(Transparent, Flat: boolean);
    procedure SetButtonsHints;
    procedure CloseUp;
    procedure DropDown;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure SetSearchEngine(Value: TwzsDBSearchEngine);
    function GetField: TField;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure SetKeyValue(Value: Variant);
  protected
    procedure Loaded; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Change; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetButtonsWidth: integer;
    //procedure ActiveChanged(Sender: TObject);
    procedure WMNCPaint(var Message: TWMNCPaint); message WM_NCPAINT;
  public
    constructor Create(AOwner: TComponent); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function GetDisplayLabel: string;
    property KeyValue: Variant read FKeyValue write SetKeyValue;
  published
    property About: TwzsAboutInfo read FAbout write FAbout stored false;
    property DataField: string read FDataField write SetDataField;
    property LocateButton: TwzsEditButtonOptions read FLocateButtonOptions write FLocateButtonOptions;
    property FilterButton: TwzsEditButtonOptions read FFilterButtonOptions write FFilterButtonOptions;
    property ClearButton: TwzsEditButtonOptions read FClearButtonOptions write FClearButtonOptions;
    property DropDownButton: TwzsEditButtonOptions read FDropDownButtonOptions write FDropDownButtonOptions;
    property DynamicLocate: boolean read FDynamicLocate write FDynamicLocate;
    property Style: TStyles read FStyle write SetStyle default styUltraFlat;
    property SearchEngine: TwzsDBSearchEngine read FSearchEngine write SetSearchEngine;
    property ClearText: boolean read FClearText write FClearText default true;
    property DropDownBox: TwzsDropDownBoxOptions read FDropDownBoxOptions write FDropDownBoxOptions;

    property Text;
    property Enabled;
    property ReadOnly;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property Visible;
    property OnChange;
    property TabOrder;

  end;


procedure Register;

implementation

uses qStrings, u_wzsDBSearchConsts;

const
 cButtonWidth=17;
 cVertBorderFix=4;
 cHorBorderFix=0;
 cOperChars='<>=';

procedure Register;
begin
  RegisterComponents('wzsTools',
    [TwzsDBSearchEdit, TwzsDBSearchEngine,
     TwzsGroupFilterButton, TwzsGroupClearButton]);
end;

{ TwzsDBSearchEdit }

constructor TwzsDBSearchEdit.Create(AOwner: TComponent);
begin
 inherited Create(Aowner);

 ControlStyle := ControlStyle + [csReplicatable] - [csSetCaption];

 FDropDownBox:=TwzsSearchEditDropDownBox.Create(self);
 FDropDownBox.Parent:=self;
 
 FDynamicLocate:=false;
 FStyle:=styUltraFlat;

 AutoSize:=false;

 FLocateButton:=CreateEditButton;
 FFilterButton:=CreateEditButton;
 FClearButton:=CreateEditButton;
 FDropDownButton:=CreateEditButton;

 FLocateButton.OnClick:=LocateButtonClick;
 FFilterButton.OnClick:=FilterButtonClick;
 FClearButton.OnClick:=ClearButtonClick;
 FDropDownButton.OnClick:=DropDownButtonClick;

 FLocateButton.Glyph.LoadFromResourceName(HInstance, 'bmpLocate_1');
 FFilterButton.Glyph.LoadFromResourceName(HInstance, 'bmpFilter_1');
 FClearButton.Glyph.LoadFromResourceName(HInstance, 'bmpClear_1');
 FDropDownButton.Glyph.LoadFromResourceName(HInstance, 'bmpDropDown_1');

 FLocateButtonOptions:=TwzsEditButtonOptions.Create(self, FLocateButton);
 FFilterButtonOptions:=TwzsEditButtonOptions.Create(self, FFilterButton);
 FClearButtonOptions:=TwzsEditButtonOptions.Create(self, FClearButton);
 FDropDownButtonOptions:=TwzsEditButtonOptions.Create(self, FDropDownButton);

 FLocateButtonOptions.ShortCut:=TextToShortCut('Ctrl+L');
 FFilterButtonOptions.ShortCut:=TextToShortCut('Enter');
 FClearButtonOptions.ShortCut:=TextToShortCut('Esc');
 FDropDownButtonOptions.ShortCut:=TextToShortCut('Alt+Down');

 FDropDownBoxOptions:=TwzsDropDownBoxOptions.Create(FDropDownBox);

 FClearText:=true;

 Height:=21;

 SetStyle(FStyle);
 SetButtonsPos;

end;

procedure TwzsDBSearchEdit.Change;
begin
  inherited Change;

  if (FDynamicLocate) and (FSearchEngine <> nil) then
   FSearchEngine.Locate(FDataField, Text);
end;

procedure TwzsDBSearchEdit.SetDataField(const Value: string);
begin
  if FDataField<>Value then
   begin
    FDataField:=Value;

    if (csDesigning in ComponentState) and (GetField<>nil) then
     case GetField.FieldKind of
      fkLookup: FDropDownButtonOptions.Visible:=true;
      fkData: FDropDownButtonOptions.Visible:=false;
     end;
         
    SetButtonsHints;
   end;

end;


procedure TwzsDBSearchEdit.SetButtonsHints;
begin
  //FFilterButton.Hint:=Format(SFilterButtonHint, [GetDisplayLabel]);
  //FLocateButton.Hint:=Format(SLocateButtonHint, [GetDisplayLabel]);
  //FClearButton.Hint:=SClearButtonHint;

  FFilterButtonOptions.Hint:=Format(SFilterButtonHint,
    [GetDisplayLabel, ShortCutToText(FFilterButtonOptions.ShortCut)]);

  FLocateButtonOptions.Hint:=Format(SLocateButtonHint,
    [GetDisplayLabel, ShortCutToText(FLocateButtonOptions.ShortCut)]);

  FClearButtonOptions.Hint:=Format(SClearButtonHint,
    [ShortCutToText(FClearButtonOptions.ShortCut)]);

  {
  if FFilterButtonOptions.ShortCut<>0 then
    FFilterButtonOptions.Hint:=FFilterButtonOptions.Hint+
    ' ('+ShortCutToText(FFilterButtonOptions.ShortCut)+')';

  if FLocateButtonOptions.ShortCut<>0 then
    FLocateButtonOptions.Hint:=FLocateButtonOptions.Hint+
    ' ('+ShortCutToText(FLocateButtonOptions.ShortCut)+')';

  if FClearButtonOptions.ShortCut<>0 then
    FClearButtonOptions.Hint:=FClearButtonOptions.Hint+
    ' ('+ShortCutToText(FClearButtonOptions.ShortCut)+')';
  }

end;


procedure TwzsDBSearchEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  //not my code ;)
  Params.Style := Params.Style or WS_CLIPCHILDREN;

end;


procedure TwzsDBSearchEdit.WMSize(var Message: TWMSize);
begin
 inherited;
 
 SetButtonsPos;
end;


procedure TwzsDBSearchEdit.SetSearchEngine(Value: TwzsDBSearchEngine);
begin
 FSearchEngine:=Value;
end;


procedure TwzsDBSearchEdit.LocateButtonClick(Sender: TObject);
begin
 if FSearchEngine<>nil then
  FSearchEngine.Locate(FDataField, Text);

 SetFocus;
 SelectAll;
end;

procedure TwzsDBSearchEdit.FilterButtonClick(Sender: TObject);
begin
  if FSearchEngine<>nil then
  begin
   FSearchEngine.AddFieldsOnGroup;
   FSearchEngine.Filter;
  end;

  SetFocus;
  SelectAll;
end;

function TwzsDBSearchEdit.CreateEditButton: TSpeedButton;
begin

 result:=TSpeedButton.Create(self);
 result.Parent:=self;
 result.Visible:=true;
 result.Height:=Height-cVertBorderFix;
 result.Flat:=true;
 result.Transparent:=false;
 result.Cursor:=crArrow;
 result.Width:=cButtonWidth;
 result.ShowHint:=true;

 //result.Glyph.LoadFromResourceName(HInstance, 'searchglyph');

end;
{
procedure TwzsDBSearchEdit.Filter;
begin

 if IsSearchEngineAssigned then
  begin
   //FSearchEngine.DataSource.DataSet.FilterOptions:=FFilterOptions;
   FSearchEngine.DataSource.DataSet.Filter:=GetFilterString;
   FSearchEngine.DataSource.DataSet.Filtered:=true;
  end;

end;
}




procedure TwzsDBSearchEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
   begin
     if AComponent = FSearchEngine then
        FSearchEngine:=nil;
//     if AComponent = FGroupFilterButton then
//        FGroupFilterButton:= nil;
   end;

end;

function TwzsDBSearchEdit.GetButtonsWidth: integer;
var
  i: integer;
begin
  result:=0;
  
  for i:=0 to ControlCount-1 do
   if (Controls[i].Visible) and (Controls[i] is TSpeedButton) then
    inc(result, Controls[i].Width);

end;

procedure TwzsDBSearchEdit.SetButtonsPos;
var
 i, w: integer;

begin
 w:=Width-4;

 for i:=0 to ControlCount-1 do
  if (Controls[i].Visible) and (Controls[i] is TSpeedButton) then
   begin
    Controls[i].Left:=w - Controls[i].Width - cHorBorderFix;
    w:=Controls[i].Left;
    Controls[i].Height:=Height-cVertBorderFix;
   end;

end;

procedure TwzsDBSearchEdit.SetStyle(Value: TStyles);
begin
 if Value<>FStyle then
 begin
   FStyle:=Value;

   case FStyle of
    styUltraFlat:
     begin
       BorderStyle:=bsNone;
       BevelInner:=bvSpace;
       BevelKind:=bkFlat;
       BevelOuter:=bvLowered;
       SetButtonsProps(True, True);
     end;
    stySoftFlat:
     begin
       BorderStyle:=bsNone;
       BevelInner:=bvLowered;
       BevelKind:=bkFlat;
       BevelOuter:=bvLowered;
       SetButtonsProps(True, True);
     end;
    stySoftBorder:
     begin
       BorderStyle:=bsNone;
       BevelInner:=bvSpace;
       BevelKind:=bkTile;
       BevelOuter:=bvLowered;
       SetButtonsProps(True, True);
     end;
    styDefault:
     begin
       BorderStyle:=bsSingle;
       BevelKind:=bkNone;
       SetButtonsProps(false, false);
     end;
    styFlatEhlib:
     begin
       BorderStyle:=bsNone;
       BevelInner:=bvLowered;
       BevelKind:=bkSoft;
       BevelOuter:=bvSpace;
       SetButtonsProps(true, true);
     end;
   end;
 end;
 
end;

procedure TwzsDBSearchEdit.SetButtonsProps(Transparent, Flat: boolean);
var
  i: integer;
  b: TSpeedButton;
begin
  if (csDesigning in ComponentState) then
   for i:=0 to ControlCount-1 do
    if Controls[i] is TSpeedButton then
     begin
      b:=Controls[i] as TSpeedButton;
      b.Transparent:=Transparent;
      b.Flat:=Flat;
     end;
end;

procedure TwzsDBSearchEdit.DropDownButtonClick(Sender: TObject);
begin
 DropDown;
end;

procedure TwzsDBSearchEdit.DropDown;
var
 recCount: integer;

begin
 SetFocus;

 if (GetField<>nil) and (GetField.FieldKind=fkLookup) then
  begin
   FDropDownBox.ListSource:=TDataSource.Create(self);
   FDropDownBox.ListSource.DataSet:=GetField.LookupDataSet;
   FDropDownBox.KeyField:=GetField.LookupKeyFields;
   FDropDownBox.ListField:=GetField.LookupResultField;

   recCount:=FDropDownBox.ListSource.DataSet.RecordCount;

   if DropDownBox.RowCount > recCount  then
     DropDownBox.RowCount:= recCount;

   FDropDownBox.KeyValue:=null;

   FDropDownBox.ListLink.DataSet.Locate(GetField.LookupKeyFields, FKeyValue,
      FSearchEngine.LocateOptions);

  end;

 FDropDownBox.Width:=Width;

 SetWindowPos(FDropDownBox.Handle, HWND_TOP,
      ClientOrigin.x - 2,
      ClientOrigin.y + Height - 3,
      0, 0,
      SWP_NOSIZE or SWP_SHOWWINDOW or SWP_NOACTIVATE);

 FDropDownBox.Visible:=true;
end;



procedure TwzsDBSearchEdit.CMCancelMode(var Message: TCMCancelMode);
begin

  if (Message.Sender <> Self) and (Message.Sender <> FDropDownBox) then
      FDropDownBox.Visible:=false; 
end;

{
procedure TwzsDBSearchEdit.SetLookupValue(Index: integer);
begin
  Text:=FLookupValues[Index];
  KeyValue:=FLookupKeyValues[Index];
end;
}

function TwzsDBSearchEdit.GetDisplayLabel: string;
begin
 if (FSearchEngine<>nil) and (FDataField<>'') then
  result:=FSearchEngine.DataLink.DataSet.FindField(FDataField).DisplayLabel
 else
  result:='(DataField is not defined)';
end;

procedure TwzsDBSearchEdit.SetKeyValue(Value: Variant);
var
 dataset: TDataset;
 keyfields, listfield: string;
begin
 FKeyValue:=Value;

 if (GetField<>nil) and (GetField.FieldKind=fkLookup) then
     begin
      dataset:=GetField.LookupDataSet;
      keyfields:=GetField.LookupKeyFields;
      listfield:=GetField.LookupResultField;
      if dataset.Locate(keyfields, Value, [loCaseInsensitive]) then
        Text:=dataset.FindField(listfield).AsString;
     end;
  
end;

procedure TwzsDBSearchEdit.WMNCPaint(var Message: TWMNCPaint);
{wz 25 dec 2009
Code of this handler is written just to make this control
compatible with TDBEditEh flat style, bacause flat EhLib
controls already used in my favorite working projects. So
lets change the control to EhLib-look style...
}
var
  FCanvas: TControlCanvas;
	dc : hDc;
	Pen : hPen;
	OldPen : hPen;
	OldBrush : hBrush;

begin
	inherited;

  if Style = styFlatEhlib then
   begin
    FCanvas := TControlCanvas.Create;
    FCanvas.Control := self;

    dc := GetWindowDC(Handle);
    message.Result := 1;
    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(clBtnFace));
    OldPen:=SelectObject(dc, Pen);
    OldBrush := SelectObject(dc, GetStockObject(NULL_BRUSH));

    Rectangle(dc, 1, 1, Width-1, Height-1);

    Pen := CreatePen(PS_SOLID, 1, ColorToRGB(clWhite));
    OldPen:=SelectObject(dc, Pen);

    MoveToEx(dc, 0, Height-1, nil);
    LineTo(dc, Width-1, Height-1);
    LineTo(dc, Width-1, 0);

    SelectObject(dc, OldBrush);
    SelectObject(dc, OldPen);
    DeleteObject(Pen);
    ReleaseDC(Handle, FCanvas.Handle);
   end;

end;

procedure TwzsDBSearchEdit.CloseUp;
begin
  KeyValue:=FDropDownBox.ListLink.DataSet.FindField(FDropDownBox.KeyField).AsString;
  //KeyValue:=VarToStr(FDropDownBox.KeyValue);

  FDropDownBox.Visible:=false;

end;

{ TwzsEditButtonOptions }

function TwzsEditButtonOptions.GetCaption: TCaption;
begin
  result:=FEditButton.caption;
end;

function TwzsEditButtonOptions.GetFlat: boolean;
begin
 result:=FEditButton.Flat;
end;

function TwzsEditButtonOptions.GetGlyph: TBitmap;
begin
 result:=FEditButton.Glyph;
end;

function TwzsEditButtonOptions.GetVisible: boolean;
begin
 result:= FEditButton.Visible;
end;

function TwzsEditButtonOptions.GetWidth: integer;
begin
 result:= FEditButton.Width;
end;

procedure TwzsEditButtonOptions.SetCaption(const Value: TCaption);
begin
 FEditButton.Caption:=Value;
end;

procedure TwzsEditButtonOptions.SetFlat(const Value: boolean);
begin
 FEditButton.Flat:=Value;
end;

procedure TwzsEditButtonOptions.SetGlyph(const Value: TBitmap);
begin
 FEditButton.Glyph := Value;
end;

procedure TwzsEditButtonOptions.SetVisible(const Value: boolean);
begin
 FEditButton.Visible:=value;

 if Value then
  FEditButton.Top:=0
 else
  FEditButton.Top:=-99;  //this is the way how we can hide speedbutton in design-time!

 //ShowWindow(FEditButton.Handle, SW_SHOW)
 //ShowWindow(FEditButton.Handle, SW_HIDE);

 FSearchEdit.SetButtonsPos;
end;


procedure TwzsEditButtonOptions.SetWidth(const Value: integer);
begin
 FEditButton.width:=value;
 FSearchEdit.SetButtonsPos;
end;

function TwzsEditButtonOptions.GetTransparent: boolean;
begin
 result:= FEditButton.Transparent;
end;

procedure TwzsEditButtonOptions.SetTransparent(const Value: boolean);
begin
 FEditButton.Transparent:=Value;
end;


function TwzsEditButtonOptions.GetHint: string;
begin
 result:=FEditButton.Hint;
end;

procedure TwzsEditButtonOptions.SetHint(const Value: string);
begin
 FEditButton.Hint:=Value;
end;

constructor TwzsEditButtonOptions.Create(AOwner: TwzsDBSearchEdit; AEditButton: TSpeedButton);
begin
  inherited Create;
  FSearchEdit:=AOwner;
  FEditButton:=AEditButton;
end;

{ TwzsCustomSearchEngineButton }

constructor TwzsCustomSearchEngineButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Flat:=true;
  ShowHint:=true;
end;

procedure TwzsCustomSearchEngineButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if Operation = opRemove then
   begin
     if AComponent = FSearchEngine then
        FSearchEngine := nil;
   end;

end;


{ TwzsDBSearchEngine }

{
function TwzsDBSearchEngine.BuildFilterString(FieldNames,
  Values: TStrings): string;
var
 resStr, valStr, operStr: string;
 i: integer;

begin
  resStr:='';

  for i:=0 to FieldNames.Count-1 do
   begin
    if (FieldNames.Strings[i]<>'') and (Values.Strings[i]<>'') then
     begin
       operStr:=Values.Strings[i];
       valStr:=Values.Strings[i];
       q_KeepChars(operStr, cOperChars);
       q_DelChars(valStr, cOperChars);
       if operStr='' then operStr:='=';

       case FDataLink.DataSet.FindField(FieldNames.Strings[i]).DataType of
        ftString, ftDate, ftTime, ftDateTime:
         valStr:=''''+valStr+'''';
       end;

       resStr:=resStr+'('+FieldNames.Strings[i]+' '+operStr+' '+valStr+')';
     end;
   end;

  resStr:=q_replaceText(resStr, ')(', ') and (');


  result:=resStr;

end;
}

procedure TwzsDBSearchEngine.Filter;
begin

 if FDataLink.DataSet<>nil then
  begin
   FDataLink.DataSet.Cancel;
   FDataLink.DataSet.Filter:=FFilterExpr.GetFieldsFilterStr;

   //showmessage(FDataLink.DataSet.Filter);

   if FDataLink.DataSet.Filter<>'' then
    FDataLink.DataSet.Filtered:=true;

  end;

end;

procedure TwzsDBSearchEngine.ClearFilter;
begin
 if (FDataLink.DataSet<>nil) and (FDataLink.DataSet.Filtered) then
  begin
   FDataLink.DataSet.Cancel;
   FDataLink.DataSet.Filter:='';
   FDataLink.DataSet.Filtered:=false;
  end;
end;

constructor TwzsDBSearchEngine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLocateOptions:=[loCaseInsensitive, loPartialKey];
  FFilterOptions:=[foCaseInsensitive];

  FDataLink:=TDataLink.Create;
  
  FFilterExpr:=TwzsFilterExprBuilder.Create(self);

  FPartialOnStrings:=false;  
end;

procedure TwzsDBSearchEngine.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  {    если пользуемся даталинком нотификейшена не надо?
  if Operation = opRemove then
   begin
     if AComponent = FDataSource then
        FDataSource := nil;
   end;
  }
end;


procedure TwzsDBSearchEngine.SetDataSource(Value: TDatasource);
begin

 FDataLink.DataSource:=Value;

 if FDataLink.DataSet<>nil then
  FDataLink.DataSet.FilterOptions:=FFilterOptions;

end;

function TwzsDBSearchEngine.Locate(KeyFields: string; KeyValues: Variant): boolean;
begin
  result:=false;

  if (FDataLink.DataSet<>nil) and (KeyFields<>'') and
     (FDataLink.DataSet.Active) and (VarToStr(KeyValues)<>'') then
   begin
    FDataLink.DataSet.Cancel;
    result:=FDataLink.DataSet.Locate(KeyFields, KeyValues, FLocateOptions);
   end;

  if (result) and (assigned(FOnLocated)) then
   OnLocated(self);

end;

procedure TwzsDBSearchEdit.ClearButtonClick(Sender: TObject);
begin
 if FSearchEngine<>nil then
  begin
   FSearchEngine.ClearGroup;
   FSearchEngine.ClearFilter;
  end; 

 SetFocus;
end;


constructor TwzsGroupFilterButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Hint:=SGroupFilterButtonHint;
  Glyph.LoadFromResourceName(HInstance, 'bmpFilter_2');

end;

function TwzsDBSearchEngine.GetDataSource: TDatasource;
begin
 result:=FDataLink.DataSource;
end;

{
function TwzsDBSearchEngine.GetFilterString(
  DBSearchEdit: TwzsDBSearchEdit): string;
var
 f, v, resStr, operStr, valStr: string;

begin
 resStr:='';

 f:=DBSearchEdit.GetSearchFieldName;
 v:=DBSearchEdit.GetSearchValue;

 if (DBSearchEdit.GetField<>nil) and (v<>'') then
  begin

   operStr:=v;
   valStr:=v;
   q_KeepChars(operStr, cOperChars);
   q_DelChars(valStr, cOperChars);
   if operStr='' then
    operStr:='=';

   if (FPartialOnStrings) and (FDataLink.DataSet.FindField(f).DataType = ftString) then
    valStr:='*'+valStr+'*';
    
   case FDataLink.DataSet.FindField(f).DataType of
    ftString, ftDate, ftTime, ftDateTime:
     valStr:=''''+valStr+'''';
   end;

   resStr:=resStr+'('+f+' '+operStr+' '+valStr+')';

  end;

  result:=resStr;
end;
}

{ TwzsGroupClearButton }


procedure TwzsGroupClearButton.Click;
begin
  inherited;
  DoClear;
end;

constructor TwzsGroupClearButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Hint:=SGroupClearButtonHint;
  Glyph.LoadFromResourceName(HInstance, 'bmpClear_2');
end;

procedure TwzsGroupClearButton.DoClear;
begin
 if FSearchEngine<>nil then
  begin
   FSearchEngine.ClearGroup;
   FSearchEngine.ClearFilter;
  end;
end;

{ TwzsDBLookupListBox }

constructor TwzsCustomPopupLookupListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  ControlStyle := ControlStyle + [csNoDesignVisible, csReplicatable];
  Visible:=false;

end;

procedure TwzsCustomPopupLookupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
  begin
    Style :=Style or WS_POPUP or WS_VSCROLL or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
    WindowClass.Style:=CS_SAVEBITS;
    if FDropShadow then
      WindowClass.Style:=WindowClass.Style or CS_DROPSHADOW;
  end;

end;

procedure TwzsCustomPopupLookupListBox.WMKillFocus(var Message: TWMKillFocus);
begin
 Parent.SetFocus;

 inherited;
end;


procedure TwzsCustomPopupLookupListBox.Paint;
var
  y: integer;
  r: TRect;
  s: string;

begin
  inherited Paint;

  s:=ListLink.DataSet.FindField(ListField).Value;
  y:=ListLink.ActiveRecord*GetTextHeight;

  r:=rect(0, y, ClientWidth, y+GetTextHeight);

  Canvas.Brush.Color:=clHighlight;
  Canvas.FillRect(r);
  Canvas.Font.Color:=clHighlightText;
  Canvas.TextRect(r, 2, y, s);

end;

function TwzsDBSearchEdit.GetField: TField;
begin
 result:=nil;
 if (FSearchEngine<>nil) and (FDataField<>'') then
  result:=FSearchEngine.DataLink.DataSet.FindField(FDataField);
end;

procedure TwzsCustomPopupLookupListBox.MoveListTo(ListPos: TListPositions);
begin
 case ListPos of
  lpPrev: ListLink.DataSet.MoveBy(-1);
  lpNext: ListLink.DataSet.MoveBy(1);
  lpFirst: ListLink.DataSet.First;
  lpLast: ListLink.DataSet.Last;
 end;

end;

procedure TwzsCustomPopupLookupListBox.WMMouseActivare(
  var Message: TWMMouseActivate);
begin
  Message.Result:=MA_NOACTIVATE;
end;

procedure TwzsCustomPopupLookupListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  line: integer;
begin
  line:=Y div GetTextHeight;

  if (ListLink.DataSet <> nil) and (ListLink.DataSet.Active) then
    ListLink.DataSet.MoveBy(line-ListLink.ActiveRecord);

  inherited MouseMove(Shift, X, Y);
end;

{ TwzsDBLookupListBoxOptions }

constructor TwzsDropDownBoxOptions.Create(ADropDownBox: TwzsCustomPopupLookupListBox);
begin
  inherited Create;

  FSearchEditDropDownBox:=ADropDownBox;
end;


procedure TwzsGroupFilterButton.Click;
begin
  inherited Click;

  if FSearchEngine<>nil then
  begin
    FSearchEngine.AddFieldsOnGroup;
    FSearchEngine.Filter;
  end;
end;

procedure TwzsDBSearchEngine.ClearGroup;
var
 i: integer;
 c: TwzsDBSearchEdit;
 list: TStrings;

begin
 list:=GetComponentsList(Owner, TwzsDBSearchEdit);

 for i:=0 to list.Count-1 do
  begin
   c:=list.Objects[i] as TwzsDBSearchEdit;
   if (c.SearchEngine=self) and (c.ClearText) then
     c.Text:='';
  end;   
end;

procedure TwzsDBSearchEdit.Loaded;
begin
  inherited Loaded;

  SendMessage( Handle, em_SetMargins, ec_LeftMargin, 0 );
  SendMessage( Handle, em_SetMargins, ec_RightMargin, MakeLong(0, GetButtonsWidth + 2 ));
end;

procedure TwzsDBSearchEdit.KeyDown(var Key: Word; Shift: TShiftState);
var
  bKey: word;
  bShift: TShiftState;
begin

  if (FDropDownBox<>nil) and (FDropDownBox.Visible) then
   begin
    case Key of
     VK_ESCAPE: FDropDownBox.Visible:=false;
     VK_RETURN: CloseUp;
     VK_UP: FDropDownBox.MoveListTo(lpPrev);
     VK_DOWN: FDropDownBox.MoveListTo(lpNext);
     VK_HOME: FDropDownBox.MoveListTo(lpFirst);
     VK_END: FDropDownBox.MoveListTo(lpLast);
    end;
   end
  else
   begin
    inherited KeyDown(Key, Shift);

    ShortCutToKey(FFilterButtonOptions.ShortCut, bKey, bShift);
    if (Key = bKey) and (Shift = bShift) then
     FilterButtonClick(self);

    ShortCutToKey(FLocateButtonOptions.ShortCut, bKey, bShift);
    if (Key = bKey) and (Shift = bShift) then
     LocateButtonClick(self);

    ShortCutToKey(FClearButtonOptions.ShortCut, bKey, bShift);
    if (Key = bKey) and (Shift = bShift) then
     ClearButtonClick(self);

    ShortCutToKey(FDropDownButtonOptions.ShortCut, bKey, bShift);
    if (Key = bKey) and (Shift = bShift) then
     DropDownButtonClick(self);
   end;
end;

procedure TwzsDBSearchEngine.AddFieldsOnGroup;
var
 clist: TStrings;
 i: integer;
 c: TwzsDBSearchEdit;

begin
 clist:=GetComponentsList(Owner, TwzsDBSearchEdit);

 FFilterExpr.Fields.Clear;

 for i:=0 to clist.Count-1 do
  begin
   c:=clist.Objects[i] as TwzsDBSearchEdit;
   if c.SearchEngine=self then
     FFilterExpr.AddField(c.GetField, c.Text);
  end;

end;

function TwzsDBSearchEngine.GetPartialOnStrings: boolean;
begin
  result:=FFilterExpr.PartialOnStrings;
end;

procedure TwzsDBSearchEngine.SetPartialOnStrings(Value: boolean);
begin
  FFilterExpr.PartialOnStrings:=Value;
end;

function TwzsDropDownBoxOptions.GetDropShadow: boolean;
begin
  result:=FSearchEditDropDownBox.DropShadow;
end;

function TwzsDropDownBoxOptions.GetRowCount: integer;
begin
  result:=FSearchEditDropDownBox.RowCount;
end;

procedure TwzsDropDownBoxOptions.SetDropShadow(Value: boolean);
begin
  FSearchEditDropDownBox.DropShadow:=Value;
end;

procedure TwzsDropDownBoxOptions.SetRowCount(Value: integer);
begin
  FSearchEditDropDownBox.RowCount:=Value;
end;

{ TwzsSearchEditDropDownBox }


constructor TwzsSearchEditDropDownBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSearchEdit:=AOwner as TwzsDBSearchEdit;
end;


procedure TwzsSearchEditDropDownBox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  
  FSearchEdit.CloseUp;
end;

end.


