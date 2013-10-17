<cfparam Name="URL.groupID" Default="0">
<cfset Variables.formAction = Variables.doURL & "&groupID=#URL.groupID#">

<cfinclude template="security_group.cfm">
<cfinclude template="../../view/v_group/nav_group.cfm">
<cfif IsDefined("URL.confirm_group")>
	<cfinclude template="../../view/v_group/confirm_group.cfm">
</cfif>
<cfif IsDefined("URL.error_group")>
	<cfinclude template="../../view/v_group/error_group.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listGroups">
	<cfinclude template="control_listGroups.cfm">
</cfcase>

<cfcase value="insertGroup,updateGroup">
	<cfinclude template="control_insertUpdateGroup.cfm">
</cfcase>

<cfcase value="viewGroup">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupSummary" ReturnVariable="qry_selectGroupSummary">
			<cfinvokeargument Name="groupID" Value="#URL.groupID#">
		</cfinvoke>

		<cfinclude template="../../view/v_group/dsp_selectGroup.cfm">

	<cfelseif Not Application.fn_IsUserAuthorized("viewCustomFieldValuesAll") and Not Application.fn_IsUserAuthorized("listStatusHistory")>
		<cfset URL.error_group = "invalidAction">
		<cfinclude template="../../view/v_group/error_group.cfm">
	<cfelse>
 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="groupID">
				<cfinvokeargument name="targetID" value="#URL.groupID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="groupID">
				<cfinvokeargument name="targetID" value="#URL.groupID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="listGroupUser">
	<cfinclude template="control_listGroupUser.cfm">
</cfcase>

<cfcase value="insertGroupUser">
	<cfinclude template="control_insertGroupUser.cfm">
</cfcase>

<cfcase value="listGroupCompany">
	<cfinclude template="control_listGroupCompany.cfm">
</cfcase>

<cfcase value="insertGroupCompany">
	<cfinclude template="control_insertGroupCompany.cfm">
</cfcase>

<cfcase value="listGroupAffiliate,listGroupCobrand,listGroupVendor">
	<cfinclude template="control_listGroupTarget.cfm">
</cfcase>

<cfcase value="insertGroupAffiliate,insertGroupCobrand,insertGroupVendor">
	<cfinclude template="control_insertGroupTarget.cfm">
</cfcase>

<cfcase value="insertPermissionTarget,viewPermissionTarget">
	<cfif Variables.doAction is "viewPermissionTarget">
		<cfset Variables.formAction = "">
	<cfelse>
		<cfset Variables.formAction = "index.cfm?method=#URL.method#&groupID=#URL.groupID#">
	</cfif>

	<cfset Variables.permissionControl = "group">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("groupID")>
	<cfset Variables.targetID = URL.groupID>
	<cfset Variables.doControl = "permission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPrices">
	<cfset Variables.urlParameters = "&groupID=#URL.groupID#">
	<cfset Variables.doControl = "price">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNote">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&groupID=#URL.groupID#">
		<cfinvokeargument name="primaryTargetKey" value="groupID">
		<cfinvokeargument name="targetID" value="#URL.groupID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&groupID=#URL.groupID#">
		<cfinvokeargument name="primaryTargetKey" value="groupID">
		<cfinvokeargument name="targetID" value="#URL.groupID#">
		<cfinvokeargument name="userID_target" value="#qry_selectGroup.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectGroup.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listStatusHistory">
	<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
		<cfinvokeargument name="primaryTargetKey" value="groupID">
		<cfinvokeargument name="targetID" value="#URL.groupID#">
	</cfinvoke>
</cfcase>

<cfcase value="viewCustomFieldValuesAll">
	<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
		<cfinvokeargument name="companyID" value="#Session.companyID_author#">
		<cfinvokeargument name="primaryTargetKey" value="groupID">
		<cfinvokeargument name="targetID" value="#URL.groupID#">
	</cfinvoke>
</cfcase>

<cfcase value="insertPayflowGroup,viewPayflowGroup">
	<cfset Variables.doControl = "payflow">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("groupID")>
	<cfset Variables.targetID = URL.groupID>
	<cfset Variables.urlParameters = "&groupID=#URL.groupID#">

	<cfset Variables.doControl = "commission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_group = "invalidAction">
	<cfinclude template="../../view/v_group/error_group.cfm">
</cfdefaultcase>
</cfswitch>

