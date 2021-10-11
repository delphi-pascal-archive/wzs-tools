program demo_doa;

uses
  Forms,
  u_demo_doa in 'u_demo_doa.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
