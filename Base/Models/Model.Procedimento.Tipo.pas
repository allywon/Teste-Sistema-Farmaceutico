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
    tpAtencaoDomiciliar:     Result := 'Aten��o farmac�utica domiciliar';
    tpPressaoArterial:       Result := 'Aferi��o de press�o arterial';
    tpTemperaturaCorporal:   Result := 'Aferi��o de temperatura corporal';
    tpGlicemiaCapilar:       Result := 'Aferi��o de glicemia capilar';
    tpInalacao:              Result := 'Inala��o';
    tpInjetaveis:            Result := 'Aplica��o de injet�veis';
  end;
end;

function TipoProcedimentoDescricao(ATipo: TTipoProcedimento): string;
begin
  case ATipo of
    tpAtencaoDomiciliar:
      Result := 'Visita domiciliar para acompanhamento farmacoterap�utico';
    tpPressaoArterial:
      Result := 'Medi��o e registro da press�o arterial';
    tpTemperaturaCorporal:
      Result := 'Verifica��o da temperatura corporal';
    tpGlicemiaCapilar:
      Result := 'Teste de glicemia com pun��o digital';
    tpInalacao:
      Result := 'Administra��o de medicamentos por inala��o';
    tpInjetaveis:
      Result := 'Aplica��o de medicamentos injet�veis';
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

  raise Exception.CreateFmt('Tipo de procedimento inv�lido: %s', [ATexto]);
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

