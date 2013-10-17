<cfoutput>
<table border="0" cellspacing="0" cellpadding="2" class="MainText">
<tr>
	<td>Status: </td>
	<td><cfif qry_selectCommission.commissionStatus[1] is 1>Active<cfelse>Inactive</cfif></td>
</tr>
<tr>
	<td>Internal Name: </td>
	<td>#qry_selectCommission.commissionName[1]#</td>
</tr>
<tr>
	<td>Custom ID: </td>
	<td>#qry_selectCommission.commissionID_custom[1]#</td>
</tr>
<tr>
	<td>Description: </td>
	<td>#qry_selectCommission.commissionDescription[1]#</td>
</tr>
</table>

<p class="TableText">
<b>Calculation Basis:</b> (<font class="TableText">determines when commission is calculated</font>)<br>
<cfswitch expression="#qry_selectCommission.commissionPeriodIntervalType[1]#">
<cfcase value="ww">Weekly -- Calculated weekly based on total of all invoices fully paid that calendar week.</cfcase>
<cfcase value="m">Monthly -- Calculated monthly based on total of all invoices fully paid that calendar month.</cfcase>
<cfcase value="q">Quarterly -- Calculated quarterly based on total of all invoices fully paid that calendar quarter.</cfcase>
<cfcase value="yyyy">Annually -- Calculated monthly based on total of all invoices fully paid that calendar year.</cfcase>
<cfdefaultcase>Invoice-based -- Calculated independently for each individual invoice when fully paid.</cfdefaultcase>
</cfswitch>
</p>

<p class="TableText">
<b>Commission Applies To:</b><br>
<cfif qry_selectCommission.commissionAppliesToInvoice[1] is 0>
	Commission is applied to individual products and/or categories -- not to the entire invoice.
<cfelse>
	Commission is applied to the entire invoice -- minus any commissions on individual products.<br>
	&nbsp; &nbsp; &nbsp; 
	<cfswitch expression="#qry_selectCommission.commissionAppliesToExistingProducts[1]#_#qry_selectCommission.commissionAppliesToCustomProducts[1]#">
	<cfcase value="1_1">Include existing <i>and</i> custom product line items in invoice total.</cfcase>
	<cfcase value="1_0">Include only existing product line items in invoice total.</cfcase>
	<cfcase value="0_1">Include only custom product line items in invoice total.</cfcase>
	</cfswitch>
</cfif>
</p>

<p>
<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr><td colspan="2"><b>Commission Salesperson Targets:</b> (who receives commission)</td></tr>
<tr>
	<td>Targets all: </td>
	<td>
		<cfif qry_selectCommissionTarget.RecordCount is 0>
			n/a
		<cfelse>
			<cfloop Query="qry_selectCommissionTarget">
				<cfswitch expression="#Application.fn_GetPrimaryTargetKey(qry_selectCommissionTarget.primaryTargetID)#">
				<cfcase value="userID">Users</cfcase>
				<cfcase value="companyID">Companies</cfcase>
				<cfcase value="affiliateID">Affiliates</cfcase>
				<cfcase value="cobrandID">Cobrands</cfcase>
				<cfcase value="vendorID">Vendors</cfcase>
				<cfcase value="groupID">Groups</cfcase>
				</cfswitch>
				<cfif qry_selectCommissionTarget.CurrentRow is not qry_selectCommissionTarget.RecordCount>, </cfif>
			</cfloop>
		</cfif>
	</td>
</tr>
</table>
</p>

<p>
<div class="TableText"><b>Date range during which commission will be applied:</b></div>
<table border="0" cellspacing="2" cellpadding="2" class="TableText">
<tr>
	<td valign="top">Begin Date: </td>
	<td><cfif Not IsDate(qry_selectCommission.commissionDateBegin[1])>n/a<cfelse>#DateFormat(qry_selectCommission.commissionDateBegin[1], "mmmm dd, yyyy")# at #TimeFormat(qry_selectCommission.commissionDateBegin[1], "hh:mm tt")#</cfif></td>
</tr>
<tr>
	<td valign="top">End Date: </td>
	<td><cfif Not IsDate(qry_selectCommission.commissionDateEnd[1])>n/a<cfelse>#DateFormat(qry_selectCommission.commissionDateEnd[1], "mmmm dd, yyyy")# at #TimeFormat(qry_selectCommission.commissionDateEnd[1], "hh:mm tt")#</cfif></td>
</tr>
</table>
</p>

<cfloop Query="qry_selectCommission">
	<cfif qry_selectCommission.commissionStageOrder is not 1><br></cfif>
	<table border="1" cellspacing="0" cellpadding="2" class="TableText">
	<tr valign="top"<cfif (qry_selectCommission.commissionStageOrder mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<cfif qry_selectCommission.RecordCount is 1>
				<b>Commission has only one stage.</b>
			<cfelseif qry_selectCommission.CurrentRow is qry_selectCommission.RecordCount>
				<b>Commission Stage ###qry_selectCommission.commissionStageOrder#:</b> (this is the last commission stage)
			<cfelse>
				<b>Commission Stage ###qry_selectCommission.commissionStageOrder#:</b> 
				#qry_selectCommission.commissionStageInterval#
				<cfset Variables.stagePos = ListFind(Variables.commissionStageIntervalTypeList_value, qry_selectCommission.commissionStageIntervalType)>
				<cfif Variables.stagePos is 0>
					?
				<cfelse>
					#ListGetAt(Variables.commissionStageIntervalTypeList_label, Variables.stagePos)#<cfif qry_selectCommission.commissionStageInterval gt 1>s</cfif>
				</cfif>
			</cfif>
		</td>
	</tr>
	<tr valign="top"<cfif (qry_selectCommission.commissionStageOrder mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			Internal Description of This Stage: #qry_selectCommission.commissionStageDescription#<br>
			Text on Commission Statement: &nbsp; &nbsp; #qry_selectCommission.commissionStageText#
		</td>
	</tr>
	<tr valign="top"<cfif (qry_selectCommission.commissionStageOrder mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" class="TableText">
			<tr>
				<td>Commission Stated As: </td>
				<td>
					<cfif qry_selectCommission.commissionStageDollarOrPercent is 1>
						#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommission.commissionStageAmount * 100)#% of revenue
					<cfelse>
						$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommission.commissionStageAmount)# multiplied times quantity
					</cfif>
				</td>
			</tr>
			<tr>
				<td>Minimum Commission: </td>
				<td><cfif qry_selectCommission.commissionStageAmountMinimum is 0>n/a<cfelse>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommission.commissionStageAmountMinimum)#</cfif></td>
			</tr>
			<tr>
				<td>Maximum Commission: </td>
				<td><cfif qry_selectCommission.commissionStageAmountMaximum is 0>n/a<cfelse>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommission.commissionStageAmountMaximum)#</cfif></td>
			</tr>
			</table>
		</td>
	</tr>
	<cfif qry_selectCommission.commissionStageVolumeDiscount is 1>
		<tr valign="top"<cfif (qry_selectCommission.commissionStageOrder mod 2) is 0> bgcolor="f4f4ff"</cfif>>
			<td>
				<i><b>Use volume options.</b></i><br>
				Uses $ or % method above, but not the number. Min/max options still apply.
				<table border="0" cellspacing="0" cellpadding="0" class="TableText">
				<tr valign="top">
					<td>
						<i>Commission Levels:</i><br>
						<cfif qry_selectCommission.commissionStageVolumeDollarOrQuantity is 0>
							Based on <i>revenue</i>.<br>
						<cfelse>
							Based on the <i>quantity</i> ordered.<br>
						</cfif>
						<br>
						<i>Use Step Commission?</i><br>
						<cfif qry_selectCommission.commissionStageVolumeStep is 0>
							No - Use commission based on total quantity in invoice for all units
						<cfelse>
							Yes - Apply commission at each level within the same invoice
						</cfif>
					</td>
					<td width="25">&nbsp;</td>
					<td>
						<table border="1" cellspacing="0" cellpadding="2" class="TableText">
						<tr valign="bottom">
							<th class="TableHeader">&nbsp;</th>
							<th class="TableHeader">Minimum <cfif qry_selectCommission.commissionStageVolumeDollarOrQuantity is 0>$<cfelse>##</cfif></th>
							<th class="TableHeader">Commission <cfif qry_selectCommission.commissionStageDollarOrPercent is 0>$<cfelse>%</cfif></th>
							<th class="TableHeader">Total<br>Commission?</th>
						</tr>

						<cfset Variables.thisCommissionStageID = qry_selectCommission.commissionStageID>
						<cfset Variables.thisCommissionStageOrder = qry_selectCommission.commissionStageOrder>
						<cfset Variables.thisStageVolumeDollarOrQuantity = qry_selectCommission.commissionStageVolumeDollarOrQuantity>
						<cfset Variables.thisStageDollarOrPercent = qry_selectCommission.commissionStageDollarOrPercent>
						<cfset Variables.volumeDiscountRow = ListFind(ValueList(qry_selectCommissionVolumeDiscount.commissionStageID), qry_selectCommission.commissionStageID)>

						<cfif Variables.volumeDiscountRow is not 0>
							<cfloop Query="qry_selectCommissionVolumeDiscount" StartRow="#Variables.volumeDiscountRow#">
								<cfif qry_selectCommissionVolumeDiscount.CommissionStageID is not Variables.thisCommissionStageID><cfbreak></cfif>
								<tr<cfif (qry_selectCommissionVolumeDiscount.CurrentRow mod 2) is not (Variables.thisCommissionStageOrder mod 2)> bgcolor="f4f4ff"<cfelse> bgcolor="white"</cfif>>
								<td align="right">#IncrementValue(qry_selectCommissionVolumeDiscount.CurrentRow - Variables.volumeDiscountRow)#: </td>

								<td align="center">
									<cfif Variables.thisStageVolumeDollarOrQuantity is 0>
										$#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum)#
									<cfelse>
										#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum)#
									</cfif>
								</td>
								<td align="center">
									<cfif Variables.thisStageDollarOrPercent is 0>
										$#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount)#
									<cfelse>
										#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * 100)#%
									</cfif>
								</td>
								<td align="center"><cfif qry_selectCommissionVolumeDiscount.commissionVolumeDiscountIsTotalCommission is 1>Yes<cfelse>No</cfif></td>
								</tr>
							</cfloop>
						</cfif>
						</table>
					</td>
				</tr>
				</table>
			</td>
		</tr>
	</cfif>
	</table>
</cfloop>
</cfoutput>
