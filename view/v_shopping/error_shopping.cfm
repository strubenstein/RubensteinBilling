<cfoutput>
<p class="ErrorMessage">
<cfswitch expression="#URL.error_shopping#">
<cfcase value="invalidCategory">You did not select a valid category.</cfcase>
<cfcase value="invalidProduct">You did not select a valid product.</cfcase>
<cfcase value="productNotAvailable">This product is not currently available for purchase.</cfcase>
<cfcase value="invalidInvoice">You did not select a valid purchase.</cfcase>
<cfcase value="searchText">You did not enter any search text.</cfcase>
<cfcase value="searchType_vendorCode">You did not enter a valid brand.</cfcase>
<cfcase value="searchType_productCatalogPageNumber">You did not enter a valid catalog page number.</cfcase>
<cfcase value="searchType_categoryID">You did not select a valid category.</cfcase>
<cfcase value="productParameter_exist">You did not submit options for all required parameters.</cfcase>
<cfcase value="productParameter_blank">You did not select a parameter option.</cfcase>
<cfcase value="productParameter_valid">You did not select a valid parameter option.</cfcase>
<cfcase value="productParameter_excluded">The parameter combination you selected is not available.</cfcase>
</cfswitch>
<br><img src="#Application.billingUrlroot#/images/aline.gif" width="500" height="2" alt="" border="0"></p>
</cfoutput>

