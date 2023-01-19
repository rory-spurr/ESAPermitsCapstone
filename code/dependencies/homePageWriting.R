# This webpage is helpful for formatting these lengthy paragraphs
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/



welcomeText <- tagList(
  tags$p("This platform summarizes and displays data collected by the National Marine 
         Fisheries Service (NMFS) on the permits they issue for scientific research that 
         may impact U.S. West Coast salmon, steelhead, eulachon, rockfish, or 
         sturgeon that are listed for protection under the Endangered Species Act (ESA)."),
  tags$br(),
  tags$image(src = "image/fishJumping.png", width = "50%", height = "50%"),
  tags$br(),
  tags$br(),
  tags$p("The app summarizes how much impact is occurring on ESA-listed fishes in particular
         areas. Users can choose what data to display to answer 
         specific questions, or learn about a species or region of interest."),
  tags$br(),
  tags$image(src = "image/mapGraph.png", width = "80%", height = "65%")      
)





backgroundText <- tagList(
  tags$p(strong("What is the ESA and how does it affect scientific research?")),
  tags$p("The Endangered Species Act (ESA) was enacted in 1973 to provide a policy 
      framework for the protection and conservation of threatened and endangered species:"),
  tags$ul(
    tags$li("Endangered species are species that are at risk of extinction throughout all or a 
        significant portion of its range."),
    tags$li("Threatened species are those that are likely to become an endangered species within 
        the foreseeable future throughout all or a significant portion of its range.")
    ),
    tags$p("The ESA prohibits take, which means to harass, harm, pursue, hunt, shoot, wound, kill, 
      trap, capture, or collect, or to attempt to engage in any such conduct (16 U.S.C. 1531-1544)."),
    tags$br(),
    tags$p("Research on ESA-listed species is important to understand their current extinction risk and 
      threats to recovery. The ESA therefore outlined exceptions to the prohibitions on take where 
      researchers can apply for permits to conduct studies on ESA-listed species:"),
    tags$ul(
      tags$li("Under section 10(a)(1)(A) of the ESA, for studies conducted by any entity that have a 
         bona fide scientific purpose and meet other key",
         tags$a("criteria", href = "https://www.govinfo.gov/app/details/CFR-2010-title50-vol7/CFR-2010-title50-vol7-sec222-308"),
         ", such as limiting harm or justifying the data need; or"),
      tags$li("Under section 4(d) of the ESA, for research that may take threatened species being conducted 
              by state agencies or tribes.")
    ),
    tags$p("Researchers apply for permits through the Authorizations and Permits for Protected Species", 
       tags$a("(APPS)", href = "https://apps.nmfs.noaa.gov/index.cfm"), # adds a hyperlink to APPS 
       " application, and NMFS personnel view this information and make permitting decisions based on the 
       expected harm the research will do to the species realtive to the value of the information that would be collected."),
  tags$br(),
  tags$p(strong("Why was this app developed?")),
  tags$p("Currently NMFS' West Coast Region does not have an easy way to map and visually summarize their research
         permitting information for internal use, or to share with applicants and co-managers.
         Therefore, the primary purpose of this project was to create an application that will:"),
  tags$ul(
    tags$li("Support the decision-making process for scientific research permits in NMFS' West
            Coast Region,"),
    tags$li("Provide more transparency to researchers as well as state and tribal governement employees
            about the permitting process, and"),
    tags$li("Educate the public about the role of research to inform
            the mangement of ESA-listed species.")
  ),
  tags$br(),
  tags$p(strong("References:"),
    tags$br(),
    "Endangered Species Act. 16 U.S.C. 1531-1544 (1973).",
    tags$br(),
    "National Marine Fisheries Service (NMFS). (2019). Chapter 3:  NMFS Pacific Marine/Anadromous Fish and 
    Invertebrates Scientific Research Authorizations and Oregon Scientific Take Permits. National Marine 
    Fisheries Service. 1315 East-West Highway Silver Spring, MD 20910.")
)

disclaimerText <- tagList(
  tags$p(strong("Terms of Use")),
  tags$p("Within our study, there are several limitations and assumptions we are using to develop our analyses. Below we will
         detail these limitations and assuptions for transparency and to allow the user to understand how we obtained
         our results"),
  tags$br(),
  tags$p(strong("Limitations and Assumptions")),
  tags$ul(
  tags$li("Data inputs - The permit application process has changed greatly since the database was created in 1994. 
          Therefore, there are data attributes that lack consistency and missing information. For example, early permit 
          applications were not required to enter specific information regarding location, HUC number, take action, and so on. 
          As we are aware of this, we will either provide a quality check to fill in gaps based on provided information or will 
          not include these values/permits into our project as they are not complete/missing necessary information. Additionally, 
          in the StreamName section, NOAA allowed permit applicants to provide the name of the waterbody they planned to work with. 
          As this is a textbox entry rather than a drop down with provided names, information on the same waterbody can be unnecessarily
          duplicated with alternative names or descriptions. Therefore, we manually adjusted the waterbody entries to ensure no duplication 
          occurred for waterbody names and to provide more consistency across the nomenclature. "),
  tags$li("Non-reported take - Under the data file WCRPermitBiOp_Pass report data 4d and S10_22March22.csv, researchers are 
          asked to report the actual take and mortality that occurred to ESA-listed species during the duration of their study. 
          However, some organizations or projects can opt out or neglect to report on the actual take and mortality. As a result, 
          these projects are not included in our analyses due to lack of data. Thus, a limitation of this unreported data is we 
          are missing total take and mortality data and therefore complicates further abundance data analysis."),
  tags$li("Changed HUC numbers - Over time, HUC 8 codes have been rearranged and their boundaries redrawn. 
          Many permits use old or outdated HUC 8 codes, causing issues when trying to map our permit data 
          using the Watershed Boundary Dataset (USGS et al. 2022). Therefore, HUC 8 codes had to be updated 
          to reflect any changes to their boundaries. Decisions were made using an unpublished document that 
          summarizes HUC 8 code changes up until 2018 (Hanson et al. 2018). Some of these changes ran on 
          assumptions using other fields (such as WaterbodyName or LocationDescription) and are detailed below:"),
  tags$br(),
        tags$pre(" \t \t# 18020103 = 18020156 # very certain"),
        tags$pre(" \t \t# 18020109 = 18020163 # very certain"),
        tags$pre(" \t \t# 18020112 = 18020154 # very certain based on location descriptions"),
        tags$pre(" \t \t# 18020118 = 18020154 # very certain based on location descriptions"),
        tags$pre(" \t \t# 18040005 = 18040012 # very certain based on location descriptions"),
        tags$pre(" \t \t# 18060001 = 18060015 # split between 18050006 as well, arbitrarily picked"),
        tags$pre(" \t \t# 18060012 = 18060006 # chose this over Monterey Bay as population is South-Central Cal Coast")),
  tags$br(),
  tags$p(strong("References:"),
         tags$br(),
         tags$li("U.S. Geological Survey (USGS), U.S. Department of Agriculture – Natural Resource Conservation Service 
         (NRCS), U.S. Environmental Protection Agency (EPA) (2022). USGS National Watershed Boundary Dataset 
         in FileGDB 10.1 format (published 20220526). Accessed May 15, 2022 at URL",
         tags$a("https://prd-tnm.s3.amazonaws.com/index.html?prefix=StagedProducts/Hydrography/WBD/National/GDB/",
                href = "https://prd-tnm.s3.amazonaws.com/index.html?prefix=StagedProducts/Hydrography/WBD/National/GDB/")),
         tags$li("Hanson, K., Daw, S., Davenport, L., Jones, K., Niknami, L., & Buto, S. (2018). Criteria for Legacy Name and Code Changes. [Unpublished]"))
)



