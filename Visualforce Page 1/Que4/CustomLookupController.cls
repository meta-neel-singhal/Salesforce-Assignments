public class CustomLookupController {
    
    private final Opportunity OpportunityObject;
    public Id ContactId {get; set;}
    public Boolean HasError {get; set;}
    
    public CustomLookupController() {
        try {
            HasError = false;
            OpportunityObject = [SELECT Id, Name, Bill_To_Contact__c, Manager__c FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
            ContactId = OpportunityObject.Bill_To_Contact__c;
        } catch (Exception e) {
            HasError = true;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, System.Label.no_record_found));
        }
    }
    
    public List<SelectOption> getContacts() {
        List<SelectOption> options = new List<SelectOption>();
        List<Contact> contacts = (List<Contact>)[SELECT Id, Name, Subjects__c FROM Contact WHERE AccountId = :OpportunityObject.Manager__c];
        for(Contact contact : contacts) {
            options.add(new SelectOption(contact.Id, contact.Name));
        }
        return options;
    }
    
    public PageReference clear() {
        OpportunityObject.Bill_To_Contact__c = null;
        update OpportunityObject;
        
        PageReference redirectPage = new ApexPages.StandardController(OpportunityObject).view();
        return redirectPage;
    }
    
    public PageReference save() {
        OpportunityObject.Bill_To_Contact__c = ContactId;
        update OpportunityObject;
        
        PageReference redirectPage = new ApexPages.StandardController(OpportunityObject).view();
        return redirectPage; 
    }
    
    public PageReference cancel() {
        PageReference redirectPage = new ApexPages.StandardController(OpportunityObject).view();
        return redirectPage;
    }  
}