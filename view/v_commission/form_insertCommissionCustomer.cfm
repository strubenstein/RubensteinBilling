<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p class="MainText" style="width: 650">You may specify whether the salesperson receives a commission on all invoices for this company, or only those for a particular user (for manual invoices) or subscriber (for subscription-based invoices). If the salesperson receives a commission for all company invoices, leave Contact and Subscriber set to &quot;all&quot;. If a salesperson gets paid for more than one contact/subscriber but not all, you must create separate entries for each.</p>

<p class="MainText" style="width: 650">If entering a begin date before today, back- sales commissions are <i>not</i> calculated. However, it will be used for the purpose of determining which stage of a commission plan the salesperson is currently in for the purposes of calculating future sales commissions.</p>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Salesperson: </td>
	<td>
		<cfif Variables.doAction is "insertCommissionCustomer">
			<select name="targetID" size="1">
			<option value="0">-- SELECT --</option>
			<cfloop Query="qry_selectUserCompanyList_company">
				<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.targetID is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
			</cfloop>
			</select>
		<cfelse>
			<cfset Variables.userRow = ListFind(ValueList(qry_selectUserCompanyList_company.userID), Form.targetID)>
			<cfif Variables.userRow is 0>
				???
			<cfelse>
				#qry_selectUserCompanyList_company.firstName[Variables.userRow]# #qry_selectUserCompanyList_company.lastName[Variables.userRow]#
			</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Percentage: </td>
	<td>
		<input type="text" name="commissionCustomerPercent" value="#HTMLEditFormat(Application.fn_LimitPaddedDecimalZerosQuantity(Form.commissionCustomerPercent, 4))#" size="6" maxlength="6">% 
		(percentage of calculated commission salesperson should receive; 0-100 where 10 = 10%)
	</td>
</tr>
<tr>
	<td>Primary: </td>
	<td><label><input type="checkbox" name="commissionCustomerPrimary" value="1"<cfif Form.commissionCustomerPrimary is 1> checked</cfif>> Salesperson is primary salesperson for this customer.</label></td>
</tr>
<tr>
	<td>Begin Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "commissionCustomerDateBegin", Form.commissionCustomerDateBegin, "", 0, "", 0, "", "am", True)# (If blank, defaults to today.)</td>
</tr>
<tr>
	<td>End Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "commissionCustomerDateEnd", Form.commissionCustomerDateEnd, "", 0, "", 0, "", "am", True)# (If blank, commissions continue for life of customer)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="commissionCustomerDescription" value="#HTMLEditFormat(Form.commissionCustomerDescription)#" size="50" maxlength="#maxlength_CommissionCustomer.commissionCustomerDescription#"> (for internal use only)</td>
</tr>
<tr><td colspan="2">If no contacts/subscribers are selected, all are included.</td></tr>
<tr valign="top">
	<td>Contact(s): </td>
	<td>
		<cfif qry_selectUserCompanyList_customer.RecordCount is 0>
			n/a
		<cfelse>
			<select name="userID" size="4" class="TableText" multiple>
			<option value="0"<cfif ListFind(Form.userID, 0)> selected</cfif>>-- ALL CONTACTS --</option>
			<cfloop Query="qry_selectUserCompanyList_customer">
				<option value="#qry_selectUserCompanyList_customer.userID#"<cfif ListFind(Form.userID, qry_selectUserCompanyList_customer.userID)> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_customer.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_customer.firstName)#</option>
			</cfloop>
			</select>
		</cfif> 
		(contact for manual invoices)
	</td>
</tr>
<tr valign="top">
	<td>Subscriber(s): </td>
	<td>
		<cfif qry_selectSubscriberList.RecordCount is 0>
			n/a
		<cfelse>
			<select name="subscriberID" size="4" class="TableText" multiple>
			<option value="0"<cfif ListFind(Form.subscriberID, 0)> selected</cfif>>-- ALL SUBSCRIBERS --</option>
			<cfloop Query="qry_selectSubscriberList">
				<option value="#qry_selectSubscriberList.subscriberID#"<cfif ListFind(Form.subscriberID, qry_selectSubscriberList.subscriberID)> selected</cfif>>#HTMLEditFormat(qry_selectSubscriberList.subscriberName)#</option>
			</cfloop>
			</select>
		</cfif>
		(subscriber for automated subscription-based invoices)
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><input type="submit" name="submitCommissionCustomer" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>

