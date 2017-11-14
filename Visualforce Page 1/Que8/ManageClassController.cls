public class ManageClassController {
    
    public String classID { get; set; }
    public List<Class__c> classes;
    public Class__c selectedClass;
    public boolean showEdit { get; set; }
    
    public ManageClassController() {
        showEdit = false;
        setClasses();
    }
    
    public void setClasses() {
        showEdit = false;
        classes = (List<Class__c>) [SELECT Id, Name, Fee__c, Board__c, Max_Size__c, Class_Teacher__c FROM Class__c];
    }
    
    public Class__c getSelectedClass() {
        return selectedClass;
    }
    
    public void setSelectedClass() {
        showEdit = true;
        selectedClass = (Class__c) [SELECT Id, Name, Fee__c, Board__c, Max_Size__c, Class_Teacher__c FROM Class__c WHERE ID = :classID];
    }
    
    public List<Class__c> getClasses() {
        return classes;
    }
    
    public void saveChanges() {
        UPDATE selectedClass;
        setClasses();        
    }
    
    public void deleteSelectedClass() {
        
        selectedClass = (Class__c) [SELECT Id, Name, Fee__c, Board__c, Max_Size__c, Class_Teacher__c FROM Class__c WHERE ID = :classID];
        DELETE selectedClass;
        
        setClasses();
    }
}