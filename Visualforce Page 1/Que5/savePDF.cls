public class savePDF {
    
    private final Student__c student;
    
    public savePdf() {
        student = [SELECT Id FROM Student__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    }
    
    public PageReference saveAttachment() {
        List<Attachment> oldAttachment = [Select id, name from Attachment where parentId = :student.Id ];
        if (oldAttachment.size() > 0) {
            Delete oldAttachment;
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