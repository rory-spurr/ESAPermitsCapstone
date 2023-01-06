# This webpage is helpful for formatting these lengthy paragraphs
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/



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
    Fisheries Service. 1315 East-West Highway Silver Spring, MD 20910."))

disclaimerText <- tagList(
  tags$p("Hello")
  )



