program BorderlessWindowTool;

// "Borderless Window Tool" is a simple tool to force most applications windows into a borderless windowed mode.
// Copyright (c) 2023 Greg P. (https://github.com/coffeegreg)
// Borderless Window Tool is licensed under MIT license.
// See the https://github.com/coffeegreg/BorderlessWindowTool/LICENSE.txt file for more details.

{$codepage utf8}
{$mode objfpc}{$H+}

uses
  Classes, CustApp, Windows, winapi;

const
  APP_NAME = 'Borderless Window Tool';
  APP_VERSION = 'v1.0';
  APP_COPYRIGHT = 'Copyright (c) 2023 Greg P. (https://github.com/coffeegreg)';

type
  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  lErrorMsg: String;
  lWindowHandle: THandle;
begin
  lErrorMsg:=CheckOptions('h l w: b f', 'help list window: borderlesswindow fullscreen');
  if lErrorMsg<>'' then begin
    writeln(lErrorMsg);
    Terminate;
    Exit;
  end;

  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('l', 'list') then
    begin
      EnumWindows(@EnumWindowsProc,0);
      Terminate;
      Exit;
    end;

  if HasOption('w', 'window') then
    begin
      lWindowHandle:=GetWindowHandle(GetOptionValue('w','window'));
      if HasOption('b', 'borderlesswindow') then
        SetBorderlessWindow(lWindowHandle);
      if HasOption('f', 'fullscreen') then
       SetWindowFullScreen(lWindowHandle);
      Terminate;
      Exit;
    end;

  WriteHelp;
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  writeln(Title);
  writeln('Usage: ', ExeName, ' [options]');
  writeln('-h [--help]'+#09+#09+#09+'Shows this help.');
  writeln('-l [--list]'+#09+#09+#09+'List visible windows captions.');
  writeln('-w [--window=]<window_caption>'+#09+'Selected window caption.');
  writeln('-b [--borderless]'+#09+#09+#09+'Set window borderless.');
  writeln('-f [--fullscreen]'+#09+#09+#09+'Set window fullscreen.');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Title:=APP_NAME+' '+APP_VERSION+' '+APP_COPYRIGHT;
  Application.Run;
  Application.Free;
end.

