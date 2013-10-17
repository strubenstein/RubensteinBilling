<cfset primaryTargetID_group = Application.fn_GetPrimaryTargetID("groupID")>

<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="selectPriceTarget" ReturnVariable="qry_selectPriceTarget">
	<cfinvokeargument Name="priceID" Value="#URL.priceID#">
	<cfinvokeargument Name="priceTargetWithTargetInfo" Value="False">
	<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_group#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Group" Method="selectGroupList" ReturnVariable="qry_selectGroupList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfset Variables.formAction = Variables.navPriceAction><!---  & "&priceID=" & URL.priceID --->
<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitPriceTargetGroup") and IsDefined("Form.groupID")>
	<cfloop Index="loopGroupID" List="#Form.groupID#">
		<cfif Not ListFind(ValueList(qry_selectPriceTarget.targetID), loopGroupID)>
			<cfinvoke Component="#Application.billingMapping#data.PriceTarget" Method="insertPriceTarget" ReturnVariable="isPriceTargetInserted">
				<cfinvokeargument Name="priceID" Value="#URL.priceID#">
				<cfinvokeargument Name="primaryTargetID" Value="#primaryTargetID_group#">
				<cfinvokeargument Name="targetID" Value="#loopGroupID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="priceTargetStatus" Value="1">
				<cfinvokeargument Name="priceTargetOrder" Value="0">
			</cfinvoke>
		</cfif>
	</cfloop>

	<cflocation url="index.cfm?method=#URL.method#&priceID=#URL.priceID##Variables.urlParameters#&confirm_price=#Variables.doAction#" AddToken="No">
	<!--- <cflocation url="#Variables.formAction#&confirm_price=#Variables.doAction#" AddToken="No"> --->
</cfif>

<cfinclude template="../../view/v_price/lang_insertPriceTargetGroup.cfm">

<cfset Variables.groupColumnList = Variables.lang_insertPriceTargetGroup_title.priceTarget
		& "^" & Variables.lang_insertPriceTargetGroup_title.groupName
		& "^" & Variables.lang_insertPriceTargetGroup_title.groupStatus
		& "^" & Variables.lang_insertPriceTargetGroup_title.groupDescription>
<cfset Variables.groupColumnCount = DecrementValue(2 * ListLen(groupColumnList, "^"))>

<cfset Variables.formName = "priceTargetGroup">
<cfset Variables.formSubmitName = "submitPriceTargetGroup">
<cfset Variables.formSubmitValue = Variables.lang_insertPriceTargetGroup_title.formSubmitValue>
<cfset Form.groupID = ValueList(qry_selectPriceTarget.targetID)>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_group/form_groupTarget.cfm">
