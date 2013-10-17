<cfset errorMessage_fields = StructNew()>

<!--- 
null/required
email address
maxlength

html
--->

<cfloop Query="qry_selectContentCompanyList">
	<cfif Form["contentCompanyText#qry_selectContentCompanyList.contentID#"] is "" and qry_selectContentCompanyList.contentRequired is 1>
		<cfset errorMessage_fields["contentCompanyText#CurrentRow#"] = CurrentRow & ": " & Variables.lang_insertContentCompany.contentCompanyText_blank>
	<cfelseif qry_selectContentCompanyList.contentMaxlength gt 0 and Len(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"]) gt qry_selectContentCompanyList.contentMaxlength>
		<cfset errorMessage_fields["contentCompanyText#CurrentRow#"] = CurrentRow & ": " & ReplaceNoCase(ReplaceNoCase(Variables.lang_insertContentCompany.contentCompanyText_maxlength, "<<MAXLENGTH>>", qry_selectContentCompanyList.contentMaxlength, "ALL"), "<<LEN>>", Len(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"]), "ALL")>
	<cfelseif Len(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"]) gt maxlength_ContentCompany.contentCompanyText>
		<cfset errorMessage_fields["contentCompanyText#CurrentRow#"] = CurrentRow & ": " & ReplaceNoCase(ReplaceNoCase(Variables.lang_insertContentCompany.contentCompanyText_maxlength, "<<MAXLENGTH>>", maxlength_ContentCompany.contentCompanyText, "ALL"), "<<LEN>>", Len(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"]), "ALL")>
	<cfelseif ListFind(Variables.contentType_email, qry_selectContentCompanyList.contentType) and qry_selectContentCompanyList.contentRequired is 1 and Not fn_IsValidEmail(Form["contentCompanyText#qry_selectContentCompanyList.contentID#"])>
		<cfset errorMessage_fields["contentCompanyText#CurrentRow#"] = CurrentRow & ": " & Variables.lang_insertContentCompany.contentCompanyText_email>
	</cfif>

	<cfif qry_selectContentCompanyList.contentHtmlOk is 1 and Not ListFind("0,1", Form["contentCompanyHtml#qry_selectContentCompanyList.contentID#"])>
		<cfset errorMessage_fields["contentCompanyHtml#CurrentRow#"] = CurrentRow & ": " & Variables.lang_insertContentCompany.contentCompanyHtml>
	</cfif>
	<cfif qry_selectContentCompanyList.contentFilename is not "" and FindNoCase("<CF", Form["contentCompanyText#qry_selectContentCompanyList.contentID#"])>
		<cfset errorMessage_fields["contentFilename#CurrentRow#"] = CurrentRow & ": " & Variables.lang_insertContentCompany.contentFilename>
	</cfif>
</cfloop>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_insertContentCompany.errorTitle>
	<cfset errorMessage_header = Variables.lang_insertContentCompany.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertContentCompany.errorFooter>
</cfif>
