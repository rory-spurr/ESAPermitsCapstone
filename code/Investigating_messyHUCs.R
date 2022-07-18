yr <- juveniles %>% filter(CommonName == "yelloweye rockfish")
yr$WaterbodyName


bocaccio <- juveniles %>% filter(CommonName == "bocaccio")
bocaccio$WaterbodyName

# seems like waterbody name would be easiest to use/incorporate into a map

theNAjuv <- juveniles %>% filter(is.na(HUCNumber) == T)
the89juv <- juveniles %>% filter(HUCNumber == 99999999)

theNAadult <- adults %>% filter(is.na(HUCNumber) == T)
the89adult <- adults %>% filter(HUCNumber == 99999999)


# Change the "N/A" character string values to NA for computing ease
the89adult <- the89adult %>%
  mutate(across(c(WaterbodyName, StreamName), na_if, "N/A"))

waterbody.tab <- table(the89adult$WaterbodyName, the89adult$StreamName, useNA = T)
waterbody.tab

ggplot()+
  geom_sf(data = PS_bound, aes(fill = MarinBasin))

if (is.na(juveniles$HUCNumber) == T) {
  
}






