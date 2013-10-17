<cfset errorMessage_fields = StructNew()>

<cfif Trim(Form.searchText) is not "" and Trim(Form.searchField) is "">
	<cfset errorMessage_fields.searchField = Variables.lang_listUsers.searchField>
</cfif>

<cfif Form.statusID is not "" and Form.statusID is not 0>
	<cfif Not ListFind(ValueList(qry_selectStatusList.statusID), Form.statusID)>
		<cfset errorMessage_fields.statusID = Variables.lang_listUsers.statusID>
	</cfif>
</cfif>

<cfif Form.groupID is not "" and Form.groupID is not 0>
	<cfif Not ListFind(ValueList(qry_selectGroupList.groupID), Form.groupID)>
		<cfset errorMessage_fields.groupID = Variables.lang_listUsers.groupID>
	</cfif>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
		<cfset errorMessage_fields.affiliateID = Variables.lang_listUsers.affiliateID>
	</cfif>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
		<cfset errorMessage_fields.cobrandID = Variables.lang_listUsers.cobrandID>
	</cfif>
</cfif>

<!--- if cobrand or affiliate partner, ensure they selected at least one cobrand or affiliate --->
<cfif Session.companyID is not Session.companyID_author and Not Application.fn_IsIntegerPositive(Form.cobrandID) and Not Application.fn_IsIntegerPositive(Form.affiliateID)>
	<cfif Session.cobrandID_list is not 0>
		<cfset Form.cobrandID = Session.cobrandID_list>
	<cfelse>
		<cfset Form.affiliateID = Session.affiliateID_list>
	</cfif>
</cfif>

<cfloop Index="field" List="userStatus,companyIsCustomer,userHasCustomPricing,companyIsAffiliate,companyIsCobrand,userIsPrimaryContact,userHasCustomID,companyIsVendor,companyIsTaxExempt,userNewsletterStatus,userNewsletterHtml,userIsActiveSubscriber">
	<cfif Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listUsers[field]>
	</cfif>
</cfloop>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listUsers.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listUsers.queryPage>
</cfif>

<cfif Form.userIsExported is not "" and Not ListFind("-1,0,1", Form.userIsExported)>
	<cfset errorMessage_fields.userIsExported = Variables.lang_listUsers.userIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listUsers.errorTitle>
	<cfset errorMessage_header = Variables.lang_listUsers.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listUsers.errorFooter>
</cfif>

