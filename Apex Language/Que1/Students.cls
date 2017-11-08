//Create a class and a static function which take classid as argument and returns all names of the students in that class as a list.
public class Students {
    public static List<String> namesOfStudents(Id classID) {
        List<String> studentsName = new List<String>();
        
        for (Student__c student : [SELECT Name FROM Student__c WHERE Class__c = :classID]) {
            studentsName.add(student.Name);
        }
        return studentsName;
    }
}