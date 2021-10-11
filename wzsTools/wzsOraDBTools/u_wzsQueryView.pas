unit u_wzsQueryView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, OracleData, StdCtrls, ActnList;

type
  TwzsQueryView = class(TForm)
    mmQueryView: TMemo;
    ActionList1: TActionList;
    GetQuery: TAction;
    procedure FormShow(Sender: TObject);
    procedure GetQueryExecute(Sender: TObject);
  private
    { Private declarations }
  public
    Dataset: TOracleDataset;
    
  end;

var
  wzsQueryView: TwzsQueryView;

implementation

uses u_wzsOraDBToolsCommon;

{$R *.DFM}

procedure TwzsQueryView.FormShow(Sender: TObject);
begin
  GetQuery.Execute;
end;

procedure TwzsQueryView.GetQueryExecute(Sender: TObject);
begin
  if Dataset <> nil then
  begin
    mmQueryView.Clear;
    mmQueryView.Lines.Add(GetFinalSQL(Dataset));
  end;
end;

end.
