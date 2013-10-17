<cfcomponent DisplayName="WSBank" Hint="Manages all bank web services">

<cffunction Name="insertBank" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts new bank into database and returns bankID">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="bankName" Type="string">
	<cfargument Name="bankBranch" Type="string">
	<cfargument Name="bankBranchCity" Type="string">
	<cfargument Name="bankBranchState" Type="string">
	<cfargument Name="bankBranchCountry" Type="string">
	<cfargument Name="bankBranchContactName" Type="string">
	<cfargument Name="bankBranchPhone" Type="string">
	<cfargument Name="bankBranchFax" Type="string">
	<cfargument Name="bankRoutingNumber" Type="string">
	<cfargument Name="bankAccountNumber" Type="string">
	<cfargument Name="bankAccountName" Type="string">
	<cfargument Name="bankCheckingOrSavings" Type="string">
	<cfargument Name="bankPersonalOrCorporate" Type="boolean">
	<cfargument Name="bankDescription" Type="string">
	<cfargument Name="bankAccountType" Type="string">
	<cfargument Name="bankRetain" Type="boolean">
	<cfargument Name="addressID" Type="numeric">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_bank/ws_insertBank.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateBank" Access="remote" Output="No" ReturnType="numeric" Hint="Updates existing bank account. If necessary, deletes existing bank account. Inserts new bank account and returns new bankID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="bankID" Type="numeric">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="numeric">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="bankName" Type="string">
	<cfargument Name="bankBranch" Type="string">
	<cfargument Name="bankBranchCity" Type="string">
	<cfargument Name="bankBranchState" Type="string">
	<cfargument Name="bankBranchCountry" Type="string">
	<cfargument Name="bankBranchContactName" Type="string">
	<cfargument Name="bankBranchPhone" Type="string">
	<cfargument Name="bankBranchFax" Type="string">
	<cfargument Name="bankRoutingNumber" Type="string">
	<cfargument Name="bankAccountNumber" Type="string">
	<cfargument Name="bankAccountName" Type="string">
	<cfargument Name="bankCheckingOrSavings" Type="string">
	<cfargument Name="bankPersonalOrCorporate" Type="boolean">
	<cfargument Name="bankDescription" Type="string">
	<cfargument Name="bankAccountType" Type="string">
	<cfargument Name="bankRetain" Type="boolean">
	<cfargument Name="addressID" Type="numeric">
	<cfargument Name="bankStatus" Type="boolean">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var updateFieldList_valid = "">
	<cfset var isBankUpdate = True>

	<cfinclude template="ws_bank/ws_updateBank.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectBank" Access="remote" Output="No" ReturnType="query" Hint="Select existing bank account(s)">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="bankID" Type="string">

	<cfset var returnValue = QueryNew("blank")>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_bank/ws_selectBank.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectBankList" Access="remote" Output="No" ReturnType="query" Hint="Select existing bank account(s) based on designated criteria">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="bankCheckingOrSavings" Type="string">
	<cfargument Name="bankPersonalOrCorporate" Type="boolean">
	<cfargument Name="bankDescription" Type="string">
	<cfargument Name="bankAccountType" Type="string">
	<cfargument Name="bankStatus" Type="boolean">
	<cfargument Name="bankRetain" Type="boolean">

	<cfset var returnValue = QueryNew("blank")>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_bank/ws_selectBankList.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
