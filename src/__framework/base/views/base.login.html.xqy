(:@GENERATED@:)
xquery version "1.0-ml";
declare default element namespace "http://www.w3.org/1999/xhtml";
import module namespace response = "http://www.xquerrail-framework.com/response" at "/_framework/response.xqy";

declare option xdmp:output "indent-untyped=yes";
declare variable $response as map:map external;
let $init := response:initialize($response)
return
<div id="login" xmlns="">
    <h3>Log In</h3>
    <!--  Current user: {xdmp:get-current-user()} -->
    <form action="" method="post">
        <div class="loginitems">
            <label for="user">User</label>
            <input type="text" name="user"/>
            <br/>
            <label for="password">Password</label>
            <input type="password" name="password"/>
            <br/>
            <input type="submit" class="submit" value="Log In"/>
        </div>
    </form>
</div>
