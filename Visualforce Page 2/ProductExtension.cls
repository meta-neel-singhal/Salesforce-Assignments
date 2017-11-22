public class ProductExtension {
    public String ProductIdToAdd {get; set;}
    public String ProductIdToDelete {get; set;}
    public Boolean Display ;
    public Id RecordId;
    public Integer Size = 5;
    public String id = 'id';
    public ApexPages.StandardController StandardController {get; set;}
    public Map<Id, Purchase_Order_Line_Item__c> CartItems;
    public Map<Id, Product2> AvailableProducts;
    public List<Product2> AvailableProductsList {get; set;}
    List<Purchase_Order_Line_Item__c> PresentCartItems;
    public List<Purchase_Order_Line_Item__c> ItemsToDelete = new List<Purchase_Order_Line_Item__c>();
    
    public ApexPages.StandardSetController ProductSetController {
        get {
            if(ProductSetController == null) {
                AvailableProducts = new Map<Id, Product2>([SELECT Id, ProductCode, Name, Unit_Price__c FROM Product2]);
                AvailableProductsList = AvailableProducts.values();
                ProductSetController = new ApexPages.StandardSetController(AvailableProductsList);
                ProductSetController.setPageSize(Size);
            }
            return ProductSetController;
        }
        set;
    }
    
    public List<Product2> ProductsList {
        get {  
            if(ProductSetController != null) {
                return (List<Product2>)ProductSetController.getRecords();  
            } else  {
                return null;
            }
        }  
        set;
    }
    
    public Boolean HasNext {  
        get { return ProductSetController.getHasNext(); }  
        set;  
    } 
    
    public Boolean HasPrevious {  
        get { return ProductSetController.getHasPrevious(); }  
        set;  
    }  
    
    public Integer PageNumber {  
        get { return ProductSetController.getPageNumber(); }  
        set;  
    }
    
    public Integer ResultSize {  
        get { return ProductSetController.getResultSize(); }  
        set;  
    }  
    
    public Integer PageSize {  
        get { return ProductSetController.getPageSize(); }  
        set;  
    }
    
    public List<Purchase_Order_Line_Item__c> CartItemsList {
        get { return CartItems.values(); }
        set;
    }
              
    public boolean getDisplay() {
        if (ApexPages.currentPage().getParameters().get(id) == null) {
            Display = false;
        } else {
            Display = true;
        }
        return Display;
    }
      
    public ProductExtension(ApexPages.StandardController controller) {
        StandardController = controller;
        RecordId = StandardController.getId();
        CartItems = new Map<Id, Purchase_Order_Line_Item__c>();
        PresentCartItems = [SELECT Id, Name, Product__c, Quantity__c, Total_Price__c, Unit_Price__c
                            FROM Purchase_Order_Line_Item__c
                            WHERE Purchase_Order__c = :RecordId];
        for (Purchase_Order_Line_Item__c item : PresentCartItems) {
            CartItems.put(item.Product__c, item);
        }
    }
    
    public void previous() {  
        ProductSetController.previous();  
    }  
    
    public void next() {  
        ProductSetController.next();  
    } 
    
    public void addProduct() {      
        Product2 product = AvailableProducts.get(ProductIdToAdd);
        Purchase_Order_Line_Item__c lineItem = new Purchase_Order_Line_Item__c(Product__c = product.Id, 
                                                                               Purchase_Order__c = RecordId,
                                                                               Total_Price__c = product.Unit_Price__c,
                                                                               Quantity__c = 1,
                                                                               Unit_Price__c = product.Unit_Price__c);
        CartItems.put(product.Id, lineItem);
        for (Integer count = 0; count < AvailableProductsList.size(); count++) {
            if (AvailableProductsList.get(count).Id == ProductIdToAdd) {
                AvailableProductsList.remove(count);
            }
        }
        
        ProductSetController = new ApexPages.StandardSetController(AvailableProductsList);
        ProductSetController.setPageSize(Size);
    }
    
    public void deleteProduct() {
        CartItems.remove(ProductIdToDelete);
        AvailableProductsList.add(AvailableProducts.get(ProductIdToDelete));
        
        ProductSetController = new ApexPages.StandardSetController(AvailableProductsList);
        ProductSetController.setPageSize(Size);
    }
    
    public PageReference saveChanges() {
        StandardController.save();
        delete ItemsToDelete;
        upsert CartItems.values();
        PageReference orderPage;
        
        if (ApexPages.currentPage().getParameters().get(id) != null) {
            orderPage = new PageReference('https://ap5.salesforce.com/' + RecordId);
        } else {
            orderPage = new PageReference('https://ap5.salesforce.com/a05/o');
        }
        
        orderPage.setRedirect(true);
        return orderPage;
    }
}