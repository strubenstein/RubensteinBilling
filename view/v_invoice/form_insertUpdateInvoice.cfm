<cfoutput>
<!--- 
<script language="JavaScript">
function setTodayDateFinal ()
{
if (document.#Variables.formName#.invoiceClosed.checked == true && document.#Variables.formName#.invoiceDateClosed_date.value == "")
	{
	document.#Variables.formName#.invoiceDateClosed_date.value = "#DateFormat(Now(), "mm/dd/yyyy")#";
	document.#Variables.formName#.invoiceDateClosed_hh.value = #Variables.nowDateTime_hh#;
	document.#Variables.formName#.invoiceDateClosed_mm.value = #Minute(Variables.nowDateTime)#;
	document.#Variables.formName#.invoiceDateClosed_tt.value = "#Variables.nowDateTime_tt#";
	}
}

function setTodayDateComplete ()
{
if (document.#Variables.formName#.invoiceCompleted.checked == true && document.#Variables.formName#.invoiceDateCompleted_date.value == "")
	{
	document.#Variables.formName#.invoiceDateCompleted_date.value = "#DateFormat(Now(), "mm/dd/yyyy")#";
	document.#Variables.formName#.invoiceDateCompleted_hh.value = #Variables.nowDateTime_hh#;
	document.#Variables.formName#.invoiceDateCompleted_mm.value = #Minute(Variables.nowDateTime)#;
	document.#Variables.formName#.invoiceDateCompleted_tt.value = "#Variables.nowDateTime_tt#";
	}
}
</script>
--->

<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.displayCompanyList is True>
	<tr>
		<td>Company: </td>
		<td>
			<select name="userID" size="1">
			<cfloop Query="qry_selectUserCompanyList_user">
				<option value="#qry_selectUserCompanyList_user.companyID#"<cfif Form.companyID is qry_selectUserCompanyList_user.companyID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_user.companyName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<cfif Variables.doAction is "insertInvoice" and IsDefined("qry_selectSubscriberList") and qry_selectSubscriberList.RecordCount is not 0>
	<tr valign="top">
		<td>Subscriber: </td>
		<td>
			<select name="subscriberID" size="1">
			<option value="0"<cfif Form.subscriberID is 0> selected</cfif>> -- NO SUBSCRIBER SPECIFIED --</option>
			<cfloop Query="qry_selectSubscriberList">
				<option value="#qry_selectSubscriberList.subscriberID#"<cfif Form.subscriberID is qry_selectSubscriberList.subscriberID> selected</cfif>>#HTMLEditFormat(qry_selectSubscriberList.subscriberName)#</option>
			</cfloop>
			</select>
			<div class="SmallText">
			Select the subscriber for this company that is the target of the invoice.<br>
			Any available credits must match both company <i>and</i> subscriber.
			</div>
		</td>
	</tr>
</cfif>
<tr>
	<td>Contact Person: </td>
	<td>
		<select name="userID" size="1">
		<option value="0">-- SELECT CONTACT --</option>
		<cfloop Query="qry_selectUserCompanyList_company">
			<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr valign="top">
	<td>Invoice Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="invoiceStatus" value="1"<cfif Form.invoiceStatus is 1> checked</cfif>>Active</label> &nbsp; 
		<label style="color: red"><input type="radio" name="invoiceStatus" value="0"<cfif Form.invoiceStatus is not 1> checked</cfif>>Ignored (Not Active)</label>
	</td>
</tr>
<!--- 
<tr valign="top">
	<td>Manually Created: </td>
	<td><label><input type="checkbox" name="invoiceManual" value="1"<cfif Form.invoiceManual is 1> checked</cfif>> Invoice was manually created or updated</label></td>
</tr>
--->
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="invoiceID_custom" value="#HTMLEditFormat(Form.invoiceID_custom)#" size="20" maxlength="#maxlength_Invoice.invoiceID_custom#"></td>
</tr>

<tr valign="top">
	<td>Processed Status: </td>
	<td>
		<label style="color: red"><input type="radio" name="invoiceClosed" value="0"<cfif Form.invoiceClosed is 0> checked</cfif><cfif Form.invoiceClosed is not 0> disabled</cfif>>Open</label> - New line items may still be added to invoice<br>
		<label style="color: gold"><input type="radio" name="invoiceClosed" value="1"<cfif Form.invoiceClosed is 1> checked</cfif><cfif Form.invoiceClosed is 0> title="Verify Close" onclick="return confirm('Are you sure you want to close this invoice? It cannot be re-opened.');"</cfif>>Closed</label> - No additional changes are permitted. Cannot be re-opened.<br>
		<label style="color: green"><input type="radio" name="invoiceClosed" value="2"<cfif Form.invoiceClosed is 2> checked</cfif><cfif Form.invoiceClosed is 0> title="Verify Close" onclick="return confirm('Are you sure you want to close this invoice? It cannot be re-opened?');"</cfif>>Completed</label> - Fully processed, including payment, shipment, etc.
	</td>
</tr>

<!--- 
<tr valign="top">
	<td>Closed Status: </td>
	<td>
		<label><input type="checkbox" name="invoiceClosed" value="1"<cfif Form.invoiceClosed is 1> checked<cfelse> onClick="javascript:setTodayDateFinal();"</cfif>>Yes, closed/submitted on:</label> 
		#fn_FormSelectDateTime(Variables.formName, "invoiceDateClosed_date", Form.invoiceDateClosed_date, "invoiceDateClosed_hh", Form.invoiceDateClosed_hh, "invoiceDateClosed_mm", Form.invoiceDateClosed_mm, "invoiceDateClosed_tt", Form.invoiceDateClosed_tt, True)#
	</td>
</tr>
<tr valign="top">
	<td>Is Fully Processed: </td>
	<td>
		<label><input type="checkbox" name="invoiceCompleted" value="1"<cfif Form.invoiceCompleted is 1> checked<cfelse> onClick="javascript:setTodayDateComplete();"</cfif>>Yes, fully processed on:</label> 
		#fn_FormSelectDateTime(Variables.formName, "invoiceDateCompleted_date", Form.invoiceDateCompleted_date, "invoiceDateCompleted_hh", Form.invoiceDateCompleted_hh, "invoiceDateCompleted_mm", Form.invoiceDateCompleted_mm, "invoiceDateCompleted_tt", Form.invoiceDateCompleted_tt, True)#
	</td>
</tr>
--->
<tr valign="top">
	<td>Notice Sent: </td>
	<td><label><input type="checkbox" name="invoiceSent" value="1"<cfif Form.invoiceSent is 1> checked</cfif>> Invoice has been sent to customer</label></td>
</tr>

<tr valign="top">
	<td>Payment Status: </td>
	<td>
		<label style="color: red"><input type="radio" name="invoicePaid" value=""<cfif Form.invoicePaid is ""> checked</cfif>>Not Yet Paid</label> &nbsp; 
		<label style="color: gold"><input type="radio" name="invoicePaid" value="0"<cfif Form.invoicePaid is 0> checked</cfif>>Partially Paid</label> &nbsp; 
		<label style="color: green"><input type="radio" name="invoicePaid" value="1"<cfif Form.invoicePaid is 1> checked</cfif>>Fully Paid</label>
		<div class="SmallText">Note: Setting payment status to fully paid will automatically trigger sales commission calculation.<br>
		Once commissions are calculated, they are <i>not</i> re-calculated even if invoice or payment status changes.</div>
	</td>
</tr>
<tr>
	<td>Payment Due Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "invoiceDateDue_date", Form.invoiceDateDue_date, "invoiceDateDue_hh", Form.invoiceDateDue_hh, "invoiceDateDue_mm", Form.invoiceDateDue_mm, "invoiceDateDue_tt", Form.invoiceDateDue_tt, True)#</td>
</tr>
<tr>
	<td>Line Item Total: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalLineItem)#</td>
	<!--- <td>$<input type="text" name="invoiceTotalLineItem" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalLineItem)#" size="10"></td> --->
</tr>
<tr>
	<td>Total Credits: </td>
	<td>($#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalPaymentCredit)#)</td>
	<!--- <td>($<input type="text" name="invoiceTotalPaymentCredit" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalPaymentCredit)#" size="10">) (enter positive number)</td> --->
</tr>
<tr>
	<td>Tax Total: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalTax)#</td>
	<!--- <td>$<input type="text" name="invoiceTotalTax" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalTax)#" size="10"></td> --->
</tr>
<tr>
	<td>Shipping Total: </td>
	<td>$<input type="text" name="invoiceTotalShipping" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotalShipping)#" size="10"></td>
</tr>
<tr>
	<td>Grand Total: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotal)#</td>
	<!--- <td>$<input type="text" name="invoiceTotal" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.invoiceTotal)#" size="10"></td> --->
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>All Items Shipped? </td>
	<td>
		<label style="color: red"><input type="radio" name="invoiceShipped" value=""<cfif Form.invoiceShipped is ""> checked</cfif>>Not Shipped/No Shipping Required</label> &nbsp; 
		<label style="color: gold"><input type="radio" name="invoiceShipped" value="0"<cfif Form.invoiceShipped is not 1> checked</cfif>>Partially Shipped</label> &nbsp; 
		<label style="color: green"><input type="radio" name="invoiceShipped" value="1"<cfif Form.invoiceShipped is 1> checked</cfif>>Fully Shipped</label>
	</td>
</tr>
<tr>
	<td>Shipping Method: </td>
	<td>
		<select name="invoiceShippingMethod" size="1">
		<option value="">-- SHIPPING OPTION --</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.shippingMethodList_value)#">
			<option value="#ListGetAt(Variables.shippingMethodList_value, count)#"<cfif Form.invoiceShippingMethod is ListGetAt(Variables.shippingMethodList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.shippingMethodList_label, count))#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td valign="top">Special Instructions: <div class="TableText">(Max. #maxlength_Invoice.invoiceInstructions# chars.)</div></td>
	<td><textarea name="invoiceInstructions" rows="4" cols="60" wrap="soft">#HTMLEditFormat(Form.invoiceInstructions)#</textarea></td>
</tr>
<tr bgcolor="dddddd">
	<td valign="top">Shipping Address: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="addressID_shipping" value="0"<cfif Form.addressID_shipping is 0 or Not ListFind(ValueList(qry_selectShippingAddressList.addressID), Form.addressID_shipping)> checked</cfif>></td>
			<td>No shipping address specified</td>
		</tr>
		<cfset Variables.count = 0>
		<cfloop Query="qry_selectShippingAddressList">
			<cfif qry_selectShippingAddressList.addressStatus is 1 or Form.addressID_shipping is qry_selectShippingAddressList.addressID>
				<cfset Variables.count = Variables.count + 1>
				<tr valign="top"<cfif (Variables.count mod 2) is 1> bgcolor="f4f4ff"</cfif>>
				<td><input type="radio" name="addressID_shipping" value="#qry_selectShippingAddressList.addressID#"<cfif Form.addressID_shipping is qry_selectShippingAddressList.addressID> checked</cfif>></td>
				<td>
					<cfif qry_selectShippingAddressList.addressName is not "">#qry_selectShippingAddressList.addressName#<br></cfif>
					<cfif qry_selectShippingAddressList.addressDescription is not "">#qry_selectShippingAddressList.addressDescription#<br></cfif>
					#qry_selectShippingAddressList.address#<br>
					<cfif qry_selectShippingAddressList.address2 is not "">#qry_selectShippingAddressList.address2#<br></cfif>
					<cfif qry_selectShippingAddressList.address3 is not "">#qry_selectShippingAddressList.address3#<br></cfif>
					#qry_selectShippingAddressList.city#, #qry_selectShippingAddressList.state# #qry_selectShippingAddressList.zipCode#<cfif qry_selectShippingAddressList.zipCodePlus4 is not "">-#qry_selectShippingAddressList.zipCodePlus4#</cfif>
					<cfif qry_selectShippingAddressList.country is not "" and Not ListFind("US,USA,United States", qry_selectShippingAddressList.country)><br>#qry_selectShippingAddressList.country#</cfif>
				</td>
				</tr>
			</cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr>
	<td valign="top">Billing Address: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td><input type="radio" name="addressID_billing" value="0"<cfif Form.addressID_billing is 0 or Not ListFind(ValueList(qry_selectBillingAddressList.addressID), Form.addressID_billing)> checked</cfif>></td>
			<td>No billing address specified</td>
		</tr>
		<cfset Variables.count = 0>
		<cfloop Query="qry_selectBillingAddressList">
			<cfif qry_selectBillingAddressList.addressStatus is 1 or Form.addressID_billing is qry_selectBillingAddressList.addressID>
				<cfset Variables.count = Variables.count + 1>
				<tr valign="top"<cfif (Variables.count mod 2) is 1> bgcolor="f4f4ff"</cfif>>
				<td><input type="radio" name="addressID_billing" value="#qry_selectBillingAddressList.addressID#"<cfif Form.addressID_billing is qry_selectBillingAddressList.addressID> checked</cfif>></td>
				<td>
					<cfif qry_selectBillingAddressList.addressName is not "">#qry_selectBillingAddressList.addressName#<br></cfif>
					<cfif qry_selectBillingAddressList.addressDescription is not "">#qry_selectBillingAddressList.addressDescription#<br></cfif>
					#qry_selectBillingAddressList.address#<br>
					<cfif qry_selectBillingAddressList.address2 is not "">#qry_selectBillingAddressList.address2#<br></cfif>
					<cfif qry_selectBillingAddressList.address3 is not "">#qry_selectBillingAddressList.address3#<br></cfif>
					#qry_selectBillingAddressList.city#, #qry_selectBillingAddressList.state# #qry_selectBillingAddressList.zipCode#<cfif qry_selectBillingAddressList.zipCodePlus4 is not "">-#qry_selectBillingAddressList.zipCodePlus4#</cfif>
					<cfif qry_selectBillingAddressList.country is not "" and Not ListFind("US,USA,United States", qry_selectBillingAddressList.country)><br>#qry_selectBillingAddressList.country#</cfif>
				</td>
				</tr>
			</cfif>
		</cfloop>
		</table>
	</td>
</tr>

<cfif Variables.doAction is "updateInvoice" and (qry_selectInvoice.creditCardID is not 0 or qry_selectInvoice.bankID is not 0)>
	<tr bgcolor="dddddd">
		<td valign="top">Credit Card: </td>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" class="TableText">
			<tr>
				<td><input type="radio" name="creditCardID" value="0"<cfif Form.creditCardID is 0 or Not ListFind(ValueList(qry_selectCreditCardList.creditCardID), Form.creditCardID)> checked</cfif>></td>
				<td>No credit card specified</td>
			</tr>
			<cfloop Query="qry_selectCreditCardList">
				<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
				<td><input type="radio" name="creditCardID" value="#qry_selectCreditCardList.creditCardID#"<cfif Form.creditCardID is qry_selectCreditCardList.creditCardID> checked</cfif>></td>
				<td>
					<cfif qry_selectCreditCardList.creditCardName is not "">#qry_selectCreditCardList.creditCardName#<br></cfif>
					<cfif qry_selectCreditCardList.creditCardType is not "">#qry_selectCreditCardList.creditCardType# &nbsp; </cfif>
					<cfif qry_selectCreditCardList.creditCardNumber is not "">#RepeatString("*", Len(qry_selectCreditCardList.creditCardNumber) - 4)##Right(qry_selectCreditCardList.creditCardNumber, 4)# &nbsp; </cfif>
					Expires #qry_selectCreditCardList.creditCardExpirationMonth#/#qry_selectCreditCardList.creditCardExpirationYear#
				</td>
				</tr>
			</cfloop>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">Bank Account: </td>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" class="TableText">
			<tr>
				<td><input type="radio" name="bankID" value="0"<cfif Form.bankID is 0 or Not ListFind(ValueList(qry_selectBankList.bankID), Form.bankID)> checked</cfif>></td>
				<td>No bank account specified</td>
			</tr>
			<cfloop Query="qry_selectBankList">
				<tr valign="top"<cfif (CurrentRow mod 2) is 1> bgcolor="f4f4ff"</cfif>>
				<td><input type="radio" name="bankID" value="#qry_selectBankList.bankID#"<cfif Form.bankID is qry_selectBankList.bankID> checked</cfif>></td>
				<td>
					<cfif qry_selectBankList.bankName is not "">#qry_selectBankList.bankName# </cfif>
					<cfif qry_selectBankList.bankAccountNumber is not "">#qry_selectBankList.bankAccountNumber#</cfif><br>
					<cfif qry_selectBankList.bankAccountName is not "">#qry_selectBankList.bankAccountName# </cfif>
					(<cfif qry_selectBankList.bankPersonalOrCorporate is 0>Personal<cfelse>Corporate</cfif> 
					<cfif qry_selectBankList.bankCheckingOrSavings is 0>Checking<cfelseif qry_selectBankList.bankCheckingOrSavings is 1>Savings<cfelseif qry_selectBankList.bankAccountType is not "">#qry_selectBankList.bankAccountType#</cfif>)
				</td>
				</tr>
			</cfloop>
			</table>
		</td>
	</tr>
</cfif>
</table>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitInvoice" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>

