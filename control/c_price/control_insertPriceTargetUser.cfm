<cfset primaryTargetID_user = Application.fn_GetPrimaryTargetID("userID")>

<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceTarget" ReturnVariable="qry_selectPriceTarget">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="priceTargetWithTargetInfo" Value="False">
	<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_user#">
</cfinvoke>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPriceTargetUser") and IsDefined("Form.userID")>
	<cfloop Index="loopUserID" List="#Form.userID#">
		<cfif Not ListFind(ValueList(qry_selectPriceTarget.targetID), loopUserID)>
			<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="insertPriceTarget" ReturnVariable="isPriceTargetInserted">
				<cfinvokeargument Name="priceID" Value="#URL.priceID#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_user#">
				<cfinvokeargument Name="targetID" Value="#loopUserID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="priceTargetStatus" Value="1">
				<cfinvokeargument Name="priceTargetOrder" Value="0">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cfif IsDefined("Form.userListRedirect") and Trim(Form.userListRedirect) is not "">
		<cflocation url="#Form.userListRedirect#&confirm_price=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.method#&priceID=#URL.priceID##Variables.urlParameters#&confirm_price=#Variables.doAction#" AddToken="No">
	</cfif>

	<!--- 
	<cfelseif ListFirst(URL.method, ".") is "category">
		<cflocation url="index.cfm?method=#URL.method#&categoryID=#URL.categoryID#&priceID=#URL.priceID#&confirm_price=#URL.action#" AddToken="No">
	<cfelseif ListFirst(URL.method, ".") is "product">
		<cflocation url="index.cfm?method=#URL.method#&productID=#URL.productID#&priceID=#URL.priceID#&confirm_price=#URL.action#" AddToken="No">
	<cfelse>
		<cflocation url="index.cfm?method=#URL.method#&priceID=#URL.priceID#&confirm_price=#URL.action#" AddToken="No">
	--->
</cfif>

<cfset URL.companyID = "">
<cfset Form.userID_not = ValueList(qry_selectPriceTarget.targetID)>
<cfset Variables.doControl = "user">
<cfset Variables.doAction = "listUsers">
<cfinclude template="../control.cfm">

