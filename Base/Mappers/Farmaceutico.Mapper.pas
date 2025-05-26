unit Farmaceutico.Mapper;

interface

uses
  System.JSON, Model.Pessoa;

type
  TFarmaceuticoMapper = class
  public
    function ParaJSON(const AFarmaceutico: TFarmaceutico): TJSONObject;
    function DeJSON(const AJSON: TJSONObject): TFarmaceutico;
  end;

implementation

uses System.DateUtils, System.SysUtils;

{ TFarmaceuticoMapper }

function TFarmaceuticoMapper.DeJSON(const AJSON: TJSONObject): TFarmaceutico;
var lDataStr:String;
begin
  Result := TFarmaceutico.Create;
  try
    Result.Limpar;

    Result.Id := AJSON.GetValue<Int64>('id', 0);
    Result.Nome := AJSON.GetValue<string>('nome', '');
    Result.CPF := AJSON.GetValue<string>('cpf', '');
    lDataStr := AJSON.GetValue<string>('dataNascimento', '');
    if lDataStr <> '' then
      Result.DataNascimento := ISO8601ToDate(lDataStr, False);

    Result.CRF := AJSON.GetValue<string>('crf', '');
    Result.Especializacao := AJSON.GetValue<string>('especializacao', '');
  except
    FreeAndNil(Result);
    raise;
  end;
end;

function TFarmaceuticoMapper.ParaJSON(const AFarmaceutico: TFarmaceutico): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('id', TJSONNumber.Create(AFarmaceutico.Id));
    Result.AddPair('nome', AFarmaceutico.Nome);
    Result.AddPair('cpf', AFarmaceutico.CPF);
    Result.AddPair('dataNascimento', TJSONString.Create(FormatDateTime('yyyy-mm-dd', AFarmaceutico.DataNascimento)));
    Result.AddPair('crf', AFarmaceutico.CRF);
    Result.AddPair('especializacao', AFarmaceutico.Especializacao);
  except
    Result.Free;
    raise;
  end;
end;

end.
