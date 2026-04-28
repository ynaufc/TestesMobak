*** Settings ***
Library    SeleniumLibrary
Library    WebDriverManager

*** Variables ***
${BROWSER}        chrome
${URL}            https://lampi.ifce.edu.br/mobak/login
${USER_FIELD}     id=username
${PASS_FIELD}     id=password
${LOGIN_BUTTON}   id=login-button
${DASHBOARD_EL}   id=dashboard-title

*** Keywords ***
Open Mobak Login Page
    [Documentation]    Opens the browser and navigates to login page
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
    [Documentation]    Clicks the login button
    Click Button    ${LOGIN_BUTTON}

Verify Successful Login
    [Documentation]    Verifies if user was redirected to dashboard
    Wait Until Element Is Visible    ${DASHBOARD_EL}    timeout=10s
    Element Should Be Visible    ${DASHBOARD_EL}

Navigate To Dashboard
    [Documentation]    Navigate to dashboard after login
    Go To    ${URL}/dashboard

Take Screenshot On Failure
    [Documentation]    Capture screenshot if test fails
    Capture Page Screenshot    failure_screenshot.png
    
Close Session
    [Documentation]    Closes the browser
    Close Browser