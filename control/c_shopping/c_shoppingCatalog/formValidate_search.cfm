<cfparam Name="Form.searchText" Default="">
<cfparam Name="Form.searchType" Default="">

<cfset URL.error_shopping = "">
<cfset Variables.searchTypeArgumentName = "">
<cfset Variables.searchTypeArgumentValue = "">

<cfif Trim(Form.searchText) is "">
	<cfset URL.error_shopping = "searchText">
<cfelse>
	<cfswitch expression="#Form.searchType#">
	<!--- if brand/vendor, validate values is a valid vendor code; get vendorID --->
	<cfcase value="vendorCode">
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="searchField" Value="vendorCode,vendorName">
			<cfinvokeargument Name="searchText" Value="#Form.searchText#">
			<cfinvokeargument Name="returnVendorDescription" Value="True">
		</cfinvoke>

		<cfif qry_selectVendorList.RecordCount is 0>
			<cfset URL.error_shopping = "searchType_vendorCode">
		</cfif>
	</cfcase>

	<cfcase value="vendorID">
		<cfinvoke Component="#Application.billingMapping#data.Vendor" Method="selectVendorList" ReturnVariable="qry_selectVendorList">
			<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
			<cfinvokeargument Name="vendorID" Value="#Form.searchText#">
			<cfinvokeargument Name="returnVendorDescription" Value="True">
		</cfinvoke>

		<cfif qry_selectVendorList.RecordCount is 0>
			<cfset URL.error_shopping = "searchType_vendorCode">
		</cfif>
	</cfcase>

	<!--- if catalog, validate values are numbers --->
	<cfcase value="productCatalogPageNumber">
		<cfif Trim(Form.searchText) is "" or REFind("[^0-9,-]", Form.searchText)>
			<cfset URL.error_shopping = "searchType_productCatalogPageNumber">
		<cfelseif Application.fn_IsIntegerPositive(Form.searchText)>
			<cfset ignore = True>
		<cfelseif ListLen(Form.searchText, "-") is 2 and Not Find(",", Form.searchText)
				and Not Find("--", Form.searchText)
				and Left(Form.searchText, 1) is not "-" and Right(Form.searchText, 1) is not "-">
			<cfset ignore = True>
		<cfelseif Not Find("-", Form.searchText) and Not Find(",,", Form.searchText)
				and Left(Form.searchText, 1) is not "," and Right(Form.searchText, 1) is not ",">
			<cfset ignore = True>
		<cfelse>
			<cfset URL.error_shopping = "searchType_productCatalogPageNumber">
		</cfif>

		<cfset Variables.searchTypeArgumentName = "productCatalogPageNumber">
		<cfset Variables.searchTypeArgumentValue = "#Form.searchText#">
	</cfcase>

	<!--- if category, validate is valid category --->
	<cfdefaultcase><!--- Description,categoryID --->
		<cfif Not IsNumeric(Form.searchType)>
			<cfset Variables.searchTypeArgumentValue = "#Form.searchText#">
		<cfelseif ListFind(ValueList(qry_selectCategoryList.categoryID), Form.searchType)>
			<cfset Variables.searchTypeArgumentName = "categoryID">
			<cfset Variables.searchTypeArgumentValue = "#Form.searchText#">
		<cfelse>
			<cfset URL.error_shopping = "searchType_categoryID">
		</cfif>
	</cfdefaultcase>
	</cfswitch>
</cfif>


