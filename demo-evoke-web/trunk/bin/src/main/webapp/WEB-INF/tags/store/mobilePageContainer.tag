<%--
  This tag is a container for all top-level mobile pages.
  The following request-scoped variables are also introduced by this tag:
    mobileStorePrefix
      "/atg/store/StoreConfiguration.mobileStorePrefix" bean property value.
    siteContextPath
      Is a context path ("/atg/multisite/Site.productionURL" or "pageContext.request.contextPath")
      plus mobile store prefix ("/atg/store/StoreConfiguration.mobileStorePrefix" bean property value).
    siteBaseURL
      The same as "siteContextPath", but WITHOUT the "/mobile" suffix.
    isLoggedIn
      Whether a user is logged in (i.e. if a user Profile is not transient).
    userGender
      User gender: male, female or "unknown" (if user is not logged in).

  Includes:
    /mobile/includes/header.jspf - Header fragment of the page
    /mobile/includes/footer.jspf - Footer fragment of the page
    /mobile/includes/pageDirectives.jsp - Specific JSP directives which are not allowed in custom tags
    /mobile/global/util/getSiteContextPath.jsp - Defines "siteContextPath", "siteBaseURL" request-scoped variables

  Required Parameters:
    titleString
      The title of the current page

  Optional Parameters:
    displayModal
      If present, modal dialog will be visible on page load

  Page Fragments:
    modalContent (optional) - renders modal dialog / popup content for the page
--%>
<%@ include file="/includes/taglibs.jspf"%>
<%@ include file="/includes/context.jspf"%>

<%@ tag language="java"%>

<%@ attribute name="titleString" required="true"%>
<%@ attribute name="modalContent" fragment="true"%>
<%@ attribute name="displayModal" required="false"%>

<dsp:include page="/mobile/includes/pageDirectives.jsp"/>

<dsp:importbean bean="/atg/multisite/Site" var="currentSite"/>
<dsp:importbean bean="/atg/store/StoreConfiguration"/>
<dsp:importbean bean="/atg/userprofiling/Profile"/>

<dsp:getvalueof var="mobileStorePrefix" bean="StoreConfiguration.mobileStorePrefix" scope="request"/>
<dsp:include page="${mobileStorePrefix}/global/util/getSiteContextPath.jsp"/>
<dsp:getvalueof var="isTransient" bean="Profile.transient"/>
<c:set var="isLoggedIn" scope="request" value="${isTransient ? false : true}"/>
<dsp:getvalueof var="userGender" bean="Profile.gender" scope="request"/>

<dsp:getvalueof var="language" bean="/OriginatingRequest.requestLocale.locale.language"/>
<c:if test="${empty language}">
  <dsp:getvalueof var="language" bean="/OriginatingRequest.locale.language"/>
</c:if>

<!DOCTYPE HTML>
<html lang="${language}">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="format-detection" content="telephone=no"/>
    <link rel="stylesheet" href="${siteContextPath}/css/mobile.css" type="text/css" media="screen"/>
    <%-- Load the site specific CSS --%>
    <dsp:getvalueof var="siteCssFile" value="${currentSite.cssFile}"/>
    <c:if test="${not empty siteCssFile}">
      <link rel="stylesheet" href="${siteContextPath}${siteCssFile}.css" type="text/css" media="screen" charset="utf-8"/>
    </c:if>
    <dsp:getvalueof var="faviconUrl" vartype="java.lang.String" value="${currentSite.favicon}"/>
    <link rel="shortcut icon" href="${faviconUrl}"/>
    <link rel="apple-touch-icon" href="/crsdocroot/content/mobile/images/apple-touch-icon.png"/>
    <script type="text/javascript" src="${siteContextPath}/js/jquery/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="${siteContextPath}/js/atg/mobile.js"></script>
    <script type="text/javascript" src="${siteContextPath}/js/resources/resources_${language}.js"></script>
    <title><crs:outMessage key="common.storeName"/><fmt:message key="mobile.common.textSeparator"/> <c:out value="${titleString}"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"/>
  </head>
  <body>
    <div id="pageContainer">
      <%@ include file="/mobile/includes/header.jspf"%>

      <div class="storeContainer">
        <jsp:doBody/>
      </div>

      <%@include file="/mobile/includes/footer.jspf"%>

      <div id="modalOverlay" ${(not empty displayModal && displayModal) ? '' : 'class="hidden"'} onclick="CRSMA.global.toggleModal(false);">
        <div class="shadow">
          <%--
            Accessibility hint to allow user to dismiss the modal overlay.
            br elements move the text down the page; anything other than plain text will not be read
          --%>
          <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
          <fmt:message key="mobile.accessibility.overlay"/>
        </div>
        <div id="contactInfo">
          <ul class="dataList">
            <li><div class="content"><fmt:message key="navigation_tertiaryNavigation.contactUs"/></div></li>
            <li><div class="content"><dsp:include page="${mobileStorePrefix}/includes/gadgets/phone.jsp"/></div></li>
            <li><div class="content"><dsp:include page="${mobileStorePrefix}/includes/gadgets/email.jsp"/></div></li>
          </ul>
        </div>
        <jsp:invoke fragment="modalContent"/>
      </div>
    </div>
  </body>
</html>
