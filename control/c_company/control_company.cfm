<cfparam Name="URL.companyID" Default="0">
<cfset Variables.formAction = Variables.doURL & "&companyID=" & URL.companyID>

<cfif IsDefined("URL.userID") and URL.userID is not 0>
	<cfset Variables.realControl = "user">
<cfelseif IsDefined("URL.affiliateID") and URL.affiliateID is not 0>
	<cfset Variables.realControl = "affiliate">
<cfelseif IsDefined("URL.cobrandID") and URL.cobrandID is not 0>
	<cfset Variables.realControl = "cobrand">
<cfelseif IsDefined("URL.vendorID") and URL.vendorID is not 0>
	<cfset Variables.realControl = "vendor">
<cfelse>
	<cfset Variables.realControl = "company">
</cfif>

<!--- Enable user to go directly to company by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewCompany")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewCompany" and IsDefined("URL.submitView") and Trim(URL.companyID) is not "">
	<cfinclude template="act_viewCompanyByID.cfm">
</cfif>

<cfinclude template="security_company.cfm">
<cfinclude template="../../view/v_company/nav_company.cfm">
<cfif IsDefined("URL.confirm_company")>
	<cfinclude template="../../view/v_company/confirm_company.cfm">
</cfif>
<cfif IsDefined("URL.error_company")>
	<cfinclude template="../../view/v_company/error_company.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listCompanies">
	<cfinclude template="control_listCompanies.cfm">
</cfcase>

<cfcase value="insertCompany">
	<cfinclude template="control_insertCompany.cfm">
</cfcase>

<cfcase value="updateCompany">
	<cfinclude template="control_updateCompany.cfm">
</cfcase>

<cfcase value="viewCompany">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_company/dsp_viewCompanyByID.cfm">
		</cfif>
		<cfinclude template="control_viewCompany.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_fieldArchive.ViewFieldArchives" method="viewFieldArchivesViaTarget" returnVariable="isViewed">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#URL.companyID#">
		</cfinvoke>

 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="companyID">
				<cfinvokeargument name="targetID" value="#URL.companyID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="companyID">
				<cfinvokeargument name="targetID" value="#URL.companyID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="listUsers,viewUser,insertUser,updateUser,listGroupUser,insertGroupUser">
	<cfif URL.companyID is Session.companyID>
		<cfset Form.returnMyCompanyUsersOnly = 1>
	</cfif>
	<cfset Form.companyID = URL.companyID>
	<cfset Variables.doControl = "user">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listInvoices,insertInvoice,updateInvoice">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.doControl = "invoice">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listAddresses,listAddressesAll,viewAddress,insertAddress,updateAddressStatus0,updateAddressStatus1,updateAddressTypeBilling0,updateAddressTypeBilling1,updateAddressTypeShipping0,updateAddressTypeShipping1">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.doControl = "address">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listCreditCards,listCreditCardsAll,viewCreditCard,insertCreditCard,updateCreditCard,updateCreditCardStatus0,updateCreditCardStatus1,updateCreditCardRetain0,updateCreditCardRetain1,deleteCreditCard">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.doControl = "creditCard">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listBanks,listBanksAll,viewBank,insertBank,updateBank,updateBankStatus0,updateBankStatus1,updateBankRetain0,updateBankRetain1,deleteBank">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.doControl = "bank">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listPhones,listPhonesAll,insertPhone,updatePhoneStatus0,updatePhoneStatus1">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.doControl = "phone">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="insertPermissionTarget,viewPermissionTarget">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelseif qry_selectCompany.companyPrimary is 1 and Session.companyID is Application.billingSuperuserCompanyID and Application.billingSuperuserEnabled is True>
		<cfif Variables.doAction is "viewPermissionTarget">
			<cfset Variables.formAction = "">
		<cfelse>
			<cfset Variables.formAction = "index.cfm?method=#URL.method#&companyID=#URL.companyID#">
		</cfif>

		<cfset Variables.permissionControl = "company">
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("companyID")>
		<cfset Variables.targetID = URL.companyID>
		<cfset Variables.doControl = "permission">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset URL.error_company = "invalidAction">
		<cfinclude template="../../view/v_company/error_company.cfm">
	</cfif>
</cfcase>

<cfcase value="listCompanyVendors,insertVendor,updateVendor,viewVendor">
	<cfset Variables.doControl = "vendor">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCompanyAffiliates,insertAffiliate,updateAffiliate,viewAffiliate">
	<cfset Variables.doControl = "affiliate">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listCompanyCobrands,insertCobrand,updateCobrand,viewCobrand,insertCobrandHeader">
	<cfset Variables.doControl = "cobrand">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="insertGroupCompany,listGroupCompany">
	<cfinclude template="control_companyGroup.cfm">
</cfcase>

<cfcase value="listPrices">
	<cfswitch expression="#Variables.realControl#">
	<cfcase value="user">
		<cfset Variables.urlParameters = "&companyID=#URL.companyID#&userID=#URL.userID#">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	</cfcase>
	<cfcase value="affiliate">
		<cfset Variables.urlParameters = "&companyID=#URL.companyID#&affiliateID=#URL.affiliateID#">
		<cfset Variables.doControl = "affiliate">
		<cfinclude template="../control.cfm">
	</cfcase>
	<cfcase value="cobrand">
		<cfset Variables.urlParameters = "&companyID=#URL.companyID#&cobrandID=#URL.cobrandID#">
		<cfset Variables.doControl = "cobrand">
		<cfinclude template="../control.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfset Variables.urlParameters = "&companyID=#URL.companyID#">
		<cfset Variables.doControl = "price">
		<cfinclude template="../control.cfm">
	</cfdefaultcase>
	</cfswitch>
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<!--- 
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("companyID")>
		<cfset Variables.targetID = URL.companyID>
		--->
		<cfset Variables.primaryTargetID = 0>
		<cfset Variables.targetID = 0>

		<cfif IsDefined("URL.userID")>
			<cfset Variables.userID = URL.userID>
		<cfelse>
			<cfset Variables.userID = 0>
		</cfif>
		<cfset Variables.companyID = URL.companyID>
		<cfset Variables.urlParameters = "&companyID=#URL.companyID#">

		<cfset Variables.doControl = "contact">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfif Variables.realControl is not "company">
		<cfset Variables.doControl = Variables.realControl>
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
			<cfinvokeargument name="doControl" value="#URL.control#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="formAction" value="#Variables.formAction#">
			<cfinvokeargument name="primaryTargetKey" value="">
			<cfinvokeargument name="targetID" value="0">
			<cfinvokeargument name="urlParameters" value="&companyID=#URL.companyID#">
			<cfinvokeargument name="companyID_target" value="#URL.companyID#">
			<cfif IsDefined("URL.userID")>
				<cfinvokeargument name="userID_target" value="#URL.userID#">
			<cfelse>
				<cfinvokeargument name="userID_target" value="0">
			</cfif>
		</cfinvoke>
	</cfif>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfif Variables.realControl is not "company">
		<cfset Variables.doControl = Variables.realControl>
		<cfinclude template="../control.cfm">
	<cfelseif IsDefined("URL.userID") and URL.userID is not 0><!--- user --->
		<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="formAction" value="#Variables.formAction#">
			<cfinvokeargument name="urlParameters" value="&companyID=#URL.companyID#&userID=#URL.userID#">
			<cfinvokeargument name="primaryTargetKey" value="userID">
			<cfinvokeargument name="targetID" value="#URL.userID#">
			<cfinvokeargument name="userID_target" value="#URL.userID#">
			<cfinvokeargument name="companyID_target" value="#qry_selectCompany.companyID#">
		</cfinvoke>
	<cfelse><!--- company --->
		<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="formAction" value="#Variables.formAction#">
			<cfinvokeargument name="urlParameters" value="&companyID=#URL.companyID#">
			<cfinvokeargument name="primaryTargetKey" value="companyID">
			<cfinvokeargument name="targetID" value="#URL.companyID#">
			<cfinvokeargument name="userID_target" value="#qry_selectCompany.userID#">
			<cfinvokeargument name="companyID_target" value="#qry_selectCompany.companyID#">
		</cfinvoke>
	</cfif>
</cfcase>

<cfcase value="listSubscribers,insertSubscriber,updateSubscriber,listSubscriptions,insertSubscription,updateSubscription,viewSubscriptionsAll,updateSubscriptionStatus,moveSubscriptionUp,moveSubscriptionDown">
	<cfif Variables.realControl is "user">
		<cfset Variables.doControl = "user">
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("companyID")>
		<cfset Variables.targetID = URL.companyID>
		<cfset Variables.urlParameters = "&companyID=#URL.companyID#">

		<cfset Variables.doControl = "subscription">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="listPayments,viewPayment,insertPayment,updatePayment,listInvoicesForPayment,listPaymentsForInvoice,applyInvoicesToPayment,applyPaymentsToInvoice,deleteInvoicePayment">
	<cfset Variables.companyID = URL.companyID>
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">

	<cfset Variables.doControl = "payment">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPaymentRefunds,viewPaymentRefund,insertPaymentRefund,updatePaymentRefund">
	<cfset Variables.companyID = URL.companyID>
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">

	<cfset Variables.doControl = "payment">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPaymentCredits,viewPaymentCredit,insertPaymentCredit,updatePaymentCredit,listInvoicesForPaymentCredit,listPaymentCreditsForInvoice,updateInvoicePaymentCredit,deleteInvoicePaymentCredit">
	<cfset Variables.companyID = URL.companyID>
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">

	<cfset Variables.doControl = "paymentCredit">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="insertPayflowCompany,viewPayflowCompany">
	<cfset Variables.doControl = "payflow">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="insertPayflowTarget,viewPayflowTarget">
	<cfif ListFind("affiliate,cobrand", Variables.realControl)>
		<cfset Variables.doControl = Variables.realControl>
		<cfinclude template="../control.cfm">
	<cfelse>
		<cfset Variables.doAction = Replace(Variables.doAction, "Target", "Company", "ONE")>
		<cfset Variables.doControl = "payflow">
		<cfinclude template="../control.cfm">
	</cfif>
</cfcase>

<cfcase value="insertCommissionCustomer,updateCommissionCustomer,viewCommissionCustomer,updateCommissionCustomerStatus">
	<cfset Variables.doControl = "commission">
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions">
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#">
	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_company = "invalidAction">
	<cfinclude template="../../view/v_company/error_company.cfm">
</cfdefaultcase>
</cfswitch>

