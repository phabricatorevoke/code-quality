<%--
  General information about the company ("About Us" page).

  Page includes:
    None

  Required Parameters:
    None

  Optional Parameters:
    None
--%>
<dsp:page>
  <fmt:message var="pageTitle" key="mobile.navigation_tertiaryNavigation.aboutUs"/>
  <crs:mobilePageContainer titleString="${pageTitle}">
    <jsp:body>
      <div class="infoHeader">
        <fmt:message key="mobile.company_aboutUs.ourHistory"/>
      </div>
      <div class="infoContent">
        <fmt:message key="mobile.company_aboutUs.aboutUs"/>
      </div>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/company/aboutUs.jsp#3 $$Change: 713898 $ --%>
