*** Settings ***
Library    SeleniumLibrary
Resource   login_resources.robot
Test Teardown    Close Session

*** Variables ***
${LONG_STRING}    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
...    aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

*** Test Cases ***
Scenario: Login with empty username
    [Documentation]    Test login with empty username field
    Given I am on the Mobak login page
    When I fill credentials    ${EMPTY}    senha123
    And I click the login button
    Then I should see an error message

Scenario: Login with empty password
    [Documentation]    Test login with empty password field
    Given I am on the Mobak login page
    When I fill credentials    usuario    ${EMPTY}
    And I click the login button
    Then I should see an error message

Scenario: Login with emojis in username
    [Documentation]    Test login with emoji characters
    Given I am on the Mobak login page
    When I fill credentials    user😀🎉    senha123
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with special characters
    [Documentation]    Test login with special symbols
    Given I am on the Mobak login page
    When I fill credentials    user@#$%^&*()    senha!@#$%
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with SQL injection attempt
    [Documentation]    Test SQL injection in username field
    Given I am on the Mobak login page
    When I fill credentials    admin' OR '1'='1    password
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with very long username
    [Documentation]    Test username with 500+ characters
    Given I am on the Mobak login page
    When I fill credentials    ${LONG_STRING}    senha123
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with spaces only
    [Documentation]    Test login with only whitespace
    Given I am on the Mobak login page
    When I fill credentials    ${SPACE}${SPACE}${SPACE}    ${SPACE}${SPACE}${SPACE}
    And I click the login button
    Then I should see an error message

Scenario: Login with HTML tags
    [Documentation]    Test HTML injection attempt
    Given I am on the Mobak login page
    When I fill credentials    <script>alert('xss')</script>    senha123
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with unicode characters
    [Documentation]    Test unicode characters in fields
    Given I am on the Mobak login page
    When I fill credentials    用户测试    пароль123
    And I click the login button
    Then I should see an error message or invalid login

Scenario: Login with invalid credentials
    [Documentation]    Test wrong username and password
    Given I am on the Mobak login page
    When I fill credentials    usuario_invalido    senha_errada
    And I click the login button
    Then I should see an error message or invalid login

*** Keywords ***
Given I am on the Mobak login page
    Open Mobak Login Page

When I fill credentials
    [Arguments]    ${user}    ${pass}
    Input Username    ${user}
    Input User Password    ${pass}

And I click the login button
    Submit Login

Then I should see an error message
    ${check1}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.error-message    timeout=5s
    ${check2}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=[class*='error']    timeout=5s
    ${check3}=    Run Keyword And Return Status    Page Should Contain    Invalid
    Should Be True    ${check1} == True or ${check2} == True or ${check3} == True

Then I should see an error message or invalid login
    [Arguments]    ${timeout}=5s
    ${check1}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=.error-message    timeout=${timeout}
    ${check2}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=[class*='error']    timeout=${timeout}
    ${check3}=    Run Keyword And Return Status    Page Should Contain    Invalid
    ${check4}=    Run Keyword And Return Status    Page Should Contain    erro
    Should Be True    ${check1} == True or ${check2} == True or ${check3} == True or ${check4} == True