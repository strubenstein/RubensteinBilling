<cfif URL.productID is not 0 and IsDefined("qry_selectProductCategory") and Not IsDefined("Form.submitProductCategory")>
	<cfset Form.categoryID = "">
	<cfloop Query="qry_selectProductCategory">
		<cfif qry_selectProductCategory.productCategoryStatus is 1>
			<cfset Form.categoryID = ListAppend(Form.categoryID, qry_selectProductCategory.categoryID)>
		</cfif>

		<cfparam Name="Form.productCategoryDateBegin#qry_selectProductCategory.categoryID#_date" Default="#DateFormat(qry_selectProductCategory.productCategoryDateBegin, 'mm/dd/yyyy')#">
		<cfparam Name="Form.productCategoryDateBegin#qry_selectProductCategory.categoryID#_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectProductCategory.productCategoryDateBegin)), '|')#">
		<cfparam Name="Form.productCategoryDateBegin#qry_selectProductCategory.categoryID#_mm" Default="#Minute(qry_selectProductCategory.productCategoryDateBegin)#">
		<cfparam Name="Form.productCategoryDateBegin#qry_selectProductCategory.categoryID#_tt" Default="#TimeFormat(qry_selectProductCategory.productCategoryDateBegin, 'tt')#">

		<cfif IsDate(qry_selectProductCategory.productCategoryDateEnd)>
			<cfparam Name="Form.productCategoryDateEnd#qry_selectProductCategory.categoryID#_date" Default="#DateFormat(qry_selectProductCategory.productCategoryDateEnd, 'mm/dd/yyyy')#">
			<cfparam Name="Form.productCategoryDateEnd#qry_selectProductCategory.categoryID#_hh" Default="#ListFirst(fn_ConvertFrom24HourFormat(Hour(qry_selectProductCategory.productCategoryDateEnd)), '|')#">
			<cfparam Name="Form.productCategoryDateEnd#qry_selectProductCategory.categoryID#_mm" Default="#Minute(qry_selectProductCategory.productCategoryDateEnd)#">
			<cfparam Name="Form.productCategoryDateEnd#qry_selectProductCategory.categoryID#_tt" Default="#TimeFormat(qry_selectProductCategory.productCategoryDateEnd, 'tt')#">
		</cfif>
	</cfloop>
</cfif>

<cfparam Name="Form.categoryID" Default="">
<cfloop Query="qry_selectCategoryList">
	<cfparam Name="Form.productCategoryDateBegin#qry_selectCategoryList.categoryID#_date" Default="">
	<cfparam Name="Form.productCategoryDateBegin#qry_selectCategoryList.categoryID#_hh" Default="12">
	<cfparam Name="Form.productCategoryDateBegin#qry_selectCategoryList.categoryID#_mm" Default="00">
	<cfparam Name="Form.productCategoryDateBegin#qry_selectCategoryList.categoryID#_tt" Default="am">

	<cfparam Name="Form.productCategoryDateEnd#qry_selectCategoryList.categoryID#_date" Default="">
	<cfparam Name="Form.productCategoryDateEnd#qry_selectCategoryList.categoryID#_hh" Default="12">
	<cfparam Name="Form.productCategoryDateEnd#qry_selectCategoryList.categoryID#_mm" Default="00">
	<cfparam Name="Form.productCategoryDateEnd#qry_selectCategoryList.categoryID#_tt" Default="am">
</cfloop>

