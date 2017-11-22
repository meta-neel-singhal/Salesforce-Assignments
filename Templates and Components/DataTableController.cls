public class DataTableController {
    public String SObjectValue {get; set;}
    public List<String> FieldNameList {get; set;}
    public String FieldsValue {get; set;}
    public String Query {get; set;}
    public Boolean Display {get; set;}
    public Integer PageSize {get; set;}
    public Integer PageNumberToGo {get; set;}
    public Boolean Flag {get; set;}
    public String SortDirection = 'ASC';
    public String SortExp {get; set;}
    public String SortField;
    public Boolean HasError {get; set;}
    
    public String SortExpression {
        get {
            SortField = SortExp;
            return SortExp;
        }
        set;
    }
    
    public Integer PageNumber {
        get { return ControllerInstance.getPageNumber(); }  
        set;  
    }
    
    public Integer ResultSize {  
        get { return ControllerInstance.getResultSize(); }  
        set;  
    }
    
    public String getSortDirection() {
        // If no column is selected. 
        if (String.isBlank(SortExpression)) {
            SortDirection = 'ASC';
        }
        return SortDirection;
    }
    
    public ApexPages.StandardSetController ControllerInstance {get; set;}
    
    public List<sObject> RecordsList {
        get {
            if (ControllerInstance != null) {
                return (List<sObject>)ControllerInstance.getRecords();  
            } else  {
                return null;
            }
        }
        set;
    }
    
    public DataTableController() {
        Display = false;
        HasError = false;
        RecordsList = new List<sObject>();
        FieldNameList = new List<String>();
        Query = 'SELECT ';
        PageSize = 5;
        Flag = true;
    }
    
    public void getFieldList() {
        Display = true;
        if(FieldNameList.size() == 0) {
            if (FieldsValue != null) {
                FieldsValue= FieldsValue.replaceAll('\\s+', '');
                FieldNameList = FieldsValue.split(',');
            } else {
                FieldNameList = new List<String> {'Id'};
                    }
            
            for (String fieldName : FieldNameList) {
                Query += fieldName + ' ,';
            }
            Query = Query.substring(0, Query.length() - 1);
            Query += ' FROM ' + SObjectValue;
        }
        try {
            resetQuickGo();
            ControllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(Query)); 
            ControllerInstance.setPageSize(PageSize);
        } catch(Exception e) {
            HasError = true;
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR, Label.Check_sObject_or_fields_value));
        }
    }
    
    public void setPageSize(Integer value) {
        PageSize = value;
    }
    
    public void setPageNumber() {
        ControllerInstance.setPageNumber(PageNumberToGo);
    }
    
    public void previous() {
        resetQuickGo();
        ControllerInstance.previous();  
    }
    
    public void next() { 
        resetQuickGo();
        ControllerInstance.next();  
    }
    
    public void resetQuickGo() { 
        PageNumberToGo = null;
    }
    
    public void sorting() {
        if (SortField == SortExp) {
            SortDirection = ((SortDirection == 'ASC') ? 'DESC' : 'ASC');
        } else {
            SortDirection = 'ASC';
        }
        String sortFullExpression = SortExpression  + ' ' + SortDirection;
        String QueryToSort = Query + ' ORDER BY ' + sortFullExpression;
        resetQuickGo();
        system.debug(QueryToSort);
        ControllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(QueryToSort));
        ControllerInstance.setPageSize(PageSize);
    }
}