trigger PurchaseOrderTrigger on Purchase_Order__c (before insert, before update) {
    for (Purchase_Order__c orderItem : Trigger.new) {
        if (orderItem.Total_Price__c < 500) {
            orderItem.Discount__c = 0;
        }
        else if (orderItem.Total_Price__c >= 500 && orderItem.Total_Price__c <= 1500) {
            orderItem.Discount__c = 10;
        }
        else {
            orderItem.Discount__c = 15;
        }
        
        orderItem.Grand_Total__c = orderItem.Total_Price__c - (orderItem.Total_Price__c * orderItem.Discount__c / 100);
    }
}