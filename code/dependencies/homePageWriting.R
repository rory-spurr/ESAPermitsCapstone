# This webpage is helpful for formatting these lengthy paragraphs
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/



backgroundText <- list(
  # each p() call creates a new paragraph
  p("The Endangered Species Act (ESA) was created in 1973 to provide a policy framework for the protection 
    and conservation of threatened and endangered species (16 U.S.C. 1531-1544). Endangered species are species 
    that are “at risk of extinction throughout all or a significant portion of its range”, whereas threatened 
    species are those which are “likely to become an endangered species within the foreseeable future 
    throughout all or a significant portion of its range” (16 U.S.C. 1531-1544). The ESA protects species that 
    are listed as endangered or threatened from “take”, which is defined in section 3 of the ESA; it means “to 
    harass, harm, pursue, hunt, shoot, wound, kill, trap, capture, or collect [a listed species] or attempt to 
    engage in any such conduct” (16 U.S.C. 1531-1544). The ESA outlines these regulations, while also providing 
    some exceptions to the take prohibition. These exceptions specific to scientific research were created on 
    the basis that, to protect threatened and endangered species, research that will inform their conservation 
    or propagation should be allowed to occur for the conservation of that species. The two most notable 
    exceptions to the ESA that are pertinent to this project are under section 10(a)(1)(A) and section 4(d)."), 
  
  p("These two exceptions to the prohibition of taking of threatened and endangered species outlined in the ESA 
    differ in their scope and purpose. Section 10(a)(1)(A) allows the National Marine Fisheries Service (NMFS) 
    and U.S. Fish and Wildlife Service (USFWS) to “issue scientific research permits to enhance the propagation 
    or survival of a species listed as threatened or endangered, provided that there is a bona fide and 
    desirable scientific purpose to the research being conducted” (NMFS 2019). The exceptions under section 
    4(d) allow NMFS and USFWS to issue research authorizations to conserve species listed as threatened, and 
    mainly provides a streamlined and cooperative process for the state agencies to conduct research and 
    monitoring programs on threatened species (NMFS 2019). "),
  
  p("Researchers can apply to conduct scientific research from NMFS under these and other authorities through 
  the Authorizations and Permits for Protected Species application", 
  a("(APPS).", href = "https://apps.nmfs.noaa.gov/index.cfm"), # adds a hyperlink to APPS
  "APPS allows researchers to provide necessary information describing their research and its importance, and 
  after submitting it through the APPS portal, NMFS decides to grant the authorization or permit or reject the 
  application. NMFS collects and tracks information as to what permits, or authorizations are being issued where, 
  and how much take is authorized for what species and by which methods. Researchers also report the listed 
  species take that occurred during each year of their project through the APPS system. This information is kept
  in a database where data can be publicly accessed for individual issued permits, although currently there exists 
  no easily digestible central hub to view, interpret, and use this information. Thus, the purpose of this project 
  is to provide a readily available and informational framework that summarizes this critical information and puts 
  it into context for researchers, NMFS personnel, and other interested parties."),
  
  p(strong("References:"),
    br(),
    "Endangered Species Act. 16 U.S.C. 1531-1544 (1973).",
    br(),
    "National Marine Fisheries Service (NMFS). (2019). Chapter 3:  NMFS Pacific Marine/Anadromous Fish and 
    Invertebrates Scientific Research Authorizations and Oregon Scientific Take Permits. National Marine 
    Fisheries Service. 1315 East-West Highway Silver Spring, MD 20910."))



