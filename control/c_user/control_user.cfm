<cfparam Name="URL.userID" Default="0">
<cfif IsDefined("URL.companyID") and URL.control is "user">
	<cfset URL.companyID = Session.companyID>
</cfif>
<cfparam Name="URL.companyID" Default="#Session.companyID#">

<!--- Enable user to go directly to user by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewUser")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewUser" and IsDefined("URL.submitView") and Trim(URL.userID) is not "">
	<cfinclude template="act_viewUserByID.cfm">
</cfif>

<cfinclude template="security_user.cfm">
<cfinclude template="../../view/v_user/nav_user.cfm">
<cfif IsDefined("URL.confirm_user")>
	<cfinclude template="../../view/v_user/confirm_user.cfm">
</cfif>
<cfif IsDefined("URL.error_user")>
	<cfinclude template="../../view/v_user/error_user.cfm">
</cfif>

<cfif URL.userID is not 0 and (URL.companyID is Session.companyID or URL.companyID is 0)>
	<cfset URL.companyID = qry_selectUser.companyID>
</cfif>

<cfif URL.control is "company">
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#&userID=#URL.userID#">
<cfelse>
	<cfset Variables.urlParameters = "&userID=#URL.userID#">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listUsers">
	<cfinclude template="control_listUsers.cfm">
</cfcase>

<cfcase value="insertUser,updateUser">
	<cfinclude template="control_insertUpdateUser.cfm">
</cfcase>

<cfcase value="viewUser">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_user/dsp_viewUserByID.cfm">
		</cfif>
		<cfinclude template="control_viewUser.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="viewFieldArchivesViaTarget" returnVariable="isViewed">
			<cfinvokeargument name="primaryTargetKey" value="userID">
			<cfinvokeargument name="targetID" value="#URL.userID#">
		</cfinvoke>

 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="userID">
				<cfinvokeargument name="targetID" value="#URL.userID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="userID">
				<cfinvokeargument name="targetID" value="#URL.userID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="listAddresses,listAddressesAll,viewAddress,insertAddress,updateAddressStatus0,updateAddressStatus1,updateAddressTypeBilling0,updateAddressTypeBilling1,updateAddressTypeShipping0,updateAddressTypeShipping1">
	<cfset Variables.doControl = "address">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCreditCards,listCreditCardsAll,viewCreditCard,insertCreditCard,updateCreditCard,updateCreditCardStatus0,updateCreditCardStatus1,updateCreditCardRetain0,updateCreditCardRetain1,deleteCreditCard">
	<cfset Variables.doControl = "creditCard">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listBanks,listBanksAll,viewBank,insertBank,updateBank,updateBankStatus0,updateBankStatus1,updateBankRetain0,updateBankRetain1,deleteBank">
	<cfset Variables.doControl = "bank">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPhones,listPhonesAll,insertPhone,updatePhoneStatus0,updatePhoneStatus1">
	<cfset Variables.doControl = "phone">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listInvoices,insertInvoice,updateInvoice">
	<cfset Variables.doControl = "invoice">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listGroupUser,insertGroupUser">
	<cfinclude template="control_userGroup.cfm">
</cfcase>

<cfcase value="insertPermissionTarget,viewPermissionTarget">
	<cfif Variables.doAction is "viewPermissionTarget">
		<cfset Variables.formAction = "">
	<cfelseif URL.control is "company">
		<cfset Variables.formAction = "index.cfm?method=#URL.method#&companyID=#URL.companyID#&userID=#URL.userID#">
	<cfelse>
		<cfset Variables.formAction = "index.cfm?method=#URL.method#&userID=#URL.userID#">
	</cfif>

	<cfset Variables.permissionControl = "user">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("userID")>
	<cfset Variables.targetID = URL.userID>
	<cfset Variables.doControl = "permission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listUserCompany">
	<cfoutput><h1>List User Companies - Coming Soon</h1></cfoutput>
</cfcase>

<cfcase value="insertUserCompany">
	<cfoutput><h1>Add User to Companies - Coming Soon</h1></cfoutput>
</cfcase>

<cfcase value="listPrices">
	<cfset URL.control = "user">
	<cfset Variables.doControl = "price">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<!--- 
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("userID")>
	<cfset Variables.targetID = URL.userID>
	--->

	<cfset Variables.userID = URL.userID>
	<cfset Variables.companyID = qry_selectUser.companyID>

	<cfset Variables.doControl = "contact">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="primaryTargetKey" value="userID">
		<cfinvokeargument name="targetID" value="#URL.userID#">
		<cfinvokeargument name="urlParameters" value="&companyID=#URL.companyID#&userID=#URL.userID#">
		<cfinvokeargument name="userID_target" value="#URL.userID#">
		<cfinvokeargument name="companyID_target" value="#URL.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfset Variables.formAction = "index.cfm?method=#URL.control#.#Variables.doAction##Variables.urlParameters#">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfinvokeargument name="urlParameters" value="&userID=#URL.userID#">
		<cfinvokeargument name="primaryTargetKey" value="userID">
		<cfinvokeargument name="targetID" value="#URL.userID#">
		<cfinvokeargument name="userID_target" value="#URL.userID#">
		<cfinvokeargument name="companyID_target" value="#URL.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listSubscribers,insertSubscriber,updateSubscriber,listSubscriptions,insertSubscription,updateSubscription,viewSubscriptionsAll,updateSubscriptionStatus,moveSubscriptionUp,moveSubscriptionDown">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("userID")>
	<cfset Variables.targetID = URL.userID>

	<cfset Variables.doControl = "subscription">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCommissions,viewCommissionCustomer,updateCommissionCustomer,updateCommissionCustomerStatus">
	<cfif qry_selectUser.companyID is not Session.companyID_author>
		<cfset URL.error_user = Variables.doAction>
		<cfinclude template="../../view/v_user/error_user.cfm">
	<cfelse>
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("userID")>
		<cfset Variables.targetID = URL.userID>

		<cfset Variables.doControl = "commission">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listSalesCommissions,insertSalesCommission">
	<cfif qry_selectUser.companyID is not Session.companyID_author>
		<cfset URL.error_user = Variables.doAction>
		<cfinclude template="../../view/v_user/error_user.cfm">
	<cfelse>
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("userID")>
		<cfset Variables.targetID = URL.userID>

		<!--- set userID and companyID to 0 since we want to view sales commission paid to this user, not sales commission paid for invoices from this company/user --->
		<cfset URL.userID = "">
		<cfset URL.companyID = "">

		<cfset Variables.doControl = "salesCommission">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listLoginSessions">
	<cfinvoke component="#Application.billingMapping#control.c_loginSession.ListLoginSessions" method="listLoginSessions" returnVariable="isSessionsListed">
		<cfinvokeargument name="companyID" value="#Session.companyID#">
		<cfinvokeargument name="formAction" value="index.cfm?method=user.viewLoginSessionsForUser">
	</cfinvoke>
</cfcase>
<cfcase value="viewLoginSessionsForUser">
	<cfinvoke component="#Application.billingMapping#control.c_loginSession.ListLoginSessions" method="viewLoginSessionsForUser" returnVariable="isSessionsListed">
		<cfinvokeargument name="userID" value="#URL.userID#">
		<cfinvokeargument name="formAction" value="index.cfm?method=user.viewLoginSessionsForUser&companyID=#URL.companyID#&userID=#URL.userID#">
	</cfinvoke>
</cfcase>
<cfcase value="viewUserActivityReport">
	<cfinvoke component="#Application.billingMapping#control.c_loginSession.UserActivityReport" method="viewUserActivityReport" returnVariable="isUserActivity">
		<cfinvokeargument name="userID" value="#URL.userID#">
		<cfinvokeargument name="formAction" value="index.cfm?method=user.viewUserActivityReport&companyID=#URL.companyID#&userID=#URL.userID#">
		<cfif IsDefined("URL.loginSessionID") and Application.fn_IsIntegerPositive(URL.loginSessionID)>
			<cfinvokeargument name="loginSessionID" value="#URL.loginSessionID#">
		</cfif>
	</cfinvoke>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_user = "invalidAction">
	<cfinclude template="../../view/v_user/error_user.cfm">
</cfdefaultcase>
</cfswitch>

