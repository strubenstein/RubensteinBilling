<cfif Session.companyID is Application.billingSuperuserCompanyID>
	<cfset Variables.displayStatus = True>
<cfelse>
	<cfset Variables.displayStatus = False>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.TriggerAction" Method="selectTriggerActionList" ReturnVariable="qry_selectTriggerActionList">
	<cfif Variables.displayStatus is False>
		<cfinvokeargument Name="permissionStatus" Value="1">
		<cfinvokeargument Name="permissionSuperuserOnly" Value="0">
	</cfif>
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Trigger" Method="selectTriggerList" ReturnVariable="qry_selectTriggerList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
	<cfinvokeargument Name="triggerStatus" Value="1">
</cfinvoke>

<cfinclude template="../../view/v_trigger/lang_listTriggerActions.cfm">
<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("moveTriggerActionDown,moveTriggerActionUp,updateTriggerAction,insertTrigger,updateTrigger")>

<cfset Variables.columnHeaderList = Variables.lang_listTriggerActions_title.triggerModule & "^" & Variables.lang_listTriggerActions_title.triggerAction>
<cfif Variables.displayStatus is True>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listTriggerActions_title.triggerStatus>
</cfif>

<cfif ListFind(Variables.permissionActionList, "moveTriggerActionDown") and ListFind(Variables.permissionActionList, "moveTriggerActionUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listTriggerActions_title.switchTriggerOrder>
</cfif>
<cfif ListFind(Variables.permissionActionList, "updateTriggerAction")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listTriggerActions_title.updateTriggerAction>
</cfif>

<cfif qry_selectTriggerList.RecordCount is not 0>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList
			& "^" & Variables.lang_listTriggerActions_title.triggerFilename
			& "^" & Variables.lang_listTriggerActions_title.triggerDateBegin
			& "^" & Variables.lang_listTriggerActions_title.triggerDateEnd>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertTrigger") or ListFind(Variables.permissionActionList, "updateTrigger")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listTriggerActions_title.insertTrigger>
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_trigger/dsp_selectTriggerActionList.cfm">
