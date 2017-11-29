global class EmailServiceToInsertContactRecords implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        Messaging.InboundEmail.TextAttachment[] attachments = email.textAttachments;
        String XMLData = '';
        
        if (attachments != null) {
            for(Messaging.InboundEmail.TextAttachment attachment : attachments){
                if(attachment.filename.endsWith('.xml')){ 
                    XMLData = attachment.body;
                }
            }
        }
        
        XMLParser contacts = new XMLParser(XMLData);
        result.success = true;
        return result;
    }
}