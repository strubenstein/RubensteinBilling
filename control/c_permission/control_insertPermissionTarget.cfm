<!--- set default permissions for target AND target company --->
<cfloop Query="qry_selectPermissionCategoryList">
	<cfparam Name="Form.permissionBinary#qry_selectPermissionCategoryList.permissionCategoryID#" Default="0">
	<cfparam Name="Variables.permissionBinaryCompany#qry_selectPermissionCategoryList.permissionCategoryID#" Default="0">
</cfloop>

<cfset Variables.primaryTargetKey = Application.fn_GetPrimaryTargetKey(Variables.primaryTargetID)>
<!--- select permissions for company that this target belongs to --->
<cfinvoke Component="#Application.billingMapping#data.PermissionTarget" Method="selectPermissionTargetList" ReturnVariable="qry_selectPermissionTargetList_company">
	<cfinvokeargument Name="permissionTargetStatus" Value="1">
	<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("companyID")#">
	<cfswitch expression="#Variables.primaryTargetKey#">
	  <cfcase value="companyID"><cfinvokeargument Name="targetID" Value="#Session.companyID#"></cfcase>
	  <cfcase value="userID"><cfinvokeargument Name="targetID" Value="#qry_selectUser.companyID#"></cfcase>
	  <cfcase value="groupID"><cfinvokeargument Name="targetID" Value="#qry_selectGroup.companyID#"></cfcase>
	</cfswitch>
</cfinvoke>

<cfloop Query="qry_selectPermissionTargetList_company">
	<cfset Variables["permissionBinaryCompany#qry_selectPermissionTargetList_company.permissionCategoryID#"] = qry_selectPermissionTargetList_company.permissionTargetBinaryTotal>
</cfloop>

<!--- select all permissions --->
<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionList" ReturnVariable="qry_selectPermissionList_all">
	<cfinvokeargument Name="permissionStatus" Value="1">
	<cfif Session.companyID is not Application.billingSuperuserCompanyID or (URL.control is "user" and IsDefined("qry_selectUser") and qry_selectUser.companyID is not Application.billingSuperuserCompanyID)>
		<cfinvokeargument Name="permissionSuperuserOnly" Value="0">
	</cfif>
</cfinvoke>

<!--- determine which permissions this company has, and re-select the list of permissions --->
<cfset Variables.companyPermissionID_list = 0>
<cfloop Query="qry_selectPermissionList_all">
	<cfif (Variables.primaryTargetKey is "companyID" and Session.companyID is Application.billingSuperuserCompanyID and Application.billingSuperuserEnabled is True)
			or BitAnd(Variables["permissionBinaryCompany#qry_selectPermissionList_all.permissionCategoryID#"], qry_selectPermissionList_all.permissionBinaryNumber)>
		<cfset Variables.companyPermissionID_list = ListAppend(Variables.companyPermissionID_list, qry_selectPermissionList_all.permissionID)>
	</cfif>
</cfloop>

<!--- select available permissions for this target --->
<cfinvoke Component="#Application.billingMapping#data.Permission" Method="selectPermissionList" ReturnVariable="qry_selectPermissionList">
	<cfinvokeargument Name="permissionID" Value="#Variables.companyPermissionID_list#">
</cfinvoke>

<cfif Variables.doAction is "insertPermissionTarget" and IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitTargetPermission")>
	<cfparam Name="Form.permissionID" Default="">
	<cfset Variables.permissionCategoryStruct = StructNew()>
	<cfloop Query="qry_selectPermissionList">
		<cfif ListFind(Form.permissionID, qry_selectPermissionList.permissionID)><!--- permission was checked --->
			<cfif Not StructKeyExists(Variables.permissionCategoryStruct, "permCat_#qry_selectPermissionList.permissionCategoryID#")>
				<cfset Variables.permissionCategoryStruct["permCat_#qry_selectPermissionList.permissionCategoryID#"] = qry_selectPermissionList.permissionBinaryNumber>
			<cfelse>
				<cfset Variables.permissionCategoryStruct["permCat_#qry_selectPermissionList.permissionCategoryID#"] = Variables.permissionCategoryStruct["permCat_#qry_selectPermissionList.permissionCategoryID#"] + qry_selectPermissionList.permissionBinaryNumber>
			</cfif>
		</cfif>
	</cfloop>

	<cfinvoke Component="#Application.billingMapping#data.Permission" Method="insertPermissionTarget" ReturnVariable="isTargetPermissionInserted">
		<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
		<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
		<cfinvokeargument Name="userID" Value="#Session.userID#">
		<cfinvokeargument Name="permissionCategoryStruct" Value="#Variables.permissionCategoryStruct#">
	</cfinvoke>

	<cflocation url="#Variables.formAction#&confirm_#Variables.permissionControl#=#Variables.doAction#" AddToken="No">
</cfif>

<cfinvoke Component="#Application.billingMapping#data.PermissionTarget" Method="selectPermissionTargetOrderList" ReturnVariable="qry_selectPermissionTargetOrderList">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
</cfinvoke>

<cfset Variables.displayPermissionTargetOrder = False>
<cfif qry_selectPermissionTargetOrderList.RecordCount lte 1>
	<cfparam Name="Form.permissionTargetOrder" Default="0">
<cfelse>
	<cfparam Name="Form.permissionTargetOrder" Default="#qry_selectPermissionTargetOrderList.permissionTargetOrder[qry_selectPermissionTargetOrderList.RecordCount]#">
	<cfif Application.fn_IsIntegerPositive(Form.permissionTargetOrder) and Form.permissionTargetOrder lt qry_selectPermissionTargetOrderList.RecordCount>
		<cfset Variables.doAction = "viewPermissionTarget">
		<cfset Variables.displayPermissionTargetOrder = True>
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.PermissionTarget" Method="selectPermissionTargetList" ReturnVariable="qry_selectPermissionTargetList">
	<cfinvokeargument Name="primaryTargetID" Value="#Variables.primaryTargetID#">
	<cfinvokeargument Name="targetID" Value="#Variables.targetID#">
	<cfif Variables.displayPermissionTargetOrder is False>
		<cfinvokeargument Name="permissionTargetStatus" Value="1">
	<cfelse>
		<cfinvokeargument Name="permissionTargetOrder" Value="#Form.permissionTargetOrder#">
	</cfif>
</cfinvoke>

<cfloop Query="qry_selectPermissionTargetList">
	<cfset Form["permissionBinary#qry_selectPermissionTargetList.permissionCategoryID#"] = qry_selectPermissionTargetList.permissionTargetBinaryTotal>
</cfloop>

<cfset Variables.formAction_view = Variables.formAction>
<cfif Variables.doAction is "viewPermissionTarget">
	<cfset Variables.formAction = "">
</cfif>
<cfinclude template="../../view/v_permission/form_insertPermissionTarget.cfm">
