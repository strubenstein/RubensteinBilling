<cfset Variables.primaryTargetObj = Replace(Variables.doAction, "insertCommissionTarget", "", "ONE")>
<cfset Variables.doControl = LCase(Variables.primaryTargetObj)>
<cfset Variables.primaryTargetKey = Variables.doControl & "ID">
<cfset Variables.primaryTargetID_target = Application.fn_GetPrimaryTargetID(Variables.primaryTargetKey)>

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitCommissionTarget") and IsDefined("Form.#Variables.primaryTargetKey#") and Application.fn_IsIntegerList(Form[Variables.primaryTargetKey])>
	<cfinvoke Component="#Application["obj#Variables.primaryTargetObj#"]#" Method="check#Variables.primaryTargetObj#Permission" ReturnVariable="isTargetPermission">
		<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
		<cfinvokeargument Name="#Variables.primaryTargetKey#" Value="#Form[Variables.primaryTargetKey]#">
	</cfinvoke>

	<cfif isTargetPermission is False>
		<cflocation url="index.cfm?method=#URL.method#&commissionID=#URL.commissionID##Variables.urlParameters#&error_commission=#Variables.doAction#" AddToken="No">
	<cfelse>
		<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="selectCommissionTarget" ReturnVariable="qry_selectCommissionTarget">
			<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
			<cfinvokeargument Name="commissionTargetWithTargetInfo" Value="False">
			<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID_target#">
			<cfinvokeargument Name="targetID" Value="#Form[Variables.primaryTargetKey]#">
			<cfinvokeargument Name="commissionTargetStatus" Value="1">
		</cfinvoke>

		<cfloop Index="loopTargetID" List="#Form[Variables.primaryTargetKey]#">
			<cfif Not ListFind(ValueList(qry_selectCommissionTarget.targetID), loopTargetID)>
				<cfinvoke Component="#Application.billingMapping#data.CommissionTarget" Method="insertCommissionTarget" ReturnVariable="isCommissionTargetInserted">
					<cfinvokeargument Name="commissionID" Value="#URL.commissionID#">
					<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID_target#">
					<cfinvokeargument Name="targetID" Value="#loopTargetID#">
					<cfinvokeargument Name="userID" Value="#Session.userID#">
					<cfinvokeargument Name="commissionTargetStatus" Value="1">
				</cfinvoke>
			</cfif>
		</cfloop>

		<cfif IsDefined("Form.#Variables.doControl#ListRedirect") and Trim(Form["#Variables.doControl#ListRedirect"]) is not "">
			<cflocation url="#Form['#Variables.doControl#ListRedirect']#&confirm_commission=#Variables.doAction#" AddToken="No">
		<cfelse>
			<cflocation url="index.cfm?method=#URL.method#&commissionID=#URL.commissionID##Variables.urlParameters#&confirm_commission=#Variables.doAction#" AddToken="No">
		</cfif>
	</cfif>
</cfif>

<!--- <cfset Form["#Variables.primaryTargetKey#_not"] = ValueList(qry_selectCommissionTarget.targetID)> --->
<cfset URL.commissionID_not = URL.commissionID>
<cfset URL.commissionID = "">

<cfif Variables.doControl is "company">
	<cfset Variables.doAction = "listCompanies">
<cfelse>
	<cfset Variables.doAction = "list" & Variables.primaryTargetObj & "s">
</cfif>

<cfif Variables.doControl is "user">
	<cfset URL.companyID = "">
	<cfset Form.returnMyCompanyUsersOnly = 1>
</cfif>

<cfinclude template="../control.cfm">
