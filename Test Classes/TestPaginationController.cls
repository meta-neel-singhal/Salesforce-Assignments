@isTest
private class TestPaginationController {
	@testSetup
    static void setup() {
        List<Account> accountsList = new List<Account>();
        
        for(Integer count = 0; count < 20; count++){
            accountsList.add(new Account(Name = 'Test ' + count, 
                                         BillingCity = 'Jaipur', 
                                         BillingState = 'Rajasthan', 
                                         BillingCountry = 'India',
                                         AnnualRevenue = 1000 * (count + 1)));
        }
        insert accountsList;
    }
    
    @isTest
    static void testFilterAccounts() {
        PageReference pageReference = Page.AccountsPagination;
        Test.setCurrentPage(pageReference);
        PaginationController controllerInstance = new PaginationController();
                
        //Before Search        
        System.assertEquals(null, controllerInstance.Results, 'The controllerInstance is not null.');
        
        //After Search (with Billing City)
       	controllerInstance.BillingCity = 'Jai';
        controllerInstance.getAccounts();
        
        List<Account> expected = [SELECT Id FROM Account];
        List<Account> actual = controllerInstance.Results;
        
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'Account IDs does not match.');
        }
        
        //After Search (with Billing State)
       	controllerInstance.BillingState = 'tha';
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'Account IDs does not match.');
        }
        
        //After Search (with Billing Country)
       	controllerInstance.BillingCountry = 'ndi';
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'Account IDs does not match.');
        }
        
        //After Search (with Billing City, Billing State and Billing Country)
        controllerInstance.BillingCity = 'Jaipur';
        controllerInstance.BillingState = 'Raja';
       	controllerInstance.BillingCountry = 'Dia';
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'Account IDs does not match.');
        }
        
        // Test data for next page.
        controllerInstance.next();
        actual = controllerInstance.Results;
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count + 5].Id == actual[count].Id, 'Account IDs does not match.');
        }
        System.assert(controllerInstance.PageNumber == 2, 'Page number should be 2.');
        
        // Test data for last page.
        controllerInstance.last();
        actual = controllerInstance.Results;
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count + 15].Id == actual[count].Id, 'Account IDs does not match.');
        }
        System.assert(controllerInstance.HasNext == false, 'Next page should not be there.');
        System.assert(controllerInstance.HasPrevious == true, 'Previous page should be there.');
        System.assert(controllerInstance.PageNumber == 4, 'Page number should be 4.');

        // Test data for previous page.
		controllerInstance.previous();
        actual = controllerInstance.Results;
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count + 10].Id == actual[count].Id, 'Account IDs does not match.');
        }
        System.assert(controllerInstance.PageNumber == 3, 'Page number should be 3.');

        // Test data for first page.
		controllerInstance.first();
        actual = controllerInstance.Results;
        for (Integer count = 0; count < 5 ; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'Account IDs does not match.');
        }
        System.assert(controllerInstance.HasNext == true, 'Next page should be there.');
        System.assert(controllerInstance.HasPrevious == false, 'Previous page should not be there.');
        System.assert(controllerInstance.PageNumber == 1, 'Page number should be 1.');
       
        // Test data for Page Size = 10.
        controllerInstance.Size = 10;
        controllerInstance.getAccounts();
        actual = controllerInstance.Results;
        for (Integer count = 0; count < 10 ; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'Account IDs does not match.');
        }
        
        // Test data for Page Size = 15.
        controllerInstance.Size = 15;
        controllerInstance.getAccounts();
        actual = controllerInstance.Results;
        for (Integer count = 0; count < 15 ; count++) {
            System.assert(actual[count].Id == expected[count].Id, 'Account IDs does not match.');
        }
        
        //After Search (with unavailable Billing City, Billing State and Billing Country)
        controllerInstance.BillingCity = 'Udai';
        controllerInstance.BillingState = 'Haryana';
       	controllerInstance.BillingCountry = 'Chin';
        
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        System.assert(actual.size() == 0, 'Result size should be 0.');
        
        //After Search (with available Billing City but unavailable Billing State and Billing Country)
       	controllerInstance.BillingCity = 'Pur';
        controllerInstance.BillingState = 'Harya';
       	controllerInstance.BillingCountry = 'Chin';
        
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        System.assert(actual.size() == 0, 'Result size should be 0.');
        
        //After Search (with available Billing State but unavailable Billing City and Billing Country)
       	controllerInstance.BillingCity = 'Pur';
        controllerInstance.BillingState = 'Than';
       	controllerInstance.BillingCountry = 'Chin';
        
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        System.assert(actual.size() == 0, 'Result size should be 0.');
        
        //After Search (with available Billing Country but unavailable Billing City and Billing State)
       	controllerInstance.BillingCity = 'Pur';
        controllerInstance.BillingState = 'Harya';
       	controllerInstance.BillingCountry = 'Ind';
        
        controllerInstance.getAccounts();
        
        actual = controllerInstance.Results;
        System.assert(actual.size() == 0, 'Result size should be 0.');
    }
}