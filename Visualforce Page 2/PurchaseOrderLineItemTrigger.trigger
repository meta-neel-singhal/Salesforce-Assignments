trigger PurchaseOrderLineItemTrigger on Purchase_Order_Line_Item__c (before insert, before update) {
    for (Purchase_Order_Line_Item__c item : Trigger.new) {
        if (item.Unit_Price__c != null) {
            item.Total_Price__c = item.Quantity__c * item.Unit_Price__c;
        }
    }
}