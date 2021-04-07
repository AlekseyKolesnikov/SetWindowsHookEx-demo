unit uDemoHookForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Forms, Vcl.Dialogs, Vcl.Controls, Vcl.StdCtrls;

type
  TfrmHookDemo = class(TForm)
    btnStart: TButton;
    btnStop: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    LibHandle: THandle;
  public
    { Public declarations }
  end;

var
  frmHookDemo: TfrmHookDemo;

implementation

{$R *.dfm}

procedure TfrmHookDemo.btnStartClick(Sender: TObject);
type
  TStartHook = procedure;
var
  StartHook: TStartHook;
begin
  LibHandle := LoadLibrary('DemoHook.dll');

  if LibHandle = 0 then
  begin
    ShowMessage(SysErrorMessage(GetLastError()));
    Exit;
  end;

  @StartHook := GetProcAddress(LibHandle, PWideChar('sethook'));

  if @StartHook = nil then
  begin
    ShowMessage('sethook not found');
    Exit;
  end;

  btnStart.Enabled := False;
  btnStop.Enabled := True;

  StartHook;
end;

procedure TfrmHookDemo.btnStopClick(Sender: TObject);
type
  TStopHook = procedure;
var
  StopHook: TStopHook;
begin
  @StopHook := GetProcAddress(LibHandle, PWideChar('removehook'));

  if @StopHook = nil then
  begin
    ShowMessage('removehook not found');
    Exit;
  end;

  StopHook;

  FreeLibrary(LibHandle);

  btnStop.Enabled := False;
  btnStart.Enabled := True;
end;

procedure TfrmHookDemo.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if btnStop.Enabled then
    btnStopClick(nil);

  CanClose := True;
end;

end.
