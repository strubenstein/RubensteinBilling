<cfset errorMessage_fields = StructNew()>

<cfif Not ListFind("0,1", Form.invoiceLineItemStatus)>
	<cfset errorMessage_fields.invoiceLineItemStatus = Variables.lang_insertInvoiceLineItem.invoiceLineItemStatus>
</cfif>

<cfif Not ListFind("0,1", Form.invoiceLineItemManual)>
	<cfset errorMessage_fields.invoiceLineItemManual = Variables.lang_insertInvoiceLineItem.invoiceLineItemManual>
</cfif>

<cfif Variables.doAction is "insertInvoiceLineItem" and Form.invoiceLineItemOrder is not 0
		and (Not Application.fn_IsIntegerPositive(Form.invoiceLineItemOrder) or Form.invoiceLineItemOrder gt qry_selectInvoiceLineItemList.RecordCount)>
	<cfset errorMessage_fields.invoiceLineItemOrder = Variables.lang_insertInvoiceLineItem.invoiceLineItemOrder>
</cfif>

<cfif Not IsNumeric(Form.invoiceLineItemQuantity)>
	<cfset errorMessage_fields.invoiceLineItemQuantity = Variables.lang_insertInvoiceLineItem.invoiceLineItemQuantity_numeric>
<cfelseif Form.invoiceLineItemQuantity lt 0>
	<cfset errorMessage_fields.invoiceLineItemQuantity = Variables.lang_insertInvoiceLineItem.invoiceLineItemQuantity_negative>
<cfelseif Find(".", Form.invoiceLineItemQuantity) and Len(ListLast(Form.invoiceLineItemQuantity, ".")) gt maxlength_InvoiceLineItem.invoiceLineItemQuantity>
	<cfset errorMessage_fields.invoiceLineItemQuantity = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemQuantity_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemQuantity, "ALL")>
</cfif>

<cfif Trim(Form.invoiceLineItemName) is "">
	<cfset errorMessage_fields.invoiceLineItemName = Variables.lang_insertInvoiceLineItem.invoiceLineItemName_blank>
<cfelseif Len(Form.invoiceLineItemName) gt maxlength_InvoiceLineItem.invoiceLineItemName>
	<cfset errorMessage_fields.invoiceLineItemName = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemName_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemName, "ALL"), "<<LEN>>", Len(Form.invoiceLineItemName), "ALL")>
</cfif>

<cfif Not ListFind("0,1", Form.invoiceLineItemDescriptionHtml)>
	<cfset errorMessage_fields.invoiceLineItemDescriptionHtml = Variables.lang_insertInvoiceLineItem.invoiceLineItemDescriptionHtml>
</cfif>

<cfif Len(Form.invoiceLineItemDescription) gt maxlength_InvoiceLineItem.invoiceLineItemDescription>
	<cfset errorMessage_fields.invoiceLineItemDescription = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemDescription_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemDescription, "ALL"), "<<LEN>>", Len(Form.invoiceLineItemDescription), "ALL")>
</cfif>

<cfif Len(Form.invoiceLineItemProductID_custom) gt maxlength_InvoiceLineItem.invoiceLineItemProductID_custom>
	<cfset errorMessage_fields.invoiceLineItemProductID_custom = ReplaceNoCase(ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemProductID_custom_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemProductID_custom, "ALL"), "<<LEN>>", Len(Form.invoiceLineItemProductID_custom), "ALL")>
</cfif>

<cfif Not Application.fn_IsIntegerNonNegative(Form.regionID)>
	<cfset errorMessage_fields.regionID = Variables.lang_insertInvoiceLineItem.regionID>
</cfif>

<cfif Form.invoiceLineItemPriceNormal is "">
	<cfset Form.invoiceLineItemPriceNormal = 0>
<cfelseif Not IsNumeric(Form.invoiceLineItemPriceNormal) or Form.invoiceLineItemPriceNormal lt 0>
	<cfset errorMessage_fields.invoiceLineItemPriceNormal = Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceNormal_numeric>
<cfelseif Find(".", Form.invoiceLineItemPriceNormal) and Len(ListLast(Form.invoiceLineItemPriceNormal, ".")) gt maxlength_InvoiceLineItem.invoiceLineItemPriceNormal>
	<cfset errorMessage_fields.invoiceLineItemPriceNormal = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceNormal_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemPriceNormal, "ALL")>
</cfif>

<cfif Form.invoiceLineItemDiscount is "">
	<cfset Form.invoiceLineItemDiscount = 0>
<cfelseif Not IsNumeric(Form.invoiceLineItemDiscount) or Form.invoiceLineItemDiscount lt 0>
	<cfset errorMessage_fields.invoiceLineItemDiscount = Variables.lang_insertInvoiceLineItem.invoiceLineItemDiscount_numeric>
<cfelseif Find(".", Form.invoiceLineItemDiscount) and Len(ListLast(Form.invoiceLineItemDiscount, ".")) gt maxlength_InvoiceLineItem.invoiceLineItemDiscount>
	<cfset errorMessage_fields.invoiceLineItemDiscount = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemDiscount_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemDiscount, "ALL")>
</cfif>

<cfif Form.invoiceLineItemTotalTax is "">
	<cfset Form.invoiceLineItemTotalTax = 0>
<cfelseif Not IsNumeric(Form.invoiceLineItemTotalTax) or Form.invoiceLineItemTotalTax lt 0>
	<cfset errorMessage_fields.invoiceLineItemTotalTax = Variables.lang_insertInvoiceLineItem.invoiceLineItemTotalTax_numeric>
<cfelseif Find(".", Form.invoiceLineItemTotalTax) and Len(ListLast(Form.invoiceLineItemTotalTax, ".")) gt maxlength_InvoiceLineItem.invoiceLineItemTotalTax>
	<cfset errorMessage_fields.invoiceLineItemTotalTax = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemTotalTax_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemTotalTax, "ALL")>
</cfif>

<cfset Form.invoiceLineItemDateBegin = "">
<cfif Form.invoiceLineItemDateBegin_date is not "">
	<cfset dateBeginResponse = fn_FormValidateDateTime("begin", "invoiceLineItemDateBegin_date", Form.invoiceLineItemDateBegin_date, "invoiceLineItemDateBegin_hh", Form.invoiceLineItemDateBegin_hh, "invoiceLineItemDateBegin_mm", Form.invoiceLineItemDateBegin_mm, "invoiceLineItemDateBegin_tt", Form.invoiceLineItemDateBegin_tt)>
	<cfif IsDate(dateBeginResponse)>
		<cfset Form.invoiceLineItemDateBegin = dateBeginResponse>
	<cfelse><!--- IsStruct(dateBeginResponse) --->
		<cfloop Collection="#dateBeginResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(dateBeginResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfset Form.invoiceLineItemDateEnd = "">
<cfif Form.invoiceLineItemDateEnd_date is not "">
	<cfset dateEndResponse = fn_FormValidateDateTime("end", "invoiceLineItemDateEnd_date", Form.invoiceLineItemDateEnd_date, "invoiceLineItemDateEnd_hh", Form.invoiceLineItemDateEnd_hh, "invoiceLineItemDateEnd_mm", Form.invoiceLineItemDateEnd_mm, "invoiceLineItemDateEnd_tt", Form.invoiceLineItemDateEnd_tt)>
	<cfif dateEndResponse is "" or IsDate(dateEndResponse)>
		<cfset Form.invoiceLineItemDateEnd = dateEndResponse>
	<cfelse><!--- IsStruct(dateEndResponse) --->
		<cfloop Collection="#dateEndResponse#" Item="field">
			<cfset errorMessage_fields["#field#"] = StructFind(dateEndResponse, field)>
		</cfloop>
	</cfif>
</cfif>

<cfif IsDate(Form.invoiceLineItemDateBegin) and IsDate(Form.invoiceLineItemDateEnd) and DateCompare(Form.invoiceLineItemDateBegin, Form.invoiceLineItemDateEnd) is not -1>
	<cfset errorMessage_fields.invoiceLineItemDateEnd = Variables.lang_insertInvoiceLineItem.invoiceLineItemDateEnd>
</cfif>

<cfif URL.productID is 0><!--- custom product --->
	<cfset Form.categoryID = 0>
	<cfset Form.priceID = 0>
	<cfset Form.productParameterExceptionID = 0>
<cfelse><!--- real product --->
	<cfif Form.categoryID is not 0 and Not ListFind(ValueList(qry_selectProductCategory.categoryID), Form.categoryID)>
		<cfset errorMessage_fields.categoryID = Variables.lang_insertInvoiceLineItem.categoryID>
	</cfif>

	<!--- validate price --->
	<cfif Form.priceID is not 0>
		<cfset priceRow = ListFind(ValueList(qry_selectPriceListForTarget.priceID), Form.priceID)>
		<cfif priceRow is 0>
			<cfset errorMessage_fields.priceID = Variables.lang_insertInvoiceLineItem.priceID_valid>
		<cfelseif qry_selectPriceListForTarget.priceQuantityMinimumPerOrder is not 0 and qry_selectPriceListForTarget.priceQuantityMinimumPerOrder lt Form.invoiceLineItemQuantity>
			<cfset errorMessage_fields.priceID = Replace(Variables.lang_insertInvoiceLineItem.priceID_minQuantityPerOrder, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMinimumPerOrder), "ALL")>
		<cfelse>
			<!--- validate quantity is not greater than maximum quantity per customer --->
			<cfif qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer is not 0
					and displayPriceQuantityMaximumPerCustomer is True
					and StructKeyExists(quantityMaximumPerCustomer, "price#Form.priceID#")>
				<cfset sumQuantity = quantityMaximumPerCustomer["price#Form.priceID#"]>
				<cfif sumQuantity gte qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.priceID_maxQuantityPerCustomerReached, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer), "ALL")>
				<cfelseif (Form.invoiceLineItemQuantity + sumQuantity) gte qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer>
					<cfset remainderPerCustomer = Abs(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer - sumQuantity - Form.invoiceLineItemQuantity)>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertInvoiceLineItem.priceID_maxQuantityPerCustomerSplit, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumPerCustomer), "ALL"), "<<REMAINING>>", sumQuantity, "ALL"), "<<REMAINDER>>", remainderPerCustomer, "ALL")>
					<cfset multipleLineItem_priceQuantityMaxPerCustomer = True>
				</cfif>
			</cfif>

			<!--- validate quantity is not greater than maximum quantity for all customers --->
			<cfif qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers is not 0
					and displayPriceQuantityMaximumAllCustomers is True
					and StructKeyExists(quantityMaximumAllCustomers, "price#Form.priceID#")>
				<cfset sumQuantity = quantityMaximumAllCustomers["price#Form.priceID#"]>
				<cfif sumQuantity gte qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.priceID_maxQuantityAllCustomersReached, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers), "ALL")>
				<cfelseif (Form.invoiceLineItemQuantity + sumQuantity) gte qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers>
					<cfset remainderAllCustomers = Abs(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers - sumQuantity - Form.invoiceLineItemQuantity)>
					<cfset errorMessage_fields.priceID = ReplaceNoCase(ReplaceNoCase(ReplaceNoCase(Variables.lang_insertInvoiceLineItem.priceID_maxQuantityAllCustomersSplit, "<<QUANTITY>>", Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectPriceListForTarget.priceQuantityMaximumAllCustomers), "ALL"), "<<REMAINING>>", sumQuantity, "ALL"), "<<REMAINDER>>", remainderAllCustomers, "ALL")>
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
				<cfset errorMessage_fields.productParameterID = Variables.lang_insertInvoiceLineItem.productParameterID_required>
			<cfelseif qry_selectProductParameterList.productParameterRequired is 1 and Trim(Form["parameter#qry_selectProductParameterList.productParameterID#"]) is "">
				<cfset errorMessage_fields.productParameterID = Variables.lang_insertInvoiceLineItem.productParameterID_blank>
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
						<cfset errorMessage_fields.productParameterID = Variables.lang_insertInvoiceLineItem.productParameterID_valid>
					<cfelseif Not ArrayIsEmpty(invoiceLineItemProductID_customArray)>
						<cfloop Index="count" From="1" To="#ArrayLen(invoiceLineItemProductID_customArray)#">
							<cfset Form.invoiceLineItemProductID_custom = Form.invoiceLineItemProductID_custom & invoiceLineItemProductID_customArray[count]>
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
						<cfset errorMessage_fields.productParameterID = Variables.lang_insertInvoiceLineItem.productParameterID_excluded>
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

<cfif Form.priceID is not 0 and Form.invoiceLineItemPriceUnit is "">
	<cfset Form.invoiceLineItemPriceUnit = 0>
<cfelseif Not IsNumeric(Form.invoiceLineItemPriceUnit) or Form.invoiceLineItemPriceUnit lt 0>
	<cfset errorMessage_fields.invoiceLineItemPriceUnit = Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceUnit_numeric>
<cfelseif Find(".", Form.invoiceLineItemPriceUnit) and Len(ListLast(Form.invoiceLineItemPriceUnit, ".")) gt maxlength_InvoiceLineItem.invoiceLineItemPriceUnit>
	<cfset errorMessage_fields.invoiceLineItemPriceUnit = ReplaceNoCase(Variables.lang_insertInvoiceLineItem.invoiceLineItemPriceUnit_maxlength, "<<MAXLENGTH>>", maxlength_InvoiceLineItem.invoiceLineItemPriceUnit, "ALL")>
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

<cfif Form.userID is not "" and Form.userID is not 0>
	<cfloop Index="thisUserID" List="#Form.userID#">
		<cfif Not ListFind(ValueList(qry_selectUserCompanyList_company.userID), thisUserID)>
			<cfset errorMessage_fields.userID = Variables.lang_insertInvoiceLineItem.userID>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfif Variables.doAction is "insertInvoiceLineItem">
		<cfset errorMessage_title = Variables.lang_insertInvoiceLineItem.errorTitle_insert>
	<cfelse>
		<cfset errorMessage_title = Variables.lang_insertInvoiceLineItem.errorTitle_update>
	</cfif>
	<cfset errorMessage_header = Variables.lang_insertInvoiceLineItem.errorHeader>
	<cfset errorMessage_footer = Variables.lang_insertInvoiceLineItem.errorFooter>
</cfif>

