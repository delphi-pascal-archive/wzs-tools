unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, OracleData, u_wzsOraDataset, Oracle, Grids, DBGrids,
  ExtCtrls, DBCtrls;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    OracleSession1: TOracleSession;
    wzsOracleDataset1: TwzsOracleDataset;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
