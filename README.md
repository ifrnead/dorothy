# Dorothy - Assistente Moodle-SUAP

## Requisitos

1. [Ruby 2.4+](https://www.ruby-lang.org)
2. [Bundler](http://bundler.io/)
3. [Google Chrome](http://chrome.google.com)
4. [ChromeDriver](https://github.com/SeleniumHQ/selenium/wiki/ChromeDriver)

## Instalação

1. Clone esse projeto: `git clone https://github.com/ifrnead/dorothy.git`
2. Entre no projeto: `cd dorothy`
3. Instale as dependências: `bundle install`

## Configuração

1. Crie o arquivo `credentials.yml` na raiz do projeto
2. Edite o `credentials.yml` e digite suas credenciais conforme modelo abaixo:

```
username: matricula
password: senha
```

## Execução

Dorothy funciona através de comandos. Atualmente existem três comandos: `migrate`, `postcheck` e `reset`. O comando `migrate` é usado para lançar as notas de um arquivo CSV exportado do Moodle para o SUAP. O comando `postcheck` é usado para verificar quais alunos possuem nota no arquivo CSV mas essa nota não foi lançada. O comando `reset` apaga as notas de todos os alunos do diário.

### Exportando notas do Moodle

Os comandos `migrate` e `postcheck` da Dorothy necessitam do arquivo de notas exportado do Moodle. Para exportar o arquivo de notas corretamente, siga os passos abaixo.

1. Acesse a página da sua disciplina no Moodle
2. Ative a edição
3. No menu Administração, clique na opção 'Notas'
4. Clique na aba 'Exportar'
5. Clique na aba 'Arquivo de texto'
6. Opcionalmente, no campo 'Grupos vísiveis', selecione de qual grupo deseja exportar as notas
7. No campo 'Casas decimais das notas exportadas' selecione 0 (zero)
8. Na seção 'Itens de nota a serem inclusos', descelecione todos os itens clicando no link 'Selecionar todos/nenhum'
9. Selecione **UMA ÚNICA ATIVIDADE** para exportar as notas (para migrar mais de uma nota, terá que executar o comando `migrate` mais de uma vez)
10. Clique em 'Enviar'
11. Clique em 'Download'
12. Salve o arquivo na pasta `data` do projeto

### Migrando notas para o SUAP

**Atenção para as seguintes mudanças no lançamento das notas:**

- Quando o aluno não tiver uma nota no arquivo CSV, será lançada a nota 0 (zero) para o aluno no SUAP
- Quando o aluno tiver uma nota no arquivo CSV mas não tiver no SUAP, a nota do arquivo CSV será lançada no SUAP
- Quando o aluno tiver a nota zero lançada no SUAP, essa nota será sobrescrita pela nota do arquivo CSV
- Quando o aluno tiver a mesma nota no arquivo CSV e no SUAP, nenhuma nota será lançada
- Caso o parâmetro `--force` seja usado, a nota do arquivo CSV irá sobrescrever as notas do SUAP. Sem o `--force`, caso o aluno já tenha uma nota no SUAP (diferente de zero), a nota do arquivo CSV não será lançada

O comando `migrate` é usado para migrar as notas do arquivo CSV exportado do Moodle para o SUAP. O comando `migrate` tem a seguinte sintaxe:

```
bin/grades migrate --id <ID_DIARIO> --csv <ARQUIVO_CSV> --stage <ETAPA> --activity <ATIVIDADE>
```

- `<ID_DIARIO>` é o número do diário no SUAP.
- `<ETAPA>` pode ser 1, 2 ou final. Default: `1`
- `<ARQUIVO_CSV>` é o path relativo para o arquivo CSV. Default: `data/grades.csv`
- `<ATIVIDADE>` é a descrição da atividade no SUAP entre aspas.

Uma vez executado, Dorothy irá abrir uma nova janela do Google Chrome e irá lançar as notas no SUAP. Não interfira. Ao concluir o lançamento das notas, essa janela será fechada automaticamente.

### Pós-checagem

O comando de pós-checagem é usado para verificar se a nota de cada aluno presente no arquivo CSV foi de fato lançada no SUAP. O comando `postcheck` tem a seguinte sintaxe:

```
bin/grades postcheck --id <ID_DIARIO> --csv <ARQUIVO_CSV> --stage <ETAPA> --activity <ATIVIDADE>
```

- `<ID_DIARIO>` é o número do diário no SUAP.
- `<ETAPA>` pode ser 1, 2 ou final. Default: `1`
- `<ARQUIVO_CSV>` é o path relativo para o arquivo CSV. Default: `data/grades.csv`
- `<ATIVIDADE>` é a descrição da atividade no SUAP entre aspas.

Uma vez executado, Dorothy irá abrir uma nova janela do Google Chrome e irá verificar as notas lançadas. Não interfira. Ao concluir, um relatório será apresentado no terminal de comandos.

### Reset

O comando `reset` é usado quando se deseja apagar todas as notas de uma atividade específica num diário. O comando `reset` tem a seguinte sintaxe:

```
bin/grades reset --id <ID_DIARIO> --stage <ETAPA> --activity <ATIVIDADE>
```

- `<ID_DIARIO>` é o número do diário no SUAP.
- `<ETAPA>` pode ser 1, 2 ou final. Default: `1`
- `<ATIVIDADE>` é a descrição da atividade no SUAP entre aspas.

## Encontrou um problema?

1. Acesse: https://github.com/ifrnead/dorothy/issues/new
2. Descreva o problema em detalhes
3. Clique em 'Submit new issue'

## Quer sugerir melhorias?

1. Acesse: https://github.com/ifrnead/dorothy
2. Clique em 'Fork'
3. Have fun! =)
