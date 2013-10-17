<!--- 
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getCartTotalItemQuantity" returnVariable="Variables.cartTotalItemQuantity" />
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalInCart" returnVariable="Variables.cartTotalPrice" />
--->
<cfset Variables.thisFile = GetFileFromPath(GetBaseTemplatePath())>

<cfinclude template="../../view/v_shopping/var_pageTitle.cfm">
<cfinclude template="../../c/header_site.cfm">
<cfif Not IsDefined("URL.showNavigation") or URL.showNavigation is not False>
	<cfinclude template="../../c/nav_site.cfm">
</cfif>

<!--- 
<cfif FileExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Session.companyDirectory & Application.billingFilePathSlash & "header_site.cfm")>
	<cfinclude template="../../#Application.billingCustomerDirectoryInclude##Session.companyDirectory#/header_site.cfm">
<cfelse>
	<!--- <cfinclude template="../../view/v_shopping/header_site.cfm"> --->
	<cfinclude template="../../#Application.billingCustomerDirectoryInclude#/header_site.cfm">
</cfif>

<cfparam Name="Variables.navHighlight" Default="">

<cfif Not IsDefined("URL.showNavigation") or URL.showNavigation is not False>
	<cfif FileExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Session.companyDirectory & Application.billingFilePathSlash & "nav_site.cfm")>
		<cfinclude template="../../#Application.billingCustomerDirectoryInclude##Session.companyDirectory#/nav_site.cfm">
	<cfelse>
		<cfinclude template="../../#Application.billingCustomerDirectoryInclude#/nav_site.cfm">
		<!--- <cfinclude template="../../view/v_shopping/nav_site.cfm"> --->
	</cfif>
</cfif>
--->

<cfif IsDefined("URL.confirm_shopping")>
	<cfinclude template="../../view/v_shopping/confirm_shopping.cfm">
</cfif>

