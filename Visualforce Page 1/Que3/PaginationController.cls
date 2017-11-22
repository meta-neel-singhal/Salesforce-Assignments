public class PaginationController {
    
    public string BillingCity {get; set;}
    public string BillingState {get; set;}
    public string BillingCountry {get; set;}
    public Integer Size {get; set;}
    public Boolean Display {get; set;}
    
    public ApexPages.StandardSetController ControllerInstance {get; set;} 
    
    public PaginationController() {
        Results = new List<Account>();
        Display = false;
        Size = 5;
    }
    
    public List<Account> Results {
        get {  
            if(ControllerInstance != null) {
                return (List<Account>)ControllerInstance.getRecords();  
            } else  {
                return null;
            }
        }  
        set;
    }
    
    public void getAccounts() {
        Display = true;
        String query = 'SELECT Name, BillingCity, BillingState, BillingCountry FROM Account';
        boolean flag = false;
        String filter = '';
        
        if(String.isNotBlank(BillingCity)) {
            filter += ' BillingCity LIKE \'%' + String.escapeSingleQuotes(BillingCity) + '%\'';
            flag = true;
        }
        
        if(String.isNotBlank(BillingState)) {
            if(flag) {
                filter += ' AND ';
            }
            filter += ' BillingState LIKE \'%' + String.escapeSingleQuotes(BillingState) + '%\'';
        }
        
        if(String.isNotBlank(BillingCountry)) {
            if(flag) {
                filter += ' AND ';
            }
            filter += ' BillingCountry LIKE \'%' + String.escapeSingleQuotes(BillingCountry) + '%\'';
            flag = true;
        }
        
        if(filter.length() > 0) {
            query += ' WHERE ' + filter;
        }
        
        ControllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(query)); 
        ControllerInstance.setPageSize(Size);
    }
    
    public Boolean HasNext {  
        get {  
            return ControllerInstance.getHasNext();  
        }  
        set;  
    } 
    
    public Boolean HasPrevious {  
        get {  
            return ControllerInstance.getHasPrevious();  
        }  
        set;  
    }  
    
    public Integer PageNumber {  
        get {  
            return ControllerInstance.getPageNumber();  
        }  
        set;  
    } 
    
    public void previous() {  
        ControllerInstance.previous();  
    }
    
    public void next() {  
        ControllerInstance.next();  
    }
    
    public void first() {
        this.ControllerInstance.first();
    }
    
    public void last() {
        this.ControllerInstance.last();        
    }
}