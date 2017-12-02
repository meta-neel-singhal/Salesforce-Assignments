@isTest
private class TestContactTrigger {
	@isTest
    static void testHindiTeacherInsert() {
        Contact contact = new Contact(LastName = 'Test 1', Subjects__c = 'Hindi;Maths');
        try {
            insert contact;
            System.assert(false, 'An exception should be thrown by above DML statement.');
        }
        catch (Exception e) {
			System.AssertEquals(true, e.getMessage().contains(Label.Hindi_teacher_is_not_allowed), 'Trigger does not prevent Hindi teacher to get inserted.');
        }
    }
    
    @isTest
    static void testHindiTeacherUpdate() {
        Contact contact = new Contact(LastName = 'Test 1', Subjects__c = 'English;Science;Maths');
        insert contact;
        contact.Subjects__c = 'Hindi';
        try {
            update contact;
            System.assert(false, 'An exception should be thrown by above DML statement.');
        }
        catch (Exception e) {
			System.AssertEquals(true, e.getMessage().contains(Label.Hindi_teacher_is_not_allowed), 'Trigger does not prevent Hindi teacher to get updated.');
        }
    }
    
    class MyException extends Exception {
        
    }
}