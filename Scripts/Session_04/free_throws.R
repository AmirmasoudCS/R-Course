#Seasons
Seasons <- c("2005","2006","2007","2008","2009","2010","2011","2012","2013","2014")

#Players
Players <- c("KobeBryant","JoeJohnson","LeBronJames","CarmeloAnthony","DwightHoward","ChrisBosh","ChrisPaul","KevinDurant","DerrickRose","DwayneWade")

#Free Throws
KobeBryant_FT <- c(696,667,623,483,439,483,381,525,18,196)
JoeJohnson_FT <- c(261,235,316,299,220,195,158,132,159,141)
LeBronJames_FT <- c(601,489,549,594,593,503,387,403,439,375)
CarmeloAnthony_FT <- c(573,459,464,371,508,507,295,425,459,189)
DwightHoward_FT <- c(356,390,529,504,483,546,281,355,349,143)
ChrisBosh_FT <- c(474,463,472,504,470,384,229,241,223,179)
ChrisPaul_FT <- c(394,292,332,455,161,337,260,286,295,289)
KevinDurant_FT <- c(209,209,391,452,756,594,431,679,703,146)
DerrickRose_FT <- c(146,146,146,197,259,476,194,0,27,152)
DwayneWade_FT <- c(629,432,354,590,534,494,235,308,189,284)

#Free Throw Attempts
KobeBryant_FTA <- c(819,768,742,564,541,583,451,626,21,241)
JoeJohnson_FTA <- c(330,314,379,362,269,243,186,161,195,176)
LeBronJames_FTA <- c(814,701,771,762,773,663,502,535,585,528)
CarmeloAnthony_FTA <- c(709,568,590,468,612,605,367,512,541,237)
DwightHoward_FTA <- c(598,666,897,849,816,916,572,721,638,271)
ChrisBosh_FTA <- c(581,590,559,617,590,471,279,302,272,232)
ChrisPaul_FTA <- c(465,357,390,524,190,384,302,323,345,321)
KevinDurant_FTA <- c(256,256,448,524,840,675,501,750,805,171)
DerrickRose_FTA <- c(205,205,205,250,338,555,239,0,32,187)
DwayneWade_FTA <- c(803,535,467,771,702,652,297,425,258,370)

build_ft_dataframe <- function(){
    df_list <- lapply(Players, function(p) {
        ft <- get(paste0(p, "_FT"))
        fta <- get(paste0(p, "_FTA"))
        data.frame(
            Player =p,
            Season = Seasons,
            FT = ft,
            FTA = fta,
            stringsAsFactors = FALSE
        )
    })
    df <- do.call(rbind, df_list)
    df$Season <- factor(df$Season, levels=Seasons, ordered=TRUE)
    df
}

ft_df <- build_ft_dataframe()
head(ft_df)
str(ft_df)

compute_ft_pct <- function(df){
    df$FT_pct <- ifelse(df$FTA==0, NA, df$FT / df$FTA *100)
    df
}

ft_df <- compute_ft_pct(ft_df)
head(ft_df)
sum(is.na(ft_df$FT_pct))

compute_league_avg <- function(df){
    sum(df$FT, na.rm = TRUE) / sum(df$FTA, na.rm=TRUE) * 100
}

league_avg <- compute_league_avg(ft_df)
league_avg

compute_adjusted_pct <- function(df, k=20){
    league_avg <- compute_league_avg(df) / 100
    df$FT_pct_adj <- (df$FT + k*league_avg) / (df$FTA + k) * 100
    df
}

ft_df <- compute_adjusted_pct(ft_df, k=20)
head(ft_df)

ft_df[ft_df$Player == "DerrickRose", ]

install.packages("binom")
library("binom")

compute_wilson_ci <- function(df, conf_level=0.95){
    ci <- binom.confint(
        x = ifelse(df$FTA ==0, 0, df$FT),
        n = ifelse(df$FTA== 0, 1, df$FTA),
        conf.level = conf_level,
        methods="wilson"
    )
    df$CI_lower <- ci$lower * 100
    df$CI_upper <- ci$upper * 100

    df$CI_lower[df$FTA==0] <- NA
    df$CI_upper[df$FTA==0] <- NA

    df
}

ft_df <- compute_wilson_ci(ft_df)
ft_df[ft_df$Player == "DerrickRose",]

flag_outliers <- function(df, threshold=2){
    valid <- !is.na(df$FT_pct)

    loess_fit <- loess(FT_pct ~ FTA, data=df[valid,])

    df$predicted_pct <- NA
    df$predicted_pct[valid] <- predict(loess_fit)

    df$residual <- df$FT_pct - df$predicted_pct

    resid_sd <- sd(df$residual, na.rm = TRUE)
    df$is_outlier <- !is.na(df$residual) & abs(df$residual) > threshold * resid_sd

    df
}

ft_df <- flag_outliers(ft_df)
ft_df[ft_df$is_outlier, c("Player", "Season", "FTA", "FT_pct", "predicted_pct", "residual")]


get_top_n <- function(df, n=10, by="FT_pct_adj"){
    df[order(-df[[by]]), ][1:n, ]
}

filter_by_min_attempts <- function(df, min_attempts = 20) {
  df[df$FTA >= min_attempts, ]
}

# Top 10 seasons by adjusted FT%, excluding tiny sample sizes
top10 <- get_top_n(filter_by_min_attempts(ft_df, 50), n = 10, by = "FT_pct_adj")
top10[, c("Player", "Season", "FTA", "FT_pct", "FT_pct_adj")]

# Compare: top 10 by RAW FT% (unfiltered) — should look different/less sensible
top10_raw <- get_top_n(ft_df, n = 10, by = "FT_pct")
top10_raw[, c("Player", "Season", "FTA", "FT_pct", "FT_pct_adj")]

library(ggplot2)

if (!dir.exists("./assets/images")) {
  dir.create("./assets/images", recursive = TRUE)
}

plot_ft_distribution <- function(df, filename = "ft_distribution.png") {
  p <- ggplot(df, aes(x = FT_pct)) +
    geom_histogram(binwidth = 3, fill = "steelblue", color = "white", boundary = 0) +
    labs(title = "Distribution of Free Throw Percentages",
         x = "FT%", y = "Count") +
    theme_minimal()
  
  ggsave(filename = file.path("./assets/images", filename), plot = p, width = 8, height = 5, dpi = 150)
  p
}

plot_ft_distribution(ft_df)

plot_volume_vs_accuracy <- function(df, filename = "volume_vs_accuracy.png") {
  p <- ggplot(df, aes(x = FTA, y = FT_pct)) +
    geom_point(aes(color = Player), alpha = 0.7, size = 2) +
    geom_smooth(method = "loess", se = TRUE, color = "black", linewidth = 0.8) +
    labs(title = "Free Throw Accuracy vs. Volume",
         x = "Free Throw Attempts", y = "FT%") +
    theme_minimal()
  
  ggsave(filename = file.path("./assets/images", filename), plot = p, width = 9, height = 6, dpi = 150)
  p
}

plot_volume_vs_accuracy(ft_df)

plot_top_n_bar <- function(df, n = 10, by = "FT_pct_adj", min_attempts = 50, filename = "top_n_bar.png") {
  top_df <- get_top_n(filter_by_min_attempts(df, min_attempts), n = n, by = by)
  top_df$label <- paste(top_df$Player, top_df$Season)
  
  p <- ggplot(top_df, aes(x = reorder(label, .data[[by]]), y = .data[[by]])) +
    geom_col(fill = "darkorange") +
    coord_flip() +
    labs(title = paste("Top", n, "Seasons by Adjusted FT%"),
         x = "", y = "FT% (adjusted)") +
    theme_minimal()
  
  ggsave(filename = file.path("./assets/images", filename), plot = p, width = 8, height = 6, dpi = 150)
  p
}

plot_top_n_bar(ft_df)

plot_ci_errorbar <- function(df, n = 20, filename = "ci_errorbar.png") {
  sub_df <- filter_by_min_attempts(df, 20)
  sub_df <- get_top_n(sub_df, n = n, by = "FT_pct")
  sub_df$label <- paste(sub_df$Player, sub_df$Season)
  
  p <- ggplot(sub_df, aes(x = reorder(label, FT_pct), y = FT_pct)) +
    geom_point(color = "steelblue", size = 2) +
    geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.3) +
    coord_flip() +
    labs(title = "FT% with 95% Wilson Confidence Intervals",
         x = "", y = "FT%") +
    theme_minimal()
  
  ggsave(filename = file.path("./assets/images", filename), plot = p, width = 8, height = 7, dpi = 150)
  p
}

plot_ci_errorbar(ft_df)

plot_career_trend <- function(df, filename = "career_trend.png") {
  p <- ggplot(df, aes(x = Season, y = FT_pct, group = Player, color = Player)) +
    geom_line(linewidth = 0.9, na.rm = TRUE) +
    geom_point(size = 1.5, na.rm = TRUE) +
    labs(title = "Free Throw % Over Career (2005–2014)",
         x = "Season", y = "FT%") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(filename = file.path("./assets/images", filename), plot = p, width = 10, height = 6, dpi = 150)
  p
}

plot_career_trend(ft_df)


