rm(list = ls())

source("packages.R")

data <- import("coronadaten.xlsx")

names(data) <- c("datum", "schutzm", "oeffis", "massnahmen")

fobs <- 19
firstaverage <- c(rep(NA,18), rep(mean(data[fobs:(fobs+3),2]),3))

for (i in 1:round(sum(!is.na(data[,2]))/3)){
  fobs <- fobs + 3
  firstaverage <- c(firstaverage, rep(mean(data[fobs:(fobs+3),2]), 3))
}

firstaverage <- firstaverage[1:67]
firstaverage[67] <- firstaverage[66]  

data <- cbind(data,firstaverage)


fobs <- 19
secondaverage <- c(rep(NA,18), rep(mean(data[fobs:(fobs+3),3]),3))

for (i in 1:round(sum(!is.na(data[,3]))/3)){
  fobs <- fobs + 3
  secondaverage <- c(secondaverage, rep(mean(data[fobs:(fobs+3),3]), 3))
}

secondaverage <- secondaverage[1:67]
secondaverage[67] <- secondaverage[66]  

data <- cbind(data,secondaverage)

thirdaverage <- c(rep(mean(data[1:(1+3),4]),3))
fobs <- 1
for (i in 1:round(sum(!is.na(data[,4]))/3)){
  fobs <- fobs + 3
  thirdaverage <- c(thirdaverage, rep(mean(data[fobs:(fobs+3),4]), 3))
}

thirdaverage <- thirdaverage[1:67]
thirdaverage[67] <- thirdaverage[66]  

data <- cbind(data,thirdaverage)



base_plot <- ggplot(data = data) +
  geom_point(aes(x = datum, y = schutzm), 
            color = "#4BCBE2",
            alpha = 0.4,
            size = 0.4) +
  geom_line(aes(x = datum, y = firstaverage), 
            color = "#30A0A6",
            alpha = 0.9,
            size = 0.9) +
  labs(x = "", 
       y = "Prozent",
       title = "Schutzmasken beim Einkaufen\nbefürworte ich") +
  scale_y_continuous(limits = c(0, 100)) +
  theme_minimal() 
  
#ggsave("schutzmasken.png")
  

base_plot2 <- ggplot(data = data) +
  geom_point(aes(x = datum, y = oeffis), 
            color = "#4BCBE2",
            alpha = 0.4,
            size = 0.4) +
  geom_line(aes(x = datum, y = secondaverage), 
            color = "#30A0A6",
            alpha = 0.9,
            size = 0.9) +
  labs(x = "", 
       y = "",
       title = "Schutzmasken bei der Nutzung\nöffentlicher Verkehrsmittel\nbefürworte ich") +
  scale_y_continuous(limits = c(0, 100)) +
  theme_minimal() 
  

base_plot3 <- ggplot(data = data) +
  geom_point(aes(x = datum, y = massnahmen), 
            color = "#4BCBE2",
            alpha = 0.4,
            size = 0.4) +
  geom_line(aes(x = datum, y = thirdaverage), 
            color = "#30A0A6",
            alpha = 0.9,
            size = 0.9) +
  labs(x = "", 
       y = "",
       title = "Die Maßnahmen der Behörden und\nGesundheitseinrichtungen halte ich\nfür übertrieben") +
  scale_y_continuous(limits = c(0, 100)) +
  theme_minimal() 
  

prow <- plot_grid(base_plot, base_plot2, base_plot3, hjust=-0.1, align="vh", nrow = 1)

ggsave("coronabilder.png",width = 10.5, height = 6) 

