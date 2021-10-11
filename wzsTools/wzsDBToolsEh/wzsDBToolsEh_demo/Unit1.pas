unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, OracleData, Oracle, GridsEh, DBGridEh, u_wzsDBGrid,
  ExtCtrls, OracleNavigator, StdCtrls, Buttons, MemTableDataEh,
  DataDriverEh, EhlibDOA, ActnList, u_wzsStyler, Mask, DBCtrlsEh,
  u_wzsDBEdits, DBLookupEh, ToolCtrlsEh;

type
  TForm1 = class(TForm)
    OracleSession1: TOracleSession;
    odsEmp: TOracleDataSet;
    odsDept: TOracleDataSet;
    dsEmp: TDataSource;
    dsDept: TDataSource;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    CheckBox3: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    wzsDBGrid1: TwzsDBGrid;
    odsEmpEMPNO: TIntegerField;
    odsEmpENAME: TStringField;
    odsEmpJOB: TStringField;
    odsEmpMGR: TIntegerField;
    odsEmpHIREDATE: TDateTimeField;
    odsEmpSAL: TFloatField;
    odsEmpCOMM: TFloatField;
    odsEmpDEPTNO: TIntegerField;
    odsEmplkDept: TStringField;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    wzsStyler1: TwzsStyler;
    wzsDBEdit1: TwzsDBEdit;
    wzsDBComboBox1: TwzsDBComboBox;
    wzsDBDateTimeEdit1: TwzsDBDateTimeEdit;
    wzsDBNumberEdit1: TwzsDBNumberEdit;
    wzsDBLookupCombobox1: TwzsDBLookupCombobox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox2: TCheckBox;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    ColorBox3: TColorBox;
    ComboBox1: TComboBox;
    CheckBox7: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    GroupBox4: TGroupBox;
    wzsDBEdit3: TwzsDBEdit;
    Label11: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure OracleDataSet1AfterOpen(DataSet: TDataSet);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure ColorBox2Change(Sender: TObject);
    procedure ColorBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
  private
    procedure SetFlat(var obj: TControl);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  u_wzsToolsCommon;

type TGridCrack=class(TCustomDBGridEh) end;

//var
// tmp: integer;

{$R *.dfm}

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  wzsDBGrid1.Additional.ColumnsHighlight.Active:=CheckBox1.Checked;
end;

procedure TForm1.OracleDataSet1AfterOpen(DataSet: TDataSet);
begin
 // showmessage('form: after Open');
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  odsEmp.Active:=CheckBox3.Checked;
end;


procedure TForm1.CheckBox4Click(Sender: TObject);
begin
 wzsDBGrid1.Additional.DefaultFilter:= CheckBox4.Checked;
end;

procedure TForm1.CheckBox5Click(Sender: TObject);
begin
 wzsDBGrid1.Additional.FilterLookupList:= CheckBox5.Checked;
end;

procedure TForm1.CheckBox6Click(Sender: TObject);
begin
 wzsDBGrid1.Additional.FilterValueList:= CheckBox6.Checked;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DBGridEhCenter.FilterEditCloseUpApplyFilter:=true;

end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  ApplyProcOnControl(GroupBox3, SetFlat, TCustomDBEditEh, '*');
  wzsDBGrid1.Flat:=CheckBox2.Checked;
end;

procedure TForm1.SetFlat(var obj: TControl);
begin
  with obj as TCustomDBEditEh do
    Flat:=CheckBox2.Checked;
end;

procedure TForm1.ColorBox1Change(Sender: TObject);
begin
  wzsStyler1.FrameColor:=ColorBox1.Selected;
end;

procedure TForm1.ColorBox2Change(Sender: TObject);
begin
  wzsStyler1.FrameHotColor:=ColorBox2.Selected;
end;

procedure TForm1.ColorBox3Change(Sender: TObject);
begin
  wzsStyler1.FrameInnerColor:=ColorBox3.Selected;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: wzsStyler1.FrameStyle:=fsFlat;
    1: wzsStyler1.FrameStyle:=fsFlatSmooth;
    2: wzsStyler1.FrameStyle:=fsFlatRounded;
  end;
end;

procedure TForm1.CheckBox7Click(Sender: TObject);
begin
  wzsStyler1.SmoothCorners:=CheckBox7.Checked;
end;

end.
