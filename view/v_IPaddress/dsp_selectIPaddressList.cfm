<cfoutput>
<p class="MainText" style="width: 700">
By specifying an IP address, you are automatically restricting all use by that login type 
to the specified IP addresses and/or ranges. For instance, To limit only the IP address of 
web services requests, do NOT check the &quot;Browser Login&quot; checkbox in any IP address 
listings. As long as the &quot;Browser Login&quot; option is not checked for any IP address
listings, then there are no IP address restrictions on logging in via a browser.
</p>

<cfif qry_selectIPaddressList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no IP address restrictions for browser or web services requests.</p>
<cfelse>
	<p class="MainText"><b>Current Status -- IP address restrictions 
	<cfswitch expression="#Variables.webServiceRestricted#:#Variables.browserRestricted#">
	<cfcase value="True:True">applies to both browser and web service logins.</cfcase>
	<cfcase value="True:False">applies to web service logins only. There are no browser login restrictions.</cfcase>
	<cfcase value="False:True">applies to browser logins only. There are no web service login restrictions.</cfcase>
	<cfcase value="False:False">do not apply to either brower or web service logins.</cfcase>
	</cfswitch>
	</b></p>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.columnCount, 0, 0, 0, Variables.columnHeaderList, "", True)#
	<cfloop Query="qry_selectIPaddressList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>#qry_selectIPaddressList.IPaddress#<cfif qry_selectIPaddressList.IPaddress_max is not ""> thru #qry_selectIPaddressList.IPaddress_max#</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectIPaddressList.IPaddressBrowser is 1><font color="green">Permitted</font><cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectIPaddressList.IPaddressWebService is 1><font color="green">Permitted</font><cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectIPaddressList.IPaddressDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectIPaddressList.IPaddressDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "updateIPaddress")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=IPaddress.updateIPaddress&IPaddressID=#qry_selectIPaddressList.IPaddressID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteIPaddress")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=IPaddress.deleteIPaddress&IPaddressID=#qry_selectIPaddressList.IPaddressID#" class="plainlink" onmouseout="window.status=''; return true;" onmouseover="window.status='Verify Delete'; return true;" title="Verify Delete" onclick="return confirm('Are you sure you want to delete this IP address record?');">Delete</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
