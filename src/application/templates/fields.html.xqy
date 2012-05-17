xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
declare namespace domain = "http://www.xquerrail-framework.com/domain";

import module namespace form = "http://www.xquerrail-framework.com/form-builder" at "/_framework/helpers/form-builder.xqy";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;

let $init := response:initialize($response)
let $domain-model := response:model()
return
    <div class="editPanel">{
        form:build-form($domain-model,$response)
    }</div>
