unit UUser;

interface

uses UEmployee;

type
  TUser = class(TEmployee)

  private

  public
    PW: String;
    rememberMe: Boolean;
    rememberPW: Boolean;
    admin: Boolean;
    constructor Create(ID, name, nameShort, password: string; remMe, RemPW, padmin: Boolean); overload;
    constructor Create(); overload;
    procedure SetUser(ID, name, nameShort, password: string; remMe, RemPW, padmin: Boolean);
  end;

var
  User: TUser;

implementation

constructor TUser.Create(ID, name, nameShort, password: string; remMe, RemPW, padmin: Boolean);
begin
  inherited Create(ID, name, nameShort);
  PW := password;
  rememberMe := remMe;
  rememberPW := RemPW;
  admin := padmin;
end;

constructor TUser.Create;
begin

end;

procedure TUser.SetUser(ID, name, nameShort, password: string; remMe, RemPW, padmin: Boolean);
begin
  ID := ID;
  Name := name;
  nameShort := nameShort;
  PW := password;
  rememberMe := remMe;
  rememberPW := RemPW;
  admin := padmin;
end;

end.
