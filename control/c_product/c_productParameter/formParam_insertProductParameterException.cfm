<cfif URL.productParameterExceptionID is not 0 and IsDefined("qry_selectProductParameterException")>
	<cfparam Name="Form.productParameterExceptionPricePremium" Default="#qry_selectProductParameterException.productParameterExceptionPricePremium#">
	<cfparam Name="Form.productParameterExceptionText" Default="#qry_selectProductParameterException.productParameterExceptionText#">
	<cfparam Name="Form.productParameterExceptionDescription" Default="#qry_selectProductParameterException.productParameterExceptionDescription#">

	<cfif Not IsDefined("Form.isFormSubmitted")>
		<cfparam Name="Form.productParameterExceptionExcluded" Default="#qry_selectProductParameterException.productParameterExceptionExcluded#">
		<cfparam Name="Form.productParameterOptionID" Default="">
		<cfif qry_selectProductParameterException.productParameterOptionID1 is not 0>
			<cfset Form.productParameterOptionID = ListAppend(Form.productParameterOptionID, qry_selectProductParameterException.productParameterOptionID1)>
		</cfif>
		<cfif qry_selectProductParameterException.productParameterOptionID2 is not 0>
			<cfset Form.productParameterOptionID = ListAppend(Form.productParameterOptionID, qry_selectProductParameterException.productParameterOptionID2)>
		</cfif>
		<cfif qry_selectProductParameterException.productParameterOptionID3 is not 0>
			<cfset Form.productParameterOptionID = ListAppend(Form.productParameterOptionID, qry_selectProductParameterException.productParameterOptionID3)>
		</cfif>
		<cfif qry_selectProductParameterException.productParameterOptionID4 is not 0>
			<cfset Form.productParameterOptionID = ListAppend(Form.productParameterOptionID, qry_selectProductParameterException.productParameterOptionID4)>
		</cfif>
	</cfif>
</cfif>

<cfparam Name="Form.productParameterOptionID" Default="">
<cfparam Name="Form.productParameterExceptionExcluded" Default="0">
<cfparam Name="Form.productParameterExceptionPricePremium" Default="">
<cfparam Name="Form.productParameterExceptionText" Default="">
<cfparam Name="Form.productParameterExceptionDescription" Default="">

<cfif Form.productParameterExceptionPricePremium is 0>
	<cfset Form.productParameterExceptionPricePremium = "">
</cfif>
