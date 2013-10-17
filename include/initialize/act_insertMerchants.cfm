<!--- AuthorizeNet --->
<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="insertMerchant" ReturnVariable="merchantID">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="merchantName" Value="AuthorizeNet">
	<cfinvokeargument Name="merchantTitle" Value="AuthorizeNet ">
	<cfinvokeargument Name="merchantBank" Value="1">
	<cfinvokeargument Name="merchantCreditCard" Value="1">
	<cfinvokeargument Name="merchantURL" Value="http://www.authorizenet.com">
	<cfinvokeargument Name="merchantDescription" Value="">
	<cfinvokeargument Name="merchantFilename" Value="authorizenet.cfm">
	<cfinvokeargument Name="merchantStatus" Value="1">
	<cfinvokeargument Name="merchantRequiredFields" Value="merchantAccountUsername,merchantAccountPassword">
</cfinvoke>

<!--- Bluepay --->
<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="insertMerchant" ReturnVariable="merchantID">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="merchantName" Value="Bluepay">
	<cfinvokeargument Name="merchantTitle" Value="BluePay ">
	<cfinvokeargument Name="merchantBank" Value="0">
	<cfinvokeargument Name="merchantCreditCard" Value="1">
	<cfinvokeargument Name="merchantURL" Value="http://www.bluepay.com">
	<cfinvokeargument Name="merchantDescription" Value="">
	<cfinvokeargument Name="merchantFilename" Value="bluepay.cfm">
	<cfinvokeargument Name="merchantStatus" Value="1">
	<cfinvokeargument Name="merchantRequiredFields" Value="merchantAccountUsername,merchantAccountPassword">
</cfinvoke>

<!--- Skipjack --->
<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="insertMerchant" ReturnVariable="merchantID">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="merchantName" Value="Skipjack">
	<cfinvokeargument Name="merchantTitle" Value="Skipjack ">
	<cfinvokeargument Name="merchantBank" Value="0">
	<cfinvokeargument Name="merchantCreditCard" Value="1">
	<cfinvokeargument Name="merchantURL" Value="http://www.skipjack.com">
	<cfinvokeargument Name="merchantDescription" Value="">
	<cfinvokeargument Name="merchantFilename" Value="skipjack.cfm">
	<cfinvokeargument Name="merchantStatus" Value="1">
	<cfinvokeargument Name="merchantRequiredFields" Value="merchantAccountUsername,merchantAccountPassword">
</cfinvoke>

<!--- Verisign Payflow Pro --->
<cfinvoke Component="#Application.billingMapping#data.Merchant" Method="insertMerchant" ReturnVariable="merchantID">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="merchantName" Value="Verisign">
	<cfinvokeargument Name="merchantTitle" Value="Verisign ">
	<cfinvokeargument Name="merchantBank" Value="0">
	<cfinvokeargument Name="merchantCreditCard" Value="1">
	<cfinvokeargument Name="merchantURL" Value="http://www.verisign.com">
	<cfinvokeargument Name="merchantDescription" Value="">
	<cfinvokeargument Name="merchantFilename" Value="verisign.cfm">
	<cfinvokeargument Name="merchantStatus" Value="1">
	<cfinvokeargument Name="merchantRequiredFields" Value="merchantAccountUsername,merchantAccountPassword">
</cfinvoke>

