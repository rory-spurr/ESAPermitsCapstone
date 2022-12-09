# ESA_Permits_Capstone
Project repository for the Capstone entitled "Tracking ESA-listed Fish Species Research on the West Coast". Completed as part of the Master of Marine Affairs (MMA) Degree for the School of Marine and Environmental Affairs (SMEA) at the University of Washington (UW)

Contributors:
Rory Spurr and Alana Santana (SMEA MMA students) main contributors, Diana Dishman NOAA client and Anne Beaudreau SMEA advisor.

Project Goals:
Improve communication of the research permitting process under the ESA for researchers, co-managers, and the public. This will be accomplished by creating data products and communication tools that summarize ESA-listed fish research for the NOAA West Coast Region (WCR).

## ***Important: How to Run Scripts and Apps***
### The R project File:
In order to run the scripts within this repository, you must be working within the correct R project in order to have the correct working directory. In the first level of the 'ESA_Permits_Capstone' folder there will be an R project file called 'ESA_Permits_Capstone.Rproj'. It is important that you first open the project by clicking on this file, and then you can run each of the individual scripts themselves. To be certain you are working in the correct project, you can look in the top right of your Rstudio window and you should see 'ESA_Permits_Capstone'.

### Repository Organization:
1. Most of the R scripts are located inside of the 'code' folder, but there is one notable exception which is the 'Run2MakeLeafletApp.R'. This script creates the Leaflet map and table within a Shiny app, and is located in the top level of the repository. The reason being that in order for the 'Run App' button within Rstudio to work, this script must be in the top level of the repository. 
2. Aside from this exception, there are three sub directories within the 'code' folder that contain scripts of similar types. The sub directories are:
   - "main_scripts": this folder contains scripts that you should be actually running on your computer. Look here for scripts that create the various products we have created.
   - "dependencies": This folder contains all the scripts that read in data, organize the data, and create functions. No scripts from this folder will need to actually be run, because these scripts are run within the 'main_scripts' when they are needed.
   - "practice_and_notes": This folder contains many of the scripts that were practice when Alana and I were learning, as well as notes about the data that we may need. No scripts in this folder need to be run, but some useful information may be found here.
3. The 'data' folder hold all of the data needed to run the scripts.
4. The 'docs' folder contains documents relevant to the project, including data descriptions, pictures of our apps, excel tables that helped with QA/QC among other things.


an edit




