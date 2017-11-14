public class CustomLookupController {
    
    private final Opportunity opportunity;
    public Id contactId {get; set;}
    
    public CustomLookupController() {
        opportunity = [SELECT Id, Name, Bill_To_Contact__c, Manager__c FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        contactId = opportunity.Bill_To_Contact__c;
    }
    
    public List<SelectOption> getContacts() {
        List<Contact> contacts = (List<Contact>)[SELECT Id, Name, Subjects__c FROM Contact WHERE AccountId = :opportunity.Manager__c];
        List<SelectOption> options = new List<SelectOption>();
        
        for(Contact contact : contacts) {
            options.add(new SelectOption(contact.Id, contact.Name));
        }
        return options;
    }
    
    public PageReference clear() {
        opportunity.Bill_To_Contact__c = null;
        update opportunity;
        
        PageReference redirectPage = new ApexPages.StandardController(opportunity).view();
        return redirectPage;
    }
    
    public PageReference save() {
        opportunity.Bill_To_Contact__c = contactId;
        update opportunity;
        
        PageReference redirectPage = new ApexPages.StandardController(opportunity).view();
        return redirectPage; 
    }
    
    public PageReference cancel() {
        PageReference redirectPage = new ApexPages.StandardController(opportunity).view();
        return redirectPage;
    }  
}