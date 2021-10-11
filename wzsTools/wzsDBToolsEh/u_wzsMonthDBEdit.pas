{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsMonthDBEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, DBCtrlsEh, ToolCtrlsEh, Dialogs,
  {$ifdef ver150} Variants, {$endif}
  Windows, u_wzsToolsCommon;

resourcestring
  SEditButtonHint='¬ыбрать мес€ц';
  SScrollButtonHint='—ледующий/предыдущий мес€ц (стрелки ¬верх/¬низ)';
  SDefaultLineText='(текущий)';
  SNullLineText='(все периоды)';

type
  TFormatTypes=(ftMonthYear, ftYearMonth);

  TwzsMonthDBEdit = class(TCustomDBComboBoxEh)
  private
    FAbout: TwzsAboutInfo;
    //FDate: TDate;
    FValue: Variant;
    FDay, FMonth, FYear: word;
    FScrollButton: TEditButtonEh;
    FMonthFormat, FYearFormat, FDelimiter: string;
    FFormatType: TFormatTypes;
    FDefaultDate: TDate;
    FDefaultLineVisible: boolean;
    FDefaultLineText: string;
    FNullLineText: string;
    FNullLineVisible: boolean;
    procedure SetValue(Value: Variant);
    function BuildMonthList: TStrings;
    function BuildDate: TDate;
    function GetFormatString: string;
    procedure SetMonthFormat(const Value: string);
    procedure SetYearFormat(const Value: string);
    procedure SetDelimiter(const Value: string);
    procedure SetFormatType(const Value: TFormatTypes);
    procedure SetMonth(Value: integer);
    procedure SetDefaultDate(Value: TDate);
    procedure SetDefaultLineVisible(Value: boolean);
    procedure SetDefaultLineText(Value: string);
    procedure SetNullLineText(Value: string);
    procedure SetNullLineVisible(Value: boolean);
    property ReadOnly; //moved here to exclude this prop from public access
  protected
    procedure Loaded; override;
    //procedure Change; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DataChanged; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure EditButtonDown(Sender: TObject; TopButton: Boolean;
           var AutoRepeat: Boolean; var Handled: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    //property Date: TDate read FDate write SetDate;
    property Value: Variant read FValue write SetValue;
    procedure CloseUp(Accept: boolean); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property MonthFormat: string read FMonthFormat write SetMonthFormat;
    property YearFormat: string read FYearFormat write SetYearFormat;
    property Delimiter: string read FDelimiter write SetDelimiter;
    property FormatType: TFormatTypes read FFormatType write SetFormatType;
    property DefaultDate: TDate read FDefaultDate write SetDefaultDate;
    property DefaultLineVisible: boolean read FDefaultLineVisible write SetDefaultLineVisible default true;
    property DefaultLineText: string read FDefaultLineText write SetDefaultLineText;
    property NullLineText: string read FNullLineText write SetNullLineText;
    property NullLineVisible: boolean read FNullLineVisible write SetNullLineVisible default true;

    property Alignment;
    property AlwaysShowBorder;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    //property DataField;
    //property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownBox;
    property Enabled;
    property EditButton;
    property EditButtons;
    property Font;
    property Flat;
    {$ifdef ver150} property HighlightRequired; {$endif}
    property ImeMode;
    property ImeName;
    //property Items;
    //property KeyItems;
    //property MaxLength;
    property MRUList;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    //property Text;
    property Visible;
    //property WordWrap;
    //property OnButtonClick;
    //property OnButtonDown;
    property OnChange;
    //property OnCheckDrawRequiredState;
    property OnClick;
    property OnCloseUp;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    //property OnGetImageIndex;
    //property OnGetItemImageIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNotInList;
    //property OnUpdateData;
    property OnStartDock;
    property OnStartDrag;
  end;

procedure Register;

implementation

const
  ScrollButtonIndex=1;

procedure Register;
begin
  RegisterComponents('wzsTools', [TwzsMonthDBEdit]);
end;

{ TwzsMonthDBEdit }

constructor TwzsMonthDBEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  DropDownBox.Rows:=12;
  EditButton.Hint:=SEditButtonHint;
  EditButton.Width:=16;

  FScrollButton:=EditButtons.Add;
  FScrollButton.Hint:=SScrollButtonHint;
  FScrollButton.Style:=ebsUpDownEh;
  FScrollButton.Width:=16;

  FMonthFormat:='mmmm';
  FYearFormat:='yyyy';
  FDelimiter:=',';

  FValue:=null;

  FDefaultDate:=Now;
  FDefaultLineVisible:=true;
  FDefaultLineText:=SDefaultLineText;

  FNullLineText:=SNullLineText;
  FNullLineVisible:=true;
  
  Items:=BuildMonthList;

  ReadOnly:=true;
end;


procedure TwzsMonthDBEdit.Loaded;
begin
  inherited Loaded;
end;

procedure TwzsMonthDBEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  
    case Key of
      VK_UP: SetMonth(FMonth+1);
      VK_DOWN: SetMonth(FMonth-1);
    end;

end;

function TwzsMonthDBEdit.BuildMonthList: TStrings;
var
  d: TDate;
  i: integer;
  l: TStrings;

begin
  l:=TStringList.Create;

  if FDefaultLineVisible then
    l.Add(FDefaultLineText);

  if FNullLineVisible then
    l.Add(FNullLineText);

  for i:=1 to 12 do
   begin
    d:=EncodeDate(2000, i, 1);
    l.Add(FormatDateTime(FMonthFormat, d));
   end;

  result:=l; 
end;

function TwzsMonthDBEdit.BuildDate: TDate;
begin
  result:=EncodeDate(FYear, FMonth, FDay);
end;


function TwzsMonthDBEdit.GetFormatString: string;
begin
  case FFormatType of
   ftMonthYear: result:=FMonthFormat+FDelimiter+' '+FYearFormat;
   ftYearMonth: result:=FYearFormat+FDelimiter+' '+FMonthFormat;
  end;
end;

procedure TwzsMonthDBEdit.SetDelimiter(const Value: string);
begin
  FDelimiter:=Value;
  SetValue(FValue);
end;

procedure TwzsMonthDBEdit.SetFormatType(const Value: TFormatTypes);
begin
  FFormatType:=value;
  SetValue(FValue);
end;

procedure TwzsMonthDBEdit.SetMonthFormat(const Value: string);
begin
  FMonthFormat:=value;
  SetValue(FValue);
end;

procedure TwzsMonthDBEdit.SetYearFormat(const Value: string);
begin
  FYearFormat:=value;
  SetValue(FValue);
end;    

procedure TwzsMonthDBEdit.EditButtonDown(Sender: TObject;
  TopButton: Boolean; var AutoRepeat, Handled: Boolean);
var
  btn: TEditButtonControlEh;
begin
  inherited EditButtonDown(Sender, TopButton, AutoRepeat, Handled);

  btn:=sender as TEditButtonControlEh;

  if btn = FEditButtonControlList[ScrollButtonIndex].EditButtonControl then
   begin
    if TopButton then
     SetMonth(FMonth+1)
    else
     SetMonth(FMonth-1);

    Handled:=true;
   end;
end;

procedure TwzsMonthDBEdit.DataChanged;
begin
  inherited DataChanged;
end;

procedure TwzsMonthDBEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  //showmessage(AComponent.Name);
end;

procedure TwzsMonthDBEdit.SetValue(Value: Variant);
begin
  FValue:=Value;

  if FValue = null then
  begin
    Text:=FNullLineText
  end
   else
  begin
    DecodeDate(FValue, FYear, FMonth, FDay);
    FDay:=1;
    FValue:=BuildDate;
    Text:=FormatDateTime(GetFormatString, FValue);
  end;


end;

{
procedure TwzsMonthDBEdit.SetDate(Value: TDate);
begin
  DecodeDate(Value, FYear, FMonth, FDay);
  FDay:=1;
  FDate:=BuildDate;
  FValue:=FDate;
  Text:=FormatDateTime(GetFormatString, FDate);
end;
}

procedure TwzsMonthDBEdit.CloseUp(Accept: boolean);
var
  SelIdx, Month: integer;
  v: Variant;
begin
  ReadOnly:=false;

  inherited CloseUp(Accept);

  SelIdx:=Items.IndexOf(Text);

  if SelIdx > -1 then
  begin
    if (FDefaultLineVisible) and (SelIdx=0) then
      v:=FDefaultDate;

    if ((FDefaultLineVisible) and (FNullLineVisible) and (SelIdx=1)) or
       ((not FDefaultLineVisible) and (FNullLineVisible) and (SelIdx=0)) then
      v:=null;

    Month:=SelIdx-ord(FDefaultLineVisible)-ord(FNullLineVisible)+1;

    if (Month >= 1) and (Month <= 12) then
    begin
      FMonth:=Month;
      v:=BuildDate;
    end;

    SetValue(v);
    
    if v=null then
      Change;
  end;

  ReadOnly:=true;

end;

procedure TwzsMonthDBEdit.SetMonth(Value: integer);
begin
  FMonth:=Value;

  if FMonth=13 then
   begin
    FMonth:=1;
    inc(FYear);
   end;

  if FMonth=0 then
   begin
    FMonth:=12;
    dec(FYear);
   end;

  FValue:=BuildDate;
  SetValue(FValue);

end;

procedure TwzsMonthDBEdit.SetDefaultDate(Value: TDate);
begin
  FDefaultDate:=Value;
end;

procedure TwzsMonthDBEdit.SetDefaultLineVisible(Value: boolean);
begin
  if Value<>FDefaultLineVisible then
  begin
    FDefaultLineVisible:=Value;
    Items:=BuildMonthList;
  end;
end;

procedure TwzsMonthDBEdit.SetDefaultLineText(Value: string);
begin
  if Value<>FDefaultLineText then
  begin
    FDefaultLineText:=Value;

    if FDefaultLineText='' then
      FDefaultLineText:=SDefaultLineText;

    Items:=BuildMonthList;
  end;

end;

procedure TwzsMonthDBEdit.SetNullLineText(Value: string);
begin
  if Value<>FNullLineText then
  begin
    FNullLineText:=Value;

    if FNullLineText='' then
      FNullLineText:=SNullLineText;

    Items:=BuildMonthList;
  end;
end;

procedure TwzsMonthDBEdit.SetNullLineVisible(Value: boolean);
begin
  if Value<>FNullLineVisible then
  begin
    FNullLineVisible:=Value;
    Items:=BuildMonthList;
  end;

end;

end.
