/*
 * Create a class and a static function which take ContactID as argument. Create one Custom field in Account Object(ContactIDs),
 * it is comma separated of all related Contact IDs, check if it is Null or not:-
 * IF Null, then fetch all related Account Contacts and store IDs of all Contacts in it.
 * IF Not Null, then check Is Contact Id exist on this field, if not then append it on that field.
 */
public class RelatedAccountContacts {
    public static void setContactIdsInAccount(Id contactId) {
        
        List<Account> accountsList = [SELECT Id, Contact_Ids__c, (SELECT Id FROM Contacts)
                                      FROM Account
                                      WHERE ID IN (SELECT AccountId From Contact WHERE Contact.ID = :contactId)];
        List<Account> accountsToUpdate = new List<Account>();
        
        if (accountsList.size() != 0) {
            for (Account account : accountsList) {
                if (account.Contact_Ids__c == null) {
                    String contactIds = null; 
                    if (account.Contacts != null) {
                        for (Contact con : account.Contacts) {
                            if (contactIds == null) {
                                contactIds = con.Id ;
                            } else {
                                contactIds += ',' + con.Id;
                            }
                        }
                    }
                    account.Contact_Ids__c = contactIds;
                }
                else if(!account.Contact_Ids__c.contains(contactId)){
                    account.Contact_Ids__c += ',' + contactId;
                }
                accountsToUpdate.add(account);
            }
            update accountsToUpdate;
        }
    }
}