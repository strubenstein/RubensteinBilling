<!--- paymentStatus --->
<cfoutput>
<cfif qry_selectInvoicePaymentList.RecordCount is 0>
	<p class="ErrorMessage">No payments have been applied to this invoice.</p>
<cfelse>
	<cfloop Query="qry_selectInvoicePaymentList">
		<p>
		<cfif ListFind(Variables.permissionActionList, "viewPayment")>
			<div class="TableText">[ <a href="index.cfm?method=payment.viewPayment&paymentID=#qry_selectInvoicePaymentList.paymentID#" class="plainlink">View Payment</a> ]</div>
		</cfif>
		<table border="0" cellspacing="2" cellpadding="2" class="MainText">
		<cfif CurrentRow is not 1>
			<tr><td colspan="2"><hr noshade size="2" align="left" width="100%"></td></tr>
		</cfif>
		<cfif qry_selectInvoicePaymentList.paymentStatus is 0>
			<tr>
				<td colspan="2"><b>This payment is currently being ignored or has been refunded.</b></td>
			</tr>
		</cfif>
		<cfif qry_selectInvoicePaymentList.userID_author is not 0>
			<tr>
				<td>Processed By: </td>
				<td>#qry_selectInvoicePaymentList.firstName# #qry_selectInvoicePaymentList.lastName#</td>
			</tr>
		</cfif>
		<!--- 
		<cfif qry_selectInvoicePaymentList.paymentCompanyID is not 0>
			<tr>
				<td>Target Company: </td>
				<td>
					#qry_selectInvoicePaymentList.companyName#
					<cfif ListFind(Variables.permissionActionList, "viewCompany")>
						 (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectInvoicePaymentList.paymentCompanyID#" class="plainlink">go</a>)
					</cfif>
				</td>
			</tr>
		</cfif>
		<cfif qry_selectInvoicePaymentList.paymentUserID is not 0>
			<tr>
				<td>Target Name: </td>
				<td>
					#qry_selectInvoicePaymentList.targetFirstName# #qry_selectInvoicePaymentList.targetLastName#
					<cfif ListFind(Variables.permissionActionList, "viewUser")>
						 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectInvoicePaymentList.paymentUserID#" class="plainlink">go</a>)
					</cfif>
				</td>
			</tr>
		</cfif>
		--->
		<tr>
			<td>Approval Status: </td>
			<td>#fn_DisplayPaymentApproved(qry_selectInvoicePaymentList.paymentApproved)#</td>
		</tr>
		<tr>
			<td>Amount: </td>
			<td>#DollarFormat(qry_selectInvoicePaymentList.paymentAmount)#</td>
		</tr>
		<cfif qry_selectInvoicePaymentList.paymentID_custom is not "">
			<tr>
				<td>Custom ID: </td>
				<td>#qry_selectInvoicePaymentList.paymentID_custom#</td>
			</tr>
		</cfif>
		<cfif qry_selectInvoicePaymentList.paymentDescription is not "">
			<tr valign="top">
				<td>Description: </td>
				<td>#qry_selectInvoicePaymentList.paymentDescription#</td>
			</tr>
		</cfif>
		<cfif qry_selectInvoicePaymentList.paymentMessage is not "">
			<tr>
				<td>Error Message: </td>
				<td>#qry_selectInvoicePaymentList.paymentMessage#</td>
			</tr>
		</cfif>
		<tr>
			<td>Date Received: </td>
			<td>#DateFormat(qry_selectInvoicePaymentList.paymentDateReceived, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.paymentDateReceived, "hh:mm tt")#</td>
		</tr>
		<cfif IsDate(qry_selectInvoicePaymentList.paymentDateScheduled)>
			<tr>
				<td>Scheduled Processing Date: </td>
				<td>#DateFormat(qry_selectInvoicePaymentList.paymentDateScheduled, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.paymentDateScheduled, "hh:mm tt")#</td>
			</tr>
		</cfif>
		<tr>
			<td>Date Recorded: </td>
			<td>#DateFormat(qry_selectInvoicePaymentList.paymentDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.paymentDateCreated, "hh:mm tt")#</td>
		</tr>
		<tr>
			<td>Recorded Method: </td>
			<td><cfif qry_selectInvoicePaymentList.paymentManual is 0>Automatically via scheduled script<cfelse>Manually by a user</cfif></td>
		</tr>
		<tr>
			<td>Date Last Updated: </td>
			<td>#DateFormat(qry_selectInvoicePaymentList.paymentDateUpdated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectInvoicePaymentList.paymentDateUpdated, "hh:mm tt")#</td>
		</tr>
		<tr valign="top">
			<td>Payment Method: </td>
			<td>
			<cfswitch expression="#qry_selectInvoicePaymentList.paymentMethod#">
			<cfcase value="creditCard">
				Credit card
				<cfif qry_selectInvoicePaymentList.creditCardID is 0>
					 - Not Specified
				<cfelse>
					<cfif qry_selectInvoicePaymentList.merchantAccountID is 0 or Variables.displayMerchantAccount is False>
						 - Processed via the system<br>
					<cfelse>
						<cfset Variables.maRow = ListFind(ValueList(qry_selectMerchantAccountList.merchantAccountID), qry_selectInvoicePaymentList.merchantAccountID)>
						<cfif Variables.maRow is not 0>
							 - Processed via merchant account: <cfif qry_selectMerchantAccountList.merchantAccountName[Variables.maRow] is not "">#qry_selectMerchantAccountList.merchantAccountName[Variables.maRow]#<cfelse>#qry_selectMerchantAccountList.merchantTitle[Variables.maRow]#</cfif><br>
						<cfelse>
							- Processed via unknown merchant account<br>
						</cfif>
					</cfif>
					<cfif Variables.displayCreditCard is True>
						<cfset Variables.ccRow = ListFind(ValueList(qry_selectCreditCardList.creditCardID), qry_selectInvoicePaymentList.creditCardID)>
						<cfif Variables.ccRow is not 0>
							<cfif qry_selectCreditCardList.creditCardName[Variables.ccRow] is not "">#qry_selectCreditCardList.creditCardName[Variables.ccRow]#<br></cfif>
							<cfif qry_selectCreditCardList.creditCardType[Variables.ccRow] is not "">#qry_selectCreditCardList.creditCardType[Variables.ccRow]# &nbsp; </cfif>
							<cfif qry_selectCreditCardList.creditCardNumber[Variables.ccRow] is not "">#RepeatString("*", Len(qry_selectCreditCardList.creditCardNumber[Variables.ccRow]) - 4)##Right(qry_selectCreditCardList.creditCardNumber[Variables.ccRow], 4)# &nbsp; </cfif>
							Expires #qry_selectCreditCardList.creditCardExpirationMonth[Variables.ccRow]#/#qry_selectCreditCardList.creditCardExpirationYear[Variables.ccRow]#
						</cfif>
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="bank">
				Bank
				<cfif qry_selectInvoicePaymentList.bankID is 0>
					 - Not Specified
				<cfelse>
					<cfif qry_selectInvoicePaymentList.merchantAccountID is 0 or Variables.displayMerchantAccount is False>
						 - Processed via the system<br>
					<cfelse>
						<cfset Variables.maRow = ListFind(ValueList(qry_selectMerchantAccountList.merchantAccountID), qry_selectInvoicePaymentList.merchantAccountID)>
						<cfif Variables.maRow is not 0>
							 - Processed via merchant account: <cfif qry_selectMerchantAccountList.merchantAccountName[Variables.maRow] is not "">#qry_selectMerchantAccountList.merchantAccountName[Variables.maRow]#<cfelse>#qry_selectMerchantAccountList.merchantTitle[Variables.maRow]#</cfif><br>
						<cfelse>
							- Processed via unknown merchant account<br>
						</cfif>
					</cfif>
					<cfif Variables.displayBank is True>
						<cfset Variables.bankRow = ListFind(ValueList(qry_selectBankList.bankID), qry_selectInvoicePaymentList.bankID)>
						<cfif Variables.bankRow is not 0>
							<cfif qry_selectBankList.bankName[Variables.bankRow] is not "">#qry_selectBankList.bankName[Variables.bankRow]# </cfif>
							<cfif qry_selectBankList.bankAccountNumber[Variables.bankRow] is not "">#qry_selectBankList.bankAccountNumber[Variables.bankRow]#</cfif><br>
							<cfif qry_selectBankList.bankAccountName[Variables.bankRow] is not "">#qry_selectBanList.bankAccountName[Variables.bankRow]# </cfif>
							(<cfif qry_selectBankList.bankPersonalOrCorporate[Variables.bankRow] is 0>Personal<cfelse>Corporate</cfif> 
							<cfif qry_selectBankList.bankCheckingOrSavings[Variables.bankRow] is 0>Checking<cfelseif qry_selectBankList.bankCheckingOrSavings[Variables.bankRow] is 1>Savings<cfelseif qry_selectBankList.bankAccountType[Variables.bankRow] is not "">#qry_selectBankList.bankAccountType[Variables.bankRow]#</cfif>)
						</cfif>
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="cash,barter,services,other">
				#UCase(Left(qry_selectInvoicePaymentList.paymentMethod, 1))##Mid(qry_selectInvoicePaymentList.paymentMethod, 2, Len(qry_selectInvoicePaymentList.paymentMethod) - 1)#
			</cfcase>
			<cfcase value="check,certified check,cashier check">
				#UCase(Left(qry_selectInvoicePaymentList.paymentMethod, 1))##Mid(qry_selectInvoicePaymentList.paymentMethod, 2, Len(qry_selectInvoicePaymentList.paymentMethod) - 1)#
				<cfif qry_selectInvoicePaymentList.paymentCheckNumber is not 0> - check ###qry_selectInvoicePaymentList.paymentCheckNumber#</cfif>
			</cfcase>
			<cfdefaultcase><!--- other specified --->
				#qry_selectInvoicePaymentList.paymentMethod#
			</cfdefaultcase>
			</cfswitch>
			</td>
		</tr>
		<cfif ListFind(Variables.permissionActionList, "deleteInvoicePayment")>
			<tr>
				<td></td>
				<td></td>
				<td bgcolor="dddddd">[<font class="SmallText"><a href="index.cfm?method=#URL.control#.deleteInvoicePayment#Variables.urlParameters#&paymentID=#qry_selectInvoicePaymentList.paymentID#" class="plainlink" title="Remove Payment From Invoice?" onclick="return confirm('Are you sure you want to remove the payment from the invoice? If yes, click OK. If unsure, click Cancel.');">Remove Payment From Invoice</a></font>]</td>
			</tr>
		</cfif>
		</table>
		</p>
	</cfloop>
</cfif>
</cfoutput>
