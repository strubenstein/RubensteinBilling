<cfinvoke Component="#Application.billingMapping#data.ProductParameterException" Method="selectProductParameterExceptionList" ReturnVariable="qry_selectProductParameterExceptionList">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="returnParameterOptions" Value="True">
</cfinvoke>

<cfset Variables.productParameterOptionID_list = "">
<cfset Variables.productParameterOptionID_list = ListAppend(Variables.productParameterOptionID_list, ValueList(qry_selectProductParameterExceptionList.productParameterOptionID1))>
<cfset Variables.productParameterOptionID_list = ListAppend(Variables.productParameterOptionID_list, ValueList(qry_selectProductParameterExceptionList.productParameterOptionID2))>
<cfset Variables.productParameterOptionID_list = ListAppend(Variables.productParameterOptionID_list, ValueList(qry_selectProductParameterExceptionList.productParameterOptionID3))>
<cfset Variables.productParameterOptionID_list = ListAppend(Variables.productParameterOptionID_list, ValueList(qry_selectProductParameterExceptionList.productParameterOptionID4))>
<cfset Variables.productParameterOptionID_list = Replace(Variables.productParameterOptionID_list, ",0", "", "ALL")>

<cfinclude template="../../../view/v_product/v_productParameter/lang_listProductParameterExceptions.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("updateProductParameterExceptionStatus,updateProductParameterException")>

<cfset Variables.columnHeaderList = Variables.lang_listProductParameterExceptions_title.productParameterExceptionDescription
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionTriggers
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionExcluded
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionPricePremium
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionWarning
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionStatus
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionDateCreated
		& "^" &  Variables.lang_listProductParameterExceptions_title.productParameterExceptionDateUpdated>

<cfif ListFind(Variables.permissionActionList, "updateProductParameterException")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProductParameterExceptions_title.updateProductParameterException>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../../view/v_product/v_productParameter/dsp_selectProductParameterExceptionList.cfm">
