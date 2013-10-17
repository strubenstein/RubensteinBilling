<cfcomponent DisplayName="WSCommission" Hint="Manages all commission plan web services">

<cffunction Name="insertCommissionCustomer" Access="remote" Output="No" ReturnType="boolean" Hint="Inserts sales relationship between customer and user. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="companyID" Type="numeric">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">
	<cfargument Name="commissionCustomerPercent" Type="numeric">
	<cfargument Name="commissionCustomerPrimary" Type="boolean">
	<cfargument Name="commissionCustomerDateBegin" Type="string">
	<cfargument Name="commissionCustomerDateEnd" Type="string">
	<cfargument Name="commissionCustomerDescription" Type="string">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_commission/ws_insertCommissionCustomer.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectCommissionCustomerList" Access="remote" Output="No" ReturnType="query" Hint="Selects existing customer / salesperson relationships.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="targetID" Type="string">
	<cfargument Name="targetID_custom" Type="string">
	<cfargument Name="commissionCustomerPrimary" Type="boolean">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var isAllFormFieldsOk = True>
	<cfset var primaryTargetKeyArray = ArrayNew(1)>

	<cfinclude template="ws_commission/ws_selectCommissionCustomerList.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
