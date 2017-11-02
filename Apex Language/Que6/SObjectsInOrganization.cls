//Create a Class which show the list of sobjects exists in Organization
public class SObjectsInOrganization {
    public static Integer listOfSObjects() {
        Integer sObjectsCount = 0;
        List<String> sObjectsList = new List<String>();
        for ( Schema.SObjectType typ : Schema.getGlobalDescribe().values() ) {
            sObjectsList.add(String.valueOf(typ));
            sObjectsCount++;
        }
		System.debug('sObjects are: ' + JSON.serialize(sObjectsList));
        return sObjectsCount;
    }
}