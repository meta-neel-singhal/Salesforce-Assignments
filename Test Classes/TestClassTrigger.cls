@isTest
private class TestClassTrigger {
    @isTest
    static void testClassIsNotDeleted() {
        Class__c classObject = new Class__c(Name__c = 'New Class', Max_Size__c = 10);
        insert classObject;
        
        List<Student__c> studentsList = new List<Student__c>();
        
        for (Integer count = 0; count < 5; count++) {
            studentsList.add(new Student__c(Last_Name__c = 'Test ' + count, Class__c = classObject.Id, Sex__c = 'Female'));
        }
        insert studentsList;
        
        try {
            delete classObject;
            System.assert(false, 'An exception should be thrown by above DML statement.');
        }
        catch (Exception e) {
            System.AssertEquals(true, e.getMessage().contains(Label.Cannot_delete_class), 'Trigger does not prevent class from getting deleted.');
        }
    }
}