@VerifyPayments
Feature: VerifyPayments

  Background: Initial Setup 
    Given The test data has been refreshed and Browser is open

  @loginFinastra
	Scenario: Verify Finastra Login
  	Given A user has navigated to the Finastra Login page
    When The user logs in
  	Then The user is redirected to the Finastra Message Center page
    
  @logoutFinastra
	Scenario: Verify Partner Portal Logout
  	Given The user is logged into Finastra   
    When The user logs out
    Then The user is redirected to the Finastra Login page