<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectSubscriber.subscriberID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectSubscriber.subscriberID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectSubscriber.subscriberName is not "">
	<tr>
		<td>Subscriber Name: </td>
		<td>#qry_selectSubscriber.subscriberName#</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td>
		<cfif qry_selectSubscriber.subscriberStatus is 1>
			Active
		<cfelse>
			Inactive
			<cfif Variables.userCancelRow is not 0> by #qry_selectUserList.firstName[Variables.userCancelRow]# #qry_selectUserList.lastName[Variables.userCancelRow]#</cfif>
		</cfif></td>
</tr>
<cfif Variables.subscriberStatusRow is not 0>
	<tr>
		<td>Subscriber Custom Status: </td>
		<td>#qry_selectStatusHistoryList.statusOrder[Variables.subscriberStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.subscriberStatusRow]#</td>
	</tr>
</cfif>
<tr>
	<td>Completed: </td>
	<td><cfif qry_selectSubscriber.subscriberCompleted is 0>Currently has open subscriptions<cfelse>Has already completed all existing subscriptions.</cfif></td>
</tr>
<tr valign="top">
	<td>Next Processing Date: </td>
	<td>
		<cfif Not IsDate(qry_selectSubscriber.subscriberDateProcessNext)>
			(no date set)
		<cfelse>
			#DateFormat(qry_selectSubscriber.subscriberDateProcessNext, "dddd, mmmm dd, yyyy")#
			<!--- if supposed to be processed today, display link to process now --->
			<cfif Variables.displayProcessLink is True and Variables.isSubscriptionOkToProcess is True>
				<br><b>[<i><a href="index.cfm?method=subscription.viewSubscriber&subscriberID=#URL.subscriberID#&processSubscriber=True" class="plainlink">Process Subscriber Now</a></i>]</b>
			<cfelseif Variables.displayProcessLink is False and Variables.isSubscriptionOkToProcess is False>
				<br><font color="red">(Subscriber cannot be processed until all variable-quantity<br>&nbsp;subscriptions have been finalized for this billing period.)</font>
			</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Most Recent Processing: </td>
	<td><cfif Not IsDate(qry_selectSubscriber.subscriberDateProcessLast)>(no date set)<cfelse>#DateFormat(qry_selectSubscriber.subscriberDateProcessLast, "dddd, mmmm dd, yyyy")#</cfif></td>
</tr>
<tr>
	<td>Created: </td>
	<td>
		#DateFormat(qry_selectSubscriber.subscriberDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectSubscriber.subscriberDateCreated, "hh:mm tt")#
		<cfif Variables.userAuthorRow is not 0> by #qry_selectUserList.firstName[Variables.userAuthorRow]# #qry_selectUserList.lastName[Variables.userAuthorRow]#</cfif>
	</td>
</tr>
<tr>
	<td>Last Updated: </td>
	<td>#DateFormat(qry_selectSubscriber.subscriberDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectSubscriber.subscriberDateUpdated, "hh:mm tt")#</td>
</tr>
<tr valign="top">
	<td>Automatic Payment: </td>
	<td>
		<cfif qry_selectSubscriberPaymentList.RecordCount is 0>
			Not using automated payments.
		<cfelse>
			<cfif Variables.displayCreditCard is True>
				Paid via credit card:<br>
				<cfloop Query="qry_selectCreditCardList">
					<cfif qry_selectCreditCardList.creditCardName is not "">#qry_selectCreditCardList.creditCardName#<br></cfif>
					<cfif qry_selectCreditCardList.creditCardType is not "">#qry_selectCreditCardList.creditCardType# &nbsp; </cfif>
					<cfif qry_selectCreditCardList.creditCardNumber is not "">#RepeatString("*", Len(qry_selectCreditCardList.creditCardNumber) - 4)##Right(qry_selectCreditCardList.creditCardNumber, 4)# &nbsp; </cfif>
					Expires #qry_selectCreditCardList.creditCardExpirationMonth#/#qry_selectCreditCardList.creditCardExpirationYear#
				</cfloop>
			</cfif>
			<cfif Variables.displayBank is True>
				Paid via bank account (ACH):<br>
				<cfloop Query="qry_selectBankList">
					<cfif qry_selectBankList.bankName is not "">#qry_selectBankList.bankName# </cfif>
					<cfif qry_selectBankList.bankAccountNumber is not "">#qry_selectBankList.bankAccountNumber#</cfif><br>
					<cfif qry_selectBankList.bankAccountName is not "">#qry_selectBankList.bankAccountName# </cfif>
					(<cfif qry_selectBankList.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif> 
					<cfif qry_selectBankList.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBankList.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBankList.bankAccountType is not "">#qry_selectBankList.bankAccountType#</cfif>)
				</cfloop>
			</cfif>
		</cfif>
	</td>
</tr>
<cfif qry_selectSubscriber.addressID_billing is not 0>
	<cfset Variables.addressRow = ListFind(ValueList(qry_selectAddressList.addressID), qry_selectSubscriber.addressID_billing)>
	<cfif Variables.addressRow is not 0>
		<tr valign="top">
			<td>Billing Address: </td>
			<td>
				<cfif qry_selectAddressList.addressName[Variables.addressRow] is not "">#qry_selectAddressList.addressName[Variables.addressRow]#<br></cfif>
				#qry_selectAddressList.address[Variables.addressRow]#<br>
				<cfif qry_selectAddressList.address2[Variables.addressRow] is not "">#qry_selectAddressList.address2[Variables.addressRow]#<br></cfif>
				<cfif qry_selectAddressList.address3[Variables.addressRow] is not "">#qry_selectAddressList.address3[Variables.addressRow]#<br></cfif>
				#qry_selectAddressList.city[Variables.addressRow]#, #qry_selectAddressList.state[Variables.addressRow]# #qry_selectAddressList.zipCode[Variables.addressRow]#<cfif qry_selectAddressList.zipCodePlus4[Variables.addressRow] is not "">-#qry_selectAddressList.zipCodePlus4[Variables.addressRow]#</cfif><br>
				<cfif qry_selectAddressList.country[Variables.addressRow] is not "" and Not ListFindNoCase("US,USA,United States", qry_selectAddressList.country[Variables.addressRow])>#qry_selectAddressList.country[Variables.addressRow]#</cfif>
			</td>
		</tr>
	</cfif>
</cfif>
<cfif qry_selectSubscriber.addressID_shipping is not 0>
	<cfset Variables.addressRow = ListFind(ValueList(qry_selectAddressList.addressID), qry_selectSubscriber.addressID_shipping)>
	<cfif Variables.addressRow is not 0>
		<tr valign="top">
			<td>Shipping Address: </td>
			<td>
				<cfif qry_selectAddressList.addressName[Variables.addressRow] is not "">#qry_selectAddressList.addressName[Variables.addressRow]#<br></cfif>
				#qry_selectAddressList.address[Variables.addressRow]#<br>
				<cfif qry_selectAddressList.address2[Variables.addressRow] is not "">#qry_selectAddressList.address2[Variables.addressRow]#<br></cfif>
				<cfif qry_selectAddressList.address3[Variables.addressRow] is not "">#qry_selectAddressList.address3[Variables.addressRow]#<br></cfif>
				#qry_selectAddressList.city[Variables.addressRow]#, #qry_selectAddressList.state[Variables.addressRow]# #qry_selectAddressList.zipCode[Variables.addressRow]#<cfif qry_selectAddressList.zipCodePlus4[Variables.addressRow] is not "">-#qry_selectAddressList.zipCodePlus4[Variables.addressRow]#</cfif><br>
				<cfif qry_selectAddressList.country[Variables.addressRow] is not "" and Not ListFindNoCase("US,USA,United States", qry_selectAddressList.country[Variables.addressRow])>#qry_selectAddressList.country[Variables.addressRow]#</cfif>
			</td>
		</tr>
	</cfif>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportSubscribers")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectSubscriber.subscriberIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectSubscriber.subscriberIsExported is not "" and IsDate(qry_selectSubscriber.subscriberDateExported)>
				on #DateFormat(qry_selectSubscriber.subscriberDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectSubscriber.subscriberDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="subscriberID">
	<cfinvokeargument name="targetID" value="#URL.subscriberID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="subscriberID">
	<cfinvokeargument name="targetID" value="#URL.subscriberID#">
</cfinvoke>

<!--- 
<br>
<div class="MainText"><b>Notification Options</b></div>
<cfif qry_selectSubscriberNotifyList.RecordCount is 0>
	<p class="MainText">There are no notification options enabled for this subscriber.</p>
<cfelse>
	<table border="1" cellspacing="2" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>User</th>
		<th></th>
		<th></th>
		<th></th>
	</tr>
	</table>
</cfif>
--->

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.displayCobrand is True>
	<tr>
		<td>Cobrand Partner: </td>
		<td><cfif qry_selectCobrand.cobrandCode is not "">#qry_selectCobrand.cobrandCode#.</cfif> #qry_selectCobrand.cobrandName#</td>
	</tr>
</cfif>
<cfif Variables.displayAffiliate is True>
	<tr>
		<td>Affiliate Partner: </td>
		<td><cfif qry_selectAffiliate.affiliateCode is not "">#qry_selectAffiliate.affiliateCode#.</cfif> #qry_selectAffiliate.affiliateName#</td>
	</tr>
</cfif>
<tr>
	<td>Company Name: </td>
	<td>
		#qry_selectCompany.companyName# 
		<cfif Application.fn_IsUserAuthorized("viewCompany")>
			<font class="TableText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectSubscriber.companyID#" class="plainlink">go</a>)</font>
		</cfif>
	</td>
</tr>
<tr>
	<td>Company Created: </td>
	<td>#DateFormat(qry_selectCompany.companyDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCompany.companyDateCreated, "hh:mm tt")#</td>
</tr>
<tr>
	<td>Company Status: </td>
	<td><cfif qry_selectCompany.companyStatus is 1>Active<cfelse>Not Active</cfif></td>
</tr>
<cfif Variables.companyStatusRow is not 0>
	<tr>
		<td>Company Custom Status: </td>
		<td>#qry_selectStatusHistoryList.statusOrder[Variables.companyStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.companyStatusRow]#</td>
	</tr>
</cfif>
<tr>
	<td>Tax Status: </td>
	<td>Company <cfif qry_selectCompany.companyIsTaxExempt is 1>IS<cfelse>is NOT</cfif> tax-exempt.</td>
</tr>
<cfif qry_selectCompany.companyID_custom is not "">
	<tr>
		<td>ID: </td>
		<td>#qry_selectCompany.companyID_custom#</td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyDBA is not "">
	<tr>
		<td>Company DBA: </td>
		<td>#qry_selectCompany.companyDBA#</td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyURL is not "">
	<tr>
		<td>URL: </td>
		<td><a href="#qry_selectCompany.companyURL#" class="bluelink">#qry_selectCompany.companyURL#</a></td>
	</tr>
</cfif>
<cfif qry_selectCompany.companyIsAffiliate is 1 or qry_selectCompany.companyIsCobrand is 1 or qry_selectCompany.companyIsVendor is 1>
	<tr>
		<td>Company Other: </td>
		<td>
			<cfif qry_selectCompany.companyIsAffiliate is 1>Is Affiliate Partner. </cfif>
			<cfif qry_selectCompany.companyIsCobrand is 1>Is Cobrand Partner. </cfif>
			<cfif qry_selectCompany.companyIsVendor is 1>Is Vendor.</cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectUserList.RecordCount is not 0>
	<tr>
		<td>Customer Name: </td>
		<td>
			<cfif qry_selectUserList.salutation[Variables.userStatusRow] is not "">#qry_selectUserList.salutation[Variables.userStatusRow]# </cfif>
			#qry_selectUserList.firstName[Variables.userStatusRow]# #qry_selectUserList.lastName[Variables.userStatusRow]#
			<cfif qry_selectUserList.suffix[Variables.userStatusRow] is not ""> #qry_selectUserList.suffix[Variables.userStatusRow]#</cfif>
			<cfif Application.fn_IsUserAuthorized("viewUser")>
				<font class="TableText">(<a href="index.cfm?method=company.viewUser&companyID=#qry_selectSubscriber.companyID#&userID=#qry_selectSubscriber.userID#" class="plainlink">go</a>)</font>
			</cfif>
		</td>
	</tr>
	<cfif qry_selectUserList.userID_custom[Variables.userRow] is not "">
		<tr>
			<td>ID: </td>
			<td>#qry_selectUserList.userID_custom[Variables.userRow]#</td>
		</tr>
	</cfif>
	<cfif Variables.userStatusRow is not 0>
		<tr>
			<td>User Custom Status: </td>
			<td>#qry_selectStatusHistoryList.statusOrder[Variables.userStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.userStatusRow]#</td>
		</tr>
	</cfif>
	<tr>
		<td>Email: </td>
		<td><a href="mailto:#qry_selectUserList.email[Variables.userRow]#" class="bluelink">#qry_selectUserList.email[Variables.userRow]#</a></td>
	</tr>
	<tr>
		<td>Username: </td>
		<td>#qry_selectUserList.username[Variables.userRow]#</td>
	</tr>
	<tr>
		<td>User Status: </td>
		<td><cfif qry_selectUserList.userStatus[Variables.userRow] is 1>Active<cfelse>Not Active</cfif></td>
	</tr>
	<cfif Variables.userRow is not 0 and Abs(DateDiff("d", qry_selectUserList.userDateCreated[Variables.userRow], qry_selectCompany.companyDateCreated)) gt 1>
		<tr>
			<td>User Created: </td>
			<td>#DateFormat(qry_selectUserList.userDateCreated[Variables.userRow], "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectUserList.userDateCreated[Variables.userRow], "hh:mm tt")#</td>
		</tr>
	</cfif>
</cfif>
</table>
<br>
</cfoutput>
