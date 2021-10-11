unit u_wzsStyler;

interface

uses
  SysUtils, Classes, Graphics, Controls, Messages, CommCtrl,
  Windows, Dialogs, Forms,
  u_wzsToolsCommon;

//const
//  cm_wzsStylerChanged = CM_BASE + 201;

type
  TFrameStyles=(fsFlat, fsFlatSmooth, fsFlatRounded);

  TwzsStyler = class(TComponent)
  private
    FAbout: TwzsAboutInfo;
    FParent: TWinControl;
    FFrameColor: TColor;
    FFrameHotColor: TColor;
    FFrameInnerColor: TColor;
    FFrameInnerHotColor: TColor;
    FFrameStyle: TFrameStyles;
    FFlatScrollbars: boolean;
    FSmoothCorners: boolean;
    procedure SetFrameColor(Value: TColor);
    procedure SetFrameHotColor(Value: TColor);
    procedure SetFrameInnerColor(Value: TColor);
    procedure SetFrameInnerHotColor(Value: TColor);
    procedure SetFrameStyle(Value: TFrameStyles);
    procedure SetFlatScrollbars(Value: boolean);
    procedure SetSmoothCorners(Value: boolean);

  protected
    procedure StyleChangedNotify;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawFrame(C: TWinControl; msg: TMessage; DrawInnerFrame: boolean);
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property FrameColor: TColor read FFrameColor write SetFrameColor
      default clGray;
    property FrameHotColor: TColor read FFrameHotColor write SetFrameHotColor
      default cl3DDkShadow;
    property FrameInnerColor: TColor read FFrameInnerColor write SetFrameInnerColor
      default clBtnFace;
    property FrameInnerHotColor: TColor read FFrameInnerHotColor write SetFrameInnerHotColor
      default clSilver;
    property FrameStyle: TFrameStyles read FFrameStyle write SetFrameStyle
      default fsFlat;
    property FlatScrollbars: boolean read FFlatScrollbars write SetFlatScrollbars
      default false;
    property SmoothCorners: boolean read FSmoothCorners write SetSmoothCorners
      default true;

  end;

procedure Register;
procedure ColorToHSL( C: TColor; var H, S, L: Byte );
function HSLtoColor( H, S, L: Byte ): TColor;
function DarkerColor( C: TColor; Adjustment: Byte ): TColor;
function LighterColor( C: TColor; Adjustment: Byte ): TColor;
function BlendColors( ForeColor, BackColor: TColor; Alpha: Byte ): TColor;

implementation

uses Math;

type
  TControlCrack = class(TControl) end;

procedure Register;
begin
  RegisterComponents('wzsTools', [TwzsStyler]);
end;

procedure ColorToHSL( C: TColor; var H, S, L: Byte );
var
  Dif, CCmax, CCmin, RC, GC, BC, TempH, TempS, TempL: Double;
begin
  { Convert RGB color to Hue, Saturation and Luminance }

  { Convert Color to RGB color value. This is necessary if Color specifies
    a system color such as clHighlight }
  C := ColorToRGB( C );

  { Determine a percent (as a decimal) for each colorant }
  RC := GetRValue( C ) / 255;
  GC := GetGValue( C ) / 255;
  BC := GetBValue( C ) / 255;

  if RC > GC then
    CCmax := RC
  else
    CCmax := GC;
  if BC > CCmax then
    CCmax := BC;

  if RC < GC then
    CCmin := RC
  else
    CCmin := GC;

  if BC < CCmin then
    CCmin := BC;

  { Calculate Luminance }
  TempL := (CCmax + CCmin) / 2.0;

  if CCmax = CCmin then
  begin
    TempS := 0;
    TempH := 0;
  end
  else
  begin
    Dif := CCmax - CCmin;

    { Calculate Saturation }
    if TempL < 0.5 then
      TempS := Dif / (CCmax + CCmin)
    else
      TempS := Dif / ( 2.0 - CCmax - CCmin );

    { Calculate Hue }
    if RC = CCmax then
      TempH := (GC - BC) / Dif
    else if GC = CCmax then
      TempH := 2.0 + (BC - RC) / Dif
    else
      TempH := 4.0 + (RC - GC) / Dif;

    TempH := TempH / 6;
    if TempH < 0 then
      TempH := TempH + 1;
  end;

  H := Round( 240 * TempH );
  S := Round( 240 * TempS );
  L := Round( 240 * TempL );
end;

function HSLtoColor( H, S, L: Byte ): TColor;
var
  HN, SN, LN, RD, GD, BD, V, M, SV, Fract, VSF, Mid1, Mid2: Double;
  R, G, B: Byte;
  Sextant: Integer;
begin
  { Hue, Saturation, and Luminance must be normalized to 0..1 }

  HN := H / 239;
  SN := S / 240;
  LN := L / 240;

  if LN < 0.5 then
    V := LN * ( 1.0 + SN )
  else
    V := LN + SN - LN * SN;
  if V <= 0 then
  begin
    RD := 0.0;
    GD := 0.0;
    BD := 0.0;
  end
  else
  begin
    M := LN + LN - V;
    SV := (V - M ) / V;
    HN := HN * 6.0;
    Sextant := Trunc( HN );
    Fract := HN - Sextant;
    VSF := V * SV * Fract;
    Mid1 := M + VSF;
    Mid2 := V - VSF;

    case Sextant of
      0:
      begin
        RD := V;
        GD := Mid1;
        BD := M;
      end;

      1:
      begin
        RD := Mid2;
        GD := V;
        BD := M;
      end;

      2:
      begin
        RD := M;
        GD := V;
        BD := Mid1;
      end;

      3:
      begin
        RD := M;
        GD := Mid2;
        BD := V;
      end;

      4:
      begin
        RD := Mid1;
        GD := M;
        BD := V;
      end;

      5:
      begin
        RD := V;
        GD := M;
        BD := Mid2;
      end;

      else
      begin
        RD := V;
        GD := Mid1;
        BD := M;
      end;
    end;
  end;

  if RD > 1.0 then
    RD := 1.0;
  if GD > 1.0 then
    GD := 1.0;
  if BD > 1.0 then
    BD := 1.0;
  R := Round( RD * 255 );
  G := Round( GD * 255 );
  B := Round( BD * 255 );
  Result := RGB( R, G, B );
end; {= HSLtoColor =}


function DarkerColor( C: TColor; Adjustment: Byte ): TColor;
var
  H, S, L: Byte;
begin
  ColorToHSL( C, H, S, L );
  Result := HSLtoColor( H, S, Max( L - Adjustment, 0 ) );
end;

function LighterColor( C: TColor; Adjustment: Byte ): TColor;
var
  H, S, L: Byte;
begin
  ColorToHSL( C, H, S, L );
  Result := HSLtoColor( H, S, Min( L + Adjustment, 255 ) );
end;


function BlendColors( ForeColor, BackColor: TColor; Alpha: Byte ): TColor;
var
  ForeRed, ForeGreen, ForeBlue: Byte;
  BackRed, BackGreen, BackBlue: Byte;
  BlendRed, BlendGreen, BlendBlue: Byte;
  AlphaValue: Single;
begin
  AlphaValue := Alpha / 255;

  ForeColor := ColorToRGB( ForeColor );
  ForeRed   := GetRValue( ForeColor );
  ForeGreen := GetGValue( ForeColor );
  ForeBlue  := GetBValue( ForeColor );

  BackColor := ColorToRGB( BackColor );
  BackRed   := GetRValue( BackColor );
  BackGreen := GetGValue( BackColor );
  BackBlue  := GetBValue( BackColor );

  BlendRed := Round( AlphaValue * ForeRed + ( 1 - AlphaValue ) * BackRed );
  BlendGreen := Round( AlphaValue * ForeGreen + ( 1 - AlphaValue ) * BackGreen );
  BlendBlue := Round( AlphaValue * ForeBlue + ( 1 - AlphaValue ) * BackBlue );

  Result := RGB( BlendRed, BlendGreen, BlendBlue );
end;

{
  //get control real client origin
  ctrlPoint:=Control.Parent.ScreenToClient(Control.ClientOrigin);
  ctrlPoint.X:=ctrlPoint.X+(Control.Parent.ClientOrigin.x-Control.Parent.Left)-brdrFix;
  ctrlPoint.Y:=ctrlPoint.y+(Control.Parent.ClientOrigin.y-Control.Parent.Top)-brdrFix;
}

{ TwzsStyle }



constructor TwzsStyler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FParent:=AOwner as TWinControl;

  FFrameColor:=clGray;
  FFrameHotColor:=cl3DDkShadow;
  FFrameInnerColor:=clBtnFace;
  FFrameInnerHotColor:=clSilver;  
  FFrameStyle:=fsFlat;
  FFlatScrollbars:=false;
  FSmoothCorners:=true;
end;

procedure TwzsStyler.DrawFrame(C: TWinControl; msg: TMessage; DrawInnerFrame: boolean);
var
  canvas: TControlCanvas;
  clFrame, clInnerFrame, clParentBk, clBlend1, clBlend2: TColor;
  cornOffs: byte;
  fixW, fixH: integer;
  isHot: boolean;

  procedure DrawCornerPts;
  begin
      canvas.Pixels[0,0]:=clBlend1;
      canvas.Pixels[fixW,0]:=clBlend1;
      canvas.Pixels[fixW, fixH]:=clBlend1;
      canvas.Pixels[0, fixH]:=clBlend1;
  end;

  procedure DrawPreCornerPts;
  begin
      canvas.Pixels[1, 0]:=clBlend2;
      canvas.Pixels[fixW-1, 0]:=clBlend2;
      canvas.Pixels[fixW, 1]:=clBlend2;
      canvas.Pixels[fixW, fixH-1]:=clBlend2;
      canvas.Pixels[fixW-1, fixH]:=clBlend2;
      canvas.Pixels[1, fixH]:=clBlend2;
      canvas.Pixels[0, fixH-1]:=clBlend2;
      canvas.Pixels[0, 1]:=clBlend2;
  end;

begin
  //get the parent's color prop
  clParentBk:=TControlCrack(C.Parent).Color;

  fixW:=C.Width-1;
  fixH:=C.Height-1;

  isHot:=false;

  {
  case msg.Msg of
    wm_SetFocus: isHot:=true;
    wm_KillFocus: isHot:=false;
  end;
  }

  //isHot:=C.Focused;

  //if not C.Focused then
    case msg.Msg of
      cm_MouseEnter: isHot:=true;
      cm_MouseLeave: isHot:=false;
    end;
  //else
    //isHot:=true;

  if isHot then
  begin
    clFrame:=FFrameHotColor;
    clInnerFrame:=FFrameInnerHotColor;
  end
    else
  begin
    clFrame:=FFrameColor;
    clInnerFrame:=FFrameInnerColor;
  end;

  //corner size for roundrect
  case FFrameStyle of
    fsFlat: cornOffs:=0;
    fsFlatSmooth: cornOffs:=2;
    fsFlatRounded: cornOffs:=5;
  end;

  //get control's canvas
  canvas:=TControlCanvas.Create;
  canvas.Control:=C;
  canvas.Handle:=GetWindowDC(C.Handle);

  canvas.Brush.Style:=bsClear;
  canvas.Pen.Style:=psSolid;

  if DrawInnerFrame then
  begin
    canvas.Pen.Color:=clInnerFrame;
    canvas.Rectangle(1, 1, C.Width-1, C.Height-1);
  end;

  canvas.Pen.Color:=clFrame;
  canvas.RoundRect(0, 0, C.Width, C.Height, cornOffs, cornOffs);

  //corner smoothing
  if FSmoothCorners then
  begin
    clBlend1:=BlendColors(clFrame, clParentBk, 35);
    clBlend2:=BlendColors(clFrame, clParentBk, 150);
    case FFrameStyle of
      fsFlatSmooth, fsFlatRounded:
      begin
        DrawCornerPts;
        DrawPreCornerPts;
      end;
    end;
  end
    else
  begin
    clBlend1:=clParentBk;
    clBlend2:=clParentBk;    //clFrame;
    case FFrameStyle of
      fsFlatSmooth:
        DrawCornerPts;
      fsFlatRounded:
      begin
        DrawCornerPts;
        DrawPreCornerPts;
      end;
    end;
  end;

  canvas.FreeHandle;
  canvas.Free;
  
  {
  dc:=GetWindowDC(Control.Handle);

  brush:=SelectObject(dc, GetStockObject(NULL_BRUSH));

  if DrawInnerFrame then
  begin
    pen:=SelectObject(dc, CreatePen(PS_SOLID, 1, ColorToRGB(FFrameInnerColor)));
    Rectangle(dc, 1, 1, Control.Width-1, Control.Height-1);
  end;


  pen:=SelectObject(dc, CreatePen(PS_SOLID, 1, ColorToRGB(frmColor)));
  RoundRect(dc, 0, 0, Control.Width, Control.Height, cOff, cOff);

  DeleteObject(pen);
  ReleaseDC(Control.Handle, canvas.Handle);
  }
end;

procedure TwzsStyler.SetFlatScrollbars(Value: boolean);
begin
  if FFlatScrollbars <> Value then
  begin
    FFlatScrollbars:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.SetFrameColor(Value: TColor);
begin
  if FFrameColor <> Value then
  begin
    FFrameColor:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.SetFrameHotColor(Value: TColor);
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.SetFrameInnerColor(Value: TColor);
begin
  if FFrameInnerColor <> Value then
  begin
    FFrameInnerColor:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.SetFrameInnerHotColor(Value: TColor);
begin
  if FFrameInnerHotColor <> Value then
  begin
    FFrameInnerHotColor:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.SetFrameStyle(Value: TFrameStyles);
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.SetSmoothCorners(Value: boolean);
begin
  if FSmoothCorners <> Value then
  begin
    FSmoothCorners:=Value;
    StyleChangedNotify;
  end;
end;

procedure TwzsStyler.StyleChangedNotify;
var
  m: TMessage;
  i,j: integer;
  wc1, wc2: TWinControl;
begin
  {
  m.Msg:=cm_wzsStylerChanged;
  m.WParam := 0;
  m.LParam := Longint(Self);
  m.Result := 0;
  }

  m.Msg:=wm_NCPaint;
  m.WParam := 0;
  m.LParam := Longint(Self);
  m.Result := 0;

  FParent.Broadcast(m);
  for i:= 0 to FParent.ControlCount-1 do
  begin
    if FParent.Controls[i] is TWinControl then
    begin
      wc1:=FParent.Controls[i] as TWinControl;
      wc1.Broadcast(m);
    end;  
    {for j:=0 to wc1.ControlCount-1 do
    begin
      wc2:=wc1.Controls[j] as TWinControl;
      wc2.Broadcast(m);
    end;}
  end;
end;

end.
