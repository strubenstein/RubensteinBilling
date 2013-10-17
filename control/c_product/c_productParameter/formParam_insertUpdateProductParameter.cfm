<cfif URL.productParameterID is not 0 and IsDefined("qry_selectProductParameter") and IsDefined("qry_selectProductParameterOptionList")>
	<cfparam Name="Form.productParameterName" Default="#qry_selectProductParameter.productParameterName#">
	<cfparam Name="Form.productParameterText" Default="#qry_selectProductParameter.productParameterText#">
	<cfparam Name="Form.productParameterDescription" Default="#qry_selectProductParameter.productParameterDescription#">
	<cfparam Name="Form.productParameterOrder" Default="#qry_selectProductParameter.productParameterOrder#">
	<cfparam Name="Form.productParameterImage" Default="#qry_selectProductParameter.productParameterImage#">
	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.productParameterCodeStatus" Default="#qry_selectProductParameter.productParameterCodeStatus#">
		<cfparam Name="Form.productParameterExportXml" Default="#qry_selectProductParameter.productParameterExportXml#">
		<cfparam Name="Form.productParameterExportTab" Default="#qry_selectProductParameter.productParameterExportTab#">
		<cfparam Name="Form.productParameterExportHtml" Default="#qry_selectProductParameter.productParameterExportHtml#">
	</cfif>
	<cfparam Name="Form.productParameterCodeOrder" Default="#qry_selectProductParameter.productParameterCodeOrder#">
	<cfparam Name="Form.productParameterRequired" Default="#qry_selectProductParameter.productParameterRequired#">
	<cfparam Name="Form.productParameterStatus" Default="#qry_selectProductParameter.productParameterStatus#">

	<cfloop Query="qry_selectProductParameterOptionList">
		<cfparam Name="Form.productParameterOptionLabel#CurrentRow#" Default="#qry_selectProductParameterOptionList.productParameterOptionLabel#">
		<cfparam Name="Form.productParameterOptionValue#CurrentRow#" Default="#qry_selectProductParameterOptionList.productParameterOptionValue#">
		<cfparam Name="Form.productParameterOptionImage#CurrentRow#" Default="#qry_selectProductParameterOptionList.productParameterOptionImage#">
		<cfparam Name="Form.productParameterOptionCode#CurrentRow#" Default="#qry_selectProductParameterOptionList.productParameterOptionCode#">
	</cfloop>
</cfif>

<cfparam Name="Form.productParameterName" Default="">
<cfparam Name="Form.productParameterText" Default="">
<cfparam Name="Form.productParameterDescription" Default="">
<cfparam Name="Form.productParameterOrder" Default="0">
<cfparam Name="Form.productParameterImage" Default="">
<cfparam Name="Form.productParameterCodeStatus" Default="0">
<cfparam Name="Form.productParameterCodeOrder" Default="0">
<cfparam Name="Form.productParameterRequired" Default="1">
<cfparam Name="Form.productParameterStatus" Default="1">

<cfif Not IsDefined("Form.isFormSubmitted")>
	<cfparam Name="Form.productParameterExportXml" Default="1">
	<cfparam Name="Form.productParameterExportTab" Default="1">
	<cfparam Name="Form.productParameterExportHtml" Default="0">
<cfelse>
	<cfparam Name="Form.productParameterExportXml" Default="0">
	<cfparam Name="Form.productParameterExportTab" Default="0">
	<cfparam Name="Form.productParameterExportHtml" Default="0">
</cfif>

<cfparam Name="Form.productParameterOptionCount" Default="10">
<cfif Not Application.fn_IsIntegerPositive(Form.productParameterOptionCount)>
	<cfset Form.productParameterOptionCount = 10>
</cfif>

<cfloop Index="count" From="1" To="#Form.productParameterOptionCount#">
	<cfparam Name="Form.productParameterOptionLabel#count#" Default="">
	<cfparam Name="Form.productParameterOptionValue#count#" Default="">
	<cfparam Name="Form.productParameterOptionImage#count#" Default="">
	<cfparam Name="Form.productParameterOptionCode#count#" Default="">
</cfloop>

<cfloop Index="count" From="1" To="#Form.productParameterOptionCount#">
	<cfset Variables.newCount = 0>
	<cfif count is not 1 and (IsDefined("Form.submitMoveProductParameterOptionUp#count#") or IsDefined("Form.submitMoveProductParameterOptionUp#count#.x"))>
		<cfset Variables.newCount = count - 1>
	<cfelseif count is not Form.productParameterOptionCount and (IsDefined("Form.submitMoveProductParameterOptionDown#count#") or IsDefined("Form.submitMoveProductParameterOptionDown#count#.x"))>
		<cfset Variables.newCount = count + 1>
	</cfif>

	<cfif Variables.newCount is not 0>
		<!--- save current values of count being moved in temporary fields --->
		<cfset Variables.tempLabel = Form["productParameterOptionLabel#count#"]>
		<cfset Variables.tempValue = Form["productParameterOptionValue#count#"]>
		<cfset Variables.tempImage = Form["productParameterOptionImage#count#"]>
		<cfset Variables.tempCode = Form["productParameterOptionCode#count#"]>

		<!--- set values of count being forced to moved to its existing values --->
		<cfset temp = SetVariable("Form.productParameterOptionLabel#count#", Form["productParameterOptionLabel#Variables.newCount#"])>
		<cfset temp = SetVariable("Form.productParameterOptionValue#count#", Form["productParameterOptionValue#Variables.newCount#"])>
		<cfset temp = SetVariable("Form.productParameterOptionImage#count#", Form["productParameterOptionImage#Variables.newCount#"])>
		<cfset temp = SetVariable("Form.productParameterOptionCode#count#", Form["productParameterOptionCode#Variables.newCount#"])>

		<!--- set values of count being moved to its existing values --->
		<cfset temp = SetVariable("Form.productParameterOptionLabel#Variables.newCount#", Variables.tempLabel)>
		<cfset temp = SetVariable("Form.productParameterOptionValue#Variables.newCount#", Variables.tempValue)>
		<cfset temp = SetVariable("Form.productParameterOptionImage#Variables.newCount#", Variables.tempImage)>
		<cfset temp = SetVariable("Form.productParameterOptionCode#Variables.newCount#", Variables.tempCode)>

		<cfbreak>
	</cfif>
</cfloop>

