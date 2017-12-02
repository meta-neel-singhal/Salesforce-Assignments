@isTest
private class TestDataTableController {
    @testSetup
    static void setup() {
        List<Loan__c> loans = new List<Loan__c>();
        
        for (Integer count = 0; count < 20; count++) {
            Loan__c loanObject = new Loan__c(Name = 'Loan' + count,
                                             City__c = 'City ' + count,
                                             Amount__c = 1000 * (count + 1),
                                             Email__c = 'neel' + count + '.singhal@metacube.com');
            loans.add(loanObject);
        }
        insert loans;
    }
    
    @isTest
    static void testComponentWithoutStandardSetController() {
        Test.setCurrentPage(Page.ComponentUsingPage);
        DataTableController controllerInstance = new DataTableController();
        
        controllerInstance.SObjectValue = 'Loan__c';
        
        List<Loan__c> actual = controllerInstance.RecordsList;
        System.assert(actual == null, 'controllerInstance should be null.');
    }
    
    @isTest
    static void testComponentWithStandardSetController() {
        Test.setCurrentPage(Page.ComponentUsingPage);
        DataTableController controllerInstance = new DataTableController();
        controllerInstance.ControllerInstance = new ApexPages.StandardSetController([SELECT ID, Name, City__c, Amount__c, Email__c 
                                                                                     FROM Loan__c]);
        
        controllerInstance.SObjectValue = 'Loan__c';
        
        List<Loan__c> actual = controllerInstance.RecordsList;
        List<Loan__c> expected = [SELECT Id, Name FROM Loan__c];

        for (Integer count = 0; count < 20; count++) {
            System.assert(expected[count].Id == actual[count].Id, 'The IDs of expected and actual Loan object do not match.');
        }
        
        // Test number of fields if no value is given for fieldsName attribute.
        controllerInstance.getFieldList();
        System.assert(controllerInstance.FieldNameList.size() == 1, 'Size of FieldNameList must be 1.');
        
        // Test number of fields if value is given for fieldsName attribute.
        controllerInstance.FieldNameList.clear();
        controllerInstance.Query = 'SELECT ';
        controllerInstance.FieldsValue = 'Name,City__c,Amount__c';
        controllerInstance.getFieldList();
        System.assert(controllerInstance.FieldNameList.size() == 3, 'Size of FieldNameList must be 3.');
        
        // Testing navigation.
        controllerInstance.setPageSize(5);
        controllerInstance.PageNumberToGo = 3;
        controllerInstance.setPageNumber();
        controllerInstance.next();
        System.assert(controllerInstance.pageNumber == 4, 'Page Number must be 4.');
        controllerInstance.previous();
        System.assert(controllerInstance.pageNumber == 3, 'Page Number must be 3.');
        System.assert(controllerInstance.ResultSize == 20, 'Result size must be 20.');
        
        // Test sorting (Ascending).
        System.assert(controllerInstance.getSortDirection().equals('ASC'), 'Sorting direction should be ASC initially.');
        controllerInstance.SortExp = 'Name';
        controllerInstance.sorting();
        System.assert(controllerInstance.getSortDirection().equals('ASC'), 'Sorting direction should be ASC on first sort.');

        // Test sorting (Descending).
        controllerInstance.sorting();
        System.assert(controllerInstance.getSortDirection().equals('DESC'), 'Sorting direction should be DESC on second sort.');
    }
    
    @isTest
    static void testPageMessage() {
        Test.setCurrentPage(Page.ComponentUsingPage);
        DataTableController controllerInstance = new DataTableController();
        controllerInstance.ControllerInstance = new ApexPages.StandardSetController([SELECT ID, Name, City__c, Amount__c, Email__c 
                                                                                     FROM Loan__c]);
        
        controllerInstance.SObjectValue = 'Loan';
        
        controllerInstance.getFieldList();
        List<Apexpages.Message> messages = ApexPages.getMessages();
        for(Apexpages.Message message : messages){
            System.assert(message.getDetail().contains(Label.Check_sObject_or_fields_value), 'Page message is not displayed properly.');
        }
        
        controllerInstance.SObjectValue = 'Loan__c';
        controllerInstance.FieldsValue = 'Name,City,Amount__c';
        controllerInstance.getFieldList();
        messages = ApexPages.getMessages();
        for(Apexpages.Message message : messages){
            System.assert(message.getDetail().contains(Label.Check_sObject_or_fields_value), 'Page message is not displayed properly.');
        }
    }
}