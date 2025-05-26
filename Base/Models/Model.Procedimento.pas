unit Model.Procedimento;

interface

uses
  System.SysUtils, System.DateUtils, Model.Procedimento.Tipo;

type
  TProcedimento = class
  private
    FId: Int64;
    FTipo: TTipoProcedimento;
    FDescricao: string;
    FValor: Currency;
    FAviso: String;
  public
    property Id: Int64 read FId write FId;
    property Tipo: TTipoProcedimento read FTipo write FTipo;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Currency read FValor write FValor;
    property Aviso: String read FAviso write FAviso;

    procedure Limpar;
  end;

implementation

procedure TProcedimento.Limpar;
begin
  FId := 0;
  FTipo := tpAtencaoDomiciliar;
  FDescricao := EmptyStr;
  FValor := 0;
  FAviso := EmptyStr;
end;

end.

