<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="selectProductsInCart" returnVariable="qry_selectProductsInCart" />
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="selectPaymentCreditsInCart" returnVariable="qry_selectPaymentCreditsInCart" />

<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalShippingInCart" returnVariable="Variables.invoiceTotalShipping" />
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalTaxInCart" returnVariable="Variables.invoiceTotalTax" />
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalLineItemInCart" returnVariable="Variables.invoiceTotalLineItem" />
<cfinvoke component="#Application.billingMapping#control.c_shopping.c_shoppingCart.ShoppingCart" method="getInvoiceTotalPaymentCreditInCart" returnVariable="Variables.invoiceTotalPaymentCredit" />

<cfset Variables.invoiceTotal = Variables.invoiceTotalLineItem + Variables.invoiceTotalTax + Variables.invoiceTotalShipping - Variables.invoiceTotalPaymentCredit>
