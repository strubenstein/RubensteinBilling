<cfoutput>
<p class="ErrorMessage">More than one invoice has the ID you entered. Please select the correct invoice:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th>Date Created</th>
	<th align="left">Company Name</th>
	<th align="left">Subscriber Name</th>
	<th align="left">Last/First Name</th>
</tr>
<cfloop Query="qry_viewInvoiceByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td><a href="index.cfm?method=#URL.control#.viewInvoice&invoiceID=#qry_viewInvoiceByID.invoiceID#" class="plainlink">#qry_viewInvoiceByID.invoiceID#</a></td>
	<td><cfif qry_viewInvoiceByID.invoiceID_custom is "">&nbsp;<cfelse>#qry_viewInvoiceByID.invoiceID_custom#</cfif></td>
	<td><cfif qry_viewInvoiceByID.companyName is "">&nbsp;<cfelse>#qry_viewInvoiceByID.companyName#</cfif></td>
	<td><cfif qry_viewInvoiceByID.subscriberName is "">&nbsp;<cfelse>#qry_viewInvoiceByID.subscriberName#</cfif></td>
	<td>#DateFormat(qry_viewInvoiceByID.invoiceDateCreated, "mm-dd-yy")#</td>
	<td>#qry_viewInvoiceByID.lastName#<cfif qry_viewInvoiceByID.firstName is not "">, #qry_viewInvoiceByID.firstName#</cfif>&nbsp;</td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
