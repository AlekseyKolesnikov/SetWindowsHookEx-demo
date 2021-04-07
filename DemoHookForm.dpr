program DemoHookForm;

uses
  Vcl.Forms,
  uDemoHookForm in 'uDemoHookForm.pas' {frmHookDemo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmHookDemo, frmHookDemo);
  Application.Run;
end.
