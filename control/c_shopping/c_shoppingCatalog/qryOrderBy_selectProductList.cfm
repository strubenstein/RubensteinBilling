<cfswitch expression="#Arguments.queryOrderBy#">
<cfcase value="productID"><cfset queryParameters_orderBy = "avProduct.productID"></cfcase>
<cfcase value="productID_d"><cfset queryParameters_orderBy = "avProduct.productID DESC"></cfcase>
<cfcase value="vendorID"><cfset queryParameters_orderBy = "avProduct.vendorID"></cfcase>
<cfcase value="vendorID_d"><cfset queryParameters_orderBy = "avProduct.vendorID DESC"></cfcase>
<cfcase value="productCode"><cfset queryParameters_orderBy = "avProduct.productCode"></cfcase>
<cfcase value="productCode_d"><cfset queryParameters_orderBy = "avProduct.productCode DESC"></cfcase>
<cfcase value="productName"><cfset queryParameters_orderBy = "avProductLanguage.productLanguageName"></cfcase>
<cfcase value="productName_d"><cfset queryParameters_orderBy = "avProductLanguage.productLanguageName DESC"></cfcase>
<cfcase value="productPrice"><cfset queryParameters_orderBy = "avProduct.productPrice"></cfcase>
<cfcase value="productPrice_d"><cfset queryParameters_orderBy = "avProduct.productPrice DESC"></cfcase>
<cfcase value="productWeight"><cfset queryParameters_orderBy = "avProduct.productWeight"></cfcase>
<cfcase value="productWeight_d"><cfset queryParameters_orderBy = "avProduct.productWeight DESC"></cfcase>
<cfcase value="productViewCount"><cfset queryParameters_orderBy = "avProduct.productViewCount"></cfcase>
<cfcase value="productViewCount_d"><cfset queryParameters_orderBy = "avProduct.productViewCount DESC"></cfcase>
<cfcase value="productID_custom"><cfset queryParameters_orderBy = "avProduct.productID_custom"></cfcase>
<cfcase value="productID_custom_d"><cfset queryParameters_orderBy = "avProduct.productID_custom DESC"></cfcase>
<cfcase value="productCatalogPageNumber"><cfset queryParameters_orderBy = "avProduct.productCatalogPageNumber"></cfcase>
<cfcase value="productCatalogPageNumber_d"><cfset queryParameters_orderBy = "avProduct.productCatalogPageNumber DESC"></cfcase>
<cfcase value="productDateCreated"><cfset queryParameters_orderBy = "avProduct.productDateCreated"></cfcase>
<cfcase value="productDateCreated_d"><cfset queryParameters_orderBy = "avProduct.productDateCreated DESC"></cfcase>
<cfcase value="RANDOM"><cfset queryParameters_orderBy = Application.billingSql.randomID></cfcase>
<cfdefaultcase><cfset queryParameters_orderBy = "avProductLanguage.productLanguageName"></cfdefaultcase>
</cfswitch>

<cfset queryParameters_orderBy_noTable = queryParameters_orderBy>
<cfloop index="table" list="avProduct,avProductLanguage">
	<cfset queryParameters_orderBy_noTable = Replace(queryParameters_orderBy_noTable, "#table#.", "", "ALL")>
</cfloop>
