<!--- regionID --->
<cfoutput>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td><cfif qry_selectAddress.addressStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<tr>
	<td>Dates Valid: </td>
	<td>
		#DateFormat(qry_selectAddress.addressDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectAddress.addressDateCreated, "hh:mm tt")# thru 
		<cfif qry_selectAddress.addressStatus is 1>
			Present
		<cfelse>
			#DateFormat(qry_selectAddress.addressDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectAddress.addressDateUpdated, "hh:mm tt")#
		</cfif>
	</td>
</tr>
<tr><td>&nbsp;</td></tr>
<cfif qry_selectAddress.addressName is not "">
	<tr>
		<td>Contact Name (Attn): </td>
		<td>#qry_selectAddress.addressName#</td>
	</tr>
</cfif>
<cfif qry_selectAddress.addressDescription is not "">
	<tr valign="top">
		<td>Description: </td>
		<td>#qry_selectAddress.addressDescription#</td>
	</tr>
</cfif>
<tr>
	<td>Address Type:</td>
	<td>
		<cfswitch expression="#qry_selectAddress.addressTypeShipping#:#qry_selectAddress.addressTypeBilling#">
		<cfcase value="1:1">Shipping and Billing</cfcase>
		<cfcase value="1:0">Shipping</cfcase>
		<cfcase value="0:1">Billing</cfcase>
		<cfdefaultcase><!--- 0:0 --->(none specified)</cfdefaultcase>
		</cfswitch>
	</td>
</tr>
<tr valign="top">
	<td>Street Address: </td>
	<td>
		#qry_selectAddress.address#
		<cfif qry_selectAddress.address2 is not ""><br>#qry_selectAddress.address2#</cfif>
		<cfif qry_selectAddress.address3 is not ""><br>#qry_selectAddress.address3#</cfif>
	</td>
</tr>
<tr>
	<td>City: </td>
	<td>#qry_selectAddress.city#</td>
</tr>
<tr>
	<td>State/Province: </td>
	<td>#qry_selectAddress.state#</td>
</tr>
<tr>
	<td>Zip/Postal Code: </td>
	<td>#qry_selectAddress.zipCode#<cfif qry_selectAddress.zipCodePlus4 is not "">-#qry_selectAddress.zipCodePlus4#</cfif></td>
</tr>
<cfif qry_selectAddress.county is not "">
	<tr>
		<td>County: </td>
		<td>#qry_selectAddress.county#</td>
	</tr>
</cfif>
<tr>
	<td>Country: </td>
	<td>#qry_selectAddress.country#</td>
</tr>
</table>
</cfoutput>