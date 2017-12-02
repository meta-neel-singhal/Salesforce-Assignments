@isTest
private class TestPurchaseOrderTrigger {
	@testSetup
    static void setup() {
        List<Purchase_Order_Line_Item__c> lineItems = new List<Purchase_Order_Line_Item__c>();
        
        Purchase_Order__c order = new Purchase_Order__c();
        insert order;
        
        for(Integer count = 0; count < 5; count++) {
            Purchase_Order_Line_Item__c item = new Purchase_Order_Line_Item__c(Purchase_Order__c = order.Id,
                                                                               Quantity__c = 4,
                                                                               Unit_Price__c = 100 + count);
            lineItems.add(item);
        }
        
        insert lineItems;
    }
    
    @isTest
    static void testForTotalPriceGreaterThan1500() {
        Purchase_Order__c order = [SELECT Total_Price__c, Discount__c, Grand_Total__c FROM Purchase_Order__c];
        system.assert(order.Total_Price__c == 2040, 'Total Price should be 2040.');
        system.assert(order.Discount__c == 15, 'Discount should be 15%.');
        system.assert(order.Grand_Total__c == 1734, 'Grand Total should be 1734.');
    }
    
    @isTest
    static void testForTotalPriceBetween500And1500() {
        List<Purchase_Order_Line_Item__c> lineItems = [SELECT Total_Price__c FROM Purchase_Order_Line_Item__c];
        
        for(Integer count = 0; count < 5; count++) {
            lineItems[count].Quantity__c = 2;
        }
        update lineItems;
        
        Purchase_Order__c order = [SELECT Total_Price__c, Discount__c, Grand_Total__c FROM Purchase_Order__c];
        system.assert(order.Total_Price__c == 1020, 'Total Price should be 1020.');
        system.assert(order.Discount__c == 10, 'Discount should be 10%.');
        system.assert(order.Grand_Total__c == 918, 'Grand Total should be 918.');
    }
    
    @isTest
    static void testForTotalPriceLessThan500() {
        List<Purchase_Order_Line_Item__c> lineItems = [SELECT Total_Price__c FROM Purchase_Order_Line_Item__c];
        delete lineItems;
        
        Purchase_Order__c order = [SELECT Total_Price__c, Discount__c, Grand_Total__c FROM Purchase_Order__c];
        system.assert(order.Total_Price__c == 0, 'Total Price should be 0.');
        system.assert(order.Discount__c == 0, 'Discount should be 0%.');
        system.assert(order.Grand_Total__c == 0, 'Grand Total should be 0.');
    }
}