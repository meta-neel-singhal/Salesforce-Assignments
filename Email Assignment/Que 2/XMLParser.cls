public class XMLParser {
    public XMLParser(String XMLString) {
        DOM.Document document = new DOM.Document();
        try {
            document.load(XMLString);
            DOM.XmlNode rootNode = document.getRootElement();
            List<Contact> contactsList = parseXMLToContact(rootNode);
            insert contactsList;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    public List<Contact> parseXMLToContact(DOM.XmlNode node) {
        List<Contact> contactsList = new List<Contact>();
        for (DOM.XmlNode child : node.getChildElements()) {
            Contact contact = new Contact();
            for (DOM.XmlNode children : child.getChildren()) {
                if (children.getName() != null) {
                    if (children.getName().equals('Lastname')) {
                        contact.LastName = children.getText().trim();
                    } else if (children.getName().equals('FirstName')) {
                        contact.FirstName = children.getText().trim();
                    } else if (children.getName().equals('Subjects__c')) {
                        contact.Subjects__c = children.getText().trim();
                    } else if (children.getName().equals('Level__c')) {
                        contact.Level__c = children.getText().trim();
                    } else if (children.getName().equals('Title')) {
                        contact.Title = children.getText().trim();
                    }
                }
            }
            contactsList.add(contact);
        }
        return contactsList;
    }
}