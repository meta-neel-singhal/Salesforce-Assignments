/*
Create 2 new Fields of type Lookup in Opportunity named ( BillToContact(Contact) and Manager(Account).
Create a function in Class which called on Update of Opportunities (from Trigger), it take List<Oppty> as argument
and in function check BillToContact Field if it is not Blank and Manager is Blank then
populate Manager Field by related account which is linked with the contact given in BillToContact field.
*/
public class RelatedAccount {
    public void setRelatedAccounts(List<Opportunity> oppty) {
        //Integer count = 0;
        for (Opportunity o : oppty) {
            if (o.Bill_To_Contact__c != null && o.Manager__c == null) {
                o.Manager__c = [SELECT AccountId FROM Contact WHERE Id = :o.Bill_To_Contact__c LIMIT 1].AccountId;
                //count++;
            }
        }
       // return count;
    }
}