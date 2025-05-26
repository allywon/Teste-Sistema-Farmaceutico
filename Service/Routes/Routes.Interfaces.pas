unit Routes.Interfaces;

interface

uses
  System.SysUtils, System.Classes, IdHTTPServer, IdCustomHTTPServer,
  IdContext, System.JSON, IdGlobal;

type
  THTTPVerb = (hvGET, hvPOST, hvPUT, hvDELETE, hvOPTIONS);

  IRoute = interface
    ['{34FCE26F-4FDA-42AD-9FA3-9FD4A8E9B3A6}']
    procedure RegistrarRotas;
    function ProcessarRota(const APath: string; const AVerb: THTTPVerb;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
  end;

  TRouteBase = class(TInterfacedObject, IRoute)
  protected
    FServer: TIdHTTPServer;


    function ExtrairParamPath(const AURL: string; AIndice: Integer): string;
    function LerBodyComoJSON(ARequestInfo: TIdHTTPRequestInfo): TJSONObject;
    procedure ConfigurarCORS(AResponseInfo: TIdHTTPResponseInfo);
  public
    constructor Create(AServer: TIdHTTPServer);

    procedure RegistrarRotas; virtual; abstract;
    function ProcessarRota(const APath: string; const AVerb: THTTPVerb;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean; virtual;
    function ObterVerboHTTP(const AMethod: string): THTTPVerb;
  end;

implementation

{ TRouteBase }

constructor TRouteBase.Create(AServer: TIdHTTPServer);
begin
  inherited Create;
  FServer := AServer;
end;

function TRouteBase.ExtrairParamPath(const AURL: string; AIndice: Integer): string;
var
  lPartes: TArray<string>;
begin
  Result := '';
  lPartes := AURL.Split(['/']);
  if (AIndice >= 0) and (AIndice < Length(lPartes)) then
    Result := lPartes[AIndice];
end;

function TRouteBase.LerBodyComoJSON(ARequestInfo: TIdHTTPRequestInfo): TJSONObject;
var
  lBodyStream: TStringStream;
  lJSONString: string;
begin
  Result := nil;
  if Assigned(ARequestInfo.PostStream) and (ARequestInfo.PostStream.Size > 0) then
  begin
    lBodyStream := TStringStream.Create;
    try
      ARequestInfo.PostStream.Position := 0;

      lBodyStream.CopyFrom(ARequestInfo.PostStream, ARequestInfo.PostStream.Size);
      lJSONString := lBodyStream.DataString;

      if not lJSONString.IsEmpty then
        Result := TJSONObject.ParseJSONValue(lJSONString) as TJSONObject;
    finally
      lBodyStream.Free;
    end;
  end;
end;

function TRouteBase.ObterVerboHTTP(const AMethod: string): THTTPVerb;
begin
  if SameText(AMethod, 'GET') then Result := hvGET
  else if SameText(AMethod, 'POST') then Result := hvPOST
  else if SameText(AMethod, 'PUT') then Result := hvPUT
  else if SameText(AMethod, 'DELETE') then Result := hvDELETE
  else if SameText(AMethod, 'OPTIONS') then Result := hvOPTIONS
  else Result := hvGET;
end;

procedure TRouteBase.ConfigurarCORS(AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Origin'] := '*';
  AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Methods'] := 'GET, POST, PUT, DELETE, OPTIONS';
  AResponseInfo.CustomHeaders.Values['Access-Control-Allow-Headers'] := 'Content-Type, Authorization';
end;

function TRouteBase.ProcessarRota(const APath: string; const AVerb: THTTPVerb;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
begin
  Result := False; // Implementação padrão, classes filhas devem sobrescrever
end;

end.
