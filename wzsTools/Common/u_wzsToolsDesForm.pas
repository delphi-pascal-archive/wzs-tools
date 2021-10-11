{
wzsTools components
(c) Protasov Serg

wzonnet.blogspot.com
wzff.livejournal.com
wzonnet@kemcity.ru
}


unit u_wzsToolsDesForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, u_wzsToolsEditors, ComCtrls, ExtCtrls, StdCtrls, Buttons
  {$ifdef ver150} , Variants, ActnList, ImgList {$endif};

type
  TwzsToolsDesForm = class(TForm)
    pnlMain: TPanel;
    pnlBottom: TPanel;
    Image1: TImage;
    lbAuthor: TLabel;
    lbUrl1: TLabel;
    lbUrl2: TLabel;
    pnlStatus: TPanel;
    lbStatus: TLabel;
    sbOk: TSpeedButton;
    sbHelp: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbUrl1Click(Sender: TObject);
    procedure lbUrl2Click(Sender: TObject);
    procedure sbOkClick(Sender: TObject);
    procedure sbHelpClick(Sender: TObject);
  private
  public
    Editor: TwzsToolsEditor;
    Component: TComponent;
    ComponentVersion: string;
  end;

var
  wzsToolsDesForm: TwzsToolsDesForm;

implementation

uses u_wzsToolsCommon;

{$R *.dfm}

procedure TwzsToolsDesForm.FormShow(Sender: TObject);
begin
 Caption:='wzsTools';

 //for calling from TwzsAboutInfoProperty
 //(and in any cases when we cant get editor)
 if Component<>nil then
  begin
   Caption:=Component.ClassName+' '+ComponentVersion;
   lbStatus.Caption:='1 of '+Component.ClassName+' selected';
  end;

 //for calling from component editor
 if Editor<>nil then
  begin
   Caption:=Editor.Component.ClassName+' '+Editor.Version;
   lbStatus.Caption:=' '+inttostr(Editor.SelectedComponents.Count)+
     ' of '+Editor.Component.ClassName+' selected';
   Component:=Editor.Component;
  end;

 lbAuthor.Caption:=authTitle;
 lbUrl1.Caption:=urlFirst;
 lbUrl2.Caption:=urlMail;

end;

procedure TwzsToolsDesForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TwzsToolsDesForm.lbUrl1Click(Sender: TObject);
begin
 ShellOpen(lbUrl1.Caption);
end;

procedure TwzsToolsDesForm.lbUrl2Click(Sender: TObject);
begin
 ShellOpen(lbUrl2.Caption);
end;

procedure TwzsToolsDesForm.sbOkClick(Sender: TObject);
begin
 Close;
end;


procedure TwzsToolsDesForm.sbHelpClick(Sender: TObject);
begin
 ShellOpen(urlFirst);
end;

end.
