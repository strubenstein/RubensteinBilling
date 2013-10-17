<cfoutput>
<p><table width="600"><tr><td class="MainText">
Product specifications are used to display specs specific to that product. They are also useful for displaying a table of specs about related or child products.
</td></tr></table></p>

<p class="MainText">You can select from the existing specification names or enter your own.<br>
The system will stop processing specs at the first blank spec name (where both select and text options are blank).<br>
To delete a spec, just blank out the spec name in the select list.<br>
To delete <i>all</i> specs, blank out the spec name in the first select list.</p>

<form name="productSpec" method="post" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="productSpecCount_orig" value="#HTMLEditFormat(Form.productSpecCount)#">

<cfif qry_selectProduct.productHasChildren is 1>
	<div class="TableText">[<a href="index.cfm?method=product.insertChildProductSpec&productID=#URL.productID#" class="plainlink">Add Specs For All Child Products</a>]</div>
</cfif>
<table border="1" cellspacing="2" cellpadding="2" class="MainText">
<tr class="TableHeader" valign="bottom">
	<th>##</th>
	<th>Existing/New Spec Name</th>
	<th>or</th>
	<th>New Spec Name</th>
	<th>Spec Value</th>
</tr>

<cfloop Index="count" From="1" To="#Form.productSpecCount#">
	<tr class="TableText" valign="top"<cfif (count mod 2) is 0> bgcolor="f4f4ff"</cfif>>
	<td align="right">#count#</td>
	<td align="center">
		<select name="productSpecName_select#count#" size="1">
		<option value="">-- SELECT SPEC NAME --</option>
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
	</td>
	<td align="center">or</td>
	<td align="center"><input type="text" name="productSpecName_text#count#" <cfif Variables.isSpecNameChecked is False> value="#HTMLEditFormat(Form["productSpecName_text#count#"])#"</cfif> size="15" maxlength="#maxlength_ProductSpec.productSpecName#"></td>
	<td align="center">&nbsp; <input type="text" name="productSpecValue#count#" value="#HTMLEditFormat(Form["productSpecValue#count#"])#" size="15" maxlength="#maxlength_ProductSpec.productSpecValue#"> &nbsp;</td>
	</tr>
</cfloop>

<tr>
	<td colspan="5" align="center">
		Enter new number of spec options: 
		<input type="text" name="productSpecCount" value="#HTMLEditFormat(Form.productSpecCount)#" size="3" maxlength="3"> 
		<input type="submit" name="submitProductSpecCount" value="Go">
	</td>
</tr>

<tr>
	<th colspan="5" height="40"><input type="submit" name="submitProductSpec" value="Update Product Specs"></th>
</tr>
</table>
</form>
</cfoutput>
