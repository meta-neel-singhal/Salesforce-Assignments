@isTest
private class TestRelatedAccount {
    @testSetup
    static void setup() {
        Account account = new Account(Name = 'Demo');
        insert account;
        insert (new Contact(LastName = 'Singhal', AccountId = account.Id));
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        for (Integer count = 0; count < 5; count++) {
            Opportunity opportunity = new Opportunity(Name = 'Test ' + count,
                                            CloseDate = System.today() + 90,
                                            StageName = 'Prospecting');
            opportunityList.add(opportunity);
        }
        insert opportunityList;
    }
    
    @isTest
    static void testNoOfRelatedAccounts() {
        List<Opportunity> opportunityList = [SELECT Id, Bill_To_Contact__c, Manager__c FROM Opportunity];
        List<Opportunity> opportunities = new List<Opportunity>();
        Contact contact = [SELECT Id FROM Contact WHERE LastName = 'Singhal' LIMIT 1];
        for (Opportunity opportunity : opportunityList) {
            opportunity.Bill_To_Contact__c = contact.Id;
            opportunities.add(opportunity);
        }
        update opportunities;
        List<Opportunity> opportunityList2 = [SELECT Id, Bill_To_Contact__c, Manager__c FROM Opportunity];
        Account account = [SELECT Id FROM Account Limit 1];
        for (Opportunity opportunity : opportunityList2) {
            System.assertEquals(account.Id, opportunity.Manager__c, 'The manager does not match the required Account.');
        }
    } 
}