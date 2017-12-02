@isTest
private class TestFilterAccountController {
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
        PageReference pageReference = Page.FilterAccountList;
        Test.setCurrentPage(pageReference);
        FilterAccountController controllerInstance = new FilterAccountController();
        
        controllerInstance.BillingCity = 'Jaipur';
        
        //Before Search        
        System.assertEquals(null, controllerInstance.getFilterAccounts(), 'The controllerInstance is not null.');
        
        //After Search (with Billing City)
        controllerInstance.search();
        List<Account> result = controllerInstance.getFilterAccounts();
        for (Integer count = 0; count < 20 ; count++) {
            System.assertEquals('Test ' + count, result[count].Name, 'Account name does not match.');
        }
        
        controllerInstance.BillingCity = null;
        controllerInstance.BillingState = 'Rajasthan';
       
        //After Search (with Billing State)
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        for (Integer count = 0; count < 20 ; count++) {
            System.assertEquals('Test ' + count, result[count].Name, 'Account name does not match.');
        }
        
        controllerInstance.BillingState = '';
        controllerInstance.BillingCountry = 'India';
        
        //After Search (with Billing Country)
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        for (Integer count = 0; count < 20 ; count++) {
            System.assertEquals('Test ' + count, result[count].Name, 'Account name does not match.');
        }
        
        insert (new Account(Name = 'Test 20', 
                            BillingCity = 'Udaipur', 
                            BillingState = 'Rajasthan', 
                            BillingCountry = 'India',
                            AnnualRevenue = 21000));
        
        controllerInstance.BillingCity = 'Udaipur';
        controllerInstance.BillingState = 'Rajasthan';
        controllerInstance.BillingCountry = 'India';
        
        //After Search (with Billing City, Billing State and Billing Country)
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        System.assertEquals('Test 20', result[0].Name, 'Account name does not match.');
        System.assertEquals(1, result.size(), 'Result should have only 1 account.');
        
        //After Search (with unavailable Billing City, Billing State and Billing Country)
        controllerInstance.BillingCity = 'Raipur';
        controllerInstance.BillingState = 'Goa';
        controllerInstance.BillingCountry = 'China';
        
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        System.assertEquals(0, result.size(), 'Result should be empty.');
        
        //After Search (with available Billing City but unavailable Billing State and Billing Country)
        controllerInstance.BillingCity = 'Jaipur';
        controllerInstance.BillingState = 'Goa';
        controllerInstance.BillingCountry = 'China';
        
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        System.assertEquals(0, result.size(), 'Result should be empty.');
        
        //After Search (with available Billing State but unavailable Billing City and Billing Country)
        controllerInstance.BillingCity = 'Raipur';
        controllerInstance.BillingState = 'Rajastan';
        controllerInstance.BillingCountry = 'China';
        
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        System.assertEquals(0, result.size(), 'Result should be empty.');
        
        //After Search (with available Billing Country but unavailable Billing State and Billing City)
        controllerInstance.BillingCity = 'Raipur';
        controllerInstance.BillingState = 'Goa';
        controllerInstance.BillingCountry = 'India';
        
        controllerInstance.search();
        result = controllerInstance.getFilterAccounts();
        System.assertEquals(0, result.size(), 'Result should be empty.');
    }
}