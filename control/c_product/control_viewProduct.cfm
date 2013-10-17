<!--- SELECT PRODUCT Language --->
<cfinvoke Component="#Application.billingMapping#data.ProductLanguage" Method="selectProductLanguage" ReturnVariable="qry_selectProductLanguage">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="languageID" Value="">
	<cfinvokeargument Name="productLanguageStatus" Value="1">
</cfinvoke>

<!--- SELECT PRODUCT Categories --->
<cfinvoke Component="#Application.billingMapping#data.Category" Method="selectCategoryList" ReturnVariable="qry_selectCategoryList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.ProductCategory" Method="selectProductCategory" ReturnVariable="qry_selectProductCategory">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="productCategoryStatus" Value="1">
</cfinvoke>

<!--- 
Number of images
Number of recommended products
Number of recommendations by other products
Number of bundles which contain product
Number of custom pricing options
Date availability
Child products
--->
<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductSummary" ReturnVariable="qry_selectProductSummary">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
</cfinvoke>

<!--- vendor name --->
<cfif qry_selectProduct.vendorID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendor" ReturnVariable="qry_selectVendor">
		<cfinvokeargument Name="vendorID" Value="#qry_selectProduct.vendorID#">
	</cfinvoke>
</cfif>

<!--- product manager --->
<!--- who created product --->
<cfif qry_selectProduct.userID_manager is not 0 or qry_selectProduct.userID_author is not 0>
	<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
		<cfif qry_selectProduct.userID_manager is not 0 or qry_selectProduct.userID_author is not 0>
			<cfinvokeargument Name="userID" Value="#qry_selectProduct.userID_author#,#qry_selectProduct.userID_manager#">
		<cfelseif qry_selectProduct.userID_manager is not 0>
			<cfinvokeargument Name="userID" Value="#qry_selectProduct.userID_manager#">
		<cfelse>
			<cfinvokeargument Name="userID" Value="#qry_selectProduct.userID_author#">
		</cfif>
	</cfinvoke>

	<cfset userRow_author = 0>
	<cfset userRow_manager = 0>
	<cfloop Query="qry_selectUser">
		<cfif qry_selectProduct.userID_author is qry_selectUser.userID>
			<cfset userRow_author = CurrentRow>
		</cfif>
		<cfif qry_selectProduct.userID_manager is qry_selectUser.userID>
			<cfset userRow_manager = CurrentRow>
		</cfif>
	</cfloop>
</cfif>

<!--- child products --->
<cfif qry_selectProduct.productHasChildren is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductChildList">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="productID_parent" Value="#URL.productID#">
		<cfinvokeargument Name="queryOrderBy" Value="productName">
	</cfinvoke>
</cfif>

<!--- template --->
<cfif qry_selectProduct.templateFilename is not "">
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplate" ReturnVariable="qry_selectTemplate">
		<cfinvokeargument Name="templateFilename" Value="#qry_selectProduct.templateFilename#">
	</cfinvoke>
</cfif>

<!--- Products in bundle --->
<cfif qry_selectProduct.productIsBundle is 1>
	<cfinvoke Component="#Application.billingMapping#data.ProductBundle" Method="selectProductBundle" ReturnVariable="qry_selectProductBundle">
		<cfinvokeargument Name="productID" Value="#URL.productID#">
		<cfinvokeargument Name="productBundleStatus" Value="1">
	</cfinvoke>

	<cfif qry_selectProductBundle.RecordCount is 1>
		<cfset currentProductBundleID = qry_selectProductBundle.productBundleID>
		<cfinvoke Component="#Application.billingMapping#data.ProductBundleProduct" Method="selectProductBundleProductList" ReturnVariable="qry_selectProductBundleProductList">
			<cfinvokeargument Name="productBundleID" Value="#qry_selectProductBundle.productBundleID#">
		</cfinvoke>
	<cfelse>
		<cfset qry_selectProductBundleProductList = QueryNew("productBundleID,productID")>
	</cfif>
</cfif>

<cfinclude template="../../view/v_product/dsp_selectProduct.cfm">
