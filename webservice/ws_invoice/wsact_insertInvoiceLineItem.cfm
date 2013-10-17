<!--- validate product, custom price and product parameters --->
<cfinclude template="wsact_validateProductForLineItem.cfm">

<cfif returnValue is 0>
	<cfinvoke Component="#Application.billingMapping#data.Invoice" Method="selectInvoice" ReturnVariable="qry_selectInvoice">
		<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
	</cfinvoke>

	<cfif qry_selectInvoice.invoiceClosed is not 0>
		<cfif Not IsDefined("Variables.wslang_invoice")>
			<cfinclude template="wslang_invoice.cfm">
		</cfif>
		<cfset returnValue = -1>
		<cfset returnError = Variables.wslang_invoice.invoiceClosed>
	<cfelse>
		<!--- 
		<cfset displayProductParameter = False>
		<cfset displayProductParameterException = False>
		<cfset displayCustomPrice = False>
		<cfset displayCustomPriceVolumeDiscount = False>
		<cfset displayPriceQuantityMaximumPerCustomer = False>
		<cfset displayPriceQuantityMaximumAllCustomers = False>
		--->

		<cfset URL.invoiceID = Arguments.invoiceID>
		<cfset URL.productID = Arguments.productID>
		<cfset URL.invoiceLineItemID = 0>

		<cfset Form = Arguments>
		<cfset Variables.doAction = "insertInvoiceLineItem">

		<cfif Arguments.productID is not 0>
			<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProduct" ReturnVariable="qry_selectProduct">
				<cfinvokeargument Name="productID" Value="#Arguments.productID#">
			</cfinvoke>

			<cfinclude template="../../control/c_invoice/act_insertInvoiceLineItem_getProduct.cfm">
			<cfinclude template="../../control/c_invoice/act_insertInvoiceLineItem_getPrices.cfm">

			<!--- if real product, use product values as ilne item defaults unless otherwise specified --->
			<cfif Arguments.invoiceLineItemName is "">
				<cfset Arguments.invoiceLineItemName = qry_selectProductLanguage.productLanguageLineItemName>
			</cfif>
			<cfif Arguments.invoiceLineItemDescription is "">
				<cfset Arguments.invoiceLineItemDescription = qry_selectProductLanguage.productLanguageLineItemDescription>
			</cfif>
			<cfif Arguments.invoiceLineItemDescriptionHtml is "">
				<cfset Arguments.invoiceLineItemDescriptionHtml = qry_selectProductLanguage.productLanguageLineItemDescriptionHtml>
			</cfif>
			<cfif Arguments.invoiceLineItemProductID_custom is "">
				<cfset Arguments.invoiceLineItemProductID_custom = qry_selectProduct.productID_custom>
			</cfif>
			<cfif Not IsNumeric(Arguments.invoiceLineItemPriceNormal)>
				<cfset Arguments.invoiceLineItemPriceNormal = qry_selectProduct.productPrice>
			</cfif>
			<cfif Not IsNumeric(Arguments.invoiceLineItemPriceUnit)>
				<cfset Arguments.invoiceLineItemPriceUnit = qry_selectProduct.productPrice>
			</cfif>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
			<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
			<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
		</cfinvoke>

		<cfif Not IsDefined("fn_DisplayPriceAmount")>
			<cfinclude template="../../include/function/fn_DisplayPrice.cfm">
		</cfif>
		<cfif Not IsDefined("fn_ConvertTo24HourFormat")>
			<cfinclude template="../../include/function/fn_datetime.cfm">
		</cfif>

		<cfinclude template="../../control/c_invoice/formParam_insertInvoiceLineItem.cfm">
		<cfinvoke component="#Application.billingMapping#data.InvoiceLineItem" method="maxlength_InvoiceLineItem" returnVariable="maxlength_InvoiceLineItem" />

		<cfloop Index="field" List="invoiceLineItemDateBegin,invoiceLineItemDateEnd">
			<cfif Not IsDate(Arguments[field])>
				<cfset Form["#field#_date"] = "">
				<cfset Form["#field#_hh"] = "12">
				<cfset Form["#field#_mm"] = "00">
				<cfset Form["#field#_tt"] = "am">
			<cfelse>
				<cfset hour_ampm = fn_ConvertFrom24HourFormat(Hour(Arguments[field]))>
				<cfset Form["#field#_date"] = DateFormat(Arguments[field], 'mm/dd/yyyy')>
				<cfset Form["#field#_hh"] = ListFirst(hour_ampm, '|')>
				<cfset Form["#field#_mm"] = Minute(Arguments[field])>
				<cfset Form["#field#_tt"] = ListLast(hour_ampm, '|')>
			</cfif>
		</cfloop>

		<!--- 
		<cfset productParameterOptionID_list = "">
		<cfset productParameterExceptionID = 0>
		<cfset productParameterExceptionPricePremium = 0>

		<cfset multipleLineItem_priceStageVolumeStep = False>
		<cfset multipleLineItem_priceQuantityMaxPerCustomer = False>
		<cfset multipleLineItem_priceQuantityMaxAllCustomers = False>
		--->

		<cfinclude template="../../view/v_invoice/lang_insertInvoiceLineItem.cfm">
		<cfinclude template="../../control/c_invoice/formValidate_insertInvoiceLineItem.cfm">

		<cfif isAllFormFieldsOk is False>
			<cfset returnValue = -1>
			<cfset returnError = "">
			<cfloop Collection="#errorMessage_fields#" Item="field">
				<cfset returnError = ListAppend(returnError, StructFind(errorMessage_fields, field), Chr(10))>
			</cfloop>
		<cfelse>
			<!--- determine custom price if necessary --->
			<!--- insert multiple line items if necessary for step/volume pricing --->
			<!--- <cfset lineItemArray = ArrayNew(1)> --->

			<cfset lineItemArray[1] = StructNew()>
			<cfset lineItemArray[1].quantity = Form.invoiceLineItemQuantity>
			<cfset lineItemArray[1].priceUnit = Form.invoiceLineItemPriceUnit + productParameterExceptionPricePremium>
			<cfset lineItemArray[1].subTotal = lineItemArray[1].priceUnit * Form.invoiceLineItemQuantity>
			<cfset lineItemArray[1].discount = Form.invoiceLineItemDiscount>
			<cfset lineItemArray[1].totalTax = Form.invoiceLineItemTotalTax>
			<cfset lineItemArray[1].priceVolumeDiscountID = 0>

			<cfif Form.priceID is not 0>
				<!--- not volume discount --->
				<cfif qry_selectPriceListForTarget.priceStageVolumeDiscount[priceRow] is 0>
					<cfinclude template="../../control/c_invoice/act_insertInvoiceLineItem_priceSimple.cfm">

				<!--- volume discount, but not step method --->
				<cfelseif qry_selectPriceListForTarget.priceStageVolumeStep[priceRow] is 0>
					<cfinclude template="../../control/c_invoice/act_insertInvoiceLineItem_priceVolume.cfm">

				<!--- volume discount with step method --->
				<cfelse>
					<cfinclude template="../../control/c_invoice/act_insertInvoiceLineItem_priceStep.cfm">
				</cfif>
			</cfif>

			<cfif Form.priceID is not 0>
				<cfset priceStageID = qry_selectPriceListForTarget.priceStageID[ListFind(ValueList(qry_selectPriceListForTarget.priceID), Form.priceID)]>
			</cfif>

			<cfset returnValue = "">
			<cfloop Index="count" From="1" To="#ArrayLen(lineItemArray)#">
				<!--- insert new line item --->
				<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItem" ReturnVariable="newInvoiceLineItemID">
					<cfinvokeargument Name="invoiceID" Value="#Arguments.invoiceID#">
					<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
					<cfinvokeargument Name="productID" Value="#URL.productID#">
					<cfinvokeargument Name="priceID" Value="#Form.priceID#">
					<cfif Form.priceID is not 0>
						<cfinvokeargument Name="priceStageID" Value="#priceStageID#">
						<cfinvokeargument Name="priceVolumeDiscountID" Value="#lineItemArray[count].priceVolumeDiscountID#">
					</cfif>
					<cfinvokeargument Name="categoryID" Value="0">
					<cfinvokeargument Name="invoiceLineItemName" Value="#Form.invoiceLineItemName#">
					<cfinvokeargument Name="invoiceLineItemDescription" Value="#Form.invoiceLineItemDescription#">
					<cfinvokeargument Name="invoiceLineItemDescriptionHtml" Value="#Form.invoiceLineItemDescriptionHtml#">
					<cfinvokeargument Name="invoiceLineItemQuantity" Value="#lineItemArray[count].quantity#">
					<cfinvokeargument Name="invoiceLineItemPriceUnit" Value="#lineItemArray[count].priceUnit#">
					<cfinvokeargument Name="invoiceLineItemPriceNormal" Value="#Form.invoiceLineItemPriceNormal#">
					<cfinvokeargument Name="invoiceLineItemDiscount" Value="#lineItemArray[count].discount#">
					<cfinvokeargument Name="invoiceLineItemTotalTax" Value="#lineItemArray[count].totalTax#">
					<cfinvokeargument Name="invoiceLineItemSubTotal" Value="#lineItemArray[count].subTotal#">
					<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
					<cfinvokeargument Name="invoiceLineItemManual" Value="1">
					<cfinvokeargument Name="invoiceLineItemProductID_custom" Value="#Form.invoiceLineItemProductID_custom#">
					<cfinvokeargument Name="productParameterExceptionID" Value="#productParameterExceptionID#">
					<cfinvokeargument Name="regionID" Value="0">
					<cfinvokeargument Name="invoiceLineItemID_trend" Value="0">
					<cfinvokeargument Name="invoiceLineItemID_parent" Value="0">
					<cfinvokeargument Name="invoiceLineItemDateBegin" Value="#Form.invoiceLineItemDateBegin#">
					<cfinvokeargument Name="invoiceLineItemDateEnd" Value="#Form.invoiceLineItemDateEnd#">
					<cfinvokeargument Name="isUpdateInvoiceTotal" Value="True">
					<cfinvokeargument Name="userID" Value="#Form.userID#">
				</cfinvoke>

				<cfset returnValue = ListAppend(returnValue, newInvoiceLineItemID)>

				<!--- insert parameters --->
				<cfif displayProductParameter is True>
					<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItemParameter" ReturnVariable="isInvoiceLineItemParameterInserted">
						<cfinvokeargument Name="invoiceLineItemID" Value="#newInvoiceLineItemID#">
						<cfinvokeargument Name="productParameterOptionID" Value="#productParameterOptionID_list#">
						<cfinvokeargument Name="deleteExistingLineItemParameter" Value="True">
					</cfinvoke>
				</cfif>

				<!--- custom fields --->
				<cfif Trim(invoiceLineItem_customField) is not "">
					<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertCustomFieldValues" ReturnVariable="isCustomFieldValuesInserted">
						<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
						<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
						<cfinvokeargument Name="primaryTargetKey" Value="invoiceLineItemID">
						<cfinvokeargument Name="targetID" Value="#newInvoiceLineItemID#">
						<cfinvokeargument Name="customField" Value="#invoiceLineItem_customField#">
					</cfinvoke>
				</cfif>

				<!--- custom status --->
				<cfif invoiceLineItem_statusID is not 0
						or ListFind(Arguments.useCustomIDFieldList, "statusID") or ListFind(Arguments.useCustomIDFieldList, "statusID_custom")
						or ListFind(Arguments.useCustomIDFieldList, "statusID_invoiceLineItem") or ListFind(Arguments.useCustomIDFieldList, "statusID_invoiceLineItem_custom")>
					<cfinvoke Component="#Application.billingMapping#webservice.WebServiceFunction" Method="insertStatusHistory" ReturnVariable="isStatusHistoryInserted">
						<cfinvokeargument Name="companyID_author" Value="#qry_selectWebServiceSession.companyID_author#">
						<cfinvokeargument Name="userID_author" Value="#qry_selectWebServiceSession.userID#">
						<cfinvokeargument Name="primaryTargetKey" Value="invoiceLineItemID">
						<cfinvokeargument Name="targetID" Value="#newInvoiceLineItemID#">
						<cfinvokeargument Name="useCustomIDFieldList" Value="#invoiceLineItem_useCustomIDFieldList#">
						<cfinvokeargument Name="statusID" Value="#invoiceLineItem_statusID#">
						<cfinvokeargument Name="statusID_custom" Value="#invoiceLineItem_statusID_custom#">
						<cfinvokeargument Name="statusHistoryComment" Value="#Arguments.statusHistoryComment#">
					</cfinvoke>
				</cfif>
			</cfloop><!--- /loop thru all line items --->

			<!--- check for trigger --->
			<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
				<cfinvokeargument name="companyID" value="#qry_selectWebServiceSession.companyID#">
				<cfinvokeargument name="doAction" value="insertInvoiceLineItem">
				<cfinvokeargument name="isWebService" value="True">
				<cfinvokeargument name="doControl" value="invoice">
				<cfinvokeargument name="primaryTargetKey" value="invoiceLineItemID">
				<cfinvokeargument name="targetID" value="#newInvoiceLineItemID#">
			</cfinvoke>
		</cfif><!--- /validate fields --->
	</cfif><!--- invoice is still open --->
</cfif><!--- /pre-validation of arguments --->
