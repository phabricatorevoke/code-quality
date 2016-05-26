<%--
  This gadget returns ISO 4217 currency code and currency symbol
  corresponding to price list locale (Profile.priceList.locale).
  Data are returned in the following request-scoped variables:
    currencyCode
      The currency code (ISO 4217)
    currencySymbol
      The currency symbol

  Required parameters:
    None

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:getvalueof var="locale" vartype="java.lang.String" param="/atg/userprofiling/Profile.priceList.locale"/>
  <c:set var="currencyCode" scope="request" value=""/>
  <c:set var="currencySymbol" scope="request" value=""/>  

  <%-- Calculate currency code for price list locale --%>
  <c:if test="${not empty locale}">
    <dsp:droplet name="/atg/commerce/pricing/CurrencyCodeDroplet">
      <dsp:param name="locale" value="${locale}"/>
      <dsp:oparam name="output">
        <dsp:getvalueof var="currencyCode" vartype="java.lang.String" param="currencyCode" scope="request"/>
        <dsp:getvalueof var="currencySymbol" vartype="java.lang.String" param="currencySymbol" scope="request"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/global/util/currencyCode.jsp#3 $$Change: 736273 $--%>
