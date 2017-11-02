/*
Create a class and a static function which take ContactID as argument. Create one Custom field in Account Object(ContactIDs),
it is comma separated of all related Contact IDs, check if it is Null or not:-
IF Null, then fetch all related Account Contacts and store IDs of all Contacts in it.
IF Not Null, then check Is Contact Id exist on this field, if not then append it on that field.
*/
public class RelatedAccountContacts {
	public static void setContactIdsInAccount(Id contactId) {
      
        Account acc = [SELECT Id, Contact_Ids__c, (SELECT Id FROM Contacts)
                       FROM Account
                       WHERE ID IN (SELECT AccountId From Contact WHERE Contact.ID = :contactId)];
        
        System.debug(acc.Contact_Ids__c);
        if (acc != null) {
            if (acc.Contact_Ids__c == null) {
                String contactIds = ''; 
                if (acc.Contacts != null) {
                    for (Contact con : acc.Contacts) {
                        contactIds = contactIds + con.Id + ',';
                    }
                }
                acc.Contact_Ids__c = contactIds;
            }
            else if(!acc.Contact_Ids__c.contains(contactId)){
                acc.Contact_Ids__c += contactId + ',';
            }
            update acc;
            System.debug(acc.Contact_Ids__c);
        }
   }
}