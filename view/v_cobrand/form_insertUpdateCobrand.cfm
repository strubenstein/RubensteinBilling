<cfoutput>
<form method="post" name="cobrand" action="#Variables.formAction#" enctype="multipart/form-data">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="cobrandStatus" value="1"<cfif Form.cobrandStatus is 1> checked</cfif>>Active</label> &nbsp; &nbsp; 
		<label style="color: red"><input type="radio" name="cobrandStatus" value="0"<cfif Form.cobrandStatus is not 1> checked</cfif>>Disabled</label>
	</td>
</tr>
<tr>
	<td>Cobrand Name: </td>
	<td><input type="text" name="cobrandName" value="#HTMLEditFormat(Form.cobrandName)#" size="40" maxlength="#maxlength_Cobrand.cobrandName#"> (for internal purposes; may be different than company name)</td>
</tr>
<tr>
	<td>Cobrand Title: </td>
	<td><input type="text" name="cobrandTitle" value="#HTMLEditFormat(Form.cobrandTitle)#" size="40" maxlength="#maxlength_Cobrand.cobrandTitle#"> (as displayed to users; may be different than company name)</td>
</tr>

<tr>
	<td>Cobrand Code: </td>
	<td><input type="text" name="cobrandCode" value="#HTMLEditFormat(Form.cobrandCode)#" size="15" maxlength="#maxlength_Cobrand.cobrandCode#"> (can be used in link from cobrand site for tracking)</td>
</tr>
<tr>
	<td>Cobrand Domain: </td>
	<td><input type="text" name="cobrandDomain" value="#HTMLEditFormat(Form.cobrandDomain)#" size="15" maxlength="#maxlength_Cobrand.cobrandDomain#"> (domain name and extension, e.g., &quot;<i><cfif fn_GetDomainFromURL(Application.billingUrl) is "">agreedis.org<cfelse>#fn_GetDomainFromURL(Application.billingUrl)#</cfif></i>&quot;; can be used for tracking)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="cobrandID_custom" value="#HTMLEditFormat(Form.cobrandID_custom)#" size="15" maxlength="#maxlength_Cobrand.cobrandID_custom#"> (for internal purposes only)</td>
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
	<td>Cobrand URL: </td>
	<td><input type="text" name="cobrandURL" value="#HTMLEditFormat(Form.cobrandURL)#" size="50" maxlength="#maxlength_Cobrand.cobrandURL#"> (for link back to cobrand site or internal purposes)</td>
</tr>
<tr>
	<td>Cobrand Directory: </td>
	<td><input type="text" name="cobrandDirectory" value="#HTMLEditFormat(Form.cobrandDirectory)#" size="15" maxlength="#maxlength_Cobrand.cobrandDirectory#"> (directory that stores images and header/footer files for cobrand; cobrand can link to)</td>
</tr>
<tr valign="top">
	<td>Cobrand Logo: </td>
	<td>
		<table border="0" cellspacing="2" cellpadding="2" class="TableText">
		<tr>
			<td><i>File</i>: </td>
			<td><input type="file" name="cobrandImageFile" size="45"></td>
		</tr>
		<tr>
			<td><i>URL</i>: </td>
			<td><input type="text" name="cobrandImage" value="#HTMLEditFormat(Form.cobrandImage)#" size="50" maxlength="#maxlength_Cobrand.cobrandImage#"></td>
		</tr>
		</table>
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

<p><input type="submit" name="submitCobrand" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td></p>
</form>
</cfoutput>
