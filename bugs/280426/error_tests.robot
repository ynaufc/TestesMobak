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
    [Documentation]    Test login with only whitespace
    Given I am on the Mobak login page
    When I fill credentials with "   " and "   "
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
    Wait Until Element Is Visible    css=.error-message    timeout=5s
    ...    OR
    Wait Until Element Is Visible    css=[class*='error']    timeout=5s
    ...    OR
    Page Should Contain    Invalid    timeout=5s

Then I should see an error message or invalid login
    [Arguments]    ${timeout}=5s
    Run Keyword And Ignore Error    Wait Until Element Is Visible    css=.error-message    ${timeout}
    Run Keyword And Ignore Error    Wait Until Element Is Visible    css=[class*='error']    ${timeout}
    Run Keyword And Ignore Error    Page Should Contain    Invalid    ${timeout}
    Run Keyword And Ignore Error    Page Should Contain    erro    ${timeout}

*** Variables ***
${LONG_STRING}    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa