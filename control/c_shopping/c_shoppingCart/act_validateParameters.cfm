<cfloop Query="qry_selectProductParameterList">
	<cfset Variables.isParameterOption = False>
	<cfif qry_selectProductParameterList.productParameterRequired is 1 and Not IsDefined("URL.parameter#qry_selectProductParameterList.productParameterID#")>
		<cfset URL.error_shopping = "productParameter_exist">
	<cfelseif qry_selectProductParameterList.productParameterRequired is 1 and Trim(URL["parameter#qry_selectProductParameterList.productParameterID#"]) is "">
		<cfset URL.error_shopping = "productParameter_blank">
	<cfelseif IsDefined("URL.parameter#qry_selectProductParameterList.productParameterID#")>
		<cfset Variables.thisParameterID = qry_selectProductParameterList.productParameterID>
		<cfset Variables.parameterRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterID), Variables.thisParameterID)>
		<cfif Variables.parameterRow is not 0>
			<cfset Variables.thisCodeStatus = qry_selectProductParameterList.productParameterCodeStatus>
			<cfset Variables.thisCodeOrder = qry_selectProductParameterList.productParameterCodeOrder>

			<cfloop Query="qry_selectProductParameterOptionList" StartRow="#Variables.parameterRow#">
				<cfif qry_selectProductParameterOptionList.productParameterID is not Variables.thisParameterID>
					<cfbreak>
				<cfelseif URL["parameter#qry_selectProductParameterOptionList.productParameterID#"] is qry_selectProductParameterOptionList.productParameterOptionID>
					<cfset Variables.isParameterOption = True>
					<cfset Variables.productParameterOptionID_list = ListAppend(Variables.productParameterOptionID_list, qry_selectProductParameterOptionList.productParameterOptionID)>
					<!--- generate custom ID --->
					<cfif Variables.thisCodeStatus is 1>
						<cfset invoiceLineItemProductID_customArray[Variables.thisCodeOrder] = qry_selectProductParameterOptionList.productParameterOptionCode>
					</cfif>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif Variables.isParameterOption is False>
				<cfset URL.error_shopping = "productParameter_valid">
				<cfbreak>
			</cfif>
		</cfif>
	</cfif>
</cfloop>

<!--- if exception: check that combination of parameters is permitted and for price exception --->
<cfif URL.error_shopping is "" and Variables.displayProductParameterException is True>
	<cfloop Query="qry_selectProductParameterExceptionList">
		<cfif (qry_selectProductParameterExceptionList.productParameterExceptionExcluded is 1 or qry_selectProductParameterExceptionList.productParameterExceptionPricePremium is not 0)
				and ListFind(Variables.productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID1)
				and (qry_selectProductParameterExceptionList.productParameterOptionID2 is 0 or ListFind(Variables.productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID2))
				and (qry_selectProductParameterExceptionList.productParameterOptionID3 is 0 or ListFind(Variables.productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID3))
				and (qry_selectProductParameterExceptionList.productParameterOptionID4 is 0 or ListFind(Variables.productParameterOptionID_list, qry_selectProductParameterExceptionList.productParameterOptionID4))>
			<cfif qry_selectProductParameterExceptionList.productParameterExceptionExcluded is 1>
				<cfset URL.error_shopping = "productParameter_excluded">
			<cfelse>
				<cfset Variables.productParameterExceptionID = qry_selectProductParameterExceptionList.productParameterExceptionID>
				<cfset Variables.productParameterExceptionPricePremium = qry_selectProductParameterExceptionList.productParameterExceptionPricePremium>
			</cfif>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>
