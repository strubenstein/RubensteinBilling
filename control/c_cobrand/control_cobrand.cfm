<cfparam Name="URL.cobrandID" Default="0">
<cfif URL.control is "company">
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">
<cfelse>
	<cfset Variables.urlParameters = "">
</cfif>

<!--- Enable user to go directly to cobrand by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewCobrand")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewCobrand" and IsDefined("URL.submitView") and Trim(URL.cobrandID) is not "">
	<cfinclude template="act_viewCobrandByID.cfm">
</cfif>

<cfinclude template="security_cobrand.cfm">
<cfinclude template="../../view/v_cobrand/nav_cobrand.cfm">
<cfif IsDefined("URL.confirm_cobrand")>
	<cfinclude template="../../view/v_cobrand/confirm_cobrand.cfm">
</cfif>
<cfif IsDefined("URL.error_cobrand")>
	<cfinclude template="../../view/v_cobrand/error_cobrand.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listCobrands">
	<cfinclude template="control_listCobrands.cfm">
</cfcase>

<cfcase value="listCompanyCobrands">
	<cfif URL.control is "company">
		<cfinclude template="control_listCompanyCobrands.cfm">
	<cfelse>
		<cfset URL.error_cobrand = Variables.doAction>
		<cfinclude template="../../view/v_cobrand/error_cobrand.cfm">
	</cfif>
</cfcase>

<cfcase value="viewCobrand">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_cobrand/dsp_viewCobrandByID.cfm">
		</cfif>
		<cfinclude template="control_viewCobrand.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="viewFieldArchivesViaTarget" returnVariable="isViewed">
			<cfinvokeargument name="primaryTargetKey" value="cobrandID">
			<cfinvokeargument name="targetID" value="#URL.cobrandID#">
		</cfinvoke>

 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="cobrandID">
				<cfinvokeargument name="targetID" value="#URL.cobrandID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="cobrandID">
				<cfinvokeargument name="targetID" value="#URL.cobrandID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="insertCobrand">
	<cfinclude template="control_insertCobrand.cfm">
</cfcase>

<cfcase value="updateCobrand">
	<cfinclude template="control_updateCobrand.cfm">
</cfcase>

<cfcase value="insertCobrandHeader">
	<cfinclude template="control_insertCobrandHeader.cfm">
</cfcase>

<cfcase value="listPrices">
	<cfif URL.control is "cobrand">
		<cfset Variables.urlParameters = "&cobrandID=#URL.cobrandID#">
	</cfif>
	<cfset Variables.doControl = "price">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="cobrandID">
		<cfinvokeargument name="targetID" value="#URL.cobrandID#">
		<cfinvokeargument name="urlParameters" value="&cobrandID=#URL.cobrandID#">
		<cfinvokeargument name="userID_target" value="#qry_selectCobrand.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectCobrand.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&cobrandID=#URL.cobrandID#">
		<cfinvokeargument name="primaryTargetKey" value="cobrandID">
		<cfinvokeargument name="targetID" value="#URL.cobrandID#">
		<cfinvokeargument name="userID_target" value="#qry_selectCobrand.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectCobrand.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="insertPayflowTarget,viewPayflowTarget">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("cobrandID")>
	<cfset Variables.targetID = URL.cobrandID>

	<cfset Variables.doControl = "payflow">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("cobrandID")>
	<cfset Variables.targetID = URL.cobrandID>
	<cfset Variables.urlParameters = "&cobrandID=#URL.cobrandID#">

	<cfset Variables.doControl = "commission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions,insertSalesCommission">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("cobrandID")>
	<cfset Variables.targetID = URL.cobrandID>
	<cfset Variables.urlParameters = "&cobrandID=#URL.cobrandID#">

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("cobrandID")>
	<cfset Variables.targetID = URL.cobrandID>

	<cfset Variables.userID = qry_selectCobrand.userID>
	<cfset Variables.companyID = qry_selectCobrand.companyID>
	<cfset Variables.vendorID = URL.cobrandID>
	<cfset Variables.urlParameters = "&cobrandID=#URL.cobrandID#">

	<cfset Variables.doControl = "contact">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_cobrand = "invalidAction">
	<cfinclude template="../../view/v_cobrand/error_cobrand.cfm">
</cfdefaultcase>
</cfswitch>
