<cfif qry_selectTemplateList.RecordCount is 0>
	<cfoutput><p class="ErrorMessage">There are currently no templates.</p></cfoutput>
<cfelse>
	<cfoutput>
	<p class="MainText">For invoices, the default template is the template used for sending invoices to subscribers.</p>
	#fn_DisplayCurrentRecordNumbers("", "", "<br>", Variables.templateColumnCount, 0, 0, 0, Variables.templateColumnList, "", True)#
	</cfoutput>

	<cfset Variables.defaultTemplateTypeList = "">
	<cfoutput Query="qry_selectTemplateList" Group="templateType">
		<cfset Variables.typePosition = ListFind(Variables.var_templateTypeList_value, qry_selectTemplateList.templateType)>
		<tr>
			<td class="TableText" bgcolor="CCCCFF" colspan="#Variables.templateColumnCount#">&nbsp; 
			<cfif Variables.typePosition is not 0>
				<b>#ListGetAt(Variables.var_templateTypeList_label, Variables.typePosition)#</b>
			<cfelseif qry_selectTemplateList.templateType is "">
				(<i>no template type</i>)
			<cfelse>
				<b>#qry_selectTemplateList.templateType#</b>
			</cfif>
			</td>
		</tr>
		<cfoutput>
		<tr class="TableText" valign="top"<cfif (CurrentRow mod 2) is 0> bgcolor="f4f4ff"</cfif> onMouseOver="bgColor='FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='f4f4ff'"<cfelse>onMouseOut="bgColor='FFFFFF'"</cfif>>
		<td>
			#qry_selectTemplateList.templateName#
			<cfif Variables.displayTemplateFilename is True><div class="SmallText">#qry_selectTemplateList.templateFilename#</div></cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectTemplateList.templateStatus is 1>Active<cfelse>Disabled</cfif></td>
		<td>&nbsp;</td>
		<td>
			<cfif qry_selectTemplateList.templateDefault is 1>
				<cfif Not ListFind(Variables.defaultTemplateTypeList, qry_selectTemplateList.templateType)>
					Default
					<cfset Variables.defaultTemplateTypeList = ListAppend(Variables.defaultTemplateTypeList, qry_selectTemplateList.templateType)>
				<cfelse>
					<div class="SmallText"><a href="index.cfm?method=template.updateTemplateDefault&templateID=#qry_selectTemplateList.templateID#" class="plainlink">Make<br>Default</a></div>
				</cfif>
			<cfelseif ListFind(Variables.permissionActionList, "updateTemplateDefault") and (Session.companyID is qry_selectTemplateList.companyID or Session.companyID is Application.billingSuperuserCompanyID)>
				<div class="SmallText"><a href="index.cfm?method=template.updateTemplateDefault&templateID=#qry_selectTemplateList.templateID#" class="plainlink">Make<br>Default</a></div>
			<cfelse>
				-
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td><cfif qry_selectTemplateList.templateDescription is "">&nbsp;<cfelse>#qry_selectTemplateList.templateDescription#</cfif></td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectTemplateList.templateDateCreated, "mm-dd-yy")#</td>
		<td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectTemplateList.templateDateUpdated, "mm-dd-yy")#</td>
		<cfif Variables.displayNumberUsed is True>
			<td>&nbsp;</td>
			<td>#qry_selectTemplateList.templateUseCount#</td>
		</cfif>
		<cfif ListFind(Variables.permissionActionList, "updateTemplate") or ListFind(Variables.permissionActionList, "viewTemplateSample")
				or ListFind(Variables.permissionActionList, "copyTemplate") or ListFind(Variables.permissionActionList, "customizeTemplate")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif ListFind(Variables.permissionActionList, "updateTemplate")
						and (Session.companyID is qry_selectTemplateList.companyID
							or (qry_selectTemplateList.companyID is 0 and Session.companyID is Application.billingSuperuserCompanyID))>
					<a href="index.cfm?method=template.updateTemplate&templateID=#qry_selectTemplateList.templateID#" class="plainlink">Update</a><br>
				</cfif>
				<cfif ListFind(Variables.permissionActionList, "viewTemplateSample") and qry_selectTemplateList.templateType is "Invoice">
					<a href="index.cfm?method=template.viewTemplateSample&templateID=#qry_selectTemplateList.templateID#" class="plainlink">Sample</a><br>
				</cfif>
				<cfif ListFind(Variables.permissionActionList, "copyTemplate")>
					<a href="index.cfm?method=template.copyTemplate&templateID=#qry_selectTemplateList.templateID#" class="plainlink">Copy</a><br>
				</cfif>
				<cfif ListFind(Variables.permissionActionList, "customizeTemplate") and (Session.companyID is qry_selectTemplateList.companyID or Session.companyID is Application.billingSuperuserCompanyID)>
					<a href="index.cfm?method=template.customizeTemplate&templateID=#qry_selectTemplateList.templateID#" class="plainlink">Customize</a><br>
				</cfif>
			</td>
		</cfif>
		</tr>
		</cfoutput>
	</cfoutput>

	<cfoutput>
	</table>
	</cfoutput>
</cfif>
