@istest
private class TestSavePDFController {
    @testSetup
    static void setup() {
        Class__c classObject = new Class__c(Name__c= 'Class X');
        insert classObject;
        
        insert (new Student__c(Name = 'Neel Singhal',
                               First_Name__c = 'Neel', 
                               Last_Name__c = 'Singhal', 
                               Email__c = 'neel.singhal@metacube.com', 
                               Sex__c = 'Male', 
                               Class__c = classObject.Id,
                               Married__c = false));
    }
    
    @isTest
    static void testSavePDFController() {
        Student__c student = [SELECT Id FROM Student__c];
        
        List<Attachment> attachments = [SELECT Name FROM Attachment WHERE ParentID = :student.Id];
        System.assertEquals(0, attachments.size(), 'Attachments should be empty.');
        
        Test.setCurrentPage(Page.NewStudentDetailsPage);
        ApexPages.currentPage().getParameters().put('id', student.Id);
        
        SavePDFController controllerInstance = new SavePDFController();
        controllerInstance.saveAttachment();
        attachments = [SELECT name FROM Attachment WHERE ParentID = :student.Id];
        System.assertEquals(1, attachments.size(), 'Attachments size should be 1.');
        
        //When Generate PDF link is clicked again.
        Test.setCurrentPage(Page.NewStudentDetailsPage);
        ApexPages.currentPage().getParameters().put('id', student.Id);
        
        controllerInstance.saveAttachment();
        attachments = [SELECT name FROM Attachment WHERE ParentID = :student.Id];
        System.assertEquals(1, attachments.size(), 'Attachments size should be 1.');
    }
}