<cfoutput>
<p class="ErrorMessage">More than one subscriber has the ID or code you entered. Please select the correct subscriber:<br>
<table border="1" cellspacing="0" cellpadding="4" class="TableText">
<tr valign="bottom" class="TableHeader">
	<th>ID</th>
	<th>Custom ID</th>
	<th align="left">Subscriber Name</th>
	<th align="left">Company Name</th>
	<th align="left">Contact Name</th>
</tr>
<cfloop Query="qry_viewSubscriberByID">
	<tr valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td>#qry_viewSubscriberByID.subscriberID#</td>
	<td><cfif qry_viewSubscriberByID.subscriberID_custom is "">&nbsp;<cfelse>#qry_viewSubscriberByID.subscriberID_custom#</cfif></td>
	<td><a href="index.cfm?method=subscription.viewSubscriber&subscriberID=#qry_viewSubscriberByID.subscriberID#" class="plainlink">#qry_viewSubscriberByID.subscriberName#</a></td>
	<td><cfif qry_viewSubscriberByID.companyName is "">&nbsp;<cfelse>#qry_viewSubscriberByID.companyName#</cfif></td>
	<td>#qry_viewSubscriberByID.lastName#<cfif qry_viewSubscriberByID.firstName is not "">, #qry_viewSubscriberByID.firstName#</cfif>&nbsp;</td>
	</tr>
</cfloop>
</table>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
