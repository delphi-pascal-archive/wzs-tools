{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsComponentsEditors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs {$ifdef ver150}, DesignEditors, DesignIntf {$else}, DsgnIntf {$endif}, StdCtrls, Contnrs,
  u_wzsToolsEditors {$ifdef ver150}, Variants {$endif};

type
 TwzsCompsEditor = class(TwzsToolsEditor)
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

uses u_wzsToolsCommon, u_wzsDBLookupCheckBox, u_wzsComponentsCommon ;

procedure Register;
begin
  RegisterComponentEditor(TwzsDBLookupCheckBox, TwzsCompsEditor);

  //RegisterPropertyEditor(TypeInfo(string),
  // TwzsOraProcExecutor, 'ProcName', TProcNameProperty);

  RegisterPropertyEditor(TypeInfo(string),
   TwzsDBLookupCheckBox, 'ListField', TDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string),
   TwzsDBLookupCheckBox, 'KeyField', TDataFieldProperty);

  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   TwzsDBLookupCheckBox, 'About', TwzsAboutInfoProperty);
end;


{ TwzsCompsEditor }

procedure TwzsCompsEditor.Edit;
begin
  Version:=PackageVer;

  inherited Edit;

end;

{ TDataFieldProperty }

function TDataFieldProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TDataFieldProperty.GetValues(Proc: TGetStrProc);
var
 i: Integer;
 c: TwzsDBLookupCheckBox;
begin

 c:=GetComponent(0) as TwzsDBLookupCheckBox;

 if c.DataLink.DataSet<>nil then
  begin
    for i := 0 to c.DataLink.DataSet.FieldList.Count - 1 do
      Proc(c.DataLink.DataSet.FieldList[i].FieldName);
  end;


end;

end.
