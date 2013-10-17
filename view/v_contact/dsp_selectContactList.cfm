<cfoutput>
<cfif qry_selectContactList.RecordCount is 0>
	<p class="ErrorMessage">No messages meet your search criteria.</p>
<cfelse>
	<script language="JavaScript">
	function fn_toggleBgcolorOver(rowNum, rowShowA, rowShowB)
	{
		document.getElementById('row' + rowNum).style.backgroundColor = 'FFFFCC';
		if (rowShowA == 'True')
			document.getElementById('row' + rowNum + 'a').style.backgroundColor = 'FFFFCC';
		if (rowShowB == 'True')
			document.getElementById('row' + rowNum + 'b').style.backgroundColor = 'FFFFCC';
	}

	function fn_toggleBgcolorOut(rowNum, rowShowA, rowShowB, rowColor)
	{
		document.getElementById('row' + rowNum).style.backgroundColor = rowColor;
		if (rowShowA == 'True')
			document.getElementById('row' + rowNum + 'a').style.backgroundColor = rowColor;
		if (rowShowB == 'True')
			document.getElementById('row' + rowNum + 'b').style.backgroundColor = rowColor;
	}
	</script>

	#fn_DisplayCurrentRecordNumbers(Variables.queryViewAction, Form.queryOrderBy, "<br>", Variables.columnCount, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.columnHeaderList, Variables.columnOrderByList, True)#
	<cfloop Query="qry_selectContactList">
		<cfif (CurrentRow mod 2) is 0><cfset Variables.bgcolor = "f4f4ff"><cfelse><cfset Variables.bgcolor = "ffffff"></cfif>
		<cfset Variables.showContactTopic = False>
		<cfif Form.contactTopicID is "">
			<cfset Variables.topicRow = ListFind(ValueList(qry_selectContactTopicList.contactTopicID), qry_selectContactList.contactTopicID)>
			<cfif Variables.topicRow is not 0>
				<cfset Variables.showContactTopic = True>
			</cfif>
		</cfif>
		<cfif qry_selectContactList.productName is not ""><cfset Variables.showProduct = True><cfelse><cfset Variables.showProduct = False></cfif>

		<cfif Variables.showContactTopic is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#a" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'True','#Variables.showProduct#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'True','#Variables.showProduct#','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#"><b>Topic:</b> #qry_selectContactTopicList.contactTopicName[Variables.topicRow]#</td></tr>
		</cfif>
		<cfif Variables.showProduct is True>
			<tr class="SmallText" valign="top" id="row#CurrentRow#b" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showContactTopic#','True');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showContactTopic#','True','#Variables.bgcolor#');">
			<td colspan="#Variables.columnCount#"><b>Product:</b> #qry_selectContactList.productName# <cfif ListFind(Variables.permissionActionList, "viewProduct")><font class="SmallText">(<a href="index.cfm?method=product.viewProduct&productID=#qry_selectContactList.targetID#" class="plainlink">view</a>)</font></cfif></td></tr>
		</cfif>

		<tr class="TableText" valign="top" id="row#CurrentRow#" bgcolor="#Variables.bgcolor#" onMouseOver="fn_toggleBgcolorOver(#CurrentRow#,'#Variables.showContactTopic#','#Variables.showProduct#');" onMouseOut="fn_toggleBgcolorOut(#CurrentRow#,'#Variables.showContactTopic#','#Variables.showProduct#','#Variables.bgcolor#');">
		<cfif Variables.displayCustomID is True>
			<td><cfif qry_selectContactList.contactID_custom is "">&nbsp;<cfelse>#qry_selectContactList.contactID_custom#</cfif></td>
			<td>&nbsp;</td>
		</cfif>

		<!--- 
		<cfif qry_selectContactList.contactByCustomer is 0>
			<td><cfif qry_selectContactList.authorCompanyName is "" or qry_selectContactList.companyID_author is Session.companyID>&nbsp;<cfelse>#qry_selectContactList.authorCompanyName#</cfif></td>
			<td>&nbsp;</td>
			<td><cfif qry_selectContactList.userID_author is 0>&nbsp;<cfelse>#qry_selectContactList.authorLastName#,<br>#qry_selectContactList.authorFirstName#</cfif></td>
			<td>&nbsp;</td>
		<cfelse>
			<td>
				<cfif qry_selectContactList.targetCompanyName is "">
					<cfif Not ListFind(Variables.permissionActionList, "viewCompany")>(no name)<cfelse>(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">no name</a>)</cfif>
				<cfelseif qry_selectContactList.companyID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					<cfif Not ListFind(Variables.permissionActionList, "viewCompany")>#qry_selectContactList.targetCompanyName#<cfelse><a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">#qry_selectContactList.targetCompanyName#</a></cfif>
				<cfelse>#qry_selectContactList.targetCompanyName#
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectContactList.userID_target is 0>&nbsp;
				<cfelseif qry_selectContactList.userID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					<cfif Not ListFind(Variables.permissionActionList, "viewUser")>#qry_selectContactList.targetLastName#,<br>#qry_selectContactList.targetFirstName#<cfelse><a href="index.cfm?method=user.viewUser&userID=#qry_selectContactList.userID_target#" class="plainlink">#qry_selectContactList.targetLastName#,<br>#qry_selectContactList.targetFirstName#</a></cfif>
				<cfelse>#qry_selectContactList.targetLastName#,<br>#qry_selectContactList.targetFirstName#
				</cfif>
			</td>
			<td>&nbsp;</td>
		</cfif>
		--->
		<cfif qry_selectContactList.contactByCustomer is 0>
			<td>
				<cfif qry_selectContactList.authorCompanyName is not "" and qry_selectContactList.companyID_author is not Session.companyID><font class="SmallText">#qry_selectContactList.authorCompanyName#</font><br></cfif>
				<cfif qry_selectContactList.userID_author is not 0>#qry_selectContactList.authorFirstName# #qry_selectContactList.authorLastName#</cfif>
			</td>
			<td>&nbsp;</td>
		<cfelse>
			<td><font class="SmallText">
				<cfif qry_selectContactList.targetCompanyName is "">
					(no company name)<cfif ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">go</a>)</cfif><br>
				<cfelseif qry_selectContactList.companyID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					#qry_selectContactList.targetCompanyName#<cfif ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">go</a>)</cfif><br>
				<cfelse>
					#qry_selectContactList.targetCompanyName#<br>
				</cfif>
				</font>
				<cfif qry_selectContactList.userID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					#qry_selectContactList.targetFirstName# #qry_selectContactList.targetLastName#<cfif ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectContactList.userID_target#" class="plainlink">go</a>)</cfif>
				<cfelseif qry_selectContactList.userID_target is 0>
					#qry_selectContactList.targetFirstName# #qry_selectContactList.targetLastName#
				</cfif>
			</td>
			<td>&nbsp;</td>
		</cfif>

		<td><cfif qry_selectContactList.contactSubject is "">(no subject)<cfelse>#qry_selectContactList.contactSubject#</cfif></td>
		<td>&nbsp;</td>

		<!--- 
		<cfif qry_selectContactList.contactByCustomer is 0>
			<td>
				<cfif qry_selectContactList.targetCompanyName is "">
					<cfif Not ListFind(Variables.permissionActionList, "viewCompany")>(no company name)<cfelse>(<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">no company name</a>)</cfif>
				<cfelseif qry_selectContactList.companyID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					<cfif Not ListFind(Variables.permissionActionList, "viewCompany")>#qry_selectContactList.targetCompanyName#<cfelse><a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">#qry_selectContactList.targetCompanyName#</a></cfif>
				<cfelse>#qry_selectContactList.targetCompanyName#
				</cfif>
			</td>
			<td>&nbsp;</td>
			<td>
				<cfif qry_selectContactList.userID_target is 0>&nbsp;
				<cfelseif qry_selectContactList.userID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					<cfif Not ListFind(Variables.permissionActionList, "viewUser")>#qry_selectContactList.targetLastName#,<br>#qry_selectContactList.targetFirstName#<cfelse><a href="index.cfm?method=user.viewUser&userID=#qry_selectContactList.userID_target#" class="plainlink">#qry_selectContactList.targetLastName#,<br>#qry_selectContactList.targetFirstName#</a></cfif>
				<cfelse>#qry_selectContactList.targetLastName#,<br>#qry_selectContactList.targetFirstName#
				</cfif>
			</td>
			<td>&nbsp;</td>
		<cfelse>
			<td><cfif qry_selectContactList.authorCompanyName is "" or qry_selectContactList.companyID_author is Session.companyID>&nbsp;<cfelse>#qry_selectContactList.authorCompanyName#</cfif></td>
			<td>&nbsp;</td>
			<td><cfif qry_selectContactList.userID_author is 0>&nbsp;<cfelse>#qry_selectContactList.authorLastName#,<br>#qry_selectContactList.authorFirstName#</cfif></td>
			<td>&nbsp;</td>
		</cfif>
		--->
		<cfif qry_selectContactList.contactByCustomer is 0>
			<td><font class="SmallText">
				<cfif qry_selectContactList.targetCompanyName is "">
					(no company name)<cfif ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">go</a>)</cfif><br>
				<cfelseif qry_selectContactList.companyID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					#qry_selectContactList.targetCompanyName#<cfif ListFind(Variables.permissionActionList, "viewCompany")> (<a href="index.cfm?method=company.viewCompany&companyID=#qry_selectContactList.companyID_target#" class="plainlink">go</a>)</cfif><br>
				<cfelse>
					#qry_selectContactList.targetCompanyName#<br>
				</cfif>
				</font>
				<cfif qry_selectContactList.userID_target is not 0 and Not ListFind("user,company", Variables.doAction)>
					#qry_selectContactList.targetFirstName# #qry_selectContactList.targetLastName#<cfif ListFind(Variables.permissionActionList, "viewUser")> (<a href="index.cfm?method=user.viewUser&userID=#qry_selectContactList.userID_target#" class="plainlink">go</a>)</cfif>
				<cfelseif qry_selectContactList.userID_target is 0>
					#qry_selectContactList.targetFirstName# #qry_selectContactList.targetLastName#
				</cfif>
			</td>
			<td>&nbsp;</td>
		<cfelse>
			<td>
				<cfif qry_selectContactList.authorCompanyName is not "" and qry_selectContactList.companyID_author is not Session.companyID><font class="SmallText">#qry_selectContactList.authorCompanyName#</font><br></cfif>
				<cfif qry_selectContactList.userID_author is not 0>#qry_selectContactList.authorFirstName# #qry_selectContactList.authorLastName#</cfif>
			</td>
			<td>&nbsp;</td>
		</cfif>

		<!--- 
		<td class="SmallText">#Replace(Replace(qry_selectContactList.contactTo, "@", "<br>&nbsp; &nbsp; @", "ALL"), ",", "<br>", "ALL")#</td>
		<td>&nbsp;</td>
		--->
		<td>
			<cfif qry_selectContactList.contactByCustomer is 0>
				-
			<cfelseif qry_selectContactList.contactStatus is 0>
				<font color="red">Open</font><cfif ListFind(Variables.permissionActionList, "updateContactStatus1")><div class="SmallText"><a href="index.cfm?method=#URL.control#.updateContactStatus1#Variables.urlParameters#&contactID=#qry_selectContactList.contactID#" class="plainlink">Mark as<br>Resolved</a></div></cfif>
			<cfelse>
				<font color="green">Resolved</font><cfif ListFind(Variables.permissionActionList, "updateContactStatus0")><div class="SmallText"><a href="index.cfm?method=#URL.control#.updateContactStatus0#Variables.urlParameters#&contactID=#qry_selectContactList.contactID#" class="plainlink">Re-Open</a></div></cfif>
			</cfif>
		</td>
		<td>&nbsp;</td>
		<td nowrap><cfif Not IsDate(qry_selectContactList.contactDateSent)>-<cfelse>#DateFormat(qry_selectContactList.contactDateSent, "mm-dd-yy")#<div class="SmallText">#TimeFormat(qry_selectContactList.contactDateSent, "hh:mm tt")#</div></cfif></td>
		<cfif ListFind(Variables.permissionActionList, "updateContact") or ListFind(Variables.permissionActionList, "viewContact")>
			<td>&nbsp;</td>
			<td class="SmallText">
				<cfif Not IsDate(qry_selectContactList.contactDateSent)>
					<cfif ListFind(Variables.permissionActionList, "updateContact")><a href="index.cfm?method=#URL.control#.updateContact#Variables.urlParameters#&contactID=#qry_selectContactList.contactID#" class="plainlink">Update/<br>Send</a></cfif>
				<cfelse>
					<cfif ListFind(Variables.permissionActionList, "viewContact")><a href="index.cfm?method=#URL.control#.viewContact#Variables.urlParameters#&contactID=#qry_selectContactList.contactID#" class="plainlink">View</a><br></cfif>
					<cfif qry_selectContactList.contactByCustomer is 1 and qry_selectContactList.contactReplied is 0 and ListFind(Variables.permissionActionList, "replyToContact")><a href="index.cfm?method=#URL.control#.replyToContact#Variables.urlParameters#&contactID=#qry_selectContactList.contactID#" class="plainlink">Reply</a></cfif>
				</cfif>
			</td>
		</cfif>
		</tr>
	</cfloop>
	#fn_DisplayOrderByPages(Variables.columnCount, Variables.queryViewAction_orderBy, Form.queryDisplayPerPage, Form.queryPage, Variables.firstRecord, Variables.lastRecord, Variables.totalRecords, Variables.totalPages, False, "")#
</cfif>
</cfoutput>

