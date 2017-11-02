//Create a class and a static function which take classid as argument and returns all names of the students in that class as a list.
public class Students {
    public static List<Student__c> namesOfStudents(ID classID) {
        List<Student__c> students = [SELECT Name FROM Student__c WHERE Class__c = :classID];
        return students;
    }
}