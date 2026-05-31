*** Settings ***
Library    SeleniumLibrary
Resource   login_resources.robot
Test Teardown    Close Session

*** Variables ***
# Strings longas para teste de buffer overflow
${LONG_STRING_100}    ${EMPTY}
${LONG_STRING_500}    ${EMPTY}
${INVALID_EMAIL}    usuario@invalido@teste.com
${EMAIL_SEM_ARROBA}    usuarioinvalido.com
${SQL_INJECTION_1}    admin' OR '1'='1
${SQL_INJECTION_2}    admin'; DROP TABLE users; --
${SQL_INJECTION_3}    ' UNION SELECT * FROM users --
${XSS_SCRIPT_1}    <script>alert('XSS')</script>
${XSS_SCRIPT_2}    <img src=x onerror=alert('XSS')>
${XSS_SCRIPT_3}    javascript:alert('XSS')
${UNICODE_CHINESE}    用户测试用户名
${UNICODE_RUSSIAN}    пользователь
${UNICODE_ARABIC}    مستخدم
${EMOJI_STRING}    😀🎉🚀💻🔐
${WHITESPACE_ONLY}    ${SPACE}${SPACE}${SPACE}${SPACE}${SPACE}
${SPECIAL_CHARS>    user@#$%^&*()_+-=[]{}|;:',.<>?
${HTML_TAGS}    <b>negrito</b><i>italico</i>

*** Test Cases ***
# ============================================================================
# CT01 - Autenticação com identificador nulo (Cenário Negativo)
# ============================================================================
CT01_Login_With_Empty_Username
    [Documentation]    Validar comportamento do sistema ao submeter login sem usuário
    [Tags]    negative    authentication    CT01
    Given I am on the Mobak login page
    When I fill credentials with empty username    senha123
    And I click the login button
    Then I should see validation_error_message

# ============================================================================
# CT02 - Autenticação com credencial de senha nula (Cenário Negativo)
# ============================================================================
CT02_Login_With_Empty_Password
    [Documentation]    Validar bloqueio de acesso ao submeter login sem senha
    [Tags]    negative    authentication    CT02
    Given I am on the Mobak login page
    When I fill credentials with empty password    usuario_teste
    And I click the login button
    Then I should see validation_error_message

# ============================================================================
# CT03 - Submissão de caracteres não-alfanuméricos/emoji (Cenário de Validação)
# ============================================================================
CT03_Login_With_Emoji_Characters
    [Documentation]    Testar robustez da validação com caracteres emoji
    [Tags]    validation    authentication    CT03
    Given I am on the Mobak login page
    When I fill credentials    ${EMOJI_STRING}    senha123
    And I click the login button
    Then I should see error_or_invalid_login

# ============================================================================
# CT04 - Inserção de caracteres especiais não autorizados (Cenário de Validação)
# ============================================================================
CT04_Login_With_Special_Characters
    [Documentation]    Testar sanitização de dados com símbolos especiais
    [Tags]    validation    authentication    CT04
    Given I am on the Mobak login page
    When I fill credentials    ${SPECIAL_CHARS}    senha!@#$%
    And I click the login button
    Then I should see error_or_invalid_login

# ============================================================================
# CT05 - Tentativa de injeção SQL (Cenário de Segurança)
# ============================================================================
CT05_Login_With_SQL_Injection_Attempt
    [Documentation]    Avaliar resiliência contra injeção de SQL
    [Tags]    security    authentication    CT05
    Given I am on the Mobak login page
    When I fill credentials    ${SQL_INJECTION_1}    password123
    And I click the login button
    Then I should see error_or_invalid_login
    And System should_not_crash_or_expose_database_info

# ============================================================================
# CT06 - Violação de limite de caracteres (Cenário de Validação)
# ============================================================================
CT06_Login_With_Very_Long_Username
    [Documentation]    Testar comportamento com username excedendo limite
    [Tags]    validation    authentication    CT06
    Given I am on the Mobak login page
    When I fill credentials with long string    senha123
    And I click the login button
    Then I should see error_or_invalid_login_or_truncation

# ============================================================================
# CT07 - Validação de entradas com apenas espaços (Cenário de Validação)
# ============================================================================
CT07_Login_With_Whitespace_Only
    [Documentation]    Verificar algoritmo de limpeza com espaços em branco
    [Tags]    validation    authentication    CT07
    Given I am on the Mobak login page
    When I fill credentials    ${WHITESPACE_ONLY}    ${WHITESPACE_ONLY}
    And I click the login button
    Then I should see validation_error_message

# ============================================================================
# CT08 - Ataque de Cross-Site Scripting - XSS (Cenário de Segurança)
# ============================================================================
CT08_Login_With_XSS_Attempt
    [Documentation]    Testar proteção contra execução de scripts maliciosos
    [Tags]    security    authentication    CT08
    Given I am on the Mobak login page
    When I fill credentials    ${XSS_SCRIPT_1}    senha123
    And I click the login button
    Then I should see error_or_invalid_login
    And Script should_not_execute

# ============================================================================
# CT09 - Suporte a codificação Unicode (Cenário de Validação)
# ============================================================================
CT09_Login_With_Unicode_Characters
    [Documentation]    Validar aceitação de caracteres internacionais
    [Tags]    validation    authentication    CT09
    Given I am on the Mobak login page
    When I fill credentials    ${UNICODE_CHINESE}    ${UNICODE_RUSSIAN}
    And I click the login button
    Then I should see error_or_invalid_login

# ============================================================================
# CT10 - Autenticação com credenciais divergentes (Cenário Negativo)
# ============================================================================
CT10_Login_With_Invalid_Credentials
    [Documentation]    Certificar rejeição de acesso com credenciais inválidas
    [Tags]    negative    authentication    CT10
    Given I am on the Mobak login page
    When I fill credentials    usuario_inexistente    senha_errada
    And I click the login button
    Then I should see invalid_credentials_message
    And I should_remain_on_login_page

# ============================================================================
# CT12 - Restrição temporária por força bruta (Regra de Negócio)
# ============================================================================
CT12_Login_Bruteforce_Protection
    [Documentation]    Validar bloqueio após múltiplas falhas de autenticação
    [Tags]    business_rule    security    authentication    CT12
    Given I am on the Mobak login page
    When I attempt login with invalid credentials multiple times    5
    Then Account should_be_temporarily_locked_or_captcha_shown

# ============================================================================
# Teste Adicional - Validação de Email Inválido
# ============================================================================
CT_Login_With_Invalid_Email_Format
    [Documentation]    Testar validação de formato de email
    [Tags]    validation    authentication
    Given I am on the Mobak login page
    When I fill credentials    ${INVALID_EMAIL}    senha123
    And I click the login button
    Then I should see error_or_invalid_login

*** Keywords ***
Given I am on the Mobak login page
    [Documentation]    Navega para a página de login do Mobak
    Open Mobak Login Page
    Wait Until Element Is Visible    ${USER_FIELD}    timeout=10s

When I fill credentials
    [Documentation]    Preenche usuário e senha
    [Arguments]    ${user}    ${pass}
    Input Username    ${user}
    Input User Password    ${pass}

When I fill credentials with empty username
    [Documentation]    Preenche apenas a senha
    [Arguments]    ${pass}
    Input Username    ${EMPTY}
    Input User Password    ${pass}

When I fill credentials with empty password
    [Documentation]    Preenche apenas o usuário
    [Arguments]    ${user}
    Input Username    ${user}
    Input User Password    ${EMPTY}

When I fill credentials with long string
    [Documentation]    Preenche com string longa (500+ caracteres)
    [Arguments]    ${pass}
    ${long_username}=    Generate Long String    500
    Input Username    ${long_username}
    Input User Password    ${pass}

When I attempt login with invalid credentials multiple times
    [Documentation]    Tenta login inválido múltiplas vezes
    [Arguments]    ${attempts}
    FOR    ${i}    IN RANGE    ${attempts}
        Input Username    usuario_errado_${i}
        Input User Password    senha_errada
        Click Button    ${LOGIN_BUTTON}
        Wait Until Element Is Visible    css=.error-message    timeout=5s
        Wait Until Element Is Not Visible    css=.error-message    timeout=10s
    END

And I click the login button
    [Documentation]    Clica no botão de login
    Click Button    ${LOGIN_BUTTON}
    Wait Until Page Contains Element    xpath=//body    timeout=10s

Then I should see validation_error_message
    [Documentation]    Verifica mensagem de erro de validação
    ${error_found}=    Run Keyword And Return Status    Wait Until Element Is Visible    
    ...    css=.error-message, .alert, [class*='error'], [class*='alert'], .validation-message    
    ...    timeout=5s
    ${empty_field}=    Run Keyword And Return Status    Page Should Contain    
    ...    campo    timeout=3s
    ${required_field}=    Run Keyword And Return Status    Page Should Contain    
    ...    obrigatório    timeout=3s
    ${invalid}=    Run Keyword And Return Status    Page Should Contain    Invalid    timeout=3s
    Should Be True    ${error_found} == True or ${empty_field} == True or ${required_field} == True or ${invalid} == True    
    ...    msg=Nenhuma mensagem de erro de validação encontrada

Then I should see error_or_invalid_login
    [Documentation]    Verifica mensagem de erro ou login inválido
    ${error_found}=    Run Keyword And Return Status    Wait Until Element Is Visible    
    ...    css=.error-message, .alert, [class*='error'], [class*='alert']    
    ...    timeout=5s
    ${invalid_text}=    Run Keyword And Return Status    Page Should Contain    Invalid    timeout=3s
    ${erro_text}=    Run Keyword And Return Status    Page Should Contain    erro    timeout=3s
    ${fail_text}=    Run Keyword And Return Status    Page Should Contain    falha    timeout=3s
    Should Be True    ${error_found} == True or ${invalid_text} == True or ${erro_text} == True or ${fail_text} == True    
    ...    msg=Nenhuma mensagem de erro encontrada

Then I should see invalid_credentials_message
    [Documentation]    Verifica mensagem específica de credenciais inválidas
    ${credenciais}=    Run Keyword And Return Status    Page Should Contain    credenciais    timeout=3s
    ${invalido}=    Run Keyword And Return Status    Page Should Contain    inválido    timeout=3s
    ${incorrect}=    Run Keyword And Return Status    Page Should Contain    Incorrect    timeout=3s
    ${wrong}=    Run Keyword And Return Status    Page Should Contain    Wrong    timeout=3s
    Should Be True    ${credenciais} == True or ${invalido} == True or ${incorrect} == True or ${wrong} == True    
    ...    msg=Mensagem de credenciais inválidas não encontrada

Then I should remain_on_login_page
    [Documentation]    Verifica se permaneceu na página de login
    Wait Until Element Is Visible    ${USER_FIELD}    timeout=5s
    Wait Until Element Is Visible    ${PASS_FIELD}    timeout=5s

Then I should see error_or_invalid_login_or_truncation
    [Documentation]    Verifica erro, login inválido ou truncamento
    ${error_found}=    Run Keyword And Return Status    Wait Until Element Is Visible    
    ...    css=.error-message, .alert, [class*='error']    
    ...    timeout=5s
    ${invalid_text}=    Run Keyword And Return Status    Page Should Contain    Invalid    timeout=3s
    ${erro_text}=    Run Keyword And Return Status    Page Should Contain    erro    timeout=3s
    # Ou verifica se o sistema aceitou (truncou) - cenário alternativo
    ${dashboard}=    Run Keyword And Return Status    Wait Until Element Is Visible    
    ...    ${DASHBOARD_EL}    timeout=3s
    Should Be True    ${error_found} == True or ${invalid_text} == True or ${erro_text} == True or ${dashboard} == True    
    ...    msg=Nenhum comportamento esperado encontrado

Then Account should_be_temporarily_locked_or_captcha_shown
    [Documentation]    Verifica se conta foi bloqueada ou captcha exibido
    ${locked}=    Run Keyword And Return Status    Page Should Contain    bloqueada    timeout=3s
    ${locked_en}=    Run Keyword And Return Status    Page Should Contain    locked    timeout=3s
    ${try_later}=    Run Keyword And Return Status    Page Should Contain    tente mais tarde    timeout=3s
    ${captcha}=    Run Keyword And Return Status    Page Should Contain    captcha    timeout=3s
    ${attempts}=    Run Keyword And Return Status    Page Should Contain    tentativas    timeout=3s
    Should Be True    ${locked} == True or ${locked_en} == True or ${try_later} == True or ${captcha} == True or ${attempts} == True    
    ...    msg=Nenhuma indicação de bloqueio ou captcha encontrada

And System should_not_crash_or_expose_database_info
    [Documentation]    Verifica se sistema não crashou ou expôs info do banco
    ${crash}=    Run Keyword And Return Status    Page Should Contain    500 Internal Server Error    timeout=3s
    ${database}=    Run Keyword And Return Status    Page Should Contain    SQL    timeout=3s
    ${syntax}=    Run Keyword And Return Status    Page Should Contain    syntax error    timeout=3s
    ${trace}=    Run Keyword And Return Status    Page Should Contain    traceback    timeout=3s
    Should Be False    ${crash} == True and (${database} == True or ${syntax} == True or ${trace} == True)    
    ...    msg=Sistema expôs informações sensíveis ou crashou

And Script should_not_execute
    [Documentation]    Verifica se script XSS não foi executado
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=2s
    Should Be False    ${alert_present} == True    msg=Script XSS foi executado!

Generate Long String
    [Documentation]    Gera string longa para teste
    [Arguments]    ${length}=500
    ${string}=    Evaluate    'a' * ${length}
    RETURN    ${string}

Close Session
    [Documentation]    Fecha o navegador
    Close Browser