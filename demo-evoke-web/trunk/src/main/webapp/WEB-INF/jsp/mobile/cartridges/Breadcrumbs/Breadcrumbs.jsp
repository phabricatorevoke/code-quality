<%--
  "Breadcrumbs" cartridge renderer.
  Mobile version.
  Renders refinement that have been selected. Selected refinements are
  "Search refinements", "Dimension refinements" or "Range filter refinements":
    regfinementCrumbs - result of selecting a dimension
    searchCrumbs - result of performing a search
    rangeFilterCrumbs - result of applying a range filter

  Includes:
    /mobile/global/gadgets/renderNavLink.jsp - Endeca navigation links renderer
    /mobile/global/util/getNavLink.jsp - Endeca-specific navigation link generator

  Required Parameters:
    contentItem
      The "Breadcrumbs" content item to render.
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>

  <c:if test="${not empty contentItem.searchCrumbs || not empty contentItem.refinementCrumbs || not empty contentItem.rangeFilterCrumbs}">
    <ul class="crumbDataList">
      <%-- "Search Crumbs" (search terms) block --%>
      <c:forEach var="searchCrumb" items="${contentItem.searchCrumbs}">
        <c:set var="searchCrumbText">
          <c:choose>
            <c:when test="${searchCrumb.correctedTerms != null}">&quot;<c:out value="${searchCrumb.correctedTerms}"/>&quot;</c:when>
            <c:otherwise>&quot;<c:out value="${searchCrumb.terms}"/>&quot;</c:otherwise>
          </c:choose>
        </c:set>
        <li>
          <dsp:include page="${mobileStorePrefix}/global/util/getNavLink.jsp">
            <dsp:param name="navAction" value="${searchCrumb.removeAction}"/>
          </dsp:include>
          <div class="crumbContent" role="link" onclick="document.location = '${navLink}';" aria-describedby="delId">
            <div class="crumbContentText">
              ${searchCrumbText}
            </div>
          </div>
        </li>
      </c:forEach>
      <%-- "Refinement Crumbs" (facet labels) block --%>
      <c:forEach var="refinementCrumb" items="${contentItem.refinementCrumbs}">
        <dsp:include page="${mobileStorePrefix}/global/util/getNavLink.jsp">
          <dsp:param name="navAction" value="${refinementCrumb.removeAction}"/>
        </dsp:include>
        <li id="${fn:replace(refinementCrumb.displayName, '.', '_')}" onclick="CRSMA.search.removeCrumb(this, '${navLink}')">
          <div class="crumbContent" role="link" aria-describedby="delId">
            <div class="crumbContentText">
              <c:forEach var="ancestor" items="${refinementCrumb.ancestors}">
                <dsp:include page="${mobileStorePrefix}/global/gadgets/renderNavLink.jsp">
                  <dsp:param name="navAction" value="${ancestor}"/>
                  <dsp:param name="text" value="${ancestor.label}"/>
                </dsp:include>
                <%-- Levels separator for "Category breadcrumbs" --%>
                <span class="crumbLevelsSeparator">&nbsp;&gt;&nbsp;</span>
              </c:forEach>
              <span>${refinementCrumb.label}</span>
            </div>
          </div>
      </c:forEach>
      <c:forEach var="filterCrumb" items="${contentItem.rangeFilterCrumbs}">
        <dsp:include page="${mobileStorePrefix}/global/util/getNavLink.jsp">
          <dsp:param name="navAction" value="${filterCrumb.removeAction}"/>
        </dsp:include>
        <li onclick="CRSMA.search.removeCrumb(this, '${navLink}')">
          <div class="crumbContent" role="link" aria-describedby="delId">
            <div class="crumbContentText">
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${filterCrumb.lowerBound}"/>
                <dsp:param name="saveFormattedPrice" value="true"/>
              </dsp:include>
             <dsp:getvalueof var="minPrice" value="${fn:replace(fn:replace(formattedPrice, ',00', ''), '.00', '')}"/>
              <dsp:include page="/global/gadgets/formattedPrice.jsp">
                <dsp:param name="price" value="${filterCrumb.upperBound}"/>
                <dsp:param name="saveFormattedPrice" value="true"/>
              </dsp:include>
             <dsp:getvalueof var="maxPrice" value="${fn:replace(fn:replace(formattedPrice, ',00', ''), '.00', '')}"/>
             <dsp:valueof value="${minPrice}"/> - <dsp:valueof value="${maxPrice}"/>
            </div>
          </div>
        </li>
      </c:forEach>
    </ul>

    <div id="delId" style="display:none">
      <fmt:message>mobile.a11y.removeMessage</fmt:message>
    </div>
  </c:if>
</dsp:page>
