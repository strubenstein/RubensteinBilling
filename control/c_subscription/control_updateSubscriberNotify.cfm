<cfif Variables.doAction is not "insertSubscriberNotify">
	<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="selectSubscriberNotifyList" ReturnVariable="qry_selectSubscriberNotifyList">
		<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
		<!--- <cfinvokeargument Name="subscriberNotifyStatus" Value="1"> --->
	</cfinvoke>

	<cfset Variables.subscriberUserID_list = "">
	<cfloop Query="qry_selectSubscriberNotifyList">
		<cfif qry_selectSubscriberNotifyList.subscriberNotifyStatus is 1>
			<cfset Variables.subscriberUserID_list = ListAppend(Variables.subscriberUserID_list, qry_selectSubscriberNotifyList.userID)>
		</cfif>
	</cfloop>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUserList">
	<cfinvokeargument Name="userID" Value="#Variables.subscriberUserID_list#">
</cfinvoke>

<cfset Variables.subscriberNotifyCompanyID_list = ValueList(qry_selectUserList.companyID)>
<cfset Variables.subscriberNotifyAddressID_list = "">
<cfset Variables.subscriberNotifyPhoneID_list = "">

<cfloop Query="qry_selectSubscriberNotifyList">
	<cfif qry_selectSubscriberNotifyList.addressID is not 0 and Not ListFind(Variables.subscriberNotifyAddressID_list, qry_selectSubscriberNotifyList.addressID)>
		<cfset Variables.subscriberNotifyAddressID_list = ListAppend(Variables.subscriberNotifyAddressID_list, qry_selectSubscriberNotifyList.addressID)>
	</cfif>
	<cfif qry_selectSubscriberNotifyList.phoneID is not 0 and Not ListFind(Variables.subscriberNotifyAddressID_list, qry_selectSubscriberNotifyList.phoneID)>
		<cfset Variables.subscriberNotifyPhoneID_list = ListAppend(Variables.subscriberNotifyPhoneID_list, qry_selectSubscriberNotifyList.phoneID)>
	</cfif>
</cfloop>

<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList">
	<cfinvokeargument Name="companyID" Value="#Variables.subscriberNotifyCompanyID_list#">
	<cfinvokeargument Name="userID" Value="#Variables.subscriberUserID_list#">
	<cfinvokeargument Name="addressTypeBilling" Value="1">
	<cfinvokeargument Name="addressStatus" Value="1">
</cfinvoke>

<cfif Variables.subscriberNotifyAddressID_list is not "">
	<cfinvoke Component="#Application.billingMapping#data.Address" Method="selectAddressList" ReturnVariable="qry_selectAddressList_existing">
		<cfinvokeargument Name="addressID" Value="#Variables.subscriberNotifyAddressID_list#">
	</cfinvoke>

	<cfloop Query="qry_selectAddressList_existing">
		<cfif Not ListFind(ValueList(qry_selectAddressList.addressID), qry_selectAddressList_existing.addressID)>
			<cfset temp = QueryAddRow(qry_selectAddressList, 1)>
			<cfset Variables.addressRow = CurrentRow>
			<cfloop Index="field" List="#qry_selectAddressList.ColumnList#">
				<cfset temp = QuerySetCell(qry_selectAddressList, field, Evaluate("qry_selectAddressList_existing.#field#[#Variables.addressRow#]"))>
			</cfloop>
		</cfif>
	</cfloop>
</cfif>

<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectPhoneList">
	<cfinvokeargument Name="companyID" Value="#Variables.subscriberNotifyCompanyID_list#">
	<cfinvokeargument Name="userID" Value="#Variables.subscriberUserID_list#">
	<cfinvokeargument Name="phoneStatus" Value="1">
	<cfinvokeargument Name="phoneType" Value="fax">
</cfinvoke>

<cfif Variables.subscriberNotifyPhoneID_list is not "">
	<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectPhoneList_existing">
		<cfinvokeargument Name="phoneID" Value="#Variables.subscriberNotifyPhoneID_list#">
	</cfinvoke>

	<cfloop Query="qry_selectPhoneList_existing">
		<cfif Not ListFind(ValueList(qry_selectPhoneList.phoneID), qry_selectPhoneList_existing.phoneID)>
			<cfset temp = QueryAddRow(qry_selectPhoneList, 1)>
			<cfset Variables.phoneRow = CurrentRow>
			<cfloop Index="field" List="#qry_selectPhoneList.ColumnList#">
				<cfset temp = QuerySetCell(qry_selectPhoneList, field, Evaluate("qry_selectPhoneList_existing.#field#[#Variables.phoneRow#]"))>
			</cfloop>
		</cfif>
	</cfloop>
</cfif>

<cfinclude template="formParam_insertUpdateSubscriberNotify.cfm">
<cfinclude template="../../view/v_subscription/lang_insertUpdateSubscriberNotify.cfm">

<cfif Variables.doAction is not "viewSubscriberNotify" and IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitUpdateSubscriberNotify")>
	<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectUserCompanyList_company" ReturnVariable="qry_selectUserCompanyList_company">
		<cfinvokeargument Name="companyID" Value="#qry_selectSubscriber.companyID#">
	</cfinvoke>

	<cfinclude template="formValidate_insertUpdateSubscriberNotify.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../view/error_formValidation.cfm">
	<cfelse>
		<cfloop Query="qry_selectUserList">
			<cfset Variables.notifyRow = ListFind(ValueList(qry_selectSubscriberNotifyList.userID), qry_selectUserList.userID)>
			<cfif Form["addressID#qry_selectUserList.userID#"] is not 0 or Form["subscriberNotifyEmail#qry_selectUserList.userID#"] is not 0
					or Form["subscriberNotifyEmailHtml#qry_selectUserList.userID#"] is not 0 or Form["subscriberNotifyPdf#qry_selectUserList.userID#"] is not 0
					or Form["subscriberNotifyDoc#qry_selectUserList.userID#"] is not 0 or Form["phoneID#qry_selectUserList.userID#"] is not 0>
				<cfset Variables.subscriberNotifyStatus = 1>
			<cfelse>
				<cfset Variables.subscriberNotifyStatus = 0>
			</cfif>

			<cfif Variables.notifyRow is 0>
				<cfset Variables.notifyMethod = "insertSubscriberNotify">
			<cfelse>
				<cfset Variables.notifyMethod = "updateSubscriberNotify">
			</cfif>

			<cfif Variables.subscriberNotifyStatus is 1 or Variables.notifyMethod is "updateSubscriberNotify">
				<cfinvoke Component="#Application.billingMapping#data.SubscriberNotify" Method="#Variables.notifyMethod#" ReturnVariable="isSubscriberNotifyInserted">
					<cfinvokeargument Name="subscriberID" Value="#URL.subscriberID#">
					<cfinvokeargument Name="userID" Value="#qry_selectUserList.userID#">
					<cfinvokeargument Name="subscriberNotifyStatus" Value="#Variables.subscriberNotifyStatus#">
					<cfif Variables.subscriberNotifyStatus is 1>
						<cfinvokeargument Name="userID_author" Value="#Session.userID#">
						<cfinvokeargument Name="userID_cancel" Value="0">
					<cfelse>
						<cfinvokeargument Name="userID_cancel" Value="#Session.userID#">
					</cfif>
					<cfinvokeargument Name="addressID" Value="#Form["addressID#qry_selectUserList.userID#"]#">
					<cfinvokeargument Name="subscriberNotifyEmail" Value="#Form["subscriberNotifyEmail#qry_selectUserList.userID#"]#">
					<cfinvokeargument Name="subscriberNotifyEmailHtml" Value="#Form["subscriberNotifyEmailHtml#qry_selectUserList.userID#"]#">
					<cfinvokeargument Name="subscriberNotifyPdf" Value="#Form["subscriberNotifyPdf#qry_selectUserList.userID#"]#">
					<cfinvokeargument Name="subscriberNotifyDoc" Value="#Form["subscriberNotifyDoc#qry_selectUserList.userID#"]#">
					<cfinvokeargument Name="phoneID" Value="#Form["phoneID#qry_selectUserList.userID#"]#">
				</cfinvoke>
			</cfif>
		</cfloop>

		<!--- check for trigger --->
		<cfinvoke component="#Application.billingMapping#control.c_trigger.CheckForTrigger" method="checkForTrigger" returnVariable="isTrigger">
			<cfinvokeargument name="companyID" value="#Session.companyID#">
			<cfinvokeargument name="doAction" value="#Variables.doAction#">
			<cfinvokeargument name="isWebService" value="False">
			<cfinvokeargument name="doControl" value="#Variables.doControl#">
			<cfinvokeargument name="primaryTargetKey" value="subscriberID">
			<cfinvokeargument name="targetID" value="#URL.subscriberID#">
		</cfinvoke>

		<cflocation url="#Variables.formAction#&confirm_subscription=#Variables.doAction#" AddToken="No">
	</cfif>
</cfif>

<cfswitch expression="#Variables.doAction#">
<cfcase value="insertSubscriberNotify"><cfset Variables.formSubmitValue = Variables.lang_insertUpdateSubscriberNotify.formSubmitValue_insert></cfcase>
<cfcase value="updateSubscriberNotify"><cfset Variables.formSubmitValue = Variables.lang_insertUpdateSubscriberNotify.formSubmitValue_update></cfcase>
<cfcase value="viewSubscriberNotify"><cfset Variables.formAction = ""></cfcase>
</cfswitch>

<cfset Variables.columnHeaderList = Variables.lang_insertUpdateSubscriberNotify_title.lastName
		& "^" & Variables.lang_insertUpdateSubscriberNotify_title.subscriberNotifyEmail
		& "^" & Variables.lang_insertUpdateSubscriberNotify_title.subscriberNotifyEmailHtml
		& "^" & Variables.lang_insertUpdateSubscriberNotify_title.subscriberNotifyPdf
		& "^" & Variables.lang_insertUpdateSubscriberNotify_title.subscriberNotifyDoc
		& "^" & Variables.lang_insertUpdateSubscriberNotify_title.phoneID
		& "^" & Variables.lang_insertUpdateSubscriberNotify_title.addressID>
<cfset Variables.columnCount = DecrementValue(2 * ListLen(Variables.columnHeaderList, "^"))>
<cfinclude template="../../include/function/fn_DisplayOrderByNav.cfm">

<cfinclude template="../../view/v_subscription/form_insertUpdateSubscriberNotify.cfm">
