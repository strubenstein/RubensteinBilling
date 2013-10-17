<cfset errorMessage_fields = StructNew()>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listCommissions[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_integer#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsInteger(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listCommissions[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_date#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listCommissions[field]>
	</cfif>
</cfloop>

<cfif IsDefined("Form.commissionStageIntervalType") and Form.commissionStageIntervalType is not "">
	<cfloop Index="thisIntervalType" List="#Form.commissionStageIntervalType#">
		<cfif Not ListFind(Variables.commissionStageIntervalType_value, thisIntervalType)>
			<cfset errorMessage_fields.commissionStageIntervalType = Variables.lang_listCommissions.commissionStageIntervalType>
		</cfif>
	</cfloop>
</cfif>

<cfif IsDefined("Form.commissionStageInterval_min") and Form.commissionStageInterval_min is not "" and Application.fn_IsIntegerPositive(Form.commissionStageInterval_min)>
	<cfset errorMessage_fields.commissionStageInterval_min = Variables.lang_listCommissions.commissionStageInterval_min>
</cfif>

<cfif IsDefined("Form.commissionStageInterval_max") and Form.commissionStageInterval_min is not "">
	<cfif Application.fn_IsIntegerPositive(Form.commissionStageInterval_max)>
		<cfset errorMessage_fields.commissionStageInterval_max = Variables.lang_listCommissions.commissionStageInterval_max>
	<cfelseif IsDefined("Form.commissionStageInterval_min") and Form.commissionStageInterval_min is not "" and Application.fn_IsIntegerPositive(Form.commissionStageInterval_min)
			and Form.commissionStageInterval_max lt Form.commissionStageInterval_min>
		<cfset errorMessage_fields.commissionStageInterval_max = Variables.lang_listCommissions.commissionStageInterval_minMax>
	</cfif>
</cfif>

<cfset Form.commissionDateFrom = "">
<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "commissionDateFrom_date", Form.commissionDateFrom_date, "commissionDateFrom_hh", Form.commissionDateFrom_hh, "commissionDateFrom_mm", Form.commissionDateFrom_mm, "commissionDateFrom_tt", Form.commissionDateFrom_tt)>
<cfif IsDate(Variables.dateBeginResponse)>
	<cfset Form.commissionDateFrom = Variables.dateBeginResponse>
<cfelseif IsStruct(Variables.dateBeginResponse)>
	<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(Variables.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.commissionDateTo = "">
<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "commissionDateTo_date", Form.commissionDateTo_date, "commissionDateTo_hh", Form.commissionDateTo_hh, "commissionDateTo_mm", Form.commissionDateTo_mm, "commissionDateTo_tt", Form.commissionDateTo_tt)>
<cfif IsDate(Variables.dateEndResponse)>
	<cfset Form.commissionDateTo = Variables.dateEndResponse>
<cfelseif IsStruct(Variables.dateEndResponse)>
	<cfloop Collection="#Variables.dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(Variables.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.commissionDateFrom) and IsDate(Form.commissionDateTo)
		and DateCompare(Form.commissionDateFrom, Form.commissionDateTo) is not -1>
	<cfset errorMessage_fields.commissionDateToFrom = Variables.lang_listCommissions.commissionDateToFrom>
</cfif>

<cfif Form.categoryID is not "" and Form.categoryID is not 0>
	<cfloop Index="thisCategoryID" List="#Form.categoryID#">
		<cfif Not ListFind(ValueList(qry_selectCategoryList.categoryID), thisCategoryID)>
			<cfset errorMessage_fields.categoryID = Variables.lang_listCommissions.categoryID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.vendorID is not "" and Form.vendorID is not 0>
	<cfloop Index="thisVendorID" List="#Form.vendorID#">
		<cfif thisVendorID is not 0 and Not ListFind(ValueList(qry_selectVendorList.vendorID), thisVendorID)>
			<cfset errorMessage_fields.vendorID = Variables.lang_listCommissions.vendorID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.groupID is not "" and Form.groupID is not 0>
	<cfloop Index="thisGroupID" List="#Form.groupID#">
		<cfif Not ListFind(ValueList(qry_selectGroupList.groupID), thisGroupID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listCommissions.groupID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.regionID is not "" and Form.regionID is not 0>
	<cfloop Index="thisRegionID" List="#Form.regionID#">
		<cfif Not ListFind(ValueList(qry_selectRegionList.regionID), thisRegionID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listCommissions.regionID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfloop Index="thisAffiliateID" List="#Form.affiliateID#">
		<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), thisAffiliateID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listCommissions.affiliateID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfloop Index="thisCobrandID" List="#Form.cobrandID#">
		<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), thisCobrandID)>
			<cfset errorMessage_fields.cobrandID = Variables.lang_listCommissions.cobrandID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfloop Index="field" List="commissionID,commissionID_parent,commissionID_trend">
	<cfif IsDefined("Form.#field#") and Not Application.fn_IsIntegerList(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listCommissions[field]>
		<cfbreak>
	</cfif>
</cfloop>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listCommissions.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listCommissions.queryPage>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listCommissions.errorTitle>
	<cfset errorMessage_header = Variables.lang_listCommissions.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listCommissions.errorFooter>
</cfif>

