<cfif ListFind("category,price,product", URL.control)>
	<cfoutput>
	<div class="SubNav">
	<span class="SubNavTitle">Custom Pricing: </span>
	<cfswitch expression="#URL.control#">
	<cfcase value="price">Price Applies to All Products On Invoice For Designated Targets</cfcase>
	<cfcase value="product">Price Applies to Product For Designated Targets</cfcase>
	<cfcase value="category">Price Applies to All Products In Category For Designated Targets</cfcase>
	</cfswitch>
	<br>
	<cfif Application.fn_IsUserAuthorized("listPrices")><a href="index.cfm?method=#URL.control#.listPrices#Variables.urlParameters#" title="List existing custom prices" class="SubNavLink<cfif Variables.doAction is "listPrices">On</cfif>">List Existing Custom Prices</a></cfif>
	<cfif Application.fn_IsUserAuthorized("insertPrice")> | <a href="index.cfm?method=#URL.control#.insertPrice#Variables.urlParameters#" title="Create new custom price" class="SubNavLink<cfif Variables.doAction is "insertPrice">On</cfif>">Create New Custom Price</a></cfif>
	<cfif URL.priceID is not 0>
		<br><img src="#Application.billingUrlRoot#/images/grayline.jpg" width="100%" height="1" vspace="3" alt="" border="0"><br>
		<span class="SubNavObject">Price Name:</span> <span class="SubNavName"><cfif qry_selectPrice.priceID_custom is not "">#qry_selectPrice.priceID_custom#. </cfif><cfif qry_selectPrice.priceName is "">(no name)<cfelse>#qry_selectPrice.priceName#</cfif></span><br>
		<cfif Application.fn_IsUserAuthorized("viewPrice")><a href="#Replace(Variables.navPriceAction, Variables.doAction, "viewPrice", "ONE")#" title="View custom price options" class="SubNavLink<cfif Variables.doAction is "viewPrice">On</cfif>">View</a></cfif>
		<cfif Application.fn_IsUserAuthorized("updatePrice")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "updatePrice", "ONE")#" title="Update custom price (archives this custom price and creates new version)" class="SubNavLink<cfif Variables.doAction is "updatePrice">On</cfif>">Update</a></cfif>
		<cfif Application.fn_IsUserAuthorized("listInvoices")> | <a href="#Replace(Variables.navPriceAction, URL.method, "price.listInvoices", "ONE")#" title="List invoices with at least one line item that uses this custom price" class="SubNavLink<cfif Variables.doAction is "listInvoices">On</cfif>">List Existing Invoices</a></cfif>
		<cfif Application.fn_IsUserAuthorized("listSubscribers")> | <a href="#Replace(Variables.navPriceAction, URL.method, "price.listSubscribers", "ONE")#" title="List subscribers that have at least one subscription that uses this custom price" class="SubNavLink<cfif Variables.doAction is "listSubscribers">On</cfif>">List Existing Subscribers</a></cfif>
		<cfif Application.fn_IsUserAuthorized("listPriceTargets")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "listPriceTargets", "ONE")#" title="List existing targets eligible to use this custom price (company, user, affiliate and/or cobrand)" class="SubNavLink<cfif Variables.doAction is "listPriceTargets">On</cfif>">List Existing Targets</a></cfif>
		<cfif Application.fn_IsUserAuthorized("insertPriceTargetCompany") or Application.fn_IsUserAuthorized("insertPriceTargetGroup") or Application.fn_IsUserAuthorized("insertPriceTargetUser") or Application.fn_IsUserAuthorized("insertPriceTargetCobrand") or Application.fn_IsUserAuthorized("insertPriceTargetAffiliate") or Application.fn_IsUserAuthorized("insertPriceTargetRegion")>
			<br><i>Add New Target</i>: 
			<cfif Application.fn_IsUserAuthorized("insertPriceTargetCompany")><a href="#Replace(Variables.navPriceAction, Variables.doAction, "insertPriceTargetCompany", "ONE")#" title="Select customer companies that are eligible to use this custom price" class="SubNavLink<cfif Variables.doAction is "insertPriceTargetCompany">On</cfif>">Company</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertPriceTargetGroup")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "insertPriceTargetGroup", "ONE")#" title="Select groups whose members are eligible to use this custom price" class="SubNavLink<cfif Variables.doAction is "insertPriceTargetGroup">On</cfif>">Group</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertPriceTargetUser")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "insertPriceTargetUser", "ONE")#" title="Select customer users that are eligible to use this custom price" class="SubNavLink<cfif Variables.doAction is "insertPriceTargetUser">On</cfif>">User</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertPriceTargetCobrand")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "insertPriceTargetCobrand", "ONE")#" title="Select cobrands(s) whose customers are eligible to use this custom price" class="SubNavLink<cfif Variables.doAction is "insertPriceTargetCobrand">On</cfif>">Cobrand</a></cfif>
			<cfif Application.fn_IsUserAuthorized("insertPriceTargetAffiliate")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "insertPriceTargetAffiliate", "ONE")#" title="Select affiliates whose customers are eligible to use this custom price" class="SubNavLink<cfif Variables.doAction is "insertPriceTargetAffiliate">On</cfif>">Affiliate</a></cfif>
			<!--- <cfif Application.fn_IsUserAuthorized("insertPriceTargetRegion")> | <a href="#Replace(Variables.navPriceAction, Variables.doAction, "insertPriceTargetRegion", "ONE")#" title="Select regions in which this price applies" class="SubNavLink<cfif Variables.doAction is "insertPriceTargetRegion">On</cfif>">Region</a></cfif> --->
		</cfif>
	</cfif>
	</div><br>
	</cfoutput>
</cfif>
