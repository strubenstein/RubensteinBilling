<cfoutput>
<script language="Javascript" src="#Application.billingUrlroot#/js/popcalendar.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_layers.js"></script>
<script language="JavaScript" src="#Application.billingUrlroot#/js/lw_menu.js"></script>

<p>
<!--- Basic Search Form --->
<table border="0" cellspacing="0" cellpadding="2" class="TableText" width="800"><tr bgcolor="ccccff" valign="middle" id="basicSearch"<cfif Session.showAdvancedSearch is True> style="display:none;"</cfif>>
<form method="post" name="contactListBasic" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="False">
<input type="hidden" name="searchTextType" value="contactMessage,contactSubject,contactFromName,contactID_custom,contactReplyTo,contactTo,contactCC,contactBCC">
<td>
	Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; &nbsp; &nbsp; 
	Search Text: <input type="text" name="searchText" value="#HTMLEditFormat(Form.searchText)#" size="25" class="TableText"> <input type="submit" name="submitContactList" value="Submit">
</td>
<td align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Show Advanced Search</a> ]</td>
</tr>
</form>
</table>

<!--- Advanced Search Form --->
<table border="0" cellspacing="0" cellpadding="3" class="TableText" width="800" id="advancedSearch"<cfif Session.showAdvancedSearch is False> style="display:none;"</cfif>>
<form method="post" name="#Variables.formAction#" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">
<input type="hidden" name="queryOrderBy" value="#HTMLEditFormat(Form.queryOrderBy)#">
<input type="hidden" name="showAdvancedSearch" value="True">
<tr bgcolor="ccccff" class="MainText">
	<td colspan="2"><b>Advanced Search</b></td>
	<td colspan="2" align="right" class="TableText">[ <a href="javascript:void(0);" class="plainlink" onClick="toggle('advancedSearch');toggle('basicSearch');">Return to Basic Search</a> ]</td>
</tr>

<tr bgcolor="E7D8F3" valign="top">
	<td nowrap>
		Search Text: <input type="text" name="searchText" size="25" value="#HTMLEditFormat(Form.searchText)#"><br>
		&nbsp; &nbsp; &nbsp; 
		<label><input type="checkbox" name="searchTextType" value="contactMessage"<cfif ListFind(Form.searchTextType, "contactMessage")> checked</cfif>>Message</label> &nbsp; 
		<label><input type="checkbox" name="searchTextType" value="contactSubject"<cfif ListFind(Form.searchTextType, "contactSubject")> checked</cfif>>Subject</label> &nbsp; 
		<label><input type="checkbox" name="searchTextType" value="contactFromName"<cfif ListFind(Form.searchTextType, "contactFromName")> checked</cfif>>From</label> &nbsp; 
		<label><input type="checkbox" name="searchTextType" value="contactID_custom"<cfif ListFind(Form.searchTextType, "contactID_custom")> checked</cfif>>ID</label>
		</div>
		<br>
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr>
			<td>From:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "contactDateFrom_date", Form.contactDateFrom_date, "contactDateFrom_hh", Form.contactDateFrom_hh, False, 0, "contactDateFrom_tt", Form.contactDateFrom_tt, True)#</td>
		</tr>
		<tr>
			<td align="right">To:&nbsp;</td>
			<td>#fn_FormSelectDateTime(Variables.formName, "contactDateTo_date", Form.contactDateTo_date, "contactDateTo_hh", Form.contactDateTo_hh, False, 0, "contactDateTo_tt", Form.contactDateTo_tt, True)#</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<label><input type="checkbox" name="contactDateType" value="contactDateCreated"<cfif ListFind(Form.contactDateType, "contactDateCreated")> checked</cfif>>Started</label> &nbsp; 
				<label><input type="checkbox" name="contactDateType" value="contactDateUpdated"<cfif ListFind(Form.contactDateType, "contactDateUpdated")> checked</cfif>>Last Updated</label> &nbsp; 
				<label><input type="checkbox" name="contactDateType" value="contactDateSent"<cfif ListFind(Form.contactDateType, "contactDateSent")> checked</cfif>>Sent</label><br>
			</td>
		</tr>
		</table>
	</td>
	<td align="center">
		Search Email: <input type="text" name="searchEmail" size="20" value="#HTMLEditFormat(Form.searchEmail)#"><br>
		&nbsp; &nbsp; &nbsp; &nbsp;
		<label><input type="checkbox" name="searchEmailType" value="contactReplyTo"<cfif ListFind(Form.searchEmailType, "contactReplyTo")> checked</cfif>>Reply-To</label> &nbsp; 
		<label><input type="checkbox" name="searchEmailType" value="contactTo"<cfif ListFind(Form.searchEmailType, "contactTo")> checked</cfif>>To</label> &nbsp; 
		<label><input type="checkbox" name="searchEmailType" value="contactCC"<cfif ListFind(Form.searchEmailType, "contactCC")> checked</cfif>>CC</label> &nbsp; 
		<label><input type="checkbox" name="searchEmailType" value="contactBCC"<cfif ListFind(Form.searchEmailType, "contactBCC")> checked</cfif>>BCC</label><br>
		<!--- 
		<cfif qry_selectStatusList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="statusID" size="1" class="SearchSelect">
			<option value="">-- SELECT CUSTOM STATUS --</option>
			<option value="0"<cfif Form.statusID is 0> selected</cfif>>-- NO SPECIFIED STATUS --</option>
			<cfloop Query="qry_selectStatusList">
				<option value="#qry_selectStatusList.statusID#"<cfif Form.statusID is qry_selectStatusList.statusID> selected</cfif>>#qry_selectStatusList.statusOrder#. #HTMLEditFormat(Left(qry_selectStatusList.statusTitle, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		--->
		<cfif qry_selectContactTopicList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="contactTopicID" size="1" class="SearchSelect">
			<option value="">-- SELECT TOPIC --</option>
			<option value="0"<cfif Form.contactTopicID is 0> selected</cfif>>-- NO SPECIFIED TOPIC --</option>
			<cfloop Query="qry_selectContactTopicList">
				<option value="#qry_selectContactTopicList.contactTopicID#"<cfif Form.contactTopicID is qry_selectContactTopicList.contactTopicID> selected</cfif>>#HTMLEditFormat(Left(qry_selectContactTopicList.contactTopicName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif qry_selectContactTemplateList.RecordCount is not 0>
			<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
			<select name="contactTemplateID" size="1" class="SearchSelect">
			<option value="">-- SELECT TEMPLATE --</option>
			<option value="0"<cfif Form.contactTemplateID is 0> selected</cfif>>-- NO SPECIFIED TEMPLATE --</option>
			<cfloop Query="qry_selectContactTemplateList">
				<option value="#qry_selectContactTemplateList.contactTemplateID#"<cfif Form.contactTemplateID is qry_selectContactTemplateList.contactTemplateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectContactTemplateList.contactTemplateName, 30))#</option>
			</cfloop>
			</select><br>
		</cfif>
		<cfif Variables.userID is 0 and Variables.companyID is 0>
			<cfif qry_selectGroupList.RecordCount is not 0>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
				<select name="groupID" size="1" class="SearchSelect">
				<option value="">-- SELECT GROUP --</option>
				<option value="0"<cfif Form.groupID is 0> selected</cfif>>-- NO SPECIFIED GROUP --</option>
				<cfloop Query="qry_selectGroupList">
					<option value="#qry_selectGroupList.groupID#"<cfif Form.groupID is qry_selectGroupList.groupID> selected</cfif>>#HTMLEditFormat(Left(qry_selectGroupList.groupName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
			<cfif qry_selectAffiliateList.RecordCount is not 0>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
				<select name="affiliateID" size="1" class="SearchSelect">
				<option value="">-- SELECT AFFILIATE --</option>
				<option value="0"<cfif Form.affiliateID is 0> selected</cfif>>-- NO SPECIFIED AFFILIATE --</option>
				<cfloop Query="qry_selectAffiliateList">
					<option value="#qry_selectAffiliateList.affiliateID#"<cfif Form.affiliateID is qry_selectAffiliateList.affiliateID> selected</cfif>>#HTMLEditFormat(Left(qry_selectAffiliateList.affiliateName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
			<cfif qry_selectCobrandList.RecordCount is not 0>
				<img src="#Application.billingUrlRoot#/images/blank.gif" width="5" height="3" alt="" border="0"><br>
				<select name="cobrandID" size="1" class="SearchSelect">
				<option value="">-- SELECT COBRAND --</option>
				<option value="0"<cfif Form.cobrandID is 0> selected</cfif>>-- NO SPECIFIED COBRAND --</option>
				<cfloop Query="qry_selectCobrandList">
					<option value="#qry_selectCobrandList.cobrandID#"<cfif Form.cobrandID is qry_selectCobrandList.cobrandID> selected</cfif>>#HTMLEditFormat(Left(qry_selectCobrandList.cobrandName, 30))#</option>
				</cfloop>
				</select><br>
			</cfif>
		</cfif>
	</td>

	<cfset Variables.booleanList_value = "contactStatus,contactReplied,contactByCustomer,contactHasCustomID,contactHtml,contactIsSent,contactIsReply,contactToMultiple,contactHasCC,contactHasBCC">
	<cfset Variables.booleanList_label = "Open Issue,Responded To,From Customer,Has Custom ID,HTML Format,Is Sent,Is a Reply,To Multiple,CC'd,BCC'd">
	<!--- value=,contactEmail,contactFax	label=,Sent as Email,Sent as Fax --->
	<td align="center" valign="top">
		<table border="0" cellspacing="0" cellpadding="0" class="TableText">
		<tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr>
		<cfloop Index="count" From="1" To="#ListLen(Variables.booleanList_value)#">
			<cfset thisBoolean = ListGetAt(Variables.booleanList_value, count)>
			<tr onMouseOver="bgColor='FFFFCC'" onMouseOut="bgColor='E7D8F3'"><td nowrap>&nbsp; #ListGetAt(Variables.booleanList_label, count)#</td>
			<td><input type="checkbox" name="#thisBoolean#" value="1"<cfif Form[thisBoolean] is 1> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 0)"><input type="checkbox" name="#thisBoolean#" value="0"<cfif Form[thisBoolean] is 0> checked</cfif> onClick="javascript:checkUncheck('#thisBoolean#', 1)"></td></tr>
			<cfif ListFind("5", count)></table></td><td align="center" valign="top"><table border="0" cellspacing="0" cellpadding="0" class="TableText"><tr class="TableText"><th>&nbsp;</th><th>Yes&nbsp;No</th></tr></cfif>
		</cfloop>
		</table>
	</td>
	</td>
</tr>

<tr>
	<td colspan="4" bgcolor="ccccff" align="center">
		Display Per Page: <input type="text" name="queryDisplayPerPage" value="#HTMLEditFormat(Form.queryDisplayPerPage)#" size="2" class="TableText"> &nbsp; &nbsp; 
		<input type="submit" name="submitContactList" value="Submit">
		 &nbsp; &nbsp; 
		<input type="reset" value="Reset">
	</td>
</tr>
</form>
</table>
</p>
</cfoutput>

