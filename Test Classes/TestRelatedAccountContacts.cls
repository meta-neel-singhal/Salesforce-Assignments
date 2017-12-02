@isTest
private class TestRelatedAccountContacts {
    @testSetup
    static void setup() {
        Account account= new Account(Name='New Account');
        insert account;
        List<Contact> contactList = new List<Contact>();
        
        for (Integer count = 0; count < 5; count++) {
            contactList.add(new Contact(LastName = 'Test ' + count,
                                        AccountId = account.Id));
        }
        
        insert contactList;
    }
    
    @isTest
    static void testWhenContactIdsIsNull() {
        Account account = [SELECT Id, Contact_Ids__c FROM Account];
        
        List<Contact> contactList = [SELECT Id FROM Contact];
        String expected = '';
        
        for(Contact contact : contactList){
            expected += contact.Id + ',';   
        }
        expected = expected.substring(0, expected.length() - 1);
        
        System.assertEquals(null, account.Contact_Ids__c, 'The Contact IDs field should be null initially.');
        
        RelatedAccountContacts.setContactIdsInAccount(contactList.get(0).Id);
        
        account =  [SELECT Id, Contact_Ids__c FROM Account];
        System.assertEquals(expected, account.Contact_Ids__c, 'The Contact IDs field does not match the expected value.'); 
        
        account.Contact_Ids__c = expected;
        update account;
        
        Contact contact = new Contact(LastName = 'Test 5',
                                      AccountId = account.Id);
        insert contact;
        
        expected += ',' + contact.Id;
        
        RelatedAccountContacts.setContactIdsInAccount(contact.Id);
        
        account =  [SELECT Id, Contact_Ids__c FROM Account];
        System.assertEquals(expected, account.Contact_Ids__c, 'The Contact IDs field does not match the expected value.');
    }
}