<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript">
function toggle(target)
{ obj=(document.all) ? document.all[target] : document.getElementById(target);
  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
}
</script>

<cfif URL.productID is not 0 and IsDefined("qry_selectProduct.productPrice")>
	<p class="MainText"><b>Normal Price: $#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProduct.productPrice)#</b></p>
</cfif>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label><input type="radio" name="priceStatus" value="1"<cfif Form.priceStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label><input type="radio" name="priceStatus" value="0"<cfif Form.priceStatus is not 1> checked</cfif>> Not active</label>
	</td>
</tr>
--->
<tr>
	<td>Internal Name: </td>
	<td><input type="text" name="priceName" value="#HTMLEditFormat(Form.priceName)#" Size="50" Maxlength="#maxlength_Price.priceName#"> (suggested)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td><input type="text" name="priceID_custom" value="#HTMLEditFormat(Form.priceID_custom)#" Size="20" Maxlength="#maxlength_Price.priceID_custom#"> (optional; for integration purposes)</td>
</tr>
<tr>
	<td>Description: </td>
	<td><input type="text" name="priceDescription" value="#HTMLEditFormat(Form.priceDescription)#" Size="50" Maxlength="#maxlength_Price.priceDescription#"> (optional)</td>
</tr>
</table>
<br>

<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr><td colspan="2"><b>Price Applies To:</b></td></tr>
<tr>
	<td>All Customers? </td>
	<td><label><input type="checkbox" name="priceAppliesToAllCustomers" value="1"<cfif Form.priceAppliesToAllCustomers is 1> checked</cfif>> Price applies to ALL customers (otherwise, select customers on target tab)</label></td>
</tr>

<cfif URL.productID is not 0>
	<tr>
		<td>Child Products? </td>
		<td><label><input type="checkbox" name="priceAppliesToProductChildren" value="1"<cfif Form.priceAppliesToProductChildren is 1> checked</cfif>> Price applies to ALL child products of this product.</label></td>
	</tr>
<cfelseif URL.categoryID is not 0>
	<tr>
		<td>Sub Categories? </td>
		<td><label><input type="checkbox" name="priceAppliesToCategoryChildren" value="1"<cfif Form.priceAppliesToCategoryChildren is 1> checked</cfif>> Price applies to all products in ALL sub-categories of this category.</label></td>
	</tr>
<cfelse>
	<input type="hidden" name="priceAppliesToAllProductsOrInvoices" value="priceAppliesToAllProducts">
	<!--- 
	<tr valign="top">
		<td>Products or Invoice? </td>
		<td>
			<label><input type="radio" name="priceAppliesToAllProductsOrInvoices" value="priceAppliesToAllProducts"<cfif Form.priceAppliesToAllProductsOrInvoices is "priceAppliesToAllProducts"> checked</cfif>> 
			Price applies to ALL active products in ALL categories.</label><br>
			<label><input type="radio" name="priceAppliesToAllProductsOrInvoices" value="priceAppliesToInvoice"<cfif Form.priceAppliesToAllProductsOrInvoices is "priceAppliesToInvoice"> checked</cfif>> 
			Price applies to entire invoice, not to individual line items.</label> (e.g., 5% discount or $50 off if invoice total &gt; $1000.)
		</td>
	</tr>
	--->

	<!--- 
	<tr>
		<td>All Products? </td>
		<td><label><input type="checkbox" name="priceAppliesToAllProducts" value="1"<cfif Form.priceAppliesToAllProducts is 1> checked</cfif>> Price applies to ALL active products in ALL categories.</label></td>
	</tr>
	<tr>
		<td>Entire Invoice? </td>
		<td><label><input type="checkbox" name="priceAppliesToInvoice" value="1"<cfif Form.priceAppliesToInvoice is 1> checked</cfif>> Price applies to entire invoice, not to individual line items. (e.g., 5% discount or $50 off if invoice total &gt; $1000.)</label></td>
	</tr>
	--->
</cfif>

<tr>
	<td valign="top">Special Code: </td>
	<td>
		<input type="text" name="priceCode" value="#HTMLEditFormat(Form.priceCode)#" Size="25" Maxlength="#maxlength_Price.priceCode#"><br>
		<label><input type="checkbox" name="priceCodeRequired" value="1"<cfif Form.priceCode is 1> checked</cfif>> Check if customer must enter special code to receive price.</label>
	</td>
</tr>
</table>
<br>

<cfif URL.productID is not 0>
	<table border="0" cellspacing="2" cellpadding="2" class="MainText">
	<tr><td colspan="2"><b>Quantity Requirements:</b></td></tr>
	<tr>
		<td>Minimum Per Order: </td>
		<td class="TableText">
			<input type="text" name="priceQuantityMinimumPerOrder"  size="10"<cfif IsNumeric(Form.priceQuantityMinimumPerOrder)> value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form.priceQuantityMinimumPerOrder)#"</cfif>> 
			(minimum ## required to receive price)
		</td>
	</tr>
	<tr>
		<td>Maximum Per Customer: </td>
		<td class="TableText">
			<input type="text" name="priceQuantityMaximumAllCustomers"  size="10"<cfif IsNumeric(Form.priceQuantityMaximumAllCustomers)> value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form.priceQuantityMaximumAllCustomers)#"</cfif>> 
			(maximum ## each customer may purchase at this price among all purchases)
		</td>
	</tr>
	<tr>
		<td>Maximum Total: </td>
		<td class="TableText">
			<input type="text" name="priceQuantityMaximumPerCustomer"  size="10"<cfif IsNumeric(Form.priceQuantityMaximumPerCustomer)> value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form.priceQuantityMaximumPerCustomer)#"</cfif>> 
			(maximum ## available for all customers to purchase at this price)
		</td>
	</tr>
	</table>
	<br>
</cfif>

<p>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr><td colspan="2"><b>Date Range During Which Price Applies:</b></td></tr>
<tr>
	<td valign="top">Begin Date: </td>
	<td>
		#fn_FormSelectDateTime(Variables.formName, "priceDateBegin_date", Form.priceDateBegin_date, "priceDateBegin_hh", Form.priceDateBegin_hh, "priceDateBegin_mm", Form.priceDateBegin_mm, "priceDateBegin_tt", Form.priceDateBegin_tt, True)#
		 (required)<br>
		<label><input type="checkbox" name="priceDateBegin_now" value="1"<cfif Form.priceDateBegin_now is 1> checked</cfif>> Price is applied as of now (ignores date/time above)</label>
	</td>
</tr>
<tr>
	<td valign="top">End Date: </td>
	<td>
		#fn_FormSelectDateTime(Variables.formName, "priceDateEnd_date", Form.priceDateEnd_date, "priceDateEnd_hh", Form.priceDateEnd_hh, "priceDateEnd_mm", Form.priceDateEnd_mm, "priceDateEnd_tt", Form.priceDateEnd_tt, True)#
		 (optional)
		<cfif Variables.doAction is "priceUpdate">
			<br><label><input type="checkbox" name="priceDateEnd_now" value="1"<cfif Form.priceDateEnd_now is 1> checked</cfif>> Price ends now (ignores date/time above)</label>
		</cfif>
	</td>
</tr>
</table>
</p>

<!--- 
<cfset Variables.priceHasActiveSubscriptions = True>
<cfif Variables.doAction is "updatePrice" and Variables.priceHasActiveSubscriptions is True>
	<table border="1" cellspacing="0" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>&nbsp;</th>
		<th>Subscriptions<br>to Update</th>
		<th>When to<br>Update Subscription</th>
		<th>Override<br>Subscription?</th>
	</tr>
	<tr class="TableText" valign="top">
		<td align="center"><input type="radio" name="priceSubscriptionUpdateExisting" value="0"></td>
		<td>Do not update any existing subscriptions</td>
		<td align="center">-</td>
		<td align="center">-</td>
	</tr>
	<tr class="TableText" valign="top" bgcolor="f4f4ff">
		<td align="center"><input type="radio" name="priceSubscriptionUpdateExisting" value="0"></td>
		<td>Existing subscriptions not set<br>to override price update setting</td>
		<td>Price begin date</td>
		<td align="center">No</td>
	</tr>
	<tr class="TableText" valign="top">
		<td align="center"><input type="radio" name="priceSubscriptionUpdateExisting" value="0"></td>
		<td>Existing subscriptions not set<br>to override price update setting</td>
		<td>Subscriber's next billing date<br>after price begin date</td>
		<td align="center">No</td>
	</tr>
	<tr class="TableText" valign="top" bgcolor="f4f4ff">
		<td align="center"><input type="radio" name="priceSubscriptionUpdateExisting" value="0"></td>
		<td>All existing subscriptions</td>
		<td>Price begin date</td>
		<td align="center">Yes</td>
	</tr>
	<tr class="TableText" valign="top">
		<td align="center"><input type="radio" name="priceSubscriptionUpdateExisting" value="0"></td>
		<td>All existing subscriptions</td>
		<td>Subscriber's next billing date<br>after price begin date</td>
		<td align="center">Yes</td>
	</tr>
	</table>

	<p class="TableText">
	<b>Existing Subscriptions Using This Price:</b><br>
	label><input type="checkbox" name="priceSubscriptionUpdate" value="1">Update price of existing subscriptions?</label><br>
	If yes:<br>
	&nbsp; &nbsp; Override existing subscription setting?<br>
	&nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateOverride" value="0">No, do not override subscription setting<br>
	&nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateOverride" value="1">Yes, override subscription setting<br>
	&nbsp; &nbsp; When does the new price take effect?<br>
	&nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateNow" value="0">As of price begin date specified above<br>
	&nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateNow" value="1">At subscriber's next billing period after price begin date<br>
	&nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateNow" value="2">Upon subscription renewal if specified end date<br>
	&nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateNow" value="3">Upon subscription renewal <br>
	&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; If upon renewal, if subscription continues after &quot;end date&quot; :<br>
	&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateRenewal" value="0">At designated subscription end date<br>
	&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateRenewal" value="1">At designated subscription end date unless continues indefinitely<br>
	
	<br>


	<p class="TableText">
	<b>Existing Subscriptions Using This Price:</b><br>
	Update price of existing subscriptions?<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateExisting" value="0">No - Do not update existing subscriptions<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateExisting" value="1">Yes - Update existing subscriptions as of price begin date unless subscription says not to<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateExisting" value="1">Yes - Update existing subscriptions as of subscriber's next billing period after being date unless subscription says not to<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateExisting" value="2">Yes - Update all existing subscriptions as of price begin date, overriding individual subscription settings<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateExisting" value="2">Yes - Update all existing subscriptions, overriding individual subscription settings<br>
	<br>
	Update price when <i>renewing</i> existing subscriptions?<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateRenewal" value="0">No - Renew existing subscriptions at existing price, not new price<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateRenewal" value="1">Yes - Renew existing subscriptions at new price unless subscription says not to<br>
	&nbsp; &nbsp; <input type="radio" name="priceSubscriptionUpdateRenewal" value="2">Yes - Renew all existing subscriptions at new price, overriding individual subscription settings<br>
	</p>
</cfif>
--->

<cfif Variables.formAction is not "">
	<p>
	<table border="0" cellspacing="0" cellpadding="2" class="TableText">
	<tr>
		<td>Increase ## of price stages: </td>
		<td>
			<input type="text" name="priceStageCount" value="#Form.priceStageCount#" size="3"> 
			<input type="submit" name="submitPriceStageCount" value="Go">
		</td>
	</tr>
	<tr>
		<td>Increase ## of volume discount levels: </td>
		<td>
			<input type="text" name="priceVolumeDiscountCount" value="#Form.priceVolumeDiscountCount#" size="3"> 
			<input type="submit" name="submitPriceVolumeCount" value="Go">
		</td>
	</tr>
	</table>
	</p>
</cfif>

<cfloop Index="stageCount" From="1" To="#Form.priceStageCount#">
	<cfif stageCount is not 1><br></cfif>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText">
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<cfif Form.priceStageCount is 1>
				<b>Price has only one stage.</b>
				<input type="hidden" name="priceStageInterval#stageCount#" value=""> 
				<input type="hidden" name="priceStageIntervalType#stageCount#" value="">
			<cfelseif stageCount is Form.priceStageCount>
				<b>Price Stage ###stageCount#:</b> (this is the last price stage)
				<input type="hidden" name="priceStageInterval#stageCount#" value=""> 
				<input type="hidden" name="priceStageIntervalType#stageCount#" value="">
			<cfelse>
				<b>Price Stage ###stageCount#:</b> 
				<input type="text" name="priceStageInterval#stageCount#" value="#HTMLEditFormat(Form["priceStageInterval#stageCount#"])#" size="3"> 
				<select name="priceStageIntervalType#stageCount#" size="1">
				<option value="">-- INTERVAL --</option>
				<cfloop Index="intervalTypeCount" From="1" To="#ListLen(Variables.priceStageIntervalTypeList_value)#">
					<option value="#ListGetAt(Variables.priceStageIntervalTypeList_value, intervalTypeCount)#"<cfif Form["priceStageIntervalType#stageCount#"] is ListGetAt(Variables.priceStageIntervalTypeList_value, intervalTypeCount)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.priceStageIntervalTypeList_label, intervalTypeCount))#(s)</option>
				</cfloop>
				</select>
				<cfif stageCount is 1>
					 <b>(<i>Leave interval blank if only one price stage</i>)</b>
				<cfelse>
					 (<i>If 0 or blank, price stage is ignored after this stage</i>)
				</cfif>
			</cfif>
		</td>
	</tr>
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			Internal Description of This Stage: <input type="text" name="priceStageDescription#stageCount#" value="#HTMLEditFormat(Form["priceStageDescription#stageCount#"])#" size="40" maxlength="#maxlength_PriceStage.priceStageDescription#"><br>
			Text Added to Invoice Line Item: &nbsp; &nbsp; <input type="text" name="priceStageText#stageCount#" value="#HTMLEditFormat(Form["priceStageText#stageCount#"])#" size="40" maxlength="#maxlength_PriceStage.priceStageText#"><br>
		</td>
	</tr>
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<b>Price Stated As:</b><br>
			<table border="0" cellspacing="0" cellpadding="0" class="TableText">
			<tr>
				<td>
					<input type="radio" name="priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#" value="1_1"<cfif Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"] is "1_1"> checked</cfif>><!--- percent/deduction ---> 
					 <input type="text" name="priceStageAmount#stageCount#_1_1" size="6"<cfif IsNumeric(Form["priceStageAmount#stageCount#_1_1"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["priceStageAmount#stageCount#_1_1"])#"</cfif>><font size="4"><b>%</b></font> <i>Discount</i> off normal price<br>
					<input type="radio" name="priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#" value="1_0"<cfif Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"] is "1_0"> checked</cfif>><!--- percent/new ---> 
					 <input type="text" name="priceStageAmount#stageCount#_1_0" size="6"<cfif IsNumeric(Form["priceStageAmount#stageCount#_1_0"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["priceStageAmount#stageCount#_1_0"])#"</cfif>><font size="4"><b>%</b></font> <i>Of</i> the normal price<br>
				</td>
				<td width="25">&nbsp;</td>
				<td>
					<input type="radio" name="priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#" value="0_1"<cfif Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"] is "0_1"> checked</cfif>><!--- dollar/deduction ---> 
					 <font size="4"><b>$</b></font><input type="text" name="priceStageAmount#stageCount#_0_1" size="6"<cfif IsNumeric(Form["priceStageAmount#stageCount#_0_1"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["priceStageAmount#stageCount#_0_1"])#"</cfif>> Discount off normal price<br>
					<input type="radio" name="priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#" value="0_0"<cfif Form["priceStageDollarOrPercent_priceStageNewOrDeduction#stageCount#"] is "0_0"> checked</cfif><cfif URL.productID is 0> disabled</cfif>><!--- dollar/new ---> 
					 <font size="4"><b>$</b></font><input type="text" name="priceStageAmount#stageCount#_0_0" size="6"<cfif IsNumeric(Form["priceStageAmount#stageCount#_0_0"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["priceStageAmount#stageCount#_0_0"])#"</cfif><cfif URL.productID is 0> disabled</cfif>> = New price<br>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			 <label><input type="checkbox" name="priceStageVolumeDiscount#stageCount#" onClick="toggle('showVolumeDiscount#stageCount#');" value="1"<cfif Form["priceStageVolumeDiscount#stageCount#"] is 1> checked</cfif>>Use volume discount options instead</label>
			 <div class="SmallText">(Uses price method above, but not the number)</div>

			 <cfif stageCount is 1><div class="TableText">&nbsp; &nbsp; &nbsp; (<i>Click checkbox for volume options to be displayed below.</i>)</div></cfif>

			<table border="0" cellspacing="0" cellpadding="0" class="TableText" id="showVolumeDiscount#stageCount#"<cfif Form["priceStageVolumeDiscount#stageCount#"] is 0> style="display:none;"</cfif>>
			<tr>
				<td>
					<b>Volume Discount Options:</b><br>
					<i>Price Levels:</i><br>
					<label><input type="radio" name="priceStageVolumeDollarOrQuantity#stageCount#" value="1"<cfif Form["priceStageVolumeDollarOrQuantity#stageCount#"] is 1> checked</cfif>> 
					Based on the <i>quantity</i> ordered.</label><br>
					<label><input type="radio" name="priceStageVolumeDollarOrQuantity#stageCount#" value="0"<cfif Form["priceStageVolumeDollarOrQuantity#stageCount#"] is not 1> checked</cfif>> 
					Based on <i>dollar value</i> of quantity based on normal price.</label><br>
					<br>
					<i>Use Step Pricing?</i><br>
					<label><input type="radio" name="priceStageVolumeStep#stageCount#" value="0"<cfif Form["priceStageVolumeStep#stageCount#"] is not 1> checked</cfif>> 
					No - Use price based on total quantity in invoice for all units</label><br>
					<label><input type="radio" name="priceStageVolumeStep#stageCount#" value="1"<cfif Form["priceStageVolumeStep#stageCount#"] is 1> checked</cfif>> 
					Yes - Apply price at each level within the same invoice</label><br>
				</td>
				<td width="25">&nbsp;</td>
				<td>
					<table border="0" cellspacing="0" cellpadding="2" class="TableText">
					<tr valign="bottom">
						<th class="TableHeader">&nbsp;</th>
						<th class="TableHeader">Min. ##  or $</th>
						<th class="TableHeader">Price $ or %</th>
						<th class="TableHeader">Total<br>Price?</th>
					</tr>
					<cfset thisStageCount = stageCount>
					<cfloop Index="volumeCount" From="1" To="#Form.priceVolumeDiscountCount#">
						<tr<cfif (volumeCount mod 2) is not (thisStageCount mod 2)> bgcolor="f4f4ff"<cfelse> bgcolor="white"</cfif>>
						<td align="right">#volumeCount#: </td>
						<td align="center"><input type="text" name="priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#" size="8"<cfif IsNumeric(Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"])> value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form["priceVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"])#"</cfif>></td>
						<td align="center"><input type="text" name="priceVolumeDiscountAmount#thisStageCount#_#volumeCount#" size="8"<cfif IsNumeric(Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["priceVolumeDiscountAmount#thisStageCount#_#volumeCount#"])#"</cfif>></td>
						<td align="center"><cfif URL.productID is 0>-<cfelse><input type="checkbox" name="priceVolumeDiscountIsTotalPrice#thisStageCount#_#volumeCount#" value="1"<cfif Form["priceVolumeDiscountIsTotalPrice#thisStageCount#_#volumeCount#"] is 1> checked</cfif>></cfif></td>
						</tr>
					</cfloop>
					</table>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	</table>
</cfloop>

<p><input type="submit" name="submitInsertUpdatePrice" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>

