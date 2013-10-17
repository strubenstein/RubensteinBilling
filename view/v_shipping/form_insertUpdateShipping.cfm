<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="shippingStatus" value="1"<cfif Form.shippingStatus is 1> checked</cfif>> Active</label> &nbsp;
		<label style="color: red"><input type="radio" name="shippingStatus" value="0"<cfif Form.shippingStatus is not 1> checked</cfif>> Cancelled</label>
	</td>
</tr>
<tr>
	<td>Shipping Carrier: </td>
	<td>
		<select name="shippingCarrier" size="1">
		<option value="">Other</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.shippingCarrierList_value)#">
			<option value="#HTMLEditFormat(ListGetAt(Variables.shippingCarrierList_value, count))#"<cfif Form.shippingCarrier is ListGetAt(Variables.shippingCarrierList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.shippingCarrierList_label, count))#</option>
		</cfloop>
		</select> 
		<i>Other</i>: <input type="text" name="shippingCarrierOther" value="#HTMLEditFormat(Form.shippingCarrierOther)#" size="20" maxlength="#maxlength_Shipping.shippingCarrier#">
	</td>
</tr>
<tr>
	<td>Shipping Option: </td>
	<td>
		<select name="shippingMethod" size="1">
		<option value="">Other</option>
		<cfloop Index="count" From="1" To="#ListLen(Variables.shippingMethodList_value)#">
			<option value="#HTMLEditFormat(ListGetAt(Variables.shippingMethodList_value, count))#"<cfif Form.shippingMethod is ListGetAt(Variables.shippingMethodList_value, count)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.shippingMethodList_label, count))#</option>
		</cfloop>
		</select> 
		<i>Other</i>: <input type="text" name="shippingMethodOther" value="#HTMLEditFormat(Form.shippingMethodOther)#" size="20" maxlength="#maxlength_Shipping.shippingMethod#">
	</td>
</tr>
<tr>
	<td>Tracking Number: </td>
	<td><input type="text" name="shippingTrackingNumber" value="#HTMLEditFormat(Form.shippingTrackingNumber)#" size="25" maxlength="#maxlength_Shipping.shippingTrackingNumber#"></td>
</tr>
<tr>
	<td>Weight: </td>
	<td><input type="text" name="shippingWeight" value="#HTMLEditFormat(Form.shippingWeight)#" size="10"></td>
</tr>
<tr>
	<td>Custom Instructions: </td>
	<td><input type="text" name="shippingInstructions" value="#HTMLEditFormat(Form.shippingInstructions)#" size="40" maxlength="#maxlength_Shipping.shippingInstructions#"></td>
</tr>
<tr valign="top">
	<td>Has Been Sent? </td>
	<td>
		<label><input type="checkbox" name="shippingSent" value="1"<cfif Form.shippingSent is 1> checked</cfif>> Shipment has been sent (enter optional date below)</label><br>
		#fn_FormSelectDateTime(Variables.formName, "shippingDateSent_date", Form.shippingDateSent_date, "shippingDateSent_hh", Form.shippingDateSent_hh, "shippingDateSent_mm", Form.shippingDateSent_mm, "shippingDateSent_tt", Form.shippingDateSent_tt, True)#
	</td>
</tr>
<tr valign="top">
	<td>Has Been Received? </td>
	<td>
		<label><input type="checkbox" name="shippingReceived" value="1"<cfif Form.shippingReceived is 1> checked</cfif>> Customer has received shipment (enter optional date below)</label><br>
		#fn_FormSelectDateTime(Variables.formName, "shippingDateReceived_date", Form.shippingDateReceived_date, "shippingDateReceived_hh", Form.shippingDateReceived_hh, "shippingDateReceived_mm", Form.shippingDateReceived_mm, "shippingDateReceived_tt", Form.shippingDateReceived_tt, True)#
	</td>
</tr>

<tr>
	<td></td>
	<td><input type="submit" name="submitInsertShipping" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>

</form>
</cfoutput>
