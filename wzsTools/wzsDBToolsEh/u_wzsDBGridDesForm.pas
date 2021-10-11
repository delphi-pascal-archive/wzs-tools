unit u_wzsDBGridDesForm;

interface

uses
  Windows, Messages, SysUtils, {$ifdef ver150} Variants, {$endif} Classes, Graphics, Controls, Forms,
  Dialogs, u_wzsToolsDesForm, ExtCtrls, Buttons, StdCtrls;

type
  TwzsDBGridDesForm = class(TwzsToolsDesForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  wzsDBGridDesForm: TwzsDBGridDesForm;

implementation

{$R *.dfm}

end.
