trigger LoanTrigger on Loan__c (before insert, after update) {
    
    // On Insert of Loan record populate the field of Manager(Loan field) according to CityManager Object (On before insert trigger for it).
    if (Trigger.isBefore && Trigger.isInsert) {
        Set<String> cities = new Set<String>();
        Map<String, City_Manager__c> cityManagerMap = new Map<String, City_Manager__c>();
        
        for (Loan__c loan : Trigger.new) {
            cities.add(loan.City__c);
        }
        
        for (City_Manager__c cityManagerObject : [SELECT City__c, Manager__c FROM City_Manager__c WHERE City__c IN :cities]) {
            cityManagerMap.put(cityManagerObject.City__c, cityManagerObject);
        }
        
        for (Loan__c loan : Trigger.new) {
            if (cityManagerMap.get(loan.City__c) != null) {
                loan.Manager__c = cityManagerMap.get(loan.City__c).Manager__c;
            }
        }
    }
    
    // If Loan status changed , send mail to applicant, is it approved or reject. 
    if (Trigger.isAfter && Trigger.isUpdate) {
        for (Loan__c loan : Trigger.new) {
            if (loan.Status__c != null && loan.Status__c != Trigger.OldMap.get(loan.Id).Status__c) {
                List<String> parameters = new List<String>{loan.Name, loan.Status__c};
                EmailManager.sendMail(loan.Email__c, Label.Status_Changed, String.format(System.Label.Status_Email_Message, parameters));
            }
        }
    }
}