<cfoutput>
<cfif qry_selectContactTopicList.RecordCount is 0>
	<p class="ErrorMessage">There are currently no contact management topics.</p>
<cfelse>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.contactTopicColumnCount, 0, 0, 0, Variables.contactTopicColumnList, "", True)#
	<cfloop Query="qry_selectContactTopicList">
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td align="right">#qry_selectContactTopicList.contactTopicOrder#</td>
		<td>&nbsp;</td>
		<td>#qry_selectContactTopicList.contactTopicName#</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContactTopicList.contactTopicTitle is qry_selectContactTopicList.contactTopicName>&quot;<cfelse>#qry_selectContactTopicList.contactTopicTitle#</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectContactTopicList.contactTopicEmail is "">
				&nbsp;
			<cfelse>
				#Replace(qry_selectContactTopicList.contactTopicEmail, ",", "<br>", "ALL")#
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectContactTopicList.contactTopicStatus is 1>Active<cfelse>Inactive</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectContactTopicList.contactTopicDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectContactTopicList.contactTopicDateUpdated, "mm-dd-yy")#</td>
		<cfif ListFind(Variables.permissionActionList, "moveContactTopicDown") and ListFind(Variables.permissionActionList, "moveContactTopicUp")>
			<td>&nbsp;</td>
			<td>
				<cfif CurrentRow is RecordCount>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=contactTopic.moveContactTopicDown&contactTopicID=#qry_selectContactTopicList.contactTopicID#"><img src="#Application.billingUrlRoot#/images/arrow_down.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
				<cfif CurrentRow is 1>
					<img src="#Application.billingUrlRoot#/images/blank.gif" width="14" height="13" alt="" border="0">
				<cfelse>
					<a href="index.cfm?method=contactTopic.moveContactTopicUp&contactTopicID=#qry_selectContactTopicList.contactTopicID#"><img src="#Application.billingUrlRoot#/images/arrow_up.gif" width="14" height="13" alt="" border="0"></a>
				</cfif>
			</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateContactTopic")>
			<td>&nbsp;</td>
			<td class="SmallText"><a href="index.cfm?method=contactTopic.updateContactTopic&contactTopicID=#qry_selectContactTopicList.contactTopicID#" class="plainlink">Update</a></td>
		</cfif>
		</tr>
	</cfloop>
	</table>
</cfif>
</cfoutput>
