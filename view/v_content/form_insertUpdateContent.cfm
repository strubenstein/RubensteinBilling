<cfoutput>
<form method="post" name="insertContent" action="#Variables.formAction#">
<input type="hidden" name="isFormSubmitted" value="True">

<table border="0" cellspacing="2" cellpadding="2" class="MainText">
<tr>
	<td>Category: </td>
	<td>
		<cfif Variables.doAction is "insertContent" and URL.contentCategoryID is not 0>
			#qry_selectContentCategory.contentCategoryName#
		<cfelse>
			<select name="contentCategoryID" size="1">
			<cfloop Query="qry_selectContentCategoryList">
				<option value="#qry_selectContentCategoryList.contentCategoryID#"<cfif Form.contentCategoryID is qry_selectContentCategoryList.contentCategoryID> selected</cfif>>###qry_selectContentCategoryList.contentCategoryOrder#. #HTMLEditFormat(qry_selectContentCategoryList.contentCategoryName)#</option>
			</cfloop>
			</select>
		</cfif>
	</td>
</tr>

<cfif Variables.doAction is "insertContent">
	<tr>
		<td>Order: </td>
		<td>
			<cfif URL.contentCategoryID is 0>
				Last (must pre-select category to choose order)
			<cfelse>
				<select name="contentOrder" size="1">
				<cfloop Query="qry_selectContentList">
					<option value="#qry_selectContentList.contentOrder#"<cfif Form.contentOrder is qry_selectContentList.contentOrder> selected</cfif>>Before ###qry_selectContentList.contentOrder#. #HTMLEditFormat(qry_selectContentList.contentName)#</option>
				</cfloop>
				<option value="0"<cfif Form.contentOrder is 0> selected</cfif>>-- Last Content Listing --</option>
				</select>
			</cfif>
		</td>
	</tr>
</cfif>

<tr>
	<td>Status: </td>
	<td>
		<label style="color: green"><input type="radio" name="contentStatus" value="1"<cfif Form.contentStatus is 1> checked</cfif>> Active</label> &nbsp; &nbsp;
		<label style="color: red"><input type="radio" name="contentStatus" value="0"<cfif Form.contentStatus is not 1> checked</cfif>> Inactive</label>
	</td>
</tr>

<tr>
	<td>Content Listing Name: </td>
	<td><input type="text" name="contentName" size="50" value="#HTMLEditFormat(Form.contentName)#" maxlength="#maxlength_Content.contentName#"> (must be unique for category)</td>
</tr>

<tr>
	<td>Content Code: </td>
	<td><input type="text" name="contentCode" size="25" value="#HTMLEditFormat(Form.contentCode)#" maxlength="#maxlength_Content.contentCode#"> (must be unique; used for querying)</td>
</tr>

<tr>
	<td>Content Type: </td>
	<td>
		<cfset Variables.displayContentTypeOther = True>
		<select name="contentType" size="1">
		<option value=""<cfif Form.contentType is ""> selected</cfif>>-- NO TYPE --</option>
		<cfif qry_selectContentTypeList.RecordCount is not 0>
			<option value="">-- DEFAULT TYPES --</option>
		</cfif>
		<cfloop Index="type" List="#Variables.contentType_list#">
			<option value="#HTMLEditFormat(type)#"<cfif Form.contentType is type> selected<cfset Variables.displayContentTypeOther = False></cfif>>#HTMLEditFormat(type)#</option>
		</cfloop>
		<cfif qry_selectContentTypeList.RecordCount is not 0>
			<option value="">-- OTHER TYPES --</option>
			<cfloop Query="qry_selectContentTypeList">
				<cfif Not ListFindNoCase(Variables.contentType_list, qry_selectContentTypeList.contentType)>
					<option value="#HTMLEditFormat(qry_selectContentTypeList.contentType)#"<cfif Form.contentType is qry_selectContentTypeList.contentType> selected<cfset Variables.displayContentTypeOther = False></cfif>>#HTMLEditFormat(qry_selectContentTypeList.contentType)#</option>
				</cfif>
			</cfloop>
		</cfif>
		</select> 
		Other: <input type="text" name="contentTypeOther" size="15" <cfif Variables.displayContentTypeOther is True> value="#HTMLEditFormat(Form.contentTypeOther)#"</cfif> maxlength="#maxlength_Content.contentType#"> (optional)</td>
</tr>

<tr>
	<td>Optional Description: </td>
	<td><input type="text" name="contentDescription" size="50" value="#HTMLEditFormat(Form.contentDescription)#" maxlength="#maxlength_Content.contentDescription#"></td>
</tr>

<tr>
	<td>Required: </td>
	<td><label><input type="checkbox" name="contentRequired" value="1"<cfif Form.contentRequired is 1> checked</cfif>> Content is required (i.e., cannot be blank).</label></td>
</tr>

<tr>
	<td>HTML: </td>
	<td><label><input type="checkbox" name="contentHtmlOk" value="1"<cfif Form.contentHtmlOk is 1> checked</cfif>> Content may use html formatting instead of simple text formatting.</label></td>
</tr>

<tr>
	<td>Maximum Length: </td>
	<td><input type="text" name="contentMaxlength" value="#HTMLEditFormat(Form.contentMaxlength)#" size="5" maxlength="5"> (1 - #maxlength_ContentCompany.contentCompanyText#)</td>
</tr>

<tr>
	<td>Filename: </td>
	<td>
		<cfif Variables.doAction is "insertContent">
			<input type="text" name="contentFilename" value="#HTMLEditFormat(Form.contentFilename)#" size="25" maxlength="#maxlength_Content.contentFilename#">
		<cfelseif qry_selectContent.contentFilename is not "">
			#qry_selectContent.contentFilename# (content is automatically written to this file)
		<cfelse>
			(no filename)
		</cfif>
	</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" name="submitContent" value="#HTMLEditFormat(Variables.formSubmitValue)#"></td>
</tr>
</table>
</form>
</cfoutput>