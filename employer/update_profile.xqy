xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "../lib/common-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "../lib/employer-lib.xqy";
declare namespace emp="http://amityadav.name/employers";
declare option xdmp:mapping "false";

(:Check if the user is logged in:)
if (fn:not(elib:is-login())) then
	(:Redirect to the login page if the user id not logged in:)
	xdmp:redirect-response("/default.xqy") 		
else 
	(:Update the employer profile:)

	let $employer-node := elib:get-employer-details(xdmp:get-session-field("emp-id"))
	return

	if (fn:empty($employer-node)) then
		(
			xdmp:set-session-field("message", "Error updating the record!!!"),
			xdmp:redirect-response("/employer/profile") 
		)
	else
		let $status := elib:update-employer-node($employer-node, xdmp:get-request-field("company"), xdmp:get-session-field("emp-id"), xdmp:get-request-field("email"), xdmp:get-request-field("website"), xdmp:get-request-field("address1"), xdmp:get-request-field("address2"), xdmp:get-request-field("street"), xdmp:get-request-field("state"), xdmp:get-request-field("country"), xdmp:get-request-field("pin"))
		return
		
		 (xdmp:set-session-field("message", "Company profile update successfully"),
		  xdmp:redirect-response("/employer/profile") )