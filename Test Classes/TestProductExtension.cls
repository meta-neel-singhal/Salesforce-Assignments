@isTest
private class TestProductExtension {
    @testSetup
    static void setup() {
        List<Product2> productsList = new List<Product2>();
        for (Integer count = 0; count < 20; count++) {
            productsList.add(new Product2(ProductCode = 'Prod' + count,
                                          Name = 'Product ' + count,
                                          Unit_Price__c= 50 + 10 * count));
        }
        insert productsList;
        
        Purchase_Order__c purchaseOrder = new Purchase_Order__c(Customer__c = [SELECT Id FROM User WHERE Name = 'Manager'].Id,
                                                                Purchase_Date__c = Date.today());
        insert purchaseOrder;
        
        Purchase_Order_Line_Item__c lineItem = new Purchase_Order_Line_Item__c(Purchase_Order__c = purchaseOrder.Id);
        insert lineItem;
    }
    
    @isTest
    static void testPurchaseOrder() {
        Test.setCurrentPage(Page.PurchaseOrderView);
        Purchase_Order__c purchaseOrder = [SELECT Id, Customer__c, Purchase_Date__c FROM Purchase_Order__c];
        ProductExtension extensionInstance = new ProductExtension(new ApexPages.StandardController(purchaseOrder));
		
        // Test list of available products.
        List<Product2> actualAvailableProducts = extensionInstance.ProductsList;
        List<Product2> expectedAvailableProducts = [SELECT Id, ProductCode, Name, Unit_Price__c FROM Product2 LIMIT 5];

        System.assert(expectedAvailableProducts == actualAvailableProducts, 'Actual Available Products does not match Expected Available Products.');
        
        // Test if the page is opened via 'New' button.
		System.assert(extensionInstance.getDisplay() == false, 'Display value should be false.');
        
        //Test returned PageReference if page was opened via 'New' button.
        String returnPage = extensionInstance.saveChanges().getUrl();
        System.assertEquals(returnPage, '/' + Purchase_Order__c.SObjectType.getDescribe().getKeyPrefix() + '/o', 'The PageReference is not returned correctly.');        
        
        // Inserting Id in the url to open as Edit mode.
        ApexPages.currentPage().getParameters().put('id', purchaseOrder.Id);

        // Test if the page is opened via 'Edit' button.
        System.assert(extensionInstance.getDisplay() == true, 'Display value should be true.');
        
        // Test PageNumber, HasNext and HasPrevious when on first page.
        System.assert(extensionInstance.HasNext == true, 'Next page should be present.');
        System.assert(extensionInstance.HasPrevious == false, 'Previous page should not be present.');
        System.assert(extensionInstance.PageNumber == 1, 'Page number should be 1.');
        
        // Next page.
        extensionInstance.next();
        
        // Test PageNumber, HasNext and HasPrevious when page is changed.
        System.assert(extensionInstance.HasNext == true, 'Next page should be present.');
        System.assert(extensionInstance.HasPrevious == true, 'Previous page should be present.');
        System.assert(extensionInstance.PageNumber == 2, 'Page number should be 2.');
        
        // Previous page.
        extensionInstance.previous();
        
        // Test ResultSize and PageSize.
        System.assert(extensionInstance.ResultSize == 20, 'Result Size should be 20.');
        System.assert(extensionInstance.PageSize == 5, 'Page Size should be 5.');
        
        // Test if the already present cart item is inserted in the cart list in 'Edit'.
        Purchase_Order_Line_Item__c lineItem = [SELECT Id FROM Purchase_Order_Line_Item__c WHERE Purchase_Order__c = :purchaseOrder.Id];
        List<Purchase_Order_Line_Item__c> cartItems = extensionInstance.CartItemsList;
       
        System.assert(cartItems.size() == 1, 'Cart Items list should have 1 item only.');
        System.assert(cartItems[0].Id == lineItem.Id, 'Cart item does not match with the List Item.');
       
        // Adding a item to cart and then testing the items available in CartItemsList and AvailableProductsList.
        System.assert(extensionInstance.AvailableProductsList.size() == 20, 'Size of availablle product list should be 20.');
        
        Product2 productToAdd = [SELECT Id FROM Product2 WHERE ProductCode = 'Prod2'];
        extensioninstance.ProductIdToAdd = productToAdd.Id;
        extensionInstance.addProduct();
        cartItems = extensionInstance.CartItemsList;
        
        System.assert(cartItems.size() == 2, 'Size of cart items list must be 2.');
        System.assert(cartItems[1].Product__c == productToAdd.Id, 'Expected product to add was not added to the cart.');
        System.assert(extensionInstance.AvailableProductsList.size() == 19, 'Size of availablle product list should be 19.');
        
        // Deleting a item to cart and then testing the items available in CartItemsList and AvailableProductsList.
        Product2 productToDelete = productToAdd;
        extensioninstance.ProductIdToDelete = productToDelete.Id;
        extensionInstance.deleteProduct();
        cartItems = extensionInstance.CartItemsList;
        
        System.assert(cartItems.size() == 1, 'Size of cart items list should be 1.');
        System.assert(cartItems[0].Id == lineItem.Id, 'Cart item does not match with the line item.');
        System.assert(extensionInstance.AvailableProductsList.size() == 20, 'Size of available product list should be 20.');
        System.assert(extensionInstance.AvailableProductsList[19].Id == productToDelete.Id, 'Expected product to delete was not deleted from the cart.');
        
        //Test returned PageReference if page was opened via 'Edit' button.
        returnPage = extensionInstance.saveChanges().getUrl();
        System.assertEquals(returnPage, '/' + purchaseOrder.Id, 'The PageReference is not returned correctly.');
    }
}