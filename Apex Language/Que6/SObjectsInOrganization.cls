//Create a Class which show the list of sobjects exists in Organization.
public class SObjectsInOrganization {
    public static Integer listOfSObjects() {
        List<String> sObjectsList = new List<String>();
        for (Schema.SObjectType sObjectType : Schema.getGlobalDescribe().values()) {
            sObjectsList.add(String.valueOf(sObjectType));
        }
		System.debug('sObjects are: ' + JSON.serialize(sObjectsList));
        return sObjectsList.size();
    }
}