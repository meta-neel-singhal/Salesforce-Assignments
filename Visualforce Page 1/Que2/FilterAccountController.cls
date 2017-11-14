public class FilterAccountController {
    public String billingCity { get; set; }
    public String billingState { get; set; }
    public String billingCountry { get; set; }

    public List<Account> getFilterAccounts() {
        
        String whereClause = '';
        
        if(String.isBlank(billingCity)) {
            whereClause = 'WHERE BillingCity = \'' + this.billingCity+'\'';
        }
        if(String.isBlank(billingState)) {
            if(String.isBlank(whereClause)){
                whereClause += ' AND BillingState = \'' + this.billingState+'\'';
            }
            else {
                whereClause = 'WHERE BillingState = \'' + this.billingState+'\'';
            }
        }
        if(String.isBlank(billingCountry)) {
            if(String.isBlank(whereClause)){
                whereClause += ' AND BillingCountry = \'' + this.billingCountry+'\'';
            }
            else {
                whereClause = 'WHERE BillingCountry = \'' + this.billingCountry+'\'';
            }
        }
       
        List<Account> accountsList = Database.query('SELECT Name, BillingCity, BillingState, BillingCountry, AnnualRevenue ' +
                                                   	'FROM Account ' +
                                                     whereClause + 
                                                     'LIMIT 100'
        											);  
        return accountsList;
        
    }
    
    public PageReference search() {
        getFilterAccounts();
        return null;
    }
    
    public ApexPages.StandardSetController standardSetController {
        get {
            if(standardSetController == null) {
                standardSetController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name, BillingCity, BillingState, BillingCountry, AnnualRevenue
                        FROM Account
                        WHERE BillingCity=:this.BillingCity AND BillingState=:this.BillingState AND BillingCountry=:this.BillingCountry
                        LIMIT 100]));
                
                // Sets the number of records in each page set
                standardSetController.setPageSize(10);
            }
            return standardSetController;
        }
        set;
    }
    
    public void first() {
        this.standardSetController.first();
    }

    public void last() {
        this.standardSetController.last();        
    }

    public void previous() { 
        this.standardSetController.previous();
    }

    public void next() {
        this.standardSetController.next();
    }
    
    public Boolean hasNext {
        get { return standardSetController.getHasNext(); }
        set;
    }

    public Boolean hasPrevious {
        get { return standardSetController.getHasPrevious(); }
        set;
    }

    public Integer pageSize {
        get { return standardSetController.getPageSize(); }
        set;
    }

    Public Integer getTotalPages() {

        Decimal totalSize = this.standardSetController.getResultSize();
        Decimal pageSize = this.standardSetController.getPageSize();

        Decimal pages = totalSize/pageSize;

        return (Integer)pages.round(System.RoundingMode.CEILING);
    }

    public Integer pageNumber {
        get { return standardSetController.getPageNumber(); }
        set;
    }
}