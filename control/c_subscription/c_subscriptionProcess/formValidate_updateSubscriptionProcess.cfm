<cfset errorMessage_fields = StructNew()>

<cfloop Query="qry_selectSubscriptionList">
	<cfif qry_selectSubscriptionList.subscriptionIsRollup is 0>
		<cfset thisSubscriptionID = qry_selectSubscriptionList.subscriptionID>
		<cfset thisSubscriptionOrder = qry_selectSubscriptionList.subscriptionOrder>
		<cfloop Index="loopPriceStageID" List="#subscriptionID_priceStageIDList["subscription#thisSubscriptionID#"]#">
			<cfset subscriptionProcessQuantity = Form["subscriptionProcessQuantity#thisSubscriptionID#_#loopPriceStageID#"]>
			<cfif subscriptionProcessQuantity is not "">
				<cfif Not IsNumeric(subscriptionProcessQuantity)>
					<cfset errorMessage_fields.subscriptionProcessQuantity[thisSubscriptionID] = ReplaceNoCase(Variables.lang_updateSubscriptionProcess.subscriptionQuantity_numeric, "<<COUNT>>", thisSubscriptionOrder, "ALL")>
				<cfelseif subscriptionProcessQuantity lt 0>
					<cfset errorMessage_fields.subscriptionProcessQuantity[thisSubscriptionID] = ReplaceNoCase(Variables.lang_updateSubscriptionProcess.subscriptionQuantity_negative, "<<COUNT>>", thisSubscriptionOrder, "ALL")>
				<cfelseif Find(".", subscriptionProcessQuantity) and Len(ListLast(subscriptionProcessQuantity, ".")) gt maxlength_SubscriptionProcess.subscriptionProcessQuantity>
					<cfset errorMessage_fields.subscriptionProcessQuantity[thisSubscriptionID] = ReplaceNoCase(ReplaceNoCase(Variables.lang_updateSubscriptionProcess.subscriptionProcessQuantity_maxlength, "<<MAXLENGTH>>", maxlength_SubscriptionProcess.subscriptionProcessQuantity, "ALL"), "<<COUNT>>", thisSubscriptionOrder, "ALL")>
				</cfif>
			</cfif><!--- /if quantity not blank --->
		</cfloop><!--- /loop thru price stages for subscription --->
	</cfif><!--- /if not roll to --->
</cfloop><!--- /loop thru variable-quantity subscriptions --->

<cfif StructIsEmpty(errorMessage_fields)>
	<cfset isAllFormFieldsOk = True>
<cfelse>
	<cfset isAllFormFieldsOk = False>
	<cfset errorMessage_title = Variables.lang_updateSubscriptionProcess.errorTitle>
	<cfset errorMessage_header = Variables.lang_updateSubscriptionProcess.errorHeader>
	<cfset errorMessage_footer = Variables.lang_updateSubscriptionProcess.errorFooter>
</cfif>

