*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}         chrome
${URL}             https://lampi.ifce.edu.br/mobak/login
${USER_FIELD}      id=username   
${PASS_FIELD}      id=password
${LOGIN_BUTTON}    id=login-button
${DASHBOARD_EL}    id=dashboard-title

*** Keywords ***
Open Mobak Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Input Username
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${USER_FIELD}
    Input Text    ${USER_FIELD}    ${username}

Input User Password
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${PASS_FIELD}
    Input Password    ${PASS_FIELD}    ${password}

Submit Login
    Click Button    ${LOGIN_BUTTON}

Verify Successful Login
    Wait Until Element Is Visible    ${DASHBOARD_EL}    timeout=10s
    Element Should Be Visible        ${DASHBOARD_EL}

Close Session
    Close Browser