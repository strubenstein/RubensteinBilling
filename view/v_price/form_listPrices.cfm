<!---  
priceApproved
priceStageAmount
priceSubscriptionUpdateExisting
priceSubscriptionUpdateRenewal
vendorID (product by that vendor)
regionID
priceQuantityMinimumPerOrder
priceQuantityMaximumPerCustomer
priceQuantityMaximumAllCustomers
--->

<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="priceListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="priceSearchField" value="priceName,priceDescription,priceCode,priceID_custom">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="priceSearchText" value="#HTMLEditFormat(Form.priceSearchText)#" size="25" class="TableText"> <input type="submit" name="submitPriceList" value="Submit">
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
		Price Text Search:<br>
		<input type="text" name="priceSearchText" value="#HTMLEditFormat(Form.priceSearchText)#" size="25" class="TableText">
		<div class="SmallText">
		<label><input type="checkbox" name="priceSearchField" value="priceName"<cfif ListFind(Form.priceSearchField, "priceName")> checked</cfif>>Price Name</label> &nbsp;
		<label><input type="checkbox" name="priceSearchField" value="priceCode"<cfif ListFind(Form.priceSearchField, "priceCode")> checked</cfif>>Price Code</label><br>
		<label><input type="checkbox" name="priceSearchField" value="priceDescription"<cfif ListFind(Form.priceSearchField, "priceDescription")> checked</cfif>>Price Description</label><br>
		<label><input type="checkbox" name="priceSearchField" value="priceID_custom"<cfif ListFind(Form.priceSearchField, "priceID_custom")> checked</cfif>>Custom Price ID</label>
		</div>
		<br>
		Product Text Search:<br>
		<input type="text" name="productSearchText" value="#HTMLEditFormat(Form.productSearchText)#" size="25" class="TableText"><br>
		<div class="SmallText">
		<label><input type="checkbox" name="productSearchField" value="productName"<cfif ListFind(Form.productSearchField, "productName")> checked</cfif>>Product Name</label><br>
		<label><input type="checkbox" name="productSearchField" value="productID"<cfif ListFind(Form.productSearchField, "productID")> checked</cfif>>Product ID</label><br>
		<label><input type="checkbox" name="productSearchField" value="productID_custom"<cfif ListFind(Form.productSearchField, "productID_custom")> checked</cfif>>Custom Product/Vendor ID</label>
		</div>
		<br>
		Price Stated As:
		<div class="SmallText">
		<label><input type="checkbox" name="priceStageDollarOrPercent_priceStageNewOrDeduction" value="1_1"<cfif Form.priceStageDollarOrPercent_priceStageNewOrDeduction is "1_1"> checked</cfif>> <b>%</b> <i>Discount</i> off normal price</label><br><!--- percent/deduction ---> 
		<label><input type="checkbox" name="priceStageDollarOrPercent_priceStageNewOrDeduction" value="1_0"<cfif Form.priceStageDollarOrPercent_priceStageNewOrDeduction is "1_0"> checked</cfif>> <b>%</b> <i>Of</i> the normal price</label><br><!--- percent/new ---> 
		<label><input type="checkbox" name="priceStageDollarOrPercent_priceStageNewOrDeduction" value="0_1"<cfif Form.priceStageDollarOrPercent_priceStageNewOrDeduction is "0_1"> checked</cfif>> <b>$</b> Discount off normal price</label><br><!--- dollar/deduction ---> 
		<label><input type="checkbox" name="priceStageDollarOrPercent_priceStageNewOrDeduction" value="0_0"<cfif Form.priceStageDollarOrPercent_priceStageNewOrDeduction is "0_0"> checked</cfif>> <b>$</b> = New price (product only)</label><br><!--- dollar/new ---> 
		</div>
	</td>
	<td>
		Has at least one price stage with interval:<br>
		&nbsp; &nbsp;<input type="text" name="priceStageInterval_min" value="#HTMLEditFormat(Form.priceStageInterval_min)#" size="2"> to 
		<input type="text" name="priceStageInterval_max" value="#HTMLEditFormat(Form.priceStageInterval_max)#" size="2"> 
		<select name="priceStageIntervalType" size="1">
		<option value="">-- INTERVAL --</option>
		<cfloop Index="intervalTypeCount" From="1" To="#ListLen(Variables.priceStageIntervalTypeList_value)#">
			<option value="#ListGetAt(Variables.priceStageIntervalTypeList_value, intervalTypeCount)#"<cfif Form.priceStageIntervalType is ListGetAt(Variables.priceStageIntervalTypeList_value, intervalTypeCount)> selected</cfif>>#HTMLEditFormat(ListGetAt(Variables.priceStageIntervalTypeList_label, intervalTypeCount))#(s)</option>
		</cfloop>
		</select><br>

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
			<td nowrap>#fn_FormSelectDateTime(Variables.formName, "priceDateFrom_date", Form.priceDateFrom_date, "priceDateFrom_hh", Form.priceDateFrom_hh, False, 0, "priceDateFrom_tt", Form.priceDateFrom_tt, True)#</td>
		</tr>
		<tr>
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "priceDateTo_date", Form.priceDateTo_date, "priceDateTo_hh", Form.priceDateTo_hh, False, 0, "priceDateTo_tt", Form.priceDateTo_tt, True)#</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="SmallText">
				<label><input type="checkbox" name="priceDateType" value="priceDateBegin"<cfif ListFind(Form.priceDateType, "priceDateBegin")> checked</cfif>>Begins</label> &nbsp; 
				<label><input type="checkbox" name="priceDateType" value="priceDateEnd"<cfif ListFind(Form.priceDateType, "priceDateEnd")> checked</cfif>>Ends</label> &nbsp; 
				<label><input type="checkbox" name="priceDateType" value="priceDateCreated"<cfif ListFind(Form.priceDateType, "priceDateCreated")> checked</cfif>>Created</label><br>
				<label><input type="checkbox" name="priceDateType" value="priceDateUpdated"<cfif ListFind(Form.priceDateType, "priceDateUpdated")> checked</cfif>>Updated / Made Inactive</label>
			</td>
		</tr>
		</table>
	</td>

	<cfset Variables.booleanList_value = "priceStatus,priceIsParent,priceAppliedStatus,priceAppliedToSubscription,priceBeforeBeginDate,priceHasEndDate,priceHasCustomID,priceHasCode,priceCodeRequired,priceStageVolumeDiscount,priceStageVolumeDollarOrQuantity,priceStageVolumeStep,priceHasMultipleStages,priceAppliesToInvoice,priceAppliesToCategory,priceAppliesToCategoryChildren,priceAppliesToProduct,priceAppliesToProductChildren,priceAppliesToAllProducts,priceAppliesToAllCustomers,priceHasGroupTarget,priceHasAffiliateTarget,priceHasCobrandTarget,priceHasCompanyTarget,priceHasUserTarget"><!--- ,priceHasQuantityMinimumPerOrder,priceHasQuantityMaximumPerCustomer,priceHasQuantityMaximumAllCustomers,priceHasRegionTarget --->
	<cfset Variables.booleanList_label = "Status is active,Has been updated,Has been used,Used for subscription,Not yet live,Has end date,Has custom ID,Has special code,Special code is required,Is volume discount,Volume based on $ value,Volume in step fashion,Has multiple stages,Applies to invoice,Applies to category,Applies to cat. children,Applies to product,Applies to prod. children,Applies to all products,Applies to all customers,Has group target(s),Has affiliate target(s),Has cobrand target(s),Has company target(s),Has user target(s)"><!--- ,Has min. qty per order,Has max. qty <i>per</i> customer,Has max. qty <i>all</i> customers,Has region target(s) --->

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
		<input type="submit" name="submitPriceList" value="Submit"> &nbsp; &nbsp; <input type="reset" value="Reset">
	</td>
</tr>
</table>
</form>
</cfoutput>
