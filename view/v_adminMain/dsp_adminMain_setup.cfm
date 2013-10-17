<cfset Variables.bgcolorOn = False>

<cfoutput>
<br>
<div class="SubTitle">Setup Options</div>
<table border="1" cellspacing="0" cellpadding="2" class="MainText" width="800">

<cfif ListFind(Variables.permissionActionList, "listPayflows")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td nowrap><a href="index.cfm?method=payflow.listPayflows" class="plainlink">Subscription Processing Methods</a></td>
		<td>Manage the procedures used when processing subscriptions and payments.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listTemplates")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=template.listTemplates" class="plainlink">Display Templates</a></td>
		<td>Add/edit templates for displaying invoices/receipts, categories and products. (Category and product templates would apply to front-end customer site.)</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listPrices")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td nowrap><a href="index.cfm?method=price.listPrices" class="plainlink">Custom Pricing</a></td>
		<td>Manage custom prices, including volume discount options and multi-stage pricing for subscriptions. Determine which customers are eligible for a custom price. To create a custom price that applies only to a particular product or category, begin at that product or category to create the custom price. To create a custom price that applies to all products (or view all custom prices) click from here.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listCommissions")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td nowrap><a href="index.cfm?method=commission.listCommissions" class="plainlink">Sales Commission Plans</a></td>
		<td>Manage commissions plans for salespeople, affilates, cobrands, etc., including which commission plans apply to particular proudcts.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listGroups")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=group.listGroups" class="plainlink">Groups</a></td>
		<td>Add/edit groups, and assign users and companies to groups for purposes of custom pricing and assigning permissions.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listStatuses")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=status.listStatuses" class="plainlink">Custom Status</a></td>
		<td>Add/edit custom status'es for products, users, companies and invoices/purchases. Can be used to filter listings and reporting. Status changes are archived to view status history.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listCustomFields")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=customField.listCustomFields" class="plainlink">Custom Fields</a></td>
		<td>Add/edit custom fields for products, users, companies and invoices/purchases. Custom fields are used to store data about an object without adding fields to the database. (They are currently used on the Catalog request and Contact Us forms on the site.)</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
</table>
<br>
<table border="1" cellspacing="0" cellpadding="2" class="MainText" width="800">
<cfif ListFind(Variables.permissionActionList, "listImageDirectories")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=image.listImageDirectories" class="plainlink">Image Sub-Directories</a></td>
		<td>Create/delete subdirectories for uploaded images.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listCategories")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=category.listCategories" class="plainlink">Product Categories</a></td>
		<td>Add/edit product categories, add category-based custom pricing, and customized product order within category.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listMerchantAccounts")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=merchant.listMerchantAccounts" class="plainlink">Merchant Account</a></td>
		<td>Add/edit merchant accounts, i.e., the account used to process credit card and bank/ACH transactions.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listPaymentCategories")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=paymentCategory.listPaymentCategories" class="plainlink">Payment Categories</a></td>
		<td>Add/edit payment categories used to classify payments, refunds and credits.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listExportTables")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=export.listExportTables" class="plainlink">Export Options</a></td>
		<td>Customize field names and included fields for exporting queries to XML or tab-delimited files.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listIPaddresses")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=IPaddress.listIPaddresses" class="plainlink">IP Address Restrictions</a></td>
		<td>Restrict browser login and/or web services requests to designated IP addresses or IP address ranges.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listContactTemplates")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=contactTemplate.listContactTemplates" class="plainlink">Contact Management Templates</a></td>
		<td>Add/edit contact management templates. Used as templates for new emails to customers and for formatting messages submitted by customers via the site.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listContactTopics")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=contactTopic.listContactTopics" class="plainlink">Contact Management Topics</a></td>
		<td>Add/edit contact management categories used to classify messages submitted by customers via the site.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "listContentCategories")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=content.listContentCategories" class="plainlink">Content Management</a></td>
		<td>Manage content, including headers, footers, confirmation messages and emails.<br>(<i>Not all content has been added yet</i>.)</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
<cfif ListFind(Variables.permissionActionList, "insertCompany") or ListFind(Variables.permissionActionList, "insertUser") or ListFind(Variables.permissionActionList, "insertAffiliate") or ListFind(Variables.permissionActionList, "insertCobrand") or ListFind(Variables.permissionActionList, "insertVendor") or ListFind(Variables.permissionActionList, "insertProduct") or ListFind(Variables.permissionActionList, "insertInvoice") or ListFind(Variables.permissionActionList, "insertInvoiceLineItem")>
	<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
		<td><a href="index.cfm?method=import.importData" class="plainlink">Import Records</a></td>
		<td>Import initial data, including companies, users, affiliates, cobrands, vendors, products and invoices.</td>
	</tr>
	<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
</cfif>
</table>

<cfif ListFind(Variables.permissionActionList, "listMerchants") or ListFind(Variables.permissionActionList, "listSchedulers") or ListFind(Variables.permissionActionList, "listPermissionCategories") or ListFind(Variables.permissionActionList, "listPrimaryTargets") or ListFind(Variables.permissionActionList, "listLoginAttempts")>
	<br><table border="1" cellspacing="0" cellpadding="2" class="MainText" width="800">
	<cfif ListFind(Variables.permissionActionList, "listLoginAttempts")>
		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td><a href="index.cfm?method=admin.listLoginAttempts" class="plainlink">Failed Logins</a></td>
			<td>View failed login attempts from the past 24 hours and re-enable individual usernames before the 30 minute waiting period after 3 unsuccessful logins has expired.</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "listMerchants")>
		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td><a href="index.cfm?method=merchant.listMerchants" class="plainlink">Merchant Companies</a></td>
			<td>Add/edit merchant processors and merchant accounts, i.e., companies that process credit card and bank/ACH transactions. Requires existing custom code file to already exist.</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "listSchedulers")>
		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td><a href="index.cfm?method=scheduler.listSchedulers" class="plainlink">Scheduled Tasks</a></td>
			<td>Add/edit scheduled tasks.</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "listTriggerActions")>
		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td><a href="index.cfm?method=trigger.listTriggerActions" class="plainlink">Triggers</a></td>
			<td>Add/edit triggers that are automatically executed after designated actions. This enables you to run custom code after an action without editing the core files.</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "listPermissionCategories")>
		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td><a href="index.cfm?method=permission.listPermissionCategories" class="plainlink">Permissions</a></td>
			<td>Add new permissions to the system. This is <i>not</i> where permissions for users/companies/groups are assigned. This creates the permission itself, which must then be manually implemented within the code. (Please ignore.)</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
	</cfif>
	<cfif ListFind(Variables.permissionActionList, "listPrimaryTargets")>
		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td><a href="index.cfm?method=primaryTarget.listPrimaryTargets" class="plainlink">Primary Targets</a></td>
			<td>The list of system tables and primary keys. (Please ignore.)</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>

		<tr valign="top"<cfif Variables.bgcolorOn is True> bgcolor="f4f4ff"</cfif>>
			<td>Reset Application Variables</td>
			<td>
				<p>The system relies on several variables and functions stored in memory for both the admin screens and public site. These variables are automatically reset if the server is rebooted or ColdFusion is restarted.</p>
				<p>Updates to code files stored in application variables are NOT made active until the application variables are reset. They can be reset by simply calling any page with the following in the URL:</p>
				<p><i>resetApplicationVariables=True</i></p>
				<p>This must be done in both the admin screens and public site. Here are links to do both:</p>
				<a href="index.cfm?method=admin.setup&resetApplicationVariables=True" class="plainlink">Reset Admin Screens Application Variables</a> (reloads this setup page)<br>
				<a href="../index.cfm?resetApplicationVariables=True" class="plainlink" target="publicHome">Reset Public Site Application Variables</a> (loads public site homepage in new window)<br>
				<!--- <a href="../scheduled/sched_insertCategoryWeight.cfm?IamTheScheduler=True&resetCategoryWeight=True" class="plainlink" target="categoryParent">Reset Parent Weight Settings</a> (loads blank page in new window)<br> --->
			</td>
		</tr>
		<cfif Variables.bgcolorOn is True><cfset Variables.bgcolorOn = False><cfelse><cfset Variables.bgcolorOn = True></cfif>
	</cfif>
	</table>
</cfif>
</cfoutput>