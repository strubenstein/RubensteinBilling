<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.subscriptionStatus)>
	<cfset errorMessage_fields.subscriptionStatus = Variables.lang_insertSubscription.subscriptionStatus>
</cfif>

<cfif Variables.doAction is "insertSubscription" and Form.subscriptionOrder is not 0
		and (Not Application.fn_IsIntegerPositive(Form.subscriptionOrder) or Form.subscriptionOrder gt qry_selectSubscriptionList.RecordCount)>
	<cfset errorMessage_fields.subscriptionOrder = Variables.lang_insertSubscription.subscriptionOrder>
</cfif>

<cfif Not IsNumeric(Form.subscriptionQuantity)>
	<cfset errorMessage_fields.subscriptionQuantity = Variables.lang_insertSubscription.subscriptionQuantity_numeric>
<cfelseif Form.subscriptionQuantity lt 0>
	<cfset errorMessage_fields.subscriptionQuantity = Variables.lang_insertSubscription.subscriptionQuantity_negative>
<cfelseif Find(".", Form.subscriptionQuantity) and Len(ListLast(Form.subscriptionQuantity, ".")) gt maxlength_Subscription.subscriptionQuantity>
	<cfset errorMessage_fields.subscriptionQuantity = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionQuantity_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionQuantity, "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.subscriptionQuantityVaries)>
	<cfset errorMessage_fields.subscriptionQuantityVaries = Variables.lang_insertSubscription.subscriptionQuantityVaries>
</cfif>

<cfif Trim(Form.subscriptionName) is "">
	<cfset errorMessage_fields.subscriptionName = Variables.lang_insertSubscription.subscriptionName_blank>
<cfelseif Len(Form.subscriptionName) gt maxlength_Subscription.subscriptionName>
	<cfset errorMessage_fields.subscriptionName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertSubscription.subscriptionName_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionName, "ALL"), "<<LEN>>", Len(Form.subscriptionName), "ALL")>
</cfif>

<cfif Len(Form.subscriptionID_custom) gt maxlength_Subscription.subscriptionID_custom>
	<cfset errorMessage_fields.subscriptionID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertSubscription.subscriptionID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionID_custom, "ALL"), "<<LEN>>", Len(Form.subscriptionID_custom), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.subscriptionDescriptionHtml)>
	<cfset errorMessage_fields.subscriptionDescriptionHtml = Variables.lang_insertSubscription.subscriptionDescriptionHtml>
</cfif>

<cfif Len(Form.subscriptionDescription) gt maxlength_Subscription.subscriptionDescription>
	<cfset errorMessage_fields.subscriptionDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertSubscription.subscriptionDescription_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionDescription, "ALL"), "<<LEN>>", Len(Form.subscriptionDescription), "ALL")>
</cfif>

<cfif Len(Form.subscriptionProductID_custom) gt maxlength_Subscription.subscriptionProductID_custom>
	<cfset errorMessage_fields.subscriptionProductID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertSubscription.subscriptionProductID_custom_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionProductID_custom, "ALL"), "<<LEN>>", Len(Form.subscriptionProductID_custom), "ALL")>
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(Form.regionID)>
	<cfset errorMessage_fields.regionID = Variables.lang_insertSubscription.regionID>
</cfif>

<cfif Form.subscriptionPriceNormal is "">
	<cfset Form.subscriptionPriceNormal = 0>
<cfelseif Not IsNumeric(Form.subscriptionPriceNormal) or Form.subscriptionPriceNormal lt 0>
	<cfset errorMessage_fields.subscriptionPriceNormal = Variables.lang_insertSubscription.subscriptionPriceNormal_numeric>
<cfelseif Find(".", Form.subscriptionPriceNormal) and Len(ListLast(Form.subscriptionPriceNormal, ".")) gt maxlength_Subscription.subscriptionPriceNormal>
	<cfset errorMessage_fields.subscriptionPriceNormal = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionPriceNormal_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionPriceNormal, "ALL")>
</cfif>

<cfif Form.subscriptionDiscount is "">
	<cfset Form.subscriptionDiscount = 0>
<cfelseif Not IsNumeric(Form.subscriptionDiscount) or Form.subscriptionDiscount lt 0>
	<cfset errorMessage_fields.subscriptionDiscount = Variables.lang_insertSubscription.subscriptionDiscount_numeric>
<cfelseif Find(".", Form.subscriptionDiscount) and Len(ListLast(Form.subscriptionDiscount, ".")) gt maxlength_Subscription.subscriptionDiscount>
	<cfset errorMessage_fields.subscriptionDiscount = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionDiscount_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionDiscount, "ALL")>
</cfif>

<!--- 
<cfif Form.subscriptionTotalTax is "">
	<cfset Form.subscriptionTotalTax = 0>
<cfelseif Not IsNumeric(Form.subscriptionTotalTax) or Form.subscriptionTotalTax lt 0>
	<cfset errorMessage_fields.subscriptionTotalTax = Variables.lang_insertSubscription.subscriptionTotalTax_numeric>
<cfelseif Find(".", Form.subscriptionTotalTax) and Len(ListLast(Form.subscriptionTotalTax, ".")) gt maxlength_Subscription.subscriptionTotalTax>
	<cfset errorMessage_fields.subscriptionTotalTax = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionTotalTax_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionTotalTax, "ALL")>
</cfif>
--->

<cfif URL.productID is 0><!--- custom product --->
	<cfset Form.categoryID = 0>
	<cfset Form.priceID = 0>
	<cfset Form.productParameterExceptionID = 0>
<cfelse><!--- real product --->
	<cfif Form.categoryID is not 0 and Not ListFind(ValueList(qry_selectProductCategory.categoryID), Form.categoryID)>
		<cfset errorMessage_fields.categoryID = Variables.lang_insertSubscription.categoryID>
	</cfif>

	<!--- validate price --->
	<cfif Form.priceID is not 0>
		<cfset priceRow = ListFind(ValueList(qry_selectPriceListForTarget.priceID), Form.priceID)>
		<cfif priceRow is 0>
			<cfset errorMessage_fields.priceID = Variables.lang_insertSubscription.priceID_valid>
		<!--- ??? --->
		<cfelseif qry_selectPriceListForTarget.priceQuantityMinimumPerOrder is not 0 and qry_selectPriceListForTarget.priceQuantityMinimumPerOrder lt Form.subscriptionQuantity>
			<cfset errorMessage_fields.priceID = Replace(Variables.lang_insertSubscription.priceID_minQuantityPerOrder, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMinimumPerOrder), "ALL")>
		<cfelse>
			<!--- validate quantity is not greater than maximum quantity per customer --->
			<cfif qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer is not 0
					and displayPriceQuantityMaximumPerCustomer is True
					and StructKeyExists(quantityMaximumPerCustomer, "price#Form.priceID#")>
				<cfset sumQuantity = quantityMaximumPerCustomer["price#Form.priceID#"]>
				<cfif sumQuantity gte qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(Variables.lang_insertSubscription.priceID_maxQuantityPerCustomerReached, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer), "ALL")>
				<cfelseif (Form.subscriptionQuantity + sumQuantity) gte qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer>
					<cfset remainderPerCustomer = Abs(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer - sumQuantity - Form.subscriptionQuantity)>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertSubscription.priceID_maxQuantityPerCustomerSplit, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer), "ALL"), "<<REMAINING>>", sumQuantity, "ALL"), "<<REMAINDER>>", remainderPerCustomer, "ALL")>
					<cfset multipleLineItem_priceQuantityMaxPerCustomer = True>
				</cfif>
			</cfif>

			<!--- validate quantity is not greater than maximum quantity for all customers --->
			<cfif qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers is not 0
					and displayPriceQuantityMaximumAllCustomers is True
					and StructKeyExists(quantityMaximumAllCustomers, "price#Form.priceID#")>
				<cfset sumQuantity = quantityMaximumAllCustomers["price#Form.priceID#"]>
				<cfif sumQuantity gte qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(Variables.lang_insertSubscription.priceID_maxQuantityAllCustomersReached, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers), "ALL")>
				<cfelseif (Form.subscriptionQuantity + sumQuantity) gte qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers>
					<cfset remainderAllCustomers = Abs(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers - sumQuantity - Form.subscriptionQuantity)>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertSubscription.priceID_maxQuantityAllCustomersSplit, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers), "ALL"), "<<REMAINING>>", sumQuantity, "ALL"), "<<REMAINDER>>", remainderAllCustomers, "ALL")>
					<cfset multipleLineItem_priceQuantityMaxAllCustomers = False>
				</cfif>
			</cfif>
		</cfif>
	</cfif>

	<cfif displayProductParameter is True>
		<cfset invoiceLineItemProductID_customArray = ArrayNew(1)>
		<cfloop Query="qry_selectProductParameterList">
			<cfset isParameterOption = False>
			<cfif qry_selectProductParameterList.productParameterRequired is 1 and Not IsDefined("Form.parameter#qry_selectProductParameterList.productParameterID#")>
				<cfset errorMessage_fields.productParameterID = Variables.lang_insertSubscription.productParameterID_required>
			<cfelseif qry_selectProductParameterList.productParameterRequired is 1 and Trim(Form["parameter#qry_selectProductParameterList.productParameterID#"]) is "">
				<cfset errorMessage_fields.productParameterID = Variables.lang_insertSubscription.productParameterID_blank>
			<cfelse>
				<cfset thisParameterID = qry_selectProductParameterList.productParameterID>
				<cfset parameterRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterID), thisParameterID)>
				<cfif parameterRow is not 0>
					<cfset thisCodeStatus = qry_selectProductParameterList.productParameterCodeStatus>
					<cfset thisCodeOrder = qry_selectProductParameterList.productParameterCodeOrder>
		
					<cfloop Query="qry_selectProductParameterOptionList" StartRow="#parameterRow#">
						<cfif qry_selectProductParameterOptionList.productParameterID is not thisParameterID>
							<cfbreak>
						<cfelseif Form["parameter#qry_selectProductParameterOptionList.productParameterID#"] is qry_selectProductParameterOptionList.productParameterOptionID>
							<cfset isParameterOption = True>
							<cfset productParameterOptionID_list = ListAppend(productParameterOptionID_list, qry_selectProductParameterOptionList.productParameterOptionID)>
							<!--- generate custom ID --->
							<cfif thisCodeStatus is 1>
								<cfset invoiceLineItemProductID_customArray[thisCodeOrder] = qry_selectProductParameterOptionList.productParameterOptionCode>
							</cfif>
							<cfbreak>
						</cfif>
					</cfloop>

					<cfif isParameterOption is False>
						<cfset errorMessage_fields.productParameterID = Variables.lang_insertSubscription.productParameterID_valid>
					<cfelseif Not ArrayIsEmpty(invoiceLineItemProductID_customArray)>
						<cfloop Index="count" From="1" To="#ArrayLen(invoiceLineItemProductID_customArray)#">
							<cfset Form.subscriptionProductID_custom = Form.subscriptionProductID_custom & invoiceLineItemProductID_customArray[count]>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>

		<!--- if exception: check that combination of parameters is permitted and for price exception --->
		<cfif StructIsEmpty(errorMessage_fields) and displayProductParameterException is True>
			<cfloop Query="qry_selectProductParameterExceptionList">
				<cfif (qry_selectProductParameterExceptionList.productParameterExceptionExcluded is 1 or qry_selectProductParameterExceptionList.productParameterExceptionPricePremium is not 0)
						and ListFind(productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID1)
						and (qry_selectProductParameterExceptionList.productParameterOptionID2 is 0 or ListFind(productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID2))
						and (qry_selectProductParameterExceptionList.productParameterOptionID3 is 0 or ListFind(productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID3))
						and (qry_selectProductParameterExceptionList.productParameterOptionID4 is 0 or ListFind(productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID4))>
					<cfif qry_selectProductParameterExceptionList.productParameterExceptionExcluded is 1>
						<cfset errorMessage_fields.productParameterID = Variables.lang_insertSubscription.productParameterID_excluded>
					<cfelse>
						<cfset productParameterExceptionID = qry_selectProductParameterExceptionList.productParameterExceptionID>
						<cfset productParameterExceptionPricePremium = qry_selectProductParameterExceptionList.productParameterExceptionPricePremium>
					</cfif>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>

<cfif Form.priceID is not 0 and Form.subscriptionPriceUnit is "">
	<cfset Form.subscriptionPriceUnit = 0>
<cfelseif Not IsNumeric(Form.subscriptionPriceUnit) or Form.subscriptionPriceUnit lt 0>
	<cfset errorMessage_fields.subscriptionPriceUnit = Variables.lang_insertSubscription.subscriptionPriceUnit_numeric>
<cfelseif Find(".", Form.subscriptionPriceUnit) and Len(ListLast(Form.subscriptionPriceUnit, ".")) gt maxlength_Subscription.subscriptionPriceUnit>
	<cfset errorMessage_fields.subscriptionPriceUnit = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionPriceUnit_maxlength, "<<MAXLENGTH>>", maxlength_Subscription.subscriptionPriceUnit, "ALL")>
</cfif>

<cfif Form.subscriptionAppliedMaximum is "" or Form.subscriptionAppliedMaximum is 0>
	<cfset Form.subscriptionAppliedMaximum = 0>
<cfelseif Not Application.fn_IsIntegerPositive(Form.subscriptionAppliedMaximum)>
	<cfset errorMessage_fields.subscriptionAppliedMaximum = Variables.lang_insertSubscription.subscriptionAppliedMaximum>
</cfif>

<cfif Not ListFind("0,1", Form.subscriptionProRate)>
	<cfset errorMessage_fields.subscriptionProRate = Variables.lang_insertSubscription.subscriptionProRate>
</cfif>

<cfif Not ListFind(Variables.subscriptionIntervalTypeList_value, Form.subscriptionIntervalType)>
	<cfset errorMessage_fields.subscriptionIntervalType = Variables.lang_insertSubscription.subscriptionIntervalType>
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(Form.subscriptionInterval)>
	<cfset errorMessage_fields.subscriptionInterval = Variables.lang_insertSubscription.subscriptionInterval>
</cfif>

<cfset Variables.subscriptionDateFieldList = "subscriptionDateBegin,subscriptionDateEnd,subscriptionDateProcessNext">
<cfloop Index="dateField" List="#Variables.subscriptionDateFieldList#">
	<cfset Form[dateField] = "">
	<cfif Form["#dateField#_date"] is not "">
		<cfif dateField is "subscriptionDateEnd">
			<cfset dateBeginOrEnd = "end">
		<cfelse>
			<cfset dateBeginOrEnd = "begin">
		</cfif>

		<cfset dateResponse = fn_FormValidateDateTime(dateBeginOrEnd, "#dateField#_date", Form["#dateField#_date"], "#dateField#_hh", Form["#dateField#_hh"], "#dateField#_mm", Form["#dateField#_mm"], "#dateField#_tt", Form["#dateField#_tt"])>
		<cfif IsDate(dateResponse)>
			<cfset Form[dateField] = dateResponse>
		<cfelse><!--- IsStruct(dateResponse) --->
			<cfloop Collection="#dateResponse#" Item="field">
				<cfset errorMessage_fields["#field#"] = StructFind(dateResponse, field)>
			</cfloop>
		</cfif>
	</cfif>
</cfloop>

<!--- check that end begin date/time is before end date/time --->
<cfif StructIsEmpty(errorMessage_fields) and IsDate(Form.subscriptionDateEnd_date) and DateCompare(Form.subscriptionDateBegin, Form.subscriptionDateEnd) is not -1>
	<cfset errorMessage_fields.subscriptionDateEnd = Variables.lang_insertSubscription.subscriptionDateEnd>
</cfif>

<cfswitch expression="#Form.subscriptionEndByDateOrAppliedMaximum#">
<cfcase value="0"><!--- date --->
	<cfif Not IsDate(Form.subscriptionDateEnd)>
		<cfset errorMessage_fields.subscriptionEndByDateOrAppliedMaximum = Variables.lang_insertSubscription.subscriptionEndByDateOrAppliedMaximum_dateEnd>
	</cfif>
</cfcase>
<cfcase value="1"><!--- applied max --->
	<cfif Not Application.fn_IsIntegerPositive(Form.subscriptionAppliedMaximum)>
		<cfset errorMessage_fields.subscriptionEndByDateOrAppliedMaximum = Variables.lang_insertSubscription.subscriptionEndByDateOrAppliedMaximum_appliedMaximum>
	</cfif>
</cfcase>
<cfdefaultcase><!--- indefinite --->
	<cfif IsDate(Form.subscriptionDateEnd) and Application.fn_IsIntegerPositive(Form.subscriptionAppliedMaximum)>
		<cfset errorMessage_fields.subscriptionEndByDateOrAppliedMaximum = Variables.lang_insertSubscription.subscriptionEndByDateOrAppliedMaximum_both>
	</cfif>
</cfdefaultcase>
</cfswitch>

<cfif Form.userID is not "" and Form.userID is not 0>
	<cfloop Index="thisUserID" List="#Form.userID#">
		<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), thisUserID)>
			<cfset errorMessage_fields.userID = Variables.lang_insertSubscription.userID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif Form.subscriptionID_rollup is not 0 and GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfset rollupRow = ListFind(ValueList(qry_selectSubscriptionList.subscriptionID), Form.subscriptionID_rollup)>
	<cfif rollupRow is 0>
		<cfset errorMessage_fields.subscriptionID_rollup = Variables.lang_insertSubscription.subscriptionID_rollup_invalid>
	<cfelseif qry_selectSubscriptionList.subscriptionStatus[rollupRow] is 0>
		<cfset errorMessage_fields.subscriptionID_rollup = Variables.lang_insertSubscription.subscriptionID_rollup_inactive>
	<cfelseif qry_selectSubscriptionList.subscriptionID_rollup[rollupRow] is not 0>
		<cfset errorMessage_fields.subscriptionID_rollup = Variables.lang_insertSubscription.subscriptionID_rollup_nested>
	</cfif>
</cfif>
<cfif Form.subscriptionID_rollup is not 0 and Not StructKeyExists(errorMessage_fields, "subscriptionID_rollup")>
	<cfif Form.priceID is not qry_selectSubscriptionList.priceID[rollupRow]>
		<cfset errorMessage_fields.priceID_rollup = ReplaceNoCase(Variables.lang_insertSubscription.priceID_rollup, "<<priceID>>", qry_selectSubscriptionList.priceID[rollupRow], "ALL")>
	<cfelseif Form.subscriptionDateProcessNext is not qry_selectSubscriptionList.subscriptionDateProcessNext[rollupRow]>
		<cfif IsDate(qry_selectSubscriptionList.subscriptionDateProcessNext[rollupRow])>
			<cfset errorMessage_fields.subscriptionDateProcessNext_rollup = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionDateProcessNext_rollup, "<<subscriptionDateProcessNext>>", DateFormat(qry_selectSubscriptionList.subscriptionDateProcessNext[rollupRow], "mm/dd/yyyy"), "ALL")>
		<cfelse>
			<cfset errorMessage_fields.subscriptionDateProcessNext_rollup = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionDateProcessNext_rollup, "<<subscriptionDateProcessNext>>", "blank", "ALL")>
		</cfif>
	<cfelseif Form.subscriptionIntervalType is not qry_selectSubscriptionList.subscriptionIntervalType[rollupRow]>
		<cfset errorMessage_fields.subscriptionIntervalType_rollup = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionIntervalType_rollup, "<<subscriptionIntervalType>>", qry_selectSubscriptionList.subscriptionIntervalType[rollupRow], "ALL")>
	<cfelseif Form.subscriptionInterval is not qry_selectSubscriptionList.subscriptionInterval[rollupRow]>
		<cfif ListFind(Variables.subscriptionIntervalTypeList_value, Form.qry_selectSubscriptionList.subscriptionInterval[rollupRow])>
			<cfset errorMessage_fields.subscriptionInterval_rollup = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionInterval_rollup, "<<subscriptionInterval>>", qry_selectSubscriptionList.subscriptionInterval[rollupRow], "ALL")>
		<cfelse>
			<cfset errorMessage_fields.subscriptionInterval_rollup = ReplaceNoCase(Variables.lang_insertSubscription.subscriptionInterval_rollup, "<<subscriptionInterval>>", ListGetAt(Variables.subscriptionIntervalTypeList_label, ListFind(Variables.subscriptionIntervalTypeList_value, Form.qry_selectSubscriptionList.subscriptionInterval[rollupRow])), "ALL")>
		</cfif>
	</cfif>
</cfif>

<!--- Validate custom fields and custom status if applicable (and not via web service) --->
<cfif GetFileFromPath(GetBaseTemplatePath()) is "index.cfm">
	<cfif isCustomFieldValueExist is True>
		<cfinvoke component="#objInsertCustomFieldValue#" method="formValidate_insertCustomFieldValue" returnVariable="errorMessageStruct_customField" />
		<cfif Not StructIsEmpty(errorMessageStruct_customField)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_customField)>
		</cfif>
	</cfif>

	<cfif isStatusExist is True>
		<cfinvoke component="#objInsertStatusHistory#" method="formValidate_insertStatusHistory" returnVariable="errorMessageStruct_status" />
		<cfif Not StructIsEmpty(errorMessageStruct_status)>
			<cfset errorMessage_fields = StructAppend(errorMessage_fields, errorMessageStruct_status)>
		</cfif>
	</cfif>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertSubscription">
		<cfset errorMessage_title = Variables.lang_insertSubscription.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertSubscription.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertSubscription.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertSubscription.errorFooter>
</cfif>

