<%--
  This page renders all gift list's items.
  Input parameters:
    siteId
      ID of Site
  Output:
    label for site
--%>
<dsp:page>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>
  
  <dsp:getvalueof var="siteId" param="siteId"/>
  <br>
  <span class="otherStoreLabel"> 
    <dsp:droplet name="GetSiteDroplet">
      <dsp:param name="siteId" value="${siteId}" />
      <dsp:oparam name="output">
        <dsp:getvalueof var="site" param="site" />
        <fmt:message key="mobile.price.from" />
        <c:out value="${site.name}"></c:out>
      </dsp:oparam>
    </dsp:droplet>
  </span>

</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/mobile/browse/gadgets/otherStoreProductLabel.jsp#1 $$Change: 723120 $--%>
