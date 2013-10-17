<cfset primaryTargetID_company = Application.fn_GetPrimaryTargetID("companyID")>

<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceTarget" ReturnVariable="qry_selectPriceTarget">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="priceTargetWithTargetInfo" Value="False">
	<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_company#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPriceTargetCompany") and IsDefined("Form.companyID")>
	<cfloop Index="loopCompanyID" List="#Form.companyID#">
		<cfif Not ListFind(ValueList(qry_selectPriceTarget.targetID), loopCompanyID)>
			<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="insertPriceTarget" ReturnVariable="isPriceTargetInserted">
				<cfinvokeargument Name="priceID" Value="#URL.priceID#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_company#">
				<cfinvokeargument Name="targetID" Value="#loopCompanyID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="priceTargetStatus" Value="1">
				<cfinvokeargument Name="priceTargetOrder" Value="0">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cfif IsDefined("Form.companyListRedirect") and Trim(Form.companyListRedirect) is not "">
		<cflocation url="#Form.companyListRedirect#&confirm_price=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.method#&priceID=#URL.priceID##Variables.urlParameters#&confirm_price=#Variables.doAction#" AddToken="No">
	</cfif>
	<!--- 
	<cfelseif URL.control is "category">
		<cflocation url="index.cfm?method=#URL.method#&categoryID=#URL.categoryID#&priceID=#URL.priceID#&confirm_price=#URL.action#" AddToken="No">
	<cfelseif URL.control is "product">
		<cflocation url="index.cfm?method=#URL.method#&productID=#URL.productID#&priceID=#URL.priceID#&confirm_price=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.method#&priceID=#URL.priceID#&confirm_price=#URL.action#" AddToken="No">
	--->
</cfif>

<cfset Form.companyID_not = ValueList(qry_selectPriceTarget.targetID)>
<cfset Variables.doControl = "company">
<cfset Variables.doAction = "listCompanies">
<cfinclude template="../control.cfm">

