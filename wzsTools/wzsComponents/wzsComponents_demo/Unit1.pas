unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, u_wzsDBLookupCheckBox, DB, OracleData,
  Oracle, u_wzsStyler;

type
  TForm1 = class(TForm)
    OracleSession1: TOracleSession;
    OracleDataSet1: TOracleDataSet;
    DataSource1: TDataSource;
    wzsDBLookupCheckBox1: TwzsDBLookupCheckBox;
    Label1: TLabel;
    Button1: TButton;
    wzsStyler1: TwzsStyler;
    procedure Button1Click(Sender: TObject);
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
  showmessage(wzsDBLookupCheckBox1.KeyValuesString);
  showmessage(wzsDBLookupCheckBox1.SelListValuesString);
end;

end.
