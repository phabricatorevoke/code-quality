/**
 * MyAccount Javascript functions.
 * @ignore
 */
CRSMA = window.CRSMA || {};

/**
 * @namespace "MyAccount" Javascript Module of "Commerce Reference Store Mobile Application"
 * @description Holds functionality related to myaccount pages. 
 */
CRSMA.myaccount = function() {
  
  /**
   * This function shows states dropdown for selected country
   * 
   * @param {string} country a selected country
   * @param {string} state [optional] if specified then state will be preselected in the dropdown shown
   * @private
   */
  var toggleState = function(country, state) {
    var $currentState = $("select.state:visible");
    var $newState = $("select.state[data-country='"+country+"']");
    // important to add/remove the 'name' attribute from all selects;
    // otherwise, the URL becomes polluted with empty values
    var nameAttr = $currentState.attr("name");
    $("select.state").removeAttr("name");
    $currentState.val("").addClass("default").toggle();
    $newState.toggleClass("default", !(state && state != ""));
    $newState.val(state).attr('name', nameAttr).toggle();    
  };
  
  /**
   * Applies 'default' css style to select element if selected option is default one
   * 
   * @param e select element
   * @public
   */
  var changeDropdown = function(e){
    // we have to copy over the class from the 'option' to the 'select'
    // because Webkit will not honor styles applied to an option element
    var $this = $(e.currentTarget);
    $this.toggleClass("default", $("option:selected", $this).is('option:first-child'));
  };
  
  /**
   * Sets specified order id and submits a form.
   * 
   * @param {string} orderId ID of order
   * @public
   */
  var loadOrderDetails = function(orderId) {
    $("#orderId").attr("value", orderId);
    $("#loadOrderDetailForm").submit();
  };
  
  /**
   * Displays the full CRS modal redirect dialog. The link to the full CRS in the
   * dialog will contain the orderId parameter.
   * 
   * @param orderId an 'orderId' parameter value to add to the link to the full CRS site
   * @public
   */
  var toggleRedirectWithOrderId = function(orderId){
    var $modalDialog = $("#modalMessageBox");
    var link = $("a", $modalDialog);
    link.attr("href", CRSMA.global.addURLParam("orderId", orderId, link.attr("href")));
    $modalDialog.show();
    CRSMA.global.toggleModal(true);
    window.scroll(0,1);
  };
  
  /**
   * Attaches value from email input to the url value (email parameter)
   * 
   * @param {string} emailFieldId id of email input tag
   * @param {string} urlId id of url hidden tag
   * @public
   */
  var copyEmailToUrl = function(emailFieldId, urlId) {
    $('#' + urlId).val($('#' + urlId).val() + '&email=' + $('#' + emailFieldId).val());
  };
  
  /**
   * This function is a handler for country dropdown change event. It toggles
   * state dropdown and invokes standard handler.
   * 
   * @param event change event
   * @public
   */
  var selectCountry = function(event) {
    toggleState($(event.currentTarget).val());
    CRSMA.myaccount.changeDropdown(event);
  };
  
  /**
   * This function is a handler for state dropdown change event. It toggles state
   * dropdown and populate appropriate country in country dropdown
   * 
   * @param event change event
   * @public
   */
  var selectState = function(event) {
    var $countrySelect = $("#countrySelect");
    var state = $(event.currentTarget).val();
    var country = $("option:selected", event.currentTarget).attr("data-country");
    $("select.state:not(:visible)").removeAttr("name");
    if (country && country != "") {
      $countrySelect.val(country).removeClass("default");
      toggleState(country, state);
    }
    CRSMA.myaccount.changeDropdown(event);
  };
  
  return {
    'changeDropdown'           : changeDropdown,
    'copyEmailToUrl'           : copyEmailToUrl,
    'loadOrderDetails'         : loadOrderDetails,
    'selectCountry'            : selectCountry,
    'selectState'              : selectState, 
    'toggleRedirectWithOrderId': toggleRedirectWithOrderId
  }
}();
