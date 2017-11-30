public class StudentsSiteHomePageController {
    public Id StudentId {get; set;}
    public Student__c Student {get; set;}
    public Boolean Display {get; set;}
    public Map<Id, Student__c> StudentsMap;
    
    public StudentsSiteHomePageController() {
        StudentsMap = new Map<Id, Student__c> ([SELECT Id, Name, First_Name__c, Last_Name__c,  DOB__c, Sex__c, Class__c, Married__c
                                                FROM Student__c]);
    }
    
    public List<Student__c> getStudentNames() {
        return StudentsMap.values();
    }
    
    public void getStudentDetails() {
        Display = true;
        Student = StudentsMap.get(StudentId);
    }
}    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*public List<Student__c> StudentsList {get; set;}
public Integer Size {get; set;}
public Student__c selectStudent {get; set;}
public Boolean Display {get; set;}

public StudentsSiteHomePageController() {
Display = false;
StudentsList = new List<Student__c>();
}

public List<SelectOption> Students {
get {
if(Students == null) {
StudentsList = [SELECT Name, DOB__c, Sex__c, Married__c FROM Student__c];
Students = new List<SelectOption>();
for(Student__c student : StudentsList) {
Students.add(new SelectOption(student.Id, student.Name));
}
}
Size = Students.size();
return Students;
}
set;
}

public  void getStudentDetails() {
if (selectStudent != null) {
System.assert(false, '--'+selectStudent);
Display = true;
system.debug(selectStudent);
selectStudent = [SELECT Name, DOB__c, Sex__c, Married__c FROM Student__c WHERE Id = :selectStudent.Id];
}
}*/