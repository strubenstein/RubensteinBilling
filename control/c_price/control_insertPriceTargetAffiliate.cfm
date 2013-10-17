<cfset primaryTargetID_affiliate = Application.fn_GetPrimaryTargetID("affiliateID")>

<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceTarget" ReturnVariable="qry_selectPriceTarget">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="priceTargetWithTargetInfo" Value="False">
	<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_affiliate#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPriceTarget") and IsDefined("Form.affiliateID")>
	<cfloop Index="loopTargetID" List="#Form.affiliateID#">
		<cfif Not ListFind(ValueList(qry_selectPriceTarget.targetID), loopTargetID)>
			<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="insertPriceTarget" ReturnVariable="isPriceTargetInserted">
				<cfinvokeargument Name="priceID" Value="#URL.priceID#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_affiliate#">
				<cfinvokeargument Name="targetID" Value="#loopTargetID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="priceTargetStatus" Value="1">
				<cfinvokeargument Name="priceTargetOrder" Value="0">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cflocation url="index.cfm?method=#URL.method#&priceID=#URL.priceID##Variables.urlParameters#&confirm_price=#Variables.doAction#" AddToken="No">
</cfif>

<cfset URL.priceID_not = URL.priceID>
<cfset URL.priceID = "">
<cfset Variables.doAction = "listAffiliates">
<cfset Variables.doControl = "affiliate">
<cfinclude template="../control.cfm">

