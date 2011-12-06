declare default element namespace "http://www.w3.org/1999/xhtml";
<div id="page-content-wrapper">
    <div class="inner-page-title">
        <h2>Validating a complete form</h2>
        <span>Lorem ipsum dolor sic amet dixit tu</span>
    </div>
    <div class="column-content-box">
        <div class="content-box content-box-header ui-corner-all">
            <div class="ui-state-default ui-corner-top ui-box-header">
                <span class="ui-icon float-left ui-icon-notice"></span>
                Validating a form
            </div>
            <div class="content-box-wrapper">
                <form class="forms" id="signupForm" method="get" action="">
                    <fieldset>
                        <ul>
                            <li>
                                <label class="desc" for="firstname">Firstname</label>
                                <div><input id="firstname" class="field text full" name="firstname" /></div>
                            </li>
                            <li>
                                <label class="desc" for="lastname">Lastname</label>
                                
                                <div><input id="lastname" class="field text full" name="lastname" /></div>
                            </li>
                            <li>
                                <label class="desc" for="username">Username</label>
                                <div><input id="username" class="field text full" name="username" /></div>
                            </li>
                            <li>
                                <label class="desc" for="password">Password</label>
                                
                                <div><input id="password" class="field text full" name="password" type="password" /></div>
                            </li>
                            <li>
                                <label class="desc" for="confirm_password">Confirm password</label>
                                <div><input id="confirm_password" class="field text full" name="confirm_password" type="password" /></div>
                            </li>
                            <li>
                                <label class="desc" for="email">Email</label>
                                <div><input id="email" class="field text full" name="email" /></div>
                            </li>
                            
                            <li>
                                <input class="submit" type="submit" value="Submit"/>
                            </li>
                        </ul>
                    </fieldset>
                </form>
            </div>
        </div>
    </div>				
    <div class="clearfix"></div>
    <script type="text/javascript" src="/web/js/validate.js"></script>
    
    <script type="text/javascript"><![CDATA[
$().ready(function() {
	// validate the comment form when it is submitted
	$("#commentForm").validate();
	
	// validate signup form on keyup and submit
	$("#signupForm").validate({
		rules: {
			firstname: "required",
			lastname: "required",
			username: {
				required: true,
				minlength: 2
			},
			password: {
				required: true,
				minlength: 5
			},
			confirm_password: {
				required: true,
				minlength: 5,
				equalTo: "#password"
			},
			email: {
				required: true,
				email: true
			},
			topic: {
				required: "#newsletter:checked",
				minlength: 2
			},
		messages: {
			firstname: "Please enter your firstname",
			lastname: "Please enter your lastname",
			username: {
				required: "Please enter a username",
				minlength: "Your username must consist of at least 2 characters"
			},
			password: {
				required: "Please provide a password",
				minlength: "Your password must be at least 5 characters long"
			},
			confirm_password: {
				required: "Please provide a password",
				minlength: "Your password must be at least 5 characters long",
				equalTo: "Please enter the same password as above"
			},
			email: "Please enter a valid email address",
			agree: "Please accept our policy"
		}
		}


});
});
]]>
	</script>
</div>/*
