unit Routes.Status;

interface

uses
  System.SysUtils, System.Classes, IdHTTPServer, IdCustomHTTPServer,
  IdContext, System.JSON, IdGlobal, Routes.Interfaces, ModelDB;

type
  TStatusRoute = class(TRouteBase)
  private
    procedure RotaStatus(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  public
    procedure RegistrarRotas; override;
    function ProcessarRota(const APath: string; const AVerb: THTTPVerb;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean; override;
  end;

implementation

{ TStatusRoute }

procedure TStatusRoute.RegistrarRotas;
begin
  WriteLn('GET    /api/status');
end;

function TStatusRoute.ProcessarRota(const APath: string; const AVerb: THTTPVerb;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
begin
  Result := False;

  if APath = '/api/status' then
  begin
    if AVerb = hvGET then
    begin
      RotaStatus(ARequestInfo, AResponseInfo);
      Result := True;
    end
    else
    begin
      AResponseInfo.ResponseNo := 405;
      Result := True;
    end;
  end;
end;

procedure TStatusRoute.RotaStatus(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  lObjJSON: TJSONObject;
begin
  lObjJSON := TJSONObject.Create;
  try
    lObjJSON.AddPair('status', 'online');
    lObjJSON.AddPair('version', '1.0.0');
    lObjJSON.AddPair('database', BoolToStr(DBModel.FDConnection.Connected, True));
    lObjJSON.AddPair('timestamp', FormatDateTime('yyyy-mm-dd hh:nn:ss', Now));
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentText := lObjJSON.ToJSON;
  finally
    lObjJSON.Free;
  end;
end;

end.
