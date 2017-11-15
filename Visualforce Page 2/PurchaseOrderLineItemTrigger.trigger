trigger PurchaseOrderLineItemTrigger on Purchase_Order_Line_Item__c (before update) {
    
    Set<Id> listItemsId = new Set<Id>();
    for (Purchase_Order_Line_Item__c item : [SELECT Product__c FROM Purchase_Order_Line_Item__c WHERE Id IN :Trigger.new]) {
        listItemsId.add(item.Product__c);
    }
    
    Map<Id, Product2> productPriceMap = new Map<Id, Product2>([SELECT Name, Unit_Price__c FROM Product2 WHERE Id IN :listItemsId]);
    
    for (Purchase_Order_Line_Item__c item : Trigger.new) {
        item.Total_Price__c = item.Quantity__c * productPriceMap.get(item.Product__c).Unit_Price__c;
    }
}