(:@GENERATED@:)
xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";
declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;
let $init := response:initialize($response)
return
<div id="form-wrapper">
   <div class="inner-page-title">
      <h2>Create New <span class="formLabel">Countries</span>
      </h2>
   </div>
   <div class="content-box">
      <form id="form_country" name="form_country" method="post"
            action="/countries/save.html"
            onsubmit="return validateSave('form_country','country_table');">
         <ul class="editPanel">
            <li>
               <label class="desc">ISO Country Code:</label>
               <input class="field text small" name="countryCode" type="text" value=""/>
            </li>
            <li>
               <label class="desc">Country Name:</label>
               <input class="field text small" name="countryDescription" type="text" value=""/>
            </li>
            <li class="buttons">
               <a class="cnp-button" href="#"
                  onclick="return validateSave('form_country','country_table');">Create</a>
            </li>
         </ul>
      </form>
   </div>
   <div class="clearfix"/>
</div>