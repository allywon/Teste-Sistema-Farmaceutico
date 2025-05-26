unit Model.Procedimento.Tipo;

interface

uses
  Vcl.StdCtrls;

type
  TTipoProcedimento = (
    tpAtencaoDomiciliar,
    tpPressaoArterial,
    tpTemperaturaCorporal,
    tpGlicemiaCapilar,
    tpInalacao,
    tpInjetaveis
  );

  function TipoProcedimentoToStr(ATipo: TTipoProcedimento): string;
  function TipoProcedimentoDescricao(ATipo: TTipoProcedimento): string;
  function StrToTipoProcedimento(const ATexto: string): TTipoProcedimento;
  procedure PreencherComboTipo(ACombo: TCustomComboBox);

implementation

uses
  System.SysUtils;

function TipoProcedimentoToStr(ATipo: TTipoProcedimento): string;
begin
  case ATipo of
    tpAtencaoDomiciliar:     Result := 'Atenção farmacêutica domiciliar';
    tpPressaoArterial:       Result := 'Aferição de pressão arterial';
    tpTemperaturaCorporal:   Result := 'Aferição de temperatura corporal';
    tpGlicemiaCapilar:       Result := 'Aferição de glicemia capilar';
    tpInalacao:              Result := 'Inalação';
    tpInjetaveis:            Result := 'Aplicação de injetáveis';
  end;
end;

function TipoProcedimentoDescricao(ATipo: TTipoProcedimento): string;
begin
  case ATipo of
    tpAtencaoDomiciliar:
      Result := 'Visita domiciliar para acompanhamento farmacoterapêutico';
    tpPressaoArterial:
      Result := 'Medição e registro da pressão arterial';
    tpTemperaturaCorporal:
      Result := 'Verificação da temperatura corporal';
    tpGlicemiaCapilar:
      Result := 'Teste de glicemia com punção digital';
    tpInalacao:
      Result := 'Administração de medicamentos por inalação';
    tpInjetaveis:
      Result := 'Aplicação de medicamentos injetáveis';
  end;
end;

function StrToTipoProcedimento(const ATexto: string): TTipoProcedimento;
var
  lTipo: TTipoProcedimento;
begin
  for lTipo := Low(TTipoProcedimento) to High(TTipoProcedimento) do
  begin
    if SameText(TipoProcedimentoToStr(lTipo), ATexto) then
      Exit(lTipo);
  end;

  raise Exception.CreateFmt('Tipo de procedimento inválido: %s', [ATexto]);
end;

procedure PreencherComboTipo(ACombo: TCustomComboBox);
var
  lTipo: TTipoProcedimento;
begin
  ACombo.Items.Clear;
  for lTipo := Low(TTipoProcedimento) to High(TTipoProcedimento) do
    ACombo.Items.Add(TipoProcedimentoToStr(lTipo));
end;

end.

