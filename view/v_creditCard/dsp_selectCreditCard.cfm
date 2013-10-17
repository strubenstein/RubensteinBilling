<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Credit Card Status: </td>
	<td><cfif qry_selectCreditCard.creditCardStatus is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<tr>
	<td>Name on Card: </td>
	<td>#qry_selectCreditCard.creditCardName#</td>
</tr>
<tr>
	<td>Card Type: </td>
	<td>#qry_selectCreditCard.creditCardType#</td>
</tr>
<tr>
	<td>Card Number: </td>
	<td>#qry_selectCreditCard.creditCardNumber#</td>
</tr>
<tr>
	<td>Card Expiration: </td>
	<td>#qry_selectCreditCard.creditCardExpirationMonth#/#qry_selectCreditCard.creditCardExpirationYear#</td>
</tr>
<tr>
	<td>CVC ##: </td>
	<td>#qry_selectCreditCard.creditCardCVC# <cfif qry_selectCreditCard.creditCardCVC is 0>(CVC rejected)<cfelseif qry_selectCreditCard.creditCardCVC is 1>(CVC accepted)</cfif></td>
</tr>
<tr>
	<td>Retain CC Info: </td>
	<td>
		<cfif qry_selectCreditCard.creditCardRetain is 0>
			No -- Credit card information should be deleted after being processed
		<cfelse>
			Yes -- Continue to store credit card information
		</cfif>
	</td>
</tr>

<cfif qry_selectCreditCard.addressID is not 0>
	<tr><td colspan="2"><br><b>Billing Address:</b></td></tr>
	<tr>
		<td>Address Status: </td>
		<td><cfif qry_selectCreditCard.addressStatus is 1>Active<cfelse>Inactive</cfif></td>
	</tr>
	<tr>
		<td>Address Dates Valid: </td>
		<td>
			#DateFormat(qry_selectCreditCard.addressDateCreated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCreditCard.addressDateCreated, "hh:mm tt")# thru 
			<cfif qry_selectCreditCard.addressStatus is 1>
				Present
			<cfelse>
				#DateFormat(qry_selectCreditCard.addressDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectCreditCard.addressDateUpdated, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<cfif qry_selectCreditCard.addressName is not "">
		<tr>
			<td>Reference/Contact Name: </td>
			<td>#qry_selectCreditCard.addressName#</td>
		</tr>
	</cfif>
	<cfif qry_selectCreditCard.addressDescription is not "">
		<tr valign="top">
			<td>Address Description: </td>
			<td>#qry_selectCreditCard.addressDescription#</td>
		</tr>
	</cfif>
	<tr>
		<td>Address Type:</td>
		<td>
			<cfswitch expression="#qry_selectCreditCard.addressTypeShipping#:#qry_selectCreditCard.addressTypeBilling#">
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
			#qry_selectCreditCard.address#
			<cfif qry_selectCreditCard.address2 is not ""><br>#qry_selectCreditCard.address2#</cfif>
			<cfif qry_selectCreditCard.address3 is not ""><br>#qry_selectCreditCard.address3#</cfif>
		</td>
	</tr>
	<tr>
		<td>City: </td>
		<td>#qry_selectCreditCard.city#</td>
	</tr>
	<tr>
		<td>State/Province: </td>
		<td>#qry_selectCreditCard.state#</td>
	</tr>
	<tr>
		<td>Zip/Postal Code: </td>
		<td>#qry_selectCreditCard.zipCode#<cfif qry_selectCreditCard.zipCodePlus4 is not "">-#qry_selectCreditCard.zipCodePlus4#</cfif></td>
	</tr>
	<cfif qry_selectCreditCard.county is not "">
		<tr>
			<td>County: </td>
			<td>#qry_selectCreditCard.county#</td>
		</tr>
	</cfif>
	<tr>
		<td>Country: </td>
		<td>qry_selectCreditCard.country</td>
	</tr>
</cfif>
</table>
</cfoutput>