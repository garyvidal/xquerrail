xquery version "1.0-ml";

import module namespace js = "http://www.xquerrail-framework.com/helper/javascript" 
  at "/_framework/helpers/javascript.xqy";

import module namespace wijmo = "http://www.xquerrail-framework.com/helper/wijmo"
  at "/_framework/helpers/wijmo.xqy";
  
<div xmlns="http://www.w3.org/1999/xhtml">
  <table id="simple-grid"/>
  <script type="text/javascript">
  jQuery(function(){{{
    wijmo:grid("#simple-grid",())  
  }}});
  </script>
</div>
