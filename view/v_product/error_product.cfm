<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_product#">
<cfcase value="noProduct">You did not specify a valid product.</cfcase>
<cfcase value="invalidProduct">You did not specify a valid product.</cfcase>
<cfcase value="invalidDate">You did not select a valid product date range to edit.</cfcase>
<cfcase value="invalidAction">You did not select a valid product function.</cfcase>
<cfcase value="updateProductRecommend">You did not request a valid product recommendation to remove.</cfcase>
<cfcase value="productNotBundle">This product is not a bundle.<br>You may only view the bundles that include this product.</cfcase>
<cfcase value="productBundleStatus">To edit this product bundle, the product status must be inactive.</cfcase>
<cfcase value="deleteProductBundle">You did not select a valid product to remove from this bundle.</cfcase>
<cfcase value="moveProductBundleUp,moveProductBundleDown">You did not select a valid product to move up/down product order in this bundle.</cfcase>
<cfcase value="noTemplate">No template has been specified for this product.<br>The default template is used below.</cfcase>
<cfcase value="invalidTemplate">The specified template for this product does not exist.<br>The default template is used below.</cfcase>
<cfcase value="noChildProduct">You did not specify a child product or this product has no children.</cfcase>
<cfcase value="invalidChildProduct">You did not specify a valid child product of this product.</cfcase>
<cfcase value="invalidProductCategory">You did not specify a valid category for this product.</cfcase>
<cfcase value="noProductParameter">You did not specify a product parameter.</cfcase>
<cfcase value="invalidProductParameter">You did not specify a valid product parameter.</cfcase>
<cfcase value="insertProductParameter">The product may have a maximum of 254 parameters.</cfcase>
<cfcase value="moveProductParameterCodeDown,moveProductParameterCodeUp">You cannot switch the code order of a parameter for which the code is not enabled.</cfcase>
<cfcase value="insertProductParameterException">You cannot add a parameter exception until you have created at least one parameter.</cfcase>
<cfcase value="updateProductParameterExceptionStatus">The parameter exception is already inactive.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>