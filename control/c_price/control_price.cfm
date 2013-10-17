<!--- 
copy price for new product/category
region
how do we prioritize multiple pricing discounts for a single customer? use whichever gives best price or just one?
--->

<cfparam Name="URL.categoryID" Default="0">
<cfparam Name="URL.productID" Default="0">
<cfparam Name="URL.priceID" Default="0">
<cfparam Name="Variables.urlParameters" Default="">

<cfinclude template="security_price.cfm">

<cfif URL.priceID gt 0>
	<cfset Variables.navPriceAction = "index.cfm?" & CGI.Query_String>
	<cfif FindNoCase("confirm_price=", Variables.navPriceAction) and IsDefined("URL.confirm_price")>
		<cfset Variables.confirmPosition = ListFind(Variables.navPriceAction, "confirm_price=#URL.confirm_price#", "&")>
		<cfif Variables.confirmPosition is not 0>
			<cfset Variables.navPriceAction = ListDeleteAt(Variables.navPriceAction, Variables.confirmPosition, "&")>
		</cfif>
	</cfif>

	<cfif Not Find("priceID=", CGI.Query_String)>
		<cfset Variables.navPriceAction = navPriceAction & "&priceID=" & URL.priceID>
	</cfif>
</cfif>

<cfinclude template="../../view/v_price/nav_price.cfm">
<cfif URL.control is "price" and Variables.doAction is "insertPrice">
	<cfinclude template="../../view/v_price/header_price.cfm">
</cfif>

<cfif IsDefined("URL.confirm_price")>
	<cfinclude template="../../view/v_price/confirm_price.cfm">
</cfif>
<cfif IsDefined("URL.error_price")>
	<cfinclude template="../../view/v_price/error_price.cfm">
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listPrices">
	<cfinclude template="control_listPrices.cfm">
</cfcase>

<cfcase value="insertPrice,updatePrice">
	<cfinclude template="control_insertUpdatePrice.cfm">
</cfcase>

<cfcase value="viewPrice">
	<cfinclude template="control_viewPrice.cfm">
</cfcase>

<cfcase value="listPriceTargets">
	<cfinclude template="control_listPriceTargets.cfm">
</cfcase>

<cfcase value="listSubscribers">
	<cfset URL.productID = "">
	<cfset URL.categoryID = "">
	<cfset Variables.doControl = "subscription">
	<cfinclude template="../control.cfm">
</cfcase>

<cfcase value="updatePriceStatus">
	<cfinvoke Component="#Application.billingMapping#data.Price" Method="updatePrice" ReturnVariable="isPriceUpdated">
		<cfinvokeargument Name="priceID" Value="#URL.priceID#">
		<cfinvokeargument Name="priceStatus" Value="0">
	</cfinvoke>

	<cflocation url="index.cfm?method=#URL.control#.listPrices#Variables.urlParameters#&confirm_price=#Variables.doAction#" AddToken="No">
</cfcase>

<cfcase value="updatePriceTargetStatus0,updatePriceTargetStatus1">
	<cfinclude template="control_updatePriceTargetStatus.cfm">
</cfcase>

<cfcase value="insertPriceTargetCompany">
	<cfinclude template="control_insertPriceTargetCompany.cfm">
</cfcase>

<cfcase value="insertPriceTargetGroup">
	<cfinclude template="control_insertPriceTargetGroup.cfm">
</cfcase>

<cfcase value="insertPriceTargetUser">
	<cfinclude template="control_insertPriceTargetUser.cfm">
</cfcase>

<cfcase value="insertPriceTargetCobrand">
	<cfinclude template="control_insertPriceTargetCobrand.cfm">
</cfcase>

<cfcase value="insertPriceTargetAffiliate">
	<cfinclude template="control_insertPriceTargetAffiliate.cfm">
</cfcase>

<!--- 
<cfcase value="insertPriceTargetRegion">
	<cfinclude template="control_insertPriceTargetRegion.cfm">
</cfcase>
--->

<cfcase value="listInvoices">
	<cfset Variables.doControl = "invoice">
	<cfinclude template="../control.cfm">
</cfcase>

<cfdefaultcase>
	<cfset URL.error_price = "invalidAction">
	<cfinclude template="../../view/v_price/error_price.cfm">
</cfdefaultcase>
</cfswitch>

