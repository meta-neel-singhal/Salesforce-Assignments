@isTest
private class TestAddStudentController {
	@testSetup
    static void setup() {
        Class__c classObject = new Class__c(Name__c = 'Classs X');
        insert classObject;
    }
    
    @isTest
    static void testInsert() {
        Test.setCurrentPage(Page.AddStudent);
        AddStudentController controllerInstance = new AddStudentController();
        
        Class__c classObject = [SELECT Id FROM Class__c LIMIT 1];
        controllerInstance.recordId = classObject.Id;
        controllerInstance.studentName = 'Mahendra Baahubali';
        controllerInstance.add();
        
        Student__c student = [SELECT Id, Name, Last_Name__c, Class__c FROM Student__c WHERE Class__c = :classObject.Id];
        
        System.assert(student != null, 'Student object should not be null.');
        System.assert(student.Name == 'Mahendra Baahubali', 'Student Name should be Mahendra Baahubali.');
        System.assert(student.Last_Name__c == 'Baahubali', 'Student Last Name should be Baahubali.');
    }
}