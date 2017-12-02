@isTest
private class TestDeleteStudents {
    @testSetup
    static void setup() {
        Class__c classObject = new Class__c(Name__c = 'Class X');
        insert classObject;
        
        List<Student__c> students = new List<Student__c>();
        
        for (Integer count = 0; count < 10; count++) {
            students.add(new Student__c(Last_Name__c = 'Student ' + count,
                                        Class__c = classObject.Id));
        }
        
        insert students;
    }
    
    @isTest
    static void testPageMessage() {
        Test.setCurrentPage(Page.DeleteStudents);
        DeleteStudentsExtension extensionInstance = new DeleteStudentsExtension(new ApexPages.StandardSetController([SELECT Id, Last_Name__c, Class__c FROM Student__c]));
    
        List<Apexpages.Message> messages = ApexPages.getMessages();
        for(Apexpages.Message message : messages){
            System.assert(message.getDetail().contains(System.Label.no_record_found), 'Page message is not displayed properly.');
        }
    }
    
    @isTest
    static void testDeletion() {
        Test.setCurrentPage(Page.DeleteStudents);
        
        List<Student__c> students = [SELECT Id, Last_Name__c, Class__c FROM Student__c];
        
        ApexPages.StandardSetController standardSetController = new ApexPages.StandardSetController(students);
        standardSetController.setSelected(students);
        DeleteStudentsExtension extensionInstance = new DeleteStudentsExtension(standardSetController);

        // Test students list size before deletion.
        System.assert(students.size() == 10, 'Size of student list before deletion should be 10.');
        
        extensionInstance.deleteSelectedStudents();
        
        // Test students list size after deletion.
        students = [SELECT Id, Last_Name__c, Class__c FROM Student__c];
        System.assert(students.size() == 0, 'Size of student list after deletion should be 0.');
        
        // Test that list view is refreshed after deletion.
        String returnPage = extensionInstance.redirectToListView().getUrl();
        System.assertEquals(returnPage, '/' + Student__c.SObjectType.getDescribe().getKeyPrefix(), 'The page should redirect to the list view after deletion but it is not.');
    }
}