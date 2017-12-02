@isTest
private class TestManageClassController {
    @testSetup
    static void setup() {
        List<Class__c> classes = new List<Class__c>();
        for (Integer count = 0; count < 10; count++) {
            classes.add(new Class__c(Name__c = 'Class ' + count));
        }
        insert classes;
    }
    
    @isTest
    static void testClasses() {
        PageReference pageReference = Page.ManageClass;
        Test.setCurrentPage(pageReference);
        ManageClassController controllerInstance = new ManageClassController();
        
        //Test that all the classes are displayed.
        List<Class__c> classes = controllerInstance.getClasses();
        System.assert(classes == [SELECT Id, Name FROM Class__c], 'Class list does not match.');
        
        // Test selected class.
        Class__c classObject = [SELECT Id FROM Class__c WHERE Name__c = 'Class 1'];
        controllerInstance.ClassID = classObject.Id;
        controllerInstance.setSelectedClass();
        Class__c selectedClass = controllerInstance.getSelectedClass();
        System.assert(selectedClass.Id == classObject.Id, 'Selected class does not match.');
        
        // Test save changes in selected class.
        selectedClass.Fee__c = 20000;
        controllerInstance.saveChanges();
        classObject = [SELECT Id, Fee__c FROM Class__c WHERE Name__c = 'Class 1'];
        System.assert(classObject.Fee__c == 20000, 'The class fee should be 20000.');
        
        // Test delete selected class.
        classes = [SELECT Id, Fee__c FROM Class__c];
        System.assert(classes.size() == 10, 'Size of Class list should be 10.');
        controllerInstance.deleteSelectedClass();
        classes = [SELECT Id, Fee__c FROM Class__c];
        System.assert(classes.size() == 9, 'Size of Class list should be 9.');
    }
}