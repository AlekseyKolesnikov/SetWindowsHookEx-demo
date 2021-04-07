library ThunderTrayHook;

uses
  windows, messages, SysUtils, Classes;

var
  HookHandle: THandle;
  slList: TStringList;

function CodeToString(code: integer): String;
begin
  case code of
    0: Result := 'HCBT_MOVESIZE    ';
    1: Result := 'HCBT_MINMAX      ';
    2: Result := 'HCBT_QS          ';
    3: Result := 'HCBT_CREATEWND   ';
    4: Result := 'HCBT_DESTROYWND  ';
    5: Result := 'HCBT_ACTIVATE    ';
    6: Result := 'HCBT_CLICKSKIPPED';
    7: Result := 'HCBT_KEYSKIPPED  ';
    8: Result := 'HCBT_SYSCOMMAND  ';
    9: Result := 'HCBT_SETFOCUS    ';
  else Result := IntToHex(code, 8) + '         ';
  end;
end;

function hook(code: integer; w_param: WPARAM; l_param: LPARAM): Lresult; stdcall;
begin
  try
    slList.Add(DateTimeToStr(Now) + '  code ' + CodeToString(code) + '  w_param ' + IntToHex(w_param, 16) + '  l_param ' + IntToHex(l_param, 16));

    if (code = 1) and IsWindow(w_param) then
    begin
      if IsIconic(w_param) then
        slList.Add(DateTimeToStr(Now) + '  icon TRUE')
      else
        slList.Add(DateTimeToStr(Now) + '  icon FALSE');
    end;

    slList.SaveToFile('D:\debug_lib.log');
  except
  end;

  if code < 0 then
  try
    Result := CallNextHookEx(HookHandle, code, w_param, l_param)
  except
    Result := 0;
  end
  else
    Result := 0;
end;

procedure sethook;
begin
  slList := TStringList.Create;

  HookHandle := SetWindowsHookEx(WH_CBT, @hook, hInstance, 0);

  if HookHandle = 0 then
    MessageBox(0, 'Error setting hook...', 'Error', MB_ICONHAND);
end;

procedure removehook;
begin
  UnhookWindowsHookEx(HookHandle);

  slList.Free;
end;

exports
  sethook name 'sethook',
  removehook name 'removehook';
end.

