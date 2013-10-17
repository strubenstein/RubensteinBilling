<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.productSpecCount_orig" Default="#qry_selectProductSpecList.RecordCount#">
	<cfparam Name="Form.productSpecCount" Default="#Form.productSpecCount_orig#">

	<cfloop Query="qry_selectProductSpecList">
		<cfparam Name="Form.productSpecName_select#CurrentRow#" Default="#qry_selectProductSpecList.productSpecName#">
		<cfparam Name="Form.productSpecName_text#CurrentRow#" Default="">
		<cfparam Name="Form.productSpecValue#CurrentRow#" Default="#qry_selectProductSpecList.productSpecValue#">
		<cfparam Name="Form.productSpecHasImage#CurrentRow#" Default="#qry_selectProductSpecList.productSpecHasImage#">
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
	<cfparam Name="Form.productSpecValue#count#" Default="">
	<cfparam Name="Form.productSpecHasImage#count#" Default="0">
</cfloop>

