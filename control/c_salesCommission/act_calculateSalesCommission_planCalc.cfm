<cfset salesCommissionCalculatedAmount = 0>

<!--- not volume --->
<cfif qry_selectCommissionList.commissionStageVolumeDiscount[stageRow] is 0>
	<cfset salesCommissionArray[1].commissionVolumeDiscountID = 0>

	<cfif qry_selectCommissionList.commissionStageDollarOrPercent[stageRow] is 0><!--- dollar --->
		<cfset salesCommissionArray[1].salesCommissionCalculatedAmount = qry_selectCommissionList.commissionStageAmount[stageRow] * salesCommissionBasisQuantity>
	<cfelse><!--- percent --->
		<cfset salesCommissionArray[1].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionList.commissionStageAmount[stageRow] * salesCommissionBasisTotal, 2)>
	</cfif>

	<cfset salesCommissionCalculatedAmount = salesCommissionArray[1].salesCommissionCalculatedAmount>

<!--- volume discount: non step --->
<cfelseif qry_selectCommissionList.commissionStageVolumeStep[stageRow] is 0>
	<cfset salesCommissionArray[1].salesCommissionCalculatedAmount = 0>
	<cfset salesCommissionArray[1].commissionVolumeDiscountID = 0>

	<cfset beginRow = ListFind(ValueList(qry_selectCommissionVolumeDiscount.commissionStageID), thisStageID)>

	<!--- if not volume options OR quantity at first volume step is greater than purchased quantity, commission = 0 --->
	<cfif beginRow is 0
			or (qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[stageRow] is 1 and salesCommissionBasisQuantity lt qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[beginRow])
			or (qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[stageRow] is 0 and salesCommissionBasisTotal lt qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[beginRow])>
		<cfset salesCommissionArray[1].salesCommissionCalculatedAmount = 0>
		<cfset salesCommissionArray[1].commissionVolumeDiscountID = 0>
	<cfelse>
		<cfloop Query="qry_selectCommissionVolumeDiscount" StartRow="#beginRow#"><!--- loop thru volume options --->
			<cfif qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityIsMaximum is 1
					or qry_selectCommissionVolumeDiscount.CurrentRow is qry_selectCommissionVolumeDiscount.RecordCount
					or qry_selectCommissionVolumeDiscount.commissionStageID[1 + qry_selectCommissionVolumeDiscount.CurrentRow] is not thisStageID
					or (qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[stageRow] is 1
							and salesCommissionBasisQuantity lt qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow])
					or (qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[stageRow] is 0
							and salesCommissionBasisTotal lt qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow])>

				<cfif qry_selectCommissionList.commissionStageDollarOrPercent[stageRow] is 0><!--- dollar --->
					<cfset salesCommissionArray[1].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * salesCommissionBasisQuantity, 2)>
				<cfelse><!--- percent --->
					<cfset salesCommissionArray[1].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * salesCommissionBasisTotal, 2)>
				</cfif>

				<cfset salesCommissionArray[1].commissionVolumeDiscountID = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountID>
				<cfbreak>
			</cfif><!--- /if last step for this commission stage OR purchased quantity is less than quantity at next volume step --->
		</cfloop><!--- /loop thru volume discount options --->
	</cfif><!--- /if quantity at first volume step is greater than purchased quantity --->

	<cfset salesCommissionCalculatedAmount = salesCommissionArray[1].salesCommissionCalculatedAmount>

<!--- volume: step based on quantity --->
<cfelseif qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[stageRow] is 1>
	<cfset beginRow = ListFind(ValueList(qry_selectCommissionVolumeDiscount.commissionStageID), thisStageID)>

	<cfset quantityRemaining = salesCommissionBasisQuantity>
	<cfset salesCommissionCalculatedAmount = 0>
	<cfset counter = 1>

	<cfloop Query="qry_selectCommissionVolumeDiscount" StartRow="#beginRow#"><!--- loop thru volume options --->
		<cfif counter gt 1>
			<cfset salesCommissionArray[counter] = StructNew()>
		</cfif>
		<cfset salesCommissionArray[counter].commissionVolumeDiscountID = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountID>

		<!--- Determine quantity. If last step, use remaining quantity --->
		<cfif qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityIsMaximum is 1
				or qry_selectCommissionVolumeDiscount.CurrentRow is qry_selectCommissionVolumeDiscount.RecordCount
				or qry_selectCommissionVolumeDiscount.commissionStageID[1 + qry_selectCommissionVolumeDiscount.CurrentRow] is not thisStageID
				or (quantityRemaining lt (qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow] - qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum)
					and qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum is not 0)>
			<cfset salesCommissionArray[counter].quantity = quantityRemaining>
			<cfset quantityRemaining = 0>
		<!--- Not last step. Quantity based on minimum amount of next level --->
		<cfelseif qry_selectCommissionVolumeDiscount.CurrentRow is beginRow and qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum is 0>
			<cfset salesCommissionArray[counter].quantity = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow] - qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum - 1>
			<cfset quantityRemaining = quantityRemaining - salesCommissionArray[counter].quantity>
		<cfelse>
			<cfset salesCommissionArray[counter].quantity = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow] - qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum>
			<cfset quantityRemaining = quantityRemaining - salesCommissionArray[counter].quantity>
		</cfif>

		<!--- if using total commission at step regardless of quantity --->
		<cfif qry_selectCommissionVolumeDiscount.commissionVolumeDiscountIsTotalCommission is 1>
			<cfset salesCommissionArray[counter].salesCommissionCalculatedAmount = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount>
		<cfelseif qry_selectCommissionList.commissionStageDollarOrPercent[stageRow] is 0><!--- dollar --->
			<cfset salesCommissionArray[counter].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * salesCommissionArray[counter].quantity, 2)>
		<cfelse><!--- percent --->
			<cfset salesCommissionArray[counter].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * salesCommissionBasisTotal * (salesCommissionArray[counter].quantity / salesCommissionBasisQuantity), 2)>
		</cfif>

		<cfset salesCommissionCalculatedAmount = salesCommissionCalculatedAmount + salesCommissionArray[counter].salesCommissionCalculatedAmount>
		<cfset counter = counter + 1>
		<cfif quantityRemaining is 0><cfbreak></cfif>
	</cfloop>

<!--- volume: steps based on dollar value of revenue --->
<cfelse>
	<cfset beginRow = ListFind(ValueList(qry_selectCommissionVolumeDiscount.commissionStageID), thisStageID)>
	<cfset counter = 1>
	<cfset subTotalRemaining = salesCommissionBasisTotal>

	<cfloop Query="qry_selectCommissionVolumeDiscount" StartRow="#beginRow#"><!--- loop thru volume options --->
		<cfif counter gt 1>
			<cfset salesCommissionArray[counter] = StructNew()>
		</cfif>
		<cfset salesCommissionArray[counter].commissionVolumeDiscountID = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountID>

		<!--- Determine quantity. If last step, use remaining quantity --->
		<cfif qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityIsMaximum is 1
				or qry_selectCommissionVolumeDiscount.CurrentRow is qry_selectCommissionVolumeDiscount.RecordCount
				or qry_selectCommissionVolumeDiscount.commissionStageID[1 + qry_selectCommissionVolumeDiscount.CurrentRow] is not thisStageID
				or (subTotalRemaining lt (qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow] - qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum)
					and qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum is not 0)>
			<cfset salesCommissionArray[counter].quantity = subTotalRemaining>
			<cfset subTotalRemaining = 0>
		<!--- Not last step. Quantity based on minimum amount of next level --->
		<cfelse>
			<cfset salesCommissionArray[counter].quantity = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum[1 + qry_selectCommissionVolumeDiscount.CurrentRow] - qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum>
			<cfset subTotalRemaining = subTotalRemaining - salesCommissionArray[counter].quantity>
		</cfif>

		<!--- if using total step at step regardless of quantity --->
		<cfif qry_selectCommissionVolumeDiscount.commissionVolumeDiscountIsTotalCommission is 1>
			<cfset salesCommissionArray[counter].subTotal = qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount>
		<cfelseif qry_selectCommissionList.commissionStageDollarOrPercent[stageRow] is 0><!--- dollar --->
			<cfset salesCommissionArray[counter].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * salesCommissionBasisQuantity * (salesCommissionArray[counter].quantity / salesCommissionBasisTotal), 2)>
		<cfelse><!--- percent --->
			<cfset salesCommissionArray[counter].salesCommissionCalculatedAmount = Application.fn_setDecimalPrecision(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * salesCommissionArray[counter].quantity, 2)>
		</cfif>

		<cfset salesCommissionCalculatedAmount = salesCommissionCalculatedAmount + salesCommissionArray[counter].salesCommissionCalculatedAmount>
		<cfset counter = counter + 1>
		<cfif subTotalRemaining is 0><cfbreak></cfif>
	</cfloop><!--- /loop thru volume options --->
</cfif><!--- /commission calculation method --->
