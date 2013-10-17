
<cfinvoke Component="#Application.billingMapping#data.Template" Method="insertTemplate" ReturnVariable="templateID">
	<cfinvokeargument Name="companyID" Value="0">
	<cfinvokeargument Name="userID" Value="0">
	<cfinvokeargument Name="templateName" Value="Default Invoice Template">
	<cfinvokeargument Name="templateFilename" Value="defaultInvoice.cfm">
	<cfinvokeargument Name="templateType" Value="Invoice">
	<cfinvokeargument Name="templateDescription" Value="Default invoice/receipt template. Customizable.">
	<cfinvokeargument Name="templateStatus" Value="1">
</cfinvoke>
