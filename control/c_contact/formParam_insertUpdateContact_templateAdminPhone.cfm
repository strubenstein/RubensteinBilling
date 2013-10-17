<!--- customer phone fields --->
<cfinclude template="../../view/v_phone/var_phoneTypeList.cfm">

<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectAdminPhoneList">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<!--- <cfinvokeargument Name="companyID" Value="#Session.companyID#"> --->
	<cfinvokeargument Name="phoneType" Value="#Variables.phoneTypeList_value#">
	<cfinvokeargument Name="phoneStatus" Value="1">
</cfinvoke>

<cfloop Query="qry_selectAdminPhoneList">
	<cfset Variables.thePhoneNumber = "">
	<cfif qry_selectAdminPhoneList.phoneAreaCode is not "">
		<cfset Variables.thePhoneNumber = "(" & qry_selectAdminPhoneList.phoneAreaCode & ")">
	</cfif>
	<cfif qry_selectAdminPhoneList.phoneNumber is not "">
		<cfif Len(qry_selectAdminPhoneList.phoneNumber) is 7>
			<cfset Variables.thePhoneNumber = Variables.thePhoneNumber & Left(qry_selectAdminPhoneList.phoneNumber, 3) & "-" & Right(qry_selectAdminPhoneList.phoneNumber, 4)>
		<cfelse>
			<cfset Variables.thePhoneNumber = Variables.thePhoneNumber & qry_selectAdminPhoneList.phoneNumber>
		</cfif>
	</cfif>
	<cfif qry_selectAdminPhoneList.phoneExtension is not "">
		<cfset Variables.thePhoneNumber = Variables.thePhoneNumber & " ext. " & qry_selectAdminPhoneList.phoneExtension>
	</cfif>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<phone#qry_selectAdminPhoneList.phoneType#>>", thePhoneNumber, "ALL")>
</cfloop>
