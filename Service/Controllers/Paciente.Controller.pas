unit Paciente.Controller;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client,
  Data.DB, ModelDB, Model.Pessoa, Paciente.Mapper, Paciente.Dao;

type
  TPacienteController = class
  private
    FModelDB: TModelDB;
    FMapper: TPacienteMapper;
    FPacienteDAO: TPacienteDAO;
  public
    constructor Create(AModelDB: TModelDB);
    destructor Destroy; override;
    function ObterPacientes: TJSONArray;
    function ObterPacientePorId(const AId: Int64): TJSONObject;
    function ObterPacientePorCPF(const ACPF: string): TJSONObject;
    function InserirPaciente(APaciente: TPaciente): Boolean;
    function AtualizarPaciente(const AId: Int64; APaciente: TPaciente): Boolean;
    function ExcluirPaciente(const AId: Int64): Boolean;
    function CarregarPaciente(const AId: Int64; Paciente: TPaciente): Boolean;
  end;

implementation

{ TPacienteController }

constructor TPacienteController.Create(AModelDB: TModelDB);
begin
  inherited Create;
  FModelDB := AModelDB;
  FMapper := TPacienteMapper.Create;
  FPacienteDAO := TPacienteDAO.Create(AModelDB);
end;

destructor TPacienteController.Destroy;
begin
  FreeAndNil(FMapper);
  FreeAndNil(FPacienteDAO);
  inherited;
end;

function TPacienteController.ObterPacientes: TJSONArray;
var
  lLista: TArray<TPaciente>;
  lPaciente: TPaciente;
begin
  Result := TJSONArray.Create;
  try
    lLista := FPacienteDAO.ListarTodos;
    for lPaciente in lLista do
      Result.AddElement(FMapper.ParaJSON(lPaciente));
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao obter pacientes: ' + E.Message);
    end;
  end;
end;

function TPacienteController.ObterPacientePorId(const AId: Int64): TJSONObject;
var
  lPaciente: TPaciente;
begin
  lPaciente := FPacienteDAO.BuscarPorId(AId);
  if Assigned(lPaciente) then
    Result := FMapper.ParaJSON(lPaciente)
  else
    Result := TJSONObject.Create;

  FreeAndNil(lPaciente);
end;

function TPacienteController.ObterPacientePorCPF(const ACPF: string): TJSONObject;
var
  lPaciente: TPaciente;
begin
  lPaciente := FPacienteDAO.BuscarPorCPF(ACPF);
  if Assigned(lPaciente) then
    Result := FMapper.ParaJSON(lPaciente)
  else
    Result := TJSONObject.Create;

  FreeAndNil(lPaciente);
end;

function TPacienteController.InserirPaciente(APaciente: TPaciente): Boolean;
begin
  Result := FPacienteDAO.Inserir(APaciente);
end;

function TPacienteController.AtualizarPaciente(const AId: Int64; APaciente: TPaciente): Boolean;
begin
  Result := FPacienteDAO.Atualizar(AId, APaciente);
end;

function TPacienteController.ExcluirPaciente(const AId: Int64): Boolean;
begin
  Result := FPacienteDAO.Excluir(AId);
end;

function TPacienteController.CarregarPaciente(const AId: Int64; Paciente: TPaciente): Boolean;
begin
  Result := FPacienteDAO.Carregar(AId, Paciente);
end;

end.
