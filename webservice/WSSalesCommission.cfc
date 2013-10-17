<cfcomponent DisplayName="WSSalesCommission" Hint="Manages all sales commission web services">

<cffunction Name="insertSalesCommission" Access="remote" Output="No" ReturnType="numeric" Hint="Inserts sales commission for a particular invoice or line item for a salesperson, affiliate, cobrand or vendor. Returns salesCommissionID.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="invoiceID" Type="numeric">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="numeric">
	<cfargument Name="targetID_custom" Type="string">
	<cfargument Name="salesCommissionAmount" Type="numeric">
	<cfargument Name="salesCommissionPaid" Type="string">
	<cfargument Name="salesCommissionDateBegin" Type="string">
	<cfargument Name="salesCommissionDateEnd" Type="string">
	<cfargument Name="salesCommissionBasisTotal" Type="numeric">
	<cfargument Name="salesCommissionBasisQuantity" Type="numeric">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>
	<cfset var commissionCustomerID = 0>

	<cfinclude template="ws_salesCommission/ws_insertSalesCommission.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateSalesCommission" Access="remote" Output="No" ReturnType="boolean" Hint="Updates existing sales commission. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="updateFieldList" Type="string">
	<cfargument Name="salesCommissionID" Type="string">
	<cfargument Name="salesCommissionPaid" Type="string">
	<cfargument Name="salesCommissionStatus" Type="boolean">

	<cfset var returnValue = False>
	<cfset var returnError = "">
	<cfset var errorMessage_fields = StructNew()>
	<cfset var isAllFormFieldsOk = False>

	<cfinclude template="ws_salesCommission/ws_updateSalesCommission.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSalesCommission" Access="remote" Output="No" ReturnType="query" Hint="Select one or more existing sales commission.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="salesCommissionID" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var primaryTargetKeyArray = ArrayNew(1)>

	<cfinclude template="ws_salesCommission/ws_selectSalesCommission.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSalesCommissionList_count" Access="remote" Output="No" ReturnType="numeric" Hint="Returns number of sales commissions that meet criteria.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="salesCommissionID" Type="string">
	<cfargument Name="commissionID" Type="string">
	<cfargument Name="commissionID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="string">
	<cfargument Name="targetID_custom" Type="string">
	<cfargument Name="salesCommissionAmount_min" Type="numeric">
	<cfargument Name="salesCommissionAmount_max" Type="numeric">
	<cfargument Name="salesCommissionFinalized" Type="boolean">
	<cfargument Name="salesCommissionPaid" Type="string">
	<cfargument Name="salesCommissionStatus" Type="boolean">
	<cfargument Name="salesCommissionManual" Type="boolean">
	<cfargument Name="salesCommissionBasisTotal_min" Type="numeric">
	<cfargument Name="salesCommissionBasisTotal_max" Type="numeric">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="priceID" Type="string">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="categoryID" Type="string">
	<cfargument Name="categoryCode" Type="string">
	<cfargument Name="salesCommissionDateFinalized_from" Type="string">
	<cfargument Name="salesCommissionDateFinalized_to" Type="string">
	<cfargument Name="salesCommissionDatePaid_from" Type="string">
	<cfargument Name="salesCommissionDatePaid_to" Type="string">
	<cfargument Name="salesCommissionDateBegin_from" Type="string">
	<cfargument Name="salesCommissionDateBegin_to" Type="string">
	<cfargument Name="salesCommissionDateEnd_from" Type="string">
	<cfargument Name="salesCommissionDateEnd_to" Type="string">
	<cfargument Name="salesCommissionIsExported" Type="string">

	<cfset var returnValue = -1>
	<cfset var returnError = "">
	<cfset var dateBeginResponse = "">
	<cfset var dateEndResponse = "">
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_salesCommission/ws_selectSalesCommissionList_count.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSalesCommissionList" Access="remote" Output="No" ReturnType="query" Hint="Select existing sales commissions that meet criteria. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="salesCommissionID" Type="string">
	<cfargument Name="commissionID" Type="string">
	<cfargument Name="commissionID_custom" Type="string">
	<cfargument Name="primaryTargetKey" Type="string">
	<cfargument Name="targetID" Type="string">
	<cfargument Name="targetID_custom" Type="string">
	<cfargument Name="salesCommissionAmount_min" Type="numeric">
	<cfargument Name="salesCommissionAmount_max" Type="numeric">
	<cfargument Name="salesCommissionFinalized" Type="boolean">
	<cfargument Name="salesCommissionPaid" Type="string">
	<cfargument Name="salesCommissionStatus" Type="boolean">
	<cfargument Name="salesCommissionManual" Type="boolean">
	<cfargument Name="salesCommissionBasisTotal_min" Type="numeric">
	<cfargument Name="salesCommissionBasisTotal_max" Type="numeric">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="companyID" Type="string">
	<cfargument Name="companyID_custom" Type="string">
	<cfargument Name="userID" Type="string">
	<cfargument Name="userID_custom" Type="string">
	<cfargument Name="subscriberID" Type="string">
	<cfargument Name="subscriberID_custom" Type="string">
	<cfargument Name="subscriptionID" Type="string">
	<cfargument Name="subscriptionID_custom" Type="string">
	<cfargument Name="cobrandID" Type="string">
	<cfargument Name="cobrandID_custom" Type="string">
	<cfargument Name="affiliateID" Type="string">
	<cfargument Name="affiliateID_custom" Type="string">
	<cfargument Name="priceID" Type="string">
	<cfargument Name="priceID_custom" Type="string">
	<cfargument Name="productID" Type="string">
	<cfargument Name="productID_custom" Type="string">
	<cfargument Name="categoryID" Type="string">
	<cfargument Name="categoryCode" Type="string">
	<cfargument Name="salesCommissionDateFinalized_from" Type="string">
	<cfargument Name="salesCommissionDateFinalized_to" Type="string">
	<cfargument Name="salesCommissionDatePaid_from" Type="string">
	<cfargument Name="salesCommissionDatePaid_to" Type="string">
	<cfargument Name="salesCommissionDateBegin_from" Type="string">
	<cfargument Name="salesCommissionDateBegin_to" Type="string">
	<cfargument Name="salesCommissionDateEnd_from" Type="string">
	<cfargument Name="salesCommissionDateEnd_to" Type="string">
	<cfargument Name="salesCommissionIsExported" Type="string">
	<cfargument Name="queryDisplayPerPage" Type="numeric">
	<cfargument Name="queryPage" Type="numeric">
	<cfargument Name="queryOrderBy" Type="string">
	<cfargument Name="queryFirstLetter" Type="string">
	<cfargument Name="returnTargetName" Type="boolean">
	<cfargument Name="returnSalesCommissionSum" Type="boolean">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var dateBeginResponse = "">
	<cfset var dateEndResponse = "">
	<cfset var queryFirstLetter_field = "">
	<cfset var primaryTargetKeyArray = ArrayNew(1)>
	<cfset var qryParamStruct = StructNew()>

	<cfinclude template="ws_salesCommission/ws_selectSalesCommissionList.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="selectSalesCommissionInvoice" Access="remote" Output="No" ReturnType="query" Hint="Select invoices and line items included in sales commission calculation. Returns query.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="useCustomIDFieldList" Type="string">
	<cfargument Name="searchFieldList" Type="string">
	<cfargument Name="salesCommissionID" Type="string">
	<cfargument Name="invoiceID" Type="string">
	<cfargument Name="invoiceID_custom" Type="string">
	<cfargument Name="commissionCustomerID" Type="string">

	<cfset var returnValue = QueryNew("error")>
	<cfset var returnError = "">
	<cfset var isAllFormFieldsOk = True>

	<cfinclude template="ws_salesCommission/ws_selectSalesCommissionInvoice.cfm">
	<cfreturn returnValue>
</cffunction>

<cffunction Name="updateSalesCommissionIsExported" Access="public" Output="No" ReturnType="boolean" Hint="Updates whether salesCommission records have been exported. Returns True.">
	<cfargument Name="sessionUUID" Type="UUID">
	<cfargument Name="salesCommissionID" Type="string" Required="Yes">
	<cfargument Name="salesCommissionIsExported" Type="string" Required="Yes">

	<cfset var returnValue = False>
	<cfset var returnError = "">

	<cfinclude template="ws_salesCommission/ws_updateSalesCommissionIsExported.cfm">
	<cfreturn returnValue>
</cffunction>

</cfcomponent>
