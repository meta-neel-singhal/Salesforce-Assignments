public class AddStudentController {
    public String StudentName {get; set;}
    public Id RecordId;
    public Student__c Student;
        
    public AddStudentController() {
        RecordId = ApexPages.currentPage().getParameters().get('id');
    }
    
    public void add() {
        String lastName = StudentName.substring(StudentName.lastIndexOf(' ') + 1);
        Student = new Student__c(Name = StudentName, Last_Name__c = lastName, Class__c = RecordId);
        insert Student;
    }
}