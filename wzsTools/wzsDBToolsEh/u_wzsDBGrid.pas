{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBGrid;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, Dialogs,
  {$ifdef ver150} Variants, {$endif} Windows, Graphics,
  DBCtrlsEh, ToolCtrlsEh, DBGridEh, DB, GridsEh, Messages, Menus,
  Forms, Buttons, DataDriverEh, MemTableEh, ActnList,
  CommCtrl, u_wzsToolsCommon, u_wzsStyler;


resourcestring
  SColumnSortHint='Сортировать по полю "%s"';
  SFilterError='Ошибка применения фильтра';
  SFilterBtnHint='Отфильтровать (Enter)';
  SSearchBtnHint='Поиск вниз (%s)';
  SFilterDropDownBtnHint='Выбрать';


type

  TwzsDBGrid = class;

  TwzsColumnsHighlight = class(TPersistent)
  private
    FOwner: TwzsDBGrid;

    FActive: boolean;

    FReadOnlyTitleFontColor: TColor;
    FReadOnlyColFontColor: TColor;
    FReadOnlyColColor: TColor;
    FReqTitleFontColor: TColor;
    FReqColFontColor: TColor;
    FReqColColor: TColor;
    FNotReqTitleFontColor: TColor;
    FNotReqColFontColor: TColor;
    FNotReqColColor: TColor;

    procedure SetActive(Value: Boolean);
  public
    constructor Create(AOwner: TwzsDBGrid);
  published
    property Active: boolean read FActive write SetActive default true;

    property ReadOnlyTitleFontColor: TColor read FReadOnlyTitleFontColor write FReadOnlyTitleFontColor;
    property ReadOnlyColFontColor: TColor read FReadOnlyColFontColor write FReadOnlyColFontColor;
    property ReadOnlyColColor: TColor read FReadOnlyColColor write FReadOnlyColColor;

    property ReqTitleFontColor: TColor read FReqTitleFontColor write FReqTitleFontColor;
    property ReqColFontColor: TColor read FReqColFontColor write FReqColFontColor;
    property ReqColColor: TColor read FReqColColor write FReqColColor;

    property NotReqTitleFontColor: TColor read FNotReqTitleFontColor write FNotReqTitleFontColor;
    property NotReqColFontColor: TColor read FNotReqColFontColor write FNotReqColFontColor;
    property NotReqColColor: TColor read FNotReqColColor write FNotReqColColor;
  end;

  TwzsDBGridAdditional = class(TPersistent)
  private
    FOwner: TwzsDBGrid;
    FColumnsHighlight: TwzsColumnsHighlight;
    FDefaultFilter: boolean;
    FFilterShortCut: TShortCut;
    FClearFilterShortCut: TShortCut;
    FSearchShortCut: TShortCut;
    FFilterValueList: boolean;
    FFilterLookupList: boolean;
    FStyler: TwzsStyler;
    procedure SetDefaultFilter(Value: boolean);
    procedure SetStyler(Value: TwzsStyler);
  protected
  public
    constructor Create(AOwner: TwzsDBGrid);
  published
    property ColumnsHighlight: TwzsColumnsHighlight read FColumnsHighlight write FColumnsHighlight;

    property DefaultFilter: boolean read FDefaultFilter write SetDefaultFilter default false;
    property FilterShortCut: TShortCut read FFilterShortCut write FFilterShortCut;
    property ClearFilterShortCut: TShortCut read FClearFilterShortCut write FClearFilterShortCut;
    property SearchShortCut: TShortCut read FSearchShortCut write FSearchShortCut;
    property FilterValueList: boolean read FFilterValueList write FFilterValueList default false;
    property FilterLookupList: boolean read FFilterLookupList write FFilterLookupList default false;
    property Styler: TwzsStyler read FStyler write SetStyler;
  end;

 TwzsDBGrid = class(TCustomDBGridEh)
 private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsDBGridAdditional;
    FFilterDatasource: TDatasource;
    FFilterDataSetDriver: TDataSetDriverEh;
    FFilterMemTable: TMemTableEh;

    //FDataSetBeforeRefreshStored: TDataSetNotifyEvent;
    //FDataSetAfterRefreshStored: TDataSetNotifyEvent;
    FDataSetAfterOpenStored: TDataSetNotifyEvent;
    //FColumnOnUpdateDataStored: TColCellUpdateDataEventEh;
    FFilterExprBuilder: TwzsFilterExprBuilder;
    //procedure DataSetBeforeRefresh(DataSet: TDataSet);
    //procedure DataSetAfterRefresh(DataSet: TDataSet);
    //FDatasetReopened: boolean;
    FSearchValue: string;
    procedure DatasetAfterOpen(DataSet: TDataSet);
    //procedure ColumnOnUpdateData(Sender: TObject;
    //  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
    procedure GrigOnApplyFilter(Sender: TObject);

    procedure PrepareFilter;
    function GetDataset: TDataset;
    procedure HighlightColumn(Column: TColumnEh);
    //procedure SetOnUpdateColumnsHandlers;
    //procedure SetDatasetRefreshHandlers;
    procedure SetDatasetOpenHandlers;
    procedure SaveDatasetHandlers;

    procedure FilterEditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure SearchOnColumn;
  protected
    procedure Loaded; override;
    procedure SetColumnAttributes; override;
    //procedure DataChanged; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure PrepareFilterColumn(Column: TColumnEh);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure WMNCPaint(var Message: TWMNCPaint); message wm_NCPaint;
    procedure FlatChanged; override;
    //procedure CMStylerChanged(var Message: TMessage); message cm_wzsStylerChanged;
    function CreateFilterEditor: TCustomDBEditEh; override;
    procedure ShowEditor; override;
    procedure UpdateFilterEditProps(DataCol: Longint); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure FilterDataset(FilterExpr: string);

    property Canvas;
    property GridHeight;
    property RowCount;
    property SelectedRows;
    property TopRow;

    procedure SetFilterEditProps;
    
    //procedure FilterButtonClick(Sender: TObject; var Handled: Boolean);
    //procedure SearchButtonClick(Sender: TObject; var Handled: Boolean);
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsDBGridAdditional read FAdditional write FAdditional;

    property Align;
    property AllowedOperations;
    property AllowedSelections;
    property Anchors;
    property AutoFitColWidths;
    property BorderStyle;
    property Color;
    property ColumnDefValues;
    property Columns stored False;
    property Constraints;
    property ContraColCount;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragMode;
    property DrawGraphicData;
    property DrawMemoText;
    property EditActions;
    property Enabled;
    property EvenRowColor;
    property FixedColor;
    property Flat;
    property Font;
    property FooterColor;
    property FooterFont;
    property FooterRowCount;
    property FrozenCols;
    property HorzScrollBar;
    property IndicatorTitle;
    property MinAutoFitWidth;
    property OddRowColor;
    property Options;
    property OptionsEh;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RowHeight;
    property RowLines;
    property RowSizingAllowed;
    property ShowHint;
    property SortLocal;
    property STFilter;
    property SumList;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property TitleHeight;
    property TitleImages;
    property TitleLines;
    property UseMultiTitle;
    property VertScrollBar;
    property Visible;
    property VTitleMargin;
    property OnAdvDrawDataCell;
    //property OnApplyFilter;   handled internally
    property OnBuildIndicatorTitleMenu;
    property OnCellClick;
    property OnCellMouseClick;
    property OnCheckButton;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnColWidthsChanged;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawColumnCell;
    property OnDrawDataCell;
    property OnDrawFooterCell;
    property OnDataHintShow;
    property OnEditButtonClick;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetBtnParams;
    property OnGetCellParams;
    property OnGetFooterParams;
    property OnGetRowHeight;
    property OnIndicatorTitleMouseDown;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMoveRecords;
    property OnSelectionChanged;
    property OnHintShowPause;
    property OnSortMarkingChanged;
    property OnStartDrag;
    property OnSumListAfterRecalcAll;
    property OnSumListRecalcAll;
    property OnTitleBtnClick;
    property OnTitleClick;
    
    {
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BevelWidth;
    }


  end;

procedure Register;

implementation

uses qStrings, DBUtilsEh, FlatSB;

type
  TWinControlCrack = class(TWinControl) end;

procedure Register;
begin
  RegisterComponents('wzsTools', [TwzsDBGrid]);

end;

{ TwzsDBGrid }

constructor TwzsDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAdditional:=TwzsDBGridAdditional.Create(self);

  FFilterDatasource:=TDatasource.Create(self);
  FFilterMemTable:=TMemTableEh.Create(self);
  FFilterDataSetDriver:=TDatasetDriverEh.Create(self);

  FFilterDatasource.DataSet:=FFilterMemTable;
  FFilterMemTable.DataDriver:=FFilterDataSetDriver;
  FFilterMemTable.FetchAllOnOpen:=true;

  FFilterExprBuilder:=TwzsFilterExprBuilder.Create(self);

  ColumnDefValues.HighlightRequired:=true;
  ColumnDefValues.ToolTips:=true;
  ColumnDefValues.Title.TitleButton:=true;

  Options:=Options-[dgIndicator]+[dgAlwaysShowSelection];
  OptionsEh:=OptionsEh-[dghDialogFind]+
    [dghRowHighlight, dghAutoSortMarking, dghMultiSortMarking];

end;

{
procedure TwzsDBGrid.DataChanged;
begin
  inherited DataChanged;
end;
}

{
procedure TwzsDBGrid.DataSetAfterRefresh(DataSet: TDataSet);
begin
 if (FAdditional.RestoreBookmark) and (GetDataset<>nil) then
  begin
   showmessage('after refr');

   RestoreBookmark;

   if Assigned(FDataSetAfterRefreshStored) then
    FDataSetAfterRefreshStored(GetDataset);
  end;
end;

procedure TwzsDBGrid.DataSetBeforeRefresh(DataSet: TDataSet);
begin
 if (FAdditional.RestoreBookmark) and (GetDataset<>nil) then
  begin
   showmessage('before refr');

   SaveBookmark;

   if Assigned(FDataSetBeforeRefreshStored) then
    FDataSetBeforeRefreshStored(GetDataset);
  end;
end;
}

function TwzsDBGrid.GetDataset: TDataset;
begin
  result:=nil;
  if (Assigned(Datasource)) and (Assigned(Datasource.DataSet)) then
   result:=Datasource.DataSet;
end;



procedure TwzsDBGrid.HighlightColumn(Column: TColumnEh);
begin

 if (Column.Field<>nil) and (Column.Field.Visible) then
  begin

   //not req
   Column.Font.Color:=FAdditional.ColumnsHighlight.NotReqColFontColor;
   Column.Color:=FAdditional.ColumnsHighlight.NotReqColColor;
   Column.Title.Font.Color:=FAdditional.ColumnsHighlight.NotReqTitleFontColor;

   if (Column.ReadOnly) or (Column.Field.ReadOnly)
    or (not DataLink.DataSet.CanModify) then
    begin
     //readonly
     Column.Title.Font.Color:=FAdditional.ColumnsHighlight.ReadOnlyTitleFontColor;
     Column.Font.Color:=FAdditional.ColumnsHighlight.ReadOnlyColFontColor;
     Column.Color:=FAdditional.ColumnsHighlight.ReadOnlyColColor;
    end
   else
    begin
     //required
     if Column.Field.Required then
      begin
       Column.Font.Color:=FAdditional.ColumnsHighlight.ReqColFontColor;
       Column.Color:=FAdditional.ColumnsHighlight.ReqColColor;
       Column.Title.Font.Color:=FAdditional.ColumnsHighlight.ReqTitleFontColor;
      end;
    end;
  end;

end;

procedure TwzsDBGrid.Loaded;
begin
  //beware! override handlers only at runtime!

  if not (csDesigning in ComponentState) and (GetDataset<>nil) then
   begin
     SaveDatasetHandlers;
     //SetDatasetRefreshHandlers;
     SetDatasetOpenHandlers;
   end;

  inherited Loaded;
end;

procedure TwzsDBGrid.SetColumnAttributes;
var
  i: integer;
begin
 inherited SetColumnAttributes;

 for i:=0 to Columns.Count-1 do
 begin
   if FAdditional.ColumnsHighlight.Active then
     HighlightColumn(Columns[i]);

   //if FAdditional.DetectSQLSorting then
   Columns[i].Title.Hint:=Format(SColumnSortHint, [Columns[i].Title.Caption]);
 end;
end;

{
procedure TwzsDBGrid.SetOnUpdateColumnsHandlers;
var
  c: TColumnEh;
  i: integer;

begin

  for i:=0 to Columns.Count-1 do
   begin
    c:=Columns[i];
    if (c.Field<>nil) and (c.Field.DataType in [ftDate, ftDateTime]) then
     if (c.Field.EditMask<>'') or (c.EditMask<>'') then
      begin
       if (Assigned(c.OnUpdateData)) and
          (not Assigned(FColumnOnUpdateDataStored)) then
        FColumnOnUpdateDataStored:=c.OnUpdateData;

       c.OnUpdateData:=ColumnOnUpdateData;
      end;
   end;
end;
}

{
procedure TwzsDBGrid.ColumnOnUpdateData(Sender: TObject;
  var Text: String; var Value: Variant; var UseText, Handled: Boolean);
var
  c: TColumnEh;
  d: TDateTime;

begin
  showmessage('upd');

  c:=sender as TColumnEh;

  if FAdditional.NullOnDateTimeMask then
    if TryStrToDate(Text, d) then
     UseText:=true
    else
     begin
      UseText:=false;
      Value:=null;
     end;

  if Assigned(FColumnOnUpdateDataStored) then
     FColumnOnUpdateDataStored(Sender, Text, Value, UseText, Handled);

end;
}

procedure TwzsDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  bKey: word;
  bShift: TShiftState;
  CurCol: integer;
begin
  inherited KeyDown(Key, Shift);

  CurCol:=SelectedIndex;

  ShortCutToKey(FAdditional.FilterShortCut, bKey, bShift);
  if (Key = bKey) and (Shift = bShift) then
  begin
    if not STFilter.Visible then
      STFilter.Visible:=true;

    StartEditFilter(CurCol);
  end;

  ShortCutToKey(FAdditional.ClearFilterShortCut, bKey, bShift);
  if (Key = bKey) and (Shift = bShift) then
  begin
    ClearFilter;

    SelectedIndex:=CurCol;

    if (DataLink.DataSet.Filtered) then
      DataLink.DataSet.Filtered:=false;
  end;

  ShortCutToKey(FAdditional.SearchShortCut, bKey, bShift);

  if (Key = bKey) and (Shift = bShift) then
    SearchOnColumn;
end;

procedure TwzsDBGrid.PrepareFilter;
var
  i: integer;

begin
  FFilterDataSetDriver.ProviderDataSet:=GetDataset;

  if FAdditional.FilterValueList then
  begin //fetch all data into memtable
    GetDataset.DisableControls;
    FFilterMemTable.Active:=true;
    GetDataset.First;
    GetDataset.EnableControls;
  end;

  OnApplyFilter:=GrigOnApplyFilter;

  for i:=0 to Columns.Count-1 do
    PrepareFilterColumn(Columns[i]);

end;

procedure TwzsDBGrid.PrepareFilterColumn(Column: TColumnEh);
var
 ds: TDatasource;
begin

 if (Column.Field<>nil) and (Column.STFilter.Visible) and
 (not Assigned(Column.STFilter.ListSource)) then
  case Column.Field.FieldKind of
   fkLookup:
    begin
     if FAdditional.FilterLookupList then
     begin
       if Column.Field.LookupDataSet<>nil then
         begin
           ds:=TDataSource.Create(self);
           ds.DataSet:=Column.Field.LookupDataSet;
           Column.STFilter.ListSource:=ds;
           Column.STFilter.DataField:=Column.Field.KeyFields;
           Column.STFilter.KeyField:=Column.Field.LookupKeyFields;
           Column.STFilter.ListField:=Column.Field.LookupResultField;
         end;
     end
      else
     Column.STFilter.Visible:=false; 
    end; //fkLookup
   fkData:
     if FAdditional.FilterValueList then
       Column.STFilter.ListSource:=FFilterDatasource;

  end;

  //useful showmessage(Columns[8].STFilter.CurrentDataField);
end;

procedure TwzsDBGrid.Notification(AComponent: TComponent;
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

procedure TwzsDBGrid.DatasetAfterOpen(DataSet: TDataSet);
begin
  //if FAdditional.NullOnDateTimeMask then
  //  SetOnUpdateColumnsHandlers;

  if FAdditional.DefaultFilter then
    PrepareFilter;

  //if (FAdditional.DetectSQLSorting) and (not FDatasetReopened) then
  //  DetectSortColumns;

  if Assigned(FDatasetAfterOpenStored) then
    FDatasetAfterOpenStored(GetDataset);

  //FDatasetReopened:=true;

end;

{
procedure TwzsDBGrid.SetDatasetRefreshHandlers;
begin
 if not (csDesigning in ComponentState) and (GetDataset<>nil) then
  if FAdditional.RestoreBookmark then
   begin
     GetDataset.BeforeRefresh:=DataSetBeforeRefresh;
     GetDataset.AfterRefresh:=DataSetAfterRefresh;
   end
  else
   begin
     GetDataset.BeforeRefresh:=FDataSetBeforeRefreshStored;
     GetDataset.AfterRefresh:=FDataSetAfterRefreshStored;
   end;
end;
}

procedure TwzsDBGrid.GrigOnApplyFilter(Sender: TObject);
var
  i: integer;
  //f: TField;
begin
  if not FAdditional.DefaultFilter then
    exit;

  FFilterExprBuilder.Fields.Clear;

  for i:=0 to Columns.Count-1 do
  begin
   if Columns[i].Visible then
    FFilterExprBuilder.AddField(Columns[i].Field, Columns[i].STFilter.ExpressionStr);
  end;

  FilterDataset(FFilterExprBuilder.GetFieldsFilterStr);

  StopEditFilter;

end;

procedure TwzsDBGrid.SaveDatasetHandlers;
begin
    if (Assigned(GetDataset.AfterOpen)) and
       (not Assigned(FDataSetAfterOpenStored)) then
      FDataSetAfterOpenStored:=GetDataset.AfterOpen;
      
    {
    if Assigned(GetDataset.BeforeRefresh) and
       (not Assigned(FDataSetBeforeRefreshStored)) then
      FDataSetBeforeRefreshStored:=GetDataset.BeforeRefresh;

    if Assigned(GetDataset.AfterRefresh) and
       (not Assigned(FDataSetAfterRefreshStored)) then
      FDataSetAfterRefreshStored:=GetDataset.AfterRefresh;
    }
end;

procedure TwzsDBGrid.SetDatasetOpenHandlers;
begin
 if not (csDesigning in ComponentState) and (GetDataset<>nil) then
   GetDataset.AfterOpen:=DataSetAfterOpen;
end;



procedure TwzsDBGrid.FilterDataset(FilterExpr: string);
begin
  if Assigned(DataLink.DataSet) then
  begin
    try
      DataLink.DataSet.Filter:=FilterExpr;
      DataLink.DataSet.Filtered:=true;
    except
      raise Exception.Create(SFilterError);
    end;
  end;
end;

procedure TwzsDBGrid.Paint;
begin

  //myflat
  {if (Flat) and (FAdditional.Styler<>nil) and
    (FAdditional.Styler.FlatScrollbars) then
    InitializeFlatSB(Handle);}

  inherited Paint;

  //myflat
  {if (Flat) and (FAdditional.Styler<>nil) and
    (FAdditional.Styler.FlatScrollbars) then
  begin
    FlatSB_SetScrollProp(Handle, WSB_PROP_HSTYLE, FSB_FLAT_MODE, true);
    FlatSB_SetScrollProp(Handle, WSB_PROP_VSTYLE, FSB_FLAT_MODE, true);
  end;}
end;

procedure TwzsDBGrid.WMNCPaint(var Message: TWMNCPaint);
begin
	inherited;

  if (Flat) and (FAdditional.Styler<>nil) then
  begin
    FAdditional.Styler.DrawFrame(Self, TMessage(message), false);
    message.Result:=0;
  end;

end;


procedure TwzsDBGrid.FlatChanged;
begin
  inherited FlatChanged;

  if (Flat) and (FAdditional.Styler<>nil) then
    begin
      RowHeight:=16;
      OptionsEh:=OptionsEh-[dghFixed3D];
    end
      else
    begin
      OptionsEh:=OptionsEh+[dghFixed3D];
      RowHeight:=0;
    end;
end;

{
procedure TwzsDBGrid.CMStylerChanged(var Message: TMessage);
begin
  FlatChanged;
end;
}


procedure TwzsDBGrid.SetFilterEditProps;
var
  fltEdtWC: TWinControl;
  //fltEdtCBEh: TDBComboBoxEh;
  //FFilterApplyButton: TEditButtonEh;
  //FSearchApplyButton: TEditButtonEh;

begin
  fltEdtWC:=FilterEdit as TWinControl;

  TWinControlCrack(fltEdtWC).OnKeyUp:=FilterEditKeyUp;


  fltEdtWC.ShowHint:=true;
  fltEdtWC.Hint:=SFilterBtnHint+' / '+
    Format(SSearchBtnHint, [ShortCutToText(FAdditional.SearchShortCut)]);

  { create custom edit buttons in filter edit
  but their click handlers didnt work :(

  feeh:=TDBComboBoxEh(FilterEdit);
  feeh.EditButton.Hint:=SFilterDropDownBtnHint;
  feeh.EditButtons.Clear;
  if not feeh.EditButton.Visible then
  begin
    //FFilterApplyButton:=feeh.EditButtons.Add;
    //FFilterApplyButton.OnClick:=FilterButtonClick;
    //FFilterApplyButton.Hint:=SFilterBtnHint;
    //FSearchApplyButton:=feeh.EditButtons.Add;
    //FSearchApplyButton.OnClick:=SearchButtonClick;
    //FSearchApplyButton.Hint:=Format(SSearchBtnHint, [ShortCutToText(FAdditional.SearchShortCut)]);
  end;
  }
end;

function TwzsDBGrid.CreateFilterEditor: TCustomDBEditEh;
begin
  result:=inherited CreateFilterEditor;
end;

procedure TwzsDBGrid.ShowEditor;
begin
  inherited ShowEditor;
end;

procedure TwzsDBGrid.UpdateFilterEditProps(DataCol: Integer);

begin
  inherited UpdateFilterEditProps(DataCol);

  SetFilterEditProps;

end;

procedure TwzsDBGrid.SearchOnColumn;
begin
{  TLocateTextOptionEh = (ltoCaseInsensitiveEh, ltoAllFieldsEh, ltoMatchFormatEh,
    ltoIgnoteCurrentPosEh, ltoStopOnEscape);
  TLocateTextOptionsEh = set of TLocateTextOptionEh;
  TLocateTextDirectionEh = (ltdUpEh, ltdDownEh, ltdAllEh);
  TLocateTextMatchingEh = (ltmAnyPartEh, ltmWholeEh, ltmFromBegingEh);
  TLocateTextTreeFindRangeEh = (lttInAllNodesEh, lttInExpandedNodesEh,
    lttInCurrentLevelEh, lttInCurrentNodeEh);
}

  if (SelectedField<>nil) and (FilterEdit<>nil) then
  begin
    if FilterEdit.Value<>'' then
      FSearchValue:=FilterEdit.Value;

    LocateText(self, SelectedField.FieldName, FSearchValue, [ltoCaseInsensitiveEh],
      ltdDownEh, ltmAnyPartEh, lttInAllNodesEh);

  end;


  {
  if GetDataset<>nil then
  begin
    GetDataset.Cancel;
    GetDataset.Locate(KeyFld, KeyValue, [loCaseInsensitive, loPartialKey]);
  end;
  }
end;


procedure TwzsDBGrid.FilterEditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bKey: word;
  bShift: TShiftState;
begin
  ShortCutToKey(FAdditional.SearchShortCut, bKey, bShift);

  if (Key = bKey) and (Shift = bShift) then
    SearchOnColumn;
end;

{
procedure TwzsDBGrid.FilterButtonClick(Sender: TObject;
  var Handled: Boolean);
begin
    GrigOnApplyFilter(self);
end;

procedure TwzsDBGrid.SearchButtonClick(Sender: TObject;
  var Handled: Boolean);
begin
  SearchOnColumn;
end;
}

{ TwzsDBGridAdditional }

constructor TwzsDBGridAdditional.Create(AOwner: TwzsDBGrid);
begin
  inherited Create;

  FOwner:=AOwner;

  FColumnsHighlight:=TwzsColumnsHighlight.Create(FOwner);

  //FRestoreBookmark:=false;
  //FNullOnDateTimeMask:=false;

  FDefaultFilter:=false;
  FFilterShortCut:=TextToShortCut('F8');
  FClearFilterShortCut:=TextToShortCut('F9');
  FSearchShortCut:=TextToShortCut('F3');
  FFilterValueList:=false;
  FFilterLookupList:=false;

end;

procedure TwzsDBGridAdditional.SetDefaultFilter(Value: boolean);
begin
  FDefaultFilter:=Value;
  FOwner.SetDatasetOpenHandlers;
end;

procedure TwzsDBGridAdditional.SetStyler(Value: TwzsStyler);
begin
  FStyler:=Value;
  FOwner.FlatChanged;
end;

{ TwzsColumnsHighlight }

constructor TwzsColumnsHighlight.Create(AOwner: TwzsDBGrid);
begin
  inherited Create;

  FOwner:=AOwner;

  FActive:=true;

  FReadOnlyTitleFontColor:=clGray;
  FReadOnlyColFontColor:=clWindowText;
  FReadOnlyColColor:=clWindow;

  FReqTitleFontColor:=clWindowText;
  FReqColFontColor:=clWindowText;
  FReqColColor:=clWindow;

  FNotReqTitleFontColor:=$00EC7600; //$00954A00;
  FNotReqColFontColor:=clWindowText;
  FNotReqColColor:=clWindow;

end;

procedure TwzsColumnsHighlight.SetActive(Value: Boolean);
begin

  FActive:=Value;

  if FActive then
   FOwner.SetColumnAttributes
  else
   FOwner.Columns.RestoreDefaults;

end;

{ TwzsCustomButton }
{
constructor TwzsCustomButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //self.BevelKind:=bkTile;

  Width:=16;
  Height:=16;
  Caption:='F';
  
end;

procedure TwzsCustomButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);

  with Params do
   begin

    Style:=Style and (not BS_OWNERDRAW);
    //Style:=Style and not BS_PUSHBUTTON;
    //Style:=Style or BS_FLAT;

    ExStyle:=ExStyle or WS_EX_CLIENTEDGE;
    //(BS_FLAT)
    //Style:=Style (and not WS_BORDER);
   end;


  //Params.ExStyle:=Params.ExStyle or WS_EX_STATICEDGE;


  //WS_EX_WINDOWEDGE
  //WS_EX_CLIENTEDGE;

  //and (not WS_BORDER);
  //WS_SIZEBOX;

end;
}


end.
