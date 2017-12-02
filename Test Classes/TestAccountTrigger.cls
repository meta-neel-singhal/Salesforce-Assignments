@isTest
private class TestAccountTrigger {
	@testSetup
    static void setup() {
        List<Account> accounts = new List<account>();
        for (Integer count = 0; count < 5; count++) {
            accounts.add(new Account(Name = 'Account ' + count));
        }
        insert accounts;
    }
    
    @isTest
    static void testChildCount() {
        List<Account> accounts = [SELECT Id, Child_Count__c FROM Account];
        for (Integer count = 0; count < 5; count++) {
            System.assert(accounts[count].Child_Count__c == 0, 'Child count is not 0.');
        }
        
        List<Account> accountsList = new List<Account>();
        for (Integer count = 0; count < 5; count++) {
            for (Integer counter = 0; counter < 3; counter++) {
                accountsList.add(new Account(Name = 'Demo ' + count + counter,
                                                 Parent_Account__c = accounts[count].Id));
            }
        }
        insert accountsList;
        
        // Test Child Count on insertion of Accounts.
        accounts = [SELECT Id, Child_Count__c FROM Account WHERE Name LIKE 'Account%'];
        System.assert(accounts.size() == 5, 'Child count is not 5.');
        for (Integer count = 0; count < 5; count++) {
            System.assert(accounts[count].Child_Count__c == 3, 'Child count is not 3.');
        }
        
        // Test Child Count on updation of Accounts.
        accountsList[0].Parent_Account__c = accounts[3].Id;
        update accountsList;
        accounts = [SELECT Id, Child_Count__c FROM Account WHERE Name LIKE 'Account%'];
        System.assert(accounts[0].Child_Count__c == 2, 'Child count is not 2.');
        System.assert(accounts[3].Child_Count__c == 4, 'Child count is not 4.');
        
        // Test Child Count on deletion of Accounts.
        accountsList = [SELECT Id FROM Account WHERE Name LIKE 'Demo%'];
        delete accountsList;
        accounts = [SELECT Id, Child_Count__c FROM Account WHERE Name LIKE 'Account%'];
        for (Integer count = 0; count < 5; count++) {
            System.assert(accounts[count].Child_Count__c == 0, 'Child count is not 0.');
        }
    }
}