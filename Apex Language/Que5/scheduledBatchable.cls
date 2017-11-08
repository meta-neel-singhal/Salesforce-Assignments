global class ScheduledBatchable implements Schedulable {
   global void execute(SchedulableContext context) {
      SendEmailToOpportunityOwner sendEmail = new SendEmailToOpportunityOwner(); 
      Database.executeBatch(sendEmail);
   }
}