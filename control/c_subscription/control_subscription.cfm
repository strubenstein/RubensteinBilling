<cfparam Name="URL.subscriberID" Default="0">
<cfparam Name="URL.companyID" Default="0">
<cfparam Name="URL.userID" Default="0">

<cfset Variables.formAction = "index.cfm?method=#URL.control#.#URL.action#">
<cfif URL.control is "company" and URL.companyID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&companyID=#URL.companyID#">
</cfif>
<cfif ListFind("user,company", URL.control) and URL.userID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&userID=#URL.userID#">
</cfif>
<cfset Variables.subscriptionActionList = Replace(Variables.formAction, URL.action, "listSubscribers", "ONE")>

<!--- Enable user to go directly to subscriber by entering ID or custom ID --->
<cfset Variables.isViewPermission = Application.fn_IsUserAuthorized("viewSubscriber")>
<cfset Variables.displayViewByIDList = False>
<cfif Variables.doAction is "viewSubscriber" and IsDefined("URL.submitView") and Trim(URL.subscriberID) is not "">
	<cfinclude template="act_viewSubscriberByID.cfm">
</cfif>

<cfif URL.subscriberID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&subscriberID=" & URL.subscriberID>
</cfif>

<cfparam Name="URL.displaySubscriberSpecial" Default="">

<cfinclude template="security_subscriber.cfm">
<cfinclude template="security_subscription.cfm">
<cfinclude template="../../view/v_subscription/nav_subscription.cfm">
<cfif IsDefined("URL.confirm_subscription")>
	<cfinclude template="../../view/v_subscription/confirm_subscription.cfm">
</cfif>
<cfif IsDefined("URL.error_subscription")>
	<cfinclude template="../../view/v_subscription/error_subscription.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listSubscribers">
	<cfinclude template="control_listSubscribers.cfm">
</cfcase>

<cfcase value="insertSubscriber,updateSubscriber">
	<!--- Must be coming from company or user --->
 	<cfinclude template="control_insertUpdateSubscriber.cfm">
</cfcase>

<cfcase value="viewSubscriber">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfif Variables.displayViewByIDList is True>
			<cfinclude template="../../view/v_subscription/dsp_viewSubscriberByID.cfm">
		</cfif>
		<cfinclude template="control_viewSubscriber.cfm">
	<cfelseif Not Application.fn_IsUserAuthorized("viewCustomFieldValuesAll") and Not Application.fn_IsUserAuthorized("listStatusHistory")>
		<cfset URL.error_subscription = "invalidAction">
		<cfinclude template="../../view/v_subscription/error_subscription.cfm">
	<cfelse>
 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="subscriberID">
				<cfinvokeargument name="targetID" value="#URL.subscriberID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="subscriberID">
				<cfinvokeargument name="targetID" value="#URL.subscriberID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="updateSubscriberNotify,viewSubscriberNotify">
	<cfinclude template="control_updateSubscriberNotify.cfm">
</cfcase>

<cfcase value="insertSubscriberNotify">
	<cfinclude template="control_insertSubscriberNotify.cfm">
</cfcase>

<cfcase value="viewSubscriptions,viewSubscriptionsAll">
	<cfinclude template="control_viewSubscriptions.cfm">
</cfcase>

<cfcase value="viewSubscription">
	<cfif Not IsDefined("URL.viewFieldArchives") or URL.viewFieldArchives is not True>
		<cfinclude template="control_viewSubscription.cfm">
	<cfelseif Not Application.fn_IsUserAuthorized("viewCustomFieldValuesAll") and Not Application.fn_IsUserAuthorized("listStatusHistory")>
		<cfset URL.error_subscription = "invalidAction">
		<cfinclude template="../../view/v_subscription/error_subscription.cfm">
	<cfelse>
 		<cfif Application.fn_IsUserAuthorized("viewCustomFieldValuesAll")>
			<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
				<cfinvokeargument name="companyID" value="#Session.companyID_author#">
				<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
				<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
			</cfinvoke>
		</cfif>

		<cfif Application.fn_IsUserAuthorized("listStatusHistory")>
			<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
				<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
				<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
			</cfinvoke>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="insertSubscription,updateSubscription">
	<cfinclude template="control_insertSubscription.cfm">
</cfcase>

<cfcase value="updateSubscriptionStatus">
	<cfinclude template="control_updateSubscriptionStatus.cfm">
</cfcase>

<cfcase value="moveSubscriptionUp,moveSubscriptionDown">
	<cfinvoke Component="#Application.billingMapping#data.Subscription" Method="switchSubscriptionOrder" ReturnVariable="isSubscriptionSwitched">
		<cfinvokeargument Name="subscriptionID" Value="#URL.subscriptionID#">
		<cfinvokeargument Name="subscriptionOrder_direction" Value="#Variables.doAction#">
	</cfinvoke>

	<cflocation url="index.cfm?method=subscription.viewSubscriptions&subscriberID=#URL.subscriberID#&confirm_subscription=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updateSubscriptionProcess">
	<cfinclude template="c_subscriptionProcess/control_updateSubscriptionProcess.cfm">
</cfcase>

<cfcase value="processSubscriber">
	<cfif Not IsDate(qry_selectSubscriber.subscriberDateProcessNext)>
		<cfset URL.error_subscription = "processSubscriber_notScheduled">
		<cfinclude template="../../view/v_subscription/error_subscription.cfm">
	<cfelseif DateCompare(CreateDateTime(Year(qry_selectSubscriber.subscriberDateProcessNext), Month(qry_selectSubscriber.subscriberDateProcessNext), Day(qry_selectSubscriber.subscriberDateProcessNext), 00, 00, 00), CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 00, 00, 00)) is 1>
		<cfset URL.error_subscription = "processSubscriber_beforeDate">
		<cfinclude template="../../view/v_subscription/error_subscription.cfm">
	<cfelse>
		<cfset Variables.subscriberID = URL.subscriberID>
		<cfinclude template="c_subscriptionProcess/control_processSubscriber.cfm">
		<cfif IsDefined("Variables.isSubscriptionOkToProcess") and Variables.isSubscriptionOkToProcess is True>
			<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&confirm_subscription=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cfset URL.error_subscription = "processSubscriber_other">
			<cfinclude template="../../view/v_subscription/error_subscription.cfm">
		</cfif>
	</cfif>
</cfcase>

<cfcase value="listNotes,insertNote,updateNote">
	<cfinvoke component="#Application.billingMapping#control.c_note.ControlNote" method="controlNote" returnVariable="isNotesListed">
		<cfinvokeargument name="doControl" value="#URL.control#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfif IsDefined("URL.subscriptionID") and Application.fn_IsIntegerPositive(URL.subscriptionID)><!--- subscription --->
			<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
			<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
			<cfinvokeargument name="urlParameters" value="&subscriberID=#URL.subscriberID#&subscriptionID=#URL.subscriptionID#">
		<cfelse><!--- subscriber --->
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#URL.subscriberID#">
			<cfinvokeargument name="urlParameters" value="&subscriberID=#URL.subscriberID#">
		</cfif>
		<cfinvokeargument name="userID_target" value="#qry_selectSubscriber.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectSubscriber.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="listTasks,insertTask,updateTask,updateTaskFromList">
	<cfinvoke component="#Application.billingMapping#control.c_task.ControlTask" method="controlTask" returnVariable="isTask">
		<cfinvokeargument name="doControl" value="#Variables.doControl#">
		<cfinvokeargument name="doAction" value="#Variables.doAction#">
		<cfinvokeargument name="formAction" value="#Variables.formAction#">
		<cfif IsDefined("URL.subscriptionID") and Application.fn_IsIntegerPositive(URL.subscriptionID)><!--- subscription --->
			<cfinvokeargument name="urlParameters" value="&subscriberID=#URL.subscriberID#&subscriptionID=#URL.subscriptionID#">
			<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
			<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
		<cfelse>
			<cfinvokeargument name="urlParameters" value="&subscriberID=#URL.subscriberID#">
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#URL.subscriberID#">
		</cfif>
		<cfinvokeargument name="userID_target" value="#qry_selectSubscriber.userID#">
		<cfinvokeargument name="companyID_target" value="#qry_selectSubscriber.companyID#">
	</cfinvoke>
</cfcase>

<cfcase value="viewCustomFieldValuesAll">
	<cfif IsDefined("URL.subscriptionID") and Application.fn_IsIntegerPositive(URL.subscriptionID)><!--- subscription --->
		<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
			<cfinvokeargument name="companyID" value="#Session.companyID_author#">
			<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
			<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
		</cfinvoke>
	<cfelse><!--- subscriber --->
		<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValueHistory" returnVariable="isCustomFieldHistory">
			<cfinvokeargument name="companyID" value="#Session.companyID_author#">
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#URL.subscriberID#">
		</cfinvoke>
	</cfif>
</cfcase>

<cfcase value="listStatusHistory">
	<cfif IsDefined("URL.subscriptionID") and Application.fn_IsIntegerPositive(URL.subscriptionID)><!--- subscription --->
		<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
			<cfinvokeargument name="primaryTargetKey" value="subscriptionID">
			<cfinvokeargument name="targetID" value="#URL.subscriptionID#">
		</cfinvoke>
	<cfelse><!--- subscriber --->
		<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistory">
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#URL.subscriberID#">
		</cfinvoke>
	</cfif>
</cfcase>

<cfcase value="listInvoices,insertInvoice,updateInvoice">
	<cfset URL.companyID = qry_selectSubscriber.companyID>

	<cfset Variables.doControl = "invoice">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPayments,viewPayment,insertPayment,updatePayment,listInvoicesForPayment,listPaymentsForInvoice,applyInvoicesToPayment,applyPaymentsToInvoice,deleteInvoicePayment">
	<cfset Variables.companyID = URL.companyID>
	<cfset Variables.subscriberID = URL.subscriberID>
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#&subscriberID=#URL.subscriberID#">

	<cfset Variables.doControl = "payment">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPaymentRefunds,viewPaymentRefund,insertPaymentRefund,updatePaymentRefund">
	<cfset Variables.companyID = URL.companyID>
	<cfset Variables.subscriberID = URL.subscriberID>
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#&subscriberID=#URL.subscriberID#">

	<cfset Variables.doControl = "payment">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listPaymentCredits,viewPaymentCredit,insertPaymentCredit,updatePaymentCredit,listInvoicesForPaymentCredit,listPaymentCreditsForInvoice,updateInvoicePaymentCredit,deleteInvoicePaymentCredit">
	<cfset Variables.companyID = URL.companyID>
	<cfset Variables.subscriberID = URL.subscriberID>
	<cfset Variables.urlParameters = "&companyID=#URL.companyID#&subscriberID=#URL.subscriberID#">

	<cfset Variables.doControl = "paymentCredit">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="insertCommissionCustomer,updateCommissionCustomer,viewCommissionCustomer,updateCommissionCustomerStatus">
	<cfset URL.companyID = qry_selectSubscriber.companyID>

	<cfset Variables.doControl = "commission">
	<cfset Variables.urlParameters = "&subscriberID=#URL.subscriberID#">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listSalesCommissions">
	<cfset Variables.companyID = qry_selectSubscriber.companyID>
	<cfset Variables.subscriberID = URL.subscriberID>
	<cfset Variables.urlParameters = "&subscriberID=#URL.subscriberID#">

	<cfif IsDefined("URL.subscriptionID") and Application.fn_IsIntegerPositive(URL.subscriptionID)>
		<cfset Variables.subscriptionID = URL.subscriptionID>
		<cfset Variables.productID = qry_selectSubscription.productID>
		<cfset Variables.urlParameters = Variables.urlParameters & "&subscriptionID=#URL.subscriptionID#">
	<cfelse>
		<cfset Variables.subscriptionID = 0>
	</cfif>

	<cfset Variables.doControl = "salesCommission">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="listContacts,insertContact,updateContact,viewContact">
	<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("subscriberID")>
	<cfset Variables.targetID = URL.subscriberID>

	<cfset Variables.userID = qry_selectSubscriber.userID>
	<cfset Variables.companyID = qry_selectSubscriber.companyID>
	<cfset Variables.subscriberID = URL.subscriberID>
	<cfset Variables.urlParameters = "&subscriberID=#URL.subscriberID#">

	<cfset Variables.doControl = "contact">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_subscription = "invalidAction">
	<cfinclude template="../../view/v_subscription/error_subscription.cfm">
</cfdefaultcase>
</cfswitch>

