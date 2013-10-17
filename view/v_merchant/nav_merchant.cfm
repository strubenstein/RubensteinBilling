<cfoutput>
<div class="SubNav">
<span class="SubNavTitle">Merchant Accounts: </span>
<cfif Application.fn_IsUserAuthorized("listMerchants")><a href="index.cfm?method=merchant.listMerchants" title="List existing merchant processors" class="SubNavLink<cfif Variables.doAction is "listMerchants">On</cfif>">List Existing Merchant Processors</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertMerchant")> | <a href="index.cfm?method=merchant.insertMerchant" title="Add new merchant processor" class="SubNavLink<cfif Variables.doAction is "insertMerchant">On</cfif>">Add New Merchant Processor</a> | </cfif>
<cfif Application.fn_IsUserAuthorized("listMerchantAccounts")><a href="index.cfm?method=merchant.listMerchantAccounts" title="List existing merchant accounts for your company" class="SubNavLink<cfif Variables.doAction is "listMerchantAccounts">On</cfif>">List Existing Merchant Accounts</a></cfif>
<cfif Application.fn_IsUserAuthorized("insertMerchantAccount")> | <a href="index.cfm?method=merchant.insertMerchantAccount" title="Add new merchant account for your company" class="SubNavLink<cfif Variables.doAction is "insertMerchantAccount">On</cfif>">Add New Merchant Account</a></cfif>
</div><br>
</cfoutput>
