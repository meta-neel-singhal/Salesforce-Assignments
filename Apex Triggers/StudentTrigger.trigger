trigger StudentTrigger on Student__c (before insert, after insert, after update) {
    
    Set<Id> classIds = new Set<Id>();
    
    for (Student__c student : Trigger.new) {
        classIds.add(student.Class__c);
    }
    
    Map<Id, Class__c> classMap =  new Map<Id, Class__c>([SELECT Id, Max_Size__c, NumberOfStudents__c, My_Count__c FROM Class__c WHERE Id IN :classIds]);
    Set<Class__c> classesToUpdate = new Set<Class__c>();
    
    //Not allow insert student if class already reached MaxLimit.
    if (Trigger.isBefore && Trigger.isInsert) {
        for (Student__c student : Trigger.new) {
            Class__C classObject = classMap.get(student.Class__c);
            if (classObject.Max_Size__c != null && classObject.Max_Size__c <= classObject.NumberOfStudents__c) {
                student.addError('The class is already full!!!');
            }
        }
    }
    
    //When insert any student’s in class then update MyCount Accordingly.
    if (Trigger.isAfter && Trigger.isInsert) {
        for(Student__c student : Trigger.new) {
            Class__c classSelected = classMap.get(student.Class__c);
            if (classSelected.My_Count__c != null) {
                classSelected.My_Count__c += 1;
            } else {
                classSelected.My_Count__c = 1;
            }
            classesToUpdate.add(classSelected);
        }
    }
    
    //When update any student’s in class then update MyCount Accordingly.
    if (Trigger.isAfter && Trigger.isUpdate) {
        Set<Id> oldClassIds = new Set<Id>();
        for (Id studentId : Trigger.oldMap.keySet()) {
        	oldClassIds.add(Trigger.oldMap.get(studentId).Class__c);
        }
        Map<Id, Class__c> oldClassMap = new Map<Id, Class__c>([SELECT Id, Max_Size__c, NumberOfStudents__c, My_Count__c FROM Class__c WHERE Id IN :oldclassIds]);
        
        for(Student__c student : Trigger.new) {
            if(student.Class__c != Trigger.oldMap.get(student.Id).Class__c) {
                Class__c classSelected = classMap.get(student.Class__c);  
                classSelected.My_Count__c += 1;
                classesToUpdate.add(classSelected);
                classSelected = oldclassMap.get(Trigger.oldMap.get(student.Id).Class__c);
                classSelected.My_Count__c -= 1;
                classesToUpdate.add(classSelected);
            }
        }
    }
    
    update (new List<Class__c>(classesToUpdate));
}