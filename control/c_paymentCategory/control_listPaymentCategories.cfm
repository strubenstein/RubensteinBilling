<cfinvoke Component="#Application.billingMapping#data.PaymentCategory" Method="selectPaymentCategoryList" ReturnVariable="qry_selectPaymentCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="paymentCategoryType" Value="#URL.paymentCategoryType#">
</cfinvoke>

<cfinclude template="../../view/v_paymentCategory/lang_listPaymentCategories.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("movePaymentCategoryUp,movePaymentCategoryDown,updatePaymentCategory")>

<cfset Variables.columnHeaderList = Variables.lang_listPaymentCategories_title.paymentCategoryOrder>

<cfif Not REFindNoCase("[A-Za-z0-9]", ValueList(qry_selectPaymentCategoryList.paymentCategoryID_custom))>
	<cfset Variables.displayPaymentCategoryID_custom = False>
<cfelse>
	<cfset Variables.displayPaymentCategoryID_custom = True>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPaymentCategories_title.paymentCategoryID_custom>
</cfif>

<cfset Variables.columnHeaderList = Variables.columnHeaderList
		& "^" & Variables.lang_listPaymentCategories_title.paymentCategoryName
		& "^" & Variables.lang_listPaymentCategories_title.paymentCategoryTitle
		& "^" & Variables.lang_listPaymentCategories_title.paymentCategoryAutoMethod
		& "^" & Variables.lang_listPaymentCategories_title.paymentCategoryStatus
		& "^" & Variables.lang_listPaymentCategories_title.paymentCategoryDateCreated>

<cfif ListFind(Variables.permissionActionList, "movePaymentCategoryUp") and ListFind(Variables.permissionActionList, "movePaymentCategoryDown")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPaymentCategories_title.switchPaymentCategoryOrder>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updatePaymentCategory")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPaymentCategories_title.updatePaymentCategory>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_paymentCategory/dsp_selectPaymentCategoryList.cfm">

