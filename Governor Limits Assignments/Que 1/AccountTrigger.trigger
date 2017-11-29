trigger AccountTrigger on Account (after insert, after delete, after update) {
    Set<Id> accountIds = new Set<Id>();
    Set<Id> changedAccounts = new Set<Id>();
    Id parentId;
    List<Account> accountsToUpdate = new List<Account>();
    for (Account account : (Trigger.isDelete ? Trigger.old : Trigger.new)) {
        if (account.Parent_Account__c != null) {
            accountIds.add(account.Parent_Account__c);
        }
    }
    
    List<AggregateResult> results = [SELECT COUNT(Id) childCount, Parent_Account__c FROM Account WHERE Parent_Account__c IN :accountIds GROUP BY Parent_Account__c];
    
    // Update child counts for all accounts having childCount > 0.
    for (AggregateResult result : results) {
        parentId = (Id) result.get('Parent_Account__c');
        accountsToUpdate.add(new Account(Id = parentId,
                                         Child_Count__c = (Decimal) result.get('childCount')));
        changedAccounts.add(parentId);
    }
    
    // Get Id of all accounts having childCount = 0.
    accountIds.removeAll(changedAccounts);
    for (Id parent : accountIds) {
        accountsToUpdate.add(new Account(Id = parent,
                                         Child_Count__c = 0));
    }
    
    update accountsToUpdate;
    
}