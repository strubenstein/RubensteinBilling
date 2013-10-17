<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript">
function toggle(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
}

function toggleOn(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display = 'inline';
}

function toggleOff(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display = 'none';
}
</script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif ListFind("invoice,salesCommission", URL.control)>
	<tr>
		<td>Recipient Type: </td>
		<td>
			<cfif qry_selectAffiliateList.RecordCount is not 0>
				<label><input type="radio" name="primaryTargetKey" value="affiliateID" onClick="toggleOn('affiliate');toggleOff('cobrand');toggleOff('user');toggleOff('vendor');" <cfif Form.primaryTargetKey is "affiliateID"> checked</cfif>>Affiliate</label> &nbsp; 
			</cfif>
			<cfif qry_selectCobrandList.RecordCount is not 0>
				<label><input type="radio" name="primaryTargetKey" value="cobrandID" onClick="toggleOff('affiliate');toggleOn('cobrand');toggleOff('user');toggleOff('vendor');" <cfif Form.primaryTargetKey is "cobrandID"> checked</cfif>>Cobrand</label> &nbsp; 
			</cfif>
			<label><input type="radio" name="primaryTargetKey" value="userID" onClick="toggleOff('affiliate');toggleOff('cobrand');toggleOn('user');toggleOff('vendor');" <cfif Form.primaryTargetKey is "userID"> checked</cfif>>User</label> &nbsp; 
			<cfif qry_selectVendorList.RecordCount is not 0>
				<label><input type="radio" name="primaryTargetKey" value="vendorID" onClick="toggleOff('affiliate');toggleOff('cobrand');toggleOff('user');toggleOn('vendor');" <cfif Form.primaryTargetKey is "vendorID"> checked</cfif>>Vendor</label>
			</cfif>
		</td>
	</tr>
	<tr valign="top">
		<td>Recipient: </td>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" id="affiliate" <cfif Form.primaryTargetKey is not "affiliateID"> style="display:none;"</cfif>><tr><td>
			<cfif qry_selectAffiliateList.RecordCount is 0>
				[ No Affiliates ]
			<cfelse>
				<select name="affiliateID" size="1">
				<cfloop Query="qry_selectAffiliateList"><option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option></cfloop>
				</select>
			</cfif>
			</td></tr></table>

			<table border="0" cellspacing="0" cellpadding="0" id="cobrand" <cfif Form.primaryTargetKey is not "cobrandID"> style="display:none;"</cfif>><tr><td>
			<cfif qry_selectCobrandList.RecordCount is 0>
				[ No Cobrands ]
			<cfelse>
				<select name="cobrandID" size="1">
				<cfloop Query="qry_selectCobrandList"><option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option></cfloop>
				</select>
			</cfif>
			</td></tr></table>

			<table border="0" cellspacing="0" cellpadding="0" id="user" <cfif Form.primaryTargetKey is not "userID"> style="display:none;"</cfif>><tr><td>
			<select name="userID" size="1">
			<cfif URL.control is "invoice" and qry_selectCommissionCustomerList.RecordCount is not 0>
				<option value="0">-- SALESPERSON(S) --</option>
				<cfloop Query="qry_selectCommissionCustomerList"><option value="#qry_selectCommissionCustomerList.targetID#"<cfif Form.userID is qry_selectCommissionCustomerList.targetID> selected</cfif>>#HTMLEditFormat(qry_selectCommissionCustomerList.lastName)#, #HTMLEditFormat(qry_selectCommissionCustomerList.firstName)#</option></cfloop>
				<option value="0">-- ALL USER(S) --</option>
			</cfif>
			<cfloop Query="qry_selectUserCompanyList_company"><option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option></cfloop>
			</select>
			</td></tr></table>

			<table border="0" cellspacing="0" cellpadding="0" id="vendor" <cfif Form.primaryTargetKey is not "vendorID"> style="display:none;"</cfif>><tr><td>
			<cfif qry_selectVendorList.RecordCount is 0>
				[ No Vendors ]
			<cfelse>
				<select name="vendorID" size="1">
				<cfloop Query="qry_selectVendorList"><option value="#qry_selectVendorList.vendorID#"<cfif Form.vendorID is qry_selectVendorList.vendorID> selected</cfif>>#HTMLEditFormat(Left(qry_selectVendorList.vendorName, 30))#</option></cfloop>
				</select>
			</cfif>
			</td></tr></table>
		</td>
	</tr>
</cfif>
<tr><td class="SmallText" colspan="2">&nbsp;</td></tr>
<tr>
	<td>Amount: </td>
	<td>$<input type="text" name="salesCommissionAmount" size="10" value="#HTMLEditFormat(Form.salesCommissionAmount)#"> (may be negative)</td>
</tr>
<tr>
	<td>Paid: </td>
	<td>
		<label style="color: red"><input type="radio" name="salesCommissionPaid" value=""<cfif Form.salesCommissionPaid is ""> checked</cfif>>Not Paid</label> &nbsp; 
		<label style="color: gold"><input type="radio" name="salesCommissionPaid" value="0"<cfif Form.salesCommissionPaid is 0> checked</cfif>>Partially Paid</label> &nbsp; 
		<label style="color: green"><input type="radio" name="salesCommissionPaid" value="1"<cfif Form.salesCommissionPaid is 1> checked</cfif>>Fully Paid</label>
	</td>
</tr>
<tr><td colspan="2"><i>Optional Information</i>:</td></tr>
<tr>
	<td>Revenue Basis: </td>
	<td>$<input type="text" name="salesCommissionBasisTotal" size="10" value="#HTMLEditFormat(Form.salesCommissionBasisTotal)#"></td>
</tr>
<tr>
	<td>Quantity Basis: </td>
	<td>&nbsp;<input type="text" name="salesCommissionBasisQuantity" size="10" value="#HTMLEditFormat(Form.salesCommissionBasisQuantity)#"></td>
</tr>
<tr>
	<td>Begin Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "salesCommissionDateBegin", Form.salesCommissionDateBegin, "", 0, "", 0, "", "am", True)#</td>
</tr>
<tr>
	<td>End Date: </td>
	<td>#fn_FormSelectDateTime(Variables.formName, "salesCommissionDateEnd", Form.salesCommissionDateEnd, "", 0, "", 0, "", "am", True)#</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitSalesCommission" value="Add Sales Commission"></td>
</tr>
</table>
</form>
</cfoutput>
