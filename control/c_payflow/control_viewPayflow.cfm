<cfif qry_selectPayflow.templateID is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Template" Method="selectTemplate" ReturnVariable="qry_selectTemplate">
		<cfinvokeargument Name="templateID" Value="#qry_selectPayflow.templateID#">
	</cfinvoke>
</cfif>

<cfinclude template="../../view/v_payflow/dsp_selectPayflow.cfm">