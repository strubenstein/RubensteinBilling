<cfoutput>
<cfif qry_selectContactTemplateList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no contact management templates.</p>
<cfelse>
	<cfset Variables.lastPrimaryTargetID = -1>
	<cfset Variables.nextPrimaryTargetID = -1>

	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.contactTemplateColumnCount, 0, 0, 0, Variables.contactTemplateColumnList, "", True)#
	<cfloop Query="qry_selectContactTemplateList">
		<cfif qry_selectContactTemplateList.primaryTargetID is not Variables.lastPrimaryTargetID>
			<cfset Variables.primaryTargetRow = ListFind(ValueList(qry_selectPrimaryTargetList.primaryTargetID), qry_selectContactTemplateList.primaryTargetID)>
			<tr class="TableText" valign="top" bgcolor="CCCCFF">
				<td colspan="12"><b>Primary Target: <cfif qry_selectContactTemplateList.primaryTargetID is 0>All<cfelseif Variables.primaryTargetRow is 0>?<cfelse>#qry_selectPrimaryTargetList.primaryTargetName[Variables.primaryTargetRow]#</cfif></b></td>
				<cfif ListFind(Variables.permissionActionList, "insertContactTemplate")>
					<td colspan="7" class="SmallText" align="right">[<a href="index.cfm?method=contactTemplate.insertContactTemplate&primaryTargetID=#qry_selectContactTemplateList.primaryTargetID#" class="plainlink">Add New Template To This Target</a>]</td>
				</cfif>
			</tr>
		</cfif>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectContactTemplateList.contactTemplateOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectContactTemplateList.contactTemplateName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContactTemplateList.contactTemplateSubject is "">&nbsp;<cfelse>#HTMLEditFormat(qry_selectContactTemplateList.contactTemplateSubject)#</cfif></td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContactTemplateList.contactTemplateHtml is 1>Yes<cfelse>&nbsp;</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectContactTemplateList.contactTemplateFromName is not "" and qry_selectContactTemplateList.contactTemplateReplyTo is "">
				#qry_selectContactTemplateList.contactTemplateFromName#
			<cfelseif qry_selectContactTemplateList.contactTemplateFromName is not "">
				<a href="mailto:#qry_selectContactTemplateList.contactTemplateReplyTo#" class="plainlink">#qry_selectContactTemplateList.contactTemplateFromName#</a>
			<cfelseif qry_selectContactTemplateList.contactTemplateReplyTo is "">
				<a href="mailto:#qry_selectContactTemplateList.contactTemplateReplyTo#" class="plainlink">#qry_selectContactTemplateList.contactTemplateReplyTo#</a>
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContactTemplateList.contactTemplateStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectContactTemplateList.contactTemplateDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectContactTemplateList.contactTemplateDateUpdated, "mm-dd-yy")#</td>
		<cfif CurrentRow is RecordCount>
			<cfset Variables.nextPrimaryTargetID = -1>
		<cfelse>
			<cfset Variables.nextPrimaryTargetID = qry_selectContactTemplateList.primaryTargetID[CurrentRow + 1]>
		</cfif>

		<cfif ListFind(Variables.permissionActionList, "moveContactTemplateDown") and ListFind(Variables.permissionActionList, "moveContactTemplateUp")>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectContactTemplateList.primaryTargetID is not Variables.nextPrimaryTargetID>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=contactTemplate.moveContactTemplateDown&contactTemplateID=#qry_selectContactTemplateList.contactTemplateID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif qry_selectContactTemplateList.primaryTargetID is not Variables.lastPrimaryTargetID>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=contactTemplate.moveContactTemplateUp&contactTemplateID=#qry_selectContactTemplateList.contactTemplateID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateContactTemplate")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=contactTemplate.updateContactTemplate&contactTemplateID=#qry_selectContactTemplateList.contactTemplateID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
		<cfset Variables.lastPrimaryTargetID = qry_selectContactTemplateList.primaryTargetID>
	</cfloop>
	</table>
</cfif>
</cfoutput>
