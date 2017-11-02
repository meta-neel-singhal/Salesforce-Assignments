public class ClassStudents {
	//Create a function which returns a map where key is class and value is set of studentid in it.
    
    public static Map<class__c, set<Id>> getStudentClassMap() {
        Map<class__c, set<Id>> classStudentmap = new Map<class__c, set<Id>>();
        for(class__c cl: [SELECT Name, (SELECT Id FROM Students__r) FROM Class__c]) {
            set<Id> idSet = new set<Id>();
            for(Student__c student : cl.students__r) {
                idSet.add(student.Id);
            }
            classStudentmap.put(cl, idSet);
        }
        System.debug(classStudentmap);
        return classStudentmap;
    }
    
    /*public static Map<Class__c, Set<Student__c>> classStudentsMap() {
        Map<Class__c, Set<Student__c>> studentsInClass = new Map<Class__c, Set<Student__c>>();
        //Set<Student__c> studentIds = new Set<Student__c>();
       
        for(Class__c c : [SELECT Id FROM Class__c]) {
            Set<Student__c> studentIds = new Set<Student__c>();
            studentIds.addAll( [SELECT Id FROM Student__c WHERE Class__r.Id = :c.Id] );
            System.debug(studentIds);
            studentsInClass.put(c, studentIds);
        }
        
        System.debug(studentsInClass);
        return studentsInClass;
    }*/
}