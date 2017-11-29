public class DeleteStudentsExtension {
    public ApexPages.StandardSetController StandardController;
    public List<Student__c> SelectedStudents;
    public Boolean HasError {get; set;}
    
    public DeleteStudentsExtension(ApexPages.StandardSetController StandardController) {
        HasError = false;
        this.StandardController = StandardController;
        SelectedStudents = (List<Student__c>) StandardController.getSelected();
        try {
            if (SelectedStudents.size() == 0) {
                throw new NullValueException(System.Label.no_record_found);
            } 
        } catch (Exception e) {
            HasError = true;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    public PageReference deleteSelectedStudents() {
        delete SelectedStudents;
        return redirectToListView();
    }
    
    public PageReference redirectToListView() {
        Schema.DescribeSObjectResult result = Student__c.SObjectType.getDescribe(); 
        PageReference pageReference = new PageReference('/' + result.getKeyPrefix()); 
        pageReference.setRedirect(true); 
        return pageReference;
    }
    
    public class NullValueException extends Exception {
        
    }
}