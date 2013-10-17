<cfoutput>
<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Name: </td>
	<td>#qry_selectProduct.productName#</td>
</tr>
<cfif qry_selectProduct.productID_custom is not "">
	<tr>
		<td>Custom ID: </td>
		<td>#qry_selectProduct.productID_custom#</td>
	</tr>
</cfif>
<tr>
	<td>Price: </td>
	<td>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectProduct.productPrice)#</td>
</tr>
<tr>
	<td>Status: </td>
	<td><cfif qry_selectProduct.productStatus is 1>Active<cfelse>Not Active</cfif></td>
</tr>
<tr>
	<td>Listed On Site: </td>
	<td><cfif qry_selectProduct.productListedOnSite is 1>Yes, listed on site<cfelse>No, not listed on site</cfif></td>
</tr>

<tr>
	<td>Has Specs: </td>
	<td><cfif qry_selectProduct.productHasSpec is 1>Yes, it has listed specifications<cfelse>No, it has not listed specifications</cfif></td>
</tr>
<tr>
	<td>Has Parameters: </td>
	<td>
		<cfif qry_selectProduct.productHasParameter is 0>
			No, it has no parameter options
		<cfelse>
			Yes, it has parameter options<cfif qry_selectProduct.productHasParameterException is 0>, but no exceptions.<cfelse> as well as exceptions.</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Can Be Purchased: </td>
	<td><cfif qry_selectProduct.productCanBePurchased is 1>Yes, this product can be purchased<cfelse>No, this product is primarily a parent product for grouping purposes</cfif></td>
</tr>
<cfif qry_selectProduct.productHasChildren is 1>
	<tr>
		<td>Displays Child Products: </td>
		<td><cfif qry_selectProduct.productDisplayChildren is 1>Yes, child products are listed on product page<cfelse>No, child products are listed separately</cfif></td>
	</tr>
</cfif>
<cfif qry_selectProduct.productID_parent is not 0>
	<tr>
		<td>Parent Product: </td>
		<td>
			#qry_selectProductSummary.parentProductName#
			<cfif Application.fn_IsUserAuthorized("viewProduct")>
				 (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectProduct.productID_parent#" class="plainlink">go</a>)
			 </cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectProduct.vendorID is not 0>
	<tr>
		<td>Vendor: </td>
		<td>
			#qry_selectVendor.vendorName#<cfif qry_selectVendor.vendorCode is not "">(#qry_selectVendor.vendorCode#)</cfif>
			<cfif Application.fn_IsUserAuthorized("viewVendor")>
				 (<a href="index.cfm?method=vendor.viewVendor&vendorID=#qry_selectProduct.vendorID#" class="plainlink">go</a>)</td>
			</cfif>
	</tr>
</cfif>
<cfif qry_selectProduct.productCode is not "">
	<tr>
		<td>Vendor Product ID: </td>
		<td>#qry_selectProduct.productCode#</td>
	</tr>
</cfif>
<cfif qry_selectProduct.userID_manager is not 0 and IsDefined("userRow_manager") and userRow_manager is not 0>
	<tr>
		<td>Manager: </td>
		<td>
			#qry_selectUser.firstName[userRow_manager]# #qry_selectUser.lastName[userRow_manager]# 
			<cfif Application.fn_IsUserAuthorized("viewUser")>
				 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectProduct.userID_manager#" class="plainlink">go</a>)
			</cfif>
		</td>
	</tr>
</cfif>
<tr>
	<td>Created: </td>
	<td>
		#DateFormat(qry_selectProduct.productDateCreated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectProduct.productDateCreated, "hh:mm tt")#
		<cfif qry_selectProduct.userID_author is not 0 and IsDefined("userRow_author") and userRow_author is not 0>
			#qry_selectUser.firstName[userRow_author]# #qry_selectUser.lastName[userRow_author]# 
			<cfif Application.fn_IsUserAuthorized("viewUser")>
				 (<a href="index.cfm?method=user.viewUser&userID=#qry_selectProduct.userID_author#" class="plainlink">go</a>)
			</cfif>
		</cfif>
	</td>
</tr>
<tr>
	<td>Last Updated: </td>
	<td>#DateFormat(qry_selectProduct.productDateUpdated, "dddd, mmmm dd yyyy")# at #TimeFormat(qry_selectProduct.productDateUpdated, "hh:mm tt")#</td>
</tr>
<cfif qry_selectProduct.productCatalogPageNumber is not 0>
	<tr>
		<td>Catalog Page ##: </td>
		<td>#qry_selectProduct.productCatalogPageNumber#</td>
	</tr>
</cfif>
<cfif qry_selectProduct.productWeight is not 0>
	<tr>
		<td>Weight: </td>
		<td>#DecimalFormat(qry_selectProduct.productWeight)# pounds</td>
	</tr>
</cfif>
<tr>
	<td>In Stock: </td>
	<td><cfif qry_selectProduct.productInWarehouse is 1>Yes<cfelse>No</cfif></td>
</tr>
<cfif qry_selectProduct.productViewCount is not 0>
	<tr>
		<td>Page Views: </td>
		<td>#qry_selectProduct.productViewCount#</td>
	</tr>
</cfif>
<cfif Application.fn_IsUserAuthorized("exportProducts")>
	<tr>
		<td>Export Status: </td>
		<td>
			<cfswitch expression="#qry_selectProduct.productIsExported#">
			<cfcase value="1">Exported - Import Confirmed</cfcase>
			<cfcase value="0">Exported - Awaiting Import Confirmation</cfcase>
			<cfdefaultcase>Not Exported</cfdefaultcase>
			</cfswitch>
			<cfif qry_selectProduct.productIsExported is not "" and IsDate(qry_selectProduct.productDateExported)>
				on #DateFormat(qry_selectProduct.productDateExported, "mmmm dd, yyyy")# at #TimeFormat(qry_selectProduct.productDateExported, "hh:mm tt")#
			</cfif>
		</td>
	</tr>
</cfif>
</table>

<!--- Custom status and custom fields --->
<cfinvoke component="#Application.billingMapping#control.c_status.ViewStatusHistory" method="viewStatusHistory" returnVariable="isStatusHistoryViewed">
	<cfinvokeargument name="primaryTargetKey" value="productID">
	<cfinvokeargument name="targetID" value="#URL.productID#">
</cfinvoke>

<cfinvoke component="#Application.billingMapping#control.c_customField.ViewCustomFieldValue" method="viewCustomFieldValues" returnVariable="isCustomFieldValuesViewed">
	<cfinvokeargument name="companyID" value="#Session.companyID_author#">
	<cfinvokeargument name="primaryTargetKey" value="productID">
	<cfinvokeargument name="targetID" value="#URL.productID#">
</cfinvoke>

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>## Images: </td>
	<td>#qry_selectProductSummary.productImageCount#</td>
</tr>
<tr>
	<td>## Thumbnails: </td>
	<td>#qry_selectProductSummary.productThumbnailCount#</td>
</tr>
<tr>
	<td>## Products Recommended by this product: </td>
	<td>#qry_selectProductSummary.productRecommendsCount#</td>
</tr>
<tr>
	<td>## of Products that Recommend this product: </td>
	<td>#qry_selectProductSummary.productRecommendedCount#</td>
</tr>
<tr>
	<td>## Custom Pricing Options: </td>
	<td>#qry_selectProductSummary.productCustomPriceCount#</td>
</tr>
<cfif qry_selectProduct.productIsBundle is 0>
	<tr>
		<td>## Products bundles that include this product: </td>
		<td>#qry_selectProductSummary.productInBundleCount#</td>
	</tr>
</cfif>
<cfif qry_selectProduct.templateFilename is not "">
	<tr valign="top">
		<td>Template: </td>
		<td>
			#qry_selectTemplate.templateName#
			<cfif qry_selectTemplate.templateDescription is not ""><div class="TableText"><i>Description</i>: #qry_selectTemplate.templateDescription#</div></cfif>
		</td>
	</tr>
</cfif>
<cfif qry_selectProductLanguage.productLanguageName is not qry_selectProduct.productName>
	<tr valign="top">
		<td>Name as listed on site: </td>
		<td>#qry_selectProductLanguage.productLanguageName#</td>
	</tr>
</cfif>
<cfif qry_selectProductLanguage.productLanguageLineItemName is not qry_selectProduct.productName and qry_selectProductLanguage.productLanguageLineItemName is not qry_selectProductLanguage.productLanguageName>
	<tr valign="top">
		<td>Name as listed on invoice: </td>
		<td>#qry_selectProductLanguage.productLanguageLineItemName#</td>
	</tr>
</cfif>
<cfif qry_selectProductLanguage.productLanguageSummary is not "">
	<tr valign="top">
		<td>Summary as listed on site: </td>
		<td>#qry_selectProductLanguage.productLanguageSummary#</td>
	</tr>
</cfif>
<cfif qry_selectProductLanguage.productLanguageLineItemDescription is not qry_selectProductLanguage.productLanguageSummary>
	<tr valign="top">
		<td>Summary as listed on invoice: </td>
		<td>#qry_selectProductLanguage.productLanguageLineItemDescription#</td>
	</tr>
</cfif>
<cfif qry_selectProduct.productIsBundle is 1>
	<tr valign="top">
		<td>Products included in this bundle:</td>
		<td>
			<cfloop Query="qry_selectProductBundleProductList">
				#qry_selectProductBundleProductList.productName#
				<cfif Application.fn_IsUserAuthorized("viewProduct")>
					 (<a href="index.cfm?method=product.viewProduct&productID=#qry_selectProductBundleProductList.productID#" class="plainlink">go</a>)
				</cfif>
				<br>
			</cfloop>
		</td>
	</tr>
</cfif>
<cfif qry_selectProduct.productHasChildren is 1>
	<tr valign="top">
		<td>Child Products:</td>
		<td>#qry_selectProductChildList.RecordCount#</td>
	</tr>
</cfif>
</table>

<div class="MainText">
<cfif qry_selectProductCategory.RecordCount is not 0>
	<cfset categoryRowStruct = StructNew()>
	<cfloop Query="qry_selectCategoryList">
		<cfset categoryRowStruct["cat#qry_selectCategoryList.categoryID#"] = CurrentRow>
	</cfloop>

	<br><br><b>Product Categories:</b><br>
	<cfloop Query="qry_selectProductCategory">
		<cfset catRow = categoryRowStruct["cat#qry_selectProductCategory.categoryID#"]>
		<cfloop Index="parentCategoryID" List="#qry_selectCategoryList.categoryID_parentList[catRow]#">
			#qry_selectCategoryList.categoryName[categoryRowStruct["cat#parentCategoryID#"]]# / 
		</cfloop>
		 #qry_selectCategoryList.categoryName[catRow]#<br>
	</cfloop>
</cfif>

<cfif qry_selectProductLanguage.productLanguageDescription is not "">
	<br><br><b>Product Description:</b><br>
	<div class="TableText" style="width: 800">
	<cfif qry_selectProductLanguage.productLanguageDescriptionHtml is 1>
		#qry_selectProductLanguage.productLanguageDescription#
	<cfelse>
		#Replace(qry_selectProductLanguage.productLanguageDescription, Chr(10), "<br>", "ALL")#
	</cfif>
	</div>
</cfif>
</div>
</cfoutput>

