declare default element namespace "http://www.w3.org/1999/xhtml";
<div id="sub-nav">
    <div class="page-title">
        <h1><?title?></h1>
        <?if xdmp:get-current-user() = "validator-nobody"?>
        <span>Login using a regular ML security account</span>
        <?elseif?>
        <?breadcrumb?>
        <?endif?>
    </div>
</div>