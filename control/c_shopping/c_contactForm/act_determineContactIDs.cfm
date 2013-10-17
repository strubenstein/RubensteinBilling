<cfswitch expression="#GetFileFromPath(GetBaseTemplatePath())#">
<cfcase value="contactus.cfm">
	<cfset Variables.contactTopicID = 1>
	<cfset Variables.contactTemplateID = 1>
	<cfset Variables.requiredFields = ListAppend(Variables.requiredFields, "contactMessage")>

	<!--- if inquiry is about a particular product - call for quote --->
	<cfif IsDefined("URL.productID") and Application.fn_IsIntegerPositive(URL.productID)>
		<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCatalog.ShoppingCatalog" Method="selectProductLanguageVendor" ReturnVariable="qry_selectProduct">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="productID" Value="#URL.productID#">
		</cfinvoke>

		<cfif qry_selectProduct.RecordCount is 1>
			<cfset Variables.isProductCallForQuote = True>
			<cfset Variables.contactTopicID = 2>
			<cfset Variables.contactTemplateID = 2>

			<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID("productID")>
			<cfset Variables.targetID = URL.productID>
		</cfif>
	</cfif>
</cfcase>

<cfcase value="catalog.cfm">
	<cfset Variables.contactTopicID = 3>
	<cfset Variables.contactTemplateID = 3>
	<cfset Variables.customFieldName_list = "surfaceType,racingType">
	<cfset Variables.customFieldTarget_list = "userID,userID">
	<cfset Variables.requiredFields = ListAppend(Variables.requiredFields, "address,city,state,zipCode")>
</cfcase>
</cfswitch>

