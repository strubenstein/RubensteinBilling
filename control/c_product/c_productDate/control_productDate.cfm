<cfinvoke Component="#Application.billingMapping#data.ProductDate" Method="selectProductDateList" ReturnVariable="qry_selectProductDateList">
	<cfinvokeargument Name="productID" Value="#URL.productID#">
</cfinvoke>

<cfparam Name="URL.productDateID" Default="0">
<cfinclude template="../../../view/v_product/v_productDate/nav_productDate.cfm">

<cfswitch expression="#Variables.doAction#">
<cfcase value="insertProductDate">
	<cfinclude template="control_insertProductDate.cfm">
</cfcase>

<cfcase value="updateProductDate">
	<cfinclude template="control_updateProductDate.cfm">
</cfcase>

<cfcase value="deleteProductDate">
	<cfinclude template="control_deleteProductDate.cfm">
</cfcase>
</cfswitch>

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("insertProductDate,updateProductDate,deleteProductDate")>

<cfinclude template="../../../view/v_product/v_productDate/dsp_selectProductDateList.cfm">

