<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<script language="JavaScript" type="text/javascript">
<!-- Begin
<cfif URL.displayExtendedForm is True>
	function setTitle () {
		if (document.#Variables.formName#.productLanguageName.value == "")
		document.#Variables.formName#.productLanguageName.value = document.#Variables.formName#.productName.value;
	
		if (document.#Variables.formName#.productLanguageLineItemName.value == "")
		document.#Variables.formName#.productLanguageLineItemName.value = document.#Variables.formName#.productName.value;
	}
</cfif>
</script>

<form method="post" name="#Variables.formName#" action="#Variables.formAction#"<cfif URL.displayExtendedForm is True> enctype="multipart/form-data"</cfif>>
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="0" cellpadding="2" class="TableText">
<tr>
	<td>Product Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="productStatus" value="1"<cfif Form.productStatus is 1> checked</cfif>> Active</label>&nbsp;
		<label style="color: red"><input type="radio" name="productStatus" value="0"<cfif Form.productStatus is not 1> checked</cfif>> Inactive</label> 
	</td>
</tr>
<tr>
	<td>Listed on Site? </td>
	<td>
		<label style="color: green"><input type="radio" name="productListedOnSite" value="1"<cfif Form.productListedOnSite is 1> checked</cfif>> Yes</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="productListedOnSite" value="0"<cfif Form.productListedOnSite is not 1> checked</cfif>> No</label> &nbsp;
		(<i>Product can be active but not listed if customers cannot view/order product directly</i>.)
	</td>
</tr>
<tr>
	<td>Can Be Purchased? </td>
	<td>
		<label style="color: green"><input type="radio" name="productCanBePurchased" value="1"<cfif Form.productCanBePurchased is 1> checked</cfif>> Yes</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="productCanBePurchased" value="0"<cfif Form.productCanBePurchased is not 1> checked</cfif>> No</label> &nbsp;
		(<i>Primarily intended for parent products where only child products are purchased and parent acts more like a category</i>.)
	</td>
</tr>
<tr>
	<td>Display Child Products? </td>
	<td>
		<label style="color: green"><input type="radio" name="productDisplayChildren" value="1"<cfif Form.productDisplayChildren is 1> checked</cfif>> Yes</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="productDisplayChildren" value="0"<cfif Form.productDisplayChildren is not 1> checked</cfif>> No</label> &nbsp;
		(<i>For parent products, specifies whether to display all child products when viewing the parent product.</i>.)
	</td>
</tr>
<tr>
	<td valign="top">Parent Product ID: </td>
	<td>
		<input type="text" name="productID_parent" value="#HTMLEditFormat(Form.productID_parent)#" size="6"> 
		(If product is child of existing product, enter parent product ID here.)<br>
		If child product, select type: 
		<label><input type="radio" name="productChildType" value="1"<cfif Form.productChildType is 1> checked</cfif>> Variation (e.g., size or color)</label> &nbsp; &nbsp; 
		<label><input type="radio" name="productChildType" value="2"<cfif Form.productChildType is 2> checked</cfif>> Add-on option</label>
	</td>
</tr>
<tr>
	<td valign="top">Product Bundle? </td>
	<td>
		<cfif URL.productID is 0>
			<label><input type="checkbox" name="productIsBundle" value="1"<cfif Form.productIsBundle is 1> checked</cfif>> 
			Check if this &quot;<i>product</i>&quot; is actually a bundle of multiple products.</label><br>
			(<i>The list of products in this bundle will be specified on a separate page.</i>)<br>
			<i>If checked, Product Status must be Inactive until after the products have been added to this bundle.</i>
		<cfelseif Form.productIsBundle is 1>
			Product <b>is</b> a bundle.
		<cfelse>
			Product is <b>not</b> bundle.
		</cfif>
	</td>
</tr>

<tr><td>&nbsp;</td></tr>

<tr>
	<td valign="top"><b>Product Name:</b> </td>
	<td>
		<input type="text" name="productName" value="#HTMLEditFormat(Form.productName)#" size="50" maxlength="#maxlength_Product.productName#"<cfif URL.displayExtendedForm is True> onBlur="javascript:setTitle();"</cfif>><br>
		(For internal use. Should be unique. Name displayed on site and invoices can be customized on <i>Language</i> tab.)
	</td>
</tr>
<tr>
	<td valign="top"><b>Price (default): </b></td>
	<td>
		$<input type="text" name="productPrice" value="#Application.fn_LimitPaddedDecimalZerosDollar(Form.productPrice)#" size="10"> (#maxlength_Product.productPrice# decimal places permitted)<br>
		<label><input type="checkbox" name="productPriceCallForQuote" value="1"<cfif Form.productPriceCallForQuote is 1> checked</cfif>> 
		Suggest customer should call for quote instead of displaying price.</label> (Assumes product &quot;Can Be Purchased&quot; is set to &quot;No&quot;, but not required.)
	</td>
</tr>

<tr>
	<td>Product Manager: </td>
	<td>
		<select name="userID_manager" size="1">
		<option value="0">-- SELECT PRODUCT MANAGER --</option>
		<cfloop Query="qry_selectUserCompanyList_company">
			<option value="#qry_selectUserCompanyList_company.userID#"<cfif Form.userID_manager is qry_selectUserCompanyList_company.userID> selected</cfif>>#HTMLEditFormat(qry_selectUserCompanyList_company.lastName)#, #HTMLEditFormat(qry_selectUserCompanyList_company.firstName)#</option>
		</cfloop>
		</select> (optional)
	</td>
</tr>
<tr>
	<td>Custom Product ID: </td>
	<td><input type="text" name="productID_custom" value="#HTMLEditFormat(productID_custom)#" size="20" maxlength="#maxlength_Product.productID_custom#"></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>Vendor: </td>
	<td>
		<select name="vendorID" size="1">
		<option value="0">-- SELECT VENDOR --</option>
		<cfloop Query="qry_selectVendorList">
			<option value="#qry_selectVendorList.vendorID#"<cfif Form.vendorID is qry_selectVendorList.vendorID> selected</cfif>>#HTMLEditFormat(qry_selectVendorList.vendorName)# <cfif qry_selectVendorList.vendorCode is not "">(#HTMLEditFormat(qry_selectVendorList.vendorCode)#)</cfif></option>
		</cfloop>
		</select> (optional)
	</td>
</tr>
<tr>
	<td>Vendor Product ID: </td>
	<td><input type="text" name="productCode" value="#HTMLEditFormat(Form.productCode)#" size="20" maxlength="#maxlength_Product.productCode#"></td>
</tr>

<tr><td>&nbsp;</td></tr>
<tr>
	<td>In Stock? </td>
	<td>
		<label><input type="radio" name="productInWarehouse" value="1"<cfif Form.productInWarehouse is 1> checked</cfif>> Yes</label>&nbsp;
		<label><input type="radio" name="productInWarehouse" value="0"<cfif Form.productInWarehouse is not 1> checked</cfif>> No</label>
	</td>
</tr>
<tr>
	<td>Shipping Weight: </td>
	<td><input type="text" name="productWeight" value="#HTMLEditFormat(Form.productWeight)#" size="10"> (in pounds; #maxlength_Product.productWeight# decimal places permitted)</td>
</tr>
<tr>
	<td>Catalog Page ##: </td>
	<td><input type="text" name="productCatalogPageNumber" value="#HTMLEditFormat(Form.productCatalogPageNumber)#" size="10"> (if in paper catalog)</td>
</tr>
<tr valign="top">
	<td>Template: </td>
	<td>
		<cfset Variables.isCurrentTemplateDisabled = True>
		<select name="templateFilename" size="1">
		<option value="">-- SELECT TEMPLATE --</option>
		<cfloop Query="qry_selectTemplateList">
			<option value="#qry_selectTemplateList.templateFilename#"<cfif Form.templateFilename is qry_selectTemplateList.templateFilename> selected<cfset Variables.isCurrentTemplateDisabled = False></cfif>>#HTMLEditFormat(qry_selectTemplateList.templateName)#</option>
		</cfloop>
		</select> (used to display product to customers)
		<cfif URL.productID is not 0 and Form.templateFilename is not "" and Variables.isCurrentTemplateDisabled is True>
			<div class="MainText"><font color="red"><b>Note: The current template is no longer active. Please select another template.</b></font></div>
		</cfif>
	</td>
</tr>
</table>

<cfif URL.displayExtendedForm is True>
	<p>
	<table border="0" cellspacing="0" cellpadding="2" class="TableText">
	<tr valign="top">
		<td>Category: </td>
		<td>
			<select name="categoryID" <cfif Variables.categoryIsMultiple is False>size="1"<cfelse>size="5" multiple</cfif>>
			<cfloop Query="qry_selectCategoryList">
				<option value="#qry_selectCategoryList.categoryID#"<cfif ListFind(Form.categoryID, qry_selectCategoryList.categoryID)> selected</cfif>><cfif qry_selectCategoryList.categoryLevel gt 2>#RepeatString("- ", qry_selectCategoryList.categoryLevel - 2)#</cfif>#qry_selectCategoryList.categoryName#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="2" class="TableText">
	<tr>
		<td>Product Name as displayed on site: </td>
		<td><input type="text" name="productLanguageName" value="#HTMLEditFormat(Form.productLanguageName)#" size="50" maxlength="#maxlength_ProductLanguage.productLanguageName#"></td>
	</tr>
	<tr>
		<td>Product Name as listed on invoice: </td>
		<td><input type="text" name="productLanguageLineItemName" value="#HTMLEditFormat(Form.productLanguageLineItemName)#" size="50" maxlength="#maxlength_ProductLanguage.productLanguageName#"></td>
	</tr>
	<tr valign="top">
		<td colspan="2">
			Product description as displayed on site: 
			<select name="productLanguageDescriptionHtml" size="1">
			<option value="0"<cfif Form.productLanguageDescriptionHtml is not 1> selected</cfif>>text</option>
			<option value="1"<cfif Form.productLanguageDescriptionHtml is 1> selected</cfif>>html</option>
			</select>
			<cfif maxlength_ProductLanguage.productLanguageDescription is 0>(no size limit)<cfelse>(maximum #maxlength_ProductLanguage.productLanguageDescription# characters)</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="2"><textarea name="productLanguageDescription" rows="10" cols="90" wrap="soft">#HTMLEditFormat(Form.productLanguageDescription)#</textarea></td>
	</tr>
	</table>
	</p>

	<input type="hidden" name="submitImage" value="True">
	<cfif IsDefined("Form.imageUploaded")>
		<input type="hidden" name="imageUploaded" value="#HTMLEditFormat(Form.imageUploaded)#">
	</cfif>
	<cfif IsDefined("Form.imageUploaded_thumbnail")>
		<input type="hidden" name="imageUploaded_thumbnail" value="#HTMLEditFormat(Form.imageUploaded_thumbnail)#">
	</cfif>

	<p>
	<table border="0" cellspacing="0" cellpadding="2" class="MainText">
	<tr>
		<td colspan="2"><b>Image:</b> </td>
	</tr>
	<tr>
		<td valign="top"><i>Upload File</i>: </td>
		<td>
			<input type="file" name="imageFile" size="45"><br>
			To Directory: 
			<select name="imageDirectory" size="1">
			<option value="">-- DEFAULT --</option>
			<cfloop Index="imageDir" List="#Variables.imageSubDirectoryList#">
				<option value="#HTMLEditFormat(imageDir)#"<cfif imageDir is Form.imageDirectory> selected</cfif>>#HTMLEditFormat(imageDir)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td><i><b>or</b> Enter URL</i>: </td>
		<td><input type="text" name="imageURL" value="#HTMLEditFormat(Form.imageURL)#" size="50" maxlength="#maxlength_Image.imageURL#"></td>
	</tr>
	<tr>
		<td>Category Page: </td>
		<td><label><input type="checkbox" name="imageDisplayCategory" value="1"<cfif Form.imageDisplayCategory is 1> checked</cfif>> Display image on category page and search results</label></td>
	</tr>

	<tr>
		<td colspan="2">
			<br><b>Thumbnail:</b><br>
			<font class="TableText"><i>Displayed in place of full image. Links to full image in a pop-up window.</i></font>
		</td>
	</tr>
	<tr>
		<td valign="top"><i>Upload File</i>: </td>
		<td>
			<input type="file" name="imageFile_thumbnail" size="45"><br>
			To Directory: 
			<select name="imageDirectory_thumbnail" size="1">
			<option value="">-- DEFAULT --</option>
			<cfloop Index="imageDir" List="#Variables.imageSubDirectoryList#">
				<option value="#HTMLEditFormat(imageDir)#"<cfif imageDir is Form.imageDirectory_thumbnail> selected</cfif>>#HTMLEditFormat(imageDir)#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td><i><b>or</b> Enter URL</i>: </td>
		<td><input type="text" name="imageURL_thumbnail" value="#HTMLEditFormat(Form.imageURL_thumbnail)#" size="50" maxlength="#maxlength_Image.imageURL#"></td>
	</tr>
	<tr>
		<td>Category Page: </td>
		<td><label><input type="checkbox" name="imageDisplayCategory_thumbnail" value="1"<cfif Form.imageDisplayCategory_thumbnail is 1> checked</cfif>> Display image on category page and search results</label></td>
	</tr>
	</table>
	</p>
</cfif>

<!--- Insert custom fields and custom status forms if necessary --->
<cfif isStatusExist is True>
	<cfinvoke component="#objInsertStatusHistory#" method="form_insertStatusHistory" returnVariable="isStatusHistoryForm" />
</cfif>
<cfif isCustomFieldValueExist is True>
	<cfinvoke component="#objInsertCustomFieldValue#" method="form_insertCustomFieldValue" returnVariable="isCustomFieldValueForm" />
</cfif>

<p><input type="submit" name="submitProduct" value="#HTMLEditFormat(Variables.formSubmitValue)#"></p>
</form>
</cfoutput>

