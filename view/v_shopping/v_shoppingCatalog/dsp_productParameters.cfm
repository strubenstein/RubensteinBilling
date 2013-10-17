<!--- <input type="image" name="product#qry_selectProductChildList.productID#" src="/images/img_store/addtocart.gif" width="87" height="20" alt="Add to Cart" border="0">	--->
<cfoutput>
<div class="MainText"><b>Please select the product parameters:</b></div>
<table border="0" cellspacing="2" cellpadding="2" class="TableText">
<cfloop Query="qry_selectProductParameterList">
	<cfset Variables.thisParameterID = qry_selectProductParameterList.productParameterID>
	<cfset Variables.parameterRow = ListFind(ValueList(qry_selectProductParameterOptionList.productParameterID), Variables.thisParameterID)>
	<cfif Variables.parameterRow is not 0>
		<tr>
			<td>#qry_selectProductParameterList.productParameterText#: </td>
			<td>
				<select name="parameter#Variables.thisParameterID#" size="1" class="TableText">
				<cfloop Query="qry_selectProductParameterOptionList" StartRow="#Variables.parameterRow#">
					<cfif qry_selectProductParameterOptionList.productParameterID is not Variables.thisParameterID><cfbreak></cfif>
					<option value="#qry_selectProductParameterOptionList.productParameterOptionID#">#HTMLEditFormat(qry_selectProductParameterOptionList.productParameterOptionLabel)#</option>
				</cfloop>
				</select>
			</td>
		</tr>
	</cfif>
</cfloop>
</table>

<cfif Variables.displayProductParameterException is True>
	<div class="TableText">
	<cfloop Query="qry_selectProductParameterExceptionList">#productParameterExceptionText#<br></cfloop>
	</div>
</cfif>
</cfoutput>
