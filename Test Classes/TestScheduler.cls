@isTest
private class TestScheduler {
    @isTest
    static void testschedule() {
        Test.StartTest();
        
        // Schedule the test job.
        String jobId = System.schedule('testScheduledBatchable', ScheduledBatchable.CRON_EXP, new ScheduledBatchable());
        
        // Get the information from the CronTrigger API object.
        CronTrigger cronTrigger = [SELECT Id, CronExpression, TimesTriggered,
                                   NextFireTime
                                   FROM CronTrigger WHERE id = :jobId];
        
        // Verify the CRON expressions are the same.
        System.assertEquals(ScheduledBatchable.CRON_EXP, cronTrigger.CronExpression, 'CRON Expressions does not match.');
        
        // Verify the job has not run.
        System.assertEquals(0, cronTrigger.TimesTriggered, 'cronTrigger is triggered earlier.');
        
        // Verify the next time the job will run.
        System.assertEquals('2017-11-30 00:00:00', String.valueOf(cronTrigger.NextFireTime), 'Next fire time of cronTrigger does not match.');
        
        SendEmailToOpportunityOwner sendEmail = new SendEmailToOpportunityOwner(); 
        Id batchId = Database.executeBatch(sendEmail);

        // Verify the batch executes successfully.
        System.assertNotEquals('000000000000000', batchId, 'Batch execution is not successful.');
            
        Test.stopTest();
    }
}