inherited fCadastroPaciente: TfCadastroPaciente
  Caption = 'Cadastro de Pacientes'
  TextHeight = 15
  inherited pnlCentro: TPanel
    inherited pnlDados: TPanel
      inherited edtCPF: TEdit
        MaxLength = 11
        NumbersOnly = True
      end
    end
    inherited pnlGrid: TPanel
      inherited pnlPesquisa: TPanel
        inherited lblPesquisa: TLabel
          Height = 22
        end
      end
    end
  end
end
