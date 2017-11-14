//Create a function which returns a map where key is class and value is set of studentid in it.
public class ClassStudents {    
    public static Map<Class__c, Set<Id>> getStudentClassMap() {
        Map<Class__c, Set<Id>> classStudentmap = new Map<Class__c, Set<Id>>();
        for (Class__c classObject : [SELECT Name, (SELECT Id FROM Students__r) FROM Class__c]) {
            Set<Id> idSet = new Set<Id>();
            for(Student__c student : classObject.students__r) {
                idSet.add(student.Id);
            }
            classStudentmap.put(classObject, idSet);
        }
        return classStudentmap;
    }
}