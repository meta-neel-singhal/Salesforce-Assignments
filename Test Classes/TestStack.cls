@isTest
private class TestStack {
   static Stack StackObject = new Stack();
   
   @isTest
   static void testStack() {
       try {
           StackObject.pop();
       }
       catch(Exception e) {
           System.assert(e.getMessage().contains(Label.Stack_is_Empty), 'Exception must be thrown.');
       }
       try {
           StackObject.push(null);
       }
       catch(Exception e) {
           System.assert(e.getMessage().contains(Label.Provide_an_element), 'Exception must be thrown.');
       }
       System.assertEquals(0, StackObject.size(), 'Stack must be empty.');
       StackObject.push(5);
       StackObject.push(8);
       System.assertEquals(2, StackObject.size(), 'Stack size must be 2.');
       StackObject.pop();
       System.assertEquals(1, StackObject.size(), 'Stack size must be 1.');
   }
}