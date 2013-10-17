<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionTarget" ReturnVariable="qry_selectCommissionTarget">
	<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
	<cfinvokeargument Name="commissionTargetStatus" Value="1">
	<cfinvokeargument Name="targetID" Value="0">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionVolumeDiscount" ReturnVariable="qry_selectCommissionVolumeDiscount">
	<cfinvokeargument Name="commissionStageID" Value="#ValueList(qry_selectCommission.commissionStageID)#">
</cfinvoke>

<cfinclude template="../../view/v_commission/var_commissionStageIntervalTypeList.cfm">
<cfinclude template="../../view/v_commission/var_commissionPeriodIntervalTypeList.cfm">

<cfinclude template="../../view/v_commission/dsp_selectCommission.cfm">

