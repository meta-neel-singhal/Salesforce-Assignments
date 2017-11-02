global class scheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      sendEmailToOpptyOwner b = new sendEmailToOpptyOwner(); 
      database.executebatch(b);
   }
}