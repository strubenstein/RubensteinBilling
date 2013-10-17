<cfparam Name="URL.affiliateID" Default="0">
<cfif URL.control is "company">
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">
<cfelse>
	<cfset Variables.urlParameters = "">
</cfif>

<!--- Enable user to go directly to affiliate by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewAffiliate")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewAffiliate" and IsDefined("URL.submitView") and Trim(URL.affiliateID) is not "">
	<cfinclude template="act_viewAffiliateByID.cfm">
</cfif>

<cfinclude template="security_affiliate.cfm">
<cfinclude template="../../view/v_affiliate/nav_affiliate.cfm">
<cfif IsDefined("URL.confirm_affiliate")>
	<cfinclude template="../../view/v_affiliate/confirm_affiliate.cfm">
</cfif>
<cfif IsDefined("URL.error_affiliate")>
	<cfinclude template="../../view/v_affiliate/error_affiliate.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listAffiliates">
	<cfinclude template="control_listAffiliates.cfm">
</cfcase>

<cfcase value="viewAffiliate">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_affiliate/dsp_viewAffiliateByID.cfm">
		</cfif>
		<cfinclude template="control_viewAffiliate.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="viewFieldArchivesViaTarget" returnVariable="isViewed">
			<cfinvokeargument name="primaryTargetKey" value="affiliateID">
			<cfinvokeargument name="targetID" value="#URL.affiliateID#">
		</cfinvoke>

 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="affiliateID">
				<cfinvokeargument name="targetID" value="#URL.affiliateID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="affiliateID">
				<cfinvokeargument name="targetID" value="#URL.affiliateID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="listCompanyAffiliates">
	<cfif URL.control is "company">
		<cfinclude template="control_listCompanyAffiliates.cfm">
	<cfelse>
		<cfset URL.error_affiliate = Variables.doAction>
		<cfinclude template="../../view/v_affiliate/error_affiliate.cfm">
	</cfif>
</cfcase>

<cfcase value="insertAffiliate">
	<cfinclude template="control_insertAffiliate.cfm">
</cfcase>

<cfcase value="updateAffiliate">
	<cfinclude template="control_updateAffiliate.cfm">
</cfcase>

<cfcase value="listPrices">
	<cfif URL.control is "affiliate">
		<cfset Variables.urlParameters = "&affiliateID=#URL.affiliateID#">
	</cfif>
	<cfset Variables.doControl = "price">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="affiliateID">
		<cfinvokeargument name="targetID" value="#URL.affiliateID#">
		<cfinvokeargument name="urlParameters" value="&affiliateID=#URL.affiliateID#">
		<cfinvokeargument name="userID_target" value="#qry_selectAffiliate.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectAffiliate.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&affiliateID=#URL.affiliateID#">
		<cfinvokeargument name="primaryTargetKey" value="affiliateID">
		<cfinvokeargument name="targetID" value="#URL.affiliateID#">
		<cfinvokeargument name="userID_target" value="#qry_selectAffiliate.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectAffiliate.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="insertPayflowTarget,viewPayflowTarget">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("affiliateID")>
	<cfset Variables.targetID = URL.affiliateID>

	<cfset Variables.doControl = "payflow">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCommissions">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("affiliateID")>
	<cfset Variables.targetID = URL.affiliateID>
	<cfset Variables.urlParameters = "&affiliateID=#URL.affiliateID#">

	<cfset Variables.doControl = "commission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions,insertSalesCommission">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("affiliateID")>
	<cfset Variables.targetID = URL.affiliateID>
	<cfset Variables.urlParameters = "&affiliateID=#URL.affiliateID#">

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("affiliateID")>
	<cfset Variables.targetID = URL.affiliateID>

	<cfset Variables.userID = qry_selectAffiliate.userID>
	<cfset Variables.companyID = qry_selectAffiliate.companyID>
	<cfset Variables.vendorID = URL.affiliateID>
	<cfset Variables.urlParameters = "&affiliateID=#URL.affiliateID#">

	<cfset Variables.doControl = "contact">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_affiliate = "invalidAction">
	<cfinclude template="../../view/v_affiliate/error_affiliate.cfm">
</cfdefaultcase>
</cfswitch>
