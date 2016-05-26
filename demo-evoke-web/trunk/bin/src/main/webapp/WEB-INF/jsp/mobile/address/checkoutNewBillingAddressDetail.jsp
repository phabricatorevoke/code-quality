<%--
  This page serves the following "Checkout" address detail contexts:
    - Checkout / New Credit Card / New Billing Address
    - Checkout / Edit Credit Card / New Billing Address

  Page includes:
    /mobile/address/gadgets/addressAddEdit.jsp - Renders address form (except "Nickname" field)

  Required parameters:
    cardOper
      'edit' = edit credit card
      'add' = add card

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/order/purchase/CouponFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/MobileB2CProfileFormHandler"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="cardOper" param="cardOper"/>

  <%-- FormHandler "address" property name --%>
  <c:set var="addrPropertyName">
    <c:if test="${cardOper == 'add'}">/atg/userprofiling/MobileB2CProfileFormHandler.billAddrValue</c:if>
    <c:if test="${cardOper == 'edit'}">/atg/userprofiling/MobileB2CProfileFormHandler.editValue</c:if>
  </c:set>

  <%-- ========== Handle form exceptions ========== --%>
  <dsp:getvalueof var="formExceptions" bean="MobileB2CProfileFormHandler.formExceptions"/>
  <jsp:useBean id="errorMap" class="java.util.HashMap"/>
  <c:if test="${not empty formExceptions}">
    <c:forEach var="formException" items="${formExceptions}">
      <c:set var="errorCode" value="${formException.errorCode}"/>
      <c:choose>
        <c:when test="${errorCode == 'stateIsIncorrect'}">
          <c:set target="${errorMap}" property="state" value="invalid"/>
          <c:set target="${errorMap}" property="country" value="invalid"/>
        </c:when>
        <c:when test="${errorCode == 'missingRequiredValue'}">
          <c:set var="propertyName" value="${formException.propertyName}"/>
          <c:set target="${errorMap}" property="${propertyName}" value="missing"/>
        </c:when>
      </c:choose>
    </c:forEach>
  </c:if>

  <fmt:message key="mobile.common.newBillingAddress" var="pageTitle"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="dataContainer">
        <%-- ========== Form header ========== --%>
        <h2><fmt:message key="mobile.common.newBillingAddress"/></h2>

        <%-- ========== Form ========== --%>
        <dsp:form action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <c:url value="${pageContext.request.requestURI}" var="errorURL" context="/">
            <c:param name="cardOper" value="${cardOper}"/>
          </c:url>
          <c:if test="${cardOper == 'add'}">
            <dsp:input type="hidden" bean="MobileB2CProfileFormHandler.createBillingAddressSuccessURL"
                       value="${siteContextPath}/checkout/billingCVV.jsp?dispatchCSV=newCardNewAddress"/>
            <dsp:input type="hidden" bean="MobileB2CProfileFormHandler.createBillingAddressErrorURL" value="${errorURL}"/>

            <%-- "Coupon code" --%>
            <dsp:getvalueof var="couponCode" bean="CouponFormHandler.currentCouponCode"/>
            <dsp:input bean="CouponFormHandler.couponCode" priority="10" type="hidden" value="${couponCode}"/>
          </c:if>

          <ul class="dataList">
            <%-- Include "addressAddEdit.jsp" to render address properties --%>
            <dsp:include page="gadgets/addressAddEdit.jsp">
              <dsp:param name="formHandlerComponent" value="${addrPropertyName}"/>
              <dsp:param name="restrictionDroplet" value="/atg/store/droplet/ShippingRestrictionsDroplet"/>
              <dsp:param name="errorMap" value="${errorMap}"/>
            </dsp:include>

            <c:if test="${cardOper == 'add'}">
              <%--
                If the shopper is a guest shopper, we don't offer to save the address.
                Otherwise set "saveBillingAddress" to false to override default value of true.
              --%>
              <c:choose>
                <c:when test="${isLoggedIn}">
                  <li class="clear">
                    <div class="content">
                      <dsp:input type="checkbox" bean="MobileB2CProfileFormHandler.billAddrValue.saveBillingAddress"
                                 checked="true" id="saveBillingAddress"/>
                      <label for="saveBillingAddress" onclick=""><fmt:message key="mobile.checkout_addressAdd.saveAddress"/></label>
                    </div>
                  </li>
                </c:when>
                <c:otherwise>
                  <dsp:input type="hidden" bean="MobileB2CProfileFormHandler.billAddrValue.saveBillingAddress" value="false"/>
                </c:otherwise>
              </c:choose>
            </c:if>
          </ul>

          <%-- "Submit" button --%>
          <div class="centralButton">
            <c:set var="submitBtnHandleMethod">
              <c:if test="${cardOper == 'add'}">MobileB2CProfileFormHandler.createBillingAddress</c:if>
              <c:if test="${cardOper == 'edit'}">MobileB2CProfileFormHandler.newAddress</c:if>
            </c:set>
            <fmt:message var="submitBtnValue" key="mobile.common.done"/>
            <dsp:input bean="${submitBtnHandleMethod}" class="mainActionButton" type="submit" priority="-10" value="${submitBtnValue}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
