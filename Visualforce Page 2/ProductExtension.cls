public class ProductExtension {
    public String productIdToAdd {get; set;}
    public String productIdToDelete {get; set;}
    public Boolean display ;
    public ID recordId;
    public ApexPages.StandardController standardController {get; set;}
    public Map<Id, Purchase_Order_Line_Item__c> cartItems;
    public Map<Id, Product2> availableProducts;
    public List<Product2> availableProductsList {get; set;}
    List<Purchase_Order_Line_Item__c> presentCartItems;
    public List<Purchase_Order_Line_Item__c> itemsToDelete = new List<Purchase_Order_Line_Item__c>();
    
    public ApexPages.StandardSetController productSetController {
        get {
            if(productSetController == null) {
                availableProducts = new Map<Id, Product2>([SELECT Id, ProductCode, Name, Unit_Price__c FROM Product2]);
                availableProductsList = availableProducts.values();
                productSetController = new ApexPages.StandardSetController(availableProductsList);
                productSetController.setPageSize(5);
            }
            return productSetController;
        }
        set;
    }
    
    public boolean getDisplay() {
        if (ApexPages.currentPage().getParameters().get('id') == null) {
            display = false;
        } else {
            display = true;
        }
        return display;
    }
    
    public List<Product2> productsList {
        get {  
            if(productSetController != null) {
                return (List<Product2>)productSetController.getRecords();  
            } else  {
                return null;
            }
        }  
        set;
    }
    
    public ProductExtension(ApexPages.StandardController controller) {
        standardController = controller;
        recordId = standardController.getId();
        cartItems = new Map<Id, Purchase_Order_Line_Item__c>();
        presentCartItems = [SELECT Id, Name, Product__c, Quantity__c, Total_Price__c, Unit_Price__c
                            FROM Purchase_Order_Line_Item__c
                            WHERE Purchase_Order__c = :recordId];
        for (Purchase_Order_Line_Item__c item : presentCartItems) {
            cartItems.put(item.Product__c, item);
        }
    }
    
    public Boolean hasNext {  
        get { return productSetController.getHasNext(); }  
        set;  
    }  
    public Boolean hasPrevious {  
        get { return productSetController.getHasPrevious(); }  
        set;  
    }  
    public Integer pageNumber {  
        get { return productSetController.getPageNumber(); }  
        set;  
    }  
    public void previous() {  
        productSetController.previous();  
    }  
    public void next() {  
        productSetController.next();  
    } 
    
    public Integer ResultSize {  
        get { return productSetController.getResultSize(); }  
        set;  
    }  
    
    public Integer PageSize {  
        get { return productSetController.getPageSize(); }  
        set;  
    }
    
    public List<Purchase_Order_Line_Item__c> cartItemsList {
        get { return cartItems.values(); }
        set;
    }
    
    public void addProduct() {      
        Product2 product = availableProducts.get(productIdToAdd);
        Purchase_Order_Line_Item__c lineItem = new Purchase_Order_Line_Item__c(Product__c = product.Id, 
                                                                               Purchase_Order__c = recordId,
                                                                               Total_Price__c = product.Unit_Price__c,
                                                                               Quantity__c = 1,
                                                                               Unit_Price__c = product.Unit_Price__c);
        cartItems.put(product.Id, lineItem);
        for (Integer count = 0; count < availableProductsList.size(); count++) {
            if (availableProductsList.get(count).Id == productIdToAdd) {
                availableProductsList.remove(count);
            }
        }
        
        productSetController = new ApexPages.StandardSetController(availableProductsList);
        productSetController.setPageSize(5);
    }
    
    public void deleteProduct() {
        cartItems.remove(productIdToDelete);
        availableProductsList.add(availableProducts.get(productIdToDelete));
        
        productSetController = new ApexPages.StandardSetController(availableProductsList);
        productSetController.setPageSize(5);
    }
    
    public PageReference saveChanges() {
        standardController.save();
        delete itemsToDelete;
        upsert cartItems.values();
        PageReference orderPage;
        
        if (ApexPages.currentPage().getParameters().get('id') != null) {
            orderPage = new PageReference('https://ap5.salesforce.com/' + recordId);
        } else {
            orderPage = new PageReference('https://ap5.salesforce.com/a05/o');
        }
        
        orderPage.setRedirect(true);
        return orderPage;
    }
}