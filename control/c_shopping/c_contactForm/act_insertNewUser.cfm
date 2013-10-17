<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUser" ReturnVariable="newUserID">
	<cfinvokeargument Name="firstName" Value="#Form.firstName#">
	<cfinvokeargument Name="lastName" Value="#Form.lastName#">
	<cfinvokeargument Name="email" Value="#Form.email#">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID#">
	<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID#">
	<cfinvokeargument Name="username" Value="">
	<cfinvokeargument Name="password" Value="">
</cfinvoke>

<cfset Variables.userID = newUserID>

<!--- company --->
<cfinvoke Component="#Application.billingMapping#data.Company" Method="insertCompany" ReturnVariable="newCompanyID">
	<cfinvokeargument Name="companyID_author" Value="#Session.companyID_author#">
	<cfinvokeargument Name="companyName" Value="#Form.companyName#">
	<cfinvokeargument Name="userID" Value="#newUserID#">
	<cfinvokeargument Name="affiliateID" Value="#Session.affiliateID#">
	<cfinvokeargument Name="cobrandID" Value="#Session.cobrandID#">
	<cfinvokeargument Name="companyID_parent" Value="0">
	<cfinvokeargument Name="userID_author" Value="0">
</cfinvoke>

<cfset Variables.companyID = newCompanyID>

<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
	<cfinvokeargument Name="userID" Value="#Variables.userID#">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.User" Method="insertUserCompany" ReturnVariable="isUserCompanyInserted">
	<cfinvokeargument Name="userID" Value="#Variables.userID#">
	<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
</cfinvoke>

<!--- phone --->
<cfif Variables.insertPhone is True and Trim(Form.phoneNumber) is not "">
	<cfinvoke Component="#Application.billingMapping#data.Phone" Method="insertPhone" ReturnVariable="phoneID">
		<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
		<cfinvokeargument Name="userID" Value="#Variables.userID#">
		<cfinvokeargument Name="userID_author" Value="0">
		<cfinvokeargument Name="phoneType" Value="phone">
		<cfinvokeargument Name="phoneAreaCode" Value="#Form.phoneAreaCode#">
		<cfinvokeargument Name="phoneNumber" Value="#REReplace(Form.phoneNumber, "[^0-9]", "", "ALL")#">
		<cfinvokeargument Name="phoneExtension" Value="#REReplace(Form.phoneExtension, "[^0-9]", "", "ALL")#">
	</cfinvoke>
</cfif>

<!--- address --->
<cfif Variables.insertAddress is True and (Trim(Form.address) is not "" or Trim(Form.city) is not "" or Trim(Form.state) is not "" or Trim(Form.zipCode) is not "")>
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="insertAddress" ReturnVariable="addressID">
		<cfinvokeargument Name="companyID" Value="#Variables.companyID#">
		<cfinvokeargument Name="userID" Value="#Variables.userID#">
		<cfinvokeargument Name="userID_author" Value="0">
		<cfinvokeargument Name="address" Value="#Form.address#">
		<cfinvokeargument Name="city" Value="#Form.city#">
		<cfinvokeargument Name="state" Value="#Form.state#">
		<cfinvokeargument Name="zipCode" Value="#Form.zipCode#">
		<cfinvokeargument Name="country" Value="#Form.country#">
	</cfinvoke>
</cfif>
