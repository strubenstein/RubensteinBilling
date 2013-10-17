<cfinvoke Component="#Application.billingMapping#data.ProductSpec" Method="selectProductSpecList" ReturnVariable="qry_selectProductSpecList">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
	<cfinvokeargument Name="productSpecStatus" Value="1">
</cfinvoke>

<cfswitch expression="#Variables.doAction#">
<cfcase value="listProductSpecs">
	<cfinclude template="../../../view/v_product/v_productSpec/dsp_selectProductSpecList.cfm">
</cfcase>

<cfcase value="insertProductSpec">
	<cfinclude template="control_insertProductSpec.cfm">
</cfcase>

<cfcase value="insertChildProductSpec">
	<cfinclude template="control_insertProductChildSpec.cfm">
</cfcase>
</cfswitch>

