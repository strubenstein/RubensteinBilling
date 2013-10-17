<cfset errorMessage_fields = StructNew()>

<cfif Trim(Form.searchText) is not "" and Trim(Form.searchField) is "">
	<cfset errorMessage_fields.searchField = Variables.lang_listCompanies.searchField>
</cfif>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listCompanies[field]>
	</cfif>
</cfloop>

<cfif Form.groupID is not "" and Form.groupID is not 0 and Not ListFind(ValueList(qry_selectGroupList.groupID), Form.groupID)>
	<cfset errorMessage_fields.groupID = Variables.lang_listCompanies.groupID>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0 and Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
	<cfset errorMessage_fields.affiliateID = Variables.lang_listCompanies.affiliateID>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0 and Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
	<cfset errorMessage_fields.cobrandID = Variables.lang_listCompanies.cobrandID>
</cfif>

<!--- if cobrand or affiliate partner, ensure they selected at least one cobrand or affiliate --->
<cfif Session.companyID is not Session.companyID_author and Not Application.fn_IsIntegerPositive(Form.cobrandID) and Not Application.fn_IsIntegerPositive(Form.affiliateID)>
	<cfif Session.cobrandID_list is not 0>
		<cfset Form.cobrandID = Session.cobrandID_list>
	<cfelse>
		<cfset Form.affiliateID = Session.affiliateID_list>
	</cfif>
</cfif>

<cfif Form.statusID is not "" and Form.statusID is not 0 and Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
	<cfset errorMessage_fields.statusID = Variables.lang_listCompanies.statusID>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listCompanies.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listCompanies.queryPage>
</cfif>

<cfif IsDefined("Form.queryFirstLetter") and Form.queryFirstLetter is not "">
	<cfif Len(Form.queryFirstLetter) gt 1 and Form.queryFirstLetter is not "0-9">
		<cfset errorMessage_fields.queryFirstLetter = Variables.lang_listCompanies.queryFirstLetter>
	<cfelseif Not REFindNoCase("[A-Za-z]", Form.queryFirstLetter)>
		<cfset errorMessage_fields.queryFirstLetter = Variables.lang_listCompanies.queryFirstLetter>
	</cfif>
</cfif>

<cfif Form.companyIsExported is not "" and Not ListFind("-1,0,1", Form.companyIsExported)>
	<cfset errorMessage_fields.companyIsExported = Variables.lang_listCompanies.companyIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listCompanies.errorTitle>
	<cfset errorMessage_header = Variables.lang_listCompanies.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listCompanies.errorFooter>
</cfif>

