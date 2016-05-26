<%--
  Multisite menu renderer.
  Adds multisite menu to search filed. Allows to search products on selected sites only.

  Required parameters:
    None

  Optional parameters:
    None
--%>
<dsp:page>
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/dynamo/droplet/ForEach"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/CartSharingSitesDroplet"/>
  <dsp:importbean bean="/atg/endeca/assembler/SearchFormHandler"/>

  <%-- Get the site ID for the current site. The current site should not be rendered as a link in the Store site picker --%>
  <dsp:getvalueof var="currentSiteId" bean="Site.id"/>

  <dsp:droplet name="CartSharingSitesDroplet">
    <dsp:param name="siteId" value="${currentSiteId}"/>
    <dsp:param name="shareableTypeId" value="crs.MobileSite"/>
    <dsp:getvalueof var="sites" param="sites"/>
    <dsp:oparam name="output">
      <%-- Ensure we have more than 1 site --%>
      <c:if test="${fn:length(sites) > 0}">
        <div id="searchMultisiteContainer">
          <div id="multisiteHeader"><fmt:message key="mobile.search.multisite.title"/><fmt:message key="mobile.common.labelSeparator"/></div>
          <%-- Iterate through the sites in the "Shopping Cart" sharing group --%>
          <dsp:droplet name="ForEach">
            <dsp:param name="array" param="sites"/>
            <dsp:param name="sortProperties" value="-name"/>
            <dsp:oparam name="output">
               <dsp:getvalueof var="siteIdx" param="index"/>
              <dsp:setvalue param="site" paramvalue="element"/>
              <dsp:getvalueof var="siteName" param="site.name"/>
              <dsp:getvalueof var="siteId" param="site.id"/>
              <c:choose>
                <c:when test="${siteId == currentSiteId}">
                  <div class="siteLine">
                    <div class="content">
                      <dsp:input type="checkbox" priority="20" id="searchSite${siteIdx}" bean="SearchFormHandler.siteIds" name="siteIds" value="${siteId}"
                                 onclick="this.checked=!this.checked; CRSMA.search.focusOnSearchField();" checked="true"/>
                      <label for="searchSite${siteIdx}" onclick="" class="disabledLabel">${siteName}</label>
                    </div>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="siteLine">
                    <div class="content">
                      <dsp:input type="checkbox" priority="20" id="searchSite${siteIdx}" bean="SearchFormHandler.siteIds" name="siteIds" value="${siteId}"
                                 onclick="CRSMA.search.focusOnSearchField();"/>
                      <label for="searchSite${siteIdx}" onclick="">${siteName}</label>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </dsp:oparam>
          </dsp:droplet>
          <dsp:input bean="SearchFormHandler.siteScope" type="hidden" value="ok" name="siteScope"/>
          <dsp:input type="hidden" bean="SearchFormHandler.search" name="search" value="submit" priority="10"/>
        </div>
      </c:if>
    </dsp:oparam>
  </dsp:droplet>
</dsp:page>
