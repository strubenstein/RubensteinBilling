<cfoutput>
<cfif qry_selectTaskList.RecordCount is 0>
	<p class="ErrorMessage">No tasks meet your search criteria.</p>
<cfelse>
	<p>
	#fn_DisplayCurrentRecordNumbers(methodStruct.queryViewAction, Form.queryOrderBy, "<br>", methodStruct.columnCount, methodStruct.firstRecord, methodStruct.lastRecord, methodStruct.totalRecords, methodStruct.columnHeaderList, methodStruct.columnOrderByList, True, 930)#
	<cfloop Query="qry_selectTaskList">
		<cfif (CurrentRow mod 2) is 0><cfset methodStruct.bgcolor = "f4f4ff"><cfelse><cfset methodStruct.bgcolor = "ffffff"></cfif>
		<tr class="TableText" valign="top" style="border: 1px solid black"<cfif (CurrentRow mod 2) is 0> bgcolor="##f4f4ff"</cfif> onMouseOver="bgColor='##FFFFCC'" <cfif (CurrentRow mod 2) is 0>onMouseOut="bgColor='##f4f4ff'"<cfelse>onMouseOut="bgColor='##FFFFFF'"</cfif>>
		<td><cfif listTasksViewStruct.isUpdateTaskForm is True><input type="checkbox" name="updateTaskID" value="#qry_selectTaskList.taskID#" onClick="checkTask(#qry_selectTaskList.taskID#)"></cfif><a href="#methodStruct.thisTaskAction#&taskID=#qry_selectTaskList.taskID#" class="plainlink" style="color: black"><cfif qry_selectTaskList.taskMessage is "">(no description)<cfelse>#qry_selectTaskList.taskMessage#</cfif></a></td><td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectTaskList.taskDateScheduled)>&nbsp; -<cfelse>#DateFormat(qry_selectTaskList.taskDateScheduled, "mm/dd/yyyy")#<div class="SmallText">#TimeFormat(qry_selectTaskList.taskDateScheduled, "hh:mm tt")#</div></cfif></td><td>&nbsp;</td>
		<cfif listTasksViewStruct.isDisplayAgent is True><td>#qry_selectTaskList.agentLastName#,<br>#qry_selectTaskList.agentFirstName#</td><td>&nbsp;</td></cfif>
		<cfif listTasksViewStruct.isDisplayTarget is True>
			<td>
				<cfif qry_selectTaskList.companyID_target is not 0 and qry_selectTaskList.targetCompanyName is not "">#qry_selectTaskList.targetCompanyName#<cfif ListFind(methodStruct.permissionActionList, "viewCompany")> <font class="SmallText">(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectTaskList.companyID_target#" class="plainlink">go</a>)</font></cfif><br></cfif>
				<cfif qry_selectTaskList.userID_target is not 0>#qry_selectTaskList.targetLastName#, #qry_selectTaskList.targetFirstName#<cfif ListFind(methodStruct.permissionActionList, "viewUser")> <font class="SmallText">(<a href="index.cfm?method=user.viewUser&userID=#qry_selectTaskList.userID_target#" class="plainlink">go</a>)</font></cfif></cfif>
			</td><td>&nbsp;</td>
		</cfif>
		<cfif listTasksViewStruct.isDisplayAuthor is True><td>#qry_selectTaskList.authorLastName#,<br>#qry_selectTaskList.authorFirstName#</td><td>&nbsp;</td></cfif>
		<td nowrap>
			<cfif qry_selectTaskList.taskCompleted is 0>&nbsp; -<cfelse>Yes</cfif>
			<cfif qry_selectTaskList.taskStatus is 0><div class="SmallText" style="color: red">Ignored</div></cfif>
		</td><td>&nbsp;</td>
		<td nowrap>#DateFormat(qry_selectTaskList.taskDateCreated, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectTaskList.taskDateCreated, "hh:mm tt")#</div></td>
		<cfif listTasksViewStruct.isDisplayInvoice is True><td>&nbsp;</td><td class="SmallText"><a href="index.cfm?method=invoice.viewInvoice&invoiceID=#qry_selectTaskList.targetID#" class="plainlink">View Invoice</a></div></td></cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(methodStruct.columnCount, methodStruct.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, methodStruct.firstRecord, methodStruct.lastRecord, methodStruct.totalRecords, methodStruct.totalPages, False, "")#
	</p>
</cfif>
</cfoutput>
