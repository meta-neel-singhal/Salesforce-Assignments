@isTest
private class TestEmailService {
   @isTest
    static void testEmailServiceForValidAttachment() {
        // Create a new email and envelope object.
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Setup the data for the email.
        email.subject = 'Test Job Applicant';
        email.fromname = 'Neel Singhal';
        envelope.fromAddress = 'neelkumar.singhal@metacube.com';
        
        // Add an attachment.
        Messaging.InboundEmail.TextAttachment attachment = new Messaging.InboundEmail.TextAttachment();
        attachment.body = '<?xml version="1.0" encoding="UTF-8"?>'
                        + '<Contacts>'
                            + '<Contact>'
                                + '<Lastname>Singhal</Lastname>'
                                + '<FirstName>Priya</FirstName>'
                                + '<Subjects__c>English</Subjects__c>'
                                + '<Level__c>Secondary</Level__c>'
                                + '<Title>First Teacher</Title>'
                            + '</Contact>'
                            + '<Contact>'
                                + '<Lastname>Singhal</Lastname>'
                                + '<FirstName>Sunil</FirstName>'
                                + '<Subjects__c>Science</Subjects__c>'
                                + '<Level__c>Tertiary</Level__c>'
                                + '<Title>Second Teacher</Title>'
                            + '</Contact>'
                        + '</Contacts>';
        attachment.fileName = 'textfile.xml';
        attachment.mimeTypeSubType = 'text/xml';
        
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachment };
            
        // Call the email service class.
        EmailServiceToInsertContactRecords emailProcess = new EmailServiceToInsertContactRecords();
        emailProcess.handleInboundEmail(email, envelope);
        
        // Test the inserted data.
        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(2, contacts.size(), 'Size of contacts list must be 2.');
    }
    
    @isTest
    static void testEmailServiceForInvalidAttachment() {
        // Create a new email and envelope object.
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        // Setup the data for the email.
        email.subject = 'Test Job Applicant';
        email.fromname = 'Neel Singhal';
        envelope.fromAddress = 'neelkumar.singhal@metacube.com';
        
        // Add an attachment.
        Messaging.InboundEmail.TextAttachment attachment = new Messaging.InboundEmail.TextAttachment();

        attachment.body = '<?xml version="1.0" encoding="UTF-8"?>'
                        + '<Contacts>'
                            + '<Contact>'
                                + '<fname>Prakash</fname>'
                                + '<lname>Gyamlani</lname>'
                                + '……. (Atleast 5 fields)'
                            + '</Contact>'
                            + '<Contact>'
                                + '………….'
                            + '</Contact>'
            				+ '………………………………'
                        + '</Contacts>';
        attachment.fileName = 'textfile.xml';
        attachment.mimeTypeSubType = 'text/xml';
        
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachment };
            
        // Call the email service class and test the exception.
        EmailServiceToInsertContactRecords emailProcess = new EmailServiceToInsertContactRecords();
        emailProcess.handleInboundEmail(email, envelope);    
        
        // Test that no data is inserted.
        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(0, contacts.size(), 'Contacts list must be empty.');
    }
}