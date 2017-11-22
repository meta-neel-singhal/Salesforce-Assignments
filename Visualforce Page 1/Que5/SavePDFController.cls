public class SavePDFController {
    private static Student__c STUDENT;
    
    public SavePDFController() {
        STUDENT = [SELECT Id FROM Student__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }
    
    public PageReference saveAttachment() {
        List<Attachment> oldAttachment = [SELECT Id, Name FROM Attachment WHERE ParentId = :STUDENT.Id ];
        if (oldAttachment.size() > 0) {
            delete oldAttachment;
        }
        
        Attachment attachment = new Attachment(); 
        PageReference pdf = Page.NewStudentDetailsPage;
        
        Blob body;
        pdf.getParameters().put('id', student.Id);
        
        try {
            body = pdf.getContentAsPDF();
        } catch (VisualforceException e) {
            body = Blob.valueOf(System.Label.Error + e);
        }
        
        attachment.Body = body;
        attachment.Name = Datetime.now().format('yyyy-MM-dd HH:mm') + ' ' + 'DetailsPDF' + '.pdf';
        attachment.ParentId = student.Id;
        insert attachment;
        
        return pdf;
    }
}