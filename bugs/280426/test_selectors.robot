*** Settings ***
Library    SeleniumLibrary
Library    WebDriverManager

*** Test Cases ***
Test Find Elements
    [Documentation]    
    Run Keyword If    '${BROWSER}' == 'chrome'    WebDriverManager    Chrome
    Open Browser    https://lampi.ifce.edu.br/mobak/login    ${BROWSER}
    
    # Testar se os elementos são encontrados
    Wait Until Element Is Visible    id=username    10s
    Log    Campo usuário encontrado
    
    Wait Until Element Is Visible    id=password    10s
    Log    Campo senha encontrado
    
    Wait Until Element Is Visible    id=login-button    10s
    Log    Botão login encontrado
    
    Close Browser