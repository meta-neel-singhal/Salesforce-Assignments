<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_student_when_the_record_updates</fullName>
        <description>Alert student when the record updates</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Student_Record_Update_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Married_equals_true</fullName>
        <description>If any student have wife name then automatically its married = true.</description>
        <field>Married__c</field>
        <literalValue>1</literalValue>
        <name>Married equals true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Alert for Record Updated</fullName>
        <actions>
            <name>Alert_student_when_the_record_updates</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends email to student when His record gets update.</description>
        <formula>LastModifiedDate &lt;&gt;  CreatedDate</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Married equals true if having Wife Name</fullName>
        <actions>
            <name>Married_equals_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If any student have wife name then automatically its married = true.</description>
        <formula>NOT( ISBLANK( Spouse_Name__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
