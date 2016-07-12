          *****************************************
          -                                       -
          -     ResumeService Application         -
          -                                       -
          *****************************************
NOTE: BEST VIEWED IN MOZILLA FIREFOX

This application is designed to run on MarkLogic Server 4.1 and later.

To run the application, following things should be taken care off

a) MarkLogic Server installed,

b) Configure MarkLogic server as described below.



To set up the MarkLogic Server Configuration:

1) Create a forest (for example, named resumeservice).

2) Create a database (for example, named resumeservice).

3) Attach the forest to the database.

4) Create an HTTP App Server that accesses the new database. The following 
   are sample configuration values for the HTTP server (you can use these
   or choose different ones):

   server name:  resumeservice
   root:         resumeservice
   port:         8003
   modules:      filesystem
   database:     resumeservice

5) In the url rewriter text field add url_rewrite.xqy
   
6) Copy the files to 
   the App Server root on your host (for example, to the directory
   c:\Program Files\MarkLogic\resumeservice).

    NOTE: Make sure the user who executes this module has the necessary 
          prvileges to load documents into the database and to execute 
          the privileged functions in the script.  

7)  User should have following Execute Privileges- unprotected-uri ,xdmp:get-session-field,xdmp:set-session-field

8) You can now run the application by accessing the
    App Server root.  For example:

    http://localhost:8003/


About the application:
Resume Matching Service provides relevant jobs to candidates and provides employers relevant candidates.
Candidates can search for jobs based on skills as well as the system automatically pushes relevant jobs to the candidate.
On the other hand employers can add jobs and all the relevant candidates against the jobs posted will be pushed to the employer from the system.
Employers can search for candidates based on skills.

CANDIDATE:
- Candidate can register and create/update their CV
- Candidate views the list of jobs matching his/her skills automatically
- Candiates can view the details of the job
- Candidate has a search feature that enables them to search for a job against skills
- Comma separated skills can be provided in the search and all the jobs matching the skills will be listed

 
EMPLOYER
- Employers can register themselves
- Employers can edit their profile
- Employers can add/update new jobs 
- Employer can view all the candidates matching the skill set required for the job
- Employers can search candidates based on the skills and view their details profile


Enhancements
- Deletion of jobs
- Communication medium such as in-build mailbox can be added so that candidate and the employers can communicate
- Module that calculates and displayes the percentage of match between the candidate and the jobs can be added (Sorting jobs and candidates by relevancy)



The following files are included in the distribution:

//INSTRUCTION FILE
README.txt			Instruction file


default.xqy			Homepage for loggin into the app
url_rewrite.xqy			URL rewrite X Query File.

//LIBRARY MODULES
lib/candidate-lib.xqy		Library module for functions related to candidate
lib/common-lib.xqy XQuery	Library module for functions related to common activities
lib/employer-lib.xqy  XQuery	Library module for functions related to employer

//FILES RELATED TO CANDIDATE ACTIVITY
candidate/*

//FILES RELATED TO EMPLOYER ACTIVITY
employer/*

//SUPPORTING FILES
css/ CSS files
js/ JavaScript files
images/ Images files

Questions:  contact amit.yadav19@gmail.com
