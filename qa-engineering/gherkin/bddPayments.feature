@Payments
Feature: bddPayments

  Background: Setup Payments
    Given The test data has been refreshed and Browser is open
  
    #bad  
  @paymentForeignCurrencySTP
	Scenario: Send a Foreign Currency Payment  STP
  	Given The user navigates to the Transfer Payments page
    And The user requires "0" approval for "Foreign Currency Payment" services
    And The user completes a valid "Payment" request   
  	When The user is redirected to the "Add Beneficiary" page
    And The user has filled out the appropriate beneficiary information
    And The user has submitted the "Payment" to complete a valid transfer
    Then The user is returned to the "homepage" and shown a success message
    And The payment is removed from the "Add Beneficiary" queue
  
    #good
  @paymentFC
	Scenario Outline: Send a Payment
  	Given The <role> is logged into Portal 
    And The user requires "0" approvals to make a payment
    And The user has account permissions and services enabled
  	When The user submits a payment transaction
    Then The payment can be verified
    And The user can logout
  
  @ex-PaymentFC  
  Examples: 
    | role                |  approval |
    | "Trader"            |  "0"      |
    | "Trader"            |  "1"      |
    | "Trader"            |  "2"      |
    | "Super Admin"       |  "0"      |
    | "Super Admin"       |  "1"      |
    | "Super Admin"       |  "2"      |
    | "Back Office Admin" |  "0"      |
    | "Back Office Admin" |  "1"      |
    | "Back Office Admin" |  "2"      |
    | "Front Office"      |  "0"      |
    | "Front Office"      |  "1"      |
    | "Front Office"      |  "2"      |
      
    #good
  @transaction
	Scenario Outline: Make a Transaction
  	Given The <role> is logged into Portal 
    And The user requires <permission> approval for <service> and <subservice>
  	When The user submits a <service> transaction
    And The <service> transaction can be verified
    And The user can logout
  
  @ex-PaymentFC  
  Examples: 
    | role      | service   | subservice                  | permission  | message     |
    | "Trader"  | "Payment" | "Foreign Currency Payment"  | "0"         | "success"   |
    | "Trader"  | "Payment" | "Foreign Currency Payment"  | "1"         | "approval"  |
    | "Trader"  | "Payment" | "Foreign Currency Payment"  | "2"         | "approval"  |

    