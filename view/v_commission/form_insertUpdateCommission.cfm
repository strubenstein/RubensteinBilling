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

<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<!--- 
<tr>
	<td>Status: </td>
	<td>
		<label><input type="radio" name="commissionStatus" value="1"<cfif Form.commissionStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label><input type="radio" name="commissionStatus" value="0"<cfif Form.commissionStatus is not 1> checked</cfif>> Not active</label>
	</td>
</tr>
--->
<tr>
	<td>Internal Name: </td>
	<td class="TableText"><input type="text" name="commissionName" value="#HTMLEditFormat(Form.commissionName)#" Size="50" Maxlength="#maxlength_Commission.commissionName#"> (suggested)</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td class="TableText"><input type="text" name="commissionID_custom" value="#HTMLEditFormat(Form.commissionID_custom)#" Size="20" Maxlength="#maxlength_Commission.commissionID_custom#"> (optional; for integration purposes)</td>
</tr>
<tr>
	<td>Description: </td>
	<td class="TableText"><input type="text" name="commissionDescription" value="#HTMLEditFormat(Form.commissionDescription)#" Size="50" Maxlength="#maxlength_Commission.commissionDescription#"> (optional)</td>
</tr>
</table>

<p class="TableText">
<b>Calculation Basis:</b> (<font class="TableText">determines when commission is calculated</font>)<br>
<label><input type="radio" name="commissionPeriodIntervalType" value=""<cfif Form.commissionPeriodIntervalType is ""> checked</cfif>>
	Invoice-based -- Calculated independently for each individual invoice when fully paid.</label><br>
<span class="SmallText">(OR calculated on a periodic basis based on all invoices fully paid within that calendar period)</span><br>
<label><input type="radio" name="commissionPeriodIntervalType" value="ww"<cfif Form.commissionPeriodIntervalType is "ww"> checked</cfif>>
	Weekly -- Calculated weekly based on total of all invoices fully paid that calendar week.</label><br>
<label><input type="radio" name="commissionPeriodIntervalType" value="m"<cfif Form.commissionPeriodIntervalType is "m"> checked</cfif>>
	Monthly -- Calculated monthly based on total of all invoices fully paid that calendar month.</label><br>
<label><input type="radio" name="commissionPeriodIntervalType" value="q"<cfif Form.commissionPeriodIntervalType is "q"> checked</cfif>>
	Quarterly -- Calculated quarterly based on total of all invoices fully paid that calendar quarter.</label><br>
<label><input type="radio" name="commissionPeriodIntervalType" value="yyyy"<cfif Form.commissionPeriodIntervalType is "yyyy"> checked</cfif>>
	Annually -- Calculated monthly based on total of all invoices fully paid that calendar year.</label><br>
</p>

<p class="TableText">
<b>Commission Applies To:</b><br>
<label><input type="radio" name="commissionAppliesToInvoice" value="0"<cfif Form.commissionAppliesToInvoice is 0> checked</cfif>> 
Commission is applied to individual products and/or categories -- not to the entire invoice.<br>
&nbsp; &nbsp; &nbsp; (The products and categories may be selected later.)</label><br>
<label><input type="radio" name="commissionAppliesToInvoice" value="1"<cfif Form.commissionAppliesToInvoice is 1> checked</cfif>> 
Commission is applied to the entire invoice -- minus any commissions on individual products.</label><br>
&nbsp; &nbsp; &nbsp; <label><input type="radio" name="commissionAppliesToExistingProducts_commissionAppliesToCustomProducts" value="1_1"<cfif Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts is "1_1"> checked</cfif>> 
	Include existing <i>and</i> custom product line items in invoice total.</label><br>
&nbsp; &nbsp; &nbsp; <label><input type="radio" name="commissionAppliesToExistingProducts_commissionAppliesToCustomProducts" value="1_0"<cfif Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts is "1_0"> checked</cfif>> 
	Include only existing product line items in invoice total.</label><br>
&nbsp; &nbsp; &nbsp; <label><input type="radio" name="commissionAppliesToExistingProducts_commissionAppliesToCustomProducts" value="0_1"<cfif Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts is "0_1"> checked</cfif>> 
	Include only custom product line items in invoice total.</label><br>
</p>

<p>
<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr><td colspan="2"><b>Commission Salesperson Targets:</b> (who receives commission)</td></tr>
<tr>
	<td>Targets all: </td>
	<td>
		<label><input type="checkbox" name="commissionTargetsAllUsers" value="1"<cfif Form.commissionTargetsAllUsers is 1> checked</cfif>>Salespeople (users)</label> &nbsp; 
		<!--- <label><input type="checkbox" name="commissionTargetsAllCompanies" value="1"<cfif Form.commissionTargetsAllCompanies is 1> checked</cfif>>Companies (including customers)</label><br> --->
		<!--- <label><input type="checkbox" name="commissionTargetsAllGroups" value="1"<cfif Form.commissionTargetsAllGroups is 1> checked</cfif>>Groups</label> &nbsp; --->
		<label><input type="checkbox" name="commissionTargetsAllAffiliates" value="1"<cfif Form.commissionTargetsAllAffiliates is 1> checked</cfif>>Affiliates</label> &nbsp; 
		<label><input type="checkbox" name="commissionTargetsAllCobrands" value="1"<cfif Form.commissionTargetsAllCobrands is 1> checked</cfif>>Cobrands</label> &nbsp; 
		<label><input type="checkbox" name="commissionTargetsAllVendors" value="1"<cfif Form.commissionTargetsAllVendors is 1> checked</cfif>>Vendors</label> &nbsp; 
	</td>
</tr>
<tr class="SmallText">
	<td>&nbsp;</td>
	<td>(Note: Targets may also be selected individually or via groups.)</td>
</tr>
</table>
</p>

<p>
<div class="TableText"><b>Date range during which commission will be applied:</b></div>
<table border="0" cellspacing="2" cellpadding="2" class="TableText">
<tr>
	<td valign="top">Begin Date: </td>
	<td>
		#fn_FormSelectDateTime(Variables.formName, "commissionDateBegin_date", Form.commissionDateBegin_date, "commissionDateBegin_hh", Form.commissionDateBegin_hh, "commissionDateBegin_mm", Form.commissionDateBegin_mm, "commissionDateBegin_tt", Form.commissionDateBegin_tt, True)# (required)<br>
		<label><input type="checkbox" name="commissionDateBegin_now" value="1"<cfif Form.commissionDateBegin_now is 1> checked</cfif>> Commission is applied as of now (ignores date/time above)</label>
	</td>
</tr>
<tr>
	<td valign="top">End Date: </td>
	<td>
		#fn_FormSelectDateTime(Variables.formName, "commissionDateEnd_date", Form.commissionDateEnd_date, "commissionDateEnd_hh", Form.commissionDateEnd_hh, "commissionDateEnd_mm", Form.commissionDateEnd_mm, "commissionDateEnd_tt", Form.commissionDateEnd_tt, True)#
		 (optional)
		<cfif Variables.doAction is "updateCommission">
			<br><label><input type="checkbox" name="commissionDateEnd_now" value="1"<cfif Form.commissionDateEnd_now is 1> checked</cfif>> Commission ends now (ignores date/time above)</label>
		</cfif>
	</td>
</tr>
</table>
</p>

<p>
<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr>
	<td><b>Increase ## of commission stages:</b> </td>
	<td>
		<input type="text" name="commissionStageCount" value="#Form.commissionStageCount#" size="3"> 
		<input type="submit" name="submitCommissionStageCount" value="Go">
	</td>
</tr>
<tr>
	<td><b>Increase ## of volume levels:</b> </td>
	<td>
		<input type="text" name="commissionVolumeDiscountCount" value="#Form.commissionVolumeDiscountCount#" size="3"> 
		<input type="submit" name="submitCommissionVolumeCount" value="Go">
	</td>
</tr>
</table>
</p>

<cfloop Index="stageCount" From="1" To="#Form.commissionStageCount#">
	<cfif stageCount is not 1><br></cfif>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText">
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<cfif Form.commissionStageCount is 1>
				<b>Commission has only one stage.</b>
				<input type="hidden" name="commissionStageInterval#stageCount#" value=""> 
				<input type="hidden" name="commissionStageIntervalType#stageCount#" value="">
			<cfelseif stageCount is Form.commissionStageCount>
				<b>Commission Stage ###stageCount#:</b> (this is the last commission stage)
				<input type="hidden" name="commissionStageInterval#stageCount#" value=""> 
				<input type="hidden" name="commissionStageIntervalType#stageCount#" value="">
			<cfelse>
				<b>Commission Stage ###stageCount#:</b> 
				<input type="text" name="commissionStageInterval#stageCount#" value="#HTMLEditFormat(Form["commissionStageInterval#stageCount#"])#" size="3"> 
				<select name="commissionStageIntervalType#stageCount#" size="1">
				<option value="">-- INTERVAL --</option>
				<cfloop Index="intervalTypeCount" From="1" To="#ListLen(Variables.commissionStageIntervalTypeList_value)#">
					<option value="#ListGetAt(Variables.commissionStageIntervalTypeList_value, intervalTypeCount)#"<cfif Form["commissionStageIntervalType#stageCount#"] is ListGetAt(Variables.commissionStageIntervalTypeList_value, intervalTypeCount)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.commissionStageIntervalTypeList_label, intervalTypeCount))#(s)</option>
				</cfloop>
				</select>
				<cfif stageCount is 1>
					 <b>(<i>Leave interval blank if only one commission stage</i>)</b>
				<cfelse>
					 (<i>If 0 or blank, commission stage is ignored after this stage</i>)
				</cfif>
			</cfif>
		</td>
	</tr>
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			Internal Description of This Stage: <input type="text" name="commissionStageDescription#stageCount#" value="#HTMLEditFormat(Form["commissionStageDescription#stageCount#"])#" size="40" maxlength="#maxlength_CommissionStage.commissionStageDescription#"><br>
			Text on Commission Statement: &nbsp; &nbsp; <input type="text" name="commissionStageText#stageCount#" value="#HTMLEditFormat(Form["commissionStageText#stageCount#"])#" size="40" maxlength="#maxlength_CommissionStage.commissionStageText#">
		</td>
	</tr>
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" class="TableText">
			<tr valign="top">
				<td>
					Commission Stated As:<br>
					<input type="radio" name="commissionStageDollarOrPercent#stageCount#" value="1"<cfif Form["commissionStageDollarOrPercent#stageCount#"] is 1> checked</cfif>><!--- percent ---> 
					 <input type="text" name="commissionStageAmount#stageCount#_1" size="6"<cfif IsNumeric(Form["commissionStageAmount#stageCount#_1"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["commissionStageAmount#stageCount#_1"])#"</cfif>><font size="4"><b>%</b></font> of revenue<br>
					<input type="radio" name="commissionStageDollarOrPercent#stageCount#" value="0"<cfif Form["commissionStageDollarOrPercent#stageCount#"] is 0> checked</cfif>><!--- dollar ---> 
					 <font size="4"><b>$</b></font><input type="text" name="commissionStageAmount#stageCount#_0" size="6"<cfif IsNumeric(Form["commissionStageAmount#stageCount#_0"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["commissionStageAmount#stageCount#_0"])#"</cfif>> multiplied times quantity<br>
				</td>
				<td width="25">&nbsp;</td>
				<td>
					<i>If using percentage, enter optional min/max commission</i>:<br>
					 Minimum Commission: $<input type="text" name="commissionStageAmountMinimum#stageCount#" size="6"<cfif IsNumeric(Form["commissionStageAmountMinimum#stageCount#"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["commissionStageAmountMinimum#stageCount#"])#"</cfif>><br>
					 Maximum Commission: $<input type="text" name="commissionStageAmountMaximum#stageCount#" size="6"<cfif IsNumeric(Form["commissionStageAmountMaximum#stageCount#"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["commissionStageAmountMaximum#stageCount#"])#"</cfif>><br>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr valign="top"<cfif (stageCount mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			 <label><input type="checkbox" name="commissionStageVolumeDiscount#stageCount#" onClick="toggle('showVolumeDiscount#stageCount#');" value="1"<cfif Form["commissionStageVolumeDiscount#stageCount#"] is 1> checked</cfif>>
			 <i><b>Use volume options.</b></i></label> Uses $ or % method above, but not the number. Min/max options still apply.
			 <cfif stageCount is 1><div class="TableText">&nbsp; &nbsp; &nbsp; (<i>Click checkbox for volume options to be displayed below.</i>)</div></cfif>

			<table border="0" cellspacing="0" cellpadding="0" class="TableText" id="showVolumeDiscount#stageCount#"<cfif Form["commissionStageVolumeDiscount#stageCount#"] is 0> style="display:none;"</cfif>>
			<tr valign="top">
				<td>
					<i>Commission Levels:</i><br>
					<label><input type="radio" name="commissionStageVolumeDollarOrQuantity#stageCount#" value="0"<cfif Form["commissionStageVolumeDollarOrQuantity#stageCount#"] is not 1> checked</cfif>> 
					Based on <i>revenue</i>.</label><br>
					<label><input type="radio" name="commissionStageVolumeDollarOrQuantity#stageCount#" value="1"<cfif Form["commissionStageVolumeDollarOrQuantity#stageCount#"] is 1> checked</cfif>> 
					Based on the <i>quantity</i> ordered.</label><br>
					<br>
					<i>Use Step Commission?</i><br>
					<label><input type="radio" name="commissionStageVolumeStep#stageCount#" value="0"<cfif Form["commissionStageVolumeStep#stageCount#"] is not 1> checked</cfif>> 
					No - Use commission based on total</label><div align="center">quantity in invoice for all units</div>
					<label><input type="radio" name="commissionStageVolumeStep#stageCount#" value="1"<cfif Form["commissionStageVolumeStep#stageCount#"] is 1> checked</cfif>> 
					Yes - Apply commission at each level</label><div align="center">within the same invoice</div>
				</td>
				<td width="25">&nbsp;</td>
				<td>
					<table border="0" cellspacing="0" cellpadding="2" class="TableText">
					<tr valign="bottom">
						<th class="TableHeader">&nbsp;</th>
						<th class="TableHeader">Minimum<br>## or $</th>
						<th class="TableHeader">Commission<br>$ or %</th>
						<th class="TableHeader">Total<br>Commission?</th>
					</tr>
					<cfset thisStageCount = stageCount>
					<cfloop Index="volumeCount" From="1" To="#Form.commissionVolumeDiscountCount#">
						<tr<cfif (volumeCount mod 2) is not (thisStageCount mod 2)> bgcolor="f4f4ff"<cfelse> bgcolor="white"</cfif>>
						<td align="right">#volumeCount#: </td>
						<td align="center"><input type="text" name="commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#" size="8"<cfif IsNumeric(Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"])> value="#Application.fn_LimitPaddedDecimalZerosQuantity(Form["commissionVolumeDiscountQuantityMinimum#thisStageCount#_#volumeCount#"])#"</cfif>></td>
						<td align="center"><input type="text" name="commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#" size="8"<cfif IsNumeric(Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"])> value="#Application.fn_LimitPaddedDecimalZerosDollar(Form["commissionVolumeDiscountAmount#thisStageCount#_#volumeCount#"])#"</cfif>></td>
						<td align="center"><input type="checkbox" name="commissionVolumeDiscountIsTotalCommission#thisStageCount#_#volumeCount#" value="1"<cfif Form["commissionVolumeDiscountIsTotalCommission#thisStageCount#_#volumeCount#"] is 1> checked</cfif>></td>
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

<p><input type="submit" name="submitInsertUpdateCommission" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>
