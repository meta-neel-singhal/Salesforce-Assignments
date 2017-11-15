public class DataTableController {
    public String sObjectValue {get; set;}
    public List<String> fieldNameList {get; set;}
    public String fieldsValue {get; set;}
    public String query {get; set;}
    public Boolean display {get; set;}
    public Integer pageSize {get; set;}
    public Integer pageNumberToGo {get; set;}
    public String orderBy {get; set;}
    public Boolean flag;
    
    public ApexPages.StandardSetController controllerInstance {get; set;}
    
    public DataTableController() {
        display = false;
        recordsList = new List<sObject>();
        fieldNameList = new List<String>();
        query = 'SELECT ';
        pageSize = 5;
        flag = true;
    }
    
    public List<sObject> recordsList {
        get {
            if (controllerInstance != null) {
                return (List<sObject>)controllerInstance.getRecords();  
            }
            else  {
                return null;
            }
        }
        set;
    }
    
    public void getFieldList() {
        display = true;
        if(fieldNameList.size() == 0) {
            if (fieldsValue != null) {
                fieldsValue= fieldsValue.replaceAll('\\s+', '');
                fieldNameList = fieldsValue.split(',');
            } else {
                fieldNameList = new List<String>(Schema.getGlobalDescribe().get(sObjectValue).getDescribe().fields.getMap().keySet());
            }
            
            for (String fieldName : fieldNameList) {
                query += fieldName + ' ,';
            }
            query = query.substring(0, query.length() - 1);
            query += ' FROM ' + sObjectValue;
        }
        controllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(query)); 
        controllerInstance.setPageSize(pageSize);
    }
    
    public void setPageSize(Integer value) {
        pageSize = value;
    }
    
    public void setPageNumber() {
        controllerInstance.setPageNumber(pageNumberToGo);
    }
    
    public Integer pageNumber {
        get { return controllerInstance.getPageNumber(); }  
        set;  
    }
    
    public void previous() {
        controllerInstance.previous();  
    }
    
    public void next() {  
        controllerInstance.next();  
    }
    
    public Integer ResultSize {  
        get { return controllerInstance.getResultSize(); }  
        set;  
    }
    
    public void sorting() {
        String queryToSort;
        if(flag) {
            queryToSort = query + ' ORDER BY ' + orderBy;
        } else {
            queryToSort = query + ' ORDER BY ' + orderBy + ' DESC';
        }
        flag = !flag;
        controllerInstance = new ApexPages.StandardSetController(Database.getQueryLocator(queryToSort));
        controllerInstance.setPageSize(pageSize);
    }
}