<cfoutput>
<p class="ConfirmationMessage">
<cfswitch expression="#URL.confirm_product#">
<!--- <cfcase value="insertProduct">Product successfully created!<br>Specify the summary and description information below.</cfcase> --->
<cfcase value="insertProduct">
	Product successfully created!<br>
	<cfif IsDefined("URL.productID_new") and IsNumeric(URL.productID_new)>
		<a href="index.cfm?method=product.viewProductSummary&productID=#URL.productID_new#" class="plainlink">Manage new product ###URL.productID_new#</a>.<br>
	</cfif>
	Or you may create a new product below.
</cfcase>
<cfcase value="updateProduct">Main product information successfully updated!</cfcase>
<cfcase value="insertProductLanguage">Product language successfully updated!</cfcase>
<cfcase value="insertProductCategory">Product category(s) successfully updated!</cfcase>
<cfcase value="insertProductSpec">Product specifications successfully updated.</cfcase>
<cfcase value="insertProductSpecChild">Product specifications for product and child products successfully updated.</cfcase>
<cfcase value="blankProductSpec">Product specifications successfully removed.</cfcase>
<cfcase value="insertProductDate">Product availability dates added.</cfcase>
<cfcase value="updateProductDate">Product availability dates updated.</cfcase>
<cfcase value="deleteProductDate">Product availability dates deleted.</cfcase>
<cfcase value="insertProductRecommend">Product recommendation added!</cfcase>
<cfcase value="updateProductRecommend">Product recommendation removed!</cfcase>
<cfcase value="deleteRecommend">Product recommendation deleted!</cfcase>
<cfcase value="moveRecommendUp,moveRecommendDown">Product order in recommendation list updated!</cfcase>
<cfcase value="insertProductBundle">Product added to bundle!</cfcase>
<cfcase value="updateProductBundle">Product quantity in bundle updated!</cfcase>
<cfcase value="deleteProductBundle">Product removed from bundle!</cfcase>
<cfcase value="moveProductBundleUp,moveProductBundleDown">Product order in bundle updated!</cfcase>
<cfcase value="moveChildProductUp,moveChildProductDown">Product child order successfully updated!</cfcase>
<cfcase value="fixChildProductOrder">Product child order successfully fixed!</cfcase>
<cfcase value="moveProductCategoryUp,moveProductCategoryDown">Product order within category successfully updated!</cfcase>
<cfcase value="insertProductParameter">Product parameter successfully added!</cfcase>
<cfcase value="updateProductParameter">Product parameter successfully updated!</cfcase>
<cfcase value="moveProductParameterUp,moveProductParameterDown">Product parameter order successfully updated!</cfcase>
<cfcase value="moveProductParameterCodeUp,moveProductParameterCodeDown">Product parameter code order successfully updated!</cfcase>
<cfcase value="insertProductParameterException">Product parameter exception successfully created!</cfcase>
<cfcase value="updateProductParameterException">Product parameter exception successfully updated!<br>The original version has been archived.</cfcase>
<cfcase value="updateProductParameterExceptionStatus">Product parameter exception is now inactive.</cfcase>
<cfcase value="updateProductIsExported">Export status of product records successfully updated!</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>
