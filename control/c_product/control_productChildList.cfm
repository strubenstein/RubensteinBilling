<cfset Variables.displayProductParent = False>
<cfif qry_selectProduct.productID_parent is not 0>
	<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductParent">
		<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
		<cfinvokeargument Name="productID" Value="#qry_selectProduct.productID_parent#">
		<cfinvokeargument Name="queryOrderBy" Value="productName">
	</cfinvoke>

	<cfif qry_selectProductParent.RecordCount is not 0>
		<cfset Variables.displayProductParent = True>
	</cfif>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Product" Method="selectProductList" ReturnVariable="qry_selectProductChildList">
	<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
	<cfinvokeargument Name="productID_parent" Value="#URL.productID#">
	<cfinvokeargument Name="queryOrderBy" Value="productChildOrder">
</cfinvoke>

<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">
<cfinclude template="../../view/v_product/lang_productChildList.cfm">

<cfset Variables.permissionActionList = Application.fn_IsUserAuthorizedList("unseparateChildProduct,separateChildProduct,viewProduct,moveChildProductDown,moveChildProductUp,fixChildProductOrder")>
<cfset Variables.columnHeaderList = Variables.lang_productChildList.productChildOrder
		& "^" & Variables.lang_productChildList.productID
		& "^" & Variables.lang_productChildList.productName
		& "^" & Variables.lang_productChildList.productChildType
		& "^" & Variables.lang_productChildList.productChildSeparate
		& "^" & Variables.lang_productChildList.productPrice
		& "^" & Variables.lang_productChildList.productStatus
		& "^" & Variables.lang_productChildList.productDateCreated>
<cfset Variables.columnOrderByList = "^False^False^False^False^False^False^False^False">

<cfif ListFind(Variables.permissionActionList, "viewProduct")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_productChildList.viewProduct>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>
<cfif ListFind(Variables.permissionActionList, "moveChildProductDown") and ListFind(Variables.permissionActionList, "moveChildProductUp")>
	<cfset Variables.columnHeaderList = Variables.columnHeaderList & "^" & Variables.lang_productChildList.switchProductChildOrder>
	<cfset Variables.columnOrderByList = Variables.columnOrderByList & "^False">
</cfif>

<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>

<cfinclude template="../../view/v_product/dsp_selectProductChildList.cfm">
