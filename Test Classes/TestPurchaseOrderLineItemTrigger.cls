@isTest
private class TestPurchaseOrderLineItemTrigger {
    @testSetup
    static void setup() {
        List<Purchase_Order_Line_Item__c> lineItems = new List<Purchase_Order_Line_Item__c>();
        
        Purchase_Order__c order = new Purchase_Order__c();
        insert order;
        
        for(Integer count = 0; count < 5; count++) {
            Purchase_Order_Line_Item__c item = new Purchase_Order_Line_Item__c(Purchase_Order__c = order.Id,
                                                                               Quantity__c = 2,
                                                                               Unit_Price__c = 100 + count);
            lineItems.add(item);
        }
        
        insert lineItems;
    }
    
    @isTest
    static void testItemInsert() {
        List<Purchase_Order_Line_Item__c> lineItems = [SELECT Total_Price__c FROM Purchase_Order_Line_Item__c];
        
        for(Integer count = 0; count < 5; count++) {
            System.assert(lineItems[count].Total_Price__c == (2 * (100 + count)), 'Total Price of list items does not match.');
        }
    }
    
    @isTest
    static void testItemUpdate() {
        List<Purchase_Order_Line_Item__c> lineItems = [SELECT Total_Price__c FROM Purchase_Order_Line_Item__c];
        
        for(Integer count = 0; count < 5; count++) {
            lineItems[count].Quantity__c = 4;
        }
        update lineItems;
        lineItems = [SELECT Total_Price__c FROM Purchase_Order_Line_Item__c];
        for(Integer count = 0; count < 5; count++) {
            System.assert(lineItems[count].Total_Price__c == (4 * (100 + count)), 'Total Price of list items does not match.');
        }
    }
}