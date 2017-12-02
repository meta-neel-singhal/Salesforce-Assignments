@isTest
private class TestLoanTrigger {
    
    @testSetup
    static void setup() {
        List<City_Manager__c> cityManagers = new List<City_Manager__c>();
        List<Loan__c> loans = new List<Loan__c>();
        List<User> user = [SELECT Id FROM User LIMIT 5];
        
        for (Integer count = 0; count < 5; count++) {
            City_Manager__c cityManagerObject = new City_Manager__c(Name = 'CM' + count,
                                                                    City__c = 'City ' + count,
                                                                    Manager__c = user[count].Id);
            cityManagers.add(cityManagerObject);
        }
        insert cityManagers;
        
        for (Integer count = 0; count < 5; count++) {
            Loan__c loanObject = new Loan__c(Name = 'Loan' + count,
                                             City__c = 'City ' + count,
                                             Email__c = 'neelkumar.singhal@metacube.com');
            loans.add(loanObject);
        }
        insert loans;
    }
    
    @isTest
    static void testInsertion() {
        List<Loan__c> loans = new List<Loan__c>([SELECT Id, Name, City__c, Manager__c FROM Loan__c]);
        List<User> user = [SELECT Id FROM User LIMIT 5];
        for (Integer count = 0; count < 5; count++) {
            System.assert(loans[count].Manager__c == user[count].Id, 'Manager does not match the required user.');
        }
    }
    
    @isTest
    static void testUpdate() {
        Loan__c loan = [SELECT Id, Name, Status__c, Email__c FROM Loan__c LIMIT 1];
        loan.Status__c = 'Approved';
        update loan;
    }
}