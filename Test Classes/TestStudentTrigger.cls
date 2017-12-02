@isTest
private class TestStudentTrigger {
    @testSetup
    static void setup() {
        List<Student__c> students = new List<Student__c>();
        Class__c classObject = new Class__c(Name = 'XI', Name__c = 'Class XI', Max_Size__c = 10);
        insert classObject;
        Class__c anotherClass = new Class__c(Name = 'XII', Name__c = 'Class XII', Max_Size__c = 10);
        insert anotherClass;
        for (Integer count = 0; count < 10; count++) {
            Student__c student = new Student__c(Name = 'Test ' + count, Last_Name__c = 'Test', Class__c = classObject.Id);
            students.add(student);
        }
        insert students;
    }	
    
    @isTest
    static void testInsertWhenClassIsFull() {
        Class__c classObject = [SELECT Id FROM Class__c WHERE Name = 'XI'];
        Student__c student = new Student__c(Name = 'Test 11', Last_Name__c = 'Test', Class__c = classObject.Id);
        try {
            insert student;
            System.assert(false, 'An exception should be thrown by above DML statement.');
        } catch (Exception e) {
			System.AssertEquals(true, e.getMessage().contains(Label.Class_already_full), 'Trigger does not prevent student to get inserted into class when it is full.');
        }
    }
    
    @isTest
    static void testMyCountOnInsert() {
        Class__c classObject = [SELECT Id, My_Count__c FROM Class__c WHERE Name = 'XI'];
        System.assert(classObject.My_Count__c == 10, 'My Count of the classObject should be 10.');
    }
    
    @isTest
    static void testMyCountOnUpdate() {
        Class__c anotherClass = [SELECT Id, My_Count__c FROM Class__c WHERE Name = 'XII'];
        List<Student__c> studentsList = new List<Student__c>();
        for (Student__c student : [SELECT Name, Class__c FROM Student__c LIMIT 5]) {
            student.Class__c = anotherClass.Id;
            studentsList.add(student);
        }
        update studentsList;
        Class__c classObject = [SELECT Id, My_Count__c FROM Class__c WHERE Name = 'XI'];
        anotherClass = [SELECT Id, My_Count__c FROM Class__c WHERE Name = 'XII'];
        System.assert(classObject.My_Count__c == 5, 'My Count of classObject should be 5.');
        System.assert(anotherClass.My_Count__c == 5, 'My Count of anotherClass should be 5.');
    }
}