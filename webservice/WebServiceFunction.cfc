<cfcomponent DisplayName="WebServiceFunction" Hint="Manages all web services security functions for validating targetID's.">

<cffunction Name="insertCustomFieldValues" Access="public" Output="No" ReturnType="boolean" Hint="Verifies that submitted sessionID matches session variable.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetKey" Type="string" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="customField" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var customFieldXml = "">
	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>
	<cfset var customFieldTypeList = "">
	<cfset var customFieldXmlCount = 0>
	<cfset var customFieldXmlName = "">
	<cfset var customFieldXmlValue = "">
	<cfset var customFieldRow = 0>
	<cfset var customFieldID = 0>
	<cfset var valueRow = 0>
	<cfset var customFieldOptionID_struct = StructNew()>
	<cfset var customFieldValue_struct = StructNew()>

	<cfset var isAllFormFieldsOk = False>
	<cfset var thisCustomFieldID = 0>
	<cfset var thisCustomFieldType = "">
	<cfset var thisCustomFormType = "">
	<cfset var formVariable = "">
	<cfset var formValue = "">
	<cfset var optionID = 0>
	<cfset var fieldValue = "">
	<cfset var counter = 0>
	<cfset var optionRow = 0>

	<cfinclude template="ws_customField/wsact_insertCustomFieldValues.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="insertStatusHistory" Access="public" Output="No" ReturnType="boolean" Hint="Inserts custom status for target. Called only from other web services functions.">
	<cfargument Name="companyID_author" Type="numeric" Required="Yes">
	<cfargument Name="userID_author" Type="numeric" Required="Yes">
	<cfargument Name="primaryTargetKey" Type="string" Required="Yes">
	<cfargument Name="targetID" Type="numeric" Required="Yes">
	<cfargument Name="useCustomIDFieldList" Type="string" Required="Yes">
	<cfargument Name="statusID" Type="numeric" Required="Yes">
	<cfargument Name="statusID_custom" Type="string" Required="Yes">
	<cfargument Name="statusHistoryComment" Type="string" Required="No" Default="">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var primaryTargetID = Application.fn_GetPrimaryTargetID(Arguments.primaryTargetKey)>

	<cfinclude template="ws_status/wsact_insertStatusHistory.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
