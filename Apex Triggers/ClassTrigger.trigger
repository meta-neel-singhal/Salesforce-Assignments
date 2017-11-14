//Not allow delete to class if there are more then one Female students.
trigger ClassTrigger on Class__c (before delete) {
    
    List<AggregateResult> femalesInClass = [SELECT COUNT(Id) total, Class__c FROM Student__C WHERE (Sex__c = 'Female' AND Class__c IN :Trigger.Old) GROUP BY Class__c];
    
    Map<ID, Integer> classMap = new Map<ID, Integer>();
    for (AggregateResult result : femalesInClass) {
        classMap.put((Id)result.get('Class__c'), (Integer)result.get('total'));
    }
    
    for (Class__c classObject : Trigger.old) {
        if (classMap.containsKey(classObject.Id) && classMap.get(classObject.Id) > 1) {
            classObject.addError('Can\'t delete class since more than 2 females are present!!!');
        }
    }
}