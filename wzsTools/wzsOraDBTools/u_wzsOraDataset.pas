{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}

unit u_wzsOraDataset;

interface

uses
  SysUtils, Classes, Controls, StdCtrls, Mask, Dialogs, Oracle, OracleData,
  {$ifdef ver150} Variants, {$endif} Windows, Graphics,
  DB, Messages, Menus, Forms, Buttons, u_wzsToolsCommon;

{
resourcestring
  SColumnSortHint='Сортировать по полю "%s"';
  SFilterError='Ошибка применения фильтра';
}

type

  TwzsOracleDataset = class;

  TwzsOracleDatasetAdditional = class(TPersistent)
  private
   FOwner: TwzsOracleDataset;
   FAllowInsert, FAllowDelete: boolean;
   FKeepBookmark: boolean;
   FRefreshAfterPost: boolean;
   procedure SetKeepBookmark(Value: boolean);
  protected
  public
    constructor Create(AOwner: TwzsOracleDataset);
  published
    property KeepBookmark: boolean read FKeepBookmark write SetKeepBookmark
      default false;
    property RefreshAfterPost: boolean read FRefreshAfterPost write FRefreshAfterPost
      default false;
    property AllowInsert: boolean read FAllowInsert write FAllowInsert
      default true;
    property AllowDelete: boolean read FAllowDelete write FAllowDelete
      default true;
  end;

 TwzsOracleDataset = class(TOracleDataset)
  private
    FAbout: TwzsAboutInfo;
    FAdditional: TwzsOracleDatasetAdditional;
    FMyBookmark: TBookmark;
    FPrevRecNo: integer;
  protected
    procedure DoBeforeInsert; override;
    procedure DoBeforeDelete; override;

    procedure DoBeforeRefresh; override;
    procedure DoAfterRefresh; override;
    procedure DoAfterPost; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveMyBookmark;
    procedure GotoMyBookmark;
  published
    property About: TwzsAboutInfo read FAbout write FAbout;
    property Additional: TwzsOracleDatasetAdditional read FAdditional write FAdditional;

  end;

procedure Register;

implementation

uses qStrings;

procedure Register;
begin
  RegisterComponents('wzsTools', [TwzsOracleDataset]);

end;

{ TwzsOracleDataset }

constructor TwzsOracleDataset.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //RefreshOptions:=[roAfterInsert, roAfterUpdate];
  //OracleDictionary.DefaultValues:=true;

  FAdditional:=TwzsOracleDatasetAdditional.Create(self);

  FMyBookmark:=nil;
  FPrevRecNo:=1;

end;

{ TwzsDBGridAdditional }

constructor TwzsOracleDatasetAdditional.Create(AOwner: TwzsOracleDataset);
begin
  inherited Create;

  FOwner:=AOwner;

  FKeepBookmark:=false;
  FRefreshAfterPost:=false;

  FAllowInsert:=true;
  FAllowDelete:=true;
end;



procedure TwzsOracleDatasetAdditional.SetKeepBookmark(Value: boolean);
begin
  FKeepBookmark:=Value;
end;

procedure TwzsOracleDataset.DoAfterPost;
begin
  inherited DoAfterPost;

  if FAdditional.RefreshAfterPost then
    Refresh;
end;

procedure TwzsOracleDataset.DoAfterRefresh;
begin
  inherited DoAfterRefresh;

  if FAdditional.KeepBookmark then
    GotoMyBookmark;
end;

procedure TwzsOracleDataset.DoBeforeDelete;
begin
  inherited DoBeforeDelete;

  if not FAdditional.AllowDelete then
    Abort;
end;

procedure TwzsOracleDataset.DoBeforeInsert;
begin
  inherited DoBeforeInsert;

  if not FAdditional.AllowInsert then
    Abort;
end;

procedure TwzsOracleDataset.DoBeforeRefresh;
begin
  inherited DoBeforeRefresh;

  if FAdditional.KeepBookmark then
    SaveMyBookmark;
end;

procedure TwzsOracleDataset.GotoMyBookmark;
begin
  if BookmarkValid(FMyBookmark) then
    GotoBookmark(FMyBookmark)
  else
    RecNo:=FPrevRecNo-1;
  
{  try
    GotoBookmark(FMyBookmark);
  except
    RecNo:=FPrevRecNo-1;
  end;}
end;

procedure TwzsOracleDataset.SaveMyBookmark;
begin
  FMyBookmark:=GetBookmark;
  FPrevRecNo:=RecNo;
end;

end.
