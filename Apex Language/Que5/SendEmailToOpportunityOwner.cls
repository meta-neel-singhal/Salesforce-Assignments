//Create a Scheduler to mail to Opportunity Owner , if not modified for last 30 days.
public class SendEmailToOpportunityOwner implements Database.Batchable<Opportunity> {

    public Iterable<Opportunity> start(Database.BatchableContext context) {
        return [SELECT Id, OwnerId FROM Opportunity where LastModifiedDate = LAST_N_DAYS:30];
    }

    public void execute(Database.BatchableContext context, List<Opportunity> scope) {
        for(Opportunity s : scope) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {s.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Opportunity not modified');
            mail.setPlainTextBody('The opportunity is not modified for last 30 days!!!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }

    public void finish(Database.BatchableContext context) {
    }
}