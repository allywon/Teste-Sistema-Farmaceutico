unit Procedimento.Controller;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client,
  Data.DB, ModelDB, Model.Procedimento, Model.Procedimento.Tipo,
  Procedimento.Mapper, Procedimento.Dao;

type
  TProcedimentoController = class
  private
    FModelDB: TModelDB;
    FMapper: TProcedimentoMapper;
    FProcedimentoDAO: TProcedimentoDAO;
  public
    constructor Create(AModelDB: TModelDB);
    destructor Destroy; override;

    function ObterProcedimentos: TJSONArray;
    function ObterProcedimentoPorId(const AId: Int64): TJSONObject;
    function InserirProcedimento(AProcedimento: TProcedimento): Boolean;
    function AtualizarProcedimento(const AId: Int64; AProcedimento: TProcedimento): Boolean;
    function ExcluirProcedimento(const AId: Int64): Boolean;
    function CarregarProcedimento(const AId: Int64; AProcedimento: TProcedimento): Boolean;
  end;

implementation

{ TProcedimentoController }

constructor TProcedimentoController.Create(AModelDB: TModelDB);
begin
  inherited Create;
  FModelDB := AModelDB;
  FMapper := TProcedimentoMapper.Create;
  FProcedimentoDAO := TProcedimentoDAO.Create(AModelDB);
end;

destructor TProcedimentoController.Destroy;
begin
  FreeAndNil(FMapper);
  FreeAndNil(FProcedimentoDAO);
  inherited;
end;

function TProcedimentoController.ObterProcedimentos: TJSONArray;
var
  lLista: TArray<TProcedimento>;
  lProcedimento: TProcedimento;
begin
  Result := TJSONArray.Create;
  try
    lLista := FProcedimentoDAO.ListarTodos;
    for lProcedimento in lLista do
      Result.AddElement(FMapper.ParaJSON(lProcedimento));
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao obter procedimentos: ' + E.Message);
    end;
  end;
end;

function TProcedimentoController.ObterProcedimentoPorId(const AId: Int64): TJSONObject;
var
  lProcedimento: TProcedimento;
begin
  lProcedimento := FProcedimentoDAO.BuscarPorId(AId);
  if Assigned(lProcedimento) then
    Result := FMapper.ParaJSON(lProcedimento)
  else
    Result := TJSONObject.Create;

  FreeAndNil(lProcedimento);
end;

function TProcedimentoController.InserirProcedimento(AProcedimento: TProcedimento): Boolean;
begin
  Result := FProcedimentoDAO.Inserir(AProcedimento);
end;

function TProcedimentoController.AtualizarProcedimento(const AId: Int64; AProcedimento: TProcedimento): Boolean;
begin
  Result := FProcedimentoDAO.Atualizar(AId, AProcedimento);
end;

function TProcedimentoController.ExcluirProcedimento(const AId: Int64): Boolean;
begin
  Result := FProcedimentoDAO.Excluir(AId);
end;

function TProcedimentoController.CarregarProcedimento(const AId: Int64; AProcedimento: TProcedimento): Boolean;
begin
  Result := FProcedimentoDAO.Carregar(AId, AProcedimento);
end;

end.

