@isTest
private class TestStudentJSONController {
    @testSetup
    static void setup() {
        List<Class__c> classes = new List<Class__c>();
        for (Integer count = 0; count < 2; count++) {
            classes.add(new Class__c(Name__c = 'Class ' + count));
        }
        insert classes;
        
        List<Student__c> students = new List<Student__c>();
        for (Integer count = 0; count < 10; count++) {
            students.add(new Student__c(Last_Name__c = 'Student ' + count, 
                                        Class__c = classes[0].Id));
            students.add(new Student__c(Last_Name__c = 'Student ' + (count + 10), 
                                        Class__c = classes[1].Id));
        }
        insert students;
    }
    
    @isTest
    static void testJson() {
        PageReference pageReference = Page.StudentAsJSON;
        Test.setCurrentPage(pageReference);
        StudentJSONController controllerInstance = new StudentJSONController();
        List<String> actual = controllerInstance.getStudentsJSON();
        List<String> expected = new List<String>();
        for (Student__c student : [SELECT Name FROM Student__c]) {
            expected.add(JSON.serialize(student));
        }
        System.assert(expected == actual, 'JSON mismatched.');
    }
}