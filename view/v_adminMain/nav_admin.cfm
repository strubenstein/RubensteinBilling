<cfoutput>
<cfscript>
function fn_tabNav (urlControl, navControl, navText, navAction, navTitle)
{
	var tabClass = "NormalTab";
	if (navControl is urlControl and (navControl is not "admin" or navAction is URL.action))
		tabClass = "SelectedTab";
	else if (navControl is "payment" and urlControl is "paymentCredit")
		tabClass = "SelectedTab";
	else if (navAction is "setup" and ListFind("payflow,template,price,commission,group,status,customField,image,category,merchant,paymentCategory,export,IPaddress,contactTemplate,contactTopic,content,scheduler,permission,primaryTarget", urlControl))
		tabClass = "SelectedTab";

	return "<td><img src=""#Application.billingUrlRoot#/images/clearpixel.gif"" height=1 width=1></td>"
		& "<td class=""#tabClass#"" valign=top align=left height=26><img src=""#Application.billingUrlRoot#/images/left_arc.gif"" height=5 width=5 border=0></td>"
		& "<td class=""#tabClass#"" valign=center align=middle height=26 nowrap><a class=""#tabClass#"" title=""#HTMLEditFormat(navTitle)#"" href=""index.cfm?method=#navControl#.#navAction#"">#navText#</a></td>"
		& "<td class=""#tabClass#"" valign=top align=left><img src=""#Application.billingUrlRoot#/images/right_arc.gif"" height=5 width=5 border=0></td>";
}
</cfscript>

<table border="0" cellspacing="0" cellpadding="0">
<form method="get" action="">
<tr valign="bottom">
	<td class="MainText">
		<cfif Session.companyDirectory is "" and FileExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & "header_admin.cfm")>
			<cfinclude template="../../#Application.billingCustomerDirectoryInclude#header_admin.cfm">
		<cfelseif Session.companyDirectory is not "" and FileExists(Application.billingCustomerDirectoryPath & Application.billingFilePathSlash & Session.companyDirectory & Application.billingFilePathSlash & "header_admin.cfm")>
			<cfinclude template="../../#Application.billingCustomerDirectoryInclude##Session.companyDirectory#/header_admin.cfm">
		<cfelse>
			<div style="font-family: Arial, Helvetica, sans-serif; font-size: 20px; font-weight: bold; color: 784397">Billing</div>
		</cfif>
	</td>
	<td class="TableText" align="right">
		&nbsp; &nbsp; 
		<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("listCategories,listPrices,listGroups,listAffiliates,listCobrands,listVendors,listSalesCommissions,listNewsletters")>
		<cfif Variables.permissionActionList is not "">
			<select name="method" size="1" class="TableText" onChange="window.open(this.options[this.selectedIndex].value,'_main')">
			<option value="">-- Other Features --</option>
			<cfif ListFind(Variables.permissionActionList, "listCategories")><option value="index.cfm?method=category.listCategories"<cfif URL.control is "category"> selected class="NavSelectOn"</cfif>>Product Categories</option></cfif>
			<cfif ListFind(Variables.permissionActionList, "listGroups")><option value="index.cfm?method=group.listGroups"<cfif URL.control is "group"> selected class="NavSelectOn"</cfif>>Groups</option></cfif>
			<cfif ListFind(Variables.permissionActionList, "listAffiliates")><option value="index.cfm?method=affiliate.listAffiliates"<cfif URL.control is "affiliate"> selected class="NavSelectOn"</cfif>>Affiliates</option></cfif>
			<cfif ListFind(Variables.permissionActionList, "listCobrands")><option value="index.cfm?method=cobrand.listCobrands"<cfif URL.control is "cobrand"> selected class="NavSelectOn"</cfif>>Cobrands</option></cfif>
			<cfif ListFind(Variables.permissionActionList, "listVendors")><option value="index.cfm?method=vendor.listVendors"<cfif URL.control is "vendor"> selected class="NavSelectOn"</cfif>>Vendors</option></cfif>
			<cfif ListFind(Variables.permissionActionList, "listNewsletters")><option value="index.cfm?method=newsletter.listNewsletters"<cfif URL.control is "newsletter"> selected class="NavSelectOn"</cfif>>Newsletter</option></cfif>
			</select>
			&nbsp; &nbsp; &nbsp;
		</cfif>
		<!--- <a href="index.cfm?method=admin.main" class="plainlink">Help</a> | --->
		<a href="index.cfm?method=user.updateUser&userID=#Session.userID#" title="Manage your own user information" class="plainlink">My User Info</a> | 
		<a href="mailto:support@agreedis.org" title="Contact Support" class="plainlink">Support</a> | 
		<a href="index.cfm?method=admin.main&logout=True" title="End this session of Billing Admin" class="plainlink">Logout</a> | 
	</td>
	<td class="TableText"><cfinclude template="dsp_recentPages.cfm"></td>
</tr>
</form>
<tr valign="bottom" height="35">
	<td colspan="4">
		<table border="0" cellspacing="0" cellpadding="0"><tr>
		<td><img src="#Application.billingUrlRoot#/images/clearpixel.gif" height=1 width=1></td>
		#fn_tabNav(URL.control, "admin", "Home", "main", "Billing Admin Homepage")#
		<cfif Application.fn_IsUserAuthorized("listInvoices")>#fn_tabNav(URL.control, "invoice", "Invoices", "listInvoices", "List invoices")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listSubscribers")>#fn_tabNav(URL.control, "subscription", "Subscriptions", "listSubscribers", "List subscribers (companies that have product subscriptions)")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listPayments")>
			#fn_tabNav(URL.control, "payment", "Payments", "listPayments", "List customer payments, refunds and payment credits, including scheduled transactions")#
		<cfelseif Application.fn_IsUserAuthorized("listPaymentRefunds")>
			#fn_tabNav(URL.control, "payment", "Payments", "listPaymentRefunds", "List customer refunds, including scheduled refunds")#
		<cfelseif Application.fn_IsUserAuthorized("listPaymentCredits")>
			#fn_tabNav(URL.control, "paymentCredit", "Payments", "listPaymentCredits", "List payment credits")#
		</cfif>
		<cfif Application.fn_IsUserAuthorized("listSalesCommissions")>#fn_tabNav(URL.control, "salesCommission", "Sales Commissions", "listSalesCommissions", "List sales commissions calculated for salespeople and partners")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listProducts")>#fn_tabNav(URL.control, "product", "Products", "listProducts", "List products offered by your company")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listCompanies")>#fn_tabNav(URL.control, "company", "Companies", "listCompanies", "List companies, including your own company, customers and partners")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listUsers")>#fn_tabNav(URL.control, "user", "Users", "listUsers", "List users, including your employees and customer/partner contacts")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listTasks")>#fn_tabNav(URL.control, "task", "Tasks", "listTasks", "List all scheduled tasks")#</cfif>
		<cfif Application.fn_IsUserAuthorized("listContacts")>#fn_tabNav(URL.control, "contact", "Contact Mgmt", "listContacts", "List messages sent via admin or submitted by customers")#</cfif>
		<cfif StructKeyExists(Session, "isSetupPermission") and Session.isSetupPermission is True>#fn_tabNav(URL.control, "admin", "Setup", "setup", "Setup Options")#</cfif>
		</tr></table>
	</td>
</tr>
</table>
</cfoutput>
