unit UBookStatus;

// unused
interface

type
  TBookingStatus = (Wareneingang, Warenausgang);

type
  TBookStatus = class(TObject)
    function GetStatus: TBookingStatus;
    procedure SetStatus(const Value: TBookingStatus);

  private
    property Status: TBookingStatus read GetStatus write SetStatus;
  end;

implementation

function TBookStatus.GetStatus: TBookingStatus;
begin
  Result := Status
end;

procedure TBookStatus.SetStatus(const Value: TBookingStatus);
begin
  Status := Value;
end;

end.
