<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SVMXC_CalculateContractPrice</fullName>
        <description>DO NOT USE THIS FIELD UPDATE</description>
        <field>Discounted_Price__c</field>
        <formula>Discounted_Price__c * 1</formula>
        <name>SVMXC_CalculateContractPrice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SVMXC_ContractPriceOrDiscountChanged</fullName>
        <actions>
            <name>SVMXC_CalculateContractPrice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>DO NOT ACTIVATE OR USE THIS RULE</description>
        <formula>1 = 2</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
