xquery version "1.0-ml";
(:
 : This library contains functions related to employer operations
 : This also contains function related to Adding/Updating the jobs
 : 
 : Author:
 : Amit Yadav <amit.y@glballogic.com>
 : Date: 05 NOV 2009
:)

module namespace clib = "http://amityadav.name/candidate-lib";
declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare namespace cd="http://amityadav.name/candidates";
declare namespace emp="http://amityadav.name/employers";

declare variable $candidate-dir := ( "/candidates-data/" );
declare variable $user-id  := ( "/candidates-data/ids.xml" );
declare variable $candidate-base :=( "/candidates-data/candidates" );

declare variable $jobs-dir := ( "/jobs-data/" );
declare variable $employer-base :=( "/employers-data/employers" );



(:
	Check whether the user is logged in to the system or not
:)
declare function clib:is-login()
{
	if(xdmp:get-session-field("candidate")) then
		true()
	else
		false()
};


(:
	Function to display candidate header
:)
declare function clib:display-candidate-header($username)
{
	let $home :=
		if(xdmp:get-request-path() eq "/candidate/candidate-home.xqy") then 
		 "item_active"
		else ""
	return

	let $profile :=
		if((xdmp:get-request-path() eq "/candidate/view_profile.xqy") or (xdmp:get-request-path() eq "/candidate/edit_profile.xqy")) then 
		 "item_active"
		else ""
	return

	let $jobs :=
		if((xdmp:get-request-path() eq "/candidate/candidate_jobs.xqy") or (xdmp:get-request-path() eq "/employer/view_job.xqy")) then 
		 "item_active"
		else ""
	return


	<div id="header">
		<div class="logo"><a href="#"><img src="/images/logo.gif" border="0" /><h2>Resume Service</h2></a></div>
		
		<div class="alliancelogo">
			<div class="floatright">
				<span class="bold">Search Jobs based on Skills</span>
				<form action="/candidate/search_job.xqy" id="job_search" method="post">
					<input type="text" value="{xdmp:get-request-field('q')}" name="q" id="q" class="searchtextfield"/>
						<a onclick="$('job_search').submit();" href="javascript:void(0);">
							<img width="27" height="24" align="left" src="/images/icon-search.gif" alt="Search"/>
						</a>
				</form>
				<script>
					<![CDATA[
						var search1 = new LiveValidation('q');
						search1.add( Validate.Presence, {faliureMessage: "Search text can not be empty"});
					]]>
				</script>
			</div>
		</div>

		<div class="clearer"></div>
		<div id="tab">
			<ul>
				<li class="{$home}" ><a href="/candidate"><span class="tab-coach">Home</span></a></li>
				<li class="{$profile}"><a href="/candidate/profile"><span class="tab-coach">Profile</span></a></li>
				<li class="{$jobs}"><a href="/candidate/jobs"><span class="tab-coach">Jobs</span></a></li>
				<li><span class="tab-image-link"></span></li>	
			</ul>
		</div>
		<div class="floatright">
			<span>Welcome <span class="bold">{$username}</span> </span> &nbsp;| &nbsp;<a href="/candidate/logout"><span class="topnav-text-link bold">Logout</span></a>
		</div>
		<div class="clearer"></div>
	</div>
  
};


(:
	Link to the candidate home
:)
declare function clib:candidate-home()
{
    <div>
     <a href="/candidate">Candidate Dashboard</a>
	</div>
};



(:
	Function to display candidate profile
:)
declare function clib:display-candidate-profile($candidate)
{
	(<div class="profile">
		<div class="float-right">
			<a href="/candidate/edit" class="bold">
				Edit Profile
			</a>
		</div>
		<span class="green1">Profile Information</span>
		<div class="height5"/>
		<div class="textheading1">Username</div>
		<div class="formfield2">{$candidate/cd:login/text()}</div>
		
		<div class="height7"/>
		<div class="textheading1">Name</div>
		<div class="formfield2">{$candidate/cd:fname/text(), " ", $candidate/cd:lname/text()}</div>

		<div class="height7"/>
		<div class="textheading1">Email</div>
		<div class="formfield2">{$candidate/cd:email/text()}</div>

		<div class="height7"/>
		<div class="textheading1">Resume Title</div>
		<div class="formfield2">{$candidate/cd:resume/cd:resume-title/text()}</div>

		<div class="height7"/>
		<div class="textheading1">Skills</div>
		<div class="formfield2">{$candidate/cd:resume/cd:skills/text()}</div>

		<div class="height7"/>
		<div class="textheading1">Experience</div>
		<div class="formfield2">{$candidate/cd:resume/cd:experience/text()}</div>

		<div class="height7"/>
		<div class="textheading1">Summary</div>
		<div class="formfield2">{$candidate/cd:resume/cd:summary/text()}</div>
		
		<div class="height7"/>
		<div class="textheading1">Last Updated</div>
		<div class="formfield2">{fn:adjust-date-to-timezone(xs:date(fn:adjust-dateTime-to-timezone($candidate/cd:date/text())))}</div>
		<div class="height7"/>
		<div class="height20"/>
	</div>)
};



(:
	Function to calculate the next incremental id for the new candidate record
:)
declare function clib:next-id() as xs:integer
{
  let $id := doc($user-id)/id
  let $next-val :=
    if ($id castable as xs:integer) then xs:integer($id) + 1
    else 1
  let $next-node := <id>{$next-val}</id>
  let $insert :=
    if ($id) then xdmp:node-replace($id, $next-node)
    else xdmp:document-insert($user-id, $next-node)
  return $next-val
};



(:
	Function to insert new candidate
:)
declare function clib:add-candidate($login as xs:string,
                        $password as xs:string,
                        $email as xs:string)
{
  if ($login = "") then error("Username missing") else
  if ($password = "") then error("Password cannot be blank") else
  if ($email = "") then error("Email cannot be blank") else

  let $candidate-id := clib:next-id()
  let $new-candidate := 
    <cd:candidate id="{$candidate-id}">
		<cd:login>{$login}</cd:login>
		<cd:password>{$password}</cd:password>
		<cd:email>{$email}</cd:email>
		<cd:fname></cd:fname>
		<cd:lname></cd:lname>
		<cd:resume>
			<cd:resume-title></cd:resume-title>
			<cd:experience></cd:experience>
			<cd:skills></cd:skills>
			<cd:summary></cd:summary>
		</cd:resume>
		<cd:date>{current-dateTime()}</cd:date>
    </cd:candidate>

  let $insert := xdmp:document-insert($candidate-base, <candidates xmlns:cd="http://amityadav.name/candidates">{doc($candidate-base)//cd:candidate, $new-candidate}</candidates>)
  return $new-candidate
};



(:
	Function to authenticate candidate
:)
declare function clib:is-candidate-registered($username as xs:string, $password as xs:string)
{
  for $user in xdmp:directory($candidate-dir)//cd:candidate[cd:login=$username and cd:password=$password]
  return

  if($user/@id) then
  (
	(:Set the user in the session:)
		xdmp:set-session-field("candidate", "1") ,
		xdmp:set-session-field("user-id", $user/@id),
	    true()
  )
  else
    false()
};



(:
	Get the candidate details provided the candidate ID
:)
declare function clib:get-candidate-details($id)
{
  for $candidate in xdmp:directory($candidate-dir)//cd:candidate[@id=$id]
  return $candidate
};



(: 
	Update a node with the specified elements 
:)
declare function clib:update-node($root, $changes) {

  element { node-name($root) }
  { 
    $root/@*,

    for $ele in $root/*
      let $new := $changes[node-name(.) = node-name($ele)]
      return if (empty($new)) then $ele else $new
  }
};



(:
	Function to update the candidate profile
:)
declare function clib:update-candidate-node($oldCandidate as element(cd:candidate), 
						$fname as xs:string,
                        $candidate-id as xs:string,
                        $lname,
                        $resume-title as xs:string,
                        $skills as xs:string,
                        $experience as xs:string,
                        $summary as xs:string,
                        $email) as element(cd:candidate)
{
	let $updated-candidate-node := clib:update-node($oldCandidate, (
			<cd:email>{$email}</cd:email>,
			<cd:fname>{$fname}</cd:fname>,
			<cd:lname>{$lname}</cd:lname>,
			(<cd:resume>
				<cd:resume-title>{$resume-title}</cd:resume-title>
				<cd:experience>{$experience}</cd:experience>
				<cd:skills>{$skills}</cd:skills>
				<cd:summary>{$summary}</cd:summary>
			</cd:resume>),
			<cd:date>{current-dateTime()}</cd:date>

    ))

  let $replace := xdmp:node-replace($oldCandidate, $updated-candidate-node)
  return $updated-candidate-node

};





(:
	---------------------------------------------
	Functions for jobs matching criteria
	---------------------------------------------
:)

(: Function to get the matching jobs accordig to the skills and the summary :)

declare function clib:get-matching-jobs($phrase) as element()* 
{
	cts:search(
		xdmp:directory($jobs-dir)//emp:job,
        cts:or-query((
				for $token in fn:tokenize($phrase, ",")
				return (
							cts:element-word-query(xs:QName("emp:title"), fn:normalize-space($token)), 
							cts:element-word-query(xs:QName("emp:skill"), fn:normalize-space($token)), 
							cts:element-word-query(xs:QName("emp:summary"), fn:normalize-space($token))
						)
		))
	)
};



(: 
	Function to pint comma separated skills 
:)
declare function clib:print-skill($skills)
{
	for $skill  in $skills/emp:skill
    return 
        (
			<a href="/candidate/search_job.xqy?q={$skill/text()}">{fn:normalize-space($skill/text())}</a>,
			if (fn:not($skill/text() eq $skills/emp:skill[last()]/text())) then 
				text {', '}
			else 
				text { }
		)
};



(: 
	Function to dialpay all the matching jobs listing
:)

declare function clib:display-matching-jobs($jobs as element(emp:job)) as element()* {
	<div class="" id="job-{$jobs/@id}"  xmlns="http://www.w3.org/1999/xhtml">
		<span class="fromheading navyblue-normal">
			<a href="/employer/job/{$jobs/@id}">
				{$jobs/emp:title/text()}
			</a>
		</span>
					
		<span class="subjectheading navyblue-normal">
				{
					for $skill in $jobs/emp:skills
					return clib:print-skill($skill)
				}
		</span> 
					
		<span class="dateheading black11">
			{fn:adjust-date-to-timezone(xs:date(fn:adjust-dateTime-to-timezone($jobs/emp:date/text())))}
		</span> 
					
		<span class="actionsheading">
			{$jobs/emp:experience/text()} Years
		</span>
		<div class="height5"></div>
		<div class="hr3"></div>
		<div class="height3"></div>
	</div>
};