<cfinclude template="../../../view/v_product/v_productParameter/lang_listProductParameters.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveProductParameterDown,moveProductParameterUp,moveProductParameterCodeDown,moveProductParameterCodeUp,updateProductParameter")>
<cfset Variables.columnHeaderList = Variables.lang_listProductParameters_title.productParameterName
		& "^" & Variables.lang_listProductParameters_title.productParameterText
		& "^" & Variables.lang_listProductParameters_title.productParameterRequired
		& "^" & Variables.lang_listProductParameters_title.productParameterStatus
		& "^" & Variables.lang_listProductParameters_title.productParameterOrder>
<cfset Variables.columnOrderByList = "productParameterName^productParameterText^productParameterRequired^productParameterStatus^productParameterOrder">

<cfif ListFind(Variables.permissionActionList, "moveProductParameterDown") and ListFind(Variables.permissionActionList, "moveProductParameterUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProductParameters_title.switchProductParameterOrder>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>

<cfset Variables.columnHeaderList = Variables.columnHeaderList
		& "^" & Variables.lang_listProductParameters_title.productParameterDateCreated 
		& "^" & Variables.lang_listProductParameters_title.productParameterDateUpdated 
		& "^" & Variables.lang_listProductParameters_title.productParameterCodeOrder >
<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^productParameterDateCreated^productParameterDateUpdated^productParameterCodeOrder">

<cfif ListFind(Variables.permissionActionList, "moveProductParameterCodeDown") and ListFind(Variables.permissionActionList, "moveProductParameterCodeUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProductParameters_title.switchProductParameterCodeOrder>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateProductParameter")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProductParameters_title.updateProductParameter>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>

<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listProductParameters_title.productParameterOptionCount>
<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">

<cfset Variables.queryViewAction = Variables.formAction>
<cfset Variables.queryOrderBy = URL.queryOrderBy>

<cfif qry_selectProductParameterList.RecordCount is 0>
	<cfset Variables.displayParameterOptions = False>
<cfelse>
	<cfset Variables.displayParameterOptions = True>
	<cfinvoke Component="#Application.billingMapping#data.ProductParameterOption" Method="selectProductParameterOptionList" ReturnVariable="qry_selectProductParameterOptionList">
		<cfinvokeargument Name="productParameterID" Value="#ValueList(qry_selectProductParameterList.productParameterID)#">
		<cfinvokeargument Name="productParameterOptionStatus" Value="1">
	</cfinvoke>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../../view/v_product/v_productParameter/dsp_selectProductParameterList.cfm">
