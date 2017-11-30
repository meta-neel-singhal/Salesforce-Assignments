package main;

import com.sforce.soap.enterprise.Connector;
import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.Error;
import com.sforce.soap.enterprise.QueryResult;
import com.sforce.soap.enterprise.SaveResult;
import com.sforce.soap.enterprise.sobject.Contact;
import com.sforce.soap.enterprise.sobject.Student__c;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

public class Main {
	static final String USERNAME = "neel.singhal@metacube.com";
	static final String PASSWORD = "Neel@21ksHrLTPhkgTr3rRMbz8OBBir5m";
	static EnterpriseConnection connection;

	public static void main(String[] args) {
		ConnectorConfig config = new ConnectorConfig();
		config.setUsername(USERNAME);
		config.setPassword(PASSWORD);

		try {
			connection = Connector.newConnection(config);
			queryContacts();
			createStudents();
		} catch (ConnectionException e) {
			e.printStackTrace();
		}
	}

	// Query for Contacts.
	private static void queryContacts() {
		System.out.println("Querying for Contacts...");
		try {
			QueryResult queryResults = connection
					.query("SELECT Id, FirstName, LastName FROM Contact LIMIT 20");
			if (queryResults.getSize() > 0) {
				int size = queryResults.getRecords().length;
				for (int count = 0; count < size; count++) {
					Contact contact = (Contact) queryResults.getRecords()[count];
					System.out.println("Id: " + contact.getId() + " - Name: "
							+ contact.getFirstName() + " "
							+ contact.getLastName());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Insert Students
	private static void createStudents() {
		System.out.println("Creating new Students...");
		Student__c[] students = new Student__c[5];
		try {
			QueryResult queryResults = connection
					.query("SELECT Id FROM Class__c WHERE Name = 'A'");
			for (int count = 0; count < 5; count++) {
				Student__c student = new Student__c();
				student.setName("Student " + count);
				student.setLast_Name__c("LastName " + count);
				student.setClass__c(queryResults.getRecords()[0].getId());
				students[count] = student;
			}
			// Create the records in Salesforce.com
			SaveResult[] saveResults = connection.create(students);
			// Check the returned results for any errors
			int size = saveResults.length;
			for (int count = 0; count < size; count++) {
				if (saveResults[count].isSuccess()) {
					System.out.println((count + 1)
							+ ". Successfully created record - Id: "
							+ saveResults[count].getId());
				} else {
					Error[] errors = saveResults[count].getErrors();
					for (int counter = 0; counter < errors.length; counter++) {
						System.out.println("ERROR creating record: "
								+ errors[counter].getMessage());
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
