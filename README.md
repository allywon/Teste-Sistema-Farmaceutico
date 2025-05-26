Instruções de Instalação e Execução
1. Baixe o projeto
- Clique em "Code" e selecione "Download ZIP".
- Extraia o conteúdo para o local desejado no seu computador.

2. Execute o serviço (Service.exe)
- Navegue até a pasta Teste\Service\Win32\Debug.
- Execute o arquivo Service.exe como administrador.
- Certifique-se de que o arquivo libmysql.dll (incluso na pasta) esteja no mesmo diretório do Service.exe.

3. Inicialização do banco de dados
- Ao iniciar o serviço, será criada automaticamente uma base de dados chamada banco_teste, com as tabelas necessárias e dados iniciais (procedimentos padrão).
- Esses procedimentos podem ser alterados posteriormente conforme necessário.

4. Execute o front-end
Vá até a pasta Teste\Front-end\Win32\Debug e execute o arquivo Teste.exe.

5. Estilo visual (opcional)
- O front-end utiliza o estilo "Sky" do Delphi.
- Para habilitá-lo:
  - Acesse Project > Options > Application > Appearance.
  - Em Available Styles, selecione Sky e marque como Default Style.

6. Pronto!
Agora você já pode realizar cadastros de pacientes, farmacêuticos, procedimentos e lançar os serviços farmacêuticos.

![Tela inicial](<Tela inicial.png>)



