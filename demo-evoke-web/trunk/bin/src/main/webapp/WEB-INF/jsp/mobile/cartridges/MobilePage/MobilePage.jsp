<%--
  "MobilePage" cartridge renderer.

  Required Parameters:
    contentItem
      The "MobilePage" content item to render.

  Optional parameters:
    nav
      nav=true - The page and all the subpages are in "Refinement" mode.
                 Otherwise, the mode is considered as "Results list".
--%>
<dsp:page>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>

  <fmt:message var="pageTitle" key="mobile.search_searchResults.title"/> 
  <crs:mobilePageContainer titleString="${pageTitle}" >
  
    <jsp:attribute name="modalContent">
      <dsp:include page="${mobileStorePrefix}/global/gadgets/noSearchResults.jsp"/>
    </jsp:attribute>
  
    <jsp:body>
      <div id="switchBar"></div>

      <div id="main" style="display:none">
        <c:forEach var="element" items="${contentItem.MainContent}">
          <dsp:renderContentItem contentItem="${element}"/>
        </c:forEach>
      </div>

      <div id="secondary" style="display:none">
        <c:forEach var="element" items="${contentItem.SecondaryContent}">
          <dsp:renderContentItem contentItem="${element}"/>
        </c:forEach>
      </div>

      <script>
        $(document).ready(function() {
          CRSMA.global.initMobilePage();
        });
      </script>
    </jsp:body>
  </crs:mobilePageContainer>
</dsp:page>
