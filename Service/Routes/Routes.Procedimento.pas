unit Routes.Procedimento;

interface

uses
  System.SysUtils, System.Classes, IdHTTPServer, IdCustomHTTPServer,
  IdContext, System.JSON, IdGlobal, Routes.Interfaces,
  Procedimento.Controller, ModelDB, Model.Procedimento.Tipo, Model.Procedimento;

type
  TProcedimentoRoute = class(TRouteBase)
  private
    FProcedimentoController: TProcedimentoController;

    procedure RotaProcedimentos(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure RotaProcedimentoById(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; const AId: string);
  public
    constructor Create(AServer: TIdHTTPServer; AModelDB: TModelDB);
    destructor Destroy; override;

    procedure RegistrarRotas; override;
    function ProcessarRota(const APath: string; const AVerb: THTTPVerb;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean; override;
  end;

implementation

{ TProcedimentoRoute }

constructor TProcedimentoRoute.Create(AServer: TIdHTTPServer; AModelDB: TModelDB);
begin
  inherited Create(AServer);
  FProcedimentoController := TProcedimentoController.Create(AModelDB);
end;

destructor TProcedimentoRoute.Destroy;
begin
  FreeAndNil(FProcedimentoController);
  inherited;
end;

procedure TProcedimentoRoute.RegistrarRotas;
begin
  WriteLn('GET    /api/procedimentos');
  WriteLn('GET    /api/procedimentos/:id');
  WriteLn('POST   /api/procedimentos');
  WriteLn('PUT    /api/procedimentos/:id');
  WriteLn('DELETE /api/procedimentos/:id');
end;

function TProcedimentoRoute.ProcessarRota(const APath: string; const AVerb: THTTPVerb;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo): Boolean;
var
  lIdParam: string;
begin
  Result := False;

  if APath = '/api/procedimentos' then
  begin
    if AVerb in [hvGET, hvPOST] then
    begin
      RotaProcedimentos(ARequestInfo, AResponseInfo);
      Result := True;
    end
    else
    begin
      AResponseInfo.ResponseNo := 405;
      Result := True;
    end;
  end
  else if APath.StartsWith('/api/procedimentos/') then
  begin
    lIdParam := ExtrairParamPath(APath, 3);
    if lIdParam <> '' then
    begin
      RotaProcedimentoById(ARequestInfo, AResponseInfo, lIdParam);
      Result := True;
    end
    else
    begin
      AResponseInfo.ResponseNo := 400;
      AResponseInfo.ContentText := '{"error": "ID n�o fornecido"}';
      Result := True;
    end;
  end;
end;

procedure TProcedimentoRoute.RotaProcedimentos(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  lBodyJSON: TJSONObject;
  lResult: Boolean;
  lVerbo: THTTPVerb;
  lProcedimento: TProcedimento;
begin
  lVerbo := ObterVerboHTTP(ARequestInfo.Command);

  case lVerbo of
    hvGET:
      begin
        AResponseInfo.ResponseNo := 200;
        AResponseInfo.ContentText := FProcedimentoController.ObterProcedimentos.ToJSON;
      end;

    hvPOST:
      begin
        lBodyJSON := LerBodyComoJSON(ARequestInfo);
        if not Assigned(lBodyJSON) then
        begin
          AResponseInfo.ResponseNo := 400;
          AResponseInfo.ContentText := '{"error": "JSON inv�lido ou ausente"}';
          Exit;
        end;

        lProcedimento := TProcedimento.Create;
        try
          lProcedimento.Tipo := TTipoProcedimento(lBodyJSON.GetValue<Integer>('tipo'));
          lProcedimento.Descricao := lBodyJSON.GetValue<string>('descricao');
          lProcedimento.Valor := lBodyJSON.GetValue<Double>('valor');

          lResult := FProcedimentoController.InserirProcedimento(lProcedimento);
          if lResult then
          begin
            AResponseInfo.ResponseNo := 201;
            AResponseInfo.ContentText := '{"mensagem": "Procedimento criado com sucesso"}';
          end
          else
          begin
            AResponseInfo.ResponseNo := 500;
            AResponseInfo.ContentText := '{"erro": "Falha ao inserir procedimento"}';
          end;
        finally
          lBodyJSON.Free;
          lProcedimento.Free;
        end;
      end;
  end;
end;

procedure TProcedimentoRoute.RotaProcedimentoById(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo; const AId: string);
var
  lId: Int64;
  lBodyJSON: TJSONObject;
  lResult: Boolean;
  lVerbo: THTTPVerb;
  lProcedimento: TProcedimento;
begin
  lVerbo := ObterVerboHTTP(ARequestInfo.Command);
  lId := StrToInt64Def(AId, 0);

  case lVerbo of
    hvGET:
      begin
        AResponseInfo.ResponseNo := 200;
        AResponseInfo.ContentText := FProcedimentoController.ObterProcedimentoPorId(lId).ToJSON;
      end;

    hvPUT:
      begin
        lBodyJSON := LerBodyComoJSON(ARequestInfo);
        if not Assigned(lBodyJSON) then
        begin
          AResponseInfo.ResponseNo := 400;
          AResponseInfo.ContentText := '{"error": "JSON inv�lido ou ausente"}';
          Exit;
        end;

        lProcedimento := TProcedimento.Create;
        try
          lProcedimento.Tipo := TTipoProcedimento(lBodyJSON.GetValue<Integer>('tipo'));
          lProcedimento.Descricao := lBodyJSON.GetValue<string>('descricao');
          lProcedimento.Valor := lBodyJSON.GetValue<Double>('valor');

          lResult := FProcedimentoController.AtualizarProcedimento(lId, lProcedimento);
          if lResult then
          begin
            AResponseInfo.ResponseNo := 200;
            AResponseInfo.ContentText := '{"mensagem": "Procedimento atualizado com sucesso"}';
          end
          else
          begin
            AResponseInfo.ResponseNo := 500;
            AResponseInfo.ContentText := '{"erro": "Falha ao atualizar procedimento"}';
          end;
        finally
          lBodyJSON.Free;
          lProcedimento.Free;
        end;
      end;

    hvDELETE:
      begin
        lResult := FProcedimentoController.ExcluirProcedimento(lId);
        if lResult then
        begin
          AResponseInfo.ResponseNo := 200;
          AResponseInfo.ContentText := '{"mensagem": "Procedimento exclu�do com sucesso"}';
        end
        else
        begin
          AResponseInfo.ResponseNo := 404;
          AResponseInfo.ContentText := '{"erro": "Procedimento n�o encontrado ou falha ao excluir"}';
        end;
      end;
  end;
end;

end.
