<cfoutput>
<cfif qry_selectAddressList.RecordCount is 0>
	<p class="ErrorMessage">This <cfif URL.userID is not 0>user<cfelse>company</cfif> has no listed addresses.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.addressColumnCount, 0, 0, 0, Variables.addressColumnList, "", True)#
	<cfloop Query="qry_selectAddressList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td><cfif qry_selectAddressList.addressName is "">&nbsp;<cfelse>#qry_selectAddressList.addressName#</cfif></td>
		<td>&nbsp;</td>
		<td>#qry_selectAddressList.addressVersion#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectAddressList.userID is 0>Company<cfelseif Variables.doControl is "user">User<cfelse>#qry_selectAddressList.firstName# #qry_selectAddressList.lastName#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectAddressList.addressTypeBilling is 1>
				Yes<cfif ListFind(Variables.permissionActionList, "updateAddressTypeBilling0")><div class="SmallText"><a href="#Variables.addressActionTypeBillingNo#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Disable for<br>Billing</a></div></cfif>
			<cfelse>
				No<cfif ListFind(Variables.permissionActionList, "updateAddressTypeBilling1")><div class="SmallText"><a href="#Variables.addressActionTypeBillingYes#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Enable for<br>Billing</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectAddressList.addressTypeShipping is 1>
				Yes<cfif ListFind(Variables.permissionActionList, "updateAddressTypeShipping0")><div class="SmallText"><a href="#Variables.addressActionTypeShippingNo#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Disable for<br>Shipping</a></div></cfif>
			<cfelse>
				No<cfif ListFind(Variables.permissionActionList, "updateAddressTypeShipping1")><div class="SmallText"><a href="#Variables.addressActionTypeShippingYes#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Enable for<br>Shipping</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectAddressList.addressStatus is 1>
				<font color="green">Active</font><cfif ListFind(Variables.permissionActionList, "updateAddressStatus0")><div class="SmallText"><a href="#Variables.addressActionStatusArchived#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Change to<br>Archived</a></div></cfif>
			<cfelse>
				<font color="red">Archived</font><cfif ListFind(Variables.permissionActionList, "updateAddressStatus1")><div class="SmallText"><a href="#Variables.addressActionStatusActive#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Change to<br>Active</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectAddressList.city is "">&nbsp;<cfelse>#qry_selectAddressList.city#</cfif>
			<cfif qry_selectAddressList.state is "">&nbsp;<cfelse><cfif qry_selectAddressList.city is "">, </cfif>#qry_selectAddressList.state#</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectAddressList.addressDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectAddressList.addressDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "insertAddress")>
			<td>&nbsp;</td>
			<td class="SmallText"><cfif qry_selectAddressList.addressStatus is 0>-<cfelse><a href="#Variables.addressActionUpdate#&addressID=#qry_selectAddressList.addressID#" class="plainlink">Update</a></cfif></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "viewAddress")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="#Variables.addressActionView#&addressID=#qry_selectAddressList.addressID#" class="plainlink">View</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
