yr <- juveniles %>% filter(CommonName == "yelloweye rockfish")
yr$WaterbodyName


bocaccio <- juveniles %>% filter(CommonName == "bocaccio")
bocaccio$WaterbodyName

# seems like waterbody name would be easiest to use/incorporate into a map

theNAjuv <- juveniles %>% filter(is.na(HUCNumber) == T)
the89juv <- juveniles %>% filter(HUCNumber == 99999999)

theNAadult <- adults %>% filter(is.na(HUCNumber) == T)
the89adult <- adults %>% filter(HUCNumber == 99999999)

ggplot()+
  geom_sf(data = PS_bound, aes(fill = MarinBasin))

if (is.na(juveniles$HUCNumber) == T) {
  
}


# for NA value HUCs, the area is really all of the Puget Sound, so not quite sure how to handle that.