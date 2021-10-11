{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}


unit u_wzsToolsEditors;

interface

uses
  Windows, Messages, SysUtils {$ifdef ver150}, Variants {$endif}, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Contnrs
  {$ifdef ver150}, DesignEditors, DesignIntf {$else}, DsgnIntf {$endif};

type
 TwzsApplyProc = procedure(var Component: TComponent) of object;

 TwzsToolsEditor = class(TComponentEditor)
 private
 protected
  procedure ShowDesignerForm; virtual;
 public
  Version: string;
  SelectedComponents: TComponentList;
  procedure Edit; override;
  procedure ExecuteVerb(Index: Integer); override;
  function GetVerb(Index: Integer): string; override;
  function GetVerbCount: Integer; override;
  function GetSelectionByClass(ClassType: TClass): TComponentList;
  procedure ApplyProcOnList(Proc: TwzsApplyProc);
 end;

 TwzsAboutInfoProperty = class(TStringProperty)
  protected
   procedure ShowAboutForm; virtual;
  public
   function GetAttributes: TPropertyAttributes; override;
   procedure Edit; override;
   function GetValue: string; override;
 end;


procedure Register;
procedure RegAboutProp(ComponentClass: TClass);

implementation

uses u_wzsToolsCommon, u_wzsToolsDesForm, u_wzsStyler;

procedure RegAboutProp(ComponentClass: TClass);
begin
  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   ComponentClass, 'About', TwzsAboutInfoProperty);
end;

procedure Register;
begin
  RegisterComponentEditor(TwzsStyler, TwzsToolsEditor);

  RegAboutProp(TwzsStyler);

end;

{ TwzsToolsEditor }

procedure TwzsToolsEditor.ShowDesignerForm;
var
 DesignerForm: TwzsToolsDesForm;

begin
 SelectedComponents:=GetSelectionByClass(Component.ClassType);

 DesignerForm:=TwzsToolsDesForm.Create(nil);
 DesignerForm.Editor:=self;
 DesignerForm.ShowModal;

 Designer.Modified;

end;

procedure TwzsToolsEditor.Edit;
begin
 ShowDesignerForm;
end;

procedure TwzsToolsEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
   0: Edit;
  end;
end;

function TwzsToolsEditor.GetVerb(Index: Integer): string;
begin
  case index of
   0: result:='Edit...';
  end;
end;

function TwzsToolsEditor.GetVerbCount: Integer;
begin
  result:=1;
end;

{ TwzsAboutInfoProperty }

procedure TwzsAboutInfoProperty.Edit;
begin
 {$ifdef ver150}
 Designer.Edit(GetComponent(0) as TComponent);
 {$else}
 ShowAboutForm;
 {$endif}
end;

function TwzsAboutInfoProperty.GetAttributes: TPropertyAttributes;
begin
 result:=[paReadOnly, paDialog];
end;

function TwzsAboutInfoProperty.GetValue: string;
begin
 result:=authTitle+' ['+urlFirst+', '+urlMail+']';
end;

function TwzsToolsEditor.GetSelectionByClass(
  ClassType: TClass): TComponentList;
var
 {$ifdef ver150}
 sel: IDesignerSelections;
 {$else}
 sel: TDesignerSelectionList;
 {$endif}

 list: TComponentList;
 c: TComponent;
 i: integer;
begin

 {$ifdef ver150}
 sel:=TDesignerSelections.Create;
 {$else}
 sel:=TDesignerSelectionList.create;
 {$endif}

 list:=TComponentList.Create;

 Designer.GetSelections(sel);

 for i:=0 to sel.Count-1 do
  begin
   c:=sel.Items[i] as TComponent;
   if c is ClassType then
     list.Add(c);
  end;

 result:=list;

end;

procedure TwzsToolsEditor.ApplyProcOnList(Proc: TwzsApplyProc);
var
 i: integer;
 component: TComponent;
begin
 if SelectedComponents<>nil then
  for i:=0 to SelectedComponents.Count-1 do
   begin
    component:=SelectedComponents[i];
    Proc(component);
   end;
end;

procedure TwzsAboutInfoProperty.ShowAboutForm;
var
 DesignerForm: TwzsToolsDesForm;

begin
 DesignerForm:=TwzsToolsDesForm.Create(nil);
 DesignerForm.Component:=GetComponent(0) as TComponent;
 DesignerForm.ShowModal;
end;


end.
