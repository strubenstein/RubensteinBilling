<!--- 
companyID,
statusID,
languageID
--->
<cfset Variables.salutationList = "Mr.,Ms.,Miss,Mrs.,Dr.">
<cfset Variables.suffixList = "Jr.,Sr.,I,II,III,IV">

<cfoutput>
<cfif Variables.doAction is "insertUser" and (Not IsDefined("URL.companyID") or URL.companyID is 0 or URL.companyID is Session.companyID)>
	<p class="MainText">The new user you create below will be added to your company.</p>
<cfelseif Variables.doAction is "updateUser">
	<p class="MainText">Only enter the password (and verify it) if updating the password. Otherwise, just leave it blank.</p>
</cfif>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Username: </td>
	<td><input type="text" name="username" size="20" maxlength="#maxlength_User.username#" value="#HTMLEditFormat(Form.username)#"></td>
</tr>
<tr>
	<td>Password: </td>
	<td><input type="password" name="password" size="20" maxlength="50" value="#HTMLEditFormat(Form.password)#"></td>
</tr>
<tr>
	<td>(Verify) </td>
	<td><input type="password" name="passwordVerify" size="20" maxlength="50" value="#HTMLEditFormat(Form.passwordVerify)#"></td>
</tr>
<tr>
	<td valign="top">User Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="userStatus" value="1"<cfif Form.userStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="userStatus" value="0"<cfif Form.userStatus is not 1> checked</cfif>> Banned</label> (cannot log in)<br>
	</td>
</tr>
<tr>
	<td>Custom User ID: </td>
	<td><input type="text" name="userID_custom" size="20" maxlength="#maxlength_User.userID_custom#" value="#HTMLEditFormat(Form.userID_custom)#"></td>
</tr>
<tr>
	<td>Salutation: </td>
	<td>
		<select name="salutation_select" size="1">
		<option value=""></option>
		<cfset Variables.isSalutationSelect = False>
		<cfloop Index="salute" List="#Variables.salutationList#">
			<option value="#HTMLEditFormat(salute)#"<cfif Form.salutation_select is salute> selected<cfset Variables.isSalutationSelect = True></cfif>>#HTMLEditFormat(salute)#</option>
		</cfloop>
		</select> 
		<i>Other</i>: <input type="text" name="salutation_text" size="5" maxlength="#maxlength_User.salutation#"<cfif Variables.isSalutationSelect is False> value="#HTMLEditFormat(Form.salutation_text)#"</cfif>>
	</td>
</tr>
<tr>
	<td>First Name: </td>
	<td><input type="text" name="firstName" size="20" maxlength="#maxlength_User.firstName#" value="#HTMLEditFormat(Form.firstName)#"></td>
</tr>
<tr>
	<td>Middle: </td>
	<td><input type="text" name="middleName" size="20" maxlength="#maxlength_User.middleName#" value="#HTMLEditFormat(Form.middleName)#"></td>
</tr>
<tr>
	<td>Last Name: </td>
	<td><input type="text" name="lastName" size="20" maxlength="#maxlength_User.lastName#" value="#HTMLEditFormat(Form.lastName)#"></td>
</tr>
<tr>
	<td>Suffix: </td>
	<td>
		<select name="suffix_select" size="1">
		<option value=""></option>
		<cfset Variables.isSuffixSelect = False>
		<cfloop Index="suff" List="#Variables.suffixList#">
			<option value="#HTMLEditFormat(suff)#"<cfif Form.suffix_select is suff> selected<cfset Variables.isSuffixSelect = True></cfif>>#HTMLEditFormat(suff)#</option>
		</cfloop>
		</select> 
		<i>Other</i>: <input type="text" name="suffix_text" size="5" maxlength="#maxlength_User.suffix#"<cfif Variables.isSuffixSelect is False> value="#HTMLEditFormat(Form.suffix_text)#"</cfif>>
	</td>
</tr>
<tr>
	<td>Email: </td>
	<td><input type="text" name="email" size="40" maxlength="#maxlength_User.email#" value="#HTMLEditFormat(Form.email)#"></td>
</tr>
<tr>
	<td valign="top">Newsletter: </td>
	<td>
		<label><input type="checkbox" name="userNewsletterStatus" value="1"<cfif Form.userNewsletterStatus is 1> checked</cfif>> Send newsletter to user</label>
		<div class="TableText">
		&nbsp; &nbsp; &nbsp; &nbsp; <label><input type="radio" name="userNewsletterHtml" value="1"<cfif Form.userNewsletterHtml is 1> checked</cfif>> HTML format</label> &nbsp; &nbsp; 
		<label><input type="radio" name="userNewsletterHtml" value="0"<cfif Form.userNewsletterHtml is not 1> checked</cfif>> Text format</label> 
		</div>
	</td>
</tr>
<tr>
	<td valign="top">Job Department: </td>
	<td>
		<select name="jobDepartment_select" size="1">
		<option value="">-- SELECT EXISTING DEPARTMENT --</option>
		<cfloop Query="qry_selectUserJobDepartmentList">
			<option value="#HTMLEditFormat(qry_selectUserJobDepartmentList.jobDepartment)#"<cfif Form.jobDepartment_select is qry_selectUserJobDepartmentList.jobDepartment> selected</cfif>>#HTMLEditFormat(qry_selectUserJobDepartmentList.jobDepartment)#</option>
		</cfloop>
		</select><br>
		<i>New</i>: <input type="text" name="jobDepartment_text" size="34" maxlength="#maxlength_User.jobDepartment#" value="#HTMLEditFormat(Form.jobDepartment_text)#">
	</td>
</tr>
<tr>
	<td>Job Title: </td>
	<td><input type="text" name="jobTitle" size="40" maxlength="#maxlength_User.jobTitle#" value="#HTMLEditFormat(Form.jobTitle)#"></td>
</tr>

<tr valign="top">
	<td>Email Verifiication: </td>
	<td>
		<table border="0" cellspacing="0" cellpadding="0" class="MainText">
		<tr>
			<td>Status: </td>
			<td>
				<input type="radio" name="userEmailVerified" value=""<cfif Form.userEmailVerified is ""> checked</cfif>>Not Requested</label> &nbsp; 
				<label style="color: red"><input type="radio" name="userEmailVerified" value="0"<cfif Form.userEmailVerified is 0> checked</cfif>>Not Verified</label> &nbsp; 
				<label style="color: green"><input type="radio" name="userEmailVerified" value="1"<cfif Form.userEmailVerified is 1> checked</cfif>>Verified</label>
				<cfif Variables.doAction is "updateUser" and IsDate(qry_selectUser.userEmailDateVerified)> (on #DateFormat(qry_selectUser.userEmailDateVerified, "mm/dd/yyyy")# at #TimeFormat(qry_selectUser.userEmailDateVerified, "hh:mm tt")#)</cfif>
			</td>
		</tr>
		<tr>
			<td valign="top">Code: </td>
			<td>
				<cfif Variables.doAction is "insertUser" or qry_selectUser.userEmailVerifyCode is "">(none)<cfelse>#qry_selectUser.userEmailVerifyCode#</cfif><br>
				<label><input type="checkbox" name="generateUserEmailVerifyCode" value="1"<cfif IsDefined("Form.generateUserEmailVerifyCode")> checked</cfif>> Check to generate a new unique code.</label><br>
				<label><input type="checkbox" name="sendUserEmailVerifyCode" value="1"<cfif IsDefined("Form.sendUserEmailVerifyCode")> checked</cfif>> Send verification email to user.</label>
			</td>
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

<input type="submit" name="submitUser" value="#HTMLEditFormat(Variables.formSubmitValue)#">
</form>
</cfoutput>

