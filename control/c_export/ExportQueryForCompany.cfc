<cfcomponent displayName="ExportQueryForCompany">

<cffunction name="exportQueryForCompany" access="public" output="no" returnType="boolean">
	<cfargument name="exportResultsMethod" type="string" required="yes" hint="Form value">
	<cfargument name="exportResultsFormat" type="string" required="yes" hint="Form value">
	<cfargument name="xmlTagPlural" type="string" required="yes">
	<cfargument name="xmlTagSingle" type="string" required="yes">
	<cfargument name="fileNamePrefix" type="string" required="yes">
	<cfargument name="exportQueryName" type="string" required="yes">
	<cfargument name="qry_exportTargetList" type="query" required="yes">
	<cfargument name="fieldsWithCustomDisplay" type="string" required="yes">
	<cfargument name="fieldsWithCustomName" type="string" required="no" default="">

	<cfset var exportStruct = StructNew()>
	<cfset var tab = "	">

	<cfswitch expression="#Arguments.exportResultsMethod#">
	<cfcase value="excel">
		<cfset exportStruct.exportFileExtension = ".xls">
		<cfset exportStruct.exportFileType = "application/msexcel">
	</cfcase>
	<cfcase value="iif"><!--- QuickBooks tab-delimited --->
		<cfset exportStruct.exportFileExtension = ".iif">
		<cfset exportStruct.exportFileType = "text/txt">
	</cfcase>
	<cfcase value="tab">
		<cfset exportStruct.exportFileExtension = ".txt">
		<cfset exportStruct.exportFileType = "text/txt">
	</cfcase>
	<cfcase value="xml">
		<cfset exportStruct.exportFileExtension = ".xml">
		<cfset exportStruct.exportFileType = "text/xml">
	</cfcase>
	</cfswitch>

	<cfif Arguments.exportResultsMethod is not "iif">
		<!--- If XML or data format, get XML field names. If tab/excel and display, get field headers. --->
		<cfinvoke Component="#Application.billingMapping#data.ExportQueryFieldCompany" Method="selectExportQueryForCompany" ReturnVariable="qry_selectExportQueryForCompany">
			<cfinvokeargument Name="companyID" Value="#Session.companyID_author#">
			<cfinvokeargument Name="exportQueryName" Value="#Arguments.exportQueryName#">
			<cfif Arguments.exportResultsMethod is "xml" or Arguments.exportResultsFormat is "data"><!--- tab,html,xml --->
				<cfinvokeargument Name="exportResultsMethod" Value="xml">
			<cfelse><!--- data --->
				<cfinvokeargument Name="exportResultsMethod" Value="tab">
			</cfif>
		</cfinvoke>
	<cfelse><!--- QuickBooks tab-delimited --->
		<!--- Create query of export fields --->
		<cfset qry_selectExportQueryForCompany = QueryNew("")>
		<!--- exportTableFieldName,exportQueryFieldAs,exportTableFieldName_default,exportTableFieldName_custom --->
		<!--- Determine fields based on QuickBooks export and query name --->
		<cfinclude template="act_exportQueryForCompany_quickbooks.cfm">
	</cfif>

	<!--- 
	If any fields have different names as returned in query compared to actual database field name, rename export query fields
	List of realName|selectAsName

	<cfloop Index="fieldOldNew" List="#Arguments.fieldsWithCustomName#">
		<cfset exportStruct.fieldRow = ListFind(ValueList(qry_selectExportQueryForCompany.exportTableFieldName), ListFirst(fieldOldNew, "|"))>
		<cfif exportStruct.fieldRow is not 0>
			<cfset QuerySetCell(qry_selectExportQueryForCompany, exportTableFieldName, ListLast(fieldOldNew, "|"), exportStruct.fieldRow)>
		</cfif>
	</cfloop>
	--->

	<cfset exportStruct.exportFileDirectory = Application.billingTempPath & Application.billingFilePathSlash>
	<cfif Session.companyDirectory is not "">
		<cfset exportStruct.exportFileDirectory = exportStruct.exportFileDirectory & Session.companyDirectory & Application.billingFilePathSlash>
	</cfif>
	<cfset exportStruct.exportFilename = Arguments.fileNamePrefix & "_" & DateFormat(Now(), "yyyymmdd") & exportStruct.exportFileExtension>

	<cfscript>
	function fnx_fieldName (defaultFieldName, customFieldName)
	{
		if (customFieldName is "")
			return defaultFieldName;
		else
			return customFieldName;
	}

	function fnx_fieldData (fieldName, fieldAs, queryRow)
	{
		var fieldData = "";

		if (fieldAs is "")
			{
			fieldData = Evaluate("Arguments.qry_exportTargetList.#fieldName#[queryRow]");
			if (ListFind(Arguments.fieldsWithCustomDisplay, fieldName))
				fieldData = Evaluate("fnx_#fieldName#(fieldData)");
			}
		else
			{
			fieldData = Evaluate("Arguments.qry_exportTargetList.#fieldAs#[queryRow]");
			if (ListFind(Arguments.fieldsWithCustomDisplay, fieldAs))
				fieldData = Evaluate("fnx_#fieldAs#(fieldData)");
			}
	
		return fieldData;
	}

	// CUSTOM FUNCTIONS FOR TARGET TYPE TO FORMAT DATA
	// affiliate
	function fnx_affiliateStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_affiliateDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_affiliateDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// cobrand
	function fnx_cobrandStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_cobrandDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_cobrandDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// company
	function fnx_companyStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_companyID_parent (value) {if (value is 0) return ""; else return value;}
	function fnx_companyIsAffiliate (value) {if (value is 1) return "Is Affiliate"; else return "Not Affiliate";}
	function fnx_companyIsCobrand (value) {if (value is 1) return "Is Cobrand"; else return "Not Cobrand";}
	function fnx_companyIsVendor (value) {if (value is 1) return "Is Vendor"; else return "Not Vendor";}
	function fnx_companyIsCustomer (value) {if (value is 1) return "Is Customer"; else return "Not Customer";}
	function fnx_companyIsTaxExempt (value) {if (value is 1) return "Is TaxExempt"; else return "Not TaxExempt";}
	function fnx_companyDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_companyDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// invoice
	function fnx_invoiceTotal (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_invoiceTotalTax (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_invoiceTotalLineItem (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_invoiceTotalPaymentCredit (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_invoiceTotalShipping (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_invoiceStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_invoiceSent (value) {if (value is 1) return "Sent"; else return "Not Sent";}
	function fnx_invoiceClosed (value) {if (value is 0) return "Open"; else return "Closed";}
	function fnx_invoiceDateClosed (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_invoicePaid (value) {if (value is "") return "Not Paid"; else if (value is 0) return "Partially Paid"; else return "Fully Paid";}
	function fnx_invoiceDatePaid (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_invoiceShipped (value) {if (value is "") return "No"; else if (value is 0) return "Partially Shipped"; else return "Fully Shipped";}
	function fnx_invoiceCompleted (value) {if (value is 0) return "Not Completed"; else return "Completed";}
	function fnx_invoiceDateCompleted (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_invoiceDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_invoiceDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// newsletterSubscriber
	function fnx_newsletterSubscriberStatus (value) {if (value is 1) return "Subscribed"; else return "Unsubscribed";}
	function fnx_newsletterSubscriberHtml (value) {if (value is 1) return "html"; else return "text";}
	function fnx_newsletterSubscriberDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// payment
	function fnx_paymentAmount (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_paymentManual (value) {if (value is 0) return "Automated"; else return "Manual";}
	function fnx_paymentProcessed (value) {if (value is 1) return "Processed"; else return "Not Processed";}
	function fnx_paymentCheckNumber (value) {if (value is 0) return ""; else return value;}
	function fnx_paymentApproved (value) {if (value is "") return "Unknown"; else if (value is 0) return "Approved"; else return "Rejected";}
	function fnx_paymentStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_paymentIsRefund (value) {if (value is 0) return "Payment"; else return "Refund";}
	function fnx_paymentDateReceived (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_paymentDateScheduled (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_paymentDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_paymentDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// paymentCredit
	function fnx_paymentCreditAmount (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_paymentCreditStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_paymentCreditRollover (value) {if (value is 0) return "No"; else return "Roll Over";}
	function fnx_paymentCreditNegativeInvoice (value) {if (value is 0) return "No"; else return "Negative Invoice Allowed";}
	function fnx_paymentCreditCompleted (value) {if (value is 1) return "Available"; else return "Completed";}
	function fnx_paymentCreditDateBegin (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_paymentCreditDateEnd (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_paymentCreditDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_paymentCreditDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// product
	function fnx_productPrice (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_productPriceCallForQuote (value) {if (value is 1) return "Yes"; else return "No";}
	function fnx_productWeight (value) {if (value is 0) return ""; else return value;}
	function fnx_productStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_productListedOnSite (value) {if (value is 1) return "Listed"; else return "Not Listed";}
	function fnx_productCanBePurchased (value) {if (value is 1) return "May Be Purchased"; else return "Cannot Be Purchased";}
	function fnx_productDisplayChildren (value) {if (value is 1) return "Yes"; else return "No";}
	function fnx_productChildType (value) {if (value is 0) return ""; else if (value is 1) return "Variation"; else return "Upgrade/Add-On Option";}
	function fnx_productCatalogPageNumber (value) {if (value is 0) return ""; else return value;}
	function fnx_productChildOrder (value) {if (value is 0) return ""; else return value;}
	function fnx_productChildSeparate (value) {if (value is 1) return "Yes"; else return "No";}
	function fnx_productInWarehouse (value) {if (value is 1) return "In Stock"; else return "Out of Stock";}
	function fnx_productDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_productDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// salesCommission
	function fnx_salesCommissionAmount (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_salesCommissionBasisTotal (value) {if (Form.exportResultsFormat is "display") return "$" & Application.fn_LimitPaddedDecimalZerosDollar(value); else return Application.fn_LimitPaddedDecimalZerosDollar(value);}
	function fnx_salesCommissionBasisQuantity (value) {if (Form.exportResultsFormat is "display") return Application.fn_LimitPaddedDecimalZerosQuantity(value); else return Application.fn_LimitPaddedDecimalZerosQuantity(value);}
	function fnx_salesCommissionFinalized (value) {if (value is 1) return "Finalized"; else return "Open";}
	function fnx_salesCommissionPaid (value) {if (value is 1) return "Fully Paid"; else if (value is 0) return "Partially Paid"; else return "Not Paid";}
	function fnx_salesCommissionStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_salesCommissionManual (value) {if (value is 1) return "Manual"; else return "Auto";}
	function fnx_commissionStatus (value) {if (value is 1) return "Active"; else if (value is 0) return "Inactive"; else return "";}
	function fnx_commissionPeriodOrInvoiceBased (value) {if (value is 1) return "Invoice"; else if (value is 0) return "Period"; else return "";}
	function fnx_commissionHasMultipleStages (value) {if (value is 1) return "Multiple Stages"; else if (value is 0) return "One Stage"; else return "";}
	function fnx_salesCommissionDateFinalized (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_salesCommissionDatePaid (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_salesCommissionDateBegin (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_salesCommissionDateEnd (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_salesCommissionDateCreated (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_salesCommissionDateUpdated (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_commissionDateCreated (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_commissionDateUpdated (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// subscriber
	function fnx_subscriberStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_subscriberCompleted (value) {if (value is 1) return "Completed"; else return "Not Completed";}
	function fnx_subscriberDateProcessNext (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_subscriberDateProcessLast (value) {if (Not IsDate(value)) return ""; else return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_subscriberDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_subscriberDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// user
	function fnx_userStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_userNewsletterStatus (value) {if (value is 1) return "Subscribed"; else return "Not Subscribed";}
	function fnx_userNewsletterHtml (value) {if (value is 1) return "HTML"; else return "Text";}
	function fnx_userDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_userDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}

	// vendor
	function fnx_vendorStatus (value) {if (value is 1) return "Active"; else return "Inactive";}
	function fnx_vendorDescriptionDisplay (value) {if (value is 1) return "Yes"; else return "No";}
	function fnx_vendorURLdisplay (value) {if (value is 1) return "Yes"; else return "No";}
	function fnx_vendorDescriptionHtml (value) {if (value is 1) return "html"; else return "text";}
	function fnx_vendorDateCreated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	function fnx_vendorDateUpdated (value) {return DateFormat(value, "mm/dd/yyyy") & " " & TimeFormat(value, "hh:mm tt");}
	</cfscript>

	<cfswitch expression="#Arguments.exportResultsMethod#">
	<cfcase value="xml">
		<cfset exportStruct.exportFile = "<?xml version=""1.0""?><#Arguments.xmlTagPlural#>">
		<cfloop Query="Arguments.qry_exportTargetList">
			<cfset exportStruct.queryRow = CurrentRow>
			<cfset exportStruct.exportFile = exportStruct.exportFile & "<#Arguments.xmlTagSingle#>">
			<cfloop Query="qry_selectExportQueryForCompany">
				<cfset exportStruct.exportFile = exportStruct.exportFile
					& "<" & fnx_fieldName(qry_selectExportQueryForCompany.exportTableFieldName_default, qry_selectExportQueryForCompany.exportTableFieldName_custom) & ">"
					& XmlFormat(fnx_fieldData(qry_selectExportQueryForCompany.exportTableFieldName, qry_selectExportQueryForCompany.exportQueryFieldAs, exportStruct.queryRow))
					& "</" & fnx_fieldName(qry_selectExportQueryForCompany.exportTableFieldName_default, qry_selectExportQueryForCompany.exportTableFieldName_custom) & ">">
			</cfloop>
			<cfset exportStruct.exportFile = exportStruct.exportFile & "</#Arguments.xmlTagSingle#>">
		</cfloop>
		<cfset exportStruct.exportFile = exportStruct.exportFile & "</#Arguments.xmlTagPlural#>">
	</cfcase>

	<cfcase value="iif"><!--- QuickBooks tab-delimited --->
		<!--- Not yet written --->
	</cfcase>

	<cfdefaultcase><!--- tab,excel --->
		<cfset exportStruct.exportFile = "">
		<cfloop Query="qry_selectExportQueryForCompany">
			<cfset exportStruct.exportFile = ListAppend(exportStruct.exportFile, fnx_fieldName(qry_selectExportQueryForCompany.exportTableFieldName_default, qry_selectExportQueryForCompany.exportTableFieldName_custom), tab)>
		</cfloop>

		<cfloop Query="Arguments.qry_exportTargetList">
			<cfset exportStruct.queryRow = CurrentRow>
			<cfset exportStruct.thisDataRow = "">
			<cfloop Query="qry_selectExportQueryForCompany">
				<cfset exportStruct.thisDataRow = ListAppend(exportStruct.thisDataRow, fnx_fieldData(qry_selectExportQueryForCompany.exportTableFieldName, qry_selectExportQueryForCompany.exportQueryFieldAs, exportStruct.queryRow), tab)>
			</cfloop>
			<cfset exportStruct.exportFile = exportStruct.exportFile & Chr(10) & exportStruct.thisDataRow>
		</cfloop>
	</cfdefaultcase>
	</cfswitch>

	<cffile Action="Write" File="#exportStruct.exportFileDirectory##exportStruct.exportFilename#" Output="#exportStruct.exportFile#">

	<cfheader Name="Content-Disposition" Value="attachment;filename=#exportStruct.exportFilename#">
	<cfcontent File="#exportStruct.exportFileDirectory##exportStruct.exportFilename#" Type="#exportStruct.exportFileType#" DeleteFile="Yes">

	<cfreturn True>
</cffunction>

</cfcomponent>
