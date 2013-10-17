<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="selectProductLanguage" ReturnVariable="qry_selectProductLanguage">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="languageID" Value="">
	<cfinvokeargument Name="productLanguageStatus" Value="1">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#data.ProductLanguage" method="maxlength_ProductLanguage" returnVariable="maxlength_ProductLanguage" />
<cfinclude template="formParam_insertProductLanguage.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitProductLanguage")>
	<cfinclude template="../../view/v_product/lang_insertProductLanguage.cfm">
	<cfinclude template="formValidate_insertProductLanguage.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="insertProductLanguage" ReturnVariable="isProductLanguage">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
			<cfinvokeargument Name="languageID" Value="">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="productLanguageName" Value="#Form.productLanguageName#">
			<cfinvokeargument Name="productLanguageLineItemName" Value="#Form.productLanguageLineItemName#">
			<cfinvokeargument Name="productLanguageLineItemDescription" Value="#Form.productLanguageLineItemDescription#">
			<cfinvokeargument Name="productLanguageLineItemDescriptionHtml" Value="#Form.productLanguageLineItemDescriptionHtml#">
			<cfinvokeargument Name="productLanguageSummaryHtml" Value="#Form.productLanguageSummaryHtml#">
			<cfinvokeargument Name="productLanguageSummary" Value="#Form.productLanguageSummary#">
			<cfinvokeargument Name="productLanguageDescription" Value="#Form.productLanguageDescription#">
			<cfinvokeargument Name="productLanguageDescriptionHtml" Value="#Form.productLanguageDescriptionHtml#">
		</cfinvoke>

		<cflocation url="index.cfm?method=product.insertProductLanguage&productID=#URL.productID#&confirm_product=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfinclude template="../../view/v_product/form_insertProductLanguage.cfm">
