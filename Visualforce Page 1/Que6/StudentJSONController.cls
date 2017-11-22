public class StudentJSONController {
	public List<Student__c> Students;
    
    public StudentJSONController() {
        Students = [SELECT Name FROM Student__c];
    }
    
    public List<String> getStudentsJSON() {
        List<String> studentList = new List<String>();
        
        for (Student__c student : Students) {
            studentList.add(JSON.serialize(student));
        }
        
        return studentList;
    }
}