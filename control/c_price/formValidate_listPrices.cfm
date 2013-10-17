<cfset errorMessage_fields = StructNew()>

<cfloop Index="field" List="#Variables.fields_boolean#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not ListFind("0,1", Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPrices[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_integer#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not Application.fn_IsInteger(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPrices[field]>
	</cfif>
</cfloop>

<cfloop Index="field" List="#Variables.fields_date#">
	<cfif IsDefined("Form.#field#") and Form[field] is not "" and Not IsDate(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPrices[field]>
	</cfif>
</cfloop>

<cfif IsDefined("Form.priceStageIntervalType") and Form.priceStageIntervalType is not "">
	<cfloop Index="thisIntervalType" List="#Form.priceStageIntervalType#">
		<cfif Not ListFind(Variables.priceStageIntervalTypeList_value, thisIntervalType)>
			<cfset errorMessage_fields.priceStageIntervalType = Variables.lang_listPrices.priceStageIntervalType>
		</cfif>
	</cfloop>
</cfif>

<cfif IsDefined("Form.priceStageInterval_min") and Form.priceStageInterval_min is not "" and Not Application.fn_IsIntegerPositive(Form.priceStageInterval_min)>
	<cfset errorMessage_fields.priceStageInterval_min = Variables.lang_listPrices.priceStageInterval_min>
</cfif>

<cfif IsDefined("Form.priceStageInterval_max") and Form.priceStageInterval_min is not "">
	<cfif Not Application.fn_IsIntegerPositive(Form.priceStageInterval_max)>
		<cfset errorMessage_fields.priceStageInterval_max = Variables.lang_listPrices.priceStageInterval_max>
	<cfelseif IsDefined("Form.priceStageInterval_min") and Form.priceStageInterval_min is not "" and Application.fn_IsIntegerPositive(Form.priceStageInterval_min)
			and Form.priceStageInterval_max lt Form.priceStageInterval_min>
		<cfset errorMessage_fields.priceStageInterval_max = Variables.lang_listPrices.priceStageInterval_minMax>
	</cfif>
</cfif>

<cfif IsDefined("Form.priceStageDollarOrPercent_priceStageNewOrDeduction") and Form.priceStageDollarOrPercent_priceStageNewOrDeduction is not "">
	<cfloop Index="thisPriceStatedAs" List="#Form.priceStageDollarOrPercent_priceStageNewOrDeduction#">
		<cfif Not ListFind("0_0,1_1,0_1,1_0", Form.priceStageDollarOrPercent_priceStageNewOrDeduction)>
			<cfset errorMessage_fields.priceStageDollarOrPercent_priceStageNewOrDeduction = Variables.lang_listPrices.priceStageDollarOrPercent_priceStageNewOrDeduction>
		</cfif>
	</cfloop>
</cfif>

<cfset Form.priceDateFrom = "">
<cfset Variables.dateBeginResponse = fn_FormValidateDateTime("begin", "priceDateFrom_date", Form.priceDateFrom_date, "priceDateFrom_hh", Form.priceDateFrom_hh, "priceDateFrom_mm", Form.priceDateFrom_mm, "priceDateFrom_tt", Form.priceDateFrom_tt)>
<cfif IsDate(Variables.dateBeginResponse)>
	<cfset Form.priceDateFrom = Variables.dateBeginResponse>
<cfelseif IsStruct(Variables.dateBeginResponse)>
	<cfloop Collection="#Variables.dateBeginResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(Variables.dateBeginResponse, field)>
	</cfloop>
</cfif>

<cfset Form.priceDateTo = "">
<cfset Variables.dateEndResponse = fn_FormValidateDateTime("end", "priceDateTo_date", Form.priceDateTo_date, "priceDateTo_hh", Form.priceDateTo_hh, "priceDateTo_mm", Form.priceDateTo_mm, "priceDateTo_tt", Form.priceDateTo_tt)>
<cfif IsDate(Variables.dateEndResponse)>
	<cfset Form.priceDateTo = Variables.dateEndResponse>
<cfelseif IsStruct(Variables.dateEndResponse)>
	<cfloop Collection="#Variables.dateEndResponse#" Item="field">
		<cfset errorMessage_fields[field] = StructFind(Variables.dateEndResponse, field)>
	</cfloop>
</cfif>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.priceDateFrom) and IsDate(Form.priceDateTo)
		and DateCompare(Form.priceDateFrom, Form.priceDateTo) is not -1>
	<cfset errorMessage_fields.priceDateToFrom = Variables.lang_listPrices.priceDateToFrom>
</cfif>

<cfif Form.categoryID is not "" and Form.categoryID is not 0>
	<cfloop Index="thisCategoryID" List="#Form.categoryID#">
		<cfif Not ListFind(ValueList(qry_selectCategoryList.categoryID), thisCategoryID)>
			<cfset errorMessage_fields.categoryID = Variables.lang_listPrices.categoryID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.vendorID is not "" and Form.vendorID is not 0>
	<cfloop Index="thisVendorID" List="#Form.vendorID#">
		<cfif thisVendorID is not 0 and Not ListFind(ValueList(qry_selectVendorList.vendorID), thisVendorID)>
			<cfset errorMessage_fields.vendorID = Variables.lang_listPrices.vendorID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.groupID is not "" and Form.groupID is not 0>
	<cfloop Index="thisGroupID" List="#Form.groupID#">
		<cfif Not ListFind(ValueList(qry_selectGroupList.groupID), thisGroupID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listPrices.groupID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.regionID is not "" and Form.regionID is not 0>
	<cfloop Index="thisRegionID" List="#Form.regionID#">
		<cfif Not ListFind(ValueList(qry_selectRegionList.regionID), thisRegionID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listPrices.regionID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.affiliateID is not "" and Form.affiliateID is not 0>
	<cfloop Index="thisAffiliateID" List="#Form.affiliateID#">
		<cfif Not ListFind(ValueList(qry_selectAffiliateList.affiliateID), thisAffiliateID)>
			<cfset errorMessage_fields.affiliateID = Variables.lang_listPrices.affiliateID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.cobrandID is not "" and Form.cobrandID is not 0>
	<cfloop Index="thisCobrandID" List="#Form.cobrandID#">
		<cfif Not ListFind(ValueList(qry_selectCobrandList.cobrandID), thisCobrandID)>
			<cfset errorMessage_fields.cobrandID = Variables.lang_listPrices.cobrandID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfloop Index="field" List="priceID,priceID_parent,priceID_trend">
	<cfif IsDefined("Form.#field#") and Not Application.fn_IsIntegerList(Form[field])>
		<cfset errorMessage_fields[field] = Variables.lang_listPrices[field]>
		<cfbreak>
	</cfif>
</cfloop>

<cfif Not Application.fn_IsIntegerPositive(Form.queryDisplayPerPage)>
	<cfset errorMessage_fields.queryDisplayPerPage = Variables.lang_listPrices.queryDisplayPerPage>
</cfif>

<cfif Not Application.fn_IsIntegerPositive(Form.queryPage)>
	<cfset errorMessage_fields.queryPage = Variables.lang_listPrices.queryPage>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_listPrices.errorTitle>
	<cfset errorMessage_header = Variables.lang_listPrices.errorHeader>
	<cfset errorMessage_footer = Variables.lang_listPrices.errorFooter>
</cfif>

