<!--- if parent product has no specs, use first child product instead --->

<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.productSpecCount_orig" Default="#qry_selectProductSpecList.RecordCount#">
	<cfparam Name="Form.productSpecCount" Default="#Form.productSpecCount_orig#">

	<cfloop Query="qry_selectProductSpecList">
		<cfparam Name="Form.productSpecName_select#CurrentRow#" Default="#qry_selectProductSpecList.productSpecName#">
		<cfparam Name="Form.productSpecName_text#CurrentRow#" Default="">
		<cfparam Name="Form.productSpecValue#CurrentRow#_#URL.productID#" Default="#qry_selectProductSpecList.productSpecValue#">
		<cfparam Name="Form.productSpecHasImage#CurrentRow#_#URL.productID#" Default="#qry_selectProductSpecList.productSpecHasImage#">
	</cfloop>

	<cfloop Query="qry_selectProductChildSpecList">
		<cfparam Name="Form.productSpecName_select#qry_selectProductChildSpecList.productSpecOrder#" Default="#qry_selectProductChildSpecList.productSpecName#">
		<cfparam Name="Form.productSpecName_text#qry_selectProductChildSpecList.productSpecOrder#" Default="">
		<cfparam Name="Form.productSpecValue#qry_selectProductChildSpecList.productSpecOrder#_#qry_selectProductChildSpecList.productID#" Default="#qry_selectProductChildSpecList.productSpecValue#">
		<cfparam Name="Form.productSpecHasImage#qry_selectProductChildSpecList.productSpecOrder#_#qry_selectProductChildSpecList.productID#" Default="#qry_selectProductChildSpecList.productSpecHasImage#">
	</cfloop>
</cfif>

<cfparam Name="Form.productSpecCount_orig" Default="5">
<cfparam Name="Form.productSpecCount" Default="#Form.productSpecCount_orig#">

<cfif Not Application.fn_IsIntegerPositive(Form.productSpecCount_orig) or Not Application.fn_IsIntegerPositive(Form.productSpecCount)>
	<cfset Form.productSpecCount_orig = 5>
	<cfset Form.productSpecCount  = 5>
</cfif>

<cfloop Index="count" From="1" To="#Max(Form.productSpecCount_orig,Form.productSpecCount)#">
	<cfparam Name="Form.productSpecName_select#count#" Default="">
	<cfparam Name="Form.productSpecName_text#count#" Default="">
</cfloop>

<cfloop Index="pID" List="#Variables.productID_list#">
	<cfset Variables.thisProductID = pID>
	<cfloop Index="count" From="1" To="#Max(Form.productSpecCount_orig,Form.productSpecCount)#">
		<cfparam Name="Form.productSpecValue#count#_#Variables.thisProductID#" Default="">
		<cfparam Name="Form.productSpecHasImage#count#_#Variables.thisProductID#" Default="0">
	</cfloop>
</cfloop>

