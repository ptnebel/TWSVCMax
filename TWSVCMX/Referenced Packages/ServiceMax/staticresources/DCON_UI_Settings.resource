<configuration version="2.0">
  <grid id="workOrderSettings" autorefresh="false" refreshtime="7" sortColumn="Name" sortOrder="DESC" columnIndex="0" filterColumn="Name" woHoverColor="0" woSelectionColor="16711731" resetTime="false" unassignWO="false">
    <selectedcolumns>
      <column name="Name" width="145.78841309823676"/>
      <column name="SVMXC__Company__c" width="141.26784214945425"/>
      <column name="SVMXC__Contact__c" width="126.575986565911"/>
      <column name="SVMXC__Case__c" width="94.93198992443318"/>
      <column name="SVMXC__Priority__c" width="57.63727959697732"/>
      <column name="SVMXC__Order_Status__c" width="79.10999160369435"/>
      <column name="SVMXC__Order_Type__c" width="120.92527287993283"/>
      <column name="SVMXC__Dispatch_Status__c" width="94.93198992443318"/>
      <column name="SVMXC__City__c" width="81.37027707808564"/>
      <column name="SVMXC__State__c" width="55.376994122586055"/>
      <column name="SVMXC__Component__c" width="113.01427371956338"/>
      <column name="SVMXC__Customer_Down_Status__c" width="135.61712846347604"/>
      <column name="SVMXC__Billing_Type__c" width="99.45256087321604"/>
    </selectedcolumns>
    <rules>
      <rule name="Critical Work Orders" status="TAG168" expression="" color="16750848">
        <row property="SVMXC__Priority__c" type="" fieldType="" compare="matches" value="Critical"/>
      </rule>
      <rule name="High Priority Work Orders" status="TAG168" expression="" color="16737996">
        <row property="SVMXC__Priority__c" type="" fieldType="" compare="matches" value="High"/>
      </rule>
      <rule name="Medium Priority Work Orders" status="TAG168" expression="" color="16776960">
        <row property="SVMXC__Priority__c" type="" fieldType="" compare="matches" value="Medium"/>
      </rule>
    </rules>
  </grid>
  <grid id="technicianSettings" view="territory" map="true" mapDefaultZoomLevel="7" mapDefaultLat="34.079962" mapDefaultLng="-118.23761" loglevel="WARN" noOfDays="0" condition="before" refreshEventsOnChange="false" retainDateOnShowRoute="false" autoCalculateEndDate="false" eventRowColor="11723263" driveColor="39372" defaultEventColor="13421568" defaultWOEventColor="16776960" toolTipShowDelay="0" toolTipHideDelay="3000" dataTipOnClick="false">
    <selectedcolumns>
      <column name="Name" width="150"/>
    </selectedcolumns>
    <rules>
      <rule name="Call" status="TAG168" expression="" color="16750848">
        <row property="Subject" type="EVENT" fieldType="" compare="matches" value="Call"/>
      </rule>
      <rule name="Email" status="TAG168" expression="" color="65280">
        <row property="Subject" type="EVENT" fieldType="" compare="matches" value="Email"/>
      </rule>
      <rule name="Meeting" status="TAG168" expression="" color="255">
        <row property="Subject" type="EVENT" fieldType="" compare="matches" value="Meeting"/>
      </rule>
      <rule name="Send Letter/Quote" status="TAG168" expression="" color="65535">
        <row property="Subject" type="EVENT" fieldType="" compare="matches" value="Send Letter/Quote"/>
      </rule>
      <rule name="Other" status="TAG168" expression="" color="16711935">
        <row property="Subject" type="EVENT" fieldType="" compare="matches" value="Other"/>
      </rule>
    </rules>
  </grid>
  <grid id="keywordSettings">
    <selectedcolumns>
      <column name="SVMXC__Case__c" width="0"/>
      <column name="SVMXC__City__c" width="0"/>
      <column name="SVMXC__Component__c" width="0"/>
      <column name="SVMXC__Order_Status__c" width="0"/>
      <column name="SVMXC__Order_Type__c" width="0"/>
      <column name="SVMXC__State__c" width="0"/>
      <column name="SVMXC__Zip__c" width="0"/>
    </selectedcolumns>
  </grid>
  <grid id="teamKeywordSettings" matchcriteria="any">
    <selectedcolumns>
      <column name="SVMXC__City__c" width="0"/>
      <column name="EXPERTISE" width="0"/>
      <column name="PRODUCT" width="0"/>
      <column name="Name" width="0"/>
      <column name="SVMXC__State__c" width="0"/>
      <column name="SVMXC__Zip__c" width="0"/>
    </selectedcolumns>
  </grid>
  <grid id="techKeywordSettings" matchcriteria="any">
    <selectedcolumns>
      <column name="SVMXC__City__c" width="0"/>
      <column name="EXPERTISE" width="0"/>
      <column name="Name" width="0"/>
      <column name="PRODUCT" width="0"/>
      <column name="SVMXC__State__c" width="0"/>
      <column name="SVMXC__Zip__c" width="0"/>
    </selectedcolumns>
  </grid>
</configuration>