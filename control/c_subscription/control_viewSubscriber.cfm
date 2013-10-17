<!--- 
get company and user
get subscriptions ? summary data?
get notification options
get payment options
get status
--->

<!--- author, canceller --->
<cfset Variables.subscriberUserID_list = qry_selectSubscriber.userID>
<cfif qry_selectSubscriber.userID_author is not 0>
	<cfset Variables.subscriberUserID_list = ListAppend(Variables.subscriberUserID_list, qry_selectSubscriber.userID_author)>
</cfif>
<cfif qry_selectSubscriber.userID_cancel is not 0>
	<cfset Variables.subscriberUserID_list = ListAppend(Variables.subscriberUserID_list, qry_selectSubscriber.userID_cancel)>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
	<cfinvokeargument Name="userID" Value="#Variables.subscriberUserID_list#">
</cfinvoke>

<cfset Variables.userAuthorRow = 0>
<cfset Variables.userCancelRow = 0>
<cfset Variables.userRow = 0>

<cfloop Query="qry_selectUserList">
	<cfif qry_selectUserList.userID is qry_selectSubscriber.userID>
		<cfset Variables.userRow = CurrentRow>
	<cfelseif qry_selectUserList.userID is qry_selectSubscriber.userID_author>
		<cfset Variables.userAuthorRow = CurrentRow>
	<cfelse>
		<cfset Variables.userCancelRow = CurrentRow>
	</cfif>
</cfloop>

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
</cfinvoke>

<!--- get billing and shipping addresses --->
<cfset Variables.addressID_list = "">
<cfif qry_selectSubscriber.addressID_billing is not 0>
	<cfset Variables.addressID_list = ListAppend(Variables.addressID_list, qry_selectSubscriber.addressID_billing)>
</cfif>
<cfif qry_selectSubscriber.addressID_shipping is not 0>
	<cfset Variables.addressID_list = ListAppend(Variables.addressID_list, qry_selectSubscriber.addressID_shipping)>
</cfif>

<cfif Variables.addressID_list is not "">
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
		<cfinvokeargument Name="addressID" Value="#Variables.addressID_list#">
	</cfinvoke>
</cfif>

<!--- payment options --->
<cfinvoke Component="#Application.billingMapping#data.SubscriberPayment" Method="selectSubscriberPaymentList" ReturnVariable="qry_selectSubscriberPaymentList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<cfinvokeargument Name="subscriberPaymentStatus" Value="1">
</cfinvoke>

<cfset Variables.displayBank = False>
<cfset Variables.displayCreditCard = False>

<cfif qry_selectSubscriberPaymentList.RecordCount is not 0>
	<cfset Variables.displayBankID = "">
	<cfset Variables.displayCreditCardID = "">

	<cfloop Query="qry_selectSubscriberPaymentList">
		<cfif qry_selectSubscriberPaymentList.bankID is not 0 and Not ListFind(Variables.displayBankID, qry_selectSubscriberPaymentList.bankID)>
			<cfset Variables.displayBankID = ListAppend(Variables.displayBankID, qry_selectSubscriberPaymentList.bankID)>
		</cfif>
		<cfif qry_selectSubscriberPaymentList.creditCardID is not 0 and Not ListFind(Variables.displayCreditCardID, qry_selectSubscriberPaymentList.creditCardID)>
			<cfset Variables.displayCreditCardID = ListAppend(Variables.displayCreditCardID, qry_selectSubscriberPaymentList.creditCardID)>
		</cfif>
	</cfloop>

	<cfif Variables.displayBankID is not "">
		<cfinvoke Component="#Application.billingMapping#data.Bank" Method="selectBankList" ReturnVariable="qry_selectBankList">
			<cfinvokeargument Name="bankID" Value="#Variables.displayBankID#">
		</cfinvoke>
		<cfif qry_selectBankList.RecordCount is not 0>
			<cfset Variables.displayBank = True>
		</cfif>
	</cfif>

	<cfif Variables.displayCreditCardID is not "">
		<cfinvoke Component="#Application.billingMapping#data.CreditCard" Method="selectCreditCardList" ReturnVariable="qry_selectCreditCardList">
			<cfinvokeargument Name="creditCardID" Value="#Variables.displayCreditCardID#">
		</cfinvoke>
		<cfif qry_selectCreditCardList.RecordCount is not 0>
			<cfset Variables.displayCreditCard = True>
		</cfif>
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="selectSubscriberNotifyList" ReturnVariable="qry_selectSubscriberNotifyList">
	<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
	<cfinvokeargument Name="subscriberNotifyStatus" Value="1">
</cfinvoke>

<cfset Variables.displayCobrand = False>
<cfif qry_selectCompany.cobrandID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Cobrand" Method="selectCobrand" ReturnVariable="qry_selectCobrand">
		<cfinvokeargument Name="cobrandID" Value="#qry_selectCompany.cobrandID#">
	</cfinvoke>

	<cfif qry_selectCobrand.RecordCount is 1>
		<cfset Variables.displayCobrand = True>
	</cfif>
</cfif>

<cfset Variables.displayAffiliate = False>
<cfif qry_selectCompany.affiliateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Affiliate" Method="selectAffiliate" ReturnVariable="qry_selectAffiliate">
		<cfinvokeargument Name="affiliateID" Value="#qry_selectCompany.affiliateID#">
	</cfinvoke>

	<cfif qry_selectAffiliate.RecordCount is 1>
		<cfset Variables.displayAffiliate = True>
	</cfif>
</cfif>

<!--- custom status of subscriber, company and user --->
<cfset Variables.primaryTargetArray = ArrayNew(1)>
<cfset Variables.primaryTargetArray[1] = Application.fn_GetPrimaryTargetID("subscriberID") & "," & URL.subscriberID>
<cfset Variables.primaryTargetArray[2] = Application.fn_GetPrimaryTargetID("companyID") & "," & qry_selectSubscriber.companyID>
<cfset Variables.primaryTargetArray[3] = Application.fn_GetPrimaryTargetID("userID") & "," & qry_selectSubscriber.userID>

<cfinvoke Component="#Application.billingMapping#data.StatusHistory" Method="selectStatusHistoryList" ReturnVariable="qry_selectStatusHistoryList">
	<cfinvokeargument Name="primaryTargetArray" Value="#Variables.primaryTargetArray#">
	<cfinvokeargument Name="statusHistoryStatus" Value="1">
</cfinvoke>

<cfset Variables.userStatusRow = 0>
<cfset Variables.companyStatusRow = 0>
<cfset Variables.subscriberStatusRow = 0>

<cfloop Query="qry_selectStatusHistoryList">
	<cfif qry_selectStatusHistoryList.primaryTargetID is Application.fn_GetPrimaryTargetID("companyID")>
		<cfset Variables.companyStatusRow = CurrentRow>
	<cfelseif qry_selectStatusHistoryList.primaryTargetID is Application.fn_GetPrimaryTargetID("userID")>
		<cfset Variables.userStatusRow = CurrentRow>
	<cfelseif qry_selectStatusHistoryList.primaryTargetID is Application.fn_GetPrimaryTargetID("subscriberID")>
		<cfset Variables.subscriberStatusRow = CurrentRow>
	</cfif>
</cfloop>

<!--- determine whether to display link to process subscriber now --->
<cfset Variables.displayProcessLink = False>
<cfset Variables.isSubscriptionOkToProcess = True>
<cfif IsDate(qry_selectSubscriber.subscriberDateProcessNext)
		and DateDiff("d", qry_selectSubscriber.subscriberDateProcessNext, Now()) is 0
		and Application.fn_IsUserAuthorized("updateSubscriptionProcess")
		and qry_selectSubscriber.subscriberStatus is 1
		and qry_selectSubscriber.subscriberCompleted is 0>
	<cfset Variables.subscriberID = URL.subscriberID>

	<!--- 1. Select subscriptions to be processed today. if no subscriptions, STOP --->
	<cfinclude template="c_subscriptionProcess/act_processSubscriber_getSubscriptions.cfm">

	<!--- subscriber has subscriptions that need to be processed --->
	<cfif Variables.isSubscriptionOkToProcess is True>
		<!--- If any variable-quantity subscriptions, are all quantities entered? If yes, continue. If not, STOP. --->
		<cfinclude template="c_subscriptionProcess/act_processSubscriber_checkProcessID.cfm">
		<!--- OUTPUT: Variables.subscriberProcessID --->

		<!--- 2. If any variable-quantity subscriptions, are all quantities entered? If yes, continue. If not, STOP. --->
		<cfinclude template="c_subscriptionProcess/act_processSubscriber_variableQuantity.cfm">
		<!--- OUTPUT: Query quantities for variable-quantity subscriptions --->
	</cfif>

	<cfif Variables.isSubscriptionOkToProcess is True>
		<cfset Variables.displayProcessLink = True>
		<!--- actually process subscriber --->
		<cfif IsDefined("URL.processSubscriber") and URL.processSubscriber is True>
			<cfinclude template="c_subscriptionProcess/control_processSubscriber.cfm">
			<cfif Variables.isSubscriptionOkToProcess is True>
				<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&confirm_subscription=processSubscriber" AddToken="No">
			<cfelse>
				<cflocation url="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&error_subscription=processSubscriber" AddToken="No">
			</cfif>
		</cfif>
	</cfif>
</cfif>

<cfinclude template="../../view/v_subscription/dsp_selectSubscriber.cfm">
