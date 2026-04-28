*** Settings ***
Resource         login_resources.robot
Test Teardown    Close Session

*** Test Cases ***
Cenário: Login com sucesso no Mobak
    [Documentation]    Teste para validar o fluxo de login usando princípios de BDD.
    Dado que estou na página de login do Mobak
    Quando preencho as credenciais com "seu_usuario" e "sua_senha"
    E clico no botão de login
    Então devo ser redirecionado para o dashboard

*** Keywords ***
Dado que estou na página de login do Mobak
    Open Mobak Login Page

Quando preencho as credenciais com "${user}" e "${pass}"
    Input Username    ${user}
    Input User Password    ${pass}

E clico no botão de login
    Submit Login

Então devo ser redirecionado para o dashboard
    Verify Successful Login