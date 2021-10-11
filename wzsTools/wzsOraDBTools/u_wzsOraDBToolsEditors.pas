{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}


unit u_wzsOraDBToolsEditors;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, OracleDesign {$ifdef ver150}, DesignEditors, DesignIntf {$else}, DsgnIntf {$endif}, StdCtrls, Contnrs,
  u_wzsToolsEditors {$ifdef ver150}, Variants {$endif};


type
 TwzsOraDBToolsEditor = class(TwzsToolsEditor)
 public
  procedure Edit; override;
 end;

 TwzsOracleDatasetEditor = class(TOracleDataSetEditor)
 private
 protected
  procedure ShowDesignerForm;
 public
  procedure ExecuteVerb(Index: Integer); override;
  function GetVerb(Index: Integer): string; override;
  function GetVerbCount: Integer; override;
 end;

 TProcNameProperty = class(TStringProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
 end;

 TPackageNameProperty = class(TStringProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
 end;

 TResultVariableProperty = class(TStringProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
 end;

 TSequenceNameProperty = class(TStringProperty)
 public
  function GetAttributes: TPropertyAttributes; override;
  procedure GetValues(Proc: TGetStrProc); override;
 end;

procedure Register;

implementation

uses u_wzsToolsCommon, u_wzsOraProcExecutor, u_wzsOraDBToolsCommon,
  u_wzsOraDataset, u_wzsToolsDesForm;

procedure Register;
begin
  RegisterComponentEditor(TwzsOraProcExecutor, TwzsOraDBToolsEditor);
  RegisterComponentEditor(TwzsOracleDataset, TwzsOracleDatasetEditor);

  RegisterPropertyEditor(TypeInfo(string),
   TwzsOraProcExecutor, 'ProcName', TProcNameProperty);
  RegisterPropertyEditor(TypeInfo(string),
   TwzsOraProcExecutor, 'PackageName', TPackageNameProperty);
  RegisterPropertyEditor(TypeInfo(string),
   TwzsOraProcExecutor, 'ResultVariable', TResultVariableProperty);
  RegisterPropertyEditor(TypeInfo(string),
   TwzsOraProcExecutor, 'SequenceName', TSequenceNameProperty);

  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   TwzsOraProcExecutor, 'About', TwzsAboutInfoProperty);
  RegisterPropertyEditor(TypeInfo(TwzsAboutInfo),
   TwzsOracleDataset, 'About', TwzsAboutInfoProperty);
end;


{ TProcNameProperty }

function TProcNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;


procedure TProcNameProperty.GetValues(Proc: TGetStrProc);
var
 c: TwzsOraProcExecutor;
begin

 c:=GetComponent(0) as TwzsOraProcExecutor;

 FillStringPropertyList(c.Session,
   'select procedure_name from user_procedures where object_name='''+c.PackageName+'''',
   Proc);


{
 list:=TStringList.Create;

 if (c.Session<>nil) then
  begin
    list:=GetFieldData(c.Session,
      'select procedure_name from user_procedures where object_name='''+c.PackageName+'''');
    for i := 0 to list.Count - 1 do
     Proc(list[i]);
  end;
}
end;

{ TPackageNameProperty }

function TPackageNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];

end;

procedure TPackageNameProperty.GetValues(Proc: TGetStrProc);
var
 c: TwzsOraProcExecutor;
begin

 c:=GetComponent(0) as TwzsOraProcExecutor;

 FillStringPropertyList(c.Session,
   'select distinct object_name from user_procedures',
   Proc);

end;

{ TResultVariableProperty }

function TResultVariableProperty.GetAttributes: TPropertyAttributes;
begin
   Result := [paValueList];
end;

procedure TResultVariableProperty.GetValues(Proc: TGetStrProc);
var
 list: TStringList;
 i: Integer;
 c: TwzsOraProcExecutor;
begin

 c:=GetComponent(0) as TwzsOraProcExecutor;

 list:=TStringList.Create;

 if (c.Variables.Count>0) then
  begin
    for i:=0 to c.Variables.Count-1 do
     list.Add(c.Variables.Data(i).name);

    for i := 0 to list.Count - 1 do
     Proc(list[i]);
  end;


end;

{ TSequenceNameProperty }

function TSequenceNameProperty.GetAttributes: TPropertyAttributes;
begin
 Result := [paValueList];
end;

procedure TSequenceNameProperty.GetValues(Proc: TGetStrProc);
var
 c: TwzsOraProcExecutor;
begin

 c:=GetComponent(0) as TwzsOraProcExecutor;

 FillStringPropertyList(c.Session,
   'select sequence_name from user_sequences',
   Proc);

end;

{ TwzsOraDBToolsEditor }

procedure TwzsOraDBToolsEditor.Edit;
begin
  Version:=PackageVer;

  inherited Edit;

end;

{ TwzsOracleDatasetEditor }

procedure TwzsOracleDatasetEditor.ExecuteVerb(Index: Integer);
begin

  case Index of
    0..6: inherited ExecuteVerb(Index);
    7: ShowDesignerForm;
  end;

end;

function TwzsOracleDatasetEditor.GetVerb(Index: Integer): string;
begin
  case Index of
   0..6: result:= inherited GetVerb(Index);
   7: result:='wzsOracleDataset additional...';
  end;
end;

function TwzsOracleDatasetEditor.GetVerbCount: Integer;
begin
  result := inherited GetVerbCount + 1;
end;

procedure TwzsOracleDatasetEditor.ShowDesignerForm;
var
 DesignerForm: TwzsToolsDesForm;

begin
 DesignerForm:=TwzsToolsDesForm.Create(nil);
 DesignerForm.Editor:=nil;
 DesignerForm.Component:=Component;
 DesignerForm.ComponentVersion:=PackageVer;
 DesignerForm.ShowModal;

 Designer.Modified;
end;

end.
