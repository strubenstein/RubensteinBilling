DROP SCHEMA IF EXISTS `Billing` ;
CREATE SCHEMA IF NOT EXISTS `Billing` COLLATE utf8_general_ci ;

CREATE  TABLE IF NOT EXISTS `Billing`.`avExportTableField` (
	`exportTableFieldID` INT NOT NULL AUTO_INCREMENT ,
	`exportTableID` INT NOT NULL DEFAULT 0 ,
	`exportTableFieldName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldType` VARCHAR(50) NOT NULL DEFAULT '',
	`exportTableFieldPrimaryKey` TINYINT NOT NULL DEFAULT 0 ,
	`exportTableFieldSize` SMALLINT NOT NULL DEFAULT 0 ,
	`exportTableFieldDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`exportTableFieldOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`exportTableFieldXmlName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldXmlStatus` TINYINT NOT NULL DEFAULT 0 ,
	`exportTableFieldTabName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldTabStatus` TINYINT NOT NULL DEFAULT 0 ,
	`exportTableFieldHtmlName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldHtmlStatus` TINYINT NOT NULL DEFAULT 0 ,
	`exportTableFieldStatus` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`exportTableFieldID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSalesCommissionInvoice` (
	`salesCommissionID` INT NOT NULL DEFAULT 0 ,
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
	`salesCommissionInvoiceAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`salesCommissionInvoiceQuantity` DECIMAL(19,4) NOT NULL DEFAULT 0 ,
	`commissionCustomerID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`salesCommissionID`, `invoiceID`, `invoiceLineItemID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avRegionBundle` (
	`regionID_isBundle` INT NOT NULL DEFAULT 0 ,
	`regionID_inBundle` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`regionID_isBundle`, `regionID_inBundle`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoiceLineItemParameter` (
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`invoiceLineItemID`, `productParameterOptionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductRegion` (
	`productID` INT NOT NULL DEFAULT 0 ,
	`regionID` INT NOT NULL DEFAULT 0 ,
	`productRegionStatus` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`productID`, `regionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductBundleProduct` (
	`productBundleID` INT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`productBundleProductOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`productBundleProductQuantity` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`productBundleID`, `productID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avExportTable` (
	`exportTableID` INT NOT NULL AUTO_INCREMENT ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`exportTableName` VARCHAR(50) NOT NULL DEFAULT '',
	`exportTableDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`exportTableOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`exportTableStatus` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`exportTableID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPriceVolumeDiscount` (
	`priceVolumeDiscountID` INT NOT NULL AUTO_INCREMENT ,
	`priceStageID` INT NOT NULL DEFAULT 0 ,
	`priceVolumeDiscountQuantityMinimum` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`priceVolumeDiscountQuantityIsMaximum` TINYINT NOT NULL DEFAULT 0 ,
	`priceVolumeDiscountIsTotalPrice` TINYINT NOT NULL DEFAULT 0 ,
	`priceVolumeDiscountAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`priceVolumeDiscountID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPriceStage` (
	`priceStageID` INT NOT NULL AUTO_INCREMENT ,
	`priceID` INT NOT NULL DEFAULT 0 ,
	`priceStageOrder` TINYINT NOT NULL DEFAULT 0 ,
	`priceStageAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`priceStageDollarOrPercent` TINYINT NOT NULL DEFAULT 0 ,
	`priceStageNewOrDeduction` TINYINT NOT NULL DEFAULT 0 ,
	`priceStageVolumeDiscount` TINYINT NOT NULL DEFAULT 0 ,
	`priceStageVolumeDollarOrQuantity` TINYINT NOT NULL DEFAULT 0 ,
	`priceStageVolumeStep` TINYINT NOT NULL DEFAULT 0 ,
	`priceStageInterval` SMALLINT NOT NULL DEFAULT 0 ,
	`priceStageIntervalType` VARCHAR(5) NOT NULL DEFAULT '',
	`priceStageText` VARCHAR(255) NOT NULL DEFAULT '',
	`priceStageDescription` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`priceStageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPermissionAction` (
	`permissionID` INT NOT NULL DEFAULT 0 ,
	`permissionAction` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`permissionID`, `permissionAction`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avNewsletter` (
	`newsletterID` INT NOT NULL AUTO_INCREMENT ,
	`contactID` INT NOT NULL DEFAULT 0 ,
	`newsletterRecipientCount` INT NOT NULL DEFAULT 0 ,
	`newsletterDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`newsletterCriteria` TEXT NULL ,
  PRIMARY KEY (`newsletterID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avWebServiceSession` (
	`webServiceSessionID` INT NOT NULL AUTO_INCREMENT ,
	`webServiceSessionUUID` VARCHAR(50) NOT NULL DEFAULT '',
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`webServiceSessionPermissionStruct` VARCHAR(255) NOT NULL DEFAULT '',
	`webServiceSessionIPaddress` VARCHAR(25) NOT NULL DEFAULT '',
	`webServiceSessionLastError` VARCHAR(255) NOT NULL DEFAULT '',
	`webServiceSessionDateCreated` DATETIME NOT NULL,
	`webServiceSessionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`webServiceSessionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avVendor` (
	`vendorID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`vendorCode` VARCHAR(25) NOT NULL DEFAULT '',
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`vendorDescription` VARCHAR(2000) NOT NULL DEFAULT '',
	`vendorDescriptionHtml` TINYINT NOT NULL DEFAULT 0 ,
	`vendorDescriptionDisplay` TINYINT NOT NULL DEFAULT 0 ,
	`vendorURL` VARCHAR(100) NOT NULL DEFAULT '',
	`vendorURLdisplay` TINYINT NOT NULL DEFAULT 0 ,
	`vendorName` VARCHAR(255) NOT NULL DEFAULT '',
	`vendorImage` VARCHAR(100) NOT NULL DEFAULT '',
	`vendorStatus` TINYINT NOT NULL DEFAULT 0 ,
	`vendorID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`vendorDateCreated` DATETIME NOT NULL,
	`vendorDateUpdated` DATETIME NOT NULL,
	`vendorIsExported` TINYINT NULL,
	`vendorDateExported` DATETIME NULL,
  PRIMARY KEY (`vendorID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avUserProductWishList` (
	`productID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`userProductWishListQuantity` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`userProductWishListStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userProductWishListFulfilled` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
	`userProductWishListComment` VARCHAR(255) NOT NULL DEFAULT '',
	`userProductWishListRating` TINYINT NOT NULL DEFAULT 0 ,
	`addressID` INT NOT NULL DEFAULT 0 ,
	`userProductWishListDateCreated` DATETIME NOT NULL,
	`userProductWishListDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productID`, `userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avUserProductFavorite` (
	`productID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`userProductFavoriteQuantity` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`userProductFavoriteStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userProductFavoriteDateCreated` DATETIME NOT NULL,
	`userProductFavoriteDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productID`, `userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avUserCompany` (
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userCompanyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userCompanyDateCreated` DATETIME NOT NULL,
	`userCompanyDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`userID`, `companyID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avShipping` (
	`shippingID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`shippingCarrier` VARCHAR(50) NOT NULL DEFAULT '',
	`shippingMethod` VARCHAR(100) NOT NULL DEFAULT '',
	`shippingWeight` DECIMAL(9,2) NOT NULL DEFAULT 0 ,
	`shippingTrackingNumber` VARCHAR(50) NOT NULL DEFAULT '',
	`shippingInstructions` VARCHAR(255) NOT NULL DEFAULT '',
	`shippingSent` TINYINT NOT NULL DEFAULT 0 ,
	`shippingDateSent` DATETIME NULL,
	`shippingReceived` TINYINT NOT NULL DEFAULT 0 ,
	`shippingDateReceived` DATETIME NULL,
	`shippingStatus` TINYINT NOT NULL DEFAULT 0 ,
	`shippingDateCreated` DATETIME NOT NULL,
	`shippingDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`shippingID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avScheduler` (
	`schedulerID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`schedulerStatus` TINYINT NOT NULL DEFAULT 0 ,
	`schedulerName` VARCHAR(150) NOT NULL DEFAULT '',
	`schedulerDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`schedulerURL` VARCHAR(255) NOT NULL DEFAULT '',
	`schedulerDateBegin` DATETIME NOT NULL,
	`schedulerDateEnd` DATETIME NULL,
	`schedulerInterval` VARCHAR(10) NOT NULL DEFAULT '',
	`schedulerRequestTimeOut` SMALLINT NOT NULL DEFAULT 0 ,
	`schedulerDateCreated` DATETIME NOT NULL,
	`schedulerDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`schedulerID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avRegion` (
	`regionID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`regionName` VARCHAR(255) NOT NULL DEFAULT '',
	`regionCity` VARCHAR(100) NOT NULL DEFAULT '',
	`regionCounty` VARCHAR(100) NOT NULL DEFAULT '',
	`regionState` VARCHAR(100) NOT NULL DEFAULT '',
	`regionStateAbbr` VARCHAR(2) NOT NULL DEFAULT '',
	`regionZipCode` VARCHAR(10) NOT NULL DEFAULT '',
	`regionZipCodeMax` VARCHAR(50) NOT NULL DEFAULT '',
	`regionCountry` VARCHAR(100) NOT NULL DEFAULT '',
	`regionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`regionIsBundle` TINYINT NOT NULL DEFAULT 0 ,
	`regionInBundle` TINYINT NOT NULL DEFAULT 0 ,
	`regionDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`regionDateCreated` DATETIME NOT NULL,
	`regionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`regionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductRecommend` (
	`productID_target` INT NOT NULL DEFAULT 0 ,
	`productID_recommend` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productRecommendStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productRecommendReverse` TINYINT NOT NULL DEFAULT 0 ,
	`productRecommendDateCreated` DATETIME NOT NULL,
	`productRecommendDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productID_target`, `productID_recommend`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductParameterOption` (
	`productParameterOptionID` INT NOT NULL AUTO_INCREMENT ,
	`productParameterID` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionLabel` VARCHAR(100) NOT NULL DEFAULT '',
	`productParameterOptionValue` VARCHAR(100) NOT NULL DEFAULT '',
	`productParameterOptionOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`productParameterOptionImage` VARCHAR(100) NOT NULL DEFAULT '',
	`productParameterOptionCode` VARCHAR(50) NOT NULL DEFAULT '',
	`productParameterOptionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterOptionVersion` SMALLINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionDateCreated` DATETIME NOT NULL,
	`productParameterOptionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productParameterOptionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductParameterException` (
	`productParameterExceptionID` INT NOT NULL AUTO_INCREMENT ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionID1` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionID2` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionID3` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionID4` INT NOT NULL DEFAULT 0 ,
	`productParameterExceptionExcluded` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterExceptionPricePremium` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`productParameterExceptionText` VARCHAR(255) NOT NULL DEFAULT '',
	`productParameterExceptionDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`productParameterExceptionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterExceptionID_parent` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productParameterExceptionDateCreated` DATETIME NOT NULL,
	`productParameterExceptionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productParameterExceptionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductParameter` (
	`productParameterID` INT NOT NULL AUTO_INCREMENT ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`productParameterName` VARCHAR(100) NOT NULL DEFAULT '',
	`productParameterText` VARCHAR(100) NOT NULL DEFAULT '',
	`productParameterDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`productParameterOrder` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterImage` VARCHAR(100) NOT NULL DEFAULT '',
	`productParameterCodeStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterCodeOrder` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterRequired` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productParameterExportXml` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterExportTab` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterExportHtml` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterDateCreated` DATETIME NOT NULL,
	`productParameterDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productParameterID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductDate` (
	`productDateID` INT NOT NULL AUTO_INCREMENT ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`regionID` INT NOT NULL DEFAULT 0 ,
	`productDateBegin` DATETIME NOT NULL,
	`productDateEnd` DATETIME NULL,
	`productDateStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productDateDateCreated` DATETIME NOT NULL,
	`productDateDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productDateID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductCategory` (
	`productID` INT NOT NULL DEFAULT 0 ,
	`categoryID` INT NOT NULL DEFAULT 0 ,
	`productCategoryPrimary` TINYINT NOT NULL DEFAULT 0 ,
	`productCategoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productCategoryOrder` INT NOT NULL DEFAULT 0 ,
	`productCategoryPage` INT NOT NULL DEFAULT 0 ,
	`productCategoryDateCreated` DATETIME NOT NULL,
	`productCategoryDateUpdated` DATETIME NOT NULL,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productCategoryDateBegin` DATETIME NOT NULL,
	`productCategoryDateEnd` DATETIME NULL,
  PRIMARY KEY (`productID`, `categoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductBundle` (
	`productBundleID` INT NOT NULL AUTO_INCREMENT ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`productBundleVersion` SMALLINT NOT NULL DEFAULT 0 ,
	`productBundleStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productBundleDateCreated` DATETIME NOT NULL,
	`productBundleDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productBundleID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProduct` (
	`productID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_manager` INT NOT NULL DEFAULT 0 ,
	`vendorID` INT NOT NULL DEFAULT 0 ,
	`productCode` VARCHAR(40) NOT NULL DEFAULT '',
	`productName` VARCHAR(255) NOT NULL DEFAULT '',
	`productPrice` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`productPriceCallForQuote` TINYINT NOT NULL DEFAULT 0 ,
	`productWeight` DECIMAL(9,2) NOT NULL DEFAULT 0 ,
	`productStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productListedOnSite` TINYINT NOT NULL DEFAULT 0 ,
	`productHasImage` TINYINT NOT NULL DEFAULT 0 ,
	`productHasCustomPrice` TINYINT NOT NULL DEFAULT 0 ,
	`productViewCount` INT NOT NULL DEFAULT 0 ,
	`productInBundle` TINYINT NOT NULL DEFAULT 0 ,
	`productIsBundle` TINYINT NOT NULL DEFAULT 0 ,
	`productIsBundleChanged` TINYINT NOT NULL DEFAULT 0 ,
	`productIsRecommended` TINYINT NOT NULL DEFAULT 0 ,
	`productHasRecommendation` TINYINT NOT NULL DEFAULT 0 ,
	`productIsDateRestricted` TINYINT NOT NULL DEFAULT 0 ,
	`productIsDateAvailable` TINYINT NOT NULL DEFAULT 0 ,
	`productID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`templateFilename` VARCHAR(50) NOT NULL DEFAULT '',
	`productCatalogPageNumber` SMALLINT NOT NULL DEFAULT 0 ,
	`productID_parent` INT NOT NULL DEFAULT 0 ,
	`productHasChildren` TINYINT NOT NULL DEFAULT 0 ,
	`productChildOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`productChildType` TINYINT NOT NULL DEFAULT 0 ,
	`productChildSeparate` TINYINT NOT NULL DEFAULT 0 ,
	`productInWarehouse` TINYINT NOT NULL DEFAULT 0 ,
	`productIsRegionRestricted` TINYINT NOT NULL DEFAULT 0 ,
	`productHasSpec` TINYINT NOT NULL DEFAULT 0 ,
	`productCanBePurchased` TINYINT NOT NULL DEFAULT 0 ,
	`productDisplayChildren` TINYINT NOT NULL DEFAULT 0 ,
	`productHasParameter` TINYINT NOT NULL DEFAULT 0 ,
	`productHasParameterException` TINYINT NOT NULL DEFAULT 0 ,
	`productDateCreated` DATETIME NOT NULL,
	`productDateUpdated` DATETIME NOT NULL,
	`productIsExported` TINYINT NULL,
	`productDateExported` DATETIME NULL,
  PRIMARY KEY (`productID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPrimaryTarget` (
	`primaryTargetID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetTable` VARCHAR(50) NOT NULL DEFAULT '',
	`primaryTargetKey` VARCHAR(50) NOT NULL DEFAULT '',
	`primaryTargetName` VARCHAR(100) NOT NULL DEFAULT '',
	`primaryTargetStatus` TINYINT NOT NULL DEFAULT 0 ,
	`primaryTargetDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`primaryTargetDateCreated` DATETIME NOT NULL,
	`primaryTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`primaryTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPriceTarget` (
	`priceTargetID` INT NOT NULL AUTO_INCREMENT ,
	`priceID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`priceTargetStatus` TINYINT NOT NULL DEFAULT 0 ,
	`priceTargetOrder` INT NOT NULL DEFAULT 0 ,
	`priceTargetDateCreated` DATETIME NOT NULL,
	`priceTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`priceTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPrice` (
	`priceID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`categoryID` INT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`priceAppliesToCategory` TINYINT NOT NULL DEFAULT 0 ,
	`priceAppliesToCategoryChildren` TINYINT NOT NULL DEFAULT 0 ,
	`priceAppliesToProduct` TINYINT NOT NULL DEFAULT 0 ,
	`priceAppliesToProductChildren` TINYINT NOT NULL DEFAULT 0 ,
	`priceAppliesToAllProducts` TINYINT NOT NULL DEFAULT 0 ,
	`priceAppliesToAllCustomers` TINYINT NOT NULL DEFAULT 0 ,
	`priceAppliesToInvoice` TINYINT NOT NULL DEFAULT 0 ,
	`priceCode` VARCHAR(25) NOT NULL DEFAULT '',
	`priceCodeRequired` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`priceStatus` TINYINT NOT NULL DEFAULT 0 ,
	`priceApproved` TINYINT NOT NULL DEFAULT 0 ,
	`priceDateApproved` DATETIME NULL,
	`userID_approved` INT NOT NULL DEFAULT 0 ,
	`priceName` VARCHAR(100) NOT NULL DEFAULT '',
	`priceDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`priceQuantityMinimumPerOrder` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`priceAppliedStatus` TINYINT NOT NULL DEFAULT 0 ,
	`priceQuantityMaximumAllCustomers` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`priceQuantityMaximumPerCustomer` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`priceBillingMethod` VARCHAR(255) NOT NULL DEFAULT '',
	`priceDateBegin` DATETIME NOT NULL,
	`priceDateEnd` DATETIME NULL,
	`priceID_parent` INT NOT NULL DEFAULT 0 ,
	`priceID_trend` INT NOT NULL DEFAULT 0 ,
	`priceIsParent` TINYINT NOT NULL DEFAULT 0 ,
	`priceHasMultipleStages` TINYINT NOT NULL DEFAULT 0 ,
	`priceSubscriptionUpdateExisting` TINYINT NOT NULL DEFAULT 0 ,
	`priceSubscriptionUpdateRenewal` TINYINT NOT NULL DEFAULT 0 ,
	`priceID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`priceDateCreated` DATETIME NOT NULL,
	`priceDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`priceID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPhone` (
	`phoneID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`phoneID_parent` INT NOT NULL DEFAULT 0 ,
	`phoneID_trend` INT NOT NULL DEFAULT 0 ,
	`phoneVersion` SMALLINT NOT NULL DEFAULT 0 ,
	`phoneAreaCode` VARCHAR(5) NOT NULL DEFAULT '',
	`phoneNumber` VARCHAR(10) NOT NULL DEFAULT '',
	`phoneExtension` VARCHAR(5) NOT NULL DEFAULT '',
	`phoneStatus` TINYINT NOT NULL DEFAULT 0 ,
	`phoneType` VARCHAR(25) NOT NULL DEFAULT '',
	`phoneDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`phoneDateCreated` DATETIME NOT NULL,
	`phoneDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`phoneID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPermissionTarget` (
	`permissionTargetID` INT NOT NULL AUTO_INCREMENT ,
	`permissionCategoryID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`permissionTargetOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`permissionTargetBinaryTotal` INT NOT NULL DEFAULT 0 ,
	`permissionTargetStatus` TINYINT NULL,
	`permissionTargetDateCreated` DATETIME NULL,
	`permissionTargetDateUpdated` DATETIME NULL,
  PRIMARY KEY (`permissionTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPermissionCategory` (
	`permissionCategoryID` INT NOT NULL AUTO_INCREMENT ,
	`permissionCategoryName` VARCHAR(100) NOT NULL DEFAULT '',
	`permissionCategoryTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`permissionCategoryOrder` TINYINT NOT NULL DEFAULT 0 ,
	`permissionCategoryDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`permissionCategoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`permissionCategoryDateCreated` DATETIME NOT NULL,
	`permissionCategoryDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`permissionCategoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPermission` (
	`permissionID` INT NOT NULL AUTO_INCREMENT ,
	`permissionCategoryID` INT NOT NULL DEFAULT 0 ,
	`permissionBinaryNumber` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`permissionName` VARCHAR(100) NOT NULL DEFAULT '',
	`permissionTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`permissionDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`permissionOrder` TINYINT NOT NULL DEFAULT 0 ,
	`permissionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`permissionSuperuserOnly` TINYINT NOT NULL DEFAULT 0 ,
	`permissionDateCreated` DATETIME NOT NULL,
	`permissionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`permissionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPaymentCategory` (
	`paymentCategoryID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`paymentCategoryName` VARCHAR(100) NOT NULL DEFAULT '',
	`paymentCategoryTitle` VARCHAR(255) NOT NULL DEFAULT '',
	`paymentCategoryID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`paymentCategoryOrder` TINYINT NOT NULL DEFAULT 0 ,
	`paymentCategoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`paymentCategoryCreatedViaSetup` TINYINT NOT NULL DEFAULT 0 ,
	`paymentCategoryType` VARCHAR(10) NOT NULL DEFAULT '',
	`paymentCategoryAutoMethod` VARCHAR(255) NOT NULL DEFAULT '',
	`userID` INT NOT NULL DEFAULT 0 ,
	`paymentCategoryDateCreated` DATETIME NOT NULL,
	`paymentCategoryDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`paymentCategoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPayflowTarget` (
	`payflowTargetID` INT NOT NULL AUTO_INCREMENT ,
	`payflowID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`payflowTargetStatus` TINYINT NOT NULL DEFAULT 0 ,
	`payflowTargetDateBegin` DATETIME NOT NULL,
	`payflowTargetDateEnd` DATETIME NULL,
	`payflowTargetDateCreated` DATETIME NOT NULL,
	`payflowTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`payflowTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPayflowNotify` (
	`payflowNotifyID` INT NOT NULL AUTO_INCREMENT ,
	`payflowID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`payflowNotifyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`payflowNotifyType` VARCHAR(50) NOT NULL DEFAULT '',
	`payflowNotifyTask` TINYINT NOT NULL DEFAULT 0 ,
	`payflowNotifyEmail` TINYINT NOT NULL DEFAULT 0 ,
	`payflowNotifyDateCreated` DATETIME NOT NULL,
	`payflowNotifyDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`payflowNotifyID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPayflowInvoice` (
	`payflowInvoiceID` INT NOT NULL AUTO_INCREMENT ,
	`payflowID` INT NOT NULL DEFAULT 0 ,
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`payflowInvoiceStatus` TINYINT NOT NULL DEFAULT 0 ,
	`payflowInvoiceCompleted` TINYINT NOT NULL DEFAULT 0 ,
	`payflowInvoiceManual` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`payflowInvoiceDateCreated` DATETIME NOT NULL,
	`payflowInvoiceDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`payflowInvoiceID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPayflow` (
	`payflowID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`payflowName` VARCHAR(100) NOT NULL DEFAULT '',
	`payflowID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`payflowDefault` TINYINT NOT NULL DEFAULT 0 ,
	`payflowStatus` TINYINT NOT NULL DEFAULT 0 ,
	`payflowInvoiceSend` TINYINT NOT NULL DEFAULT 0 ,
	`payflowReceiptSend` TINYINT NOT NULL DEFAULT 0 ,
	`payflowInvoiceDaysFromSubscriberDate` TINYINT NOT NULL DEFAULT 0 ,
	`payflowChargeDaysFromSubscriberDate` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectNotifyCustomer` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectNotifyAdmin` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectRescheduleDays` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectMaximum_company` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectMaximum_invoice` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectMaximum_subscriber` TINYINT NOT NULL DEFAULT 0 ,
	`payflowRejectTask` TINYINT NOT NULL DEFAULT 0 ,
	`payflowOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`payflowDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`templateID` INT NOT NULL DEFAULT 0 ,
	`payflowEmailFromName` VARCHAR(100) NOT NULL DEFAULT '',
	`payflowEmailReplyTo` VARCHAR(100) NOT NULL DEFAULT '',
	`payflowEmailSubject` VARCHAR(100) NOT NULL DEFAULT '',
	`payflowEmailCC` VARCHAR(255) NOT NULL DEFAULT '',
	`payflowEmailBCC` VARCHAR(255) NOT NULL DEFAULT '',
	`payflowDateCreated` DATETIME NOT NULL,
	`payflowDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`payflowID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avNote` (
	`noteID` INT NOT NULL AUTO_INCREMENT ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_target` INT NOT NULL DEFAULT 0 ,
	`companyID_target` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`noteMessage` TEXT NOT NULL ,
	`noteStatus` TINYINT NOT NULL DEFAULT 0 ,
	`noteDateCreated` DATETIME NOT NULL,
	`noteDateUpdated` DATETIME NOT NULL,
	`primaryTargetID_partner` INT NOT NULL DEFAULT 0 ,
	`targetID_partner` INT NOT NULL DEFAULT 0 ,
	`userID_partner` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`noteID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avMerchantAccount` (
	`merchantAccountID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`merchantID` INT NOT NULL DEFAULT 0 ,
	`merchantAccountUsername` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantAccountPassword` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantAccountID_custom` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantAccountStatus` TINYINT NOT NULL DEFAULT 0 ,
	`merchantAccountBank` TINYINT NOT NULL DEFAULT 0 ,
	`merchantAccountCreditCard` TINYINT NOT NULL DEFAULT 0 ,
	`merchantAccountDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`merchantAccountDateCreated` DATETIME NOT NULL,
	`merchantAccountDateUpdated` DATETIME NOT NULL,
	`merchantAccountName` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantAccountCreditCardTypeList` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`merchantAccountID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avMerchant` (
	`merchantID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`merchantName` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantURL` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`merchantBank` TINYINT NOT NULL DEFAULT 0 ,
	`merchantCreditCard` TINYINT NOT NULL DEFAULT 0 ,
	`merchantFilename` VARCHAR(100) NOT NULL DEFAULT '',
	`merchantStatus` TINYINT NOT NULL DEFAULT 0 ,
	`merchantRequiredFields` VARCHAR(255) NOT NULL DEFAULT '',
	`merchantDateCreated` DATETIME NOT NULL,
	`merchantDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`merchantID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avIPaddress` (
	`IPaddressID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`IPaddress` VARCHAR(25) NOT NULL DEFAULT '',
	`IPaddress_max` VARCHAR(25) NOT NULL DEFAULT '',
	`IPaddressBrowser` TINYINT NOT NULL DEFAULT 0 ,
	`IPaddressWebService` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`IPaddressDateCreated` DATETIME NOT NULL,
	`IPaddressDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`IPaddressID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoiceSent` (
	`invoiceSentID` INT NOT NULL AUTO_INCREMENT ,
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`invoiceSentDate` DATETIME NOT NULL,
	`invoiceSentEmail` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceSentFax` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceSentPostage` TINYINT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_target` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`invoiceSentID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoicePaymentCredit` (
	`invoicePaymentCreditID` INT NOT NULL AUTO_INCREMENT ,
	`paymentCreditID` INT NOT NULL DEFAULT 0 ,
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`invoicePaymentCreditManual` TINYINT NOT NULL DEFAULT 0 ,
	`invoicePaymentCreditDate` DATETIME NOT NULL,
	`invoicePaymentCreditAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoicePaymentCreditText` VARCHAR(510) NOT NULL DEFAULT '',
	`invoicePaymentCreditRolloverPrevious` TINYINT NOT NULL DEFAULT 0 ,
	`invoicePaymentCreditRolloverNext` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`invoicePaymentCreditID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoicePayment` (
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`paymentID` INT NOT NULL DEFAULT 0 ,
	`invoicePaymentManual` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`invoicePaymentDate` DATETIME NOT NULL,
	`invoicePaymentAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`invoiceID`, `paymentID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoiceLineItemUser` (
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`invoiceLineItemID`, `userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avImage` (
	`imageID` INT NOT NULL AUTO_INCREMENT ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`imageURL` VARCHAR(255) NOT NULL DEFAULT '',
	`imageAlt` VARCHAR(100) NOT NULL DEFAULT '',
	`imageHeight` SMALLINT NOT NULL DEFAULT 0 ,
	`imageWidth` SMALLINT NOT NULL DEFAULT 0 ,
	`imageBorder` TINYINT NOT NULL DEFAULT 0 ,
	`imageSize` SMALLINT NOT NULL DEFAULT 0 ,
	`imageOther` VARCHAR(100) NOT NULL DEFAULT '',
	`imageTag` VARCHAR(600) NOT NULL DEFAULT '',
	`imageStatus` TINYINT NOT NULL DEFAULT 0 ,
	`imageOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`imageHasThumbnail` TINYINT NOT NULL DEFAULT 0 ,
	`imageIsThumbnail` TINYINT NOT NULL DEFAULT 0 ,
	`imageID_parent` INT NOT NULL DEFAULT 0 ,
	`imageUploaded` TINYINT NOT NULL DEFAULT 0 ,
	`imageDeleted` TINYINT NOT NULL DEFAULT 0 ,
	`imageDisplayCategory` TINYINT NOT NULL DEFAULT 0 ,
	`imageDateCreated` DATETIME NOT NULL,
	`imageDateUpdated` DATETIME NOT NULL,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`imageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avHeaderFooter` (
	`headerFooterID` INT NOT NULL AUTO_INCREMENT ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`headerFooterStatus` TINYINT NOT NULL DEFAULT 0 ,
	`headerFooterText` TEXT NOT NULL ,
	`headerFooterHtml` TINYINT NOT NULL DEFAULT 0 ,
	`headerFooterIndicator` TINYINT NOT NULL DEFAULT 0 ,
	`headerFooterDateCreated` DATETIME NOT NULL,
	`headerFooterDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`headerFooterID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avGroupTarget` (
	`groupTargetID` INT NOT NULL AUTO_INCREMENT ,
	`groupID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`groupTargetStatus` TINYINT NOT NULL DEFAULT 0 ,
	`groupTargetDateCreated` DATETIME NOT NULL,
	`groupTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`groupTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avGroup` (
	`groupID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`groupName` VARCHAR(100) NOT NULL DEFAULT '',
	`groupCategory` VARCHAR(50) NOT NULL DEFAULT '',
	`groupDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`groupStatus` TINYINT NOT NULL DEFAULT 0 ,
	`groupID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`groupDateCreated` DATETIME NOT NULL,
	`groupDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`groupID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avFieldArchive` (
	`fieldArchiveID` INT NOT NULL AUTO_INCREMENT ,
	`fieldArchiveTableName` VARCHAR(50) NOT NULL DEFAULT '',
	`fieldArchiveFieldName` VARCHAR(50) NOT NULL DEFAULT '',
	`fieldArchiveValue` VARCHAR(255) NOT NULL DEFAULT '',
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`fieldArchiveDate` DATETIME NOT NULL,
  PRIMARY KEY (`fieldArchiveID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avExportTableFieldCompany` (
	`exportTableFieldID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`exportTableFieldCompanyXmlName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldCompanyTabName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldCompanyHtmlName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportTableFieldCompanyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`exportTableFieldID`, `companyID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avExportQueryFieldCompany` (
	`exportQueryFieldID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`exportQueryFieldCompanyOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`exportQueryFieldCompanyXmlStatus` TINYINT NOT NULL DEFAULT 0 ,
	`exportQueryFieldCompanyTabStatus` TINYINT NOT NULL DEFAULT 0 ,
	`exportQueryFieldCompanyHtmlStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`exportQueryFieldID`, `companyID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldVarchar` (
	`customFieldVarcharID` INT NOT NULL AUTO_INCREMENT ,
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionID` INT NOT NULL DEFAULT 0 ,
	`customFieldVarcharStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldVarcharValue` VARCHAR(2000) NOT NULL DEFAULT '',
	`customFieldVarcharDateCreated` DATETIME NOT NULL,
	`customFieldVarcharDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldVarcharID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldTarget` (
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`customFieldTargetStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`customFieldTargetOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`customFieldTargetDateCreated` DATETIME NOT NULL,
	`customFieldTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldID`, `primaryTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldOption` (
	`customFieldOptionID` INT NOT NULL AUTO_INCREMENT ,
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionLabel` VARCHAR(100) NOT NULL DEFAULT '',
	`customFieldOptionValue` VARCHAR(100) NOT NULL DEFAULT '',
	`customFieldOptionOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`customFieldOptionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldOptionVersion` SMALLINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionDateCreated` DATETIME NOT NULL,
	`customFieldOptionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldOptionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldInt` (
	`customFieldIntID` INT NOT NULL AUTO_INCREMENT ,
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionID` INT NOT NULL DEFAULT 0 ,
	`customFieldIntStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldIntValue` INT NULL,
	`customFieldIntDateCreated` DATETIME NOT NULL,
	`customFieldIntDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldIntID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldDecimal` (
	`customFieldDecimalID` INT NOT NULL AUTO_INCREMENT ,
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionID` INT NOT NULL DEFAULT 0 ,
	`customFieldDecimalStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldDecimalValue` DECIMAL(18,4) NULL ,
	`customFieldDecimalDateCreated` DATETIME NOT NULL,
	`customFieldDecimalDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldDecimalID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldDateTime` (
	`customFieldDateTimeID` INT NOT NULL AUTO_INCREMENT ,
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionID` INT NOT NULL DEFAULT 0 ,
	`customFieldDateTimeStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldDateTimeValue` DATETIME NULL,
	`customFieldDateTimeDateCreated` DATETIME NOT NULL,
	`customFieldDateTimeDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldDateTimeID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomFieldBit` (
	`customFieldBitID` INT NOT NULL AUTO_INCREMENT ,
	`customFieldID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`customFieldOptionID` INT NOT NULL DEFAULT 0 ,
	`customFieldBitStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldBitValue` TINYINT NULL,
	`customFieldBitDateCreated` DATETIME NOT NULL,
	`customFieldBitDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`customFieldBitID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCustomField` (
	`customFieldID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`customFieldName` VARCHAR(100) NOT NULL DEFAULT '',
	`customFieldTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`customFieldDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`customFieldType` VARCHAR(50) NOT NULL DEFAULT '',
	`customFieldFormType` VARCHAR(40) NOT NULL DEFAULT '',
	`customFieldStatus` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldExportXml` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldExportTab` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldExportHtml` TINYINT NOT NULL DEFAULT 0 ,
	`customFieldDateCreated` DATETIME NOT NULL,
	`customFieldDateUpdated` DATETIME NOT NULL,
	`customFieldInternal` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`customFieldID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCreditCard` (
	`creditCardID` INT NOT NULL AUTO_INCREMENT ,
	`addressID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`creditCardName` VARCHAR(100) NOT NULL DEFAULT '',
	`creditCardNumber` VARCHAR(100) NOT NULL DEFAULT '',
	`creditCardExpirationMonth` CHAR(2) NOT NULL DEFAULT '',
	`creditCardExpirationYear` CHAR(4) NOT NULL DEFAULT '',
	`creditCardType` VARCHAR(50) NOT NULL DEFAULT '',
	`creditCardCVC` VARCHAR(15) NOT NULL DEFAULT '',
	`creditCardStatus` TINYINT NOT NULL DEFAULT 0 ,
	`creditCardRetain` TINYINT NOT NULL DEFAULT 0 ,
	`creditCardDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`creditCardDateCreated` DATETIME NOT NULL,
	`creditCardDateUpdated` DATETIME NOT NULL,
	`creditCardCVCstatus` TINYINT NULL,
  PRIMARY KEY (`creditCardID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avContentCategory` (
	`contentCategoryID` INT NOT NULL AUTO_INCREMENT ,
	`contentCategoryName` VARCHAR(100) NOT NULL DEFAULT '',
	`contentCategoryCode` VARCHAR(50) NOT NULL DEFAULT '',
	`contentCategoryDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`contentCategoryOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`contentCategoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`contentCategoryDateCreated` DATETIME NOT NULL,
	`contentCategoryDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`contentCategoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avContent` (
	`contentID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`contentName` VARCHAR(100) NOT NULL DEFAULT '',
	`contentDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`contentCode` VARCHAR(50) NOT NULL DEFAULT '',
	`contentCategoryID` INT NOT NULL DEFAULT 0 ,
	`contentType` VARCHAR(25) NOT NULL DEFAULT '',
	`contentOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`contentMaxlength` SMALLINT NOT NULL DEFAULT 0 ,
	`contentHtmlOk` TINYINT NOT NULL DEFAULT 0 ,
	`contentRequired` TINYINT NOT NULL DEFAULT 0 ,
	`contentStatus` TINYINT NOT NULL DEFAULT 0 ,
	`contentFilename` VARCHAR(50) NOT NULL DEFAULT '',
	`contentDateCreated` DATETIME NOT NULL,
	`contentDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`contentID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avContact` (
	`contactID` INT NOT NULL AUTO_INCREMENT ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`companyID_target` INT NOT NULL DEFAULT 0 ,
	`userID_target` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`contactSubject` VARCHAR(100) NOT NULL DEFAULT '',
	`contactMessage` TEXT NOT NULL ,
	`contactHtml` TINYINT NOT NULL DEFAULT 0 ,
	`contactFax` TINYINT NOT NULL DEFAULT 0 ,
	`contactEmail` TINYINT NOT NULL DEFAULT 0 ,
	`contactByCustomer` TINYINT NOT NULL DEFAULT 0 ,
	`contactFromName` VARCHAR(100) NOT NULL DEFAULT '',
	`contactReplyTo` VARCHAR(100) NOT NULL DEFAULT '',
	`contactTo` VARCHAR(255) NOT NULL DEFAULT '',
	`contactCC` VARCHAR(255) NOT NULL DEFAULT '',
	`contactBCC` VARCHAR(255) NOT NULL DEFAULT '',
	`contactTopicID` INT NOT NULL DEFAULT 0 ,
	`contactTemplateID` INT NOT NULL DEFAULT 0 ,
	`contactID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`contactID_orig` INT NOT NULL DEFAULT 0 ,
	`contactReplied` TINYINT NOT NULL DEFAULT 0 ,
	`contactStatus` TINYINT NOT NULL DEFAULT 0 ,
	`contactDateSent` DATETIME NULL,
	`contactDateCreated` DATETIME NOT NULL,
	`contactDateUpdated` DATETIME NOT NULL,
	`primaryTargetID_partner` INT NOT NULL DEFAULT 0 ,
	`targetID_partner` INT NOT NULL DEFAULT 0 ,
	`userID_partner` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`contactID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionProduct` (
	`commissionProductID` INT NOT NULL AUTO_INCREMENT ,
	`commissionID` INT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`commissionProductChildren` TINYINT NOT NULL DEFAULT 0 ,
	`commissionProductStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`commissionProductDateCreated` DATETIME NOT NULL,
	`commissionProductDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`commissionProductID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionCustomerUser` (
	`commissionCustomerID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`commissionCustomerID`, `userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionCustomer` (
	`commissionCustomerID` INT NOT NULL AUTO_INCREMENT ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`commissionCustomerAllUsers` TINYINT NOT NULL DEFAULT 0 ,
	`commissionCustomerAllSubscribers` TINYINT NOT NULL DEFAULT 0 ,
	`commissionCustomerPercent` DECIMAL(5,4) NOT NULL DEFAULT 0,
	`commissionCustomerDateBegin` DATETIME NOT NULL,
	`commissionCustomerDateEnd` DATETIME NULL,
	`commissionCustomerStatus` TINYINT NOT NULL DEFAULT 0 ,
	`commissionCustomerPrimary` TINYINT NOT NULL DEFAULT 0 ,
	`commissionCustomerDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`commissionCustomerDateCreated` DATETIME NOT NULL,
	`commissionCustomerDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`commissionCustomerID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionCategory` (
	`commissionCategoryID` INT NOT NULL AUTO_INCREMENT ,
	`commissionID` INT NOT NULL DEFAULT 0 ,
	`categoryID` INT NOT NULL DEFAULT 0 ,
	`commissionCategoryChildren` TINYINT NOT NULL DEFAULT 0 ,
	`commissionCategoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`commissionCategoryDateCreated` DATETIME NOT NULL,
	`commissionCategoryDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`commissionCategoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommission` (
	`commissionID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`commissionName` VARCHAR(50) NOT NULL DEFAULT '',
	`commissionID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`commissionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`commissionAppliesToExistingProducts` TINYINT NOT NULL DEFAULT 0 ,
	`commissionAppliesToCustomProducts` TINYINT NOT NULL DEFAULT 0 ,
	`commissionAppliesToInvoice` TINYINT NOT NULL DEFAULT 0 ,
	`commissionAppliedStatus` TINYINT NOT NULL DEFAULT 0 ,
	`commissionDateBegin` DATETIME NOT NULL,
	`commissionDateEnd` DATETIME NULL,
	`commissionID_parent` INT NOT NULL DEFAULT 0 ,
	`commissionID_trend` INT NOT NULL DEFAULT 0 ,
	`commissionIsParent` TINYINT NOT NULL DEFAULT 0 ,
	`commissionHasMultipleStages` TINYINT NOT NULL DEFAULT 0 ,
	`commissionDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`commissionPeriodOrInvoiceBased` TINYINT NOT NULL DEFAULT 0 ,
	`commissionPeriodIntervalType` VARCHAR(5) NOT NULL DEFAULT '',
	`commissionDateCreated` DATETIME NOT NULL,
	`commissionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`commissionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCategory` (
	`categoryID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`categoryCode` VARCHAR(50) NOT NULL DEFAULT '',
	`categoryName` VARCHAR(255) NOT NULL DEFAULT '',
	`categoryDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`categoryTitle` VARCHAR(255) NOT NULL DEFAULT '',
	`categoryOrder` INT NOT NULL DEFAULT 0 ,
	`categoryOrder_manual` INT NOT NULL DEFAULT 0 ,
	`categoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`categoryID_parent` INT NOT NULL DEFAULT 0 ,
	`categoryID_parentList` VARCHAR(500) NOT NULL DEFAULT '',
	`categoryLevel` TINYINT NOT NULL DEFAULT 0 ,
	`categoryHasChildren` TINYINT NOT NULL DEFAULT 0 ,
	`categoryAcceptListing` TINYINT NOT NULL DEFAULT 0 ,
	`categoryIsListed` TINYINT NOT NULL DEFAULT 0 ,
	`categoryHasCustomPrice` TINYINT NOT NULL DEFAULT 0 ,
	`categoryViewCount` INT NOT NULL DEFAULT 0 ,
	`categoryItemsPerPage` INT NOT NULL DEFAULT 0 ,
	`categoryNumberOfPages` INT NOT NULL DEFAULT 0 ,
	`headerFooterID_header` INT NOT NULL DEFAULT 0 ,
	`headerFooterID_footer` INT NOT NULL DEFAULT 0 ,
	`templateFilename` VARCHAR(50) NOT NULL DEFAULT '',
	`categoryDateCreated` DATETIME NOT NULL,
	`categoryDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`categoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avBank` (
	`bankID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`bankName` VARCHAR(255) NOT NULL DEFAULT '',
	`bankBranch` VARCHAR(255) NOT NULL DEFAULT '',
	`bankBranchCity` VARCHAR(50) NOT NULL DEFAULT '',
	`bankBranchState` VARCHAR(50) NOT NULL DEFAULT '',
	`bankBranchCountry` VARCHAR(100) NOT NULL DEFAULT '',
	`bankBranchContactName` VARCHAR(100) NOT NULL DEFAULT '',
	`bankBranchPhone` VARCHAR(25) NOT NULL DEFAULT '',
	`bankBranchFax` VARCHAR(25) NOT NULL DEFAULT '',
	`bankRoutingNumber` VARCHAR(100) NOT NULL DEFAULT '',
	`bankAccountNumber` VARCHAR(100) NOT NULL DEFAULT '',
	`bankAccountName` VARCHAR(100) NOT NULL DEFAULT '',
	`bankCheckingOrSavings` TINYINT NULL,
	`bankPersonalOrCorporate` TINYINT NOT NULL DEFAULT 0 ,
	`bankDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`bankAccountType` VARCHAR(50) NOT NULL DEFAULT '',
	`bankStatus` TINYINT NOT NULL DEFAULT 0 ,
	`bankRetain` TINYINT NOT NULL DEFAULT 0 ,
	`addressID` INT NOT NULL DEFAULT 0 ,
	`bankDateCreated` DATETIME NOT NULL,
	`bankDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`bankID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avAffiliate` (
	`affiliateID` INT NOT NULL AUTO_INCREMENT ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`affiliateCode` VARCHAR(25) NOT NULL DEFAULT '',
	`affiliateName` VARCHAR(255) NOT NULL DEFAULT '',
	`affiliateURL` VARCHAR(100) NOT NULL DEFAULT '',
	`affiliateStatus` TINYINT NOT NULL DEFAULT 0 ,
	`affiliateID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`affiliateDateCreated` DATETIME NOT NULL,
	`affiliateDateUpdated` DATETIME NOT NULL,
	`affiliateIsExported` TINYINT NULL,
	`affiliateDateExported` DATETIME NULL,
  PRIMARY KEY (`affiliateID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avAddress` (
	`addressID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`addressID_parent` INT NOT NULL DEFAULT 0 ,
	`addressID_trend` INT NOT NULL DEFAULT 0 ,
	`addressName` VARCHAR(100) NOT NULL DEFAULT '',
	`addressDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`addressTypeShipping` TINYINT NOT NULL DEFAULT 0 ,
	`addressTypeBilling` TINYINT NOT NULL DEFAULT 0 ,
	`address` VARCHAR(100) NOT NULL DEFAULT '',
	`address2` VARCHAR(100) NOT NULL DEFAULT '',
	`address3` VARCHAR(100) NOT NULL DEFAULT '',
	`city` VARCHAR(50) NOT NULL DEFAULT '',
	`state` VARCHAR(50) NOT NULL DEFAULT '',
	`zipCode` VARCHAR(15) NOT NULL DEFAULT '',
	`zipCodePlus4` VARCHAR(4) NOT NULL DEFAULT '',
	`county` VARCHAR(100) NOT NULL DEFAULT '',
	`country` VARCHAR(100) NOT NULL DEFAULT '',
	`regionID` INT NOT NULL DEFAULT 0 ,
	`addressStatus` TINYINT NOT NULL DEFAULT 0 ,
	`addressVersion` SMALLINT NOT NULL DEFAULT 0 ,
	`addressDateCreated` DATETIME NOT NULL,
	`addressDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`addressID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avTriggerAction` (
	`triggerAction` VARCHAR(50) NOT NULL DEFAULT '',
	`userID` INT NOT NULL DEFAULT 0 ,
	`triggerActionControl` VARCHAR(50) NOT NULL DEFAULT '',
	`triggerActionDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`triggerActionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`triggerActionOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`triggerActionSuperuserOnly` TINYINT NOT NULL DEFAULT 0 ,
	`triggerActionDateCreated` DATETIME NOT NULL,
	`triggerActionDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`triggerAction`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avTrigger` (
	`triggerID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`triggerStatus` TINYINT NOT NULL DEFAULT 0 ,
	`triggerAction` VARCHAR(50) NOT NULL DEFAULT '',
	`triggerDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`triggerFilename` VARCHAR(50) NOT NULL DEFAULT '',
	`triggerDateBegin` DATETIME NOT NULL,
	`triggerDateEnd` DATETIME NULL,
	`triggerDateCreated` DATETIME NOT NULL,
	`triggerDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`triggerID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avTask` (
	`taskID` INT NOT NULL AUTO_INCREMENT ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_agent` INT NOT NULL DEFAULT 0 ,
	`companyID_agent` INT NOT NULL DEFAULT 0 ,
	`userID_target` INT NOT NULL DEFAULT 0 ,
	`companyID_target` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`taskStatus` TINYINT NOT NULL DEFAULT 0 ,
	`taskCompleted` TINYINT NOT NULL DEFAULT 0 ,
	`taskMessage` VARCHAR(1000) NOT NULL DEFAULT '',
	`taskDateScheduled` DATETIME NOT NULL,
	`taskDateCreated` DATETIME NOT NULL,
	`taskDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`taskID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriptionUser` (
	`subscriptionID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`subscriptionID`, `userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriptionParameter` (
	`subscriptionID` INT NOT NULL DEFAULT 0 ,
	`productParameterOptionID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`subscriptionID`, `productParameterOptionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPaymentRefundProduct` (
	`paymentID` INT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`subscriptionID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`paymentID`, `productID`, `subscriptionID`, `invoiceLineItemID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPaymentCreditProduct` (
	`paymentCreditID` INT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`subscriptionID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`paymentCreditID`, `productID`, `subscriptionID`, `invoiceLineItemID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoiceLineItem` (
	`invoiceLineItemID` INT NOT NULL AUTO_INCREMENT ,
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemName` VARCHAR(510) NOT NULL DEFAULT '',
	`invoiceLineItemDescription` VARCHAR(2000) NOT NULL DEFAULT '',
	`invoiceLineItemDescriptionHtml` TINYINT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`priceID` INT NOT NULL DEFAULT 0 ,
	`categoryID` INT NOT NULL DEFAULT 0 ,
	`regionID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemQuantity` DECIMAL(14,4) NOT NULL DEFAULT 0 ,
	`invoiceLineItemPriceUnit` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceLineItemSubTotal` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceLineItemDiscount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceLineItemTotal` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceLineItemPriceNormal` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceLineItemProductID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`invoiceLineItemTotalTax` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceLineItemOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`invoiceLineItemStatus` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceLineItemProductIsBundle` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceLineItemProductInBundle` TINYINT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemManual` TINYINT NOT NULL DEFAULT 0 ,
	`productParameterExceptionID` INT NOT NULL DEFAULT 0 ,
	`userID_cancel` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID_parent` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID_trend` INT NOT NULL DEFAULT 0 ,
	`subscriptionID` INT NOT NULL DEFAULT 0 ,
	`priceStageID` INT NOT NULL DEFAULT 0 ,
	`priceVolumeDiscountID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemDateBegin` DATETIME NULL,
	`invoiceLineItemDateEnd` DATETIME NULL,
	`invoiceLineItemDateCreated` DATETIME NOT NULL,
	`invoiceLineItemDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`invoiceLineItemID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriptionProcess` (
	`subscriberProcessID` INT NOT NULL DEFAULT 0 ,
	`subscriptionID` INT NOT NULL DEFAULT 0 ,
	`priceStageID` INT NOT NULL DEFAULT 0 ,
	`subscriptionProcessQuantity` DECIMAL(10,4) NULL,
	`subscriptionProcessQuantityFinal` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionProcessDateBegin` DATETIME NULL,
	`subscriptionProcessDateEnd` DATETIME NULL,
  PRIMARY KEY (`subscriberProcessID`, `subscriptionID`, `priceStageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscription` (
	`subscriptionID` INT NOT NULL AUTO_INCREMENT ,
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_cancel` INT NOT NULL DEFAULT 0 ,
	`subscriptionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionCompleted` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionDateBegin` DATETIME NOT NULL,
	`subscriptionDateEnd` DATETIME NULL,
	`subscriptionContinuesAfterEnd` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionEndByDateOrAppliedMaximum` TINYINT NULL,
	`subscriptionAppliedMaximum` SMALLINT NOT NULL DEFAULT 0 ,
	`subscriptionAppliedCount` SMALLINT NOT NULL DEFAULT 0 ,
	`subscriptionIntervalType` VARCHAR(5) NOT NULL DEFAULT '',
	`subscriptionInterval` SMALLINT NOT NULL DEFAULT 0 ,
	`subscriptionID_parent` INT NOT NULL DEFAULT 0 ,
	`subscriptionID_trend` INT NOT NULL DEFAULT 0 ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`priceID` INT NOT NULL DEFAULT 0 ,
	`priceStageID` INT NOT NULL DEFAULT 0 ,
	`regionID` INT NOT NULL DEFAULT 0 ,
	`categoryID` INT NOT NULL DEFAULT 0 ,
	`subscriptionProductID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`productParameterExceptionID` INT NOT NULL DEFAULT 0 ,
	`subscriptionQuantity` DECIMAL(13, 2) NOT NULL DEFAULT 0,
	`subscriptionQuantityVaries` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`subscriptionName` VARCHAR(510) NOT NULL DEFAULT '',
	`subscriptionDescription` VARCHAR(2000) NOT NULL DEFAULT '',
	`subscriptionDescriptionHtml` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionPriceNormal` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`subscriptionPriceUnit` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`subscriptionDiscount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`subscriptionDateProcessNext` DATETIME NULL,
	`subscriptionDateProcessLast` DATETIME NULL,
	`subscriptionProRate` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`subscriptionIsRollup` TINYINT NOT NULL DEFAULT 0 ,
	`subscriptionID_rollup` INT NOT NULL DEFAULT 0 ,
	`subscriptionDateCreated` DATETIME NOT NULL,
	`subscriptionDateUpdated` DATETIME NOT NULL,
	`subscriptionCategoryMultiple` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`subscriptionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriberProcess` (
	`subscriberProcessID` INT NOT NULL AUTO_INCREMENT ,
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`subscriberProcessDate` DATETIME NOT NULL,
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`subscriberProcessExistingInvoice` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberProcessCurrent` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberProcessStatus` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberProcessAllQuantitiesEntered` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberProcessDateCreated` DATETIME NOT NULL,
	`subscriberProcessDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`subscriberProcessID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriberPayment` (
	`subscriberPaymentID` INT NOT NULL AUTO_INCREMENT ,
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`creditCardID` INT NOT NULL DEFAULT 0 ,
	`bankID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_cancel` INT NOT NULL DEFAULT 0 ,
	`subscriberPaymentStatus` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberPaymentDateCreated` DATETIME NOT NULL,
	`subscriberPaymentDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`subscriberPaymentID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriberNotify` (
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_cancel` INT NOT NULL DEFAULT 0 ,
	`addressID` INT NOT NULL DEFAULT 0 ,
	`subscriberNotifyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberNotifyEmail` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberNotifyEmailHtml` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberNotifyPdf` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberNotifyDoc` TINYINT NOT NULL DEFAULT 0 ,
	`phoneID` INT NOT NULL DEFAULT 0 ,
	`subscriberNotifyDateCreated` DATETIME NOT NULL,
	`subscriberNotifyDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`subscriberID`, `userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPaymentCredit` (
	`paymentCreditID` INT NOT NULL AUTO_INCREMENT ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`paymentCreditStatus` TINYINT NOT NULL DEFAULT 0 ,
	`paymentCreditName` VARCHAR(255) NOT NULL DEFAULT '',
	`paymentCreditDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`paymentCreditDateBegin` DATETIME NULL,
	`paymentCreditDateEnd` DATETIME NULL,
	`paymentCreditAppliedMaximum` SMALLINT NOT NULL DEFAULT 0 ,
	`paymentCreditAppliedCount` SMALLINT NOT NULL DEFAULT 0 ,
	`paymentCreditDateCreated` DATETIME NOT NULL,
	`paymentCreditDateUpdated` DATETIME NOT NULL,
	`paymentCreditID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`paymentCreditAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`paymentCreditRollover` TINYINT NOT NULL DEFAULT 0 ,
	`paymentCategoryID` INT NOT NULL DEFAULT 0 ,
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`paymentCreditCompleted` TINYINT NOT NULL DEFAULT 0 ,
	`paymentCreditIsExported` TINYINT NULL,
	`paymentCreditDateExported` DATETIME NULL,
	`paymentCreditNegativeInvoice` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`paymentCreditID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPayment` (
	`paymentID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`paymentManual` TINYINT NOT NULL DEFAULT 0 ,
	`paymentDateCreated` DATETIME NOT NULL,
	`paymentDateUpdated` DATETIME NOT NULL,
	`creditCardID` INT NOT NULL DEFAULT 0 ,
	`bankID` INT NOT NULL DEFAULT 0 ,
	`merchantAccountID` INT NOT NULL DEFAULT 0 ,
	`paymentCheckNumber` SMALLINT NOT NULL DEFAULT 0 ,
	`paymentID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`paymentStatus` TINYINT NOT NULL DEFAULT 0 ,
	`paymentApproved` TINYINT NULL,
	`paymentAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`paymentDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`paymentMessage` VARCHAR(255) NOT NULL DEFAULT '',
	`paymentProcessed` TINYINT NOT NULL DEFAULT 0 ,
	`paymentMethod` VARCHAR(25) NOT NULL DEFAULT '',
	`paymentDateReceived` DATETIME NOT NULL,
	`paymentDateScheduled` DATETIME NULL,
	`paymentCategoryID` INT NOT NULL DEFAULT 0 ,
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`paymentIsRefund` TINYINT NOT NULL DEFAULT 0 ,
	`paymentID_refund` INT NOT NULL DEFAULT 0 ,
	`subscriberProcessID` INT NOT NULL DEFAULT 0 ,
	`paymentIsExported` TINYINT NULL,
	`paymentDateExported` DATETIME NULL,
	`paymentCreditCardType` VARCHAR(50) NOT NULL DEFAULT '',
	`paymentCreditCardLast4` VARCHAR(40) NOT NULL DEFAULT '',
  PRIMARY KEY (`paymentID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionCustomerSubscriber` (
	`commissionCustomerID` INT NOT NULL DEFAULT 0 ,
	`subscriberID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`commissionCustomerID`, `subscriberID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSubscriber` (
	`subscriberID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userID_cancel` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`subscriberName` VARCHAR(100) NOT NULL DEFAULT '',
	`subscriberStatus` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberCompleted` TINYINT NOT NULL DEFAULT 0 ,
	`subscriberDateProcessNext` DATETIME NULL,
	`subscriberDateProcessLast` DATETIME NULL,
	`subscriberID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`addressID_billing` INT NOT NULL DEFAULT 0 ,
	`addressID_shipping` INT NOT NULL DEFAULT 0 ,
	`subscriberDateCreated` DATETIME NOT NULL,
	`subscriberDateUpdated` DATETIME NOT NULL,
	`subscriberIsExported` TINYINT NULL,
	`subscriberDateExported` DATETIME NULL,
  PRIMARY KEY (`subscriberID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avStatusTarget` (
	`companyID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`statusTargetExportXmlStatus` TINYINT NOT NULL DEFAULT 0 ,
	`statusTargetExportXmlName` VARCHAR(100) NOT NULL DEFAULT '',
	`statusTargetExportTabStatus` TINYINT NOT NULL DEFAULT 0 ,
	`statusTargetExportTabName` VARCHAR(100) NOT NULL DEFAULT '',
	`statusTargetExportHtmlStatus` TINYINT NOT NULL DEFAULT 0 ,
	`statusTargetExportHtmlName` VARCHAR(100) NOT NULL DEFAULT '',
	`userID` INT NOT NULL DEFAULT 0 ,
	`statusTargetDateCreated` DATETIME NOT NULL,
	`statusTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`companyID`, `primaryTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avStatusHistory` (
	`statusHistoryID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`statusHistoryStatus` TINYINT NOT NULL DEFAULT 0 ,
	`statusID` INT NOT NULL DEFAULT 0 ,
	`statusHistoryManual` TINYINT NOT NULL DEFAULT 0 ,
	`statusHistoryComment` VARCHAR(255) NOT NULL DEFAULT '',
	`statusHistoryDateCreated` DATETIME NOT NULL,
	`statusHistoryDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`statusHistoryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avStatus` (
	`statusID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`statusName` VARCHAR(100) NOT NULL DEFAULT '',
	`statusTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`statusDisplayToCustomer` TINYINT NOT NULL DEFAULT 0 ,
	`statusDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`statusOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`statusStatus` TINYINT NOT NULL DEFAULT 0 ,
	`statusID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`statusDateCreated` DATETIME NOT NULL,
	`statusDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`statusID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionTarget` (
	`commissionTargetID` INT NOT NULL AUTO_INCREMENT ,
	`commissionID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`commissionTargetStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`commissionTargetDateCreated` DATETIME NOT NULL,
	`commissionTargetDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`commissionTargetID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionStage` (
	`commissionStageID` INT NOT NULL AUTO_INCREMENT ,
	`commissionID` INT NOT NULL DEFAULT 0 ,
	`commissionStageOrder` TINYINT NOT NULL DEFAULT 0 ,
	`commissionStageAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`commissionStageDollarOrPercent` TINYINT NOT NULL DEFAULT 0 ,
	`commissionStageAmountMinimum` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`commissionStageAmountMaximum` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`commissionStageVolumeDiscount` TINYINT NOT NULL DEFAULT 0 ,
	`commissionStageVolumeDollarOrQuantity` TINYINT NOT NULL DEFAULT 0 ,
	`commissionStageVolumeStep` TINYINT NOT NULL DEFAULT 0 ,
	`commissionStageInterval` SMALLINT NOT NULL DEFAULT 0 ,
	`commissionStageIntervalType` VARCHAR(5) NOT NULL DEFAULT '',
	`commissionStageText` VARCHAR(255) NOT NULL DEFAULT '',
	`commissionStageDescription` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`commissionStageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avUser` (
	`userID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`username` VARCHAR(50) NOT NULL DEFAULT '',
	`password` VARCHAR(255) NOT NULL DEFAULT '',
	`userStatus` TINYINT NOT NULL DEFAULT 0 ,
	`firstName` VARCHAR(50) NOT NULL DEFAULT '',
	`middleName` VARCHAR(50) NOT NULL DEFAULT '',
	`lastName` VARCHAR(50) NOT NULL DEFAULT '',
	`suffix` VARCHAR(10) NOT NULL DEFAULT '',
	`salutation` VARCHAR(10) NOT NULL DEFAULT '',
	`email` VARCHAR(100) NOT NULL DEFAULT '',
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`userID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`jobTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`jobDepartment` VARCHAR(100) NOT NULL DEFAULT '',
	`jobDivision` VARCHAR(100) NOT NULL DEFAULT '',
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`userNewsletterStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userNewsletterHtml` TINYINT NOT NULL DEFAULT 0 ,
	`userDateCreated` DATETIME NOT NULL,
	`userDateUpdated` DATETIME NOT NULL,
	`userIsExported` TINYINT NULL,
	`userDateExported` DATETIME NULL,
	`userEmailVerified` TINYINT NULL,
	`userEmailVerifyCode` VARCHAR(35) NOT NULL DEFAULT '',
	`userEmailDateVerified` DATETIME NULL,
  PRIMARY KEY (`userID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductSpec` (
	`productSpecID` INT NOT NULL AUTO_INCREMENT ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`productSpecName` VARCHAR(100) NOT NULL DEFAULT '',
	`productSpecValue` VARCHAR(100) NOT NULL DEFAULT '',
	`productSpecOrder` TINYINT NOT NULL DEFAULT 0 ,
	`productSpecStatus` TINYINT NOT NULL DEFAULT 0 ,
	`productSpecVersion` SMALLINT NOT NULL DEFAULT 0 ,
	`productSpecHasImage` TINYINT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productSpecDateCreated` DATETIME NOT NULL,
	`productSpecDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productSpecID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avProductLanguage` (
	`productLanguageID` INT NOT NULL AUTO_INCREMENT ,
	`productID` INT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`productLanguageStatus` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`productLanguageName` VARCHAR(510) NOT NULL DEFAULT '',
	`productLanguageLineItemName` VARCHAR(510) NOT NULL DEFAULT '',
	`productLanguageSummary` VARCHAR(2000) NOT NULL DEFAULT '',
	`productLanguageSummaryHtml` TINYINT NOT NULL DEFAULT 0 ,
	`productLanguageLineItemDescription` VARCHAR(2000) NOT NULL DEFAULT '',
	`productLanguageLineItemDescriptionHtml` TINYINT NOT NULL DEFAULT 0 ,
	`productLanguageDescription` TEXT NOT NULL ,
	`productLanguageDescriptionHtml` TINYINT NOT NULL DEFAULT 0 ,
	`productLanguageDateCreated` DATETIME NOT NULL,
	`productLanguageDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`productLanguageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avLanguageCompany` (
	`companyID` INT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`languageCompanyDefault` TINYINT NOT NULL DEFAULT 0 ,
	`languageCompanyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`languageCompanyDateCreated` DATETIME NOT NULL,
	`languageCompanyDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`companyID`, `languageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoice` (
	`invoiceID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`invoiceClosed` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceDateClosed` DATETIME NULL,
	`invoiceSent` TINYINT NOT NULL DEFAULT 0 ,
	`invoicePaid` TINYINT NULL,
	`invoiceDatePaid` DATETIME NULL,
	`invoiceTotal` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceTotalTax` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceTotalLineItem` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceTotalShipping` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceTotalPaymentCredit` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`invoiceShipped` TINYINT NULL,
	`invoiceCompleted` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceDateCompleted` DATETIME NULL,
	`invoiceStatus` TINYINT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceDateDue` DATETIME NULL,
	`invoiceID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`invoiceManual` TINYINT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`regionID` INT NOT NULL DEFAULT 0 ,
	`invoiceShippingMethod` VARCHAR(50) NOT NULL DEFAULT '',
	`addressID_shipping` INT NOT NULL DEFAULT 0 ,
	`addressID_billing` INT NOT NULL DEFAULT 0 ,
	`creditCardID` INT NOT NULL DEFAULT 0 ,
	`bankID` INT NOT NULL DEFAULT 0 ,
	`invoiceInstructions` VARCHAR(1000) NOT NULL DEFAULT '',
	`subscriberID` INT NOT NULL DEFAULT 0 ,
	`invoiceDateCreated` DATETIME NOT NULL,
	`invoiceDateUpdated` DATETIME NOT NULL,
	`invoiceIsExported` TINYINT NULL,
	`invoiceDateExported` DATETIME NULL,
  PRIMARY KEY (`invoiceID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avContentCompany` (
	`contentCompanyID` INT NOT NULL AUTO_INCREMENT ,
	`contentID` INT NOT NULL DEFAULT 0 ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`contentCompanyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`contentCompanyText` VARCHAR(8000) NOT NULL DEFAULT '',
	`contentCompanyHtml` TINYINT NOT NULL DEFAULT 0 ,
	`contentCompanyOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`contentCompanyDateCreated` DATETIME NOT NULL,
	`contentCompanyDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`contentCompanyID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avContactTopic` (
	`contactTopicID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`contactTopicName` VARCHAR(50) NOT NULL DEFAULT '',
	`contactTopicTitle` VARCHAR(50) NOT NULL DEFAULT '',
	`contactTopicOrder` TINYINT NOT NULL DEFAULT 0 ,
	`contactTopicEmail` VARCHAR(255) NOT NULL DEFAULT '',
	`contactTopicStatus` TINYINT NOT NULL DEFAULT 0 ,
	`contactTopicDateCreated` DATETIME NOT NULL,
	`contactTopicDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`contactTopicID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avContactTemplate` (
	`contactTemplateID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`contactTemplateName` VARCHAR(100) NOT NULL DEFAULT '',
	`contactTemplateHtml` TINYINT NOT NULL DEFAULT 0 ,
	`contactTemplateFromName` VARCHAR(100) NOT NULL DEFAULT '',
	`contactTemplateReplyTo` VARCHAR(100) NOT NULL DEFAULT '',
	`contactTemplateCC` VARCHAR(255) NOT NULL DEFAULT '',
	`contactTemplateBCC` VARCHAR(255) NOT NULL DEFAULT '',
	`contactTemplateSubject` VARCHAR(100) NOT NULL DEFAULT '',
	`contactTemplateMessage` TEXT NOT NULL ,
	`contactTemplateOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`contactTemplateStatus` TINYINT NOT NULL DEFAULT 0 ,
	`contactTemplateDateCreated` DATETIME NOT NULL,
	`contactTemplateDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`contactTemplateID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avLanguage` (
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`languageName` VARCHAR(100) NOT NULL DEFAULT '',
	`languageAbbreviation` VARCHAR(50) NOT NULL DEFAULT '',
	`languageDefault` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`languageID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avShippingInvoiceLineItem` (
	`shippingID` INT NOT NULL DEFAULT 0 ,
	`invoiceLineItemID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`shippingID`, `invoiceLineItemID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avPayflowTemplate` (
	`payflowTemplateID` INT NOT NULL AUTO_INCREMENT ,
	`payflowID` INT NOT NULL DEFAULT 0 ,
	`templateID` INT NOT NULL DEFAULT 0 ,
	`payflowTemplateStatus` TINYINT NOT NULL DEFAULT 0 ,
	`payflowTemplateType` VARCHAR(100) NOT NULL DEFAULT '',
	`payflowTemplatePaymentMethod` VARCHAR(100) NOT NULL DEFAULT '',
	`payflowTemplateNotifyMethod` VARCHAR(100) NOT NULL DEFAULT '',
	`userID` INT NOT NULL DEFAULT 0 ,
	`payflowTemplateDateCreated` DATETIME NOT NULL,
	`payflowTemplateDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`payflowTemplateID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avInvoiceTemplate` (
	`invoiceID` INT NOT NULL DEFAULT 0 ,
	`templateID` INT NOT NULL DEFAULT 0 ,
	`invoiceTemplateStatus` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceTemplateManual` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceTemplateDateCreated` DATETIME NOT NULL,
	`invoiceTemplateDateUpdated` DATETIME NOT NULL,
	`invoiceTemplateHtml` TINYINT NOT NULL DEFAULT 0 ,
	`invoiceTemplateText` TEXT NOT NULL ,
	`userID` INT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`invoiceID`, `templateID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avTemplate` (
	`templateID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`templateName` VARCHAR(100) NOT NULL DEFAULT '',
	`templateFilename` VARCHAR(50) NOT NULL DEFAULT '',
	`templateType` VARCHAR(50) NOT NULL DEFAULT '',
	`templateDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`templateStatus` TINYINT NOT NULL DEFAULT 0 ,
	`templateDefault` TINYINT NOT NULL DEFAULT 0 ,
	`templateXml` TEXT NOT NULL ,
	`templateDateCreated` DATETIME NOT NULL,
	`templateDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`templateID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avLoginSession` (
	`loginSessionID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`loginSessionDateBegin` DATETIME NOT NULL,
	`loginSessionDateEnd` DATETIME NULL,
	`loginSessionTimeout` TINYINT NOT NULL DEFAULT 0 ,
	`loginSessionCurrent` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`loginSessionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avLoginAttempt` (
	`loginAttemptID` INT NOT NULL AUTO_INCREMENT ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`loginAttemptUsername` VARCHAR(255) NOT NULL DEFAULT '',
	`loginAttemptCount` SMALLINT NOT NULL DEFAULT 0 ,
	`loginAttemptDateCreated` DATETIME NOT NULL,
	`loginAttemptDateUpdated` DATETIME NOT NULL,
  PRIMARY KEY (`loginAttemptID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avExportQueryField` (
	`exportQueryFieldID` INT NOT NULL AUTO_INCREMENT ,
	`exportQueryID` INT NOT NULL DEFAULT 0 ,
	`exportTableFieldID` INT NOT NULL DEFAULT 0 ,
	`exportQueryFieldOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`exportQueryFieldAs` VARCHAR(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`exportQueryFieldID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avExportQuery` (
	`exportQueryID` INT NOT NULL AUTO_INCREMENT ,
	`exportQueryName` VARCHAR(100) NOT NULL DEFAULT '',
	`exportQueryTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`exportQueryDescription` VARCHAR(255) NOT NULL DEFAULT '',
	`exportQueryOrder` SMALLINT NOT NULL DEFAULT 0 ,
	`exportQueryStatus` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`exportQueryID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avNewsletterSubscriber` (
	`newsletterSubscriberID` INT NOT NULL AUTO_INCREMENT ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`newsletterSubscriberEmail` VARCHAR(100) NOT NULL DEFAULT '',
	`newsletterSubscriberStatus` TINYINT NOT NULL DEFAULT 0 ,
	`newsletterSubscriberHtml` TINYINT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`cobrandID` INT NOT NULL DEFAULT 0 ,
	`affiliateID` INT NOT NULL DEFAULT 0 ,
	`newsletterSubscriberDateCreated` DATETIME NOT NULL,
	`newsletterSubscriberDateUpdated` DATETIME NOT NULL,
	`newsletterSubscriberIsExported` TINYINT NULL,
	`newsletterSubscriberDateExported` DATETIME NULL,
  PRIMARY KEY (`newsletterSubscriberID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCompany` (
	`companyID` INT NOT NULL AUTO_INCREMENT ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyName` VARCHAR(255) NOT NULL DEFAULT '',
	`companyDBA` VARCHAR(255) NOT NULL DEFAULT '',
	`companyURL` VARCHAR(100) NOT NULL DEFAULT '',
	`languageID` TINYINT NOT NULL DEFAULT 0 ,
	`companyPrimary` TINYINT NOT NULL DEFAULT 0 ,
	`companyStatus` TINYINT NOT NULL DEFAULT 0 ,
	`cobrandID` INT NOT NULL DEFAULT 0 ,
	`affiliateID` INT NOT NULL DEFAULT 0 ,
	`companyID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`companyID_parent` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`companyIsAffiliate` TINYINT NOT NULL DEFAULT 0 ,
	`companyIsCobrand` TINYINT NOT NULL DEFAULT 0 ,
	`companyIsVendor` TINYINT NOT NULL DEFAULT 0 ,
	`companyIsCustomer` TINYINT NOT NULL DEFAULT 0 ,
	`companyIsTaxExempt` TINYINT NOT NULL DEFAULT 0 ,
	`companyDirectory` VARCHAR(25) NOT NULL DEFAULT '',
	`companyDateCreated` DATETIME NOT NULL,
	`companyDateUpdated` DATETIME NOT NULL,
	`companyIsExported` TINYINT NULL,
	`companyDateExported` DATETIME NULL,
  PRIMARY KEY (`companyID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCobrand` (
	`cobrandID` INT NOT NULL AUTO_INCREMENT ,
	`companyID` INT NOT NULL DEFAULT 0 ,
	`userID` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`cobrandName` VARCHAR(255) NOT NULL DEFAULT '',
	`cobrandCode` VARCHAR(50) NOT NULL DEFAULT '',
	`cobrandStatus` TINYINT NOT NULL DEFAULT 0 ,
	`cobrandImage` VARCHAR(100) NOT NULL DEFAULT '',
	`cobrandURL` VARCHAR(255) NOT NULL DEFAULT '',
	`cobrandTitle` VARCHAR(100) NOT NULL DEFAULT '',
	`cobrandDomain` VARCHAR(100) NOT NULL DEFAULT '',
	`cobrandDirectory` VARCHAR(50) NOT NULL DEFAULT '',
	`cobrandID_custom` VARCHAR(50) NOT NULL DEFAULT '',
	`cobrandDateCreated` DATETIME NOT NULL,
	`cobrandDateUpdated` DATETIME NOT NULL,
	`cobrandIsExported` TINYINT NULL,
	`cobrandDateExported` DATETIME NULL,
  PRIMARY KEY (`cobrandID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avSalesCommission` (
	`salesCommissionID` INT NOT NULL AUTO_INCREMENT ,
	`commissionID` INT NOT NULL DEFAULT 0 ,
	`primaryTargetID` INT NOT NULL DEFAULT 0 ,
	`targetID` INT NOT NULL DEFAULT 0 ,
	`salesCommissionAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`salesCommissionFinalized` TINYINT NOT NULL DEFAULT 0 ,
	`salesCommissionDateFinalized` DATETIME NULL,
	`salesCommissionPaid` TINYINT NULL,
	`salesCommissionDatePaid` DATETIME NULL,
	`salesCommissionStatus` TINYINT NOT NULL DEFAULT 0 ,
	`salesCommissionManual` TINYINT NOT NULL DEFAULT 0 ,
	`userID_author` INT NOT NULL DEFAULT 0 ,
	`companyID_author` INT NOT NULL DEFAULT 0 ,
	`salesCommissionDateBegin` DATETIME NULL,
	`salesCommissionDateEnd` DATETIME NULL,
	`salesCommissionBasisTotal` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`salesCommissionBasisQuantity` DECIMAL(19,4) NOT NULL DEFAULT 0 ,
	`commissionStageID` INT NOT NULL DEFAULT 0 ,
	`commissionVolumeDiscountID` INT NOT NULL DEFAULT 0 ,
	`salesCommissionCalculatedAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`salesCommissionDateCreated` DATETIME NOT NULL,
	`salesCommissionDateUpdated` DATETIME NOT NULL,
	`salesCommissionIsExported` TINYINT NULL,
	`salesCommissionDateExported` DATETIME NULL,
  PRIMARY KEY (`salesCommissionID`) )
COLLATE = utf8_general_ci;

CREATE  TABLE IF NOT EXISTS `Billing`.`avCommissionVolumeDiscount` (
	`commissionVolumeDiscountID` INT NOT NULL AUTO_INCREMENT ,
	`commissionStageID` INT NOT NULL DEFAULT 0 ,
	`commissionVolumeDiscountQuantityMinimum` DECIMAL(19,4) NOT NULL DEFAULT 0 ,
	`commissionVolumeDiscountQuantityIsMaximum` TINYINT NOT NULL DEFAULT 0 ,
	`commissionVolumeDiscountAmount` DECIMAL(13,2) NOT NULL DEFAULT 0 ,
	`commissionVolumeDiscountIsTotalCommission` TINYINT NOT NULL DEFAULT 0 ,
  PRIMARY KEY (`commissionVolumeDiscountID`) )
COLLATE = utf8_general_ci;
