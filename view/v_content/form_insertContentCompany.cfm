<cfoutput>
<form method="post" name="insertContentCompany" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="3">
<!--- contentCode, contentType --->
<cfloop Query="qry_selectContentCompanyList">
	<tr valign="top" class="MainText"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<cfif qry_selectContentCompanyList.contentRequired is 1>*</cfif>
			#qry_selectContentCompanyList.contentName#: 
		</td>
		<td>
			<cfif qry_selectContentCompanyList.contentMaxlength is 0 or qry_selectContentCompanyList.contentMaxlength gt 255>
				<textarea name="contentCompanyText#qry_selectContentCompanyList.contentID#" rows="10" cols="80" wrap="virtual">#HTMLEditFormat(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"])#</textarea><br>
			<cfelse>
				<input type="text" name="contentCompanyText#qry_selectContentCompanyList.contentID#" value="#HTMLEditFormat(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"])#" size="#Min(50,qry_selectContentCompanyList.contentMaxlength)#" maxlength="#qry_selectContentCompanyList.contentMaxlength#"><br>
			</cfif>
			<cfif qry_selectContentCompanyList.contentHtmlOk is 1>
				<label><input type="checkbox" name="contentCompanyHtml#qry_selectContentCompanyList.contentID#" value="1"<cfif Form["contentCompanyHtml#qry_selectContentCompanyList.contentID#"] is 1> checked</cfif>>Is in html format (instead of plain text)</label><br>
			</cfif>
			<font class="TableText">
			<i>Maximum Length</i>: <cfif qry_selectContentCompanyList.contentMaxlength is 0>#maxlength_ContentCompany.contentCompanyText#<cfelse>#qry_selectContentCompanyList.contentMaxlength#</cfif> characters
			<cfif qry_selectContentCompanyList.contentDescription is not ""><br><i>Description</i>: #HTMLEditFormat(qry_selectContentCompanyList.contentDescription)#</cfif>
			</font>
		</td>
	</tr>
</cfloop>

<tr>
	<td></td>
	<td><input type="submit" name="submitContentCompany" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>