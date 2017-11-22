public class FilterAccountController {
    public String BillingCity {get; set;}
    public String BillingState {get; set;}
    public String BillingCountry {get; set;}
    List<Account> AccountsList;
    
    public void search() {
        String whereClause = '';
        
        if(String.isNotBlank(BillingCity)) {
            whereClause = 'WHERE BillingCity = \'' + this.BillingCity+'\'';
        }
        if(String.isNotBlank(BillingState)) {
            if(String.isNotBlank(whereClause)){
                whereClause += ' AND BillingState = \'' + this.BillingState+'\'';
            }
            else {
                whereClause = 'WHERE BillingState = \'' + this.BillingState+'\'';
            }
        }
        if(String.isNotBlank(BillingCountry)) {
            if(String.isNotBlank(whereClause)){
                whereClause += ' AND BillingCountry = \'' + this.BillingCountry+'\'';
            }
            else {
                whereClause = 'WHERE BillingCountry = \'' + this.BillingCountry+'\'';
            }
        }
        
        AccountsList = Database.query('SELECT Name, BillingCity, BillingState, BillingCountry, AnnualRevenue ' +
                                      'FROM Account ' +
                                      whereClause + 
                                      'LIMIT 100'
                                     );  
    }
    
    public List<Account> getFilterAccounts() {
        return AccountsList;
    }
}