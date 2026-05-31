*** Settings ***
Library     SeleniumLibrary
Resource    variables.robot

*** Keywords ***

Open Mobak Login Page
    [Documentation]    Opens the browser and navigates to login page
    ${opts}=    Evaluate    sys.modules['selenium'].webdriver.ChromeOptions()    sys
    Call Method    ${opts}    add_argument    --disable-dev-shm-usage
    Call Method    ${opts}    add_argument    --no-sandbox
    Open Browser    ${URL}    ${BROWSER}    options=${opts}
    Maximize Browser Window
    Wait Until Element Is Visible    ${USER_FIELD}    timeout=10s

Input Username
    [Arguments]    ${username}
    Input Text    ${USER_FIELD}    ${username}

Input User Password
    [Arguments]    ${password}
    Input Password    ${PASS_FIELD}    ${password}

Submit Login
    [Documentation]    Clicks the login button
    Click Button    ${LOGIN_BUTTON}

Verify Successful Login
    [Documentation]    Verifies if user was redirected to dashboard
    Wait Until Element Is Visible    ${DASHBOARD_EL}    timeout=15s

Close Session
    [Documentation]    Closes the browser
    Close Browser

Realizar Login Com Sucesso
    [Documentation]    Executa o fluxo completo de autenticação com dados válidos
    Given Open Mobak Login Page
    When Input Username         ${USER_VALIDO}
    And Input User Password     ${SENHA_VALIDA}
    And Submit Login
    Then Verify Successful Login

Realizar Login Como Operador Restrito
    [Documentation]    Executa o login utilizando uma conta sem privilégios administrativos
    Given Open Mobak Login Page
    When Input Username         ${USER_OPERADOR}
    And Input User Password     ${SENHA_VALIDA}
    And Submit Login
    Then Verify Successful Login

Realizar Logout
    [Documentation]    Encerra a sessão atual e verifica o redirecionamento para o formulário
    Click Link                       ${LOGOUT_BTN}
    Wait Until Element Is Visible    ${USER_FIELD}    timeout=10s

Ir Para Pagina de Cadastro
    [Documentation]    Acessa o ambiente a partir do login e direciona à tela de registro
    Open Mobak Login Page
    Click Link                       ${REGISTER_BTN}
    Wait Until Element Is Visible    ${NEW_EMAIL_FIELD}    timeout=10s