# Install/Load libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(ggplot2, reshape, dplyr, magrittr, cowplot, ggpubr, tidyr)

# Set seed
set.seed(6385)

# Define the association between age-specific fertility and traits 1,2
df <- data.frame(z1 = rlnorm(n = 100), 
                 z2 = rlnorm(n = 100)) 

#Here, we are saying that trait z1 is more strongly associated with age-specific fertility than trait z2 
mi <- round(.8*df$z1 + .2*df$z2,0)

df <- cbind(df, mi)

# Plotting the relationship between fertility and the phenotypic values
plot1 <- pivot_longer(df, cols = c(z1, z2), names_to = "Trait", values_to = "Phenotype") %>%
  ggplot(aes(x = Phenotype, y = mi, colour = Trait)) +
  geom_point(size=2) +
  geom_smooth(method = "lm", se=FALSE, size=1.5) +
  ylab("Fertility") +
  xlab("Phenotypic Value") +
  scale_colour_manual(values = c("#CC6677", "#44AA99")) +
  theme_cowplot() + theme(legend.position = "none") +
  theme(axis.title.x = element_text(size = 20),
        axis.text.x = element_text(size = 18),
        axis.title.y = element_text(size = 20),
        axis.text.y = element_text(size = 18)) +
  scale_y_continuous(limits=c(0, 9), breaks = c(2,4,6,8))

plot1

# Calculating Hamilton's selection gradient
# Note: This simple illustration assumes that the age-specific fertility values we
# previously obtained above dont need to add up to the population-level Mx values 
# that go into the Leslie matrix 
p <- rep(.8, 5)
m <- rep(.3, mean(mi))     # These values were picked as they are age-invariant and result in a slightly positive growth rate
A <- diag(p)
A <- cbind(A, rep(0,5))
A <-rbind(m,A)
r <- log(Re(eigen(A)$values[1]))  
l<-c(1,cumprod(p))
dr_dm <- l*exp(-r*seq(1,6))    ###Hamilton

dm_dz1 <- lm(mi ~ z1, df)$coef[2]
dm_dz2 <- lm(mi ~ z2, df)$coef[2]

df2 <- data.frame(Age = seq(1,6),
                  FertilitySelection = dr_dm,
                  z1 = dr_dm*dm_dz1,
                  z2 = dr_dm*dm_dz2)

plot2 <- pivot_longer(df2, cols = c(z1, z2), names_to = "Trait", values_to = "PhenotypicSelection") %>%
  ggplot(aes(x = Age, y = PhenotypicSelection, colour = Trait)) +
  geom_point(size=2.5) +
  geom_line(size=1.5) +
  ylab("Age-specific \nPhenotypic Selection") +
  scale_colour_manual(values = c("#CC6677", "#44AA99")) +
  theme_cowplot() +
  theme(axis.title.x = element_text(size = 20),
    axis.text.x = element_text(size = 18),
    axis.title.y = element_text(size = 20),
    axis.text.y = element_text(size = 18),
    legend.title=element_text(size=20), 
    legend.text=element_text(size=18)) +
  scale_x_continuous(name="Age", limits=c(1, 6), breaks = c(seq(1,6)))

plot2

p_all <- ggarrange(plot1, plot2, 
                   labels = c("A", "B"),
                   ncol = 2, nrow = 1)
p_all

ggsave("Async_Fig2.png", p_all, height = 5 , width = 11)
