<cfcomponent DisplayName="WSAddress" Hint="Manages all address web services">

<cffunction Name="insertAddress" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new address and returns addressID">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="addressName" Type="string">
	<cfargument Name="addressDescription" Type="string">
	<cfargument Name="addressTypeShipping" Type="boolean">
	<cfargument Name="addressTypeBilling" Type="boolean">
	<cfargument Name="address" Type="string">
	<cfargument Name="address2" Type="string">
	<cfargument Name="address3" Type="string">
	<cfargument Name="city" Type="string">
	<cfargument Name="state" Type="string">
	<cfargument Name="zipCode" Type="string">
	<cfargument Name="zipCodePlus4" Type="string">
	<cfargument Name="county" Type="string">
	<cfargument Name="country" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_address/ws_insertAddress.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateAddress" Access="remote" Output="No" ReturnType="numeric" Hint="Updates existing address. If simply updating status or type, returns existing ID. If changing address, inserts new address and returns new addressID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="addressID" Type="numeric">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="addressName" Type="string">
	<cfargument Name="addressDescription" Type="string">
	<cfargument Name="addressTypeShipping" Type="boolean">
	<cfargument Name="addressTypeBilling" Type="boolean">
	<cfargument Name="address" Type="string">
	<cfargument Name="address2" Type="string">
	<cfargument Name="address3" Type="string">
	<cfargument Name="city" Type="string">
	<cfargument Name="state" Type="string">
	<cfargument Name="zipCode" Type="string">
	<cfargument Name="zipCodePlus4" Type="string">
	<cfargument Name="county" Type="string">
	<cfargument Name="country" Type="string">
	<cfargument Name="addressStatus" Type="boolean">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var updateFieldList_valid = "">
	<cfset var isAddressUpdate = True>

	<cfinclude template="ws_address/ws_updateAddress.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectAddress" Access="remote" Output="No" ReturnType="query" Hint="Selects existing address(es).">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="addressID" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_address/ws_selectAddress.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectAddressList" Access="remote" Output="No" ReturnType="query" Hint="Select address list">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="addressName" Type="string">
	<cfargument Name="addressDescription" Type="string">
	<cfargument Name="addressTypeShipping" Type="boolean">
	<cfargument Name="addressTypeBilling" Type="boolean">
	<cfargument Name="addressStatus" Type="boolean">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">

	<cfinclude template="ws_address/ws_selectAddressList.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
