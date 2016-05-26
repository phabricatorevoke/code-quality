<%--
  "SearchBox" cartridge renderer (mobile version).
  Renders a search box which allows the user to query for search results.

  Page includes:
    /mobile/includes/multisiteSearchPicker.jsp - Multisite menu renderer

  Optional parameters:
    Ntt 
      Search term (Endeca parameter).
--%>
<dsp:page>
  <%-- Request parameters - to variables --%>
  <dsp:getvalueof var="valueNtt" param="Ntt"/>

  <%-- "Search" block --%>
  <div class="searchBar">
    <%-- ========== "Search" form ========== --%>
    <dsp:form action="${siteContextPath}/browse" name="searchForm" id="searchForm">
      <dsp:include page="${mobileStorePrefix}/includes/multisiteSearchPicker.jsp"/>

      <input type="hidden" name="Dy" value="1"/>
      <input type="hidden" name="Nty" value="1"/>

      <fmt:message var="hintText" key="mobile.common.button.searchText"/>
      <input id="searchText" class="searchText" name="Ntt" type="text" autocomplete="off"
             placeholder="${hintText}" aria-label="${hintText}"
             value="${not empty valueNtt ? valueNtt : ''}"
             onfocus="CRSMA.search.searchOnFocus()" onblur="CRSMA.search.searchOnBlur()"/>
    </dsp:form>
  </div>
</dsp:page>
