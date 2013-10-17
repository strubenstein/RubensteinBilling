<cfoutput>
<p><table width="600"><tr><td class="MainText">
Product is available to customers unless otherwise specified via the various dates ranges the product is available. A product can be available as of a beginning date or within one or more date ranges.
</td></tr></table></p>

<cfif qry_selectProductDateList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no date availability restrictions for this product.</p>
<cfelse>
	<script language="Javascript" Type="text/javascript">
	<!--
	function confirmCheck() {
		if(document.productDateDelete.okSubmit.checked == 0) {
			alert('You must confirm your delete request.');
			return false;
		}
		else return true;
	}
	//-->
	</script>

	<cfif ListFind(Variables.permissionActionList, "deleteProductDate")>
		<form method="post" name="productDateDelete" action="index.cfm?method=product.deleteProductDate&productID=#URL.productID#">
		<input type="hidden" name="isFormSubmitted" value="True">
	</cfif>

	<table border="1" cellspacing="2" cellpadding="2">
	<tr class="TableHeader" valign="bottom">
		<th>Begins</th>
		<th>Ends</th>
		<th>Created</th>
		<th>Status</th>
		<cfif ListFind(Variables.permissionActionList, "updateProductDate")>
			<th>Update</th>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteProductDate")>
			<th>Delete</th>
		</cfif>
	</tr>

	<cfloop Query="qry_selectProductDateList">
		<tr class="TableText" valign="top"<cfif URL.productDateID is qry_selectProductDateList.productDateID> bgcolor="66FF99"<cfelseif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif>>
		<td align="center" nowrap>#DateFormat(qry_selectProductDateList.productDateBegin, "ddd, mmm dd, yyyy")#<br>at #TimeFormat(qry_selectProductDateList.productDateBegin, "hh:mm tt")#</td>
		<td align="center" nowrap><cfif Not IsDate(qry_selectProductDateList.productDateEnd)>n/a<cfelse>#DateFormat(qry_selectProductDateList.productDateEnd, "ddd, mmm dd, yyyy")#<br>at #TimeFormat(qry_selectProductDateList.productDateEnd, "hh:mm tt")#</cfif></td>
		<td align="center" nowrap>#DateFormat(qry_selectProductDateList.productDateDateCreated, "mm-dd-yy")#</td>
		<td align="center"><cfif qry_selectProductDateList.productDateStatus is 0>Not Live<cfelse>Live</cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updateProductDate")>
			<td align="center" class="SmallText"><a href="index.cfm?method=product.updateProductDate&productID=#URL.productID#&productDateID=#qry_selectProductDateList.productDateID#" class="plainlink">Update</a></td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "deleteProductDate")>
			<td align="center"><input type="checkbox" name="productDateID" value="#qry_selectProductDateList.productDateID#"></td>
		</cfif>
		</tr>
	</cfloop>
	</table>

	<cfif ListFind(Variables.permissionActionList, "")>
		<p class="TableText"><input type="checkbox" name="okSubmit" value="True"> Check to confirm delete request.<br>
		<input type="submit" name="submitProductDateDelete" value="Delete Date(s)" onClick="return confirmCheck();"></p>
		</form>
	</cfif>
</cfif>
</cfoutput>

