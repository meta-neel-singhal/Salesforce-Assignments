@isTest
private class TestCustomLookupController {
    @testSetup
    static void setup() {
        Account account = new Account(Name = 'Demo');
        insert account;
        
        List<Contact> contactsList = new List<Contact>();
        
        for (Integer count = 0; count < 10; count++) {
            contactsList.add(new Contact(LastName = 'Contact ' + count, 
                                         AccountId = account.Id));
        }
        
        insert contactsList;
        
        Opportunity opportunity = new Opportunity(Name = 'Test', 
                                                  CloseDate = System.today() + 90,
                                                  StageName = 'Prospecting',
                                                  Manager__c = account.Id
                                                 );
        insert opportunity;
    }
    
    @isTest
    static void testCustomLookup() {
        PageReference pageReference = Page.CustomLookup;
        Test.setCurrentPage(pageReference);
        
        // Test when Id is null.        
        Opportunity opportunity = new Opportunity();
        ApexPages.currentPage().getParameters().put('id', opportunity.Id);        
        CustomLookupController controllerInstance = new CustomLookupController();
        
        System.assert(Opportunity.Id == null, 'Opportunity should be null');
        
        List<Apexpages.Message> messages = ApexPages.getMessages();
        for(Apexpages.Message message : messages){
            System.assert(message.getDetail().contains(Label.No_record_found), 'PageMessages are not displayed.');
        }
        
        // Test when Id is not valid.        
        ApexPages.currentPage().getParameters().put('id', 'asdassddassdd');
        controllerInstance = new CustomLookupController();
        
        messages = ApexPages.getMessages();
        for(Apexpages.Message message : messages){
            System.assert(message.getDetail().contains(Label.No_record_found), 'PageMessages are not displayed.');
        }
        
        // Test when Id is valid.        
        opportunity = [SELECT Id, Name FROM Opportunity];
        ApexPages.currentPage().getParameters().put('id', opportunity.Id);
        controllerInstance = new CustomLookupController();
        
        List<SelectOption> options = controllerInstance.getContacts();
        
        for (Integer count = 0; count < 10; count++) {
            System.assertEquals('Contact ' + count, options[count].getLabel(), 'Contact Name does not match.');
        }
        
        // Select a option
        controllerInstance.ContactId = options[0].getValue();
        
        // Testing Save, Cancel and Clear buttons.
        controllerInstance.save();
        opportunity = [SELECT Id, Bill_To_Contact__c, Name FROM Opportunity];
        System.assertEquals(options[0].getValue(), opportunity.Bill_To_Contact__c, 'Bill To Contact is not saved correctly.');
        
        controllerInstance.cancel();
        
        controllerInstance.clear();
        opportunity = [SELECT Id, Bill_To_Contact__c, Name FROM Opportunity];
        System.assertEquals(null, opportunity.Bill_To_Contact__c, 'Bill To Contact is not cleared.');
    }
}