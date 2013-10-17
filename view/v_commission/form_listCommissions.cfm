<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="commissionListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="commissionSearchField" value="commissionName,commissionDescription,commissionID_custom">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="commissionSearchText" value="#HTMLEditFormat(Form.commissionSearchText)#" size="25" class="TableText"> <input type="submit" name="submitCommissionList" value="Submit">
</td>
<td align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
</tr>
</form>
</table>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800" id="advancedSearch"<cfif Session.showAdvancedSearch is False> style="display:none;"</cfif>>
<form method="post" name="#Variables.formName#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="True">
<tr bgcolor="ccccff" class="MainText">
	<td colspan="2"><b>Advanced Search</b></td>
	<td colspan="2" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>
		Commission Text Search:<br>
		<input type="text" name="commissionSearchText" value="#HTMLEditFormat(Form.commissionSearchText)#" size="25" class="TableText">
		<div class="SmallText">
		<label><input type="checkbox" name="commissionSearchField" value="commissionName"<cfif ListFind(Form.commissionSearchField, "commissionName")> checked</cfif>>Commission Name</label><br>
		<label><input type="checkbox" name="commissionSearchField" value="commissionDescription"<cfif ListFind(Form.commissionSearchField, "commissionDescription")> checked</cfif>>Commission Description</label><br>
		<label><input type="checkbox" name="commissionSearchField" value="commissionID_custom"<cfif ListFind(Form.commissionSearchField, "commissionID_custom")> checked</cfif>>Custom Commission ID</label>
		</div>
		<br>
		Product Text Search:<br>
		<input type="text" name="productSearchText" value="#HTMLEditFormat(Form.productSearchText)#" size="25" class="TableText"><br>
		<div class="SmallText">
		<label><input type="checkbox" name="productSearchField" value="productName"<cfif ListFind(Form.productSearchField, "productName")> checked</cfif>>Product Name</label><br>
		<label><input type="checkbox" name="productSearchField" value="productID"<cfif ListFind(Form.productSearchField, "productID")> checked</cfif>>Product ID</label><br>
		<label><input type="checkbox" name="productSearchField" value="productID_custom"<cfif ListFind(Form.productSearchField, "productID_custom")> checked</cfif>>Custom Product/Vendor ID</label>
		</div>
	</td>
	<td>
		<select name="commissionPeriodIntervalType" size="1">
		<option value="">-- CALCULATION BASIS --</option>
		<option value="0"<cfif Form.commissionPeriodIntervalType is 0> selected</cfif>>Invoice</option>
		<option value="m"<cfif Form.commissionPeriodIntervalType is "m"> selected</cfif>>Monthly</option>
		<option value="q"<cfif Form.commissionPeriodIntervalType is "q"> selected</cfif>>Quarterly</option>
		</select><br>
		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
		Has at least one stage with interval:<br>
		&nbsp; &nbsp;<input type="text" name="commissionStageInterval_min" value="#HTMLEditFormat(Form.commissionStageInterval_min)#" size="2"> to 
		<input type="text" name="commissionStageInterval_max" value="#HTMLEditFormat(Form.commissionStageInterval_max)#" size="2"> 
		<select name="commissionStageIntervalType" size="1">
		<option value="">-- INTERVAL --</option>
		<cfloop Index="intervalTypeCount" From="1" To="#ListLen(Variables.commissionStageIntervalTypeList_value)#">
			<option value="#ListGetAt(Variables.commissionStageIntervalTypeList_value, intervalTypeCount)#"<cfif Form.commissionStageIntervalType is ListGetAt(Variables.commissionStageIntervalTypeList_value, intervalTypeCount)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.commissionStageIntervalTypeList_label, intervalTypeCount))#(s)</option>
		</cfloop>
		</select><br>

		<cfif qry_selectStatusList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="statusID" size="1" class="SearchSelect">
			<option value="">-- SELECT CUSTOM STATUS --</option>
			<option value="0"<cfif Form.statusID is 0> selected</cfif>>-- NO SPECIFIED STATUS --</option>
			<cfloop Query="qry_selectStatusList">
				<option value="#qry_selectStatusList.statusID#"<cfif Form.statusID is qry_selectStatusList.statusID> selected</cfif>>#qry_selectStatusList.statusOrder#. #HTMLEditFormat(Left(qry_selectStatusList.statusTitle, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif IsDefined("qry_selectCategoryList") and qry_selectCategoryList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
			<cfif URL.control is "category" and IsDefined("qry_selectCategory")>
				<b><i>Category</i>: #qry_selectCategory.categoryName#</b><br>
			<cfelse>
				<select name="categoryID" size="1" class="SearchSelect">
				<option value="0">-- SELECT CATEGORY --</option>
				<cfloop Query="qry_selectCategoryList">
					<option value="#qry_selectCategoryList.categoryID#"<cfif Form.categoryID is qry_selectCategoryList.categoryID> selected</cfif>>#RepeatString(" - ", qry_selectCategoryList.categoryLevel - 1)##HTMLEditFormat(Left(qry_selectCategoryList.categoryName, 25))#</option>
				</cfloop>
				</select><br>
			</cfif>
			&nbsp; &nbsp;<label><input type="checkbox" name="categoryID_sub" value="1"<cfif Form.categoryID_sub is 1> checked</cfif>>Include sub-categories</label><br>
		</cfif>
		<cfif IsDefined("qry_selectVendorList") and qry_selectVendorList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
			<cfif URL.control is "vendor" and IsDefined("qry_selectVendor")>
				<b><i>Vendor</i>: #qry_selectVendor.vendorName#<cfif qry_selectVendor.vendorCode is not ""> (#qry_selectVendor.vendorCode#)</cfif></b><br>
			<cfelse>
				<select name="vendorID" size="1" class="SearchSelect">
				<option value="">-- PRODUCT VENDOR --</option>
				<option value="0">-- NO SPECIFIED VENDOR --</option>
				<cfloop Query="qry_selectVendorList">
					<option value="#qry_selectVendorList.vendorID#"<cfif Form.vendorID is qry_selectVendorList.vendorID> selected</cfif>>#HTMLEditFormat(qry_selectVendorList.vendorName)#<cfif qry_selectVendorList.vendorCode is not ""> (#HTMLEditFormat(qry_selectVendorList.vendorCode)#)</cfif></option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif IsDefined("qry_selectGroupList") and qry_selectGroupList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "group" and IsDefined("qry_selectGroup")>
				<b><i>Group</i>: #qry_selectGroup.groupName#</b><br>
			<cfelse>
				<select name="groupID" size="1" class="SearchSelect">
				<option value="">-- GROUP TARGET --</option>
				<cfloop Query="qry_selectGroupList">
					<option value="#qry_selectGroupList.groupID#"<cfif Form.groupID is qry_selectGroupList.groupID> selected</cfif>>#HTMLEditFormat(Left(qry_selectGroupList.groupName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif IsDefined("qry_selectAffiliateList") and qry_selectAffiliateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "affiliate" and IsDefined("qry_selectAffiliate")>
				<b><i>Affiliate</i>: #qry_selectAffiliate.affiliateName#</b><br>
			<cfelse>
				<select name="affiliateID" size="1" class="SearchSelect">
				<option value="">-- AFFILIATE TARGET --</option>
				<cfloop Query="qry_selectAffiliateList">
					<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif IsDefined("qry_selectCobrandList") and qry_selectCobrandList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "cobrand" and IsDefined("qry_selectCobrand")>
				<b><i>Cobrand</i>: #qry_selectCobrand.cobrandName#</b><br>
			<cfelse>
				<select name="cobrandID" size="1" class="SearchSelect">
				<option value="">-- COBRAND TARGET --</option>
				<cfloop Query="qry_selectCobrandList">
					<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>

		<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="6" alt="" border="0"><br>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "commissionDateFrom_date", Form.commissionDateFrom_date, "commissionDateFrom_hh", Form.commissionDateFrom_hh, False, 0, "commissionDateFrom_tt", Form.commissionDateFrom_tt, True)#</td>
		</tr>
		<tr>
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "commissionDateTo_date", Form.commissionDateTo_date, "commissionDateTo_hh", Form.commissionDateTo_hh, False, 0, "commissionDateTo_tt", Form.commissionDateTo_tt, True)#</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="SmallText">
				<label><input type="checkbox" name="commissionDateType" value="commissionDateBegin"<cfif ListFind(Form.commissionDateType, "commissionDateBegin")> checked</cfif>>Begins</label> &nbsp; 
				<label><input type="checkbox" name="commissionDateType" value="commissionDateEnd"<cfif ListFind(Form.commissionDateType, "commissionDateEnd")> checked</cfif>>Ends</label> &nbsp; 
				<label><input type="checkbox" name="commissionDateType" value="commissionDateCreated"<cfif ListFind(Form.commissionDateType, "commissionDateCreated")> checked</cfif>>Created</label><br>
				<label><input type="checkbox" name="commissionDateType" value="commissionDateUpdated"<cfif ListFind(Form.commissionDateType, "commissionDateUpdated")> checked</cfif>>Updated / Made Inactive</label>
			</td>
		</tr>
		</table>
	</td>

	<cfset Variables.booleanList_value = "commissionStatus,commissionAppliedStatus,commissionBeforeBeginDate,commissionHasEndDate,commissionHasCustomID,commissionHasMultipleStages,commissionStageDollarOrPercent,commissionStageVolumeDiscount,commissionStageVolumeDollarOrQuantity,commissionStageVolumeStep,commissionAppliesToInvoice,commissionAppliesToExistingProducts,commissionAppliesToCustomProducts,commissionAppliesToProduct,commissionAppliesToCategory,commissionHasGroupTarget,commissionHasUserTarget,commissionTargetsAllUsers,commissionHasAffiliateTarget,commissionTargetsAllAffiliates,commissionHasCobrandTarget,commissionTargetsAllCobrands,commissionHasVendorTarget,commissionTargetsAllVendors"><!--- commissionIsParent,commissionAppliesToProductChildren,commissionAppliesToCategoryChildren,commissionHasCompanyTarget,commissionTargetsAllCompanies,commissionTargetsAllGroups, --->
	<cfset Variables.booleanList_label = "Status is active,Has been used,Not yet live,Has end date,Has custom ID,Has multiple stages,Use $ method (not %),Has volume options,Volume based on $ value,Volume in step fashion,Applies to entire invoice,Applies to existing products,Applies to custom products,Applies to product(s),Applies to category(s),Has group target(s),Has user target(s),Targets all users,Has affiliate target(s),Targets all affiliates,Has cobrand target(s),Targets all cobrands,Has vendor target(s),Targets all vendors"><!--- Has been updated,Applies to prod. children,Applies to cat. children,Has company target(s),Targets all companies,,Has region target(s),Targets all regions,Targets all groups, --->

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("13", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>
<tr bgcolor="ccccff"><!--- lime --->
	<td align="center" colspan="4">
		<b>Display Per Page:</b> <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitCommissionList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</table>
</form>
</cfoutput>
