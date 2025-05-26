unit Paciente.Mapper;

interface

uses
  System.JSON, Model.Pessoa;

type
  TPacienteMapper = class
  public
    function ParaJSON(const APaciente: TPaciente): TJSONObject;
    function DeJSON(const AJSON: TJSONObject): TPaciente;
  end;

implementation

uses System.DateUtils, System.SysUtils;

{ TProcedimentoMapper }

function TPacienteMapper.DeJSON(const AJSON: TJSONObject): TPaciente;
var lDataStr:String;
begin
  Result := TPaciente.Create;
  try
    Result.Limpar;

    Result.Id := AJSON.GetValue<Int64>('id', 0);
    Result.Nome := AJSON.GetValue<string>('nome', '');
    Result.CPF := AJSON.GetValue<string>('cpf', '');
    lDataStr := AJSON.GetValue<string>('dataNascimento', '');
    if lDataStr <> '' then
      Result.DataNascimento := ISO8601ToDate(lDataStr, False);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TPacienteMapper.ParaJSON(const APaciente: TPaciente): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('id', TJSONNumber.Create(APaciente.Id));
    Result.AddPair('nome', APaciente.Nome);
    Result.AddPair('cpf', APaciente.CPF);
    Result.AddPair('dataNascimento', TJSONString.Create(FormatDateTime('yyyy-mm-dd', APaciente.DataNascimento)));
  except
    Result.Free;
    raise;
  end;
end;

end.
