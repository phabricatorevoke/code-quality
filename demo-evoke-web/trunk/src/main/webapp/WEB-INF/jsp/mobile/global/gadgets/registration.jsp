<%--
  This page renders registration form for new customers.

  Page includes:
    None

  Required parameters:
    formHandler
      One from
        /atg/store/profile/RegistrationFormHandler
        /atg/store/mobile/order/purchase/MobileBillingFormHandler

    successUrl
      Redirection path, used when registration succeeds

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/store/droplet/ProfileSecurityStatus"/>
  <dsp:importbean bean="/atg/userprofiling/Profile"/>

  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="profileEmail" bean="Profile.email"/>
  <dsp:getvalueof var="formHandler" param="formHandler"/>
  <dsp:getvalueof var="successUrl" param="successUrl"/>
  <dsp:getvalueof var="mobileStorePrefix" bean="/atg/store/StoreConfiguration.mobileStorePrefix"/>

  <c:set var="isRegisterHandlerUsed" value="${formHandler == '/atg/store/profile/RegistrationFormHandler'}"/>
  <c:set var="isBillingHandlerUsed" value="${formHandler == '/atg/store/mobile/order/purchase/MobileBillingFormHandler'}"/>

  <%-- Check to see if the user is unknown, offer option to logout if the user is logged in --%>
  <dsp:droplet name="ProfileSecurityStatus">
    <dsp:oparam name="anonymous">
      <%-- ========== Handle form exceptions ========== --%>
      <dsp:getvalueof var="formExceptions" bean="${formHandler}.formExceptions"/>
      <jsp:useBean id="errorMap" class="java.util.HashMap"/>
      <c:if test="${not empty formExceptions}">
        <c:forEach var="formException" items="${formExceptions}">
          <c:set var="errorCode" value="${formException.errorCode}"/>
          <c:choose>
            <c:when test="${errorCode == 'invalidEmailAddress'}">
              <c:set target="${errorMap}" property="email" value="invalid"/>
            </c:when>
            <c:when test="${errorCode == 'userAlreadyExists'}">
              <c:set target="${errorMap}" property="email" value="inUse"/>
            </c:when>
            <c:when test="${errorCode == 'missingRequiredValue'}">
              <c:set var="propertyPath" value="${formException.propertyPath}"/>
              <c:set var="formHandlerValue" value="${formHandler}.value."/>
              <c:set var="field" value="${fn:substringAfter(propertyPath, formHandlerValue)}"/>
              <c:set target="${errorMap}" property="${field}" value="missing"/>
            </c:when>

            <%-- Error handling with "DropletFormException" is specific for "BillingFormHandler" --%>
            <c:when test="${errorCode == 'atg.droplet.DropletFormException'}">
              <c:set var="errorCodeInternal" value="${formException.propertyPath}"/>

              <c:if test="${errorCodeInternal == 'userAlreadyExists'}">
                <c:set target="${errorMap}" property="email" value="inUse"/>
              </c:if>
              <c:if test="${errorCodeInternal == 'passwordWrongLength'}">
                <c:set target="${errorMap}" property="password" value="invalid"/>
                <c:set var="errorMessage" value="${formException.message}"/>
              </c:if>
              <c:if test="${errorCodeInternal == 'passwordsDontMatch'}">
                <c:set var="errorMessage" value="${formException.message}"/>
              </c:if>
            </c:when>

            <%--
              Error handling with "DropletException" is specific only for Register handling.
              Password rules checker fired error: "Password length too short"
            --%>
            <c:when test="${errorCode == 'atg.droplet.DropletException'}">
              <c:set target="${errorMap}" property="password" value="invalid"/>
              <c:set var="errorMessage" value="${formException.message}"/>
            </c:when>
            
            <c:when test="${errorCode == 'passwordsDoNotMatch'}">
              <c:set var="errorMessage" value="${formException.message}"/>
            </c:when>
          </c:choose>
        </c:forEach>
      </c:if>

      <%-- Display error messages which were previously set while handling form exceptions --%>
      <c:if test="${not empty errorMessage && fn:length(errorMessage) > 0}">
        <div id="formValidationError">
          <div class="errorMessage">
            <dsp:valueof value="${errorMessage}" valueishtml="true"/>
          </div>
        </div>
      </c:if>

      <div class="content">
        <%-- Some specific for register form handler --%>
        <c:if test="${isRegisterHandlerUsed}">
          <dsp:setvalue bean="${formHandler}.extractDefaultValuesFromProfile" value="false"/>
        </c:if>

        <%-- ========== Form ========== --%>
        <dsp:form formid="registration" action="${pageContext.request.requestURI}" method="post">
          <%-- "Remember me on this device" --%>
          <dsp:input bean="${formHandler}.value.autoLogin" type="hidden" value="${true}"/>
          <%-- ========== Redirection URLs ========== --%>
          <c:url var="errorURL" value="${pageContext.request.requestURI}" context="/">
            <c:param name="formHandler" value="${formHandler}"/>
            <c:param name="successUrl" value="${successUrl}"/>
            <c:param name="registrationErrors" value="true"/>
          </c:url>

          <c:if test="${isRegisterHandlerUsed}">
            <dsp:input bean="${formHandler}.createSuccessURL" type="hidden" value="${successUrl}"/>
            <dsp:input bean="${formHandler}.createErrorURL" type="hidden" value="${errorURL}"/>
          </c:if>
          <c:if test="${isBillingHandlerUsed}">
            <dsp:input bean="${formHandler}.registerAccountSuccessURL" type="hidden" value="${successUrl}"/>
            <dsp:input bean="${formHandler}.registerAccountErrorURL" type="hidden" value="${errorURL}"/>
          </c:if>

          <!-- If email is stored and no email entered before -->
          <c:if test="${not empty profileEmail and empty handlerEmail}">
            <!-- Use this email and "forget" it -->
            <dsp:setvalue bean="${formHandler}.value.email" value="${profileEmail}"/>
            <dsp:setvalue bean="Profile.email" value=""/>
          </c:if>

          <div class="dataContainer">
            <span class="questionImage">
              <fmt:message var="privacyTitle" key="mobile.company_privacyAndTerms.pageTitle"/>
              <dsp:a page="${mobileStorePrefix}/company/terms.jsp" title="${privacyTitle}" class="icon-help register"/>
            </span>

            <ul class="dataList">
              <%-- "Email" --%>
              <li ${not empty errorMap['email'] ? 'class="errorState"' : ''}>
                <div class="content">
                  <fmt:message var="emailHint" key="mobile.common.email"/>
                  <dsp:input bean="${formHandler}.value.email" type="email" required="true"
                             placeholder="${emailHint}" aria-label="${emailHint}" autocapitalize="off" maxlength="40"/>
                </div>
                <c:if test="${not empty errorMap['email']}">
                  <span class="errorMessage">
                    <fmt:message key="mobile.form.validation.${errorMap['email']}"/>
                  </span>
                </c:if>
              </li>

              <%-- "Password" --%>
              <li ${not empty errorMap['password'] ? 'class="errorState"' : ''}>
                <div class="content">
                  <fmt:message var="createPasswordHint" key="mobile.common.createPassword"/>
                  <dsp:input bean="${formHandler}.value.password" type="password" required="true"
                             value="" maxlength="35" placeholder="${createPasswordHint}" aria-label="${createPasswordHint}"/>
                </div>
                <c:if test="${not empty errorMap['password']}">
                  <span class="errorMessage">
                    <fmt:message key="mobile.form.validation.${errorMap['password']}"/>
                  </span>
                </c:if>
              </li>
              
             <%-- User must confirm password when registering --%>
             <dsp:input bean="${formHandler}.confirmPassword" type="hidden" value="true"/>
              
             <%-- "Confirm Password" --%>
              <li ${not empty errorMap['confirmPassword'] ? 'class="errorState"' : ''}>
                <div class="content">
                  <fmt:message var="createConfirmPasswordHint" key="mobile.common.createConfirmPassword"/>
                  <dsp:input bean="${formHandler}.value.confirmPassword" type="password" required="true"
                             value="" maxlength="35" placeholder="${createConfirmPasswordHint}" aria-label="${createConfirmPasswordHint}"/>
                </div>
                <c:if test="${not empty errorMap['confirmPassword']}">
                  <span class="errorMessage">
                    <fmt:message key="mobile.form.validation.${errorMap['confirmPassword']}"/>
                  </span>
                </c:if>
              </li>
              
              <%-- "First Name" --%>
              <li ${not empty errorMap['firstName'] ? 'class="errorState"' : ''}>
                <div class="content">
                  <fmt:message var="firstNameHint" key="mobile.profile.firstName"/>
                  <dsp:input bean="${formHandler}.value.firstName" type="text" required="true"
                             maxlength="40" placeholder="${firstNameHint}" aria-label="${firstNameHint}"
                             autocapitalize="words"/>
                </div>
                <c:if test="${not empty errorMap['firstName']}">
                  <span class="errorMessage">
                    <fmt:message key="mobile.form.validation.${errorMap['firstName']}"/>
                  </span>
                </c:if>
              </li>

              <%-- "Last Name" --%>
              <li ${not empty errorMap['lastName'] ? 'class="errorState"' : ''}>
                <div class="content">
                  <fmt:message var="lastNameHint" key="mobile.profile.lastName"/>
                  <dsp:input bean="${formHandler}.value.lastName" type="text" required="true"
                             maxlength="40" placeholder="${lastNameHint}" aria-label="${lastNameHint}"
                             autocapitalize="words"/>
                </div>
                <c:if test="${not empty errorMap['lastName']}">
                  <span class="errorMessage">
                    <fmt:message key="mobile.form.validation.${errorMap['lastName']}"/>
                  </span>
                </c:if>
              </li>
            </ul>

            <%-- "Submit" button handler --%>
            <c:set var="submitBtnHandler">
              <c:if test="${isBillingHandlerUsed}" >${formHandler}.registerUser</c:if>
              <c:if test="${isRegisterHandlerUsed}">${formHandler}.create</c:if>
            </c:set>

            <%-- "Submit" button --%>
            <div class="centralButton">
              <fmt:message var="submitBtnValue" key="mobile.myaccount_login.button.create"/>
              <dsp:input bean="${submitBtnHandler}" type="submit" class="mainActionButton" value="${submitBtnValue}"/>
            </div>
          </div>
        </dsp:form>
      </div>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/global/gadgets/registration.jsp#4 $$Change: 733324 $--%>
