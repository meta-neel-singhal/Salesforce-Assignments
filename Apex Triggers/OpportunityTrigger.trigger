trigger OpportunityTrigger on Opportunity (before update, after update) {
    
    // Invoke the setRelatedAccounts function to update Manager according to the Bill_To_Contact__c.
    if (Trigger.isBefore && Trigger.isUpdate) {
        RelatedAccount relatedAccountObject = new RelatedAccount();
        relatedAccountObject.setRelatedAccounts(Trigger.new);
    }
    
    // If the stage is changed from another value  to CLOSED_WON or CLOSED_LOST, populates the Close Date field with Today().
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Opportunity> opportunities = [SELECT Id, StageName, CloseDate FROM Opportunity WHERE Id IN :Trigger.new];
        List<Opportunity> opportunityToUpdate =  new List<Opportunity>();
        for (Opportunity opportunity : opportunities) {
            if(opportunity.stageName != Trigger.oldMap.get(opportunity.id).StageName) {
                if(opportunity.StageName.equalsIgnoreCase('Closed Won') || opportunity.StageName.equalsIgnoreCase('Closed Lost')) {
                    opportunity.CloseDate = Date.today();
                    opportunityToUpdate.add(opportunity);
                } 
            }
        }
        update opportunityToUpdate;
    }
    
    /*
    Create a new PickList  “Custom Status” in Opportunity object.(New,Open,Close,Reset) values.
    When this field changed and value is “Reset” now then delete all associated  products(opp. Lines) with related Opportunity.
    */
    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Opportunity> opportunities = new Set<Opportunity>();
        for (Opportunity opportunity : Trigger.new) {
            if (opportunity.Custom_Status__c != null && opportunity.Custom_Status__c.equalsIgnoreCase('Reset') && opportunity.Custom_Status__c != Trigger.OldMap.get(opportunity.Id).Custom_Status__c) {
                opportunities.add(opportunity);
            }
            
            if (opportunities.size() > 0) {
                DELETE [SELECT Id FROM OpportunityLineItem WHERE OpportunityId IN :opportunities];
            }    
        }
    }
    
}