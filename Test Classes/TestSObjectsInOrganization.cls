@isTest
private class TestSObjectsInOrganization {
    @isTest
    static void testCountOfSObjectsInOrg() {        
        Set<String> sObjectsSet = new Set<String>();
        sObjectsSet.addAll(SObjectsInOrganization.listOfSObjects());
        System.assert(sObjectsSet.contains('Account'), 'Account object is not present in the set.');
        System.assert(sObjectsSet.contains('Contact'), 'Contact object is not present in the set.');
        System.assert(sObjectsSet.contains('Lead'), 'Lead object is not present in the set.');
        System.assert(sObjectsSet.contains('Case'), 'Case object is not present in the set.');
    }
}