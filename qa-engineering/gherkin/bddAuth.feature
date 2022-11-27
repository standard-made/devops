@Auth
Feature: bddAuth

  Background: Initial Setup 
    Given The test data has been refreshed and Browser is open

    #bad
  @loginPortalTraderQA
	Scenario: Verify Portal Trader Login
  	Given A "Trader" user navigates to the "Portal" homepage in the "QA" environment   
  	And The user has been redirected to "https://identity-dev.silvergate.com/" page for authentication
    When The user enters their email and password into the login form
    And The login button has been clicked
  	Then The user should be authenticated and redirected to "https://portal-qa.silvergate.com/accounts/wallet"
    
    #good
  @logoutPartnerPortal
	Scenario: Verify Partner Portal Logout
  	Given The user has an active session in Partner Portal   
    When The user navbar menu is verified
    Then The user can logout
  
  @loginPartnerPortal  
  Scenario Outline: Verify the Partner Portal login for every role (data-driven test)
    Given A <role> user navigates to the <site> homepage in the <envt> environment   
  	And The user has been redirected to <identity> page for authentication
    When The user enters their email and password into the login form
    And The login button has been clicked
  	Then The user should be authenticated and redirected to <homepage>
    And The user can logout
  
  # portalQA
  @ex-SuperAdmin-pQA
  Examples:
    | envt | role            | site      | identity                               | homepage                                           |
    | "QA" | "Super Admin"   | "Portal"  | "https://identity-dev.silvergate.com/" | "https://portal-qa.silvergate.com/accounts/wallet" |
    
  @ex-BackOfficeAdmin-pQA
  Examples:
    | envt | role                | site     | identity                               | homepage                                           |
    | "QA" | "Back Office Admin" | "Portal" | "https://identity-dev.silvergate.com/" | "https://portal-qa.silvergate.com/accounts/wallet" |
    
  @ex-FrontOffice-pQA
  Examples:
    | envt | role           | site          | identity                               | homepage                                           |
    | "QA" | "Front Office" | "Portal" | "https://identity-dev.silvergate.com/" | "https://portal-qa.silvergate.com/accounts/wallet" |
    
  @ex-TraderAdmin-pQA
  Examples:
    | envt | role            | site           | identity                               | homepage                                           |
    | "QA" | "Front Office"  | "Portal"  | "https://identity-dev.silvergate.com/" | "https://portal-qa.silvergate.com/accounts/wallet" |
  
  # portalSTG  
  @ex-SuperAdmin-pSTG
  Examples:
    | envt  | role          | site     | identity                               | homepage                                            |
    | "STG" | "Super Admin" | "Portal" | "https://identity-stg.silvergate.com/" | "https://portal-stg.silvergate.com/accounts/wallet" |
    
  @ex-BackOfficeAdmin-pSTG
  Examples:
    | envt  | role                | site     | identity                               | homepage                                            |
    | "STG" | "Back Office Admin" | "Portal" | "https://identity-stg.silvergate.com/" | "https://portal-stg.silvergate.com/accounts/wallet" |
    
  @ex-FrontOffice-pSTG
  Examples:
    | envt  | role           | site          | identity                               | homepage                                            |
    | "STG" | "Front Office" | "Portal" | "https://identity-stg.silvergate.com/" | "https://portal-stg.silvergate.com/accounts/wallet" |
    
  @ex-TraderAdmin-pSTG
  Examples:
    | envt  | role     | site          | identity                               | homepage                                            |
    | "STG" | "Trader" | "Portal" | "https://identity-stg.silvergate.com/" | "https://portal-stg.silvergate.com/accounts/wallet" |
  
  # backOfficeQA
  @ex-SuperAdmin-boQA
  Examples:
    | envt | role          | site     | identity                               | homepage                                        |
    | "QA" | "Super Admin" | "Back Office" | "https://identity-dev.silvergate.com/" | "https://backoffice-qa.silvergate.com/profiles" |
    
  @ex-BackOfficeAdmin-boQA
  Examples:
    | envt | role                | site     | identity                               | homepage                                        |
    | "QA" | "Back Office Admin" | "Back Office" | "https://identity-dev.silvergate.com/" | "https://backoffice-qa.silvergate.com/profiles" |
    
  @ex-FrontOffice-boQA
  Examples:
    | envt | role           | site          | identity                              | homepage                                        |
    | "QA" | "Front Office" | "Back Office" | "https://identity-dev.silvergate.com/" | "https://backoffice-qa.silvergate.com/profiles" |
    
  @ex-TraderAdmin-boQA
  Examples:
    | envt | role     | site         | identity                               | homepage                                        |
    | "QA" | "Trader" | "BackOffice" | "https://identity-dev.silvergate.com/" | "https://backoffice-qa.silvergate.com/profiles" |
    
  # backOfficeSTG
  @ex-SuperAdmin-boSTG
  Examples:
    | envt  | role          | site     | identity                               | homepage                                         |
    | "STG" | "Super Admin" | "Back Office" | "https://identity-stg.silvergate.com/" | "https://backoffice-stg.silvergate.com/profiles" |
    
  @ex-BackOfficeAdmin-boSTG
  Examples:
    | envt  | role                | site     | identity                               | homepage                                         |
    | "STG" | "Back Office Admin" | "Back Office" | "https://identity-stg.silvergate.com/" | "https://backoffice-stg.silvergate.com/profiles" |
    
  @ex-FrontOffice-boSTG
  Examples:
    | envt  | role           | site          | identity                               | homepage                                         |
    | "STG" | "Front Office" | "Back Office" | "https://identity-stg.silvergate.com/" | "https://backoffice-stg.silvergate.com/profiles" |
    
  @ex-TraderAdmin-boSTG
  Examples:
    | envt  | role     | site          | identity                               | homepage                                         |
    | "STG" | "Trader" | "Back Office" | "https://identity-stg.silvergate.com/" | "https://backoffice-stg.silvergate.com/profiles" |
