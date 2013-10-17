<cfoutput>
<form method="post" name="vendor" action="#Variables.formAction#" enctype="multipart/form-data">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="vendorStatus" value="1"<cfif Form.vendorStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="vendorStatus" value="0"<cfif Form.vendorStatus is not 1> checked</cfif>>Disabled</label>
	</td>
</tr>
<tr>
	<td>Vendor Name: </td>
	<td><input type="text" name="vendorName" value="#HTMLEditFormat(Form.vendorName)#" size="40" maxlength="#maxlength_Vendor.vendorName#"> (as displayed to users; may be different than company name)</td>
</tr>

<tr>
	<td>Vendor Code: </td>
	<td><input type="text" name="vendorCode" value="#HTMLEditFormat(Form.vendorCode)#" size="15" maxlength="#maxlength_Vendor.vendorCode#"> (combined with product code; enables searching by vendor)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="vendorID_custom" value="#HTMLEditFormat(Form.vendorID_custom)#" size="15" maxlength="#maxlength_Vendor.vendorID_custom#"> (for internal purposes only)</td>
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
	<td>Vendor URL: </td>
	<td>
		<input type="text" name="vendorURL" value="#HTMLEditFormat(Form.vendorURL)#" size="50" maxlength="#maxlength_Vendor.vendorURL#"> (link to vendor site)<br>
		<label><input type="checkbox" name="vendorURLdisplay" value="1"<cfif Form.vendorURLdisplay is 1> checked</cfif>> Check to display URL to vendor site to customers</label>
	</td>
</tr>

<tr valign="top">
	<td>Vendor Logo: </td>
	<td>
		<table border="0" cellspacing="2" cellpadding="2" class="TableText">
		<tr>
			<td><i>File</i>: </td>
			<td><input type="file" name="vendorImageFile" size="45"></td>
		</tr>
		<tr>
			<td><i>URL</i>: </td>
			<td><input type="text" name="vendorImage" value="#HTMLEditFormat(Form.vendorImage)#" size="50" maxlength="#maxlength_Vendor.vendorImage#"></td>
		</tr>
		</table>
	</td>
</tr>

<tr valign="top">
	<td>Vendor Description: </td>
	<td>
		<label><input type="checkbox" name="vendorDescriptionDisplay" value="1"<cfif Form.vendorDescriptionDisplay is 1> checked</cfif>> Check to display vendor description to customers</label><br>
		<select name="vendorDescriptionHtml" size="1">
		<option value="0"<cfif Form.vendorDescriptionHtml is 0> selected</cfif>>text</option>
		<option value="1"<cfif Form.vendorDescriptionHtml is 1> selected</cfif>>html</option>
		</select> 
		 (<i>if text format, carriage returns will be dipslayed properly</i>)<br>
		<textarea name="vendorDescription" rows="10" cols="60" wrap="virtual">#HTMLEditFormat(Form.vendorDescription)#</textarea><br>
		(<i>maximum #maxlength_Vendor.vendorDescription# characters</i>)
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

<p><input type="submit" name="submitVendor" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>
