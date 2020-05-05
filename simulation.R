rm(list = ls())

source("packages.R")

datapath <- "H:/Miete und Energie/Temp/"
datapath_ho <- "/Users/kgoebler/Desktop/Miete und Energie Projekt/temp/"
data <- import(paste(datapath_ho, "temp2.dta", sep = "/"))

data <- filter(data, hhnet_initial > 0 & !is.na(hhnet_initial)) #& notrücklagen == 0)

seq <- 0:500

# HH-nettoeinkommen
inc <- data$hhnet_initial

inc.mat <- sapply(1:length(seq), function(i) inc - seq[i]) 

for (c in 1:ncol(inc.mat)){
  inc.mat[,c] <- ifelse(inc.mat[,c] < 0, 0,inc.mat[,c])  
}

# Alle Verlustscenarien von 0 bis 500€
inc.mat <- as.data.frame(inc.mat)

# Eine variable für Bruttokalt
data$bruttokalt <- ifelse(data$hgrent > 0 & !is.na(data$hgrent) & data$owner == 0 & data$hgowner == 2, data$hgrent,
                          ifelse(data$owner == 1 & data$belastet == 1 & data$zinshoehe > 0 & !is.na(data$zinshoehe) & data$nebenkosten > 0 & !is.na(data$nebenkosten), data$zinshoehe + data$nebenkosten, 
                              ifelse(data$owner == 1 & data$belastet == 0 & data$nebenkosten > 0 & !is.na(data$nebenkosten), data$nebenkosten,NA)))

# Eine variable für gesamte Wohnkosten
data$wohkosten <- ifelse(data$bruttokalt > 0 & !is.na(data$bruttokalt) & data$hgheat > 0 & !is.na(data$hgheat) & data$hgelectr > 0 & !is.na(data$hgelectr) & data$owner == 0 & data$hgowner == 2, data$bruttokalt + data$hgheat + data$hgelectr,
                          ifelse(data$owner == 1 & data$bruttokalt > 0 & !is.na(data$bruttokalt) & data$heizkosten > 0 & !is.na(data$heizkosten) & data$stromkosten > 0 & !is.na(data$stromkosten), data$bruttokalt + data$heizkosten + data$stromkosten, NA)) 


wohnk_bruttok.mat <- matrix(nrow = nrow(data), ncol = length(seq)) 

# Bruttokalte Belastungsquote
for (c in 1:length(seq)){
  wohnk_bruttok.mat[,c] <- data$bruttokalt / inc.mat[,c] * 100
  wohnk_bruttok.mat[,c] <- ifelse(data$bruttokalt >= inc.mat[,c], 100, wohnk_bruttok.mat[,c])
}

wohnk.mat <- matrix(nrow = nrow(data), ncol = length(seq)) 

# Gesamte Wohnkostenbelastungsquote
for (c in 1:length(seq)){
  wohnk.mat[,c] <- data$wohkosten / inc.mat[,c] * 100
  wohnk.mat[,c] <- ifelse(data$wohkosten >= inc.mat[,c], 100, wohnk.mat[,c])
}


# Wohnkosten Bruttokalt
wohnk_bruttok.df <- as.data.frame(wohnk_bruttok.mat)
wohnk_bruttok.df <- cbind(data[,c("owner", "belastet", "hgowner", "hhrf")], wohnk_bruttok.df)


wohnk_bruttok.gesamt <- sapply(5:ncol(wohnk_bruttok.df), function(c) weighted.mean(wohnk_bruttok.df[,c], wohnk_bruttok.df$hhrf,na.rm = T))
wohnk_bruttok.gesamt_mieter <- sapply(5:ncol(wohnk_bruttok.df), function(c) weighted.mean(filter(wohnk_bruttok.df,hgowner == 2)[,c], filter(wohnk_bruttok.df,hgowner == 2)$hhrf,na.rm = T))
wohnk_bruttok.gesamt_eigbel <- sapply(5:ncol(wohnk_bruttok.df), function(c) weighted.mean(filter(wohnk_bruttok.df,owner == 1 & belastet == 1)[,c], filter(wohnk_bruttok.df,owner == 1 & belastet == 1)$hhrf,na.rm = T))
wohnk_bruttok.gesamt_eigunbel <- sapply(5:ncol(wohnk_bruttok.df), function(c) weighted.mean(filter(wohnk_bruttok.df,owner == 1 & belastet == 0)[,c], filter(wohnk_bruttok.df,owner == 1 & belastet == 0)$hhrf,na.rm = T))


#gesamte Wohnkosten
wohnk.df <- as.data.frame(wohnk.mat)
wohnk.df <- cbind(data[,c("owner", "belastet", "hgowner", "hhrf", "notrücklagen", "region")], wohnk.df)


wohnk.gesamt <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(wohnk.df[,c], wohnk.df$hhrf,na.rm = T))
wohnk.gesamt_mieter <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,hgowner == 2)[,c], filter(wohnk.df,hgowner == 2)$hhrf,na.rm = T))
wohnk.gesamt_eigbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,owner == 1 & belastet == 1)[,c], filter(wohnk.df,owner == 1 & belastet == 1)$hhrf,na.rm = T))
wohnk.gesamt_eigunbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,owner == 1 & belastet == 0)[,c], filter(wohnk.df,owner == 1 & belastet == 0)$hhrf,na.rm = T))

# gesamte Wohnkostenbelastung für Haushalte in Städten versus Land

wohnk.city <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df, region == 3)[,c], filter(wohnk.df, region == 3)$hhrf,na.rm = T))
wohnk.city_mieter <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,region == 3 & hgowner == 2)[,c], filter(wohnk.df,region == 3 & hgowner == 2)$hhrf,na.rm = T))
wohnk.city_eigbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,region == 3 & owner == 1 & belastet == 1)[,c], filter(wohnk.df,region == 3 & owner == 1 & belastet == 1)$hhrf,na.rm = T))
wohnk.city_eigunbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,region == 3 & owner == 1 & belastet == 0)[,c], filter(wohnk.df,region == 3 & owner == 1 & belastet == 0)$hhrf,na.rm = T))

wohnk.rural <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df, region != 3)[,c], filter(wohnk.df, region != 3)$hhrf,na.rm = T))
wohnk.rural_mieter <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,region != 3 & hgowner == 2)[,c], filter(wohnk.df,region != 3 & hgowner == 2)$hhrf,na.rm = T))
wohnk.rural_eigbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,region != 3 & owner == 1 & belastet == 1)[,c], filter(wohnk.df,region != 3 & owner == 1 & belastet == 1)$hhrf,na.rm = T))
wohnk.rural_eigunbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,region != 3 & owner == 1 & belastet == 0)[,c], filter(wohnk.df,region != 3 & owner == 1 & belastet == 0)$hhrf,na.rm = T))


#gesamte Wohnkosten für HH ohne Rücklagen

wohnk.ges_nor <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df, notrücklagen == names(table(wohnk.df$notrücklagen)[1]))[,c], filter(wohnk.df, notrücklagen == names(table(wohnk.df$notrücklagen)[1]))$hhrf,na.rm = T))
wohnk.ges_nor_mieter <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,hgowner == 2 & notrücklagen == names(table(wohnk.df$notrücklagen)[1]))[,c], filter(wohnk.df,hgowner == 2 & notrücklagen == names(table(wohnk.df$notrücklagen)[1]))$hhrf,na.rm = T))
wohnk.ges_nor_eigbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,owner == 1 & belastet == 1 & notrücklagen == names(table(wohnk.df$notrücklagen)[1]))[,c], filter(wohnk.df,owner == 1 & belastet == 1 & notrücklagen == names(table(wohnk.df$notrücklagen)[1]))$hhrf,na.rm = T))
wohnk.ges_nor_eigunbel <- sapply(7:ncol(wohnk.df), function(c) weighted.mean(filter(wohnk.df,owner == 1 & belastet == 0 & notrücklagen == names(table(wohnk.df$notrücklagen)[1]))[,c], filter(wohnk.df,owner == 1 & belastet == 0 & notrücklagen == names(table(wohnk.df$notrücklagen)[1]))$hhrf,na.rm = T))


#Bruttokalt plot datensatz
plot.df1 <- as.data.frame(c(wohnk_bruttok.gesamt,wohnk_bruttok.gesamt_mieter,wohnk_bruttok.gesamt_eigbel, wohnk_bruttok.gesamt_eigunbel))
names(plot.df1)[1] <- "wohnk"
plot.df1$Population <- as.factor(c(rep("gesamte Population",length(seq)),rep("Mieter",length(seq)),rep("Eigentümer \n (belastet)",length(seq)), rep("Eigentümer \n (nicht belastet)",length(seq))))
plot.df1$seq <- rep(-1*seq,4)

#gesamte Wohnkosten-Plot Datensatz
plot.df2 <- as.data.frame(c(wohnk.gesamt,wohnk.gesamt_mieter,wohnk.gesamt_eigbel, wohnk.gesamt_eigunbel))
names(plot.df2)[1] <- "wohnk"
plot.df2$Population <- as.factor(c(rep("gesamte Population",length(seq)),rep("Mieter",length(seq)),rep("Eigentümer \n (belastet)",length(seq)), rep("Eigentümer \n (nicht belastet)",length(seq))))
plot.df2$seq <- rep(-1*seq,4)

#gesamte Wohnkosten-Plot Datensatz ohne HH mit Rücklagen
plot.df3 <- as.data.frame(c(wohnk.ges_nor,wohnk.ges_nor_mieter,wohnk.ges_nor_eigbel, wohnk.ges_nor_eigunbel))
names(plot.df3)[1] <- "wohnk"
plot.df3$Population <- as.factor(c(rep("gesamte Population",length(seq)),rep("Mieter",length(seq)),rep("Eigentümer \n (belastet)",length(seq)), rep("Eigentümer \n (nicht belastet)",length(seq))))
plot.df3$seq <- rep(-1*seq,4)


#gesamte Wohnkosten-Plot Datensatz Großstadt
plot.df4 <- as.data.frame(c(wohnk.city,wohnk.city_mieter,wohnk.city_eigbel, wohnk.city_eigunbel))
names(plot.df4)[1] <- "wohnk"
plot.df4$Population <- as.factor(c(rep("gesamte Population",length(seq)),rep("Mieter",length(seq)),rep("Eigentümer \n (belastet)",length(seq)), rep("Eigentümer \n (nicht belastet)",length(seq))))
plot.df4$seq <- rep(-1*seq,4)

#gesamte Wohnkosten-Plot Datensatz Land
plot.df5 <- as.data.frame(c(wohnk.rural,wohnk.rural_mieter,wohnk.rural_eigbel, wohnk.rural_eigunbel))
names(plot.df5)[1] <- "wohnk"
plot.df5$Population <- as.factor(c(rep("gesamte Population",length(seq)),rep("Mieter",length(seq)),rep("Eigentümer \n (belastet)",length(seq)), rep("Eigentümer \n (nicht belastet)",length(seq))))
plot.df5$seq <- rep(-1*seq,4)

col <- c("#307397", "#30A0A6", "#A6A6A6", "#4BCBE2")

ggplot(plot.df1, aes(x = seq, y = wohnk))+
  geom_line(aes(color = Population), size = 2)+
  xlab("Euro weniger pro Monat") +
  scale_x_reverse() +
  ylab("Wohnkostenbelastungsquote (bruttokalt) in %") +
  ggtitle("") +
  theme_minimal() +
  scale_colour_manual(values=col) +
  theme(plot.title = element_text(hjust = 0.5)) 


ggsave("wohnblq_bruttokalt_siumu.png")



#### gesamte Wohnkosten (hier präferiert)
ggplot(plot.df2, aes(x = seq, y = wohnk))+
  geom_line(aes(color = Population), size = 2)+
  xlab("Euro weniger pro Monat") +
  scale_x_reverse() +
  ylab("Wohnkostenbelastungsquote in %") +
  ggtitle("") +
  theme_minimal() +
  scale_colour_manual(values=col) +
  theme(plot.title = element_text(hjust = 0.5)) 
  

ggsave("wohnblq_gesamt_simu.png")

#### gesamte Wohnkosten (hier präferiert)
ggplot(plot.df3, aes(x = seq, y = wohnk))+
  geom_line(aes(color = Population), size = 2)+
  xlab("Euro weniger pro Monat") +
  scale_x_reverse() +
  ylab("Wohnkostenbelastungsquote in %") +
  ggtitle("") +
  theme_minimal() +
  scale_colour_manual(values=col) +
  theme(plot.title = element_text(hjust = 0.5)) 


ggsave("wohnblq_gesamt_notrueck.png")



#### gesamte Wohnkosten (hier präferiert)
city <- ggplot(plot.df4, aes(x = seq, y = wohnk))+
  geom_line(aes(color = Population), size = 2)+
  xlab("Euro weniger pro Monat") +
  scale_x_reverse() +
  ylab("Wohnkostenbelastungsquote in %") +
  #ggtitle("Haushalt befindet sich in einer Großstadt") +
  theme_minimal() +
  scale_colour_manual(values=col) +
  #theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position = "none") 


#ggsave("wohnblq_city.png")

#### gesamte Wohnkosten (hier präferiert)
rural <- ggplot(plot.df5, aes(x = seq, y = wohnk))+
  geom_line(aes(color = Population), size = 2)+
  xlab("Euro weniger pro Monat") +
  scale_x_reverse() +
  ylab("Wohnkostenbelastungsquote in %") +
  #ggtitle("Haushalt befindet sich auf dem Land") +
  theme_minimal() +
  scale_colour_manual(values=col) 
  #theme(plot.title = element_text(hjust = 0.5)) 

plot_grid(city,rural, labels=c(">500.000 Einwohner", "<500.000 Einwohner"), hjust=-0.1, align="hv", rel_widths = c(1, 1.5), ncol = 2, nrow = 1)

ggsave("wohnblq_city_rural.png")



data$notrücklagen <- factor(data$notrücklagen, labels = c("keine Rücklagen", "Rücklagen"))

ggplot(subset(data, !is.na(notrücklagen)), aes(notrücklagen, (..count..)/sum(..count..)*100, na.rm = TRUE)) +
   geom_bar(aes(weight = hhrf), position = "dodge", na.rm = TRUE) +
   xlab("") +
  ylab("Anteil in %") +
  theme_grey() +
  ggtitle("Anteil der Haushalte die Rücklagen für Notfälle gebildet haben") +
  theme(plot.title = element_text(hjust = 0.5)) 

ggsave("notrueck.png")


### Tabelle mit den exakten Zahlen 

# Wohnkosten gesamt nach Mietern, Eigentümern und Eigentümern ohne Zins/Tilgungszahlungen 

wohnk.table <- wohnk.gesamt[c(1,101,201,301,401,501)]
wohnk.table <- rbind(wohnk.table, wohnk.gesamt_mieter[c(1,101,201,301,401,501)])
wohnk.table <- rbind(wohnk.table, wohnk.gesamt_eigbel[c(1,101,201,301,401,501)])
wohnk.table <- rbind(wohnk.table, wohnk.gesamt_eigunbel[c(1,101,201,301,401,501)])

rownames(wohnk.table) <- c("gesamte Pop.", "Mieter", "Eigentümer (belastet)", "Eigentümer (unbelastet)")
colnames(wohnk.table) <- c("Ausgangssituation (2018)", "-100€", "-200€", "-300€", "-400€", "-500") 

stargazer(wohnk.table, type = "text", out = "simutable.txt", title = "Corona Szenarien für die gesamte Wohnbelastungsquote von Mietern und Eigentümern")

write.table(wohnk.table, file="simutable.csv", row.names = T, col.names = T)


# Wohnkosten gesamt nach Mietern, Eigentümern und Eigentümern ohne Zins/Tilgungszahlungen f. HH ohne Notrücklagen 

wohnk_nor.table <- wohnk.ges_nor[c(1,101,201,301,401,501)]
wohnk_nor.table <- rbind(wohnk_nor.table, wohnk.ges_nor_mieter[c(1,101,201,301,401,501)])
wohnk_nor.table <- rbind(wohnk_nor.table, wohnk.ges_nor_eigbel[c(1,101,201,301,401,501)])
wohnk_nor.table <- rbind(wohnk_nor.table, wohnk.ges_nor_eigunbel[c(1,101,201,301,401,501)])

rownames(wohnk_nor.table) <- c("gesamte Pop.", "Mieter", "Eigentümer (belastet)", "Eigentümer (unbelastet)")
colnames(wohnk_nor.table) <- c("Ausgangssituation (2018)", "-100€", "-200€", "-300€", "-400€", "-500") 

stargazer(wohnk_nor.table, type = "text", out = "simutable_norueck.txt", title = "Corona Szenarien für die gesamte Wohnbelastungsquote von Mietern und Eigentümern für Haushalte die keine Notrücklagen gebildet haben")

write.table(wohnk_nor.table, file="simutable_norueck.csv", row.names = T, col.names = T)



