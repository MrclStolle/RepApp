unit UUser;

interface

type
  TUser = class(TObject)

  private

  public
    MAID, MAName, MANameShort, MAPW: String;
    rememberMe: Boolean;
    rememberPW: Boolean;
    constructor Create(const ID, name, nameShort, password: string; const remMe, RemPW: Boolean); overload;
    constructor Create(); overload;
    procedure SetUser(const ID, name, nameShort, password: string; const remMe, RemPW: Boolean);
  end;

implementation

constructor TUser.Create(const ID, name, nameShort, password: string; const remMe, RemPW: Boolean);
begin
  inherited Create;
  MAID := ID;
  MAName := name;
  MANameShort := nameShort;
  MAPW := password;
  rememberMe := remMe;
  rememberPW := RemPW;
end;

constructor TUser.Create;
begin

end;

procedure TUser.SetUser(const ID, name, nameShort, password: string; const remMe, RemPW: Boolean);
begin
  MAID := ID;
  MAName := name;
  MAPW := password;
  MANameShort := nameShort;
  rememberMe := remMe;
  rememberPW := RemPW;
end;

end.
