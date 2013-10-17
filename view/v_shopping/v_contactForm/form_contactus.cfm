<cfoutput>
<form method="post" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellpadding="2" cellspacing="2" class="MainText">
<!--- if user is already logged in, no need to request personal information --->
<cfif Session.userID is 0>
	<tr>
		<td>* Name: </td>
		<td nowrap><input type="text" name="firstName" value="#HTMLEditFormat(Form.firstName)#" size="10" maxlength="50"> <input type="text" name="lastName" value="#HTMLEditFormat(Form.lastName)#" size="12" maxlength="50"></td>
	</tr>
	<tr>
		<td>Company: </td>
		<td><input type="text" name="companyName" value="#HTMLEditFormat(Form.companyName)#" size="30" maxlength="255"></td>
	</tr>
	<tr>
		<td>* Email: </td>
		<td><input type="text" name="email" value="#HTMLEditFormat(Form.email)#" size="30" maxlength="100"></td>
	</tr>
	<tr>
		<td>Phone: </td>
		<td>
			(<input type="text" name="phoneAreaCode" value="#HTMLEditFormat(Form.phoneAreaCode)#" size="2" maxlength="5">) 
			<input type="text" name="phoneNumber" value="#HTMLEditFormat(Form.phoneNumber)#" size="7" maxlength="10"> &nbsp; 
			ext. <input type="text" name="phoneExtension" value="#HTMLEditFormat(Form.phoneExtension)#" size="2" maxlength="5">
		</td>
	</tr>
	<tr>
		<td>Address: </td>
		<td><input type="text" name="address" value="#HTMLEditFormat(Form.address)#" size="30" maxlength="100"></td>
	</tr>
	<tr>
		<td>City, ST Zip/Postal: </td>
		<td>
			<input type="text" name="city" value="#HTMLEditFormat(Form.city)#" size="15" maxlength="50">,
			<select name="state" size="1">
			<cfinclude template="../../v_address/form_selectState.cfm">
			</select>
			<input type="text" name="zipCode" value="#HTMLEditFormat(Form.zipCode)#" size="5" maxlength="15">
		</td>
	</tr>
	<tr>
		<td>Country: </td>
		<td>
			<select name="country" size="1">
			<cfinclude template="../../v_address/form_selectCountry.cfm">
			</select>
		</td>
	</tr>
</cfif>

<cfif qry_selectContactTopicList.RecordCount is not 0>
	<tr>
		<td>Reason for contact: </td>
		<td>
			<select name="contactTopicID" size="1">
			<option value="0">-- SELECT --</option>
			<cfloop Query="qry_selectContactTopicList">
				<option value="#qry_selectContactTopicList.contactTopicID#"<cfif Form.contactTopicID is qry_selectContactTopicList.contactTopicID> selected</cfif>>#HTMLEditFormat(qry_selectContactTopicList.contactTopicTitle)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
</cfif>
<tr>
	<td>Subject: </td>
	<td><input type="text" name="contactSubject" value="#HTMLEditFormat(Form.contactSubject)#" size="50" maxlength="100"></td>
</tr>
<tr valign="top">
	<td>Your Message: </td>
	<td><textarea name="contactMessage" cols="60" rows="8">#HTMLEditFormat(Form.contactMessage)#</textarea></td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td><input type="submit" name="submitContact" value="Submit"></td>
</tr>
</table>
</form>
</cfoutput>