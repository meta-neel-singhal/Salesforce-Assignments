public class StudentJSONController {
	public List<Student__c> students;
    
    public StudentJSONController() {
        students = [SELECT Name FROM Student__c];
    }
    
    public List<String> getStudentsJSON() {
        List<String> studentList = new List<String>();
        
        for (Student__c student : students) {
            studentList.add(JSON.serialize(student));
        }
        
        return studentList;
    }
}