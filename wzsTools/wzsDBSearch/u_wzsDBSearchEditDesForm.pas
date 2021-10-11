{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsDBSearchEditDesForm;

interface

uses
  Windows, Messages, SysUtils, {$ifdef ver150} Variants, {$endif} Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, u_wzsToolsDesForm, ExtCtrls, Buttons;

type
  TwzsDBSearchEditDesForm = class(TwzsToolsDesForm)
    sbDrop: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbDropClick(Sender: TObject);
  private
    procedure ToComp(var Component: TComponent);
  public
  end;

var
  wzsDBSearchEditDesForm: TwzsDBSearchEditDesForm;

implementation

uses u_wzsDBSearch, u_wzsDBSearchEditors;

{$R *.dfm}

procedure TwzsDBSearchEditDesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

  Editor.ApplyProcOnList(ToComp);

end;

procedure TwzsDBSearchEditDesForm.ToComp(var Component: TComponent);
begin
// with Component as TwzsDBSearchEdit do
//  ClearText:=cbClearText.checked;
end;

procedure TwzsDBSearchEditDesForm.sbDropClick(Sender: TObject);
begin
  inherited;
  with Editor as TwzsDBSearchEditEditor do
   DropFieldLabel;
end;

end.
