unit u_wzsComponentsCommon;

interface

{$R 'wzsComponents.dcr'}

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, Messages,
  Dialogs, Graphics, Windows, Menus, u_wzsToolsCommon, u_wzsStyler;


type
  TwzsAdditional = class(TPersistent)
  private
    FOwner: TWinControl;
    FStyler: TwzsStyler;
    procedure SetStyler(Value: TwzsStyler);
  protected
  public
    constructor Create(AOwner: TWinControl);
  published
    property Styler: TwzsStyler read FStyler write SetStyler;
  end;

const
 PackageVer='1.2';

implementation

type
  TWinControlCracker = class(TWinControl) end;


{ TwzsAdditional }

constructor TwzsAdditional.Create(AOwner: TWinControl);
begin
  FOwner:=AOwner;
end;

procedure TwzsAdditional.SetStyler(Value: TwzsStyler);
begin
  if Value<>FStyler then
  begin
    FStyler:=Value;
    TWinControlCracker(FOwner).RecreateWnd;
  end;
end;

end.
