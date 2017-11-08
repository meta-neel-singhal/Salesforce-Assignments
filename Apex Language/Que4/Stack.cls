public class Stack {
    private List<Object> listOfObjects;
    
    public Stack() {
        listOfObjects = new List<Object>();
    }
    
    public void push(Object element) {
        if (element == null) {
            throw new StackException('Please provide an element!');
        }
        
        listOfObjects.add(element);
    }
    
    public Object pop() {
        if (size() == 0) {
            throw new StackException('Stack is Empty');
        }
        
        return listOfObjects.remove(size() - 1);
    }
    
    public Integer size() {
        return listOfObjects.size();   
    }
    
    class StackException extends Exception {
        
    }
}