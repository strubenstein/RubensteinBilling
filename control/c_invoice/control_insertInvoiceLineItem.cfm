<!--- 
4 options:
- Add a new line item with an existing product
- Add a new line item based on an existing line item (copy)
- Add a new line item with a "custom" product that does not exist
- Update an existing line item, using the same product

If new line item, let user choose between custom product and existing product.
--->

<cfparam Name="URL.invoiceLineItemID" Default="0">
<!--- if new line item, select existing product or enter custom product info --->
<cfif Variables.doAction is "updateInvoiceLineItem" or URL.invoiceLineItemID is not 0>
	<cfset URL.productID = qry_selectInvoiceLineItem.productID>
<cfelseif Not IsDefined("URL.productID") or URL.productID is -1>
	<cfset Variables.urlParameters = "&invoiceID=#URL.invoiceID#">
	<cfset Variables.doAction = "listProducts">
	<cfset Variables.doControl = "product">
	<cfinclude template="../control.cfm">
	<cfinclude template="../../view/v_adminMain/footer_admin.cfm">
	<cfabort>
<cfelseif URL.productID is not 0>
	<cfif Not Application.fn_IsIntegerPositive(URL.productID)>
		<cflocation url="index.cfm?method=invoice.viewInvoice&invoiceID=#URL.invoiceID#&error_invoice=invalidProduct" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Product" Method="checkProductPermission" ReturnVariable="isProductPermission">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		</cfinvoke>

		<cfif isProductPermission is False>
			<cflocation url="index.cfm?method=invoice.viewInvoice&invoiceID=#URL.invoiceID#&error_invoice=invalidProduct" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset displayProductParameter = False>
<cfset displayProductParameterException = False>
<cfset displayCustomPrice = False>
<cfset displayCustomPriceVolumeDiscount = False>
<cfset displayPriceQuantityMaximumPerCustomer = False>
<cfset displayPriceQuantityMaximumAllCustomers = False>
<!--- 
<cfset Variables.productID_customPriceRow = StructNew()>
<cfset Variables.productID_customPriceAmount = StructNew()>
--->

<!--- select product --->
<cfif URL.productID is not 0>
	<cfinclude template="act_insertInvoiceLineItem_getProduct.cfm">
	<cfinclude template="act_insertInvoiceLineItem_getPrices.cfm">
</cfif>

<cfif Variables.doAction is "insertInvoiceLineItem">
	<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemList" ReturnVariable="qry_selectInvoiceLineItemList">
		<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
		<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
	</cfinvoke>
<cfelse><!--- updateInvoiceLineItem --->
	<!--- select existing contact users for company --->
	<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="selectInvoiceLineItemUser" ReturnVariable="qry_selectInvoiceLineItemUser">
		<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
	</cfinvoke>
</cfif>

<!--- get users in company for contact --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
	<cfinvokeargument Name="companyID" Value="#qry_selectInvoice.companyID#">
	<cfinvokeargument Name="userCompanyStatus" Value="1">
</cfinvoke>

<cfinclude template="../../include/function/fn_DisplayPrice.cfm">
<cfinclude template="../../include/function/fn_datetime.cfm">

<cfinclude template="formParam_insertInvoiceLineItem.cfm">
<cfinvoke component="#Application.billingMapping#data.InvoiceLineItem" method="maxlength_InvoiceLineItem" returnVariable="maxlength_InvoiceLineItem" />
<cfinclude template="../../view/v_invoice/lang_insertInvoiceLineItem.cfm">

<!--- Determine whether custom fields and custom status apply to this object --->
<cfobject name="objInsertCustomFieldValue" component="#Application.billingMapping#control.c_customField.InsertCustomFieldValue" />
<cfobject name="objInsertStatusHistory" component="#Application.billingMapping#control.c_status.InsertStatusHistory" />

<cfinvoke component="#objInsertCustomFieldValue#" method="formParam_insertCustomFieldValue" returnVariable="isCustomFieldValueExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="invoiceLineItemID">
	<cfinvokeargument name="targetID_formParam" value="#URL.invoiceLineItemID#">
</cfinvoke>

<cfinvoke component="#objInsertStatusHistory#" method="formParam_insertStatusHistory" returnVariable="isStatusExist">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="invoiceLineItemID">
	<cfinvokeargument name="targetID_formParam" value="#URL.invoiceLineItemID#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInvoiceLineItem")>
	<cfset productParameterOptionID_list = "">
	<cfset productParameterExceptionID = 0>
	<cfset productParameterExceptionPricePremium = 0>

	<cfset multipleLineItem_priceStageVolumeStep = False>
	<cfset multipleLineItem_priceQuantityMaxPerCustomer = False>
	<cfset multipleLineItem_priceQuantityMaxAllCustomers = False>

	<cfinclude template="formValidate_insertInvoiceLineItem.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- determine custom price if necessary --->
		<!--- insert multiple line items if necessary for step/volume pricing --->
		<cfset lineItemArray = ArrayNew(1)>

		<cfset lineItemArray[1] = StructNew()>
		<cfset lineItemArray[1].quantity = Form.invoiceLineItemQuantity>
		<cfset lineItemArray[1].priceUnit = Form.invoiceLineItemPriceUnit + productParameterExceptionPricePremium>
		<cfset lineItemArray[1].subTotal = lineItemArray[1].priceUnit * Form.invoiceLineItemQuantity>
		<cfset lineItemArray[1].discount = Form.invoiceLineItemDiscount>
		<cfset lineItemArray[1].totalTax = Form.invoiceLineItemTotalTax>
		<cfset lineItemArray[1].priceVolumeDiscountID = 0>

		<!--- 
		<cfset lineItemArray[1].subTotal = (lineItemArray[1].priceUnit * Form.invoiceLineItemQuantity) - Form.invoiceLineItemDiscount>
		<cfset lineItemArray[1].total = lineItemArray[1].subTotal + Form.invoiceLineItemTotalTax>
		--->

		<cfif Form.priceID is not 0>
			<!--- not volume discount --->
			<cfif qry_selectPriceListForTarget.priceStageVolumeDiscount[priceRow] is 0>
				<cfinclude template="act_insertInvoiceLineItem_priceSimple.cfm">

			<!--- volume discount, but not step method --->
			<cfelseif qry_selectPriceListForTarget.priceStageVolumeStep[priceRow] is 0>
				<cfinclude template="act_insertInvoiceLineItem_priceVolume.cfm">

			<!--- volume discount with step method --->
			<cfelse>
				<cfinclude template="act_insertInvoiceLineItem_priceStep.cfm">
			</cfif>
		</cfif>

		<!--- if updating existing line item, make line item inactive --->
		<cfif Variables.doAction is "updateInvoiceLineItem">
			<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="updateInvoiceLineItem" ReturnVariable="isInvoiceLineItemUpdated">
				<cfinvokeargument Name="invoiceLineItemID" Value="#URL.invoiceLineItemID#">
				<cfinvokeargument Name="invoiceLineItemStatus" Value="0">
				<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
				<cfinvokeargument Name="invoiceLineItemOrder" Value="0">
			</cfinvoke>
		</cfif>

		<cfif Form.priceID is not 0>
			<cfset priceStageID = qry_selectPriceListForTarget.priceStageID[ListFind(ValueList(qry_selectPriceListForTarget.priceID), Form.priceID)]>
		</cfif>

		<cfloop Index="count" From="1" To="#ArrayLen(lineItemArray)#">
			<!--- insert new line item --->
			<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItem" ReturnVariable="newInvoiceLineItemID">
				<cfinvokeargument Name="invoiceID" Value="#URL.invoiceID#">
				<cfinvokeargument Name="userID_author" Value="#Session.userID#">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<!--- 
				<cfinvokeargument Name="invoiceLineItemProductIsBundle" Value="0">
				<cfinvokeargument Name="invoiceLineItemProductInBundle" Value="0">
				--->
				<cfinvokeargument Name="priceID" Value="#Form.priceID#">	
				<cfif Form.priceID is not 0>
					<cfinvokeargument Name="priceStageID" Value="#priceStageID#">
					<cfinvokeargument Name="priceVolumeDiscountID" Value="#lineItemArray[count].priceVolumeDiscountID#">
				</cfif>
				<cfinvokeargument Name="categoryID" Value="#Form.categoryID#">
				<cfinvokeargument Name="invoiceLineItemName" Value="#Form.invoiceLineItemName#">
				<cfinvokeargument Name="invoiceLineItemDescription" Value="#Form.invoiceLineItemDescription#">
				<cfinvokeargument Name="invoiceLineItemDescriptionHtml" Value="#Form.invoiceLineItemDescriptionHtml#">
				<cfinvokeargument Name="invoiceLineItemQuantity" Value="#lineItemArray[count].quantity#">
				<cfinvokeargument Name="invoiceLineItemPriceUnit" Value="#lineItemArray[count].priceUnit#">
				<cfinvokeargument Name="invoiceLineItemPriceNormal" Value="#Form.invoiceLineItemPriceNormal#">
				<cfinvokeargument Name="invoiceLineItemDiscount" Value="#lineItemArray[count].discount#">
				<cfinvokeargument Name="invoiceLineItemTotalTax" Value="#lineItemArray[count].totalTax#">
				<cfinvokeargument Name="invoiceLineItemSubTotal" Value="#lineItemArray[count].subTotal#">
				<!--- 
				<cfinvokeargument Name="invoiceLineItemTotal" Value="#lineItemArray[count].total#">
				--->
				<cfinvokeargument Name="invoiceLineItemStatus" Value="1">
				<cfinvokeargument Name="invoiceLineItemManual" Value="1">
				<cfinvokeargument Name="invoiceLineItemProductID_custom" Value="#Form.invoiceLineItemProductID_custom#">
				<cfinvokeargument Name="productParameterExceptionID" Value="#productParameterExceptionID#">
				<cfinvokeargument Name="regionID" Value="#Form.regionID#">
				<cfif Variables.doAction is "insertInvoiceLineItem">
					<cfinvokeargument Name="invoiceLineItemID_trend" Value="0">
					<cfinvokeargument Name="invoiceLineItemID_parent" Value="0">
				<cfelse>
					<cfinvokeargument Name="invoiceLineItemID_trend" Value="#qry_selectInvoiceLineItem.invoiceLineItemID_trend#">
					<cfinvokeargument Name="invoiceLineItemID_parent" Value="#URL.invoiceLineItemID#">
					<cfinvokeargument Name="invoiceLineItemOrder" Value="#DecrementValue(qry_selectInvoiceLineItem.invoiceLineItemOrder + count)#">
				</cfif>
				<cfinvokeargument Name="invoiceLineItemDateBegin" Value="#Form.invoiceLineItemDateBegin#">
				<cfinvokeargument Name="invoiceLineItemDateEnd" Value="#Form.invoiceLineItemDateEnd#">
				<cfinvokeargument Name="isUpdateInvoiceTotal" Value="True">
				<cfinvokeargument Name="userID" Value="#Form.userID#">
			</cfinvoke>

			<!--- insert parameters --->
			<cfif displayProductParameter is True>
				<cfinvoke Component="#Application.billingMapping#data.InvoiceLineItem" Method="insertInvoiceLineItemParameter" ReturnVariable="isInvoiceLineItemParameterInserted">
					<cfinvokeargument Name="invoiceLineItemID" Value="#newInvoiceLineItemID#">
					<cfinvokeargument Name="productParameterOptionID" Value="#productParameterOptionID_list#">
					<cfinvokeargument Name="deleteExistingLineItemParameter" Value="True">
				</cfinvoke>
			</cfif>

			<!--- Insert custom fields and custom status if necessary --->
			<cfif isCustomFieldValueExist is True>
				<cfinvoke component="#objInsertCustomFieldValue#" method="formProcess_insertCustomFieldValue" returnVariable="isCustomFieldValueProcessed">
					<cfinvokeargument name="targetID_formProcess" value="#newInvoiceLineItemID#">
					<cfinvokeargument name="userID" value="#Session.userID#">
				</cfinvoke>
			</cfif>

			<cfif isStatusExist is True>
				<cfinvoke component="#objInsertStatusHistory#" method="formProcess_insertStatusHistory" returnVariable="isStatusHistoryProcessed">
					<cfinvokeargument name="targetID_formProcess" value="#newInvoiceLineItemID#">
					<cfinvokeargument name="userID" value="#Session.userID#">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cfif ArrayLen(Variables.lineItemArray) is 1>
			<cfset Variables.confirm_invoice = Variables.doAction>
		<cfelse><!--- multiple line items because of steps --->
			<cfset Variables.confirm_invoice = Variables.doAction & "Step">
		</cfif>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="invoiceLineItemID">
			<cfinvokeargument name="targetID" value="#newInvoiceLineItemID#">
		</cfinvoke>

		<cfif Application.fn_IsUserAuthorized("viewInvoiceLineItems")>
			<cflocation url="index.cfm?method=invoice.viewInvoiceLineItems&invoiceID=#URL.invoiceID#&confirm_invoice=#Variables.confirm_invoice#" AddToken="No">
		<cfelse>
			<cfif Variables.doAction is "updateInvoiceLineItem">
				<cfset Variables.redirectVars = "&invoiceLineItemID=#newInvoiceLineItemID#">
			<cfelseif URL.productID is 0>
				<cfset Variables.redirectVars = "&productID=0">
			<cfelse>
				<cfset Variables.redirectVars = "">
			</cfif>

			<cflocation url="index.cfm?method=invoice.#Variables.doAction#&invoiceID=#URL.invoiceID##Variables.redirectVars#&confirm_invoice=#Variables.confirm_invoice#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formAction = "index.cfm?method=invoice.#Variables.doAction#&invoiceID=#URL.invoiceID#&productID=#URL.productID#">
<cfif URL.invoiceLineItemID is not 0>
	<cfset Variables.formAction = Variables.formAction & "&invoiceLineItemID=#URL.invoiceLineItemID#">
</cfif>

<cfif Variables.doAction is "insertInvoiceLineItem">
	<cfset Variables.formSubmitValue = Variables.lang_insertInvoiceLineItem.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formSubmitValue = Variables.lang_insertInvoiceLineItem.formSubmitValue_update>
</cfif>

<cfset Variables.formName = "insertInvoiceLineItem">
<cfinclude template="../../view/v_invoice/form_insertInvoiceLineItem.cfm">
