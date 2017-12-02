@isTest
private class TestReportPageController {
    @testSetup
    static void setup() {
        List<Account> accountsList = new List<Account>();
        for (Integer count = 0; count < 10; count++) {
            accountsList.add(new Account(Name = 'Account ' + count));
        }
        insert accountsList;
        
        List<Opportunity> opportunityList = new List<Opportunity>();
        for (Integer count = 0; count < 10; count++) {
            for (Integer counter = 0; counter < 5; counter++) {
                opportunityList.add(new Opportunity(Name = 'Test ' + count,
                                                    CloseDate = System.today() + 90,
                                                    StageName = 'Prospecting',
                                                    Amount = 100 * (count + counter + 1),
                                                    AccountId = accountsList[count].Id
                                                   ));
            }
        }
        insert opportunityList;
    }
    
    @isTest
    static void testReport() {
        Test.setCurrentPage(Page.ReportPage);
        ReportPageController controllerInstance = new ReportPageController();
        List<AggregateResult> actual = controllerInstance.Results;
        System.assert(actual.size() == 10, 'The size of Aggregate Result list should be 10.');
    }
}