//Not Allow any teacher to insert/update if that teacher is teaching Hindi.
trigger ContactTrigger on Contact (before insert, before update) {
for (Contact contact : Trigger.new) {
        if(contact.Subjects__c != null && contact.Subjects__c.contains('Hindi')) {
            contact.addError('Hindi Teacher is not allowed to be inserted or updated!!!');
        }
    }
}