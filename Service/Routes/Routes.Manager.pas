unit Routes.Manager;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  IdHTTPServer, IdCustomHTTPServer, IdContext, Routes.Interfaces, ModelDB;

type
  TRouteManager = class
  private
    FServer: TIdHTTPServer;
    FRoutes: TList<IRoute>;
    FModelDB: TModelDB;
  public
    constructor Create(AServer: TIdHTTPServer; AModelDB: TModelDB);
    destructor Destroy; override;

    procedure RegistrarRotas;
    function ProcessarRequisicao(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;

    property Routes: TList<IRoute> read FRoutes;
  end;

implementation

uses
  Routes.Status, Routes.Procedimento, Routes.Paciente, Routes.Farmaceutico,
  Routes.ServicoFarmaceutico;

{ TRouteManager }

constructor TRouteManager.Create(AServer: TIdHTTPServer; AModelDB: TModelDB);
begin
  inherited Create;
  FServer := AServer;
  FModelDB := AModelDB;
  FRoutes := TList<IRoute>.Create;

  // Registra as rotas
  FRoutes.Add(TStatusRoute.Create(FServer));
  FRoutes.Add(TProcedimentoRoute.Create(FServer, FModelDB));
  FRoutes.Add(TPacienteRoute.Create(FServer, FModelDB));
  FRoutes.Add(TFarmaceuticoRoute.Create(FServer, FModelDB));
  FRoutes.Add(TServicoFarmaceuticoRoute.Create(FServer, FModelDB));
end;

destructor TRouteManager.Destroy;
begin
  FRoutes.Clear;
  FRoutes.Free;
  inherited;
end;

procedure TRouteManager.RegistrarRotas;
var
  lRoute: IRoute;
begin
  WriteLn('Endpoints disponíveis:');
  for lRoute in FRoutes do
    lRoute.RegistrarRotas;
end;

function TRouteManager.ProcessarRequisicao(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
var
  lRoute: IRoute;
  lPath: string;
  lVerb: THTTPVerb;
  lRouteBase: TRouteBase;
begin
  Result := False;
  lPath := ARequestInfo.URI;

  // Converte RouteBase para obter o método utilitário
  lRouteBase := TRouteBase.Create(FServer);
  try
    lVerb := lRouteBase.ObterVerboHTTP(ARequestInfo.Command);
  finally
    lRouteBase.Free;
  end;

  // Processa cada rota registrada
  for lRoute in FRoutes do
  begin
    Result := lRoute.ProcessarRota(lPath, lVerb, ARequestInfo, AResponseInfo);
    if Result then
      Break;
  end;

  // Se nenhuma rota processou, retorna 404
  if not Result then
  begin
    AResponseInfo.ResponseNo := 404;
    AResponseInfo.ContentText := '{"error":"Endpoint não encontrado"}';
    Result := True;
  end;
end;

end.
