*** Settings ***
Resource    login_resources.robot
Test Teardown    Close Session

*** Test Cases ***
Scenario: Login with empty username
    [Documentation]    Test login with empty username field
    Given I am on the Mobak login page
    When I fill credentials with "" and "senha123"
    And I click the login button
    Then I should see an error message

Scenario: Login with empty password
    [Documentation]    Test login with empty password field
    Given I am on the Mobak login page
    When I fill credentials with "usuario" and ""
    And I click the login button
    Then I should see an error message

Scenario: Login with emojis in username
    [Documentation]    Test login with emoji characters
    Given I am on the Mobak login page
    When I fill credentials with "user😀🎉" and "senha123"
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with special characters
    [Documentation]    Test login with special symbols
    Given I am on the Mobak login page
    When I fill credentials with "user@#$%^&*()" and "senha!@#$%"
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with SQL injection attempt
    [Documentation]    Test SQL injection in username field
    Given I am on the Mobak login page
    When I fill credentials with "admin' OR '1'='1" and "password"
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with very long username
    [Documentation]    Test username with 500+ characters
    Given I am on the Mobak login page
    When I fill credentials with "${LONG_STRING}" and "senha123"
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with spaces only
    And I click the login button
    Then I should see an error message

Scenario: Login with HTML tags
    [Documentation]    Test HTML injection attempt
    Given I am on the Mobak login page
    When I fill credentials with "<script>alert('xss')</script>" and "senha123"
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with unicode characters
    [Documentation]    Test unicode characters in fields
    Given I am on the Mobak login page
    When I fill credentials with "用户测试" and "пароль123"
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with invalid credentials
    [Documentation]    Test wrong username and password
    Given I am on the Mobak login page
    When I fill credentials with "usuario_invalido" and "senha_errada"
    And I click the login button
    Then I should see an error message or invalid login

*** Keywords ***
Given I am on the Mobak login page
    Open Mobak Login Page

When I fill credentials with "${user}" and "${pass}"
    Input Username    ${user}
    Input User Password    ${pass}

And I click the login button
    Submit Login

Then I should see an error message
    ${check1}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.error-message    timeout=5s
    ${check2}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=[class*='error']    timeout=5s
    ${check3}=    Run Keyword And Return Status    Page Should Contain    Invalid
    Should Be True    ${check1} or ${check2} or ${check3}

Then I should see an error message or invalid login
    [Arguments]    ${timeout}=5s
    ${check1}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.error-message    timeout=${timeout}
    ${check2}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=[class*='error']    timeout=${timeout}
    ${check3}=    Run Keyword And Return Status    Page Should Contain    Invalid
    ${check4}=    Run Keyword And Return Status    Page Should Contain    erro
    Should Be True    ${check1} or ${check2} or ${check3} or ${check4}

*** Variables ***
${LONG_STRING}    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa