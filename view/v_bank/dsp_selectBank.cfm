<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr><td colspan="2"><b>Bank Account Information</b></td></tr>
<tr>
	<td>Bank Status: </td>
	<td><cfif qry_selectBank.bankStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<tr>
	<td>Retain Bank Info: </td>
	<td>
		<cfif qry_selectBank.bankRetain is 0>
			No -- Bank information should be deleted after being processed
		<cfelse>
			Yes -- Continue to store bank information
		</cfif>
	</td>
</tr>
<tr>
	<td>Optional Description: </td>
	<td>#qry_selectBank.bankDescription#</td>
</tr>
<tr>
	<td>Name of Bank: </td>
	<td>#qry_selectBank.bankName#</td>
</tr>
<tr>
	<td>Name on Account: </td>
	<td>#qry_selectBank.bankAccountName#</td>
</tr>
<tr>
	<td>Account Ownership: </td>
	<td><cfif qry_selectBank.bankPersonalOrCorporate is 1>Corporate<cfelse>Personal</cfif></td>
</tr>
<tr>
	<td>Routing ##: </td>
	<td>#qry_selectBank.bankRoutingNumber#</td>
</tr>
<tr>
	<td>Account ##: </td>
	<td>#qry_selectBank.bankAccountNumber#</td>
</tr>
<tr>
	<td>Account Type: </td>
	<td>
		<cfswitch expression="#qry_selectBank.bankCheckingOrSavings#">
		<cfcase value="0">Checking</cfcase>
		<cfcase value="1">Savings</cfcase>
		<cfdefaultcase>Other: #qry_selectBank.bankAccountType#</cfdefaultcase>
		</cfswitch>
	</td>
</tr>

<cfif qry_selectBank.addressID is not 0>
	<tr><td colspan="2"><br><b>Account Address</b></td></tr>
	<tr>
		<td>Address Status: </td>
		<td><cfif qry_selectBank.addressStatus is 1>Active<cfelse>Inactive</cfif></td>
	</tr>
	<tr>
		<td>Address Dates Valid: </td>
		<td>
			#DateFormat(qry_selectBank.addressDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectBank.addressDateCreated, "hh:mm tt")# thru 
			<cfif qry_selectBank.addressStatus is 1>
				Present
			<cfelse>
				#DateFormat(qry_selectBank.addressDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectBank.addressDateUpdated, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<cfif qry_selectBank.addressName is not "">
		<tr>
			<td>Reference/Contact Name: </td>
			<td>#qry_selectBank.addressName#</td>
		</tr>
	</cfif>
	<cfif qry_selectBank.addressDescription is not "">
		<tr valign="top">
			<td>Address Description: </td>
			<td>#qry_selectBank.addressDescription#</td>
		</tr>
	</cfif>
	<tr>
		<td>Address Type:</td>
		<td>
			<cfswitch expression="#qry_selectBank.addressTypeShipping#:#qry_selectBank.addressTypeBilling#">
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
			#qry_selectBank.address#
			<cfif qry_selectBank.address2 is not ""><br>#qry_selectBank.address2#</cfif>
			<cfif qry_selectBank.address3 is not ""><br>#qry_selectBank.address3#</cfif>
		</td>
	</tr>
	<tr>
		<td>City: </td>
		<td>#qry_selectBank.city#</td>
	</tr>
	<tr>
		<td>State/Province: </td>
		<td>#qry_selectBank.state#</td>
	</tr>
	<tr>
		<td>Zip/Postal Code: </td>
		<td>#qry_selectBank.zipCode#<cfif qry_selectBank.zipCodePlus4 is not "">-#qry_selectBank.zipCodePlus4#</cfif></td>
	</tr>
	<cfif qry_selectBank.county is not "">
		<tr>
			<td>County: </td>
			<td>#qry_selectBank.county#</td>
		</tr>
	</cfif>
	<tr>
		<td>Country: </td>
		<td>qry_selectBank.country</td>
	</tr>
</cfif>

<tr><td colspan="2"><br><b>Bank Branch Information</b></td></tr>
<tr>
	<td>Branch Name: </td>
	<td>#qry_selectBank.bankBranch#</td>
</tr>
<tr>
	<td>City: </td>
	<td>#qry_selectBank.bankBranchCity#</td>
</tr>
<tr>
	<td>State/Province: </td>
	<td>#qry_selectBank.bankBranchState#</td>
</tr>
<tr>
	<td>Country: </td>
	<td>#qry_selectBank.bankBranchCountry#</td>
</tr>
<tr>
	<td>Contact Person: </td>
	<td>#qry_selectBank.bankBranchContactName#</td>
</tr>
<tr>
	<td>Phone: </td>
	<td>#qry_selectBank.bankBranchPhone#</td>
</tr>
<tr>
	<td>Fax: </td>
	<td>#qry_selectBank.bankBranchFax#</td>
</tr>
</table>
</cfoutput>