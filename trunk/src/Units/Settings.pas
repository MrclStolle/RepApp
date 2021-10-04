unit Settings;

interface

uses SysUtils, Vcl.Forms, inifiles, user;

implementation

uses inifiles;

var
  appIni: TIniFile;
  appIniPath: String;
  rememberMe: boolean;
  rememberPW: boolean;

initialization

appIniPath := ChangeFileExt(Application.ExeName, '.ini');
appIni := TIniFile.Create(appIniPath);

// if FileExists(appIniPath) then
// begin
rememberMe := StrToBool(appIni.ReadString('User', 'RemMe', 'true'));
rememberPW := StrToBool(appIni.ReadString('User', 'RemPW', 'false'));
User.MAID := appIni.ReadString('User', 'LastID', '');
User.MAName := appIni.ReadString('User', 'LastName', '');
User.MAPW := appIni.ReadString('User', 'LastPW', '');
// end;

finalization

appIni.Free;

end.
