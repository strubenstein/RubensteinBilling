<!--- 
cobrand name (if applicable)
affiliate name (if applicable)
company information
user information
phone numbers
shipping address, method
billing address, credit card info
invoice information
invoice line items

Missing:
- shipping information
- notes
- contact management
- status
- update
--->

<cfoutput>
<cfif qry_selectInvoice.invoiceStatus is 0>
	<p class="MainText"><b>This invoice is NOT currently active.</b></p>
</cfif>
<p class="MainText">This invoice was created <cfif qry_selectInvoice.invoiceManual is 1>manually.<cfelse>automatically via a subscriber.</cfif></p>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif qry_selectInvoice.invoiceID_custom is not "">
	<tr>
		<td>Purchase/Invoice ID: </td>
		<td><b>#qry_selectInvoice.invoiceID_custom#</b></td>
	</tr>
</cfif>
<tr>
	<td><b>Line Item Total: </b></td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoice.invoiceTotalLineItem)#</b></td>
</tr>
<tr>
	<td><b>Total Credits: </b></td>
	<td><b>($#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoice.invoiceTotalPaymentCredit)#)</b></td>
</tr>
<tr>
	<td><b>Tax Total: </b></td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoice.invoiceTotalTax)#</b></td>
</tr>
<tr>
	<td><b>Shipping Total: </b></td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoice.invoiceTotalShipping)#</b></td>
</tr>
<tr>
	<td><b>Grand Total: </b></td>
	<td><b>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectInvoice.invoiceTotal)#</b></td>
</tr>
</table>
<br>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="invoiceID">
	<cfinvokeargument name="targetID" value="#URL.invoiceID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="invoiceID">
	<cfinvokeargument name="targetID" value="#URL.invoiceID#">
</cfinvoke>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Created: </td>
	<td>#DateFormat(qry_selectInvoice.invoiceDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectInvoice.invoiceDateCreated, "hh:mm tt")#</td>
</tr>
<tr>
	<td>Last Updated: </td>
	<td>#DateFormat(qry_selectInvoice.invoiceDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectInvoice.invoiceDateUpdated, "hh:mm tt")#</td>
</tr>
<tr valign="top">
	<td>Processing Status: </td>
	<td>
		<cfif qry_selectInvoice.invoiceCompleted is 1>
			<font color="gold">Closed</font><cfif IsDate(qry_selectInvoice.invoiceDateClosed)> on #DateFormat(qry_selectInvoice.invoiceDateClosed, "mm-dd-yy")# at #TimeFormat(qry_selectInvoice.invoiceDateClosed, "hh:mm tt")#</cfif><br>
			<font color="red"><br>Completed</font><cfif IsDate(qry_selectInvoice.invoiceDateCompleted)> on #DateFormat(qry_selectInvoice.invoiceDateCompleted, "mm-dd-yy")# at #TimeFormat(qry_selectInvoice.invoiceDateCompleted, "hh:mm tt")#</cfif>
		<cfelseif qry_selectInvoice.invoiceClosed is 0>
			<font color="green">Open</font>
		<cfelse>
			<font color="gold">Closed</font><cfif IsDate(qry_selectInvoice.invoiceDateClosed)> on #DateFormat(qry_selectInvoice.invoiceDateClosed, "mm-dd-yy")# at #TimeFormat(qry_selectInvoice.invoiceDateClosed, "hh:mm tt")#</cfif>
		</cfif>
	</td>
</tr>
<tr valign="top">
	<td>Payment Status: </td>
	<td>
		<cfif qry_selectInvoice.invoicePaid is ""><font color="red">Not Paid</font><cfelseif qry_selectInvoice.invoicePaid is 0><font color="gold">Partially Paid</font><cfelse><font color="green">Fully Paid</font></cfif>
		<cfif IsDate(qry_selectInvoice.invoiceDatePaid)>on #DateFormat(qry_selectInvoice.invoiceDatePaid, "mm-dd-yy")# at #TimeFormat(qry_selectInvoice.invoiceDatePaid, "hh:mm tt")#</cfif><br>
		<cfif Not IsDate(qry_selectInvoice.invoiceDateDue)>
			(No payment due date.)
		<cfelse>
			Payment Due on #DateFormat(qry_selectInvoice.invoiceDateDue, "mm-dd-yy")# <cfif Hour(qry_selectInvoice.invoiceDateDue) is not 0>at #TimeFormat(qry_selectInvoice.invoiceDateDue, "hh:mm tt")#</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Shipping Method: </td>
	<td>#qry_selectInvoice.invoiceShippingMethod#</td>
</tr>
<cfif qry_selectInvoice.invoiceInstructions is not "">
	<tr>
		<td>Special Instructions: </td>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width="600"><tr><td class="MainText">
			#qry_selectInvoice.invoiceInstructions#
			</td></tr></table>
		</td>
	</tr>
</cfif>
<tr>
	<td>Shipping Status: </td>
	<td><cfif qry_selectInvoice.invoiceShipped is "">Not Shipped/No Shipping Required<cfelseif qry_selectInvoice.invoiceShipped is 0>Partially Shipped<cfelse>Fully Shipped</cfif></td>
</tr>
<cfif Variables.invoiceStatusRow is not 0>
	<tr>
		<td>Invoice Custom Status: </td>
		<td>#qry_selectStatusHistoryList.statusOrder[Variables.invoiceStatusRow]#. #qry_selectStatusHistoryList.statusTitle[Variables.invoiceStatusRow]#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportInvoices")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectInvoice.invoiceIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectInvoice.invoiceIsExported is not "" and IsDate(qry_selectInvoice.invoiceDateExported)>
				on #DateFormat(qry_selectInvoice.invoiceDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectInvoice.invoiceDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<br>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr valign="top">
	<td>
		<cfif Variables.displayShippingAddress is not 0>
			<p>
			<b>Shipping Address:</b><br>
			<cfif qry_selectAddressList.addressName[Variables.displayShippingAddress] is not "">#qry_selectAddressList.addressName[Variables.displayShippingAddress]#<br></cfif>
			#qry_selectAddressList.address[Variables.displayShippingAddress]#<br>
			<cfif qry_selectAddressList.address2[Variables.displayShippingAddress] is not "">#qry_selectAddressList.address2[Variables.displayShippingAddress]#<br></cfif>
		 	<cfif qry_selectAddressList.address3[Variables.displayShippingAddress] is not "">#qry_selectAddressList.address3[Variables.displayShippingAddress]#<br></cfif>
			#qry_selectAddressList.city[Variables.displayShippingAddress]#, #qry_selectAddressList.state[Variables.displayShippingAddress]# 
			#qry_selectAddressList.zipCode[Variables.displayShippingAddress]#<cfif qry_selectAddressList.zipCodePlus4[Variables.displayShippingAddress] is not "">-#qry_selectAddressList.zipCodePlus4[Variables.displayShippingAddress]#</cfif>
			<cfif Not ListFind("US,USA,United States", qry_selectAddressList.country[Variables.displayShippingAddress]) and qry_selectAddressList.country[Variables.displayShippingAddress] is not ""><br>#qry_selectAddressList.country[Variables.displayShippingAddress]#</cfif>
			</p>
		</cfif>
	
		<cfif Variables.displayBillingAddress is not 0>
			<p>
			<b>Billing Address:</b><br>
			<cfif qry_selectAddressList.addressName[Variables.displayBillingAddress] is not "">#qry_selectAddressList.addressName[Variables.displayBillingAddress]#<br></cfif>
			#qry_selectAddressList.address[Variables.displayBillingAddress]#<br>
			<cfif qry_selectAddressList.address2[Variables.displayBillingAddress] is not "">#qry_selectAddressList.address2[Variables.displayBillingAddress]#<br></cfif>
		 	<cfif qry_selectAddressList.address3[Variables.displayBillingAddress] is not "">#qry_selectAddressList.address3[Variables.displayBillingAddress]#<br></cfif>
			#qry_selectAddressList.city[Variables.displayBillingAddress]#, #qry_selectAddressList.state[Variables.displayBillingAddress]# 
			#qry_selectAddressList.zipCode[Variables.displayBillingAddress]#<cfif qry_selectAddressList.zipCodePlus4[Variables.displayBillingAddress] is not "">-#qry_selectAddressList.zipCodePlus4[Variables.displayBillingAddress]#</cfif>
			<cfif Not ListFind("US,USA,United States", qry_selectAddressList.country[Variables.displayBillingAddress]) and qry_selectAddressList.country[Variables.displayBillingAddress] is not ""><br>#qry_selectAddressList.country[Variables.displayBillingAddress]#</cfif>
			</p>
		</cfif>

		<cfif Variables.displayCreditCard is True>
			<p>
			<b>Credit Card Information:</b>
			<table border="0" cellspacing="0" cellpadding="2" class="MainText">
			<tr><td>Name on Card: </td><td>#qry_selectCreditCard.creditCardName#</td></tr>
			<tr><td>Card Type: </td><td>#qry_selectCreditCard.creditCardType#</td></tr>
			<tr>
				<td>Card Number: </td>
				<td>
					<cfif Application.fn_IsUserAuthorized("viewCreditCard")>
						#qry_selectCreditCard.creditCardNumber#
					<cfelse>
						#RepeatString("*", Len(qry_selectCreditCard.creditCardNumber) - 4)##Right(qry_selectCreditCard.creditCardNumber, 4)#
					</cfif>
				</td>
			</tr>
			<tr><td>Expiration Date: </td><td>#qry_selectCreditCard.creditCardExpirationMonth#/#qry_selectCreditCard.creditCardExpirationYear#</td></tr>
			<tr><td>CVC: </td><td>#qry_selectCreditCard.creditCardCVC#</td></tr>
			</table>
			</p>
		</cfif>

		<cfif Variables.displayBank is True>
			<p>
			<b>Bank Account Information:</b>
			<table border="0" cellspacing="0" cellpadding="2" class="MainText">
			<tr><td>Bank Name: </td><td>#qry_selectBank.bankName#</td></tr>
			<tr><td>Account Number: </td><td>#qry_selectBank.bankAccountNumber#</td></tr>
			<tr><td>Name on Account: </td><td>#qry_selectBank.bankAccountName#</td></tr>
			<tr>
				<td>Account Type: </td>
				<td>
					<cfif qry_selectBank.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif> 
					<cfif qry_selectBank.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBank.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBank.bankAccountType is not "">#qry_selectBank.bankAccountType#</cfif>
				</td>
			</tr>
			</table>
			</p>
		</cfif>
	</td>
	<td width="25">&nbsp;</td>
	<td>
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
			<td>#qry_selectCompany.companyName# <cfif ListFind(Variables.permissionActionList, "viewCompany")> <font class="TableText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectInvoice.companyID#" class="plainlink">go</a>)</font></cfif></td>
		</tr>
		<cfif Variables.displaySubscriberName is True>
			<tr>
				<td>Subscriber: </td>
				<td>
					#qry_selectSubscriber.subscriberName#
					<cfif ListFind(Variables.permissionActionList, "viewSubscriber")>
						<font class="TableText">(<a href="index.cfm?method=subscription.viewSubscriber&subscriberID=#qry_selectInvoice.subscriberID#" class="plainlink">go</a>)</font>
					</cfif>
				</td>
			</tr>
		</cfif>
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
		<cfif qry_selectInvoice.userID is not 0>
			<tr>
				<td>Customer Name: </td>
				<td>
					<cfif qry_selectUser.salutation is not "">#qry_selectUser.salutation# </cfif>
					#qry_selectUser.firstName# #qry_selectUser.lastName#
					<cfif qry_selectUser.suffix is not ""> #qry_selectUser.suffix#</cfif>
					<cfif ListFind(Variables.permissionActionList, "viewUser")>
						<font class="TableText">(<a href="index.cfm?method=company.viewUser&companyID=#qry_selectInvoice.companyID#&userID=#qry_selectInvoice.userID#" class="plainlink">go</a>)</font>
					</cfif>
				</td>
			</tr>
			<cfif qry_selectUser.userID_custom is not "">
				<tr>
					<td>ID: </td>
					<td>#qry_selectUser.userID_custom#</td>
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
				<td><a href="mailto:#qry_selectUser.email#" class="bluelink">#qry_selectUser.email#</a></td>
			</tr>
			<tr>
				<td>Username: </td>
				<td>#qry_selectUser.username#</td>
			</tr>
			<tr>
				<td>User Status: </td>
				<td><cfif qry_selectUser.userStatus is 1>Active<cfelse>Not Active</cfif></td>
			</tr>
			<cfif Abs(DateDiff("d", qry_selectUser.userDateCreated, qry_selectCompany.companyDateCreated)) gt 1>
				<tr>
					<td>User Created: </td>
					<td>#DateFormat(qry_selectUser.userDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectUser.userDateCreated, "hh:mm tt")#</td>
				</tr>
			</cfif>
		</cfif>
		<cfif Variables.displayPhone is True>
			<cfloop Query="qry_selectPhoneList">
				<tr>
					<td>Phone - #qry_selectPhoneList.phoneType#: </td>
					<td>
						<cfif qry_selectPhoneList.phoneAreaCode is not "">(#qry_selectPhoneList.phoneAreaCode#) </cfif>
						<cfif Len(qry_selectPhoneList.phoneNumber) is not 7>#qry_selectPhoneList.phoneNumber#<cfelse>#Left(qry_selectPhoneList.phoneNumber, 3)#-#Right(qry_selectPhoneList.phoneNumber, 4)#</cfif>
						<cfif qry_selectPhoneList.phoneExtension is not ""> ext. #qry_selectPhoneList.phoneExtension#</cfif>
					</td>
				</tr>	
			</cfloop>
		</cfif>
		</table>
	</td>
</tr>
</table>
<br>

</cfoutput>
