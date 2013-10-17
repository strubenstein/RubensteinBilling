<cfoutput>
<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="companyListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchField" value="productName,productDescription,productCode">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitProductList" value="Submit">
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
	<td colspan="4" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td>
		Search Text:<br><input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"><br>
		&nbsp; &nbsp; &nbsp; <label><input type="checkbox" name="searchField" value="productName"<cfif ListFind(Form.searchField, "productName")> checked</cfif>>Product Name</label><br>
		&nbsp; &nbsp; &nbsp; <label><input type="checkbox" name="searchField" value="productDescription"<cfif ListFind(Form.searchField, "productDescription")> checked</cfif>>Summary/Description</label><br>
		&nbsp; &nbsp; &nbsp; <label><input type="checkbox" name="searchField" value="productCode"<cfif ListFind(Form.searchField, "productCode")> checked</cfif>>Internal/Vendor ID</label><br>
		<br>
		Price Range:<br>
		$<input type="text" name="productPrice_min" value="#HTMLEditFormat(Form.productPrice_min)#" size="5" class="TableText">
		 to 
		$<input type="text" name="productPrice_max" value="#HTMLEditFormat(Form.productPrice_max)#" size="5" class="TableText"><br>
		<br>
	</td>
	<td>
		<select name="categoryID" size="1" class="SearchSelect">
		<option value="">-- SELECT CATEGORY --</option>
		<option value="0"<cfif Form.categoryID is -1> selected</cfif>>-- NOT LISTED IN ANY CATEGORIES --</option>
		<cfloop Query="qry_selectCategoryList">
			<option value="#qry_selectCategoryList.categoryID#"<cfif Form.categoryID is qry_selectCategoryList.categoryID> selected</cfif>>#RepeatString(" - ", qry_selectCategoryList.categoryLevel - 1)##HTMLEditFormat(qry_selectCategoryList.categoryName)#</option>
		</cfloop>
		</select><br>
		<label><input type="checkbox" name="categoryID_sub" value="1"<cfif Form.categoryID_sub is 1> checked</cfif>>Include sub-categories</label><br>
		<label><input type="checkbox" name="categoryID_multiple" value="1"<cfif Form.categoryID_multiple is 1> checked</cfif>>Listed in multiple categories</label><br>
		<br>
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
		<cfif qry_selectVendorList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<cfif URL.control is "vendor" and IsDefined("qry_selectVendor")>
				<b><i>Vendor</i>: #qry_selectVendor.vendorName#<cfif qry_selectVendor.vendorCode is not ""> (#qry_selectVendor.vendorCode#)</cfif></b><br>
			<cfelse>
				<select name="vendorID" size="1" class="SearchSelect">
				<option value="">-- SELECT VENDOR --</option>
				<option value="0">-- NO SPECIFIED VENDOR --</option>
				<cfloop Query="qry_selectVendorList">
					<option value="#qry_selectVendorList.vendorID#"<cfif Form.vendorID is qry_selectVendorList.vendorID> selected</cfif>>#HTMLEditFormat(qry_selectVendorList.vendorName)#<cfif qry_selectVendorList.vendorCode is not ""> (#HTMLEditFormat(qry_selectVendorList.vendorCode)#)</cfif></option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
		<cfif qry_selectProductManagerList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="userID_manager" size="1" class="SearchSelect">
			<option value="">-- SELECT PRODUCT MANAGER --</option>
			<option value="0">-- NO PRODUCT MANAGER --</option>
			<cfloop Query="qry_selectProductManagerList">
				<option value="#qry_selectProductManagerList.userID_manager#"<cfif Form.userID_manager is qry_selectProductManagerList.userID_manager> selected</cfif>>#HTMLEditFormat(qry_selectProductManagerList.lastName)#, #HTMLEditFormat(qry_selectProductManagerList.firstName)#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif Application.fn_IsUserAuthorized("exportProducts")>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="productIsExported" size="1" class="SearchSelect">
			<option value="-1">-- SELECT EXPORT STATUS --</option>
			<option value=""<cfif Form.productIsExported is ""> selected</cfif>>Not Exported</option>
			<option value="0"<cfif Form.productIsExported is 0> selected</cfif>>Exported - Awaiting Import Confirmation</option>
			<option value="1"<cfif Form.productIsExported is 1> selected</cfif>>Exported - Import Confirmed</option>
			</select><br>
		</cfif>
		<br>
		Catalog Page ##: <input type="text" name="productCatalogPageNumber" value="#HTMLEditFormat(Form.productCatalogPageNumber)#" size="2" class="TableText">
		<span class="SmallText">&nbsp; 1 <i>or</i> 2-4 <i>or</i> 5,8,9</span>
	</td>

	<cfset Variables.booleanList_value = "productStatus,productListedOnSite,productIsBundle,productInBundle,productIsRecommended,productHasRecommendation,productCanBePurchased,productInWarehouse,productWeight,productHasCustomPrice,productPriceCallForQuote,productHasImage,productIsDateRestricted,productHasChildren,productID_parent,productHasSpec,productHasParameter,productHasParameterException">
	<cfset Variables.booleanList_label = "Status is active,Listed on site,<i>Is</i> a bundle,<i>In</i> a bundle,Recommend<i>ed</i>,Recommend<i>s</i>,Can be purchased,Is in stock,Has weight value,Has custom pricing,Call for price quote,Has image,Has date restriction,<i>Has</i> child product(s),<i>Is</i> child product,Has spec(s),Has parameter(s),Has parameter exception">

	<td align="center">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<cfif thisBoolean is "productID_parent"><cfset Variables.yesValue = -1><cfelse><cfset Variables.yesValue = 1></cfif>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="#Variables.yesValue#"<cfif Form[thisBoolean] is Variables.yesValue> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("9", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
</tr>

<tr>
	<td colspan="5" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitProductList" value="Submit">
		 &nbsp; &nbsp; 
		<input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>
