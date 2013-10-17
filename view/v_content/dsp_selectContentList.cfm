<cfoutput>
<cfif qry_selectContentList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no content listings in this content category.</p>
<cfelse>
	<!--- 
	<cfif Variables.displayContentLastUpdated is True>
		<p class="MainText">Last updated 
		<cfif qry_selectContentCompanyLastUpdated.firstName is not "" or qry_selectContentCompanyLastUpdated.lastName is not "">
			by #qry_selectContentCompanyLastUpdated.firstName# #qry_selectContentCompanyLastUpdated.lastName#
		</cfif>
		<cfif IsDate(qry_selectContentCompanyLastUpdated.contentCompanyDateUpdated)>
			on #DateFormat(qry_selectContentCompanyLastUpdated.contentCompanyDateUpdated, "dddd, mmmm dd, yyyy")# at #TimeFormat(qry_selectContentCompanyLastUpdated.contentCompanyDateUpdated, "hh:mm tt")#
		</cfif>
		</p>
	</cfif>
	--->

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.contentColumnCount, 0, 0, 0, Variables.contentColumnList, "", True)#
	<cfloop Query="qry_selectContentList">
		<cfset Variables.contentCompanyRow = ListFind(ValueList(qry_selectContentCompanyLastUpdated.contentID), qry_selectContentList.contentID)>
		<cfif qry_selectContentList.contentDescription is ""><cfset Variables.showDescription = False><cfelse><cfset Variables.showDescription = True></cfif>
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showDescription#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showDescription#','#Variables.bgcolor#');">
		<!--- <tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>> --->
		<td align="right">#qry_selectContentList.contentOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectContentList.contentName#<cfif qry_selectContentList.contentCode is not ""><br><i>#qry_selectContentList.contentCode#</i></cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentList.contentType is "">&nbsp;<cfelse>#qry_selectContentList.contentType#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentList.contentMaxlength is 0>-<cfelse>#qry_selectContentList.contentMaxlength#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentList.contentRequired is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentList.contentHtmlOk is 1>Yes<cfelse>-</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContentList.contentStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectContentList.contentDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>
			<cfif Variables.displayContentLastUpdated is False or Variables.contentCompanyRow is 0>
				-
			<cfelse>
				#DateFormat(qry_selectContentCompanyLastUpdated.contentCompanyDateCreated[Variables.contentCompanyRow], "mm-dd-yy")#
				<div class="SmallText">#TimeFormat(qry_selectContentCompanyLastUpdated.contentCompanyDateCreated[Variables.contentCompanyRow], "hh:mm tt")#</div>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif Variables.displayContentLastUpdated is False or Variables.contentCompanyRow is 0>
				-
			<cfelseif qry_selectContentCompanyLastUpdated.userID[Variables.contentCompanyRow] is 0>
				(default)
			<cfelse>
				#qry_selectContentCompanyLastUpdated.firstName[Variables.contentCompanyRow]#<br>#qry_selectContentCompanyLastUpdated.lastName[Variables.contentCompanyRow]#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td>
			<cfif Variables.displayContentLastUpdated is False or Variables.contentCompanyRow is 0>
				0
			<cfelseif qry_selectContentCompanyLastUpdated.contentCompanyOrder[Variables.contentCompanyRow] is 1>
				1
			<cfelse>
				#qry_selectContentCompanyLastUpdated.contentCompanyOrder[Variables.contentCompanyRow]#
				<cfif ListFind(Variables.permissionActionList, "viewContentCompanyOrder")>
					<div class="SmallText">(<a href="index.cfm?method=content.viewContentCompanyOrder&contentCategoryID=#URL.contentCategoryID#&contentID=#qry_selectContentList.contentID#" class="plainlink">view all</a>)</div>
				</cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<cfif ListFind(Variables.permissionActionList, "moveContentDown") and ListFind(Variables.permissionActionList, "moveContentUp")>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=content.moveContentDown&contentCategoryID=#URL.contentCategoryID#&contentID=#qry_selectContentList.contentID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=content.moveContentUp&contentCategoryID=#URL.contentCategoryID#&contentID=#qry_selectContentList.contentID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateContent")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=content.updateContent&contentID=#qry_selectContentList.contentID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>

		<cfif Variables.showDescription is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.bgcolor#');">
			<td colspan="2">&nbsp;</td>
			<td colspan="#Variables.contentColumnCount - 2#"><i>Description</i>: #qry_selectContentList.contentDescription#</td>
			</tr>
		</cfif>
	</cfloop>
	</table>
</cfif>
</cfoutput>

