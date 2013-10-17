<cfoutput>
<form method="post" name="affiliate" action="#Variables.formAction#" enctype="multipart/form-data">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="affiliateStatus" value="1"<cfif Form.affiliateStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="affiliateStatus" value="0"<cfif Form.affiliateStatus is not 1> checked</cfif>>Disabled</label>
	</td>
</tr>
<tr>
	<td>Affiliate Name: </td>
	<td><input type="text" name="affiliateName" value="#HTMLEditFormat(Form.affiliateName)#" size="40" maxlength="#maxlength_Affiliate.affiliateName#"> (for internal reference; may be different than company name)</td>
</tr>

<tr>
	<td>Affiliate Code: </td>
	<td><input type="text" name="affiliateCode" value="#HTMLEditFormat(Form.affiliateCode)#" size="15" maxlength="#maxlength_Affiliate.affiliateCode#"> (used in link from affiliate site for tracking)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="affiliateID_custom" value="#HTMLEditFormat(Form.affiliateID_custom)#" size="15" maxlength="#maxlength_Affiliate.affiliateID_custom#"> (for internal purposes only)</td>
</tr>

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

<tr valign="top">
	<td>Affiliate URL: </td>
	<td><input type="text" name="affiliateURL" value="#HTMLEditFormat(Form.affiliateURL)#" size="50" maxlength="#maxlength_Affiliate.affiliateURL#"> (URL of affiliate site; for internal purposes)</td>
</tr>
</table>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitAffiliate" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></p>
</form>
</cfoutput>
