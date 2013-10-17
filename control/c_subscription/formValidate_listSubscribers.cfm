<cfset errorMessage_fields = StructNew()>

<cfif IsDefined("Form.subscriptionIntervalType") and Form.subscriptionIntervalType is not "" and Not ListFind(Variables.subscriptionIntervalTypeList_value, Form.subscriptionIntervalType)>
	<cfset errorMessage_fields.subscriptionIntervalType = Variables.lang_listSubscribers.subscriptionIntervalType>
</cfif>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listSubscribers[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_integer#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsInteger(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listSubscribers[field]>
	</cfif>
</cfloop>

<cfif IsDefined("Form.subscriberID") and Form.subscriberID is not "" and Not Application.fn_IsIntegerList(Form.subscriberID)>
	<cfset errorMessage_fields.subscriberID = Variables.lang_listSubscribers.subscriberID>
</cfif>

<cfloop Index="field" List="#Variables.fields_integerList#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsIntegerList(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listSubscribers[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_date#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listSubscribers[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_numeric#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsNumeric(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listSubscribers[field]>
	</cfif>
</cfloop>

<cfset Form.subscriberDateFrom = "">
<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "subscriberDateFrom_date", Form.subscriberDateFrom_date, "subscriberDateFrom_hh", Form.subscriberDateFrom_hh, "subscriberDateFrom_mm", Form.subscriberDateFrom_mm, "subscriberDateFrom_tt", Form.subscriberDateFrom_tt)>
<cfif IsDate(dateBeginResponse)>
	<cfset Form.subscriberDateFrom = dateBeginResponse>
<cfelseif IsStruct(dateBeginResponse)>
	<cfloop Collection="#dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.subscriberDateTo = "">
<cfset dateEndResponse = fn_FormValidateDateTime("end", "subscriberDateTo_date", Form.subscriberDateTo_date, "subscriberDateTo_hh", Form.subscriberDateTo_hh, "subscriberDateTo_mm", Form.subscriberDateTo_mm, "subscriberDateTo_tt", Form.subscriberDateTo_tt)>
<cfif IsDate(dateEndResponse)>
	<cfset Form.subscriberDateTo = dateEndResponse>
<cfelseif IsStruct(dateEndResponse)>
	<cfloop Collection="#dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.subscriberDateFrom) and IsDate(Form.subscriberDateTo)
		and DateCompare(Form.subscriberDateFrom, Form.subscriberDateTo) is not -1>
	<cfset errorMessage_fields.subscriberDateTo = Variables.lang_listSubscribers.subscriberDateTo>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0 and Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), Form.affiliateID)>
	<cfset errorMessage_fields.affiliateID = Variables.lang_listSubscribers.affiliateID>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0 and Not ListFind(ValueList(qry_selectCobrandList.cobrandID), Form.cobrandID)>
	<cfset errorMessage_fields.cobrandID = Variables.lang_listSubscribers.cobrandID>
</cfif>

<cfif Form.statusID_subscriber is not "" and Form.statusID_subscriber is not 0 and Not ListFind(ValueList(qry_selectStatusList_subscriber.statusID), Form.statusID_subscriber)>
	<cfset errorMessage_fields.statusID_subscriber = Variables.lang_listSubscribers.statusID_subscriber>
</cfif>

<cfif Form.statusID_subscription is not "" and Form.statusID_subscription is not 0 and Not ListFind(ValueList(qry_selectStatusList_subscription.statusID), Form.statusID_subscription)>
	<cfset errorMessage_fields.statusID_subscription = Variables.lang_listSubscribers.statusID_subscription>
</cfif>

<!--- if cobrand or affiliate partner, ensure they selected at least one cobrand or affiliate --->
<cfif Session.companyID is not Session.companyID_author and Not Application.fn_IsIntegerPositive(Form.cobrandID) and Not Application.fn_IsIntegerPositive(Form.affiliateID)>
	<cfif Session.cobrandID_list is not 0>
		<cfset Form.cobrandID = Session.cobrandID_list>
	<cfelse>
		<cfset Form.affiliateID = Session.affiliateID_list>
	</cfif>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listSubscribers.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listSubscribers.queryPage>
</cfif>

<cfif Form.subscriberIsExported is not "" and Not ListFind("-1,0,1", Form.subscriberIsExported)>
	<cfset errorMessage_fields.subscriberIsExported = Variables.lang_listSubscribers.subscriberIsExported>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listSubscribers.errorTitle>
	<cfset errorMessage_header = Variables.lang_listSubscribers.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listSubscribers.errorFooter>
</cfif>

