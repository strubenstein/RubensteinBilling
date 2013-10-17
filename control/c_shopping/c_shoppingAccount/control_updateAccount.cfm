<cfinvoke component="#Application.billingMapping#data.User" method="maxlength_User" returnVariable="maxlength_User" />
<cfinvoke component="#Application.billingMapping#data.Company" method="maxlength_Company" returnVariable="maxlength_Company" />
<cfinvoke component="#Application.billingMapping#data.Phone" method="maxlength_Phone" returnVariable="maxlength_Phone" />

<cfinvoke Component="#Application.billingMapping#data.Company" Method="selectCompany" ReturnVariable="qry_selectCompany">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.User" Method="selectUser" ReturnVariable="qry_selectUser">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
</cfinvoke>

<cfinvoke Component="#Application.billingMapping#data.Phone" Method="selectPhoneList" ReturnVariable="qry_selectPhoneList">
	<cfinvokeargument Name="phoneStatus" Value="1">
	<cfinvokeargument Name="userID" Value="#Session.userID#">
	<cfinvokeargument Name="companyID" Value="#Session.companyID#">
</cfinvoke>

<cfinclude template="../c_shoppingCheckout/formParam_checkoutRegister.cfm">

<cfif IsDefined("Form.isFormSubmitted") and IsDefined("Form.submitRegister")>
	<cfinclude template="../../../include/function/fn_IsValidEmail.cfm">
	<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/lang_checkoutRegister.cfm">
	<cfinclude template="../c_shoppingCheckout/formValidate_checkoutRegister.cfm">

	<cfif isAllFormFieldsOk is False>
		<cfinclude template="../../../view/error_formValidation.cfm">
	<cfelse>
		<!--- update user; archive old values --->
		<cfinvoke Component="#Application.billingMapping#data.User" Method="updateUser" ReturnVariable="isUserUpdated">
			<cfinvokeargument Name="userID" Value="#Session.userID#">
			<cfinvokeargument Name="username" Value="#Form.username#">
			<cfif Form.password is not "">
				<cfinvokeargument Name="password" Value="#Form.password#">
			</cfif>
			<cfinvokeargument Name="firstName" Value="#Form.firstName#">
			<cfinvokeargument Name="lastName" Value="#Form.lastName#">
			<cfinvokeargument Name="email" Value="#Form.email#">
		</cfinvoke>

		<!--- update company --->
		<cfinvoke Component="#Application.billingMapping#data.Company" Method="updateCompany" ReturnVariable="isCompanyUpdated">
			<cfinvokeargument Name="companyID" Value="#Session.companyID#">
			<cfinvokeargument Name="companyName" Value="#Form.companyName#">
		</cfinvoke>

		<!--- archive old user/company fields --->
		<cfif Form.companyName is not qry_selectCompany.companyName>
			<cfinvoke Component="#Application.billingMapping#data.FieldArchive" Method="insertFieldArchive" ReturnVariable="isFieldArchiveMultipleInserted">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("companyID")#">
				<cfinvokeargument Name="targetID" Value="#Session.companyID#">
				<cfinvokeargument Name="fieldArchiveTableName" Value="avCompany">
				<cfinvokeargument Name="fieldArchiveFieldName" Value="companyName">
				<cfinvokeargument Name="fieldArchiveValue" Value="#qry_selectCompany.companyName#">
			</cfinvoke>
		</cfif>

		<cfset Variables.fieldArchiveArray = ArrayNew(1)>
		<cfloop Index="field" List="username,firstName,lastName,email">
			<cfif Form[field] is not Evaluate("qry_selectUser.#field#")>
				<cfset Variables.fieldArchiveStruct = StructNew()>
				<cfset Variables.fieldArchiveStruct.fieldArchiveTableName = "avUser">
				<cfset Variables.fieldArchiveStruct.fieldArchiveFieldName = field>
				<cfset Variables.fieldArchiveStruct.fieldArchiveValue = Evaluate("qry_selectUser.#field#")>
				<cfset Variables.fieldArchiveArray[ArrayLen(Variables.fieldArchiveArray) + 1] = Variables.fieldArchiveStruct>
			</cfif>
		</cfloop>

		<cfif ArrayLen(Variables.fieldArchiveArray) is not 0>
			<cfinvoke Component="#Application.billingMapping#data.FieldArchive" Method="insertFieldArchive_multiple" ReturnVariable="isFieldArchiveMultipleInserted">
				<cfinvokeargument Name="userID" Value="0">
				<cfinvokeargument Name="primaryTargetID" Value="#Application.fn_GetPrimaryTargetID("userID")#">
				<cfinvokeargument Name="targetID" Value="#Session.userID#">
				<cfinvokeargument Name="fieldArchiveArray" Value="#Variables.fieldArchiveArray#">
			</cfinvoke>
		</cfif>

		<!--- get original phone/fax fields for comparison --->
		<cfset Variables.phoneAreaCode_orig = "">
		<cfset Variables.phoneNumber_orig = "">
		<cfset Variables.phoneExtension_orig = "">
		<cfset Variables.phoneID_parent = 0>
		<cfset Variables.phoneID_trend = 0>
		<cfset Variables.phoneVersion = 0>
		<cfset Variables.phoneID = 0>

		<cfset Variables.faxAreaCode_orig = "">
		<cfset Variables.faxNumber_orig = "">
		<cfset Variables.faxID_trend = 0>
		<cfset Variables.faxID_parent = 0>
		<cfset Variables.faxVersion = 0>
		<cfset Variables.faxID = 0>

		<cfloop Query="qry_selectPhoneList">
			<cfif qry_selectPhoneList.phoneType is "Fax">
				<cfset Variables.faxAreaCode_orig = qry_selectPhoneList.phoneAreaCode>
				<cfset Variables.faxNumber_orig = qry_selectPhoneList.phoneNumber>
				<cfset Variables.faxID_trend = qry_selectPhoneList.phoneID_trend>
				<cfset Variables.faxID_parent = qry_selectPhoneList.phoneID>
				<cfset Variables.faxVersion = qry_selectPhoneList.phoneVersion>
				<cfset Variables.faxID = qry_selectPhoneList.phoneID>
			<cfelse>
				<cfset Variables.phoneAreaCode_orig = qry_selectPhoneList.phoneAreaCode>
				<cfset Variables.phoneNumber_orig = qry_selectPhoneList.phoneNumber>
				<cfset Variables.phoneExtension_orig = qry_selectPhoneList.phoneExtension>
				<cfset Variables.phoneID_trend = qry_selectPhoneList.phoneID_trend>
				<cfset Variables.phoneID_parent = qry_selectPhoneList.phoneID>
				<cfset Variables.phoneVersion = qry_selectPhoneList.phoneVersion>
				<cfset Variables.phoneID = qry_selectPhoneList.phoneID>
			</cfif>
		</cfloop>

		<!--- update phone; archive old phone --->
		<cfif Form.phoneAreaCode is not Variables.phoneAreaCode_orig
				or Form.phoneNumber is not Variables.phoneNumber_orig
				or Form.phoneExtension is not Variables.phoneExtension_orig>
			<cfif Variables.phoneID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Phone" Method="updatePhone" ReturnVariable="isPhoneUpdated">
					<cfinvokeargument Name="phoneID" Value="#Variables.phoneID#">
					<cfinvokeargument Name="phoneStatus" Value="0">
				</cfinvoke>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Phone" Method="insertPhone" ReturnVariable="newPhoneID">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="userID_author" Value="0">
				<cfinvokeargument Name="phoneID_trend" Value="#Variables.phoneID_trend#">
				<cfinvokeargument Name="phoneID_parent" Value="#Variables.phoneID_parent#">
				<cfinvokeargument Name="phoneVersion" Value="#IncrementValue(Variables.phoneVersion)#">
				<cfinvokeargument Name="phoneAreaCode" Value="#Form.phoneAreaCode#">
				<cfinvokeargument Name="phoneNumber" Value="#REReplace(Form.phoneNumber, "[^0-9]", "", "ALL")#">
				<cfinvokeargument Name="phoneExtension" Value="#REReplace(Form.phoneExtension, "[^0-9]", "", "ALL")#">
				<cfinvokeargument Name="phoneStatus" Value="1">
				<cfinvokeargument Name="phoneType" Value="Home">
				<cfinvokeargument Name="phoneDescription" Value="">
			</cfinvoke>
		</cfif>

		<!--- update fax; archive old fax --->
		<cfif Form.faxAreaCode is not Variables.faxAreaCode_orig
				or Form.faxNumber is not Variables.faxNumber_orig>
			<cfif Variables.faxID is not 0>
				<cfinvoke Component="#Application.billingMapping#data.Phone" Method="updatePhone" ReturnVariable="isFaxUpdated">
					<cfinvokeargument Name="phoneID" Value="#Variables.faxID#">
					<cfinvokeargument Name="phoneStatus" Value="0">
				</cfinvoke>
			</cfif>

			<cfinvoke Component="#Application.billingMapping#data.Phone" Method="insertPhone" ReturnVariable="newFaxID">
				<cfinvokeargument Name="companyID" Value="#Session.companyID#">
				<cfinvokeargument Name="userID" Value="#Session.userID#">
				<cfinvokeargument Name="userID_author" Value="0">
				<cfinvokeargument Name="phoneID_trend" Value="#Variables.faxID_trend#">
				<cfinvokeargument Name="phoneID_parent" Value="#Variables.faxID_parent#">
				<cfinvokeargument Name="phoneVersion" Value="#IncrementValue(Variables.faxVersion)#">
				<cfinvokeargument Name="phoneAreaCode" Value="#Form.faxAreaCode#">
				<cfinvokeargument Name="phoneNumber" Value="#REReplace(Form.faxNumber, "[^0-9]", "", "ALL")#">
				<cfinvokeargument Name="phoneExtension" Value="">
				<cfinvokeargument Name="phoneStatus" Value="1">
				<cfinvokeargument Name="phoneType" Value="Fax">
				<cfinvokeargument Name="phoneDescription" Value="">
			</cfinvoke>
		</cfif>

		<cflocation url="myAccount.cfm?action=#URL.action#&confirm_shopping=#URL.action#" AddToken="No">
	</cfif>
</cfif>

<cfset Variables.formAction = "myAccount.cfm?action=#URL.action#">
<cfset Variables.formSubmitValue = "Update Account">

<cfinclude template="../../../view/v_shopping/v_shoppingAccount/header_updateAccount.cfm">
<cfinclude template="../../../view/v_shopping/v_shoppingCheckout/form_checkoutRegister.cfm">

