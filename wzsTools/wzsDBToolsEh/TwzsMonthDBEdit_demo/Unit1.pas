unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, u_wzsMonthDBEdit, ComCtrls, DB,
  OracleData, Oracle, ExtCtrls, OracleNavigator;

type
  TForm1 = class(TForm)
    MonthCalendar1: TMonthCalendar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    wzsMonthDBEdit1: TwzsMonthDBEdit;
    CheckBox2: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure wzsMonthDBEdit1Change(Sender: TObject);
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
  wzsMonthDBEdit1.Value:=MonthCalendar1.Date;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if wzsMonthDBEdit1.Value = null then
    showmessage('value is null')
  else
    MonthCalendar1.Date:=wzsMonthDBEdit1.Value;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 wzsMonthDBEdit1.value:=null;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  wzsMonthDBEdit1.DefaultLineVisible:=CheckBox1.Checked;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  wzsMonthDBEdit1.NullLineVisible:=CheckBox2.Checked;
end;

procedure TForm1.wzsMonthDBEdit1Change(Sender: TObject);
begin
  if wzsMonthDBEdit1.Value = null then
    showmessage('null')
  else
    showmessage(DateToStr(wzsMonthDBEdit1.Value))

end;

end.
