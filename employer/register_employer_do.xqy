xquery version "1.0-ml";
import module namespace glib = "http://amityadav.name/common-lib" at "/lib/common-lib.xqy";
import module namespace elib = "http://amityadav.name/employer-lib" at "/lib/employer-lib.xqy";
declare option xdmp:mapping "false";

if ((elib:is-login())) then
		 (:Redirect to the Employer Home Page:)
		xdmp:redirect-response("/employer")
else if(xdmp:get-request-field("register") = "1") then
  let $login := xdmp:get-request-field("login")
  let $password	:= xdmp:get-request-field("password")
  let $re-password := xdmp:get-request-field("re-password")
  let $company := xdmp:get-request-field("company")
  let $email := xdmp:get-request-field("email")
  return

  if ($login = "") then 
	(xdmp:set-session-field("message", "Provide an username"),
	xdmp:redirect-response("/employer/new"))
  else if (normalize-space($login) = "") then
   ( xdmp:set-session-field("message", "Provide an username"),
	xdmp:redirect-response("/employer/new"))
  else if (normalize-space($password) = "") then
    (xdmp:set-session-field("message", "Provide an password"),
	xdmp:redirect-response("/employer/new"))
  else if ($password != $re-password) then
    (xdmp:set-session-field("message", "The two password and re-password are not same"),
	xdmp:redirect-response("/employer/new"))
  else if (normalize-space($email) = "") then
    (xdmp:set-session-field("message", "Provide an email"),
	xdmp:redirect-response("/employer/new"))
  else 
	  let $add-employer := elib:add-employer(normalize-space($login), normalize-space($password), normalize-space($company), normalize-space($email))
	  return

	  if ($add-employer) then
		  (xdmp:set-session-field("message", "You have been successfully registered to the system"),
		  xdmp:redirect-response("/default.xqy") )
	  else  ()
else 
	xdmp:redirect-response("/employer/new")