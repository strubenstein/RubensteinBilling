<cfset errorMessage_fields = StructNew()>

<cfif Trim(Form.searchText) is not "" and Trim(Form.searchField) is "">
	<cfset errorMessage_fields.searchField = Variables.lang_listAffiliates.searchField>
</cfif>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listAffiliates[field]>
	</cfif>
</cfloop>

<cfif Form.statusID is not "" and Form.statusID is not 0 and Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
	<cfset errorMessage_fields.statusID = Variables.lang_listAffiliates.statusID>
</cfif>

<cfif Form.groupID is not "" and Form.groupID is not 0 and Not ListFind(ValueList(qry_selectGroupList.groupID), Form.groupID)>
	<cfset errorMessage_fields.groupID = Variables.lang_listAffiliates.groupID>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listAffiliates.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listAffiliates.queryPage>
</cfif>

<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
	<cfif Len(Form.queryFirstLetter) gt 1 and Form.queryFirstLetter is not "0-9">
		<cfset errorMessage_fields.queryFirstLetter = Variables.lang_listAffiliates.queryFirstLetter>
	<cfelseif Not REFindNoCase("[A-Za-z]", Form.queryFirstLetter)>
		<cfset errorMessage_fields.queryFirstLetter = Variables.lang_listAffiliates.queryFirstLetter>
	</cfif>
</cfif>

<cfif Form.affiliateIsExported is not "" and Not ListFind("-1,0,1", Form.affiliateIsExported)>
	<cfset errorMessage_fields.affiliateIsExported = Variables.lang_listAffiliates.affiliateIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listAffiliates.errorTitle>
	<cfset errorMessage_header = Variables.lang_listAffiliates.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listAffiliates.errorFooter>
</cfif>

