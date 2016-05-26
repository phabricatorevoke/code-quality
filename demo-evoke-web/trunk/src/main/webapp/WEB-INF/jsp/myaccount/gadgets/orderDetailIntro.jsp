<%-- 
  This page renders order state, submitted date, and site information 
  
  Required parameters:
    order
      the order to be rendered
      
  Optional parameters
    None      
--%>
<dsp:page>
  <dsp:importbean bean="/atg/core/i18n/LocaleTools"/>
  <dsp:importbean bean="/atg/dynamo/droplet/multisite/GetSiteDroplet"/>

    <dl class="atg_store_groupOrderInfo">
      <%-- Display the status of the order Like SUBMITTED,INCOMPLETE etc --%>
      <dt>
        <fmt:message key="common.status"/><fmt:message key="common.labelSeparator"/>
      </dt>
      
      <dd> 
        <dsp:include page="/global/util/orderState.jsp">
          <dsp:param name="order" param="order"/>
        </dsp:include>
      </dd>

      <%-- Submitted date --%>
      <dt>
        <fmt:message key="myaccount_orderDetail.placedOn"/><fmt:message key="common.labelSeparator"/>
      </dt>
      
      <dd class="atg_store_orderDate"> 
        <dsp:getvalueof var="submittedDate" vartype="java.util.Date" param="order.submittedDate"/>

        <dsp:getvalueof var="dateFormat" 
                        bean="LocaleTools.userFormattingLocaleHelper.datePatterns.shortWith4DigitYear" />   
                        
        <fmt:formatDate value="${submittedDate}" pattern="${dateFormat}" />
      </dd>
      
      <dt>
        <fmt:message key="myaccount_orderDetail.orderedOn"/><fmt:message key="common.labelSeparator"/>
      </dt>
      
      <dd>
        <%-- Site name --%>
        <dsp:droplet name="GetSiteDroplet">
          <dsp:param name="siteId" param="order.siteId"/>
          <dsp:oparam name="output">
            <dsp:valueof param="site.name"/>
          </dsp:oparam>
        </dsp:droplet>
      </dd>
    </dl>
</dsp:page>

<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/myaccount/gadgets/orderDetailIntro.jsp#1 $$Change: 713790 $--%>
