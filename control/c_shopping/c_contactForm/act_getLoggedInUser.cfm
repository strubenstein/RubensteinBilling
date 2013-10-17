<cfset Variables.userID = Session.userID>
<cfset Variables.companyID = Session.companyID>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfset Form.email = qry_selectUser.email>
<cfset Form.firstName = qry_selectUser.firstName>
<cfset Form.lastName = qry_selectUser.lastName>
<cfset Form.companyName = qry_selectCompany.companyName>
