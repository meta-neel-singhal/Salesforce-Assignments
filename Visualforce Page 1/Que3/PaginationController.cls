public class PaginationController {
    
    public string billingCity {get; set;}
    public string billingState {get; set;}
    public string billingCountry {get; set;}
    public Integer size {get; set;}
    
    public ApexPages.StandardSetController controllerInstance{get; set;} 
    
    public void setSize(Integer value) {
        size = value;
    }
    
    public PaginationController() {
        results = new List<Account>();
    }
    
    public List<Account> results {
        get {  
            if(controllerInstance != null) {
                return (List<Account>)controllerInstance.getRecords();  
            } else  {
                return null;
            }
        }  
        set;
    }
    
    public void getAccounts() {
        String query = 'SELECT Name, BillingCity, BillingState, BillingCountry FROM Account';
        boolean flag = false;
        String filter = '';
       
        if(String.isBlank(BillingCity)) {
            filter += ' BillingCity LIKE \'%' + String.escapeSingleQuotes(billingCity) + '%\'';
            flag = true;
        }
        
        if(String.isBlank(BillingState)) {
            if(flag) {
                filter += ' AND ';
            }
            filter += ' BillingState LIKE \'%' + String.escapeSingleQuotes(billingState) + '%\'';
        }
        
        if(String.isBlank(BillingCountry)) {
            if(flag) {
                filter += ' AND ';
            }
            filter += ' BillingCountry LIKE \'%' + String.escapeSingleQuotes(billingCountry) + '%\'';
            flag = true;
        }
        
        if(filter.length() > 0) {
            query += ' WHERE ' + filter;
        }
        
        controllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(query)); 
        controllerInstance.setPageSize(size);
    }
    
    public Boolean hasNext {  
        get {  
            return controllerInstance.getHasNext();  
        }  
        set;  
    } 
    
    public Boolean hasPrevious {  
        get {  
            return controllerInstance.getHasPrevious();  
        }  
        set;  
    }  
    
    public Integer pageNumber {  
        get {  
            return controllerInstance.getPageNumber();  
        }  
        set;  
    } 
    
    public void previous() {  
        controllerInstance.previous();  
    }
    
    public void next() {  
        controllerInstance.next();  
    }
    
    public void first() {
        this.controllerInstance.first();
    }
    
    public void last() {
        this.controllerInstance.last();        
    }
}