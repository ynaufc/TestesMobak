# Testes Funcionais - Aplicação Mobak

## Descrição da Task
Este repositório contém a documentação e os resultados da bateria de testes funcionais realizada na ferramenta Mobak. O objetivo principal é validar a integridade de todas as funcionalidades da aplicação, garantindo que operem conforme o esperado, sem a presença de erros visuais ou de comportamento.

## Ambiente de Teste
* **Ambiente:** Edu MOBAK

## Escopo dos Testes
* Validação de todas as funcionalidades do aplicativo.
* Verificação de consistência visual e interface do usuário.
* Monitoramento de comportamento inesperado ou falhas de fluxo.
* Identificação e reporte de bugs.
* Documentação detalhada de cenários de reprodução.

## Critérios de Aceite
Para que a entrega seja considerada concluída, os seguintes pontos devem ser atendidos:
1. Execução de todos os cenários de uso principais.
2. Documentação completa de todos os bugs encontrados.
3. Entrega de um relatório final contendo a lista de falhas e observações pertinentes.

---

## Bugs Encontrados

### 1. Formulário de Cadastro (Registro de Usuário)
* **Permissão de Caracteres Especiais no Nome:** O campo de nome aceita símbolos e caracteres especiais sem validação (exemplo: "Ana &*$%").
* **Instituição Inconsistente:** O campo aceita sequências de texto sem sentido ou aleatórias (exemplo: "asdsd").
* **Máscara de Telefone Inválida:** O sistema permite o registro com números de telefone em formatos nulos ou inválidos (exemplo: "(00) 90000-0000").
* **Valores Numéricos Irreais:** Campos de data ou tempo permitem a inserção de valores fora da lógica temporal (exemplo: "2444").
* **Aceitação de E-mails Inexistentes:** O sistema valida cadastros com domínios de e-mail fictícios (exemplo: "@teste.com").
* **Ausência de Requisitos de Senha:** O sistema permite a criação de contas com senhas extremamente fracas e repetitivas (exemplo: "aaaaaaaa").

### 2. Gerenciamento de Turmas
* **Inserção de Símbolos e Emojis:** O nome da turma aceita caracteres especiais e emojis, o que pode causar erros de renderização ou quebra de layout em diferentes dispositivos.

### 3. Dados do Aluno e Perfil
* **Nomes com Emojis:** O campo de nome do aluno aceita a inclusão de emojis, o que fere as regras de padronização de dados nominais.
* **Erro de Upload de Arquivo Incompatível:** Ao tentar subir um arquivo de script (Python) no campo destinado à foto de perfil, o sistema apresenta um "erro inesperado" em vez de exibir uma mensagem de erro tratada informando que o formato do arquivo é incompatível.

---

## Relatório Final

A bateria de testes evidenciou que a aplicação Mobak apresenta vulnerabilidades críticas no que diz respeito à validação de entrada de dados (input validation). A falta de restrições em campos de texto permite a inserção de dados inconsistentes, o que pode comprometer a integridade do banco de dados e a experiência do usuário final.

Além disso, a gestão de erros em processos de upload precisa de tratamento para evitar que falhas genéricas sejam exibidas ao usuário, garantindo uma navegação mais intuitiva e segura.

**Recomendações:**
* Implementar máscaras de entrada rigorosas para telefones e e-mails.
* Estabelecer uma política de complexidade de senhas.
* Aplicar filtros de sanitização para impedir o uso de símbolos e emojis em campos de nomes próprios.
* Configurar um manipulador de exceções para uploads de arquivos, restringindo as extensões apenas para formatos de imagem (JPG, PNG).
