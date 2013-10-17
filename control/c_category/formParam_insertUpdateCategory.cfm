<!--- Update existing category --->
<cfif URL.categoryID gt 0 and IsDefined("qry_selectCategory") and IsDefined("qry_selectHeaderFooter")>
	<cfparam Name="Form.categoryCode" Default="#qry_selectCategory.categoryCode#">
	<cfparam Name="Form.categoryName" Default="#qry_selectCategory.categoryName#">
	<cfparam Name="Form.categoryDescription" Default="#qry_selectCategory.categoryDescription#">
	<cfparam Name="Form.categoryTitle" Default="#qry_selectCategory.categoryTitle#">
	<cfparam Name="Form.categoryStatus" Default="#qry_selectCategory.categoryStatus#">
	<cfparam Name="Form.categoryID_parent" Default="#qry_selectCategory.categoryID_parent#">
	<cfparam Name="Form.categoryAcceptListing" Default="#qry_selectCategory.categoryAcceptListing#">
	<cfparam Name="Form.categoryIsListed" Default="#qry_selectCategory.categoryIsListed#">
	<cfparam Name="Form.templateFilename" Default="#qry_selectCategory.templateFilename#">

	<cfif qry_selectCategory.categoryItemsPerPage is not 0>
		<cfparam Name="Form.itemsPerPage_or_numberOfPages" Default="categoryItemsPerPage">
		<cfparam Name="Form.itemsOrPages_value" Default="#qry_selectCategory.categoryItemsPerPage#">
	<cfelse>
		<cfparam Name="Form.itemsPerPage_or_numberOfPages" Default="categoryNumberOfPages">
		<cfparam Name="Form.itemsOrPages_value" Default="#qry_selectCategory.categoryNumberOfPages#">
	</cfif>

	<cfset Form.categoryFooter_orig = "">
	<cfset Form.categoryFooterHtml_orig = "">
	<cfset Form.categoryHeader_orig = "">
	<cfset Form.categoryHeaderHtml_orig = "">

	<cfloop Query="qry_selectHeaderFooter">
		<cfif qry_selectHeaderFooter.headerFooterIndicator is 0>
			<cfparam Name="Form.categoryHeader" Default="#qry_selectHeaderFooter.headerFooterText#">
			<cfparam Name="Form.categoryHeaderHtml" Default="#qry_selectHeaderFooter.headerFooterHtml#">
			<cfset Form.categoryHeader_orig = qry_selectHeaderFooter.headerFooterText>
			<cfset Form.categoryHeaderHtml_orig = qry_selectHeaderFooter.headerFooterHtml>
		<cfelse>
			<cfparam Name="Form.categoryFooter" Default="#qry_selectHeaderFooter.headerFooterText#">
			<cfparam Name="Form.categoryFooterHtml" Default="#qry_selectHeaderFooter.headerFooterHtml#">
			<cfset Form.categoryFooter_orig = qry_selectHeaderFooter.headerFooterText>
			<cfset Form.categoryFooterHtml_orig = qry_selectHeaderFooter.headerFooterHtml>
		</cfif>
	</cfloop>
</cfif>

<!--- New category --->
<cfparam Name="Form.categoryCode" Default="">
<cfparam Name="Form.categoryName" Default="">
<cfparam Name="Form.categoryDescription" Default="">
<cfparam Name="Form.categoryTitle" Default="">
<cfparam Name="Form.categoryStatus" Default="1">
<cfif IsDefined("URL.categoryID_sub") and IsNumeric(URL.categoryID_sub)>
	<cfparam Name="Form.categoryID_parent" Default="#URL.categoryID_sub#">
<cfelse>
	<cfparam Name="Form.categoryID_parent" Default="0">
</cfif>
<cfparam Name="Form.categoryAcceptListing" Default="1">
<cfparam Name="Form.categoryIsListed" Default="1">
<cfif Not IsDefined("qry_selectTemplateList") or qry_selectTemplateList.RecordCount is 0>
	<cfparam Name="Form.templateFilename" Default="">
<cfelse>
	<cfparam Name="Form.templateFilename" Default="#qry_selectTemplateList.templateFilename[1]#">
</cfif>
<cfparam Name="Form.categoryHeader" Default="">
<cfparam Name="Form.categoryHeaderHtml" Default="0">
<cfparam Name="Form.categoryFooter" Default="">
<cfparam Name="Form.categoryFooterHtml" Default="0">

<cfparam Name="Form.itemsPerPage_or_numberOfPages" Default="categoryItemsPerPage">
<cfparam Name="Form.itemsOrPages_value" Default="12">
<cfparam Name="Form.categoryOrder_manual" Default="0">

