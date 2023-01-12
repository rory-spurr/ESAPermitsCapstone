# This webpage is helpful for formatting these lengthy paragraphs
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/



welcomeText <- tagList(
  tags$p("This platform displays and summarizes data collected by the National Marine 
         Fisheries Service (NMFS) on the permits they issue for scientific research that 
         may impact threatened or endangered salmon, steelhead, eulachon, rockfish, or 
         sturgeon."),
  tags$br(),
  tags$image(src = "image/fishJumping.png", width = "75%", height = "75%"),
  tags$br(),
  tags$p("The app displays totals as to how much impact is occurring, on what species, 
         and where it is occurring. Users can choose what data to display to answer 
         specific questions, or learn about a species or region of interest."),
  tags$div(class = "row",
    tags$div(class = "column",
      tags$image(src = "image/map.png", width = "50%", height = "50%")      
    ),
    tags$div(class = "column",
      tags$image(src = "image/graph.png", width = "50%", height = "50%")
    )
  )
)





backgroundText <- tagList(
  tags$p(strong("Background")),
  tags$p("The Endangered Species Act (ESA) was created in 1973 to provide a policy 
      framework for the protection and conservation of threatened and endangered species:"),
  tags$ul(
    tags$li("Endangered species are species that are at risk of extinction throughout all or a 
        significant portion of its range."),
    tags$li("Threatened species are those which are likely to become an endangered species within 
        the foreseeable future throughout all or a significant portion of its range.")
    ),
    tags$p("The ESA then protects threatened and endangered species from “take” which essentially 
      means harm or harassment to the species."),
    tags$br(),
    tags$p("Research on ESA-listed species is important to understand their biology, population size, 
      etc. Since take is likely to occur during research, the ESA outlined exceptions to the no-take policy 
      where researchers can apply for permits to do research on ESA-listed species:"),
    tags$ul(
      tags$li("Under section 10(a)(1)(A), NMFS authorizes scientific research permits for studies with a 
         bona fide scientific purpose."),
      tags$li("Under section 4(d) NMFS has created a streamlined procedure for research permits on 
         threatened species being conducted by state or tribal government agencies.")
    ),
    tags$p("Researchers apply for permits through the Authorizations and Permits for Protected Species", 
       tags$a("(APPS)", href = "https://apps.nmfs.noaa.gov/index.cfm"), # adds a hyperlink to APPS 
       " application, and NMFS personnel view this information and make permitting decisions based on the 
       expected harm the research will do to the species."),
  tags$br(),
  tags$p(strong("Purpose")),
  tags$p("Currently NMFS does not have an easily digestable way to view their permitting information.
         Therefore, the primary purpose of this project was to create an application through R shiny using 
         NMFS permitting information, with the hopes that this application will:"),
  tags$ul(
    tags$li("Help aid in the decision-making process for scientific research permits in the West
            Coast region"),
    tags$li("Provide more transparency to researchers as well as state and tribal governement employees
            about the permitting process."),
    tags$li("Educate the public about the importance of the ESA and conducting research to inform
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
         tags$br(),
         tags$li("Hanson, K., Daw, S., Davenport, L., Jones, K., Niknami, L., & Buto, S. (2018). Criteria for Legacy Name and Code Changes. [Unpublished]"))
)



