@VerifyPayments
Feature: VerifyPayments

  Background: Initial Setup 
    Given The test data has been refreshed and Browser is open

  @loginSTANDARD
	Scenario: Verify STANDARD Login
  	Given A user has navigated to the STANDARD Login page
    When The user logs in
  	Then The user is redirected to the STANDARD Message Center page
    
  @logoutSTANDARD
	Scenario: Verify Partner Portal Logout
  	Given The user is logged into STANDARD   
    When The user logs out
    Then The user is redirected to the STANDARD Login page