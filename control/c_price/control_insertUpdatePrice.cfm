<cfif Variables.doAction is "updatePrice">
	<cfinvoke Component="#Application.billingMapping#data.PriceVolumeDiscount" Method="selectPriceVolumeDiscount" ReturnVariable="qry_selectPriceVolumeDiscount">
		<cfinvokeargument Name="priceStageID" Value="#ValueList(qry_selectPrice.priceStageID)#">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectSubscriptionPriceCount" ReturnVariable="subscriptionCount">
		<cfinvokeargument Name="priceID" Value="#URL.priceID#">
		<cfinvokeargument Name="subscriptionStatus" Value="1">
		<cfinvokeargument Name="subscriberStatus" Value="1">
	</cfinvoke>

	<cfif subscriptionCount gt 0>
		<cfset Variables.priceHasActiveSubscriptions = True>
	<cfelse>
		<cfset Variables.priceHasActiveSubscriptions = False>
	</cfif>
</cfif>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../../view/v_price/var_priceStageIntervalTypeList.cfm">
<cfinclude template="formParam_insertUpdatePrice.cfm">
<cfinvoke component="#Application.billingMapping#data.Price" method="maxlength_Price" returnVariable="maxlength_Price" />
<cfinvoke component="#Application.billingMapping#data.Price" method="maxlength_PriceStage" returnVariable="maxlength_PriceStage" />
<cfinvoke component="#Application.billingMapping#data.PriceVolumeDiscount" method="maxlength_PriceVolumeDiscount" returnVariable="maxlength_PriceVolumeDiscount" />
<cfinclude template="../../view/v_price/lang_insertUpdatePrice.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdatePrice")>
	<cfinclude template="formValidate_insertUpdatePrice.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- generate array of structures for stages and volume discount settings --->
		<cfinclude template="act_insertUpdatePrice_struct.cfm">

		<cfif Variables.doAction is "insertPrice">
			<cfset Variables.priceID_parent = 0>
			<cfset Variables.priceID_trend = 0>
		<cfelse>
			<cfset Variables.priceID_parent = URL.priceID>
			<cfset Variables.priceID_trend = qry_selectPrice.priceID_trend>

			<cfinvoke Component="#Application.billingMapping#data.Price" Method="updatePrice" ReturnVariable="isPriceUpdated">
				<cfinvokeargument Name="priceID" Value="#Variables.priceID_parent#">
				<cfinvokeargument Name="priceStatus" Value="0">
				<cfinvokeargument Name="priceIsParent" Value="1">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Price" Method="insertPrice" ReturnVariable="priceID_new">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			<cfinvokeargument Name="priceAppliesToCategory" Value="#Iif(URL.categoryID gt 0, 1, 0)#">
			<cfinvokeargument Name="priceAppliesToCategoryChildren" Value="#Form.priceAppliesToCategoryChildren#">
			<cfinvokeargument Name="priceAppliesToProduct" Value="#Iif(URL.productID gt 0, 1, 0)#">
			<cfinvokeargument Name="priceAppliesToProductChildren" Value="#Form.priceAppliesToProductChildren#">
			<cfinvokeargument Name="priceAppliesToAllProducts" Value="#Form.priceAppliesToAllProducts#">
			<cfinvokeargument Name="priceAppliesToAllCustomers" Value="#Form.priceAppliesToAllCustomers#">
			<cfinvokeargument Name="priceAppliesToInvoice" Value="#Form.priceAppliesToInvoice#">
			<cfinvokeargument Name="priceCode" Value="#Form.priceCode#">
			<cfinvokeargument Name="priceCodeRequired" Value="#Form.priceCodeRequired#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="priceStatus" Value="#Form.priceStatus#">
			<cfinvokeargument Name="priceApproved" Value="#Form.priceApproved#">
			<cfif IsDefined("Form.priceDateApproved")>
				<cfinvokeargument Name="priceDateApproved" Value="#Form.priceDateApproved#">
			</cfif>
			<cfif IsDefined("Form.userID_approved")>
				<cfinvokeargument Name="userID_approved" Value="#Form.userID_approved#">
			</cfif>
			<cfinvokeargument Name="priceName" Value="#Form.priceName#">
			<cfinvokeargument Name="priceDescription" Value="#Form.priceDescription#">
			<cfinvokeargument Name="priceID_custom" Value="#Form.priceID_custom#">
			<cfinvokeargument Name="priceQuantityMinimumPerOrder" Value="#Iif(IsNumeric(Form.priceQuantityMinimumPerOrder), De(Form.priceQuantityMinimumPerOrder), 0)#">
			<cfinvokeargument Name="priceAppliedStatus" Value="0">
			<cfinvokeargument Name="priceQuantityMaximumAllCustomers" Value="#Iif(IsNumeric(Form.priceQuantityMaximumAllCustomers), De(Form.priceQuantityMaximumAllCustomers), 0)#">
			<cfinvokeargument Name="priceQuantityMaximumPerCustomer" Value="#Iif(IsNumeric(Form.priceQuantityMaximumPerCustomer), De(Form.priceQuantityMaximumPerCustomer), 0)#">
			<cfinvokeargument Name="priceBillingMethod" Value="#Form.priceBillingMethod#">
			<cfinvokeargument Name="priceDateBegin" Value="#Form.priceDateBegin#">
			<cfif IsDefined("Form.priceDateEnd")>
				<cfinvokeargument Name="priceDateEnd" Value="#Form.priceDateEnd#">
			</cfif>
			<cfinvokeargument Name="priceID_parent" Value="#Variables.priceID_parent#">
			<cfinvokeargument Name="priceID_trend" Value="#Variables.priceID_trend#">
			<cfinvokeargument Name="priceIsParent" Value="0">
			<cfinvokeargument Name="priceStageAmount" Value="#Variables.priceStageAmount#">
			<cfinvokeargument Name="priceStageDollarOrPercent" Value="#Variables.priceStageDollarOrPercent#">
			<cfinvokeargument Name="priceStageNewOrDeduction" Value="#Variables.priceStageNewOrDeduction#">
			<cfinvokeargument Name="priceStageVolumeDiscount" Value="#Variables.priceStageVolumeDiscount#">
			<cfinvokeargument Name="priceStageVolumeDollarOrQuantity" Value="#Variables.priceStageVolumeDollarOrQuantity#">
			<cfinvokeargument Name="priceStageVolumeStep" Value="#Variables.priceStageVolumeStep#">
			<cfinvokeargument Name="priceStageInterval" Value="#Variables.priceStageInterval#">
			<cfinvokeargument Name="priceStageIntervalType" Value="#Variables.priceStageIntervalType#">
			<cfinvokeargument Name="priceStageText" Value="#Variables.priceStageText#">
			<cfinvokeargument Name="priceStageDescription" Value="#Variables.priceStageDescription#">
			<cfinvokeargument Name="priceVolumeDiscountQuantityMinimum" Value="#Variables.priceVolumeDiscountQuantityMinimum#">
			<cfinvokeargument Name="priceVolumeDiscountAmount" Value="#Variables.priceVolumeDiscountAmount#">
			<cfinvokeargument Name="priceVolumeDiscountIsTotalPrice" Value="#Variables.priceVolumeDiscountIsTotalPrice#">
		</cfinvoke>

		<cfif Variables.doAction is "insertPrice"><!--- insert price only --->
			<cfif URL.productID is not 0 and qry_selectProduct.productHasCustomPrice is 0>
				<cfinvoke Component="#Application.billingMapping#data.Product" Method="updateProduct" ReturnVariable="isProductUpdated">
					<cfinvokeargument Name="productID" Value="#URL.productID#">
					<cfinvokeargument Name="productHasCustomPrice" Value="1">
				</cfinvoke>
			<cfelseif URL.categoryID is not 0 and qry_selectCategory.categoryHasCustomPrice is 0>
				<cfinvoke Component="#Application.billingMapping#data.Category" Method="updateCategory" ReturnVariable="isCategoryUpdated">
					<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
					<cfinvokeargument Name="categoryHasCustomPrice" Value="1">
				</cfinvoke>
			</cfif>
		<cfelse><!--- update price only --->
			<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="copyPriceTarget" ReturnVariable="isPriceTargetCopied">
				<cfinvokeargument Name="priceID_old" Value="#Variables.priceID_parent#">
				<cfinvokeargument Name="priceID_new" Value="#priceID_new#">
			</cfinvoke>
		</cfif>

		<cfif Variables.doAction is "insertPrice">
			<cflocation url="index.cfm?method=#URL.control#.listPrices#Variables.urlParameters#&confirm_price=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.control#.listPrices#Variables.urlParameters#&priceID=#priceID_new#&confirm_price=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdatePrice">
<cfif Variables.doAction is "insertPrice">
	<cfset Variables.formAction = "index.cfm?method=#URL.method#" & Variables.urlParameters>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePrice.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = "index.cfm?method=#URL.method#" & Variables.urlParameters & "&priceID=#URL.priceID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdatePrice.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_price/form_insertUpdatePrice.cfm">
<cfinclude template="../../view/v_price/footer_insertUpdatePrice.cfm">

