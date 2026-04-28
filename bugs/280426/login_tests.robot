*** Settings ***
Resource    login_resources.robot
Test Teardown    Close Session

*** Test Cases ***
Scenario: Successful Login on Mobak
    [Documentation]    Test to validate login flow using BDD principles
    Given I am on the Mobak login page
    When I fill credentials with "seu_usuario" and "sua_senha"
    And I click the login button
    Then I should be redirected to the dashboard

*** Keywords ***
Given I am on the Mobak login page
    Open Mobak Login Page

When I fill credentials with "${user}" and "${pass}"
    Input Username    ${user}
    Input User Password    ${pass}

And I click the login button
    Submit Login

Then I should be redirected to the dashboard
    Verify Successful Login