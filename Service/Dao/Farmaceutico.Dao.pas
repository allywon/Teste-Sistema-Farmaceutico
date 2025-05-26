unit Farmaceutico.Dao;

interface

uses
  FireDAC.Comp.Client, ModelDB, Model.Pessoa,
  System.Generics.Collections, System.SysUtils;

type
  TFarmaceuticoDAO = class
  private
    FDB: TModelDB;
  public
    constructor Create(ADB: TModelDB);

    function ListarTodos: TArray<TFarmaceutico>;
    function BuscarPorId(const AId: Int64): TFarmaceutico;
    function BuscarPorCPF(const ACPF: string): TFarmaceutico;
    function BuscarPorCRF(const ACRF: string): TFarmaceutico;

    function Inserir(AFarmaceutico: TFarmaceutico): Boolean;
    function Atualizar(const AId: Int64; AFarmaceutico: TFarmaceutico): Boolean;
    function Excluir(const AId: Int64): Boolean;

    function Carregar(const AId: Int64; AFarmaceutico: TFarmaceutico): Boolean;
  end;

implementation

{ TFarmaceuticoDAO }

constructor TFarmaceuticoDAO.Create(ADB: TModelDB);
begin
  FDB := ADB;
end;

function TFarmaceuticoDAO.ListarTodos: TArray<TFarmaceutico>;
var
  lQuery: TFDQuery;
  Lista: TList<TFarmaceutico>;
  lFarmaceutico: TFarmaceutico;
begin
  Lista := TList<TFarmaceutico>.Create;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM farmaceuticos ORDER BY nome';
    lQuery.Open;
    while not lQuery.Eof do
    begin
      lFarmaceutico := TFarmaceutico.Create;
      lFarmaceutico.Id := lQuery.FieldByName('id').AsLargeInt;
      lFarmaceutico.Nome := lQuery.FieldByName('nome').AsString;
      lFarmaceutico.CPF := lQuery.FieldByName('cpf').AsString;
      lFarmaceutico.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      lFarmaceutico.CRF := lQuery.FieldByName('crf').AsString;
      lFarmaceutico.Especializacao := lQuery.FieldByName('especializacao').AsString;
      Lista.Add(lFarmaceutico);
      lQuery.Next;
    end;
    Result := Lista.ToArray;
  finally
    lQuery.Free;
    Lista.Free;
  end;
end;

function TFarmaceuticoDAO.BuscarPorId(const AId: Int64): TFarmaceutico;
var
  lQuery: TFDQuery;
begin
  Result := nil;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM farmaceuticos WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      Result := TFarmaceutico.Create;
      Result.Id := lQuery.FieldByName('id').AsLargeInt;
      Result.Nome := lQuery.FieldByName('nome').AsString;
      Result.CPF := lQuery.FieldByName('cpf').AsString;
      Result.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      Result.CRF := lQuery.FieldByName('crf').AsString;
      Result.Especializacao := lQuery.FieldByName('especializacao').AsString;
    end;
  finally
    lQuery.Free;
  end;
end;

function TFarmaceuticoDAO.BuscarPorCPF(const ACPF: string): TFarmaceutico;
var
  lQuery: TFDQuery;
begin
  Result := nil;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM farmaceuticos WHERE cpf = :cpf';
    lQuery.ParamByName('cpf').AsString := ACPF;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      Result := TFarmaceutico.Create;
      Result.Id := lQuery.FieldByName('id').AsLargeInt;
      Result.Nome := lQuery.FieldByName('nome').AsString;
      Result.CPF := lQuery.FieldByName('cpf').AsString;
      Result.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      Result.CRF := lQuery.FieldByName('crf').AsString;
      Result.Especializacao := lQuery.FieldByName('especializacao').AsString;
    end;
  finally
    lQuery.Free;
  end;
end;

function TFarmaceuticoDAO.BuscarPorCRF(const ACRF: string): TFarmaceutico;
var
  lQuery: TFDQuery;
begin
  Result := nil;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM farmaceuticos WHERE crf = :crf';
    lQuery.ParamByName('crf').AsString := ACRF;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      Result := TFarmaceutico.Create;
      Result.Id := lQuery.FieldByName('id').AsLargeInt;
      Result.Nome := lQuery.FieldByName('nome').AsString;
      Result.CPF := lQuery.FieldByName('cpf').AsString;
      Result.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      Result.CRF := lQuery.FieldByName('crf').AsString;
      Result.Especializacao := lQuery.FieldByName('especializacao').AsString;
    end;
  finally
    lQuery.Free;
  end;
end;

function TFarmaceuticoDAO.Inserir(AFarmaceutico: TFarmaceutico): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'INSERT INTO farmaceuticos (nome, cpf, data_nascimento, crf, especializacao) ' +
                       'VALUES (:nome, :cpf, :data_nascimento, :crf, :especializacao)';
    lQuery.ParamByName('nome').AsString := AFarmaceutico.Nome;
    lQuery.ParamByName('cpf').AsString := AFarmaceutico.CPF;
    lQuery.ParamByName('data_nascimento').AsDate := AFarmaceutico.DataNascimento;
    lQuery.ParamByName('crf').AsString := AFarmaceutico.CRF;
    lQuery.ParamByName('especializacao').AsString := AFarmaceutico.Especializacao;
    lQuery.ExecSQL;
    Result := True;
  finally
    lQuery.Free;
  end;
end;

function TFarmaceuticoDAO.Atualizar(const AId: Int64; AFarmaceutico: TFarmaceutico): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'UPDATE farmaceuticos SET nome = :nome, cpf = :cpf, ' +
                       'data_nascimento = :data_nascimento, crf = :crf, ' +
                       'especializacao = :especializacao WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.ParamByName('nome').AsString := AFarmaceutico.Nome;
    lQuery.ParamByName('cpf').AsString := AFarmaceutico.CPF;
    lQuery.ParamByName('data_nascimento').AsDate := AFarmaceutico.DataNascimento;
    lQuery.ParamByName('crf').AsString := AFarmaceutico.CRF;
    lQuery.ParamByName('especializacao').AsString := AFarmaceutico.Especializacao;
    lQuery.ExecSQL;
    Result := True;
  finally
    lQuery.Free;
  end;
end;

function TFarmaceuticoDAO.Excluir(const AId: Int64): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT COUNT(*) FROM servicos_farmaceuticos WHERE farmaceutico_id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.Open;
    if lQuery.Fields[0].AsInteger > 0 then
      Exit(False); // Está em uso
    lQuery.Close;
    lQuery.SQL.Text := 'DELETE FROM farmaceuticos WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.ExecSQL;
    Result := True;
  finally
    lQuery.Free;
  end;
end;

function TFarmaceuticoDAO.Carregar(const AId: Int64; AFarmaceutico: TFarmaceutico): Boolean;
var
  lQuery: TFDQuery;
begin
  Result := False;
  if not Assigned(AFarmaceutico) then
    Exit;

  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := FDB.FDConnection;
    lQuery.SQL.Text := 'SELECT * FROM farmaceuticos WHERE id = :id';
    lQuery.ParamByName('id').AsLargeInt := AId;
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      AFarmaceutico.Id := lQuery.FieldByName('id').AsLargeInt;
      AFarmaceutico.Nome := lQuery.FieldByName('nome').AsString;
      AFarmaceutico.CPF := lQuery.FieldByName('cpf').AsString;
      AFarmaceutico.DataNascimento := lQuery.FieldByName('data_nascimento').AsDateTime;
      AFarmaceutico.CRF := lQuery.FieldByName('crf').AsString;
      AFarmaceutico.Especializacao := lQuery.FieldByName('especializacao').AsString;
      Result := True;
    end
    else
      AFarmaceutico.Limpar;
  finally
    lQuery.Free;
  end;
end;

end.
