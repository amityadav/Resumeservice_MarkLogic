xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "/lib/common-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "/lib/employer-lib.xqy";
declare option xdmp:mapping "false";

if ((elib:is-login())) then
		 (:Redirect to the employer Home Page:)
		xdmp:redirect-response("/candidate")
else if(xdmp:get-request-field("login") and xdmp:get-request-field("password") and xdmp:get-request-field("validate")) then 
		if(normalize-space(xdmp:get-request-field("login")) = "") then
			<span>
				<div>
					Provide an username
				</div>
			</span>
		else if(normalize-space(xdmp:get-request-field("password")) = "") then
			<span>
				<div>
					Provide a password
				</div>
			</span>
		else if(elib:is-candidate-registered(xdmp:get-request-field("login"), xdmp:get-request-field("password"))) then
			(:Redirect to the Candidate Home Page:)
		    xdmp:redirect-response("/candidate") 
		else ()	
else 
	xdmp:redirect-response("/candidate") 