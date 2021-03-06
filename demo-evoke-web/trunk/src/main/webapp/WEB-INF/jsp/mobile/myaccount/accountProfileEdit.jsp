<%--
  This page displays the "Personal Information" details with "edit" functionality.

  Page includes:
    /mobile/myaccount/gadgets/subheaderAccounts.jsp - Display subheader items

  Required parameters:
    none

  Optional parameters:
    none
--%>
<dsp:page>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>
  <dsp:importbean bean="/atg/dynamo/droplet/PossibleValues"/>
  <dsp:importbean bean="/atg/store/droplet/IsEmailRecipient"/>
  <dsp:importbean bean="/atg/store/profile/RegistrationFormHandler"/>
  <dsp:importbean bean="/atg/userprofiling/ProfileAdapterRepository"/>

  <%-- ========== Handle form exceptions ========== --%>
  <dsp:getvalueof var="formExceptions" bean="RegistrationFormHandler.formExceptions"/>
  <jsp:useBean id="errorMap" class="java.util.HashMap"/>
  <c:if test="${not empty formExceptions}">
    <c:forEach var="formException" items="${formExceptions}">
      <c:set var="errorCode" value="${formException.errorCode}"/>
      <c:choose>
        <c:when test="${errorCode == 'missingRequiredValue'}">
          <c:set var="propertyName" value="${formException.propertyName}"/>
          <c:set target="${errorMap}" property="${propertyName}" value="missing"/>
        </c:when>
        <c:when test="${errorCode == 'invalidDateFormat'}">
          <c:set target="${errorMap}" property="dateOfBirth" value="invalid"/>
        </c:when>
        <c:when test="${errorCode == 'postalCode'}">
          <c:set target="${errorMap}" property="postalCode" value="invalid"/>
        </c:when>
        <c:when test="${errorCode == 'userAlreadyExists'}">
          <c:set target="${errorMap}" property="email" value="inUse"/>
        </c:when>
        <c:when test="${errorCode == 'invalidEmailAddress'}">
          <c:set target="${errorMap}" property="email" value="invalid"/>
        </c:when>
      </c:choose>
    </c:forEach>
  </c:if>

  <fmt:message var="pageTitle" key="mobile.myaccount_profileMyInfo.myInformation"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <%-- Set the Date format --%>
      <dsp:getvalueof var="dateFormat" bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear"/>
      <dsp:setvalue bean="RegistrationFormHandler.dateFormat" value="${dateFormat}"/>
      <dsp:setvalue bean="RegistrationFormHandler.extractDefaultValuesFromProfile" value="true"/>

      <%-- ========== Subheader ========== --%>
      <fmt:message var="editProf" key="mobile.myaccount_personalInformation.editProfile"/>
      <dsp:include page="gadgets/subheaderAccounts.jsp">
        <dsp:param name="rightText" value="${editProf}"/>
        <dsp:param name="highlight" value="right"/>
      </dsp:include>

      <div class="dataContainer">
        <%-- ========== Form ========== --%>
        <dsp:form formid="accountProfileEdit" action="${pageContext.request.requestURI}" method="post">
          <%-- ========== Redirection URLs ========== --%>
          <dsp:input bean="RegistrationFormHandler.updateSuccessURL" type="hidden" value="profile.jsp"/>
          <dsp:input bean="RegistrationFormHandler.updateErrorURL" type="hidden" value="${pageContext.request.requestURI}"/>

          <ul class="dataList" role="presentation">
            <%-- "First Name" --%>
            <li ${not empty errorMap['firstName'] ? 'class="errorState"' : ''}>
              <fmt:message var="firstNamePlace" key="mobile.profile.firstName"/>
              <div class="content">
                <dsp:input maxlength="40" bean="RegistrationFormHandler.value.firstName" type="text"
                            placeholder="${firstNamePlace}" aria-label="${firstNamePlace}" required="true"/> 
              </div>
              <c:if test="${not empty errorMap['firstName']}">
                <span class="errorMessage">
                  <fmt:message key="mobile.form.validation.${errorMap['firstName']}"/>
                </span>
              </c:if>
            </li>
            <%-- "Last Name" --%>
            <li ${not empty errorMap['lastName'] ? 'class="errorState"' : ''}>
              <fmt:message var="lastNamePlace" key="mobile.profile.lastName"/>
              <div class="content">
                <dsp:input maxlength="40" bean="RegistrationFormHandler.value.lastName" type="text"
                           placeholder="${lastNamePlace}" aria-label="${lastNamePlace}" required="true"/>
              </div>
              <c:if test="${not empty errorMap['lastName']}">
                <span class="errorMessage">
                  <fmt:message key="mobile.form.validation.${errorMap['lastName']}"/>
                </span>
              </c:if>
            </li>
            <%-- "Email" --%>
            <li ${not empty errorMap['email'] ? 'class="errorState"' : ''}>
              <fmt:message var="emailPlace" key="mobile.common.email"/>
              <div class="content">
                <dsp:input maxlength="40" bean="RegistrationFormHandler.value.email"
                           placeholder="${emailPlace}" aria-label="${emailPlace}" type="email" required="true" autocapitalize="off"/>
              </div>
              <c:if test="${not empty errorMap['email']}">
                <span class="errorMessage">
                  <fmt:message key="mobile.form.validation.${errorMap['email']}"/>
                </span>
              </c:if>
            </li>
            <li>
              <fmt:message var="zipPlace" key="mobile.common.postalCode"/>
              <%-- "Postal Code" --%>
              <div class="left ${not empty errorMap['postalCode'] ? 'errorState' : ''}">
                <div class="content">
                  <dsp:input maxlength="10" size="10" bean="RegistrationFormHandler.value.homeAddress.postalCode"
                             placeholder="${zipPlace}" aria-label="${zipPlace}" type="tel" required="false"/>
                </div>
              </div>
              <div class="right">
                <%-- "Phone" --%>
                <fmt:message var="phonePlace" key="mobile.common.phone"/>
                <div class="content icon-ArrowLeft">
                  <dsp:input maxlength="15" size="10" bean="RegistrationFormHandler.value.homeAddress.phoneNumber"
                             type="tel" required="false" placeholder="${phonePlace}" aria-label="${phonePlace}" />
                </div>
              </div>
            </li>
            <li class=" ${not empty errorMap['dateOfBirth'] ? 'errorStateSeparatedRight' : ''}">
              <%-- "Gender" --%>
              <div class="left">
                <div class="content icon-ArrowLeft">
                  <dsp:getvalueof var="selectedGender" bean="RegistrationFormHandler.value.gender"/>
                  <dsp:getvalueof var="selectStyle" value="${(selectedGender == 'unknown') ? ' default' : ''}"/>
                  <%-- No permanent styles should be applied to this select using a class --%>
                  <dsp:select onchange="CRSMA.myaccount.changeDropdown(event);" name="genderSelect"
                              bean="RegistrationFormHandler.value.gender" class="select ${selectStyle}">
                    <%--
                      Get genders from "PossibleValues" droplet need to pass parameter "itemDescriptorName" as "user"
                      and "propertyName" as "gender".
                    --%>
                    <dsp:droplet name="PossibleValues">
                      <dsp:param name="itemDescriptorName" value="user"/>
                      <dsp:param name="propertyName" value="gender"/>
                      <dsp:param name="repository" bean="ProfileAdapterRepository"/>
                      <dsp:param name="returnValueObjects" value="true"/>
                      <dsp:param name="comparator" bean="/atg/userprofiling/ProfileEnumOptionsComparator"/>
                      <dsp:param name="bundle" bean="/atg/multisite/Site.resourceBundle"/>
                      <dsp:oparam name="output">
                        <%-- Get the output parameter of "PossibleValues" Droplet and put it into the forEach --%>
                        <dsp:getvalueof var="values" param="values"/>
                        <c:forEach var="gender" items="${values}">
                          <c:choose>
                            <%-- If value is unknown, show title --%>
                            <c:when test="${gender.settableValue == 'unknown'}">
                              <dsp:option iclass="default" value="${gender.settableValue}">
                                <fmt:message key="mobile.profile.selectGender"/>
                              </dsp:option>
                            </c:when>
                            <%-- Otherwise get possible values from repository --%>
                            <c:otherwise>
                              <dsp:option value="${gender.settableValue}">
                                <c:out value="${gender.localizedLabel}"/>
                              </dsp:option>
                            </c:otherwise>
                          </c:choose>
                        </c:forEach>
                      </dsp:oparam>
                    </dsp:droplet>
                  </dsp:select>
                </div>
              </div>
              <%-- "Date of Birth" --%>
              <div class="right ${not empty errorMap['dateOfBirth'] ? 'errorState bottom' : ''}">
                <fmt:message var="dobPlace" key="mobile.profile.DOB"/>
                <div class="content icon-ArrowLeft">
                  <dsp:input maxlength="10" size="15" bean="RegistrationFormHandler.dateOfBirth"
                             placeholder="${dobPlace}" aria-label="${dobPlace}" type="text" required="false"/>
                </div>
                <dsp:input type="hidden" bean="RegistrationFormHandler.dateFormat" value="${dateFormat}"/>
                <c:if test="${not empty errorMap['dateOfBirth']}">
                  <span class="errorMessage">
                    <dsp:getvalueof var="exampleDate" bean="StoreConfiguration.epochDate"/>
                    <fmt:formatDate var="formattedExampleDate" type="date" value="${exampleDate}" pattern="${dateFormat}"/>
                    <fmt:message key="mobile.common.dateFormatDisplay">
                      <fmt:param value="${formattedExampleDate}"/>
                    </fmt:message>
                  </span>
                </c:if>
              </div>
            </li>
            <li>
              <div class="content">
                <div class="checkbox">
                  <%-- "Receive Emails" checkbox --%>
                  <dsp:droplet name="IsEmailRecipient">
                    <dsp:param name="email" bean="RegistrationFormHandler.value.email"/>
                    <dsp:oparam name="true">
                      <dsp:input bean="RegistrationFormHandler.previousOptInStatus" type="hidden" value="true"/>
                      <c:choose>
                        <c:when test="${empty formExceptions}">
                          <dsp:input id="receive_emails" type="checkbox" bean="RegistrationFormHandler.emailOptIn" checked="true"/>
                        </c:when>
                        <c:otherwise>
                          <dsp:input id="receive_emails" type="checkbox" bean="RegistrationFormHandler.emailOptIn"/>
                        </c:otherwise>
                      </c:choose>
                    </dsp:oparam>
                    <dsp:oparam name="false">
                      <dsp:input bean="RegistrationFormHandler.previousOptInStatus" type="hidden" value="false"/>
                      <c:choose>
                        <c:when test="${empty formExceptions}">
                          <dsp:input id="receive_emails" type="checkbox" bean="RegistrationFormHandler.emailOptIn" checked="false"/>
                        </c:when>
                        <c:otherwise>
                          <dsp:input id="receive_emails" type="checkbox" bean="RegistrationFormHandler.emailOptIn"/>
                        </c:otherwise>
                      </c:choose>
                    </dsp:oparam>
                  </dsp:droplet>
                  <span>
                    <fmt:message var="privacyTitle" key="mobile.company_privacyAndTerms.pageTitle"/>
                    <dsp:a page="${mobileStorePrefix}/company/terms.jsp" title="${privacyTitle}" class="icon-help"/>
                  </span>
                  <label for="receive_emails" onclick=""><fmt:message key="mobile.common.receiveEmails"/></label>
                </div>
              </div>
            </li>
          </ul>

          <%-- "Submit" button --%>
          <div class="centralButton">
            <fmt:message var="done" key="mobile.common.done"/>
            <dsp:input bean="RegistrationFormHandler.update" class="mainActionButton" type="submit" value="${done}"/>
          </div>
        </dsp:form>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @updated $DateTime: 2012/10/09 05:20:49 $$Author: dvolakh $ --%>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/myaccount/accountProfileEdit.jsp#5 $$Change: 731276 $--%>
