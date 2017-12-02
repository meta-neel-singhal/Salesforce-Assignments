@isTest
private class TestStudentSiteHomePage {
    @testSetup
    static void setup() {
        List<Student__c> students = new List<Student__c>();
        List<Class__c> classes = new List<Class__c>();
        
        for(Integer count = 0; count < 5; count++) {
            classes.add((new Class__c(Name = 'C' + count, 
                                      Name__c = 'Class ' + count)));
        }
        insert classes;
        
        for(Integer count = 0; count < 5; count++) {
            for(Integer counter = 0; counter < 5; counter++) {
                students.add(new Student__c(Name = 'Student ' + count + counter,
                                            First_Name__c = 'First ' + count + counter,
                                            Last_Name__c = 'Last ' + count + counter, 
                                            Sex__c = 'Male',
                                            Class__c = classes[count].Id,
                                            Married__c = true));
            }
        }
        insert students;
    }
    
    @isTest
    static void testHomePage() {
        Test.setCurrentPage(Page.StudentsSiteHomePage);
        StudentsSiteHomePageController controllerInstance = new StudentsSiteHomePageController();
        
        // Test the returned list of students.
        List<Student__c> actual = controllerInstance.getStudentNames();
        List<Student__c> expected = [SELECT Id, Name, First_Name__c, Last_Name__c,  DOB__c, Sex__c, Class__c, Married__c
                                     FROM Student__c];
        System.assert(expected == actual, 'Student Names list does not match the expected names list.');
        
        // Test the details of selected students.
        Student__c expectedStudent = [SELECT Id, Name, First_Name__c, Last_Name__c,  DOB__c, Sex__c, Class__c, Married__c
                              FROM Student__c
                              WHERE Name = 'Student 11'];
        controllerInstance.StudentId = expectedStudent.Id;
        controllerInstance.getStudentDetails();
        Student__c actualStudent = controllerInstance.Student;
        System.assert(expectedStudent == actualStudent, 'Student details does not match with expected student details.');
    }
}