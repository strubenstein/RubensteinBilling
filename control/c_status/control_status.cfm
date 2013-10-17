<!--- 
statusLable as statusTitle instead?

User,Company,Salesperson,Vendor,Cobrand,Affiliate,Invoice,Payment,Shipping
select target type for create
255 max
--->
<cfinclude template="../../view/v_status/var_statusTargetList.cfm">
<cfset Variables.statusTargetList_id = "">
<cfloop Index="field" List="#Variables.statusTargetList_value#">
	<cfset Variables.statusTargetList_id = ListAppend(Variables.statusTargetList_id, Application.fn_GetPrimaryTargetID(field))>
</cfloop>

<cfparam Name="URL.statusID" Default="0">
<!--- <cfparam Name="URL.languageID" Default=""> --->
<cfparam Name="URL.primaryTargetID" Default="#Application.fn_GetPrimaryTargetID(ListFirst(Variables.statusTargetList_value))#">

<cfif URL.control is "status">
	<cfinvoke Component="#Application.billingMapping#data.StatusTarget" Method="selectStatusTargetList" ReturnVariable="qry_selectStatusTargetList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfinclude template="security_status.cfm">
	<cfinclude template="../../view/v_status/nav_status.cfm">
</cfif>
<cfif IsDefined("URL.confirm_status")>
	<cfinclude template="../../view/v_status/confirm_status.cfm">
</cfif>
<cfif IsDefined("URL.error_status")>
	<cfinclude template="../../view/v_status/error_status.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listStatuses">
	<cfinclude template="control_listStatuses.cfm">
</cfcase>

<cfcase value="insertStatus">
	<cfinclude template="control_insertStatus.cfm">
</cfcase>

<cfcase value="updateStatus">
	<cfinclude template="control_updateStatus.cfm">
</cfcase>

<cfcase value="moveStatusUp,moveStatusDown">
	<cfinvoke Component="#Application.billingMapping#data.Status" Method="switchStatusOrder" ReturnVariable="isStatusOrderSwitched">
		<cfinvokeargument Name="companyID" Value="#Session.companyID#">
		<cfinvokeargument Name="primaryTargetID" Value="#qry_selectStatus.primaryTargetID#">
		<cfinvokeargument Name="statusID" Value="#URL.statusID#">
		<cfinvokeargument Name="statusOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=status.listStatuses&primaryTargetID=#qry_selectStatus.primaryTargetID#&confirm_status=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateStatusTarget">
	<cfif qry_selectStatusTargetList.RecordCount is 0>
		<cfset URL.error_status = Variables.doAction>
		<cfinclude template="../../view/v_status/error_status.cfm">
	<cfelse>
		<cfinclude template="control_updateStatusTarget.cfm">
	</cfif>
</cfcase>

<cfcase value="listStatusHistory">
	<cfif URL.control is "status">
		<cfset URL.error_status = "invalidPrimaryTargetID">
		<cfinclude template="../../view/v_status/error_status.cfm">
	<cfelse>
		<cfinclude template="control_listStatusHistory.cfm">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_status = "invalidAction">
	<cfinclude template="../../view/v_status/error_status.cfm">
</cfdefaultcase>
</cfswitch>

