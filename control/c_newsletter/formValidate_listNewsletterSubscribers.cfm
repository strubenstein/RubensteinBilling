<cfset errorMessage_fields = StructNew()>

<cfif IsDefined("Form.affiliateID") and Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
		<cfset errorMessage_fields.affiliateID = Variables.lang_listNewsletterSubscribers.affiliateID>
	</cfif>
</cfif>

<cfif IsDefined("Form.cobrandID") and Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
		<cfset errorMessage_fields.cobrandID = Variables.lang_listNewsletterSubscribers.cobrandID>
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

<cfif IsDefined("Form.groupID") and Form.groupID is not "" and Form.groupID is not 0>
	<cfif Not ListFind(ValueList(qry_selectGroupList.groupID), Form.groupID)>
		<cfset errorMessage_fields.groupID = Variables.lang_listNewsletterSubscribers.groupID>
	</cfif>
</cfif>

<cfset Form.newsletterSubscriberDateFrom = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "newsletterSubscriberDateFrom_date", Form.newsletterSubscriberDateFrom_date, "newsletterSubscriberDateFrom_hh", Form.newsletterSubscriberDateFrom_hh, "newsletterSubscriberDateFrom_mm", Form.newsletterSubscriberDateFrom_mm, "newsletterSubscriberDateFrom_tt", Form.newsletterSubscriberDateFrom_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.newsletterSubscriberDateFrom = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.newsletterSubscriberDateTo = "">
<cfset dateEndResponse = fn_FormValidateDateTime("end", "newsletterSubscriberDateTo_date", Form.newsletterSubscriberDateTo_date, "newsletterSubscriberDateTo_hh", Form.newsletterSubscriberDateTo_hh, "newsletterSubscriberDateTo_mm", Form.newsletterSubscriberDateTo_mm, "newsletterSubscriberDateTo_tt", Form.newsletterSubscriberDateTo_tt)>
<cfif IsDate(dateEndResponse)>
	<cfset Form.newsletterSubscriberDateTo = dateEndResponse>
<cfelseif IsStruct(dateEndResponse)>
	<cfloop Collection="#dateEndResponse#" Item="field">
		<cfset errorMessage_fields["#field#"] = StructFind(dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.newsletterSubscriberDateFrom) and IsDate(Form.newsletterSubscriberDateTo)
		and DateCompare(Form.newsletterSubscriberDateFrom, Form.newsletterSubscriberDateTo) is not -1>
	<cfset errorMessage_fields.newsletterSubscriberDateTo = Variables.lang_listNewsletterSubscribers.newsletterSubscriberDateTo>
</cfif>

<cfif REFindNoCase("[^A-Za-z0-9._@-]", Form.newsletterSubscriberEmail)>
	<cfset errorMessage_fields.newsletterSubscriberEmail = Variables.lang_listNewsletterSubscribers.newsletterSubscriberEmail>
</cfif>

<cfloop Index="field" List="subscriberIsUser,companyIsCustomer,companyIsCobrand,companyIsVendor,companyIsTaxExempt,companyIsAffiliate,newsletterSubscriberHtml,newsletterSubscriberStatus,newsletterSubscriberRegistered,companyHasCustomPricing,companyHasMultipleUsers,userIsSalesperson,userIsInMyCompany,companyHasCustomID,userHasCustomID">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listNewsletterSubscribers[field]>
	</cfif>
</cfloop>

<cfif IsDefined("Form.newsletterSubscriberDateType") and Trim(Form.newsletterSubscriberDateType) is not "">
	<cfif (ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed") and ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed_first"))
			or (ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed") and ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed_last"))
			or (ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed_first") and ListFind(Form.newsletterSubscriberDateType, "invoiceDateClosed_last"))>
		<cfset errorMessage_fields.newsletterSubscriberDateType = Variables.lang_listNewsletterSubscribers.newsletterSubscriberDateType_invoice>
	</cfif>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage) and Variables.doAction is "listNewsletterSubscribers">
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listNewsletterSubscribers.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage) and Variables.doAction is "listNewsletterSubscribers">
	<cfset errorMessage_fields.queryPage = Variables.lang_listNewsletterSubscribers.queryPage>
</cfif>

<cfif Form.newsletterSubscriberIsExported is not "" and Not ListFind("-1,0,1", Form.newsletterSubscriberIsExported)>
	<cfset errorMessage_fields.newsletterSubscriberIsExported = Variables.lang_listNewsletterSubscribers.newsletterSubscriberIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listNewsletterSubscribers.errorTitle>
	<cfset errorMessage_header = Variables.lang_listNewsletterSubscribers.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listNewsletterSubscribers.errorFooter>
</cfif>

