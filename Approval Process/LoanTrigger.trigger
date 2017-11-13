//On Insert of Loan record populate the field of Manager(Loan field) according to CityManager Object (On before insert trigger for it).

trigger LoanTrigger on Loan__c (before insert) {
    Map<String, City_Manager__c> cityManagerMap = new Map<String, City_Manager__c>();
    
    for (City_Manager__c cityManagerObject : [SELECT City__c, Manager__c FROM City_Manager__c]) {
        cityManagerMap.put(cityManagerObject.City__c, cityManagerObject);
    }
    
    for (Loan__c loan : Trigger.new) {
        loan.Manager__c = cityManagerMap.get(loan.City__c).Manager__c;
    } 
}