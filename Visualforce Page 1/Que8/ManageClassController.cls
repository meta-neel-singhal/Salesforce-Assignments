public class ManageClassController {
    
    public String ClassID {get; set;}
    public List<Class__c> Classes;
    public Class__c SelectedClass;
    public boolean ShowEdit {get; set;}
    
    public ManageClassController() {
        ShowEdit = false;
        setClasses();
    }
    
    public void setClasses() {
        ShowEdit = false;
        Classes = (List<Class__c>) [SELECT Id, Name, Fee__c, Board__c, Max_Size__c, Class_Teacher__c FROM Class__c];
    }
    
    public Class__c getSelectedClass() {
        return SelectedClass;
    }
    
    public void setSelectedClass() {
        ShowEdit = true;
        SelectedClass = (Class__c) [SELECT Id, Name, Fee__c, Board__c, Max_Size__c, Class_Teacher__c FROM Class__c WHERE ID = :ClassID];
    }
    
    public List<Class__c> getClasses() {
        return Classes;
    }
    
    public void saveChanges() {
        update SelectedClass;
        setClasses();        
    }
    
    public void deleteSelectedClass() {
        SelectedClass = (Class__c) [SELECT Id, Name, Fee__c, Board__c, Max_Size__c, Class_Teacher__c FROM Class__c WHERE ID = :ClassID];
        delete SelectedClass;
        
        setClasses();
    }
}