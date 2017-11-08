<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_updated_by_someone_else</fullName>
        <description>Account updated by someone else</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Account_Owner_About_Changes_Done_by_Someone_Else</template>
    </alerts>
    <rules>
        <fullName>Account Updated by Someone Else</fullName>
        <actions>
            <name>Account_updated_by_someone_else</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify the account owner when someone else updates the account if the account&apos;s annualrevenue is greater than $1,000,000.</description>
        <formula>AND(AnnualRevenue  &gt; 1000000 , LastModifiedById &lt;&gt; Owner.Id)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
