unit winapi;

// Simple WinAPI library for Borderless Window Tool.

{$codepage utf8}
{$mode ObjFPC}{$H+}

interface

uses
  Windows;

function EnumWindowsProc(AWHandle: THandle; ALParM: LParam): LongBool; StdCall;
function GetWindowHandle(AWindowTitle: string): THandle;
procedure SetBorderlessWindow(AWindowHandle: THandle);
procedure SetWindowFullScreen(AWindowHandle: THandle);

implementation

function EnumWindowsProc(AWHandle: THandle; ALParM: LParam): LongBool; StdCall;
var
  LLen: LongInt;
  LTitle: array of WideChar;
begin
  Result:=True;
  if IsWindowVisible(AWHandle) then
    begin
      lLen:=GetWindowTextLengthW(AWHandle)+1;
      if lLen>1 then
        begin
          SetLength(LTitle, LLen);
          GetWindowTextW(AWHandle, @LTitle[0], lLen);
          Writeln('"'+WideCharToString(@LTitle[0])+'"');
        end;
    end;
end;

function GetWindowHandle(AWindowTitle: string): THandle;
begin
  Result:=FindWindowW(nil, PWideChar(UnicodeString(AWindowTitle)));
end;

procedure SetBorderlessWindow(aWindowHandle: THandle);
var
  LRect: TRect;
begin
  if aWindowHandle>0 then
    begin
      GetWindowRect(aWindowHandle, LRect);
      SetWindowLong(aWindowHandle, GWL_STYLE, WS_VISIBLE or WS_CLIPCHILDREN);
      MoveWindow(aWindowHandle, LRect.Left, LRect.Top, LRect.Width-1, LRect.Height-1, True);
      SetWindowPos(aWindowHandle, HWND_TOPMOST, LRect.Left, LRect.Top, LRect.Width, LRect.Height, SWP_FRAMECHANGED or SWP_NOZORDER or SWP_NOOWNERZORDER);
    end;
end;

procedure SetWindowFullScreen(aWindowHandle: THandle);
var
  LDevMode: tDEVMODE;
begin
  if aWindowHandle>0 then
    begin
      FillChar(LDevMode, SizeOf(LDevMode), #0);
      LDevMode.dmSize:=SizeOf(LDevMode);
      EnumDisplaySettings(nil, ENUM_REGISTRY_SETTINGS, @lDevMode);
      if (LDevMode.dmPelsWidth<=0) or (LDevMode.dmPelsHeight<=0) then
        EnumDisplaySettings(nil, ENUM_CURRENT_SETTINGS, @lDevMode);
      if (LDevMode.dmPelsWidth>0) or (LDevMode.dmPelsHeight>0) then
        SetWindowPos(aWindowHandle, HWND_TOPMOST, 0, 0, LDevMode.dmPelsWidth, LDevMode.dmPelsHeight, SWP_FRAMECHANGED or SWP_NOZORDER or SWP_NOOWNERZORDER)
      else
        Writeln('Can not resize your windows.');
   end;
end;

end.

