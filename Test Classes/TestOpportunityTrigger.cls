@isTest
private class TestOpportunityTrigger {
    @testSetup
    static void setup() {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer count = 0; count < 5; count++) {
            Opportunity opportunity = new Opportunity(Name = 'Test ' + count,
                                                      CloseDate = System.today() + 90,
                                                      StageName = 'Prospecting',
                                                      Custom_status__c = 'New'
                                                     );
            opportunities.add(opportunity);
        }
        insert opportunities;
        
        Product2 product = new Product2(Name = 'New Product',
                                        isActive = true,
                                        Unit_Price__c = 100);
        insert product;
        
        PricebookEntry entry = new PricebookEntry(unitprice = 0.01,
                                                  Product2Id = product.Id,
                                                  Pricebook2Id = Test.getStandardPricebookId(),
                                                  isActive = true,
                                                  UseStandardPrice = false);
        insert entry;
        
        insert (new OpportunityLineItem (Quantity = 2,
                                         OpportunityId = opportunities[0].Id,
                                         UnitPrice = 0.01,
                                         PriceBookEntryId = entry.Id)
               );
    }
    
    @isTest
    static void testOpportunitiesCloseDate() {
        List<Opportunity> opportunities = [SELECT Name, StageName FROM Opportunity];
        List<Opportunity> opportunityToUpdate = new List<Opportunity>();
        for (Opportunity opportunity : opportunities) {
            opportunity.StageName = 'Closed Won';
            opportunityToUpdate.add(opportunity);
        }
        update opportunityToUpdate;
        for (Opportunity opportunity : [SELECT CloseDate FROM Opportunity]) {
            System.assertEquals(date.today(), opportunity.CloseDate, 'Close date should be today.');
        }
    }
    
    @isTest
    static void testOpportunityLineItem() {
        Opportunity opportunity = [SELECT Id, Custom_Status__c FROM Opportunity LIMIT 1];
        opportunity.Custom_Status__c = 'Reset';
        List<OpportunityLineItem> listItems = [SELECT OpportunityId FROM OpportunityLineItem WHERE OpportunityId = :opportunity.Id];
        System.assertEquals(1, listItems.size(), 'listItems size must be 1.');
        update opportunity;
        listItems = [SELECT OpportunityId FROM OpportunityLineItem WHERE OpportunityId = :opportunity.Id];
        System.assertEquals(0, listItems.size(), 'listItems must be empty.');
    }
}