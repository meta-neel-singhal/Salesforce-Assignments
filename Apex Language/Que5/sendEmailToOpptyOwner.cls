global class sendEmailToOpptyOwner implements Database.Batchable<Opportunity> {

    global Iterable<Opportunity> start(Database.BatchableContext bc) {
        return [SELECT Id, OwnerId FROM Opportunity where LastModifiedDate = LAST_N_DAYS:30];
    }
    
    /*global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, OwnerId FROM Opportunity where LastModifiedDate = LAST_N_DAYS:30');
    }*/

    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        for(Opportunity s : scope) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {s.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Opportunity not modified');
            mail.setPlainTextBody('The opportunity is not modified for last 30 days!!!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    global void finish(Database.BatchableContext bc) {
    }
}