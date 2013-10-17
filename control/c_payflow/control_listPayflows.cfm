<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="selectPayflowList" ReturnVariable="qry_selectPayflowList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
</cfinvoke>

<cfinclude template="../../view/v_payflow/lang_listPayflows.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("viewPayflow,movePayflowUp,movePayflowDown")>

<cfset Variables.columnHeaderList = Variables.lang_listPayflows_title.payflowOrder & "^" & Variables.lang_listPayflows_title.payflowName>
<cfset Variables.columnOrderByList = "payflowOrder^payflowName">

<cfif Not REFind("[A-Za-z0-9]", ValueList(qry_selectPayflowList.payflowID_custom))>
	<cfset Variables.displayPayflowID_custom = False>
<cfelse>
	<cfset Variables.displayPayflowID_custom = True>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPayflows_title.payflowID_custom>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^payflowID_custom">
</cfif>

<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPayflows_title.payflowDefault & "^" & Variables.lang_listPayflows_title.payflowStatus>
<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^payflowDefault^payflowStatus">

<cfif ListFind(Variables.permissionActionList, "movePayflowUp") and ListFind(Variables.permissionActionList, "movePayflowDown")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPayflows_title.switchPayflowOrder>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>

<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPayflows_title.payflowDateCreated & "^" & Variables.lang_listPayflows_title.payflowDateUpdated>
<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^payflowDateCreated^payflowDateUpdated">

<cfif ListFind(Variables.permissionActionList, "viewPayflow")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listPayflows_title.viewPayflow>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../include/function/fn_toggleBgcolor.cfm">

<cfinclude template="../../view/v_payflow/dsp_selectPayflowList.cfm">
