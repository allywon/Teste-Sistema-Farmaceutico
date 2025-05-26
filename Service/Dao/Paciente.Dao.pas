unit Paciente.Dao;

interface

uses
  FireDAC.Comp.Client, ModelDB, Model.Pessoa,
  System.Generics.Collections, System.SysUtils;

type
  TPacienteDAO = class
  private
    FDB: TModelDB;
  public
    constructor Create(ADB: TModelDB);

    function ListarTodos: TArray<TPaciente>;
    function BuscarPorId(const AId: Int64): TPaciente;
    function BuscarPorCPF(const ACPF: string): TPaciente;

    function Inserir(APaciente: TPaciente): Boolean;
    function Atualizar(const AId: Int64; APaciente: TPaciente): Boolean;
    function Excluir(const AId: Int64): Boolean;

    function Carregar(const AId: Int64; APaciente: TPaciente): Boolean;
  end;

implementation

{ TPacienteDAO }

constructor TPacienteDAO.Create(ADB: TModelDB);
begin
  FDB := ADB;
end;

function TPacienteDAO.ListarTodos: TArray<TPaciente>;
var
  lQuery: TFDQuery;
  Lista: TList<TPaciente>;
  lPaciente: TPaciente;
begin
  Lista := TList<TPaciente>.Create;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM pacientes ORDER BY nome';
    lQuery.Open;
    while not lQuery.Eof do
    begin
      lPaciente := TPaciente.Create;
      lPaciente.Id := lQuery.FieldByName('id').AsLargeInt;
      lPaciente.Nome := lQuery.FieldByName('nome').AsString;
      lPaciente.CPF := lQuery.FieldByName('cpf').AsString;
      lPaciente.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      Lista.Add(lPaciente);
      lQuery.Next;
    end;
    Result := Lista.ToArray;
  finally
    lQuery.Free;
    Lista.Free;
  end;
end;

function TPacienteDAO.BuscarPorId(const AId: Int64): TPaciente;
var
  lQuery: TFDQuery;
begin
  Result := nil;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM pacientes WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      Result := TPaciente.Create;
      Result.Id := lQuery.FieldByName('id').AsLargeInt;
      Result.Nome := lQuery.FieldByName('nome').AsString;
      Result.CPF := lQuery.FieldByName('cpf').AsString;
      Result.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
    end;
  finally
    lQuery.Free;
  end;
end;

function TPacienteDAO.BuscarPorCPF(const ACPF: string): TPaciente;
var
  lQuery: TFDQuery;
begin
  Result := nil;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM pacientes WHERE cpf = :cpf';
    lQuery.ParamByName('cpf').AsString := ACPF;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      Result := TPaciente.Create;
      Result.Id := lQuery.FieldByName('id').AsLargeInt;
      Result.Nome := lQuery.FieldByName('nome').AsString;
      Result.CPF := lQuery.FieldByName('cpf').AsString;
      Result.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
    end;
  finally
    lQuery.Free;
  end;
end;

function TPacienteDAO.Inserir(APaciente: TPaciente): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'INSERT INTO pacientes (nome, cpf, data_nascimento) VALUES (:nome, :cpf, :data_nascimento)';
    lQuery.ParamByName('nome').AsString := APaciente.Nome;
    lQuery.ParamByName('cpf').AsString := APaciente.CPF;
    lQuery.ParamByName('data_nascimento').AsDate := APaciente.DataNascimento;
    lQuery.ExecSQL;
    Result := True;
  finally
    lQuery.Free;
  end;
end;

function TPacienteDAO.Atualizar(const AId: Int64; APaciente: TPaciente): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'UPDATE pacientes SET nome = :nome, cpf = :cpf, data_nascimento = :data_nascimento WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.ParamByName('nome').AsString := APaciente.Nome;
    lQuery.ParamByName('cpf').AsString := APaciente.CPF;
    lQuery.ParamByName('data_nascimento').AsDate := APaciente.DataNascimento;
    lQuery.ExecSQL;
    Result := True;
  finally
    lQuery.Free;
  end;
end;

function TPacienteDAO.Excluir(const AId: Int64): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT COUNT(*) FROM servicos_farmaceuticos WHERE paciente_id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.Open;
    if lQuery.Fields[0].AsInteger > 0 then
      Exit(False); // Está em uso
    lQuery.Close;
    lQuery.SQL.Text := 'DELETE FROM pacientes WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.ExecSQL;
    Result := True;
  finally
    lQuery.Free;
  end;
end;

function TPacienteDAO.Carregar(const AId: Int64; APaciente: TPaciente): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  if not Assigned(APaciente) then
    Exit;

  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM pacientes WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      APaciente.Id := lQuery.FieldByName('id').AsLargeInt;
      APaciente.Nome := lQuery.FieldByName('nome').AsString;
      APaciente.CPF := lQuery.FieldByName('cpf').AsString;
      APaciente.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      Result := True;
    end
    else
      APaciente.Limpar;
  finally
    lQuery.Free;
  end;
end;

end.
