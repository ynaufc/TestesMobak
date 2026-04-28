*** Settings ***
Library    SeleniumLibrary
Library    WebDriverManager

*** Variables ***
${BROWSER}        chrome
${URL}            https://lampi.ifce.edu.br/mobak/login
${USER_FIELD}     xpath=/html/body/div/main/div/div/form/div[1]/div/input
${PASS_FIELD}     xpath=/html/body/div/main/div/div/form/div[2]/div/input
${LOGIN_BUTTON}   xpath=/html/body/div/main/div/div/form/button
${DASHBOARD_EL}   xpath=//h1

*** Keywords ***
Open Mobak Login Page
    [Documentation]    Opens the browser and navigates to login page
    Open Browser    ${URL}    ${BROWSER}
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