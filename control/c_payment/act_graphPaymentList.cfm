<!--- # and $ of payments by category --->
<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_category" returnVariable="qry_selectPaymentList_category" argumentCollection="#qryParamStruct#" />

<cfif qry_selectPaymentList_category.RecordCount is not 0 and qry_selectPaymentList_category.paymentCategoryID[1] is 0>
	<cfset temp = QuerySetCell(qry_selectPaymentCategoryList, "paymentCategoryName", "(none)", 1)>
</cfif>


<!--- # and $ of payments by approval status --->
<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_summary" returnVariable="qry_selectPaymentList_status" argumentCollection="#qryParamStruct#">
	<cfinvokeargument name="paymentField" value="paymentApproved">
</cfinvoke>

<cfset Variables.paymentApprovedArray = ArrayNew(1)>
<cfloop Query="qry_selectPaymentList_status">
	<cfswitch expression="#qry_selectPaymentList_status.paymentApproved#">
	<cfcase value="0"><cfset Variables.paymentApprovedArray[CurrentRow] = "Rejected/Bounced"></cfcase>
	<cfcase value="1"><cfset Variables.paymentApprovedArray[CurrentRow] = "Approved/Cleared"></cfcase>
	<cfdefaultcase><cfset Variables.paymentApprovedArray[CurrentRow] = "Unknown"></cfdefaultcase>
	</cfswitch>
</cfloop>
<cfset temp = QueryAddColumn(qry_selectPaymentList_status, "PaymentApprovedStatus", Variables.paymentApprovedArray)>


<!--- # and $ of payments by method --->
<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_summary" returnVariable="qry_selectPaymentList_method" argumentCollection="#qryParamStruct#">
	<cfinvokeargument name="paymentField" value="paymentMethod">
</cfinvoke>

<!--- # and $ of payments manual vs automatic --->
<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_summary" returnVariable="qry_selectPaymentList_manual" argumentCollection="#qryParamStruct#">
	<cfinvokeargument name="paymentField" value="paymentManual">
</cfinvoke>

<cfset Variables.paymentManualArray = ArrayNew(1)>
<cfloop Query="qry_selectPaymentList_status">
	<cfswitch expression="#qry_selectPaymentList_manual.paymentManual#">
	<cfcase value="0"><cfset Variables.paymentManualArray[CurrentRow] = "Automated"></cfcase>
	<cfcase value="1"><cfset Variables.paymentManualArray[CurrentRow] = "Manual"></cfcase>
	</cfswitch>
</cfloop>
<cfset temp = QueryAddColumn(qry_selectPaymentList_manual, "PaymentManualStatus", Variables.paymentManualArray)>


<!--- # and $ with error message --->
<cfset qryParamStructTemp = StructCopy(qryParamStruct)>
<cfset qryParamStructTemp.paymentHasMessage = 1>
<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_summary" returnVariable="qry_selectPaymentList_message" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="paymentField" value="paymentMessage">
</cfinvoke>

<cfif qry_selectPaymentList_message.RecordCount is not 0 and qry_selectPaymentList_message.paymentMessage[1] is 0>
	<cfset temp = QuerySetCell(qry_selectPaymentList_message, "paymentMessage", "(none)", 1)>
</cfif>


<!--- # and $ by credit card type --->
<cfset qryParamStructTemp = StructCopy(qryParamStruct)>
<cfset qryParamStructTemp.paymentHasCreditCardType = 1>
<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_summary" returnVariable="qry_selectPaymentList_card" argumentCollection="#qryParamStructTemp#">
	<cfinvokeargument name="paymentField" value="paymentCreditCardType">
</cfinvoke>


<!--- Refund: Main products that are source of refund --->
<cfif FindNoCase("Refund", Variables.doAction)>
	<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_refund" returnVariable="qry_selectPaymentList_productCount" argumentCollection="#qryParamStruct#">
		<cfinvokeargument name="queryDisplayPerPage" value="10">
		<cfinvokeargument name="queryOrderBy" value="countPayment_d">
	</cfinvoke>

	<cfloop Query="qry_selectPaymentList_productCount">
		<cfif qry_selectPaymentList_productCount.productID is "">
			<cfset temp = QuerySetCell(qry_selectPaymentList_productCount, "productName", "(Not Specified)", CurrentRow)>
			<cfbreak>
		</cfif>
	</cfloop>

	<cfinvoke component="#Application.billingMapping#data.Payment" method="selectPaymentList_refund" returnVariable="qry_selectPaymentList_productTotal" argumentCollection="#qryParamStruct#">
		<cfinvokeargument name="queryDisplayPerPage" value="10">
		<cfinvokeargument name="queryOrderBy" value="sumPaymentAmount_d">
	</cfinvoke>

	<cfloop Query="qry_selectPaymentList_productTotal">
		<cfif qry_selectPaymentList_productTotal.productID is "">
			<cfset temp = QuerySetCell(qry_selectPaymentList_productTotal, "productName", "(Not Specified)", CurrentRow)>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

