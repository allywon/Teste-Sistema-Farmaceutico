unit Controller.Procedimento;

interface

uses
  System.JSON, System.SysUtils, System.Classes, System.Generics.Collections,
  REST.Types,
  Model.Procedimento, Model.Procedimento.Tipo,
  Service.RESTBase;

type
  TProcedimentoController = class(TRESTServiceBase)
  public
    function BuscarTodos: TObjectList<TProcedimento>;
    function BuscarPorId(AId: Int64): TProcedimento;
    function Salvar(AProcedimento: TProcedimento): Boolean;
    function Excluir(AId: Int64): Boolean;
  end;

implementation

uses
  Procedimento.Mapper;

function TProcedimentoController.BuscarTodos: TObjectList<TProcedimento>;
var
  lJSONArray: TJSONArray;
  lJSONItem: TJSONValue;
  lResponseContent: string;
begin
  Result := TObjectList<TProcedimento>.Create(True);

  lResponseContent := ExecutarRequisicao(rmGET, 'procedimentos', EmptyStr);

  if FRESTResponse.StatusCode = 200 then
  begin
    lJSONArray := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONArray;
    for lJSONItem in lJSONArray do
      Result.Add(TProcedimentoMapper.Create.DeJSON(lJSONItem as TJSONObject));
  end;
end;

function TProcedimentoController.BuscarPorId(AId: Int64): TProcedimento;
var
  lJSONObject: TJSONObject;
  lResponseContent, lResource: string;
begin
  Result := nil;

  lResource := Format('procedimentos/%d', [AId]);

  lResponseContent := ExecutarRequisicao(rmGET, lResource, EmptyStr);

  if FRESTResponse.StatusCode = 200 then
  begin
    lJSONObject := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
    Result := TProcedimentoMapper.Create.DeJSON(lJSONObject);
  end;
end;

function TProcedimentoController.Excluir(AId: Int64): Boolean;
var
  lResponseContent, lResource: string;
begin
  lResource := Format('procedimentos/%d', [AId]);

  lResponseContent := ExecutarRequisicao(rmDELETE, lResource, EmptyStr);

  Result := FRESTResponse.StatusCode = 200;
end;

function TProcedimentoController.Salvar(AProcedimento: TProcedimento): Boolean;
var
  lJSON: TJSONObject;
  lResource: string;
  lMetodo: TRESTRequestMethod;
  lResponseContent: string;
begin
  Result := False;
  lJSON := TProcedimentoMapper.Create.ParaJSON(AProcedimento);
  try
    if AProcedimento.Id = 0 then
    begin
      lMetodo := rmPOST;
      lResource := 'procedimentos';
    end
    else
    begin
      lMetodo := rmPUT;
      lResource := Format('procedimentos/%d', [AProcedimento.Id]);
    end;

    try
      lResponseContent := ExecutarRequisicao(lMetodo, lResource, lJSON.ToJSON);
      Result := FRESTResponse.StatusCode in [200, 201];
    except
      on E: Exception do
      begin
        AProcedimento.Aviso := FRESTResponse.Content;
        Result := False;
      end;
    end;
  finally
    lJSON.Free;
  end;
end;

end.

