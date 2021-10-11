{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBEdits;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, DBCtrlsEh, Messages,
  Dialogs, Graphics, Windows, Menus, DBLookupEh,
  u_wzsToolsCommon, u_wzsStyler;

type

  TwzsDBEditAdditional = class(TPersistent)
  private
    FOwner: TWinControl;
    FStyler: TwzsStyler;
    procedure SetStyler(Value: TwzsStyler);
  protected
  public
    constructor Create(AOwner: TWinControl);
  published
    property Styler: TwzsStyler read FStyler write SetStyler;
  end;

  TwzsDBEdit = class(TCustomDBEditEh)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsDBEditAdditional;
  protected
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    //procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message wm_EraseBkgnd;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    //procedure CMStylerChanged(var Message: TMessage); message cm_wzsStylerChanged;

    procedure CMMouseEnter(var Message: TMessage); message cm_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message cm_MOUSELEAVE;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsDBEditAdditional read FAdditional write FAdditional;

    property Alignment;
    //property AlwaysShowBorder;    //always = true
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditButtons;
    property Enabled;
    property EditMask;
    property Font;
    property Flat;
    {$ifdef ver150} property HighlightRequired; {$endif}
    {$ifdef ver150} property Images; {$endif}
    property ImeMode;
    property ImeName;
    property MaxLength;
    property MRUList;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    {$ifdef ver150} property Tooltips; {$endif}
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
    {$ifdef ver150} property OnCheckDrawRequiredState; {$endif}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$ifdef ver150} property OnGetImageIndex; {$endif}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnUpdateData;
    property OnStartDock;
    property OnStartDrag;

  end;

  TwzsDBComboBox = class(TCustomDBComboBoxEh)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsDBEditAdditional;
    //procedure SetFlatListScroll;
  protected
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    //procedure CMStylerChanged(var Message: TMessage); message cm_wzsStylerChanged;

    procedure CMMouseEnter(var Message: TMessage); message cm_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message cm_MOUSELEAVE;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsDBEditAdditional read FAdditional write FAdditional;

    property Alignment;
    //property AlwaysShowBorder;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownBox;
    property Enabled;
    property EditButton;
    property EditButtons;
    property EditMask;
    property Font;
    property Flat;
    {$ifdef ver150} property HighlightRequired; {$endif}
    property Images;
    property ImeMode;
    property ImeName;
    property Items;
    property KeyItems;
    property MaxLength;
    property MRUList;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    {$ifdef ver150} property Tooltips; {$endif}
    property Visible;
    property WordWrap;
    property OnButtonClick;
    property OnButtonDown;
    property OnChange;
    {$ifdef ver150} property OnCheckDrawRequiredState; {$endif}
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
    {$ifdef ver150} property OnGetImageIndex; {$endif}
    {$ifdef ver150} property OnGetItemImageIndex; {$endif}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNotInList;
    property OnUpdateData;
    property OnStartDock;
    property OnStartDrag;

  end;

  TwzsDBDateTimeEdit = class(TCustomDBDateTimeEditEh)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsDBEditAdditional;
  protected
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    //procedure CMStylerChanged(var Message: TMessage); message cm_wzsStylerChanged;

    procedure CMMouseEnter(var Message: TMessage); message cm_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message cm_MOUSELEAVE;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsDBEditAdditional read FAdditional write FAdditional;

    property Alignment;
    //property AlwaysShowBorder;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EditButton;
    property EditButtons;
    {$ifdef ver150} property EditFormat; {$endif}
    property Font;
    property Flat;
    {$ifdef ver150} property HighlightRequired; {$endif}
    {$ifdef ver150} property Images; {$endif}
    property ImeMode;
    property ImeName;
    property Kind;
    property MRUList;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    {$ifdef ver150} property Tooltips; {$endif}
    property Value;
    property Visible;
    property OnButtonClick;
    property OnButtonDown;
    property OnChange;
    {$ifdef ver150} property OnCheckDrawRequiredState; {$endif}
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
    {$ifdef ver150} property OnGetImageIndex; {$endif}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnUpdateData;
    property OnStartDock;
    property OnStartDrag;

  end;

  TwzsDBNumberEdit = class(TCustomDBNumberEditEh)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsDBEditAdditional;
  protected
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    //procedure CMStylerChanged(var Message: TMessage); message cm_wzsStylerChanged;

    procedure CMMouseEnter(var Message: TMessage); message cm_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message cm_MOUSELEAVE;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsDBEditAdditional read FAdditional write FAdditional;

    property Alignment;
    property AlwaysShowBorder;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property currency;
    property DataField;
    property DataSource;
    property DecimalPlaces;
    property DisplayFormat;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EditButton;
    property EditButtons;
    property Font;
    property Flat;
    {$ifdef ver150} property HighlightRequired; {$endif}
    {$ifdef ver150} property Images; {$endif}
    property ImeMode;
    property ImeName;
    property Increment;
    property MaxValue;
    property MinValue;
    property MRUList;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    {$ifdef ver150} property Tooltips; {$endif}
    property Value;
    property Visible;
    property OnButtonClick;
    property OnButtonDown;
    property OnChange;
    {$ifdef ver150} property OnCheckDrawRequiredState; {$endif}
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$ifdef ver150} property OnGetImageIndex; {$endif}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnUpdateData;
    property OnStartDock;
    property OnStartDrag;

  end;

  TwzsDBLookupCombobox = class(TCustomDBLookupComboboxEh)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsDBEditAdditional;
  protected
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    //procedure CMStylerChanged(var Message: TMessage); message cm_wzsStylerChanged;

    procedure CMMouseEnter(var Message: TMessage); message cm_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message cm_MOUSELEAVE;

  public
    constructor Create(AOwner: TComponent); override;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsDBEditAdditional read FAdditional write FAdditional;

    property Alignment;
    //property AlwaysShowBorder;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property Anchors;
    property BiDiMode;
    property Constraints;
    property DragKind;
    {$ifdef ver150} property Images; {$endif}
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
    property Color;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
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
    property KeyField;
    property ListField;
    property ListFieldIndex;
    property ListSource;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    {$ifdef ver150} property Tooltips; {$endif}
    property Visible;
    property WordWrap;
    property OnButtonClick;
    property OnButtonDown;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    {$ifdef ver150} property OnCheckDrawRequiredState; {$endif}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnDropDownBoxCheckButton;
    property OnDropDownBoxDrawColumnCell;
    property OnDropDownBoxGetCellParams;
    property OnDropDownBoxSortMarkingChanged;
    property OnDropDownBoxTitleBtnClick;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    {$ifdef ver150} property OnGetImageIndex; {$endif}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnKeyValueChanged;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnNotInList;
    property OnUpdateData;
    property OnStartDrag;

  end;

procedure Register;

implementation

uses commctrl, FlatSB;

type
  TWinControlCracker = class(TWinControl) end;

procedure Register;
begin
  RegisterComponents('wzsTools',
    [TwzsDBEdit, TwzsDBComboBox, TwzsDBDateTimeEdit, TwzsDBNumberEdit, TwzsDBLookupCombobox]);
end;

{ TwzsDBEdit }

procedure TwzsDBEdit.CMMouseEnter(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;

procedure TwzsDBEdit.CMMouseLeave(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;
{
procedure TwzsDBEdit.CMStylerChanged(var Message: TMessage);
begin
  RecreateWnd;
end;
}
constructor TwzsDBEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AlwaysShowBorder:=true;
  Additional:=TwzsDBEditAdditional.Create(self);

end;

procedure TwzsDBEdit.Notification(AComponent: TComponent;
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

{
procedure TwzsDBEdit.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
end;
}

procedure TwzsDBEdit.WMNCPaint(var Message: TWMNCPaint);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), true);
    message.Result:=0;
  end
    else
  inherited;
end;


{ TwzsDBEditAdditional }

constructor TwzsDBEditAdditional.Create(AOwner: TWinControl);
begin
  FOwner:=AOwner;
end;

procedure TwzsDBEditAdditional.SetStyler(Value: TwzsStyler);
begin
  if Value<>FStyler then
  begin
    FStyler:=Value;
    TWinControlCracker(FOwner).RecreateWnd;
  end;
end;

{ TwzsDBComboBox }

procedure TwzsDBComboBox.CMMouseEnter(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;

procedure TwzsDBComboBox.CMMouseLeave(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;
{
procedure TwzsDBComboBox.CMStylerChanged(var Message: TMessage);
begin
  RecreateWnd;
end;
}

constructor TwzsDBComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AlwaysShowBorder:=true;
  Additional:=TwzsDBEditAdditional.Create(self);
end;



procedure TwzsDBComboBox.Notification(AComponent: TComponent;
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

{
procedure TwzsDBComboBox.SetFlatListScroll;
var
  vComboInfo:TComboBoxInfo;
begin
  vComboInfo.cbSize:=SizeOf(TComboBoxInfo);
  GetComboBoxInfo(Handle,vComboInfo);
  InitializeFlatSB(vComboInfo.hwndList);
  FlatSB_SetScrollProp(vComboInfo.hwndList, WSB_PROP_VSTYLE, FSB_FLAT_MODE, true);
end;
}

procedure TwzsDBComboBox.WMNCPaint(var Message: TWMNCPaint);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), true);
    message.Result:=0;
  end
    else
  inherited;
end;

{ TwzsDBDateTimeEdit }

procedure TwzsDBDateTimeEdit.CMMouseEnter(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;

procedure TwzsDBDateTimeEdit.CMMouseLeave(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;
{
procedure TwzsDBDateTimeEdit.CMStylerChanged(var Message: TMessage);
begin
  RecreateWnd;
end;
}
constructor TwzsDBDateTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AlwaysShowBorder:=true;
  Additional:=TwzsDBEditAdditional.Create(self);
end;

procedure TwzsDBDateTimeEdit.Notification(AComponent: TComponent;
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

procedure TwzsDBDateTimeEdit.WMNCPaint(var Message: TWMNCPaint);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), true);
    message.Result:=0;
  end
    else
  inherited;
end;

{ TwzsDBNumberEdit }

procedure TwzsDBNumberEdit.CMMouseEnter(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;

procedure TwzsDBNumberEdit.CMMouseLeave(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;
{
procedure TwzsDBNumberEdit.CMStylerChanged(var Message: TMessage);
begin
  RecreateWnd;
end;
}
constructor TwzsDBNumberEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AlwaysShowBorder:=true;
  Additional:=TwzsDBEditAdditional.Create(self);
end;

procedure TwzsDBNumberEdit.Notification(AComponent: TComponent;
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

procedure TwzsDBNumberEdit.WMNCPaint(var Message: TWMNCPaint);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), true);
    message.Result:=0;
  end
    else
  inherited;
end;

{ TwzsDBLookupCombobox }

procedure TwzsDBLookupCombobox.CMMouseEnter(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;

procedure TwzsDBLookupCombobox.CMMouseLeave(var Message: TMessage);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
    FAdditional.Styler.DrawFrame(self, message, true);
end;
{
procedure TwzsDBLookupCombobox.CMStylerChanged(var Message: TMessage);
begin
  RecreateWnd;
end;
}
constructor TwzsDBLookupCombobox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AlwaysShowBorder:=true;
  Additional:=TwzsDBEditAdditional.Create(self);
end;

procedure TwzsDBLookupCombobox.Notification(AComponent: TComponent;
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

procedure TwzsDBLookupCombobox.WMNCPaint(var Message: TWMNCPaint);
begin
  if (Flat) and (FAdditional.Styler<>nil) then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), true);
    message.Result:=0;
  end
    else
  inherited;
end;

end.
