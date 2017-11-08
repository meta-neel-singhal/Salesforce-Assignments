/*
 * Create 2 new Fields of type Lookup in Opportunity named ( BillToContact(Contact) and Manager(Account).
 * Create a function in Class which called on Update of Opportunities (from Trigger), it take List<Oppty> as argument
 * and in function check BillToContact Field if it is not Blank and Manager is Blank then
 * populate Manager Field by related account which is linked with the contact given in BillToContact field.
 */
public class RelatedAccount {
    public void setRelatedAccounts(List<Opportunity> opportunities) {
        
        Map<Id, Id> accountsMap = new Map<Id, Id>();
        
        Set<Id> contactIds = new Set<Id>();
        
        for (Opportunity opportunity : opportunities) {
            contactIds.add(opportunity.Bill_To_Contact__c);
        }
        
        for (Contact contact : [SELECT AccountId FROM Contact WHERE Id IN :contactIds]) {
            accountsMap.put(contact.Id, contact.AccountId);
        }
        
        for (Opportunity opportunity : opportunities) {
            if (opportunity.Bill_To_Contact__c != null && opportunity.Manager__c == null) {
                opportunity.Manager__c = accountsMap.get(opportunity.Bill_To_Contact__c);
            }
        }
    }
}