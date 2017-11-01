<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Birthday_after_2_days</fullName>
        <description>Birthday after 2 days</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Birthday_after_2_days</template>
    </alerts>
    <alerts>
        <fullName>Birthday_after_two_days</fullName>
        <description>Birthday after two days</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Birthday_after_2_days</template>
    </alerts>
    <alerts>
        <fullName>Experience_greater_than_5</fullName>
        <description>Experience greater than 5</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_teacher_if_experience_greater_than_5</template>
    </alerts>
    <rules>
        <fullName>Birthday after 2 days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Birthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send an email to the contact two days before the contact&apos;s birthday.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Birthday_after_two_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.Birthdate</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Teacher record Inserted or Updated</fullName>
        <actions>
            <name>Experience_greater_than_5</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Add workflow to teacher(insert/update) if his experience is more then 5 then send mail.</description>
        <formula>Experience__c  &gt; 5</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
