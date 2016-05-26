<dsp:page>
  <dsp:getvalueof var="valueNtt" param="Ntt"/>
  
  <div id="noSearchResultsPopup">
    <ul class="dataList">
      <li><div class="content"><fmt:message key="mobile.search.refine.noResults"/></div></li>   
      <li class="icon-ArrowRight" role="link">
        <div class="content"><fmt:message key="mobile.search.refine.adjust"/></div>
      </li>
      <li class="icon-ArrowRight" onclick="document.location='${siteContextPath}/browse?Dy=1&Nty=1&Ntt=${valueNtt}&nav=true'" role="link">
        <div class="content"><fmt:message key="mobile.search.refine.clear"/></div>
      </li>
    </ul>
  </div>
</dsp:page>
