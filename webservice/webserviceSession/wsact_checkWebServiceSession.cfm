<cfinvoke Component="#Application.billingMapping#webservice.WebServiceSession" Method="selectWebServiceSession" ReturnVariable="qry_selectWebServiceSession">
	<cfinvokeargument Name="webServiceSessionUUID" Value="#Arguments.sessionUUID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#webservice.WebServiceSession" Method="checkWebServiceSession" ReturnVariable="isWebServiceSessionActive">
	<cfinvokeargument Name="qry_selectWebServiceSession" Value="#qry_selectWebServiceSession#">
</cfinvoke>

