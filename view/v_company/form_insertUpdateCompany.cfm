<cfoutput>
<form method="post" name="insertUpdateCompany" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<cfif Session.companyID is Application.billingSuperuserCompanyID and Application.billingSuperuserEnabled is True>
	<cfif Variables.doAction is "insertCompany">
		<script language="JavaScript">
		function toggle(target)
		{ obj=(document.all) ? document.all[target] : document.getElementById(target);
		  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
		}
		</script>
	</cfif>

	<tr>
		<td>Primary: </td>
		<td>
			<cfif URL.companyID is 0>
				<label><input type="checkbox" name="companyPrimary" value="1" onClick="toggle('showCompanyDirectory');"<cfif IsDefined("Form.companyPrimary") and Form.companyPrimary is 1> checked</cfif>>
				Company is a <i>primary</i> company, i.e., a user of the system.</label>
			<cfelseif qry_selectCompany.companyPrimary is 1>
				Yes, this company is a primary company, i.e., a user of the system.
			<cfelse>
				No, this company is not a primary company.
			</cfif>
		</td>
	</tr>
	<cfif Variables.doAction is "insertCompany"><tr id="showCompanyDirectory" style="display:none;"><cfelse><tr></cfif>
		<td>Directory: </td>
		<td class="TableText">
			<cfif Variables.doAction is "insertCompany">
				<input type="text" name="companyDirectory" value="#HTMLEditFormat(Form.companyDirectory)#" size="20" maxlength="#maxlength_Company.companyDirectory#"><br>
				Enter unique customer directory name. If blank, it is named as companyID with 3 random letters.
			<cfelse>
				#qry_selectCompany.companyDirectory#
			</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="companyStatus" value="1"<cfif Form.companyStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="companyStatus" value="0"<cfif Form.companyStatus is not 1> checked</cfif>> Disabled</label>
	</td>
</tr>
<tr>
	<td>Tax Status: </td>
	<td><label><input type="checkbox" name="companyIsTaxExempt" value="1"<cfif Form.companyIsTaxExempt is 1> checked</cfif>> Company is tax-exempt</label></td>
</tr>
<tr>
	<td>Company Name: </td>
	<td><input type="text" name="companyName" value="#HTMLEditFormat(Form.companyName)#" size="50" maxlength="#maxlength_Company.companyName#"></td>
</tr>
<tr>
	<td>Company DBA: </td>
	<td><input type="text" name="companyDBA" value="#HTMLEditFormat(Form.companyDBA)#" size="50" maxlength="#maxlength_Company.companyDBA#"></td>
</tr>

<tr>
	<td>Company URL: </td>
	<td><input type="text" name="companyURL" value="#HTMLEditFormat(Form.companyURL)#" size="50" maxlength="#maxlength_Company.companyURL#"></td>
</tr>
<tr>
	<td>Custom ID ##: </td>
	<td><input type="text" name="companyID_custom" value="#HTMLEditFormat(Form.companyID_custom)#" size="25" maxlength="#maxlength_Company.companyID_custom#"></td>
</tr>
<cfif Variables.doAction is "updateCompany">
	<tr>
		<td>Primary Contact: </td>
		<td>
			<cfif qry_selectUserCompanyList_company.RecordCount is 0>
				(This company has no users.)
			<cfelse>
				<select name="userID" size="1">
				<cfloop Query="qry_selectUserCompanyList_company">
					<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID is qry_selectUserCompanyList_company.userID> selected</cfif>>#qry_selectUserCompanyList_company.lastName#, #qry_selectUserCompanyList_company.firstName#</option>
				</cfloop>
				</select>
			</cfif>
		</td>
	</tr>
</cfif>

<cfif qry_selectAffiliateList.RecordCount is not 0>
	<tr>
		<td>Affiliate: </td>
		<td>
			<select name="affiliateID" size="1">
			<option value="0">-- NO AFFILIATE SPECIFIED --</option>
			<cfloop Query="qry_selectAffiliateList">
				<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(qry_selectAffiliateList.affiliateName)#</option>
			</cfloop> 
			</select>
		</td>
	</tr>
</cfif>

<cfif qry_selectCobrandList.RecordCount is not 0>
	<tr>
		<td>Cobrand: </td>
		<td>
			<select name="cobrandID" size="1">
			<option value="0">-- NO COBRAND SPECIFIED --</option>
			<cfloop Query="qry_selectCobrandList">
				<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(qry_selectCobrandList.cobrandName)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>

<tr><td><br><i>This company is a</i>:</td></tr>
<tr>
	<td>Customer: </td>
	<td><label><input type="checkbox" name="companyIsCustomer" value="1"<cfif Form.companyIsCustomer is 1> checked</cfif>>Company is a customer that makes purchases.</label></td>
</tr>
<tr>
	<td>Affiliate: </td>
	<td>
		<cfif Variables.doAction is "insertCompany">
			<label><input type="checkbox" name="companyIsAffiliate" value="1"<cfif Form.companyIsAffiliate is 1> checked</cfif>> 
			Check if company is an affiliate partner, meaning they link to the site and get credit for referrals.</label>
		<cfelseif Form.companyIsAffiliate is 0>
			No, company is not an affiliate partner.
		<cfelse>
			Yes, company is an affiliate partner. 
		</cfif>
	</td>
</tr>
<tr>
	<td>Cobrand Site: </td>
	<td>
		<cfif Variables.doAction is "insertCompany">
			<label><input type="checkbox" name="companyIsCobrand" value="1"<cfif Form.companyIsCobrand is 1> checked</cfif>> 
			Check if company is a cobrand partner, meaning they have a cobranded site.</label>
		<cfelseif Form.companyIsCobrand is 0>
			No, company is not a cobrand partner.
		<cfelse>
			Yes, company is a cobrand partner. 
		</cfif>
	</td>
</tr>
<tr>
	<td>Vendor: </td>
	<td>
		<cfif Variables.doAction is "insertCompany">
			<label><input type="checkbox" name="companyIsVendor" value="1"<cfif Form.companyIsVendor is 1> checked</cfif>> 
			Check if company is a vendor, meaning they provide products for sale.</label>
		<cfelseif Form.companyIsVendor is 0>
			No, company is not a vendor.
		<cfelse>
			Yes, company is a vendor.
		</cfif>
	</td>
</tr>
</table>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitInsertUpdateCompany" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>