<!--- insertPayflowInvoice,updatePayflowInvoice --->

<cfparam Name="URL.payflowID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.payflowID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&payflowID=" & URL.payflowID>
</cfif>

<cfinclude template="security_payflow.cfm">
<cfif URL.control is "payflow">
	<cfinclude template="../../view/v_payflow/nav_payflow.cfm">
</cfif>
<cfif IsDefined("URL.confirm_payflow")>
	<cfinclude template="../../view/v_payflow/confirm_payflow.cfm">
</cfif>
<cfif IsDefined("URL.error_payflow")>
	<cfinclude template="../../view/v_payflow/error_payflow.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPayflows">
	<cfinclude template="control_listPayflows.cfm">
</cfcase>

<cfcase value="insertPayflow,updatePayflow">
	<cfinclude template="control_insertUpdatePayflow.cfm">
</cfcase>

<cfcase value="viewPayflow">
	<cfinclude template="control_viewPayflow.cfm">
</cfcase>

<cfcase value="movePayflowUp,movePayflowDown">
	<cfinvoke Component="#Application.billingMapping#data.Payflow" Method="switchPayflowOrder" ReturnVariable="isPayflowOrderSwitched">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="payflowID" Value="#URL.payflowID#">
		<cfinvokeargument Name="payflowOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=payflow.listPayflows&confirm_payflowe=#Variables.doAction#" AddToken="No">
</cfcase>

<!--- 
<cfcase value="insertPayflowTemplate,updatePayflowTemplate,listPayflowTemplates">
	<cfinclude template="control_insertPayflowTemplate.cfm">
</cfcase>
--->

<cfcase value="insertPayflowNotify">
	<cfinclude template="control_insertPayflowNotify.cfm">
</cfcase>

<cfcase value="updatePayflowNotify,listPayflowNotify">
	<cfinclude template="control_updatePayflowNotify.cfm">
</cfcase>

<cfcase value="listPayflowGroups">
	<cfinclude template="control_listPayflowGroups.cfm">
</cfcase>

<cfcase value="insertPayflowGroup,viewPayflowGroup">
	<cfif URL.control is "group">
		<cfset Variables.primaryTargetKey = "groupID">
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("groupID")>
		<cfset Variables.targetID = URL.groupID>
		<cfinclude template="control_insertPayflowTarget.cfm">
	<cfelse>
		<cfset URL.error_payflow = Variables.doAction>
		<cfinclude template="../../view/v_payflow/error_payflow.cfm">
	</cfif>
</cfcase>

<cfcase value="insertPayflowTarget,viewPayflowTarget">
	<cfif ListFind("affiliate,cobrand,company", URL.control)>
		<cfset Variables.primaryTargetKey = Application.fn_GetPrimaryTargetKey(Variables.primaryTargetID)>
		<!--- 
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("groupID")>
		<cfset Variables.targetID = URL.groupID>
		--->
		<cfinclude template="control_insertPayflowTarget.cfm">
	<cfelse>
		<cfset URL.error_payflow = Variables.doAction>
		<cfinclude template="../../view/v_payflow/error_payflow.cfm">
	</cfif>
</cfcase>

<cfcase value="listPayflowCompanies">
	<cfset Variables.doControl = "company">
	<cfset Variables.doAction = "listCompanies">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="insertPayflowCompany,viewPayflowCompany">
	<cfif URL.control is "company">
		<cfset Variables.primaryTargetKey = "companyID">
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("companyID")>
		<cfset Variables.targetID = URL.companyID>
		<cfinclude template="control_insertPayflowTarget.cfm">
	<cfelse>
		<cfset URL.error_payflow = Variables.doAction>
		<cfinclude template="../../view/v_payflow/error_payflow.cfm">
	</cfif>
</cfcase>

<cfcase value="listPayflowInvoices">
	<cfset Variables.doControl = "invoice">
	<cfset Variables.doAction = "listInvoices">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="payflowID">
		<cfinvokeargument name="targetID" value="#URL.payflowID#">
		<cfinvokeargument name="urlParameters" value="&payflowID=#URL.payflowID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&payflowID=#URL.payflowID#">
		<cfinvokeargument name="primaryTargetKey" value="payflowID">
		<cfinvokeargument name="targetID" value="#URL.payflowID#">
		<cfinvokeargument name="userID_target" value="0">
		<cfinvokeargument name="companyID_target" value="0">
	</cfinvoke>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_payflow = "invalidAction">
	<cfinclude template="../../view/v_payflow/error_payflow.cfm">
</cfdefaultcase>
</cfswitch>

