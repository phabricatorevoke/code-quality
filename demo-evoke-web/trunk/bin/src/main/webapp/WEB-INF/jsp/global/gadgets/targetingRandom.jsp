<%--
  This gadget invokes the TargetingRandom droplet using the slot provided. Its
  used to return random promotional items from the slot.

  Required Parameters:
    targeter
      The targeter (or slot) to be used by the targeting droplet
   
    renderer
      The JSP page used to render the output
    
    elementName
      The name of the parameter that the targeting content should be placed into
   
  Optional Parameters:
    howMany
      The number of elements to show (defaults to 1)
    
    divId
      The id of surrounding div tag      
--%>

<dsp:page>
  
  <%-- Import Required Beans --%>
  <dsp:importbean bean="/atg/targeting/TargetingRandom"/>
  <dsp:importbean bean="/atg/store/catalog/ItemSiteFilter"/>

  <%-- Unpack dsp:params  --%>
  <dsp:getvalueof var="renderer" vartype="java.lang.String" param="renderer"/>
  <dsp:getvalueof var="howMany" vartype="java.lang.String" param="howMany"/>
  <dsp:getvalueof var="divId" vartype="java.lang.String" param="divId"/>
  <%--
    TargetingRandom is used to perform a targeting operation with the help
    of its targeter. We randomly pick an item from the array returned by the
    targeting operation.
  
    Input Parameters:
      targeter - Specifies the targeter service that will perform
                 the targeting
      howMany - If specified, indicates the maximum number of target items 
                to display (if the number of items returned by the targeting 
                operation is smaller, only that many items will be displayed).  
                If not specified, one item will be displayed.
      filter - Specifies an optional filter service that will filter items 
               returned by targeter before outputting them.
               Must be an instance of ItemFilter.
      fireViewItemEvent - Setting to false will prevent the ViewItemEvent from firing
  
    Open Parameters:
      output - At least 1 target was found
  --%>
  <dsp:droplet name="TargetingRandom">
    <dsp:param name="howMany" value="${empty howMany ? 1 : howMany}"/>
    <dsp:param name="targeter" param="targeter"/>
    <dsp:param name="fireViewItemEvent" value="false"/>
    <dsp:param name="elementName" param="elementName"/>
    <dsp:param name="filter" bean="ItemSiteFilter"/>
     
    <%-- If we were given a surrounding div id render a div --%>
    <dsp:oparam name="outputStart">
      <c:if test="${!empty divId}">
        <div id="${divId}">
      </c:if>
    </dsp:oparam>
    
    <%-- Render the output using the specified renderer --%>
    <dsp:oparam name="output">
      <dsp:include page="${renderer}"/>
    </dsp:oparam>
    
    <%-- If we were given a surrounding div id render a closing div --%>
    <dsp:oparam name="outputEnd">
      <c:if test="${!empty divId}">
        </div>
      </c:if>
    </dsp:oparam>
   
  </dsp:droplet>
</dsp:page>
<%-- @version $Id: //hosting-blueprint/B2CBlueprint/version/10.1.2/Storefront/j2ee/store.war/global/gadgets/targetingRandom.jsp#1 $$Change: 713790 $--%>
