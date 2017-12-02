@isTest
private class TestClassStudents {
    @isTest
    static void testClassStudentsMap() {
        List<Class__c> classes = new List<Class__c>();
        List<Student__c> students;
        Map<Id, List<Student__c>> classStudentMap = new Map<Id, List<Student__c>>();
        
        for(Integer count = 0; count < 5; count++) {
        	Class__c classObject = new Class__c(Name__c = 'Class ' + (count + 1), 
                                                Max_Size__c = 10);
            classes.add(classObject);
        }
        insert classes;
        system.debug(classes);
        for(Integer count = 0; count < 5; count++) {
            students = new List<Student__c>();
            for (Integer counter = 0; counter < 5; counter++) {
                Student__c student = new Student__c(Name = 'Test' + counter + 'Class' + count ,
                                                    Last_Name__c = 'Test', 
                                                    Class__c = classes[count].Id); 
                students.add(student);
            }
            insert students;
            classStudentMap.put(classes[count].Id, students);
        }
        
        Map<Class__c, Set<Id>> classStudentIdMap = ClassStudents.getStudentClassMap();
        Map<Id, Set<Id>> newClassStudentIdMap = new Map<Id, Set<Id>>();
        for (Class__c classObject : classStudentIdMap.keySet()) {
            newClassStudentIdMap.put(classObject.Id, classStudentIdMap.get(classObject));
        }
        
        Map<Id, Student__c> studentMap;
        for (Id classId : classStudentMap.keySet()) {
            studentMap = new Map<Id, Student__c>(classStudentMap.get(classId));
            System.assert(newClassStudentIdMap.get(classId).containsAll(studentMap.keySet()), 'Actual map values differ from the expected map values.');
            System.assert(newClassStudentIdMap.get(classId).size() == studentMap.keySet().size(), 'Actual map size should be equal to expected map size.');
        }
    }
}