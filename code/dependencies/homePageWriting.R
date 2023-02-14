# This webpage is helpful for formatting these lengthy paragraphs
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/

# ==========================
# Text for welcome page
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
  areas due to research. Users can choose what data to display to learn about projects on a 
  particular species or in a region of interest, or look at trends over time. It was created 
  to help NOAA staff see the ‘big picture’ view of research on the landscape, let researchers 
  learn about each other’s work, and make permitting decisions more transparent."),
  tags$br(),
  tags$image(src = "image/mapGraph.png", width = "80%", height = "65%")
)

# ==========================
# Text/video on instructional page
how2Text <- tagList(
  tags$video(id="videoID", width = "500px", height = "350px", type = "video/mp4", 
             src = "image/how2.mov", controls = "controls")
)


# ==========================
# Text for background and purpose page
backgroundText <- tagList(
  tags$p(strong("What is the ESA?")),
  tags$p("The Endangered Species Act (ESA) was enacted in 1973 to provide a policy 
      framework for the protection and conservation of threatened and endangered species:"),
  tags$ul(
    tags$li("Endangered species are species that are at risk of extinction throughout all or a 
        significant portion of its range."),
    tags$li("Threatened species are those that are likely to become an endangered species within 
        the foreseeable future throughout all or a significant portion of its range.")
    ),
    tags$p("The ESA prohibits take, which means to harass, harm, pursue, hunt, shoot, wound, kill, 
      trap, capture, or collect, or to attempt to engage in any such conduct (16 U.S.C. 1531-1544). 
           For more information, click",
    tags$a("here.", href = "https://www.fisheries.noaa.gov/national/endangered-species-conservation/endangered-species-act#section-4.-determination-of-endangered-species-and-threatened-species")),
    tags$br(),
    tags$p(strong("How does it affect scientific research?")),
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
       " application, and National Marine Fisheries Service (NMFS) personnel view this information and make permitting decisions based on the 
       expected harm the research will do to the species realtive to the value of the information that would be collected.
       For more information on permits and authorizations under section 10(a)(1)(A) and section 4(d), see ",
  tags$a("here.", href = "https://www.fisheries.noaa.gov/west-coast/endangered-species-conservation/endangered-species-act-permits-and-authorizations-west")),
  tags$br(),
  tags$p(strong("Why was this app developed?")),
  tags$p("Currently NMFS' West Coast Region does not have an easy way to map and visually summarize their research
         permitting information for internal use, or to share with applicants and co-managers.
         Therefore, students from the School of Marine and Environmental Affairs (SMEA) at the University of Washington (UW)
         were contracted with the primary purpose of developing an application that will:"),
  tags$ul(
    tags$li("Support the decision-making process for scientific research permits in NMFS' West
            Coast Region,"),
    tags$li("Provide more transparency to researchers as well as state and tribal government employees
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

# ==========================
# Text for general glossary page
glossText <- tagList(
  tags$p(strong("Acronyms")),
    tags$li("Evolutionarily significant unit (ESU): a population of organisms that is considered distinct for purposes of conservation."),
    tags$li("Distinct Population Segment (DPS): the smallest division of a taxonomic species permitted to be protected under the U.S. Endangered Species Act."),
    tags$li("Hydrologic Unit Code (HUC): A HUC is a hierarchical land area classification system created by the United States Geological Survey (USGS)."),
  tags$br(),
  tags$p(strong("Terms and Definitions")),
    tags$li("Take: Defined as any action that harasses, harms, pursues, hunts, shoots, wounds, kills, traps, captures, or collects, or attempts to engage in any such conduct."),
  tags$br(),
  tags$p(strong("Fish Glossary")),
    tags$p("Below are the names of the fish species that are included within this app."), 
    #Clicking on the species will take you to a link of the fish and ESA-status:"),
  tags$p(strong("Salmonids:")),
           tags$li("Chinook Salmon", em("(Oncorhynchus tshawytscha)")),
           tags$li("Coho Salmon", em("(Oncorhynchus kisutch)")),
           tags$li("Chum Salmon", em("(Oncorhynchus keta)")),
           tags$li("Sockeye Salmon", em("(Oncorhynchus nerka)")),
           tags$li("Steelhead Salmon", em("(Oncorhynchus mykiss)")),
  tags$p("For more information regarding salmonids and their listing statuses, see ",
         tags$a("here", href = "https://www.fisheries.noaa.gov/species/pacific-salmon-and-steelhead")),
  tags$p(strong("Rockfish and other species:")),
           tags$li("Boccaccio Rockfish",em("(Sebastes paucispinis)")),
           tags$li("Eulachon", em("(Thaleichthys pacificus)")),
           tags$li("Green Sturgeon", em("(Acipenser medirostris)")),
           tags$li("Yelloweye Rockfish", em("(Sebastes ruberrimus)")),
  tags$p("For more information regarding rockfish and other species, and their listing statuses, see ",
           tags$a("here", href = "https://www.fisheries.noaa.gov/species-directory/threatened-endangered?oq=&field_species_categories_vocab=1000000031&field_species_details_status=All&field_region_vocab=1000001126&items_per_page=25"))
           
)

# ==========================
# Text for use and limitations page
disclaimerText <- tagList(
  tags$p("Users of this app should be aware of the following limitations and assumptions regarding the raw data and data summaries:"),
  tags$p(strong("Things to know about this app")),
    tags$p("Note: These data are provisional, and are subject to change at any time. Additionally, 
            this app is specifically for ESA-listed fish species in the", 
           tags$a("west coast region", href = "https://www.fisheries.noaa.gov/about/west-coast-region"),
            "under NOAA jurisdiction. Therefore, ESA-listed fish species under the jurisdiction of the U.S. Fish and Wildlife
            Service or other federal and international organizations are not represented here."),
  tags$br(),
  tags$p("For the purpose of this project, some fields and data entries were modified to 
          simplify analyses and provide consistency across the nomenclature. These include:"),
  tags$li("Adjusting HUC 8 codes to encompass redrawn boundaries; see",
    tags$a("metadata", href = "https://github.com/rory-spurr/ESAPermitsCapstone/tree/main/docs/Metadata"),
    "for details"),
  tags$li("Renaming and classifying waterbodies in the 'WaterbodyName' field to allow for consistent
          nomenclature and inform users about the type of waterbodies (saltwater or freshwater) these species exist in. 
          Renaming practices were performed using best available data provided by the 'LocationDescription' field."),
  tags$li("Reclassifying 'Lifestage' and 'Production' fields to reduce the number of unique entries."),
  tags$ul(
    tags$li("Ex. 'Smolt' was replaced by 'Juvenile'"),
    tags$li("Ex. 'Listed Hatchery, Clipped and Intact' was replaced by 'Listed Hatchery'")
  ),
  tags$br(),
  tags$p(strong("Limitations and Omissions")),
    tags$p("This project encountered a few limitations in which the developers had no control over. 
           These limitations include:",
      tags$li("Unreported take from researchers failing to complete exit reports.")),
    tags$p("To maintain scope and presentation of the data within this project, the following was either excluded or modified:",
      tags$li("Unlisted hatchery, observe/harass, observe/sample dead tissues, unknown take action, 
              permits with ocean polygons, tribal 4d, etc.")),
  tags$br(),
  tags$p(strong("Metadata - To be edited")),
    tags$p("For further information regarding the data source, data attributes, 
         R packages used, and general metadata for this project, please visit the 
          metadata folder of our Github ",
    tags$a("here.", href = "https://github.com/rory-spurr/ESAPermitsCapstone/tree/main/docs/Metadata")), 
  tags$br(),
  tags$p(strong("How to Cite - To be edited")), #no idea how to cite our project
  tags$br(),
  tags$p(strong("License Statement")),
    tags$p("Copyright © 2007 Free Software Foundation, Inc.",
    tags$a("<https://fsf.org/>", href = "https://fsf.org/"),
    tags$p("Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.")),
  tags$br(),
  tags$br(),
  tags$image(src = "image/download.png", width = "20%", height = "20%", align = "center"),
  tags$p(strong("Acknowledgements")),
    tags$p("We thank Diana Dishman for her conceptualization of the project, expert technical 
    guidance surrounding the permitting process and editing and critiquing drafts of the application. 
    We also want to thank Anne Beaudreau for her help editing and critiquing drafts of the 
    application, as well as the professional and technical guidance she has shown us throughout 
    our time in grad school. We want to thank both NOAA’s west Coast permit and communications 
    teams for taking the time to meet with us and help with the application. Funding for this 
    project was provided through NOAA, as well as the Jay Ginter Memorial Scholarship Fund at 
    the University of Washington.")
  )

# ==========================
# Text for about Map section
aboutMapTxt <- tags$p("The map displays total authorized take (or total lethal take depending on what data 
       is selected to display), for each Hydrologic Unit Code 8 (HUC 8). The black outline shows
       all the possible HUC 8's where these species may be encountered. Individual HUC 8's may be
       clicked on inside the map to reveal more information for the HUC, including specific 
       authorized take values.")

# ==========================
# Text for Map table caption
tblCaptText <- tagList(
  tags$p("This table displays the raw data from the map above. The fields 
         within this table are defined as:"),
  tags$li("Permit Code: The code automatically assigned by the APPS system and used in correspondence about the application.
          Can be searched on APPS to learn more about an individual permit."),
  tags$li("Permit Type: Indicates the kind of permit or authority ",
          tags$a("(more detail here).", href =  "https://www.fisheries.noaa.gov/west-coast/endangered-species-conservation/endangered-species-act-permits-and-authorizations-west")),
  tags$li("Organization: Entity in charge of research operations."),
  tags$li("HUC 8: Hydrologic Unit 8 (HUC 8) code where research is taking place."),
  tags$li("Location: Name or description of research location."),
  tags$li("Water Type: Whether the research is happening in freshwater (FW) or saltwater (SW)."),
  tags$li("Take Action: Action taken to capture/tag/kill animal."),
  tags$li("Gear Type: Gear used to capture species."),
  tags$li("Total Take: Total amount of take authorized. Includes both lethal and non-lethal take."),
  tags$li("Lethal Take: Total amount of fish mortality authorized.")
)

# ==========================
# Text for time series glossary
TSglossText <- tagList(
  tags$p("This table displays the raw data from the plots above. The fields 
         within this table are defined as:"),
    tags$li("Year: The year field indicates the year that each permit was issued."),
    tags$li("Report ID: A five-digit unique code for each active project that reported take and mortality within their research."),
    tags$li("Permit Code: The code automatically assigned by the APPS system and used in correspondence about the application."),
    tags$li("Permit Type: Indicates the kind of permit or authority ",
            tags$a("(more detail here).", href =  "https://www.fisheries.noaa.gov/west-coast/endangered-species-conservation/endangered-species-act-permits-and-authorizations-west")),
    tags$li("Gear Type: Gear used to capture species."),
    tags$li("Authorized Take: Predicted and allocated number of individuals the project expects to take as a result of research. Includes numbers from lethal and non-lethal take."),
    tags$li("Reported Take: The number of individuals reportedly taken as a result of research. Includes numbers from lethal and non-lethal take."),
    tags$li("Unused Take: The number of take that was allocated but went unused by the researcher. The difference between the authorized number and the reported number."),
    tags$li("Authorized Mortality: Predicted and allocated number of individuals the project expects to kill as a result of research. Includes ONLY lethal take."),
    tags$li("Reported Mortality: The number of individuals reportedly killed as a result of research. Includes ONLY lethal take."),
    tags$li("Unused Mortality: The number of lethal take that was allocated but went unused by the researcher. The difference between the authorized number and the reported number.")
)

# Text for user boxes
# ==========================

# Rory
roryText <- tagList(
  p("Rory Spurr has worn many hats throughout his life, working as a fisheries scientist, in research
    and development for a fish passage company, and most recently as an R programmer. Rory will graduate with 
    his Master's in March and would love for someone to hire him ASAP."),
  tags$br(),
  h1(strong("Contact Info:"), style = "font-size:25px"),
  p(tags$a("Website", href = "https://rory-spurr.github.io/")),
  p("Github: ", tags$a("rory-spurr", href = "https://github.com/rory-spurr")),
  p("Email: rjspurr5@live.com")
)

# =========================

# Alana 
alanaText <- tagList(
  p("~Insert profile here~"),
  tags$br(),
  h1(strong("Contact Info:"), style = "font-size:25px"),
  p("Github: ", tags$a("asantan8", href = "https://github.com/asantan8")),
  p("Email: asantan7@uw.edu")
)








