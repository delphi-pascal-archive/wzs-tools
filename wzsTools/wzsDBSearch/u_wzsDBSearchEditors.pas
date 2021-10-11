{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBSearchEditors;

interface

uses
 Windows, Messages, SysUtils, {$ifdef ver150} Variants, {$endif} Classes, Graphics, Controls, Forms,
 Dialogs, {$ifdef ver150} DesignEditors, DesignIntf, VCLEditors, {$else} DsgnIntf, {$endif} StdCtrls, Contnrs,
 u_wzsToolsEditors;

type
 TwzsDBSearchEditEditor = class(TwzsToolsEditor)
 private
 protected
  procedure ShowDesignerForm; override;
 public
  procedure Edit; override;
  procedure ExecuteVerb(Index: Integer); override;
  function GetVerb(Index: Integer): string; override;
  function GetVerbCount: Integer; override;
  procedure DropFieldLabel;
 end;

 TwzsDBSearchEngineEditor = class(TwzsToolsEditor)
 private
 protected
 public
  procedure Edit; override;
 end;

 TDataFieldProperty = class(TStringProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
 end;

procedure Register;

implementation

uses u_wzsDBSearch, u_wzsToolsCommon, u_wzsDBSearchEditDesForm,
  u_wzsDBSearchCommon;

procedure Register;
begin
  RegisterComponentEditor(TwzsDBSearchEdit, TwzsDBSearchEditEditor);
  RegisterComponentEditor(TwzsDBSearchEngine, TwzsDBSearchEngineEditor);

  RegisterPropertyEditor(TypeInfo(string),
   TwzsDBSearchEdit, 'DataField', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(TShortCut),
   TwzsEditButtonOptions, 'ShortCut', TShortCutProperty);

  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   TwzsDBSearchEdit, 'About', TwzsAboutInfoProperty);
  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   TwzsDBSearchEngine, 'About', TwzsAboutInfoProperty);
  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   TwzsCustomSearchEngineButton, 'About', TwzsAboutInfoProperty);
   
end;


{ TDataFieldProperty }

function TDataFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;


procedure TDataFieldProperty.GetValues(Proc: TGetStrProc);
var
 l: TStringList;
 i: Integer;
 c: TwzsDBSearchEdit;
begin

 c:=GetComponent(0) as TwzsDBSearchEdit;

 l:=TStringList.Create;

 if (c.SearchEngine<>nil) and (c.SearchEngine.DataLink.DataSet<>nil) then
  begin
    l:= c.SearchEngine.DataLink.DataSet.FieldList;
    for i := 0 to l.Count - 1 do
     Proc(l[i]);
  end;

// l.Free;   do not do this!
end;

{ TwzsDBSearchEditEditor }

procedure TwzsDBSearchEditEditor.ExecuteVerb(Index: Integer);
begin
 case Index of
   0: inherited ExecuteVerb(Index);
   1: DropFieldLabel;
 end;

end;

function TwzsDBSearchEditEditor.GetVerb(Index: Integer): string;
begin

 case Index of
   0: result:= inherited GetVerb(Index);
   1: result:='Drop field label';
 end;

end;

function TwzsDBSearchEditEditor.GetVerbCount: Integer;
begin
 result := inherited GetVerbCount + 1;
end;

procedure TwzsDBSearchEditEditor.DropFieldLabel;
var
 control: TwzsDBSearchEdit;
 lbl: TLabel;
begin
 control:=Component as TwzsDBSearchEdit;

 lbl:=Designer.CreateComponent(TLabel,
      Component.Owner,
      control.Left, control.Top - 16, 150, 30) as TLabel;

 lbl.Caption:=control.GetDisplayLabel;
end;


procedure TwzsDBSearchEditEditor.ShowDesignerForm;
var
 DesignerForm: TwzsDBSearchEditDesForm;

begin
 SelectedComponents:=GetSelectionByClass(Component.ClassType);

 DesignerForm:=TwzsDBSearchEditDesForm.Create(nil);
 DesignerForm.Editor:=self;
 DesignerForm.ShowModal;

 Designer.Modified;
end;

procedure TwzsDBSearchEditEditor.Edit;
begin
  Version:=PackageVer;

  inherited Edit;

end;

{ TwzsDBSearchEngineEditor }

procedure TwzsDBSearchEngineEditor.Edit;
begin
  Version:=PackageVer;

  inherited Edit;

end;

end.
