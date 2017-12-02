@isTest
private class TestStudents {
    @testSetup
    static void setup() {
        List<Student__c> students = new List<Student__c>();
        Class__c classObject = new Class__c(Name = 'X', 
                                            Name__c = 'Class X');
        insert classObject;
        for(Integer count = 0; count < 5; count++) {
        	Student__c student = new Student__c(Name = 'Test ' + count,
                                          Last_Name__c = 'Test', 
                                          Class__c = classObject.Id); 
            students.add(student);
        }
        insert students;
    }
    
    @isTest
    static void testListOfStudents() {
        List<Student__c> expectedStudentsList = [SELECT Name FROM Student__c];
        List<String> actualStudentsList = Students.namesOfStudents([SELECT Id FROM Class__c LIMIT 1].Id);
        System.assertEquals(5, actualStudentsList.size(), 'Number of students must be 5.');
        
        
        for (Integer count = 0; count < 5; count++) {
            System.assertEquals(expectedStudentsList[count].Name, actualStudentsList[count], 'Name of students do not match.');
        }
    }
}