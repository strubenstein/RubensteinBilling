<cfif IsDefined("URL.confirm_adminMain")>
	<cfinclude template="../../view/v_adminMain/confirm_adminMain.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="fakeMain">
	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("listContacts,listTasks,listInvoices,listSubscribers,listPayments,listPaymentRefunds,listPaymentCredits")>
	<cfinclude template="qry_fakeAdminHomepageData.cfm">

	<cfset Variables.chartFile = "dsp_adminMainChart_cfmx.cfm">

	<cfinclude template="../../view/v_adminMain/header_fakeMain.cfm">
	<cfinclude template="../../view/v_adminMain/dsp_adminMain.cfm">
</cfcase>

<cfcase value="main">
	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("listContacts,listTasks,listInvoices,listSubscribers,listPayments,listPaymentRefunds,listPaymentCredits")>

	<cfif Session.affiliateID_list is not 0 and Session.cobrandID_list is not 0>
		<cfset Variables.qryParam_affCob = "AND (avCompany.affiliateID IN (#Session.affiliateID_list#) OR avCompany.cobrandID IN (#Session.cobrandID_list#))">
	<cfelseif Session.affiliateID_list is not 0>
		<cfset Variables.qryParam_affCob = "AND avCompany.affiliateID IN (#Session.affiliateID_list#)">
	<cfelseif Session.cobrandID_list is not 0>
		<cfset Variables.qryParam_affCob = "AND avCompany.cobrandID IN (#Session.cobrandID_list#)">
	<cfelse>
		<cfset Variables.qryParam_affCob = "">
	</cfif>

	<!--- get user company name, first and last name --->
	<cfinclude template="qry_selectAdminMain_user.cfm">

	<cfif ListFind(Variables.permissionActionList, "listTasks")>
		<!--- select open tasks for the user from today or earlier --->
		<cfinclude template="qry_selectAdminMain_task.cfm">
		<cfloop Query="qry_selectAdminMain_task">
			<cfset temp = QuerySetCell(qry_selectAdminMain_task, "taskDateScheduled", ToString(qry_selectAdminMain_task.taskDateScheduled), qry_selectAdminMain_task.CurrentRow)>
		</cfloop>
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listContacts")>
		<!--- get contact mgmt topics with new messages submitted by customers that have not been responded to --->
		<cfinclude template="qry_selectAdminMain_contact.cfm">
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listInvoices")>
		<!--- select invoices closed in last 7 days --->
		<cfinclude template="qry_selectAdminMain_invoice.cfm">
		<cfloop Query="qry_selectAdminMain_invoice">
			<cfset temp = QuerySetCell(qry_selectAdminMain_invoice, "invoiceDateClosed", ToString(qry_selectAdminMain_invoice.invoiceDateClosed), qry_selectAdminMain_invoice.CurrentRow)>
		</cfloop>

		<!--- select ## of closed invoices that are not paid --->
		<cfinclude template="qry_selectAdminMain_invoiceUnpaid.cfm">
		<cfloop Query="qry_selectAdminMain_invoiceUnpaid">
			<cfset temp = QuerySetCell(qry_selectAdminMain_invoiceUnpaid, "invoiceDateClosed", ToString(qry_selectAdminMain_invoiceUnpaid.invoiceDateClosed), qry_selectAdminMain_invoiceUnpaid.CurrentRow)>
		</cfloop>
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listSubscribers")>
		<!--- Subscribers processed within the past week --->
		<cfinclude template="qry_selectAdminMain_subscriberProcessed.cfm">
		<cfloop Query="qry_selectAdminMain_subscriberProcessed">
			<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberProcessed, "subscriberProcessDate", ToString(qry_selectAdminMain_subscriberProcessed.subscriberProcessDate), qry_selectAdminMain_subscriberProcessed.CurrentRow)>
		</cfloop>

		<!--- Subscribers scheduled to be processed within the coming week --->
		<cfinclude template="qry_selectAdminMain_subscriberScheduled.cfm">
		<cfloop Query="qry_selectAdminMain_subscriberScheduled">
			<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberScheduled, "subscriberDateProcessNext", ToString(qry_selectAdminMain_subscriberScheduled.subscriberDateProcessNext), qry_selectAdminMain_subscriberScheduled.CurrentRow)>
		</cfloop>

		<!--- Subscribers waiting for final quantities to be processed --->
		<cfinclude template="qry_selectAdminMain_subscriberQuantity.cfm">
		<cfloop Query="qry_selectAdminMain_subscriberQuantity">
			<cfset temp = QuerySetCell(qry_selectAdminMain_subscriberQuantity, "subscriberProcessDate", ToString(qry_selectAdminMain_subscriberQuantity.subscriberProcessDate), qry_selectAdminMain_subscriberQuantity.CurrentRow)>
		</cfloop>
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listPayments")>
		<!--- Payments successfully processed within the past week --->
		<cfinclude template="qry_selectAdminMain_paymentSuccess.cfm">
		<cfloop Query="qry_selectAdminMain_paymentSuccess">
			<cfset temp = QuerySetCell(qry_selectAdminMain_paymentSuccess, "paymentDateReceived", ToString(qry_selectAdminMain_paymentSuccess.paymentDateReceived), qry_selectAdminMain_paymentSuccess.CurrentRow)>
		</cfloop>

		<!--- Payments rejected within the past week --->
		<cfinclude template="qry_selectAdminMain_paymentReject.cfm">
		<cfloop Query="qry_selectAdminMain_paymentReject">
			<cfset temp = QuerySetCell(qry_selectAdminMain_paymentReject, "paymentDateReceived", ToString(qry_selectAdminMain_paymentReject.paymentDateReceived), qry_selectAdminMain_paymentReject.CurrentRow)>
		</cfloop>

		<!--- Payments scheduled to be made within the coming week --->
		<cfinclude template="qry_selectAdminMain_paymentScheduled.cfm">
		<cfloop Query="qry_selectAdminMain_paymentScheduled">
			<cfset temp = QuerySetCell(qry_selectAdminMain_paymentScheduled, "paymentDateScheduled", ToString(qry_selectAdminMain_paymentScheduled.paymentDateScheduled), qry_selectAdminMain_paymentScheduled.CurrentRow)>
		</cfloop>
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listPaymentRefunds")>
		<!--- Refunds processed within the past week --->
		<cfinclude template="qry_selectAdminMain_paymentRefund.cfm">
		<cfloop Query="qry_selectAdminMain_paymentRefund">
			<cfset temp = QuerySetCell(qry_selectAdminMain_paymentRefund, "paymentDateReceived", ToString(qry_selectAdminMain_paymentRefund.paymentDateReceived), qry_selectAdminMain_paymentRefund.CurrentRow)>
		</cfloop>
	</cfif>

	<cfif ListFind(Variables.permissionActionList, "listPaymentCredits")>
		<!--- Credits created within the past week --->
		<cfinclude template="qry_selectAdminMain_paymentCreditCreated.cfm">
		<cfloop Query="qry_selectAdminMain_paymentCreditCreated">
			<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditCreated, "paymentCreditDateCreated", ToString(qry_selectAdminMain_paymentCreditCreated.paymentCreditDateCreated), qry_selectAdminMain_paymentCreditCreated.CurrentRow)>
		</cfloop>

		<!--- Credits processed within the past week --->
		<cfinclude template="qry_selectAdminMain_paymentCreditProcessed.cfm">
		<cfloop Query="qry_selectAdminMain_paymentCreditProcessed">
			<cfset temp = QuerySetCell(qry_selectAdminMain_paymentCreditProcessed, "invoicePaymentCreditDate", ToString(qry_selectAdminMain_paymentCreditProcessed.invoicePaymentCreditDate), qry_selectAdminMain_paymentCreditProcessed.CurrentRow)>
		</cfloop>
	</cfif>

	<cfset Variables.chartFile = "dsp_adminMainChart_cfmx.cfm">

	<cfinclude template="../../view/v_adminMain/dsp_adminMain.cfm">
</cfcase>

<cfcase value="setup">
	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("listContactTopics,listContactTemplates,listStatuses,listCustomFields,listTemplates,listPermissionCategories,listPrimaryTargets,listPayflows,listImageDirectories,listMerchants,listMerchantAccounts,listContentCategories,listGroups,listCategories,listPaymentCategories,listSchedulers,listIPaddresses,listCommissions,listLoginAttempts,listPrices,insertCompany,insertUser,insertAffiliate,insertCobrand,insertVendor,insertProduct,insertInvoice,insertInvoiceLineItem,listTriggerActions,listExportTables")>
	<cfif (StructKeyExists(Session, "isSetupPermission") and Session.isSetupPermission is True) or Variables.permissionActionList is not "">
		<cfinclude template="../../view/v_adminMain/dsp_adminMain_setup.cfm">
		<cfinclude template="../../view/v_adminMain/dsp_adminMain_custom.cfm">
	<cfelse>
		<cfset URL.error_admin = "noSetupPermission">
		<cfinclude template="../../view/v_adminMain/error_admin.cfm">
	</cfif>
</cfcase>

<cfcase value="listLoginAttempts">
	<cfinvoke Component="#Application.billingMapping#data.LoginAttempt" Method="selectLoginAttemptList" ReturnVariable="qry_selectLoginAttemptList">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	</cfinvoke>

	<cfinclude template="../../view/v_adminMain/lang_listLoginAttempts.cfm">

	<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("deleteLoginAttempt")>
	<cfset Variables.columnHeaderList = Variables.lang_listLoginAttempts_title.loginAttemptUsername
			& "^" & Variables.lang_listLoginAttempts_title.loginAttemptCount
			& "^" & Variables.lang_listLoginAttempts_title.loginAttemptDateCreated
			& "^" & Variables.lang_listLoginAttempts_title.loginAttemptDateUpdated
			& "^" & Variables.lang_listLoginAttempts_title.userID>

	<cfif ListFind(Variables.permissionActionList, "deleteLoginAttempt")>
		<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_listLoginAttempts_title.deleteLoginAttempt>
	</cfif>

	<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

	<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
	<cfinclude template="../../view/v_adminMain/dsp_selectLoginAttemptList.cfm">
</cfcase>

<cfcase value="deleteLoginAttempt">
	<cfif Not IsDefined("URL.loginAttemptUsername") or Trim(URL.loginAttemptUsername) is "">
		<cfset URL.error_admin = Variables.doAction>
		<cfinclude template="../../view/v_adminMain/error_admin.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.LoginAttempt" Method="deleteLoginAttempt" ReturnVariable="isLoginAttemptDeleted">
			<cfinvokeargument Name="loginAttemptID" Value="0">
			<cfinvokeargument Name="loginAttemptUsername" Value="#URL.loginAttemptUsername#">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID#">
		</cfinvoke>

		<cflocation url="index.cfm?method=admin.listLoginAttempts&confirm_adminMain=#Variables.doAction#" AddToken="No">
	</cfif>
</cfcase>

<cfdefaultcase>
	<cfset URL.error_admin = "invalidAction">
	<cfinclude template="../../view/v_adminMain/error_admin.cfm">
</cfdefaultcase>
</cfswitch>

