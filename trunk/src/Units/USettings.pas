unit USettings;

interface

uses SysUtils, Vcl.Forms, inifiles, UUser, IOUtils, UOracleDB, dialogs;
/// <summary>Speichert die Daten des zuletzt eingeloggten Benutzers
/// </summary>
procedure SaveUser(var User: TUser);
/// <summary>Load last User Login-vales from .ini-file
/// </summary>
procedure GetLastUser(var User: TUser);
/// <summary>De-/Encode Text with 2x XOR
/// </summary>
/// <returns>De-/Encoded Text(String)
/// </returns>
function Encode(str: string): string;

procedure SaveConnection(DBName, UserName, pw: string); overload;

/// <summary>rückstand in früherer programmierung, switch fürs anzeigen einer User Login auswahl
/// </summary>
/// <returns> boolean
/// </returns>
function GetNamesEarly: boolean;
/// <summary>Lädt die letzte Verbindungs-Einstellung (aus der .ini) die verwendet wurde
/// </summary>
/// <returns>Erfolg des Verbindungsaufbaus (boolean)
/// </returns>
function LoadLastConnection(): boolean;
procedure InitialiseSettings;
function TryConnectionToOfficialDB: boolean;
function TryConnectionToTestDB: boolean;

procedure FinalizeSettings;

var
  appIniUserLogin: TIniFile;
  appIniDBCon: TIniFile;
  appIniUserLoginPath: String;
  appIniPathDBCon: String;
  connectedTo: String;
  // Pfad für den Speicherort für den Login des Datenbankzugriffs, ..Ext erweitert den Dateinamen für einen alternativen Datenbank-Login-Speicherorts, zB 'DEBUG'

  NamesEarly: boolean = false;
  DoEncode: boolean = false;
  debugmode: boolean;

  DBName: String;
  defaultDBName: String;
  defaultUserName: String;
  defaultPW: String;

implementation

procedure InitialiseSettings;
begin
  // definiert den Pfad des gespeicherten User-Logins
  appIniUserLoginPath := GetHomePath + '\' + ChangeFileExt(extractfilename(Application.ExeName), '.ini');
  appIniUserLogin := TIniFile.Create(appIniUserLoginPath);

  // definiert den Pfad der letzten Datenbankverbindung
  // if debugmode then
  // appIniPathDBCon := ChangeFileExt(Application.ExeName, 'DEBUG.ini')
  // else
  appIniPathDBCon := ChangeFileExt(Application.ExeName, '.ini');
  appIniDBCon := TIniFile.Create(appIniPathDBCon);

//  TryConnectionToOfficialDB;

  // default connection, offizielle Datenbank
   defaultDBName := '192.168.1.113/topdb';
   defaultUserName := 'reparatur';
   defaultPW := 'twi';

   if not LoadLastConnection then
   begin
   // showmessage('Zu ' + DBName + ' konnte keine Verbindung aufgebaut werden. Versuche mit ' + defaultDBName +
   // ' zu verbinden.');
   if TestConnection(defaultDBName, defaultUserName, defaultPW) then
   begin
   CreateConnection(defaultDBName, defaultUserName, defaultPW);
   connectedTo := 'Verbunden mit ' + defaultUserName + '@' + defaultDBName;
   if debugmode then
   showmessage('Verindung zur öffentlichen Datenbank Hergestellt! Vorsicht mit den Daten!');
   end
   else
   // showmessage('Zu ' + defaultDBName + ' konnte ebenfalls keine Verbindung aufgebaut werden.');
   end;

end;

procedure SaveUser(var User: TUser);
begin
  if User.rememberMe then
  begin
    appIniUserLogin.WriteString('User', 'LastID', User.ID);
    appIniUserLogin.WriteString('User', 'LastName', User.Name);
    appIniUserLogin.WriteString('User', 'lastNameShort', User.NameShort);
    appIniUserLogin.WriteString('User', 'RemMe', 'true');
  end
  else
  begin
    appIniUserLogin.WriteString('User', 'LastID', '');
    appIniUserLogin.WriteString('User', 'LastName', '');
    appIniUserLogin.WriteString('User', 'lastNameShort', '');
    appIniUserLogin.WriteString('User', 'RemMe', 'false');
  end;

  if User.rememberPW then
  begin
    appIniUserLogin.WriteString('User', 'LastPW', User.pw);
    appIniUserLogin.WriteString('User', 'RemPW', 'true');
  end
  else
  begin
    appIniUserLogin.WriteString('User', 'LastPW', '');
    appIniUserLogin.WriteString('User', 'RemPW', 'false');
  end;
end;

procedure GetLastUser(var User: TUser);
begin
  User := TUser.Create(appIniUserLogin.ReadString('User', 'LastID', ''), appIniUserLogin.ReadString('User', 'LastName',
    ''), appIniUserLogin.ReadString('User', 'LastNameShort', ''), appIniUserLogin.ReadString('User', 'LastPW', ''),
    StrToBool(appIniUserLogin.ReadString('User', 'RemMe', 'true')),
    StrToBool(appIniUserLogin.ReadString('User', 'RemPW', 'false')), false);
end;

function Encode(str: string): string;
var
  I: Integer;
begin
  if DoEncode then
    for I := 0 to Length(str) - 1 do
    begin
      str[I] := char(byte(str[I]) xor 41);
      str[I] := char(byte(str[I]) xor 19);
    end;

  Result := str;
end;

procedure SaveConnection(DBName, UserName, pw: string);
begin
  appIniDBCon.WriteString('connectionLast', 'DBName', DBName);
  appIniDBCon.WriteString('connectionLast', 'Username', UserName);
  appIniDBCon.WriteString('connectionLast', 'pw', pw);
end;

function GetNamesEarly: boolean;
begin
  Result := NamesEarly;
end;

function LoadLastConnection(): boolean;
var
  UserName, DBPW: String;
begin
  Result := false;
  DBName := appIniDBCon.ReadString('connection', 'DBName', '');
  UserName := appIniDBCon.ReadString('connection', 'Username', '');
  DBPW := appIniDBCon.ReadString('connection', 'pw', '');
  if DBName <> '' then
    if TestConnection(DBName, UserName, DBPW) then
    begin
      CreateConnection(DBName, UserName, DBPW);
      connectedTo := 'Verbunden mit ' + UserName + '@' + DBName;
      Result := true;
    end;
end;

function TryConnectionToTestDB: boolean;
var
  DBnameTest, DBuserTest, DBpwTest: String;
begin
  DBnameTest := appIniDBCon.ReadString('connectionTestDB', 'DBName', '');
  DBuserTest := appIniDBCon.ReadString('connectionTestDB', 'Username', '');
  DBpwTest := appIniDBCon.ReadString('connectionTestDB', 'pw', '');

  Result := TestConnection(DBnameTest, DBuserTest, DBpwTest);
  if Result then
  begin
    CreateConnection(DBnameTest, DBuserTest, DBpwTest);
    connectedTo := 'Verbunden mit ' + DBuserTest + '@' + DBnameTest;
  end;
end;

function TryConnectionToOfficialDB: boolean;
var
  DBnameoff, DBuseroff, DBpwoff: String;
begin
  DBnameoff := appIniDBCon.ReadString('connectionOffDB', 'DBName', '');
  DBuseroff := appIniDBCon.ReadString('connectionOffDB', 'Username', '');
  DBpwoff := appIniDBCon.ReadString('connectionOffDB', 'pw', '');

  Result := TestConnection(DBnameoff, DBuseroff, DBpwoff);
  if Result then
  begin
    CreateConnection(DBnameoff, DBuseroff, DBpwoff);
    connectedTo := 'Verbunden mit ' + DBuseroff + '@' + DBnameoff;
  end;
end;

procedure FinalizeSettings;
begin
  CloseConnection;
  appIniUserLogin.Free;
  appIniDBCon.Free;
end;

{ DONE -ostolle -ccode : review the getting, setting, saving of server connection }

end.
