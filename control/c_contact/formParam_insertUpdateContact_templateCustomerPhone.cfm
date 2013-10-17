<!--- customer phone fields --->
<cfinclude template="../../view/v_phone/var_phoneTypeList.cfm">

<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectCustomerPhoneList">
	<cfinvokeargument Name="userID" Value="#Variables.userID#">
	<!--- <cfinvokeargument Name="companyID" Value="#Variables.companyID#"> --->
	<cfinvokeargument Name="phoneType" Value="#Variables.phoneTypeList_value#">
	<cfinvokeargument Name="phoneStatus" Value="1">
</cfinvoke>

<cfloop Query="qry_selectCustomerPhoneList">
	<cfset Variables.thePhoneNumber = "">
	<cfif qry_selectCustomerPhoneList.phoneAreaCode is not "">
		<cfset Variables.thePhoneNumber = "(" & qry_selectCustomerPhoneList.phoneAreaCode & ")">
	</cfif>
	<cfif qry_selectCustomerPhoneList.phoneNumber is not "">
		<cfif Len(qry_selectCustomerPhoneList.phoneNumber) is 7>
			<cfset Variables.thePhoneNumber = Variables.thePhoneNumber & Left(qry_selectCustomerPhoneList.phoneNumber, 3) & "-" & Right(qry_selectCustomerPhoneList.phoneNumber, 4)>
		<cfelse>
			<cfset Variables.thePhoneNumber = Variables.thePhoneNumber & qry_selectCustomerPhoneList.phoneNumber>
		</cfif>
	</cfif>
	<cfif qry_selectCustomerPhoneList.phoneExtension is not "">
		<cfset Variables.thePhoneNumber = Variables.thePhoneNumber & " ext. " & qry_selectCustomerPhoneList.phoneExtension>
	</cfif>
	<cfset Form.contactMessage = ReplaceNoCase(Form.contactMessage, "<<phone#qry_selectCustomerPhoneList.phoneType#>>", thePhoneNumber, "ALL")>
</cfloop>
