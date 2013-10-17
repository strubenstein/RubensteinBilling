<cfcomponent DisplayName="WSPhone" Hint="Manages all phone web services">

<cffunction Name="insertPhone" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new phone number into database and return phoneID">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="phoneAreaCode" Type="string">
	<cfargument Name="phoneNumber" Type="string">
	<cfargument Name="phoneExtension" Type="string">
	<cfargument Name="phoneType" Type="string">
	<cfargument Name="phoneDescription" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_phone/ws_insertPhone.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updatePhone" Access="remote" Output="No" ReturnType="numeric" Hint="Updates existing phone number. If simply updating status or type, returns existing ID. If changing phone number, inserts new phone number and returns new phoneID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="phoneID" Type="numeric">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="phoneAreaCode" Type="string">
	<cfargument Name="phoneNumber" Type="string">
	<cfargument Name="phoneExtension" Type="string">
	<cfargument Name="phoneType" Type="string">
	<cfargument Name="phoneDescription" Type="string">
	<cfargument Name="phoneStatus" Type="boolean">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var updateFieldList_valid = "">
	<cfset var isPhoneUpdate = True>

	<cfinclude template="ws_phone/ws_updatePhone.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
