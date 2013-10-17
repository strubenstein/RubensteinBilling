<cfoutput>
<form method="post" name="insertPayflow" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Variables.doAction is "insertPayflow">
	<tr>
		<td>Order: </td>
		<td>
			<select name="payflowOrder" size="1">
			<cfloop Query="qry_selectPayflowList">
				<option value="#qry_selectPayflowList.payflowOrder#"<cfif Form.payflowOrder is qry_selectPayflowList.payflowOrder> selected</cfif>>BEFORE ###qry_selectPayflowList.payflowOrder#. #HTMLEditFormat(qry_selectPayflowList.payflowName)#</option>
			</cfloop>
			<option value="0"<cfif Form.payflowOrder is 0> selected</cfif>>-- LAST --</option>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="payflowStatus" value="1"<cfif Form.payflowStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="payflowStatus" value="0"<cfif Form.payflowStatus is not 1> checked</cfif>>Inactive</label>
	</td>
</tr>
<tr>
	<td>Default: </td>
	<td><label><input type="checkbox" name="payflowDefault" value="1"<cfif Form.payflowDefault is 1> checked</cfif>> This is the default subscription processing method for all companies unless otherwise specified via group or company setting.</label></td>
</tr>
<tr>
	<td>Name: </td>
	<td><input type="text" name="payflowName" value="#HTMLEditFormat(Form.payflowName)#" size="40" maxlength="#maxlength_Payflow.payflowName#"> (required; must be unique)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="payflowID_custom" value="#HTMLEditFormat(Form.payflowID_custom)#" size="20" maxlength="#maxlength_Payflow.payflowID_custom#"> (optional; must be unique; for integration purposes)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="payflowDescription" value="#HTMLEditFormat(Form.payflowDescription)#" size="40" maxlength="#maxlength_Payflow.payflowDescription#"> (for internal purposes)</td>
</tr>
<tr valign="top">
	<td>Send Invoice: </td>
	<td>
		<label><input type="checkbox" name="payflowInvoiceSend" value="1"<cfif Form.payflowInvoiceSend is 1> checked</cfif>> Send invoice to customer (via customer-specified method)</label><br>
		<!--- 
		<input type="text" name="payflowInvoiceDaysFromSubscriberDate" value="#HTMLEditFormat(Form.payflowInvoiceDaysFromSubscriberDate)#" size="2"> 
		days from subscriber processing date (<i>0 or blank = send invoice on same day, if checked</i>)
		--->
	</td>
</tr>
<tr valign="top">
	<td>Process Payment: </td>
	<td>
		<!--- <label><input type="checkbox" name="payflowReceiptSend" value="1"<cfif Form.payflowReceiptSend is 1> checked</cfif>> Send receipt to customer if payment successful (via customer-specified method)</label><br> --->
		<input type="text" name="payflowChargeDaysFromSubscriberDate" value="#HTMLEditFormat(Form.payflowChargeDaysFromSubscriberDate)#" size="2">  
		days from subscriber processing date
		<div class="SmallText">
			If blank or zero, send invoice and charge customer on the same day. 
			Otherwise, schedule payment for X days after invoice is processed.<br>
			If customer is not paying automatically via credit card or bank, set invoice due date instead.
		</div>
	</td>
</tr>
<!--- 
<tr valign="top">
	<td>If Rejection: </td>
	<td>
		<input type="text" name="payflowRejectRescheduleDays" value="#HTMLEditFormat(Form.payflowRejectRescheduleDays)#" size="2"> 
		days to wait before attempting to process payment again (<i>0 or blank = do not re-schedule</i>)<br>
		<label><input type="checkbox" name="payflowRejectNotifyCustomer" value="1"<cfif Form.payflowRejectNotifyCustomer is 1> checked</cfif>> Notify customer (via customer-specified method)</label><br>
		<label><input type="checkbox" name="payflowRejectNotifyAdmin" value="1"<cfif Form.payflowRejectNotifyAdmin is 1> checked</cfif>> Notify designated admin user(s) (via user-specified method)</label><br>
		<label><input type="checkbox" name="payflowRejectTask" value="1"<cfif Form.payflowRejectTask is 1> checked</cfif>> Create <i>task</i> for designated admin user(s)</label><br>
	</td>
</tr>
<tr><td colspan="2">Maximum rejections before manual action should be taken:</td></tr>
<tr>
	<td>Per Invoice: </td>
	<td>
		<input type="text" name="payflowRejectMaximum_invoice" value="#HTMLEditFormat(Form.payflowRejectMaximum_invoice)#" size="2"> 
		(for each invoice)
	</td>
</tr>
<tr>
	<td>Per Subscriber: </td>
	<td>
		<input type="text" name="payflowRejectMaximum_subscriber" value="#HTMLEditFormat(Form.payflowRejectMaximum_subscriber)#" size="2"> 
		(for all invoices processed for this customer subscriber setting)
	</td>
</tr>
<tr>
	<td>Per Customer: </td>
	<td>
		<input type="text" name="payflowRejectMaximum_company" value="#HTMLEditFormat(Form.payflowRejectMaximum_company)#" size="2"> 
		(for all invoices processed for this customer)
	</td>
</tr>
--->

	
<tr>
	<td>Invoice/Receipt Template: </td>
	<td>
		<select name="templateID" size="1">
		<option value="0">-- SELECT TEMPLATE --</option>
		<cfloop Query="qry_selectTemplateList">
			<option value="#qry_selectTemplateList.templateID#"<cfif Form.templateID is qry_selectTemplateList.templateID> selected</cfif>>#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
		</cfloop>
		</select>
	</td>
</tr>
<tr>
	<td colspan="2"><b>Email Fields:</b></td>
</tr>
<tr>
	<td>Subject: </td>
	<td><input type="text" name="payflowEmailSubject" value="#HTMLEditFormat(Form.payflowEmailSubject)#" size="40" maxlength="#maxlength_Payflow.payflowEmailSubject#"></td>
</tr>
<tr>
	<td>From Name: </td>
	<td><input type="text" name="payflowEmailFromName" value="#HTMLEditFormat(Form.payflowEmailFromName)#" size="40" maxlength="#maxlength_Payflow.payflowEmailFromName#"> (who email is from)</td>
</tr>
<tr>
	<td>Reply-To: </td>
	<td><input type="text" name="payflowEmailReplyTo" value="#HTMLEditFormat(Form.payflowEmailReplyTo)#" size="40" maxlength="#maxlength_Payflow.payflowEmailReplyTo#"> (email address)</td>
</tr>
<tr>
	<td>CC: </td>
	<td><input type="text" name="payflowEmailCC" value="#HTMLEditFormat(Form.payflowEmailCC)#" size="40" maxlength="#maxlength_Payflow.payflowEmailCC#"> (separate multiple email addresses with a comma)</td>
</tr>
<tr>
	<td>BCC: </td>
	<td><input type="text" name="payflowEmailBCC" value="#HTMLEditFormat(Form.payflowEmailBCC)#" size="40" maxlength="#maxlength_Payflow.payflowEmailBCC#"> (separate multiple email addresses with a comma)</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitPayflow" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>
