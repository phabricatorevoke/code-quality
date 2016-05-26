<%-- 
  This page lays out the elements that make up the search results page.
    
  Required Parameters:
    contentItem
      The content item - results list type 
   
  Optional Parameters:

--%>
<dsp:page>
  <dsp:importbean bean="/atg/commerce/catalog/CategoryLookup"/>
  <dsp:importbean bean="/atg/commerce/catalog/ProductLookup"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/SharingSitesDroplet"/>
  <dsp:importbean bean="/atg/store/sort/RangeSortDroplet" />
  <dsp:importbean bean="/atg/multisite/Site"/>
  <dsp:importbean bean="/atg/search/droplet/GetClickThroughId"/>
  <dsp:importbean bean="/OriginatingRequest" var="originatingRequest"/>
  <dsp:importbean bean="atg/projects/store/mobile/droplet/URLProcessor"/>

  <dsp:getvalueof var="shareableTypeId" param="shareableTypeId"/>
  <dsp:getvalueof var="filterByCatalog" param="filterByCatalog"/>

  <c:if test="${not empty shareableTypeId}">
  
    <%--
      Get a list of sites associated with the supplied shareable type.
      
      Input Parameters:
        shareableTypeId
          The shareable type that the list of sites returned will belong to.
  
      Open Parameters:
        output
          Serviced when no errors occur.
    
      Output Parameters:
        sites
          List of sites associated with the shareableTypeid.
    --%>
    <dsp:droplet name="SharingSitesDroplet">
      <dsp:param name="shareableTypeId" value="${shareableTypeId}"/>
      
      <dsp:oparam name="output">
        <dsp:getvalueof var="sites" param="sites"/>
      </dsp:oparam>
    </dsp:droplet>
  </c:if>

  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>
  <c:set var="recsPerPage" value="${contentItem.recsPerPage}"/>
  <c:set var="totalRecs" value="${contentItem.totalNumRecs}"/>
  <c:set var="initialPortionCount" value="${recsPerPage}"/>
  <c:if test="${recsPerPage > totalRecs}">
    <c:set var="initialPortionCount" value="${totalRecs}"/>
  </c:if> 
  
  <dsp:getvalueof var="p" param="p"/>
  <c:if test="${empty p}">
    <c:set var="p" value="1" />
  </c:if>

  <c:if test="${(not empty contentItem.categoryId)}">
  
    <div class="searchResults" data-results-list-count="${contentItem.totalNumRecs}">
     <div class="searchSectionHeader" style="display:none">
        <span class="searchSectionHeaderCaption">
          <span id="paginationInfo">1 - ${initialPortionCount} of ${totalRecs} <fmt:message key="mobile.search_searchResults.title"/></span>
        </span>
      </div>
      <ul class="searchResults">
        <%--
          Get the category repository object according to the id

          Input Parameters:
            id - The ID of the category we want to look up

          Open Parameters:
            output - Serviced when no errors occur
            error - Serviced when an error was encountered when looking up the category

          Output Parameters:
            element - The category whose ID matches the 'id' input parameter  
        --%>
        
        <dsp:droplet name="CategoryLookup">
          <dsp:param name="id" value="${contentItem.categoryId}"/>
          <dsp:param name="sites" value="${sites}"/>
          <dsp:param name="filterByCatalog" value="${not empty filterByCatalog ? filterByCatalog : 'true'}"/>
          <dsp:param name="filterBySite" value="true"/>

          <dsp:oparam name="output">
            <dsp:getvalueof var="productList" param="element.childProducts"/>
            <c:set var="productListSize" value="${fn:length(productList)}"/>

            <c:if test="${productListSize > 0}">
              <script>$('div.searchSectionHeader').show();</script>
            </c:if>
                        
            <c:set var="lastRecordIndex" value="${recsPerPage * p}" />
            
            <c:if test="${lastRecordIndex > productListSize}">
              <c:set var="lastRecordIndex" value="${productListSize}" />
            </c:if>            
            
            <dsp:droplet name="RangeSortDroplet">
              <dsp:param name="array" value="${productList}"/>
              <dsp:param name="sortSelection" value="${sort}"/>
              <dsp:param name="howMany" value="${recsPerPage}"/>
              <dsp:param name="start" value="${(p - 1) * recsPerPage + 1}"/>
             
              <%-- Product repository item is output --%>
              <dsp:oparam name="output">
                <dsp:setvalue param="product" paramvalue="element"/>
                <dsp:getvalueof var="item" param="product"/>
                <preview:repositoryItem item="${item}">
                  <li id="searchItem">
                    <dsp:include page="${mobileStorePrefix}/browse/gadgets/productListRow.jsp">
                      <dsp:param name="product" param="element"/>
                    </dsp:include>
                 </li>
                </preview:repositoryItem>
              </dsp:oparam>

              <%--Increase p-parameter value in request url --%>  
              <dsp:droplet name="URLProcessor">
                <dsp:param name="url" value="${pageContext.request.queryString}"/>
                <dsp:param name="parameter" value="p"/>
                <dsp:param name="parameterValue" value="${p + 1}"/>
                <dsp:oparam name="output">
                  <dsp:getvalueof var="element" param="element"/>
                  <c:set var="queryString" value="${element}"/>
                </dsp:oparam>
              </dsp:droplet>
              
              <%--Delete nav=true if it exists --%>
              <c:set var="queryString" value="${fn:replace(queryString, '&nav=true', '')}"/>
              
              <%-- Make url --%>
              <c:set var="url" value="${pageContext.request.requestURI}?${queryString}"/>
              
              <%-- Rendered once after all products have been output --%>
              <dsp:oparam name="outputEnd">
                <%-- Show pagination links --%>
                <dsp:include page="${mobileStorePrefix}/browse/gadgets/productListRangePagination.jsp">
                  <dsp:param name="lastRecordIndex" value="${lastRecordIndex}"/>
                  <dsp:param name="totalNumRecords" value="${contentItem.totalNumRecs}"/>
                  <dsp:param name="recordsPerPage" value="${recsPerPage}"/>
                  <dsp:param name="url" value="${url}"/>                  
                </dsp:include>
              </dsp:oparam>
            </dsp:droplet>
          </dsp:oparam>
        </dsp:droplet>
      </ul>
    </div>
  </c:if>
</dsp:page>