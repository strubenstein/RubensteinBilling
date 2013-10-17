<cfoutput>
<p><table width="600"><tr><td class="MainText">
Use this form to create product specs for the parent product and/or child products using the same list of spec names.
</td></tr></table></p>

<form name="productSpec" method="post" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="productSpecCount_orig" value="#HTMLEditFormat(Form.productSpecCount)#">

<table border="1" cellspacing="2" cellpadding="2" class="MainText">
<tr class="TableHeader" valign="bottom">
	<th valign="bottom" rowspan="3">PRODUCT</th>
	<th align="right">##</th>
	<cfloop Index="count" From="1" To="#Form.productSpecCount#"><th>#count#</th></cfloop>
</tr>
<tr class="TableHeader" valign="bottom">
	<th nowrap align="right">Existing/New Spec Name</th>
	<cfloop Index="count" From="1" To="#Form.productSpecCount#">
		<th>
			<select name="productSpecName_select#count#" size="1" class="SmallText">
			<option value="">-- SPEC NAME --</option>
			<cfset Variables.lastSpecType = "">
			<cfset Variables.isSpecNameChecked = False>
			<cfloop Query="qry_selectProductSpecNameList">
				<cfif Variables.lastSpecType is not qry_selectProductSpecNameList.specType>
					<cfset Variables.lastSpecType = qry_selectProductSpecNameList.specType>
					<cfswitch expression="#ListLast(qry_selectProductSpecNameList.specType, "_")#">
					<cfcase value="companyID"><option value="">-- ALL SPEC NAMES --</option></cfcase>
					<cfcase value="productID_parent"><option value="">-- FROM CHILD PRODUCTS --</option></cfcase>
					<cfcase value="productID"><option value="">-- FROM THIS PRODUCT --</option></cfcase>
					<cfcase value="vendorID"><option value="">-- FROM THIS VENDOR --</option></cfcase>
					</cfswitch>
				</cfif>
				<option value="#HTMLEditFormat(qry_selectProductSpecNameList.productSpecName)#"<cfif Form["productSpecName_select#count#"] is qry_selectProductSpecNameList.productSpecName and Variables.isSpecNameChecked is False> selected<cfset Variables.isSpecNameChecked = True></cfif>>#HTMLEditFormat(qry_selectProductSpecNameList.productSpecName)#</option>
			</cfloop>
			</select>
		</th>
	</cfloop>
</tr>
<tr class="TableHeader" valign="bottom">
	<th align="right">OR &nbsp; New Spec Name</th>
	<cfloop Index="count" From="1" To="#Form.productSpecCount#"><th><input type="text" class="SmallText" name="productSpecName_text#count#" <cfif Variables.isSpecNameChecked is False> value="#HTMLEditFormat(Form["productSpecName_text#count#"])#"</cfif> size="20" maxlength="#maxlength_ProductSpec.productSpecName#"></th></cfloop>
</tr>

<cfloop Index="pCount" From="1" To="#ListLen(Variables.productID_list)#">
	<cfset Variables.thisProductID = ListGetAt(Variables.productID_list, pCount)>
	<tr class="TableText" valign="top"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td colspan="2"><cfif count is 1>#qry_selectProduct.productName# (<i>PARENT</i>)<cfelse>#qry_selectProductChildList.productName[count - 1]#</cfif></td>
	<cfloop Index="count" From="1" To="#Form.productSpecCount#">
		<td align="center">&nbsp; <input type="text" name="productSpecValue#count#_#Variables.thisProductID#" value="#HTMLEditFormat(Form["productSpecValue#count#_#Variables.thisProductID#"])#" size="15" maxlength="#maxlength_ProductSpec.productSpecValue#"> &nbsp;</td>
	</cfloop>
	</tr>
</cfloop>
</table>

<p class="MainText">
Enter new number of spec options: 
<input type="text" name="productSpecCount" value="#HTMLEditFormat(Form.productSpecCount)#" size="3" maxlength="3"> 
<input type="submit" name="submitProductSpecCount" value="Go">
</p>

<p><input type="submit" name="submitProductSpec" value="Update Product Specs"></p>
</form>
</cfoutput>
