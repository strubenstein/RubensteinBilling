<cfif isWebServiceSessionActive is True>
	<cfinvoke Component="#Application.billingMapping#webservice.WebServiceSession" Method="updateWebServiceSession" ReturnVariable="isWebServiceSessionUpdated">
		<cfinvokeargument Name="webServiceSessionID" Value="#qry_selectWebServiceSession.webServiceSessionID#">
		<cfif IsDefined("returnError") and Trim(returnError) is not "">
			<cfinvokeargument Name="webServiceSessionLastError" Value="#returnError#">
		</cfif>
	</cfinvoke>
</cfif>
