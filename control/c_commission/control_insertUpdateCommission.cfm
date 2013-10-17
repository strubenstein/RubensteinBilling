<cfif Variables.doAction is "updateCommission">
	<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionTarget" ReturnVariable="qry_selectCommissionTarget">
		<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
		<cfinvokeargument Name="commissionTargetStatus" Value="1">
		<cfinvokeargument Name="targetID" Value="0">
	</cfinvoke>

	<cfinvoke Component="#Application.billingMapping#data.Commission" Method="selectCommissionVolumeDiscount" ReturnVariable="qry_selectCommissionVolumeDiscount">
		<cfinvokeargument Name="commissionStageID" Value="#ValueList(qry_selectCommission.commissionStageID)#">
	</cfinvoke>
</cfif>

<cfinclude template="../../include/function/fn_datetime.cfm">
<cfinclude template="../../view/v_commission/var_commissionStageIntervalTypeList.cfm">
<cfinclude template="../../view/v_commission/var_commissionPeriodIntervalTypeList.cfm">
<cfinclude template="../../view/v_commission/lang_insertUpdateCommission.cfm">

<cfinclude template="formParam_insertUpdateCommission.cfm">
<cfinvoke component="#Application.billingMapping#data.Commission" method="maxlength_Commission" returnVariable="maxlength_Commission" />
<cfinvoke component="#Application.billingMapping#data.Commission" method="maxlength_CommissionStage" returnVariable="maxlength_CommissionStage" />
<cfinvoke component="#Application.billingMapping#data.Commission" method="maxlength_CommissionVolumeDiscount" returnVariable="maxlength_CommissionVolumeDiscount" />

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitInsertUpdateCommission")>
	<cfinclude template="formValidate_insertUpdateCommission.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<!--- generate array of structures for stages and volume discount settings --->
		<cfinclude template="act_insertUpdateCommission_struct.cfm">

		<cfif Variables.doAction is "insertCommission">
			<cfset Variables.commissionID_parent = 0>
			<cfset Variables.commissionID_trend = 0>
		<cfelse>
			<cfset Variables.commissionID_parent = URL.commissionID>
			<cfset Variables.commissionID_trend = qry_selectCommission.commissionID_trend>

			<cfinvoke Component="#Application.billingMapping#data.Commission" Method="updateCommission" ReturnVariable="isCommissionUpdated">
				<cfinvokeargument Name="commissionID" Value="#Variables.commissionID_parent#">
				<cfinvokeargument Name="commissionStatus" Value="0">
				<cfinvokeargument Name="commissionIsParent" Value="1">
			</cfinvoke>
		</cfif>

		<cfinvoke Component="#Application.billingMapping#data.Commission" Method="insertCommission" ReturnVariable="commissionID_new">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="commissionName" Value="#Form.commissionName#">
			<cfinvokeargument Name="commissionDescription" Value="#Form.commissionDescription#">
			<cfinvokeargument Name="commissionID_custom" Value="#Form.commissionID_custom#">
			<cfinvokeargument Name="commissionStatus" Value="#Form.commissionStatus#">
			<cfinvokeargument Name="commissionAppliesToExistingProducts" Value="#ListFirst(Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts, "_")#">
			<cfinvokeargument Name="commissionAppliesToCustomProducts" Value="#ListLast(Form.commissionAppliesToExistingProducts_commissionAppliesToCustomProducts, "_")#">
			<cfinvokeargument Name="commissionAppliesToInvoice" Value="#Form.commissionAppliesToInvoice#">
			<cfinvokeargument Name="commissionAppliedStatus" Value="0">
			<cfinvokeargument Name="commissionPeriodIntervalType" Value="#Form.commissionPeriodIntervalType#">
			<cfif Form.commissionPeriodIntervalType is "">
				<cfinvokeargument Name="commissionPeriodOrInvoiceBased" Value="1">
			<cfelse>
				<cfinvokeargument Name="commissionPeriodOrInvoiceBased" Value="0">
			</cfif>
			<cfinvokeargument Name="commissionDateBegin" Value="#Form.commissionDateBegin#">
			<cfif IsDefined("Form.commissionDateEnd")>
				<cfinvokeargument Name="commissionDateEnd" Value="#Form.commissionDateEnd#">
			</cfif>
			<cfinvokeargument Name="commissionID_parent" Value="#Variables.commissionID_parent#">
			<cfinvokeargument Name="commissionID_trend" Value="#Variables.commissionID_trend#">
			<cfinvokeargument Name="commissionIsParent" Value="0">
			<cfinvokeargument Name="commissionStageAmount" Value="#Variables.commissionStageAmount#">
			<cfinvokeargument Name="commissionStageAmountMinimum" Value="#Variables.commissionStageAmountMinimum#">
			<cfinvokeargument Name="commissionStageAmountMaximum" Value="#Variables.commissionStageAmountMaximum#">
			<cfinvokeargument Name="commissionStageDollarOrPercent" Value="#Variables.commissionStageDollarOrPercent#">
			<cfinvokeargument Name="commissionStageVolumeDiscount" Value="#Variables.commissionStageVolumeDiscount#">
			<cfinvokeargument Name="commissionStageVolumeDollarOrQuantity" Value="#Variables.commissionStageVolumeDollarOrQuantity#">
			<cfinvokeargument Name="commissionStageVolumeStep" Value="#Variables.commissionStageVolumeStep#">
			<cfinvokeargument Name="commissionStageInterval" Value="#Variables.commissionStageInterval#">
			<cfinvokeargument Name="commissionStageIntervalType" Value="#Variables.commissionStageIntervalType#">
			<cfinvokeargument Name="commissionStageText" Value="#Variables.commissionStageText#">
			<cfinvokeargument Name="commissionStageDescription" Value="#Variables.commissionStageDescription#">
			<cfinvokeargument Name="commissionVolumeDiscountQuantityMinimum" Value="#Variables.commissionVolumeDiscountQuantityMinimum#">
			<cfinvokeargument Name="commissionVolumeDiscountAmount" Value="#Variables.commissionVolumeDiscountAmount#">
			<cfinvokeargument Name="commissionVolumeDiscountIsTotalCommission" Value="#Variables.commissionVolumeDiscountIsTotalCommission#">
		</cfinvoke>

		<cfif Variables.doAction is "updateCommission"><!--- update commission only --->
			<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="copyCommissionTarget" ReturnVariable="isCommissionTargetCopied">
				<cfinvokeargument Name="commissionID_old" Value="#Variables.commissionID_parent#">
				<cfinvokeargument Name="commissionID_new" Value="#commissionID_new#">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.CommissionCategory" Method="copyCommissionCategory" ReturnVariable="isCommissionCategoryCopied">
				<cfinvokeargument Name="commissionID_old" Value="#Variables.commissionID_parent#">
				<cfinvokeargument Name="commissionID_new" Value="#commissionID_new#">
			</cfinvoke>

			<cfinvoke Component="#Application.billingMapping#data.CommissionProduct" Method="copyCommissionProduct" ReturnVariable="isCommissionProductCopied">
				<cfinvokeargument Name="commissionID_old" Value="#Variables.commissionID_parent#">
				<cfinvokeargument Name="commissionID_new" Value="#commissionID_new#">
			</cfinvoke>
		</cfif>

		<cfloop Index="field" List="commissionTargetsAllUsers,commissionTargetsAllGroups,commissionTargetsAllAffiliates,commissionTargetsAllCobrands,commissionTargetsAllCompanies,commissionTargetsAllVendors">
			<cfparam Name="Form.#field#" Default="0">
			<cfswitch expression="#field#">
			<cfcase value="commissionTargetsAllUsers"><cfset Variables.primaryTargetKey = "userID"></cfcase>
			<cfcase value="commissionTargetsAllGroups"><cfset Variables.primaryTargetKey = "groupID"></cfcase>
			<cfcase value="commissionTargetsAllAffiliates"><cfset Variables.primaryTargetKey = "affiliateID"></cfcase>
			<cfcase value="commissionTargetsAllCobrands"><cfset Variables.primaryTargetKey = "cobrandID"></cfcase>
			<cfcase value="commissionTargetsAllCompanies"><cfset Variables.primaryTargetKey = "companyID"></cfcase>
			<cfcase value="commissionTargetsAllVendors"><cfset Variables.primaryTargetKey = "vendorID"></cfcase>
			</cfswitch>

			<cfset Variables.primaryTargetID = Application.fn_GetPrimaryTargetID(Variables.primaryTargetKey)>
			<!--- new commission and target all OR updated commission and target all now, but not originally--->
			<cfif Form[field] is 1 and (Variables.doAction is "insertCommission" or (Variables.doAction is "updateCommission" and Not ListFind(ValueList(qry_selectCommissionTarget.primaryTargetID), Variables.primaryTargetID)))>
				<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="insertCommissionTarget" ReturnVariable="isCommissionTargetInserted">
					<cfinvokeargument Name="commissionID" Value="#commissionID_new#">
					<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Variables.primaryTargetKey)#">
					<cfinvokeargument Name="targetID" Value="0">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="commissionTargetStatus" Value="1">
				</cfinvoke>

			<!--- update existing commission AND originally target all, but not now --->
			<cfelseif Form[field] is 0 and Variables.doAction is "updateCommission" and ListFind(ValueList(qry_selectCommissionTarget.primaryTargetID), Variables.primaryTargetID)>
				<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="updateCommissionTarget" ReturnVariable="isCommissionTargetUpdated">
					<cfinvokeargument Name="commissionID" Value="#commissionID_new#">
					<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID(Variables.primaryTargetKey)#">
					<cfinvokeargument Name="targetID" Value="0">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="commissionTargetStatus" Value="0">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cflocation url="index.cfm?method=#URL.control#.viewCommission#Variables.urlParameters#&commissionID=#commissionID_new#&confirm_commission=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formName = "insertUpdateCommission">
<cfif Variables.doAction is "insertCommission">
	<cfset Variables.formAction = "index.cfm?method=#URL.method#" & Variables.urlParameters>
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCommission.formSubmitValue_insert>
<cfelse>
	<cfset Variables.formAction = "index.cfm?method=#URL.method#" & Variables.urlParameters & "&commissionID=#URL.commissionID#">
	<cfset Variables.formSubmitValue = Variables.lang_insertUpdateCommission.formSubmitValue_update>
</cfif>

<cfinclude template="../../view/v_commission/form_insertUpdateCommission.cfm">
<cfinclude template="../../view/v_commission/footer_insertUpdateCommission.cfm">

