<cfparam Name="URL.vendorID" Default="0">
<cfif URL.control is "company">
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">
<cfelse>
	<cfset Variables.urlParameters = "">
</cfif>

<!--- Enable user to go directly to vendor by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewVendor")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewVendor" and IsDefined("URL.submitView") and Trim(URL.vendorID) is not "">
	<cfinclude template="act_viewVendorByID.cfm">
</cfif>

<cfinclude template="security_vendor.cfm">
<cfinclude template="../../view/v_vendor/nav_vendor.cfm">
<cfif IsDefined("URL.confirm_vendor")>
	<cfinclude template="../../view/v_vendor/confirm_vendor.cfm">
</cfif>
<cfif IsDefined("URL.error_vendor")>
	<cfinclude template="../../view/v_vendor/error_vendor.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listVendors">
	<cfinclude template="control_listVendors.cfm">
</cfcase>

<cfcase value="listCompanyVendors">
	<cfif URL.control is "company">
		<cfinclude template="control_listCompanyVendors.cfm">
	<cfelse>
		<cfset URL.error_vendor = Variables.doAction>
		<cfinclude template="../../view/v_vendor/error_vendor.cfm">
	</cfif>
</cfcase>

<cfcase value="viewVendor">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_vendor/dsp_viewVendorByID.cfm">
		</cfif>
		<cfinclude template="control_viewVendor.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="viewFieldArchivesViaTarget" returnVariable="isViewed">
			<cfinvokeargument name="primaryTargetKey" value="vendorID">
			<cfinvokeargument name="targetID" value="#URL.vendorID#">
		</cfinvoke>

 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="vendorID">
				<cfinvokeargument name="targetID" value="#URL.vendorID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="vendorID">
				<cfinvokeargument name="targetID" value="#URL.vendorID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="insertVendor">
	<cfinclude template="control_insertVendor.cfm">
</cfcase>

<cfcase value="updateVendor">
	<cfinclude template="control_updateVendor.cfm">
</cfcase>

<cfcase value="listProducts">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("vendorID")>
	<cfset Variables.targetID = URL.vendorID>
	<cfset Variables.urlParameters = "&vendorID=#URL.vendorID#">

	<cfset Variables.doControl = "product">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("vendorID")>
	<cfset Variables.targetID = URL.vendorID>
	<cfset Variables.urlParameters = "&vendorID=#URL.vendorID#">

	<cfset Variables.doControl = "commission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions,insertSalesCommission">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("vendorID")>
	<cfset Variables.targetID = URL.vendorID>
	<cfset Variables.urlParameters = "&vendorID=#URL.vendorID#">

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="vendorID">
		<cfinvokeargument name="targetID" value="#URL.vendorID#">
		<cfinvokeargument name="urlParameters" value="&vendorID=#URL.vendorID#">
		<cfinvokeargument name="userID_target" value="#qry_selectVendor.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectVendor.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&vendorID=#URL.vendorID#">
		<cfinvokeargument name="primaryTargetKey" value="vendorID">
		<cfinvokeargument name="targetID" value="#URL.vendorID#">
		<cfinvokeargument name="userID_target" value="#qry_selectVendor.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectVendor.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("vendorID")>
	<cfset Variables.targetID = URL.vendorID>

	<cfset Variables.userID = qry_selectVendor.userID>
	<cfset Variables.companyID = qry_selectVendor.companyID>
	<cfset Variables.vendorID = URL.vendorID>
	<cfset Variables.urlParameters = "&vendorID=#URL.vendorID#">

	<cfset Variables.doControl = "contact">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_vendor = "invalidAction">
	<cfinclude template="../../view/v_vendor/error_vendor.cfm">
</cfdefaultcase>
</cfswitch>
