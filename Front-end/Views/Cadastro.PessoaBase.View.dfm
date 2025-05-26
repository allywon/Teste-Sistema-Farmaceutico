object fCadastroPessoaBase: TfCadastroPessoaBase
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Pessoa Base'
  ClientHeight = 550
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlBotoes: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 40
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object btnNovo: TBitBtn
      Left = 8
      Top = 6
      Width = 90
      Height = 28
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnEditar: TBitBtn
      Left = 104
      Top = 6
      Width = 90
      Height = 28
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnSalvar: TBitBtn
      Left = 607
      Top = 6
      Width = 90
      Height = 28
      Caption = 'Salvar'
      TabOrder = 2
      OnClick = btnSalvarClick
    end
    object btnExcluir: TBitBtn
      Left = 200
      Top = 6
      Width = 90
      Height = 28
      Caption = 'Excluir'
      TabOrder = 3
      OnClick = btnExcluirClick
    end
    object btnCancelar: TBitBtn
      Left = 703
      Top = 6
      Width = 90
      Height = 28
      Caption = 'Cancelar'
      TabOrder = 4
      OnClick = btnCancelarClick
    end
  end
  object pnlCentro: TPanel
    Left = 0
    Top = 40
    Width = 800
    Height = 510
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlDados: TPanel
      Left = 0
      Top = 0
      Width = 800
      Height = 160
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object lblCPF: TLabel
        Left = 49
        Top = 56
        Width = 21
        Height = 15
        Alignment = taRightJustify
        Caption = 'CPF'
      end
      object lblNascimento: TLabel
        Left = 6
        Top = 88
        Width = 64
        Height = 15
        Alignment = taRightJustify
        Caption = 'Nascimento'
      end
      object lblNome: TLabel
        Left = 37
        Top = 32
        Width = 33
        Height = 15
        Alignment = taRightJustify
        Caption = 'Nome'
      end
      object lblCodigo: TLabel
        Left = 31
        Top = 9
        Width = 39
        Height = 15
        Alignment = taRightJustify
        Caption = 'C'#243'digo'
      end
      object edtCPF: TEdit
        Left = 76
        Top = 52
        Width = 250
        Height = 23
        MaxLength = 11
        NumbersOnly = True
        TabOrder = 0
      end
      object edtNome: TEdit
        Left = 76
        Top = 28
        Width = 250
        Height = 23
        TabOrder = 1
      end
      object edtDtNascimento: TDatePicker
        Left = 76
        Top = 77
        Date = 45794.000000000000000000
        DateFormat = 'dd/mm/yyyy'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = []
        TabOrder = 2
      end
      object edtCodigo: TEdit
        Left = 76
        Top = 6
        Width = 80
        Height = 23
        NumbersOnly = True
        TabOrder = 3
      end
    end
    object pnlGrid: TPanel
      Left = 0
      Top = 160
      Width = 800
      Height = 350
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object dbgPessoas: TDBGrid
        Left = 0
        Top = 33
        Width = 800
        Height = 317
        Align = alClient
        DataSource = dsPessoas
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'ID'
            Title.Caption = 'C'#243'digo'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Width = 60
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Nome'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Width = 487
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DataNascimento'
            Title.Caption = 'Nascimento'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Width = 104
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cpf'
            Title.Caption = 'CPF'
            Title.Font.Charset = DEFAULT_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Segoe UI'
            Title.Font.Style = [fsBold]
            Width = 127
            Visible = True
          end>
      end
      object pnlPesquisa: TPanel
        Left = 0
        Top = 0
        Width = 800
        Height = 33
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object lblPesquisa: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 8
          Width = 53
          Height = 22
          Margins.Top = 8
          Align = alLeft
          Caption = 'Pesquisar:'
          ExplicitHeight = 15
        end
        object edtPesquisa: TEdit
          AlignWithMargins = True
          Left = 62
          Top = 3
          Width = 731
          Height = 27
          Align = alLeft
          TabOrder = 0
          OnChange = edtPesquisaChange
          ExplicitHeight = 23
        end
      end
    end
  end
  object dsPessoas: TDataSource
    Left = 256
    Top = 322
  end
end
