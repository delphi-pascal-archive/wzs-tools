unit u_demo_doa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, Grids, DBGrids, OracleData,
  Oracle, ExtCtrls, OracleNavigator, DBCtrls, Buttons, 
  u_wzsDBSearch, Mask, DBCtrlsEh, DBGridEh, DBLookupEh, ComCtrls;

type
  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    OracleDataSet2: TOracleDataSet;
    DataSource2: TDataSource;
    OracleSession1: TOracleSession;
    OracleDataSet1: TOracleDataSet;
    DataSource1: TDataSource;
    OracleDataSet1EMPNO: TIntegerField;
    OracleDataSet1ENAME: TStringField;
    OracleDataSet1JOB: TStringField;
    OracleDataSet1MGR: TIntegerField;
    OracleDataSet1HIREDATE: TDateTimeField;
    OracleDataSet1SAL: TFloatField;
    OracleDataSet1COMM: TFloatField;
    OracleDataSet1DEPTNO: TIntegerField;
    OracleDataSet1lookup_dept: TStringField;
    wzsDBSearchEngine1: TwzsDBSearchEngine;
    wzsDBSearchEdit1: TwzsDBSearchEdit;
    Label1: TLabel;
    wzsDBSearchEdit2: TwzsDBSearchEdit;
    Label2: TLabel;
    wzsDBSearchEdit3: TwzsDBSearchEdit;
    Label3: TLabel;
    wzsGroupFilterButton1: TwzsGroupFilterButton;
    wzsGroupClearButton1: TwzsGroupClearButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    StatusBar1: TStatusBar;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure OracleDataSet1FilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 wzsDBSearchEdit3.KeyValue:=30;
end;

procedure TForm1.OracleDataSet1FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  StatusBar1.SimpleText:=wzsDBSearchEngine1.FilterExpr.GetFieldsFilterStr;
end;

end.
