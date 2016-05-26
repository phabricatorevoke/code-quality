<dsp:page>
  <dsp:getvalueof var="contentItem" vartype="com.endeca.infront.assembler.ContentItem" value="${originatingRequest.contentItem}"/>
  <c:if test="${contentItem.enabled}">
    <div class="refinementFacetGroupContainer">
      <span class="refinementFacetGroupName">
        <fmt:message key="mobile.price"/>
      </span>
      <ul class="refinementDataList">
        <li>
          <div class="content" id="price-range-filter">
            <span id="labelLow" style="display:none"><fmt:message key="mobile.priceslider.lowbound"/></span>
            <span id="labelHigh" style="display:none"><fmt:message key="mobile.priceslider.highbound"/></span>
            $<span class="price" id="minPrice"></span>
            <span class="priceDelimeter">-</span>
            $<span class="price" id="maxPrice"></span>
            <div class="slider-wrapper">
              <div class="range-pin range-min-value" style="left:50px;" role="slider" aria-labelledby="labelLow" aria-controls="minPrice"></div>
              <div class="range-pin range-max-value" style="right:100px;" role="slider" aria-labelledby="labelHigh" aria-controls="maxPrice"></div>
              <div class="active-range" style="left:50px;"></div>
            </div>
          </div>
        </li>
      </ul>
    </div>
    <script type="text/javascript">
      $(function() {
        CRSMA.search.initRangeFilter($('#price-range-filter'),
          {min: parseFloat('${contentItem.sliderMin}'), max: parseFloat('${contentItem.sliderMax}')},
          {min : parseFloat('${contentItem.filterCrumb.lowerBound}'), max: parseFloat('${contentItem.filterCrumb.upperBound}')},
          "${contentItem.priceProperty}");
      });
    </script>
  </c:if>
</dsp:page>
