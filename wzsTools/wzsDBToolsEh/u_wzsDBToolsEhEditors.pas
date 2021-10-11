{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBToolsEhEditors;

interface

uses
  u_wzsToolsEditors, GridEhEd, Dialogs, Classes, u_wzsDBEdits,
  {$ifdef ver150} DesignIntf, DesignEditors, VCLEditors {$else} DsgnIntf {$endif};


type

 TwzsDBToolsEhEditor = class(TwzsToolsEditor)
 public
  procedure Edit; override;
 end;

 {$ifdef ver150}
 TwzsDBGridEditor = class(TDBGridEhEditor)
 private
 protected
  procedure ShowDesignerForm;
  procedure FindDataset;
 public
  procedure ExecuteVerb(Index: Integer); override;
  function GetVerb(Index: Integer): string; override;
  function GetVerbCount: Integer; override;
 end;
 {$endif}

procedure Register;

implementation

uses
  {$ifdef ver150} u_wzsDBGrid, u_wzsDBGridDesForm, {$endif}
  u_wzsMonthDBEdit, u_wzsToolsCommon, u_wzsDBToolsEhCommon;

const
  EhLibBased = 'based on EhLib components http://www.ehlib.com';

procedure Register;
begin

  RegisterComponentEditor(TwzsMonthDBEdit, TwzsDBToolsEhEditor);
  RegisterComponentEditor(TwzsDBEdit, TwzsDBToolsEhEditor);
  RegisterComponentEditor(TwzsDBComboBox, TwzsDBToolsEhEditor);
  RegisterComponentEditor(TwzsDBDateTimeEdit, TwzsDBToolsEhEditor);
  RegisterComponentEditor(TwzsDBNumberEdit, TwzsDBToolsEhEditor);
  RegisterComponentEditor(TwzsDBLookupCombobox, TwzsDBToolsEhEditor);

  RegAboutProp(TwzsMonthDBEdit);
  RegAboutProp(TwzsDBEdit);
  RegAboutProp(TwzsDBComboBox);
  RegAboutProp(TwzsDBDateTimeEdit);
  RegAboutProp(TwzsDBNumberEdit);
  RegAboutProp(TwzsDBLookupCombobox);


  {$ifdef ver150}
  RegisterComponentEditor(TwzsDBGrid, TwzsDBGridEditor);
  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
    TwzsDBGrid, 'About', TwzsAboutInfoProperty);
  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
    TwzsDBEdit, 'About', TwzsAboutInfoProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut),
    TwzsDBGridAdditional, 'FilterShortCut', TShortCutProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut),
    TwzsDBGridAdditional, 'ClearFilterShortCut', TShortCutProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut),
    TwzsDBGridAdditional, 'SearchShortCut', TShortCutProperty);
  {$endif}

end;

{ TwzsDBToolsEditor }

procedure TwzsDBToolsEhEditor.Edit;
begin
  Version:=PackageVer+' ('+EhLibBased+')';

  inherited Edit;

end;

{ TwzsDBGridEditor }

{$ifdef ver150}
procedure TwzsDBGridEditor.ExecuteVerb(Index: Integer);
begin
 case Index of
   0: inherited ExecuteVerb(Index);
   1: ShowDesignerForm;
   2: FindDataset;
 end;

end;

procedure TwzsDBGridEditor.FindDataset;
var
  g: TwzsDBGrid;
begin
  g:=Component as TwzsDBGrid;

  if (g.DataSource<>nil) and (g.DataSource.DataSet<>nil) then
    Designer.SelectComponent(g.DataSource.DataSet);
end;

function TwzsDBGridEditor.GetVerb(Index: Integer): string;
begin
  case Index of
   0: result:= inherited GetVerb(Index);
   1: result:='Additional...';
   2: result:='Find Dataset';
  end;
end;

function TwzsDBGridEditor.GetVerbCount: Integer;
begin
  result := inherited GetVerbCount + 2;
end;

procedure TwzsDBGridEditor.ShowDesignerForm;
var
 DesignerForm: TwzsDBGridDesForm;

begin
 DesignerForm:=TwzsDBGridDesForm.Create(nil);
 DesignerForm.Editor:=nil;
 DesignerForm.Component:=Component;
 DesignerForm.ComponentVersion:=PackageVer+' ('+EhLibBased+')';
 DesignerForm.ShowModal;

 Designer.Modified;
end;
{$endif}


end.
