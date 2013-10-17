<cfoutput>
<cfif qry_selectCommissionList.RecordCount is 0>
	<p class="ErrorMessage">There are no commission plans that meet your criteria.</p>
	<!--- 
	<cfif StructKeyExists(Arguments, "groupID")>this group
	<cfelseif StructKeyExists(Arguments, "userID")>this salesperson
	<cfelseif StructKeyExists(Arguments, "companyID")>this company
	<cfelseif StructKeyExists(Arguments, "affiliateID")>this affiliate
	<cfelseif StructKeyExists(Arguments, "cobrandID")>this cobrand
	<cfelseif StructKeyExists(Arguments, "vendorID")>this vendor
	<cfelseif StructKeyExists(Arguments, "regionID")>this region
	<cfelseif StructKeyExists(Arguments, "categoryID")>this category
	<cfelseif StructKeyExists(Arguments, "productID")>this product
	<cfelse>all products or to the entire invoice</cfif>
	 at this time.
	 --->
<cfelse>
	<script language="JavaScript">
	function toggle(target)
	{ obj=(document.all) ? document.all[target] : document.getElementById(target);
	  obj.style.display=(obj.style.display=='none') ? 'inline' : 'none';
	}
	
	var clicks = 0;
	function ChangeText(obj, originalText, clickText)
	{
		if(clicks == 0)
		{
			obj.innerHTML = clickText;
			clicks = 1;
		}
		else
		{
			obj.innerHTML = originalText;
			clicks = 0;
		}	
	}
	</script>

	<cfif Not IsDefined("fn_ReturnCommissionInterval")>
		<cfinclude template="fn_selectCommissionList.cfm">
	</cfif>

	<!--- 
	Below are the commissions for 
	<cfif StructKeyExists(Arguments, "groupID")>this group.
	<cfelseif StructKeyExists(Arguments, "userID")>this salesperson.
	<cfelseif StructKeyExists(Arguments, "companyID")>this company.
	<cfelseif StructKeyExists(Arguments, "affiliateID")>this affiliate.
	<cfelseif StructKeyExists(Arguments, "cobrandID")>this cobrand.
	<cfelseif StructKeyExists(Arguments, "vendorID")>this vendor.
	<cfelseif StructKeyExists(Arguments, "regionID")>this region.
	<cfelseif StructKeyExists(Arguments, "categoryID")>this category.
	<cfelseif StructKeyExists(Arguments, "productID")>this product.
	<cfelse>all products or to the entire invoice.
	</cfif>
	--->
	<p class="MainText">To display the commission targets and volume details, click &quot;Show Details&quot;.</p>

	<cfparam Name="URL.showDetails" Default="False">
	<cfif URL.showDetails is False>
		<cfset Variables.showText = "Show Details">
		<cfset Variables.hideText = "Hide Details">
	<cfelse>
		<cfset Variables.showText = "Hide Details">
		<cfset Variables.hideText = "Show Details">
	</cfif>
	<div class="MainText">
	[<a href="#Variables.queryViewAction#&showDetails=True" class="plainlink"><cfif URL.showDetails is True><b>Show All Details</b><cfelse>Show All Details</cfif></a>] 
	[<a href="#Variables.queryViewAction#&showDetails=False" class="plainlink"><cfif URL.showDetails is False><b>Hide All Details</b><cfelse>Hide All Details</cfif></a>]
	</div>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, "", True)#
	<cfset Variables.rowBG = 1>
	<cfloop Query="qry_selectCommissionList">
		<cfset Variables.currentCommissionID = qry_selectCommissionList.commissionID>
		<cfset Variables.currentCommissionStageID = qry_selectCommissionList.commissionStageID>
		<cfif CurrentRow is 1 or qry_selectCommissionList.commissionID is not qry_selectCommissionList.commissionID[CurrentRow - 1]>
			<cfset Variables.rowBG = Iif(Variables.rowBG is 1, 0, 1)>
			<tr class="TableText" valign="top"<cfif Variables.rowBG is 1> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
			<cfif Variables.displayCommissionID_custom is True>
				<td><cfif qry_selectCommissionList.commissionID_custom is "">-<cfelse>#qry_selectCommissionList.commissionID_custom#</cfif></td>
				<td>&nbsp;</td>
			</cfif>
			<td><cfif qry_selectCommissionList.commissionName is "">(<i>No Name</i>)<cfelse>#qry_selectCommissionList.commissionName#</cfif></td>
			<td>&nbsp;</td>
			<td>
				<cfswitch expression="#qry_selectCommissionList.commissionPeriodIntervalType#">
				<cfcase value="m">Monthly</cfcase>
				<cfcase value="q">Quarterly</cfcase>
				<cfdefaultcase>Each Invoice</cfdefaultcase>
				</cfswitch><br>
				<cfif qry_selectCommissionList.commissionHasMultipleStages is 0>
					#fn_DisplayCommissionAmount(qry_selectCommissionList.commissionStageAmount, qry_selectCommissionList.commissionStageDollarOrPercent, qry_selectCommissionList.commissionStageVolumeDiscount, qry_selectCommissionList.commissionStageVolumeDollarOrQuantity, qry_selectCommissionList.commissionStageVolumeStep)#
				<cfelse>
					<table border="0" cellspacing="0" cellpadding="0">
					<tr><td class="SmallText">Stage ###qry_selectCommissionList.commissionStageOrder#</i> - #fn_ReturnCommissionInterval(qry_selectCommissionList.commissionStageInterval, qry_selectCommissionList.commissionStageIntervalType)#</td></tr>
					<tr><td class="TableText">#fn_DisplayCommissionAmount(qry_selectCommissionList.commissionStageAmount, qry_selectCommissionList.commissionStageDollarOrPercent, qry_selectCommissionList.commissionStageVolumeDiscount, qry_selectCommissionList.commissionStageVolumeDollarOrQuantity, qry_selectCommissionList.commissionStageVolumeStep)#</td></tr>
					<cfloop Index="commissionRow" From="#IncrementValue(qry_selectCommissionList.CurrentRow)#" To="#qry_selectCommissionList.RecordCount#">
						<cfif qry_selectCommissionList.commissionID[commissionRow] is not Variables.currentCommissionID><cfbreak></cfif>
						<tr><td class="SmallText" height="3"><img src="#Application.billingUrlroot#/images/aline.gif" width="125" height="1" alt="" border="0"></td></tr>
						<tr><td class="SmallText">Stage ###qry_selectCommissionList.commissionStageOrder[commissionRow]# - #fn_ReturnCommissionInterval(qry_selectCommissionList.commissionStageInterval[commissionRow], qry_selectCommissionList.commissionStageIntervalType[commissionRow])#</td></tr>
						<tr><td class="TableText">#fn_DisplayCommissionAmount(qry_selectCommissionList.commissionStageAmount[commissionRow], qry_selectCommissionList.commissionStageDollarOrPercent[commissionRow], qry_selectCommissionList.commissionStageVolumeDiscount[commissionRow], qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[commissionRow], qry_selectCommissionList.commissionStageVolumeStep[commissionRow])#</td></tr>
					</cfloop>
					</table>
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td nowrap>#DateFormat(qry_selectCommissionList.commissionDateBegin, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectCommissionList.commissionDateBegin, "hh:mm tt")#</div></td>
			<td>&nbsp;</td>
			<td nowrap><cfif Not IsDate(qry_selectCommissionList.commissionDateEnd)>-<cfelse>#DateFormat(qry_selectCommissionList.commissionDateEnd, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectCommissionList.commissionDateEnd, "hh:mm tt")#</div></cfif></td>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectCommissionList.commissionStatus is 0>
					<font color="red">Inactive</font>
				<cfelse>
					<font color="green">Live</font>
					<cfif ListFind(Variables.permissionActionList, "updateCommissionStatus")>
						<div class="SmallText"><a href="index.cfm?method=#Variables.commissionControl#.updateCommissionStatus#Variables.urlParameters#&commissionID=#qry_selectCommissionList.commissionID#" class="plainlink">Make Inactive</a></div>
					</cfif>
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td><cfif qry_selectCommissionList.commissionAppliedStatus is 0>-<cfelse>Yes</cfif></td>
			<td>&nbsp;</td>
			<td nowrap>#DateFormat(qry_selectCommissionList.commissionDateCreated, "mm-dd-yy")#</td>
			<td>&nbsp;</td>
			<td nowrap><cfif qry_selectCommissionList.commissionStatus is 1>-<cfelse>#DateFormat(qry_selectCommissionList.commissionDateUpdated, "mm-dd-yy")#</cfif></td>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif ListFind(Variables.permissionActionList, "viewCommission")><a href="index.cfm?method=#Variables.commissionControl#.viewCommission#Variables.urlParameters#&commissionID=#qry_selectCommissionList.commissionID#" class="plainlink">Manage</a><br></cfif>
				<a href="javascript:void(0);" class="plainlink" onClick="toggle('commission#qry_selectCommissionList.commissionID#');ChangeText(this,'#Variables.showText#', '#Variables.hideText#');">#Variables.showText#</a>
			</td>
			</tr>

			<tr id="commission#qry_selectCommissionList.commissionID#"<cfif URL.showDetails is False> style="display:none;"</cfif> valign="top"<cfif Variables.rowBG is 1> bgcolor="f4f4ff"</cfif>>
			<td <cfif Variables.displayCommissionID_custom is True>colspan="7"<cfelse>colspan="5"</cfif>>
				<cfif Variables.isVolumeDiscount is True>
					<cfloop Index="commissionRow" From="#qry_selectCommissionList.CurrentRow#" To="#qry_selectCommissionList.RecordCount#">
						<cfif qry_selectCommissionList.commissionID[commissionRow] is not Variables.currentCommissionID><cfbreak></cfif>
						<cfset Variables.volumeDiscountRowStart = ListFind(ValueList(qry_selectCommissionVolumeDiscount.commissionStageID), qry_selectCommissionList.commissionStageID[commissionRow])>
						<cfif Variables.volumeDiscountRowStart gt 0>
							<cfset Variables.volumeDollarOrQuantity = qry_selectCommissionList.commissionStageVolumeDollarOrQuantity[commissionRow]>
							<cfset Variables.volumeStep = qry_selectCommissionList.commissionStageVolumeStep[commissionRow]>
							<cfset Variables.dollarOrPercent = qry_selectCommissionList.commissionStageDollarOrPercent[commissionRow]>

							<table border="1" cellspacing="0" cellpadding="0">
							<cfif qry_selectCommissionList.commissionHasMultipleStages[commissionRow] is 1>
								<tr valign="bottom" class="TableHeader">
									<th colspan="4"><i>Stage ###qry_selectCommissionList.commissionStageOrder[commissionRow]#</i> - #fn_ReturnCommissionInterval(qry_selectCommissionList.commissionStageInterval[commissionRow], qry_selectCommissionList.commissionStageIntervalType[commissionRow])#</th>
								</tr>
							</cfif>
							<tr valign="bottom" class="TableHeader">
								<th>Min. <cfif Variables.volumeDollarOrQuantity is 0>Order ($)<cfelse>Quantity (##)</cfif></th>
								<th><cfif Variables.dollarOrPercent is 0>Commission<br>Amount ($)<cfelse>% of<br>Revenue</cfif></th>
							</tr>
							<cfset Variables.currentCommissionStageID = qry_selectCommissionList.commissionStageID[commissionRow]>
							<cfloop Query="qry_selectCommissionVolumeDiscount" StartRow="#Variables.volumeDiscountRowStart#">
								<cfif qry_selectCommissionVolumeDiscount.commissionStageID is not Variables.currentCommissionStageID><cfbreak></cfif>
								<tr class="TableText" valign="top" align="center">
								<td><cfif Variables.volumeDollarOrQuantity is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum)#<cfelse>#Application.fn_LimitPaddedDecimalZerosQuantity(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountQuantityMinimum)#</cfif></td>
								<td><cfif Variables.dollarOrPercent is 0>$#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount)#<cfelse>#Application.fn_LimitPaddedDecimalZerosDollar(qry_selectCommissionVolumeDiscount.commissionVolumeDiscountAmount * 100)#%</cfif><br></td>
								</tr>
							</cfloop>
							</table>
						</cfif>
					</cfloop>
				</cfif>
			</td>
			<td class="SmallText" colspan="#DecrementValue(Variables.columnCount)#">
				Created by #qry_selectCommissionList.firstName# #qry_selectCommissionList.lastName#.<br>
				<cfif qry_selectCommissionList.commissionAppliesToInvoice is 0>
					Applied to products (via product or category)<br>
				<cfelse>
					Applied to entire invoice. 
					<cfif qry_selectCommissionList.commissionAppliesToExistingProducts is 1>Includes existing products. </cfif>
					<cfif qry_selectCommissionList.commissionAppliesToCustomProducts is 1>Includes custom products. </cfif>
				</cfif>
				<cfif qry_selectCommissionList.commissionDescription is not ""><br><i>Description</i>: #qry_selectCommissionList.commissionDescription#</cfif>
			</td>
			</tr>
		</cfif>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Form.queryOrderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#
</cfif>
</cfoutput>
