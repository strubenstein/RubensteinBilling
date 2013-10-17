<cfif URL.categoryID gt 0 and URL.productID gt 0>
	<cfset URL.error_price = "bothProductAndCategory">
	<cfset URL.categoryID = 0>
	<cfset URL.productID = 0>
	<cfset Variables.doAction = "listPrices">
<cfelseif URL.categoryID gt 0 and URL.control is not "category">
	<cfset URL.error_price = "controlCategory">
	<cfset URL.categoryID = 0>
	<cfset Variables.doAction = "listPrices">
<cfelseif URL.productID gt 0 and URL.control is not "product">
	<cfset URL.error_price = "controlProduct">
	<cfset URL.productID = 0>
	<cfset Variables.doAction = "listPrices">
</cfif>

<cfif URL.priceID is not 0>
	<cfif Not Application.fn_IsIntegerPositive(URL.priceID)>
		<cflocation url="index.cfm?method=#URL.control#.listPrices&error_price=invalidPrice" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.Price" Method="checkPricePermission" ReturnVariable="isPricePermission">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="priceID" Value="#URL.priceID#">
			<!--- 
			<cfif Variables.doAction is not "listPrices">
				<cfinvokeargument Name="productID" Value="#URL.productID#">
				<cfinvokeargument Name="categoryID" Value="#URL.categoryID#">
			</cfif>
			--->
		</cfinvoke>

		<cfif isPricePermission is False>
			<cflocation url="index.cfm?method=#URL.control#.listPrices&error_price=invalidPrice" AddToken="No">
		<cfelse>
			<cfinvoke Component="#Application.billingMapping#data.Price" Method="selectPrice" ReturnVariable="qry_selectPrice">
				<cfinvokeargument Name="priceID" Value="#URL.priceID#">
			</cfinvoke>
		</cfif>
	</cfif>
<cfelseif Not ListFind("listPrices,insertPrice", Variables.doAction)>
	<cflocation url="index.cfm?method=#URL.control#.listPrices&error_price=invalidPrice" AddToken="No">
</cfif>
