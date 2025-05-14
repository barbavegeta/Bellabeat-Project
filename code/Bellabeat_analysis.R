library(dplyr)
library(readr)
library(tidyverse)
library(lubridate)

# Define base paths
folder1 <- "C:\\Users\\user\\Coursera\\Google Data Analytics\\Bellabeat\\mturkfitbit_export_3.12.16-4.11.16\\Fitabase Data 3.12.16-4.11.16\\"
folder2 <- "C:\\Users\\user\\Coursera\\Google Data Analytics\\Bellabeat\\mturkfitbit_export_4.12.16-5.12.16\\Fitabase Data 4.12.16-5.12.16\\"

setwd("C:\\Users\\user\\Coursera\\Google Data Analytics\\Bellabeat\\Project\\")
list.files()

# Load and merge all files
daily_activity <- bind_rows(
  read_csv(paste0(folder1, "dailyActivity_merged.csv")),
  read_csv(paste0(folder2, "dailyActivity_merged.csv"))
)%>% distinct()

heartrate_seconds <- bind_rows(
  read_csv(paste0(folder1, "heartrate_seconds_merged.csv")),
  read_csv(paste0(folder2, "heartrate_seconds_merged.csv"))
) %>% distinct()

hourly_calories <- bind_rows(
  read_csv(paste0(folder1, "hourlyCalories_merged.csv")),
  read_csv(paste0(folder2, "hourlyCalories_merged.csv"))
) %>% distinct()

hourly_intensities <- bind_rows(
  read_csv(paste0(folder1, "hourlyIntensities_merged.csv")),
  read_csv(paste0(folder2, "hourlyIntensities_merged.csv"))
) %>% distinct()

hourly_steps <- bind_rows(
  read_csv(paste0(folder1, "hourlySteps_merged.csv")),
  read_csv(paste0(folder2, "hourlySteps_merged.csv"))
) %>% distinct()

minute_calories <- bind_rows(
  read_csv(paste0(folder1, "minuteCaloriesNarrow_merged.csv")),
  read_csv(paste0(folder2, "minuteCaloriesNarrow_merged.csv"))
) %>% distinct()

minute_intensities <- bind_rows(
  read_csv(paste0(folder1, "minuteIntensitiesNarrow_merged.csv")),
  read_csv(paste0(folder2, "minuteIntensitiesNarrow_merged.csv"))
) %>% distinct()

minute_mets <- bind_rows(
  read_csv(paste0(folder1, "minuteMETsNarrow_merged.csv")),
  read_csv(paste0(folder2, "minuteMETsNarrow_merged.csv"))
) %>% distinct()

minute_sleep <- bind_rows(
  read_csv(paste0(folder1, "minuteSleep_merged.csv")),
  read_csv(paste0(folder2, "minuteSleep_merged.csv"))
) %>% distinct()

minute_steps <- bind_rows(
  read_csv(paste0(folder1, "minuteStepsNarrow_merged.csv")),
  read_csv(paste0(folder2, "minuteStepsNarrow_merged.csv"))
) %>% distinct()

weight_log <- bind_rows(
  read_csv(paste0(folder1, "weightLogInfo_merged.csv")),
  read_csv(paste0(folder2, "weightLogInfo_merged.csv"))
) %>% distinct()

# These files exist only in the second folder (handle separately)
daily_calories_X <- read_csv(paste0(folder2, "dailyCalories_merged_X.csv"))
daily_intensities_X <- read_csv(paste0(folder2, "dailyIntensities_merged_X.csv"))
daily_steps_X <- read_csv(paste0(folder2, "dailySteps_merged_X.csv"))
minute_calories_wide_X <- read_csv(paste0(folder2, "minuteCaloriesWide_merged_X.csv"))
minute_steps_wide_X <- read_csv(paste0(folder2, "minuteStepsWide_merged_X.csv"))
minute_intensities_wide_X <- read_csv(paste0(folder2, "minuteIntensitiesWide_merged_X.csv"))
sleep_day_X <- read_csv(paste0(folder2, "sleepDay_merged_X.csv"))

dim(daily_activity)
str(daily_activity)
head(daily_activity)
colnames(daily_activity)
sum(is.na(daily_activity))
glimpse(daily_activity)
summary(daily_activity)

daily_activity$ActivityDate <- mdy(daily_activity$ActivityDate)

# 1. MET summary

avg_mets_user <- minute_mets %>%
  mutate(Id = as.character(Id),
    Date = mdy_hms(ActivityMinute) %>% as_date()
  ) %>%
  group_by(Id, Date) %>%
  summarize(daily_mets = mean(METs, na.rm = TRUE), .groups="drop") %>%
  group_by(Id) %>%
  summarize(avg_daily_mets = round(mean(daily_mets, na.rm = TRUE),2), .groups="drop")

# 2. Weight change % of users who lost weight
weight_change <- weight_log %>%
  # parse the date column (replace `Date` with your actual date field)
  mutate(Id = as.character(Id),Date = mdy_hms(Date)) %>%
  arrange(Id, Date) %>%
  group_by(Id) %>%
  summarize(
    first_wt = first(na.omit(WeightKg)),
    last_wt = last(na.omit(WeightKg)),
    change = last_wt - first_wt,
    percentage = change/last_wt * 100
  ) %>%
  ungroup()

# 3. High intensity minutes

high_int_minutes <- minute_intensities %>%
  mutate(Id = as.character(Id),Date = mdy_hms(ActivityMinute) %>% as_date()) %>%
  group_by(Id, Date) %>%
  summarize(high_min = sum(Intensity > 2, na.rm = TRUE), .groups = "drop") %>%
  group_by(Id) %>%
  summarize(avg_high_min = mean(high_min, na.rm = TRUE), .groups = "drop")

# 4. Avg heart rate per user

avg_heart_rate_user <- heartrate_seconds %>%
  mutate(Id = as.character(Id),Date = mdy_hms(Time) %>% as_date()) %>%
  group_by(Id, Date) %>%
  summarize(avg_heart_rate_day = mean(Value, na.rm = TRUE), .groups = "drop") %>%
  group_by(Id) %>%
  summarize(avg_heart_rate = mean(avg_heart_rate_day, na.rm = TRUE), .groups = "drop")

# 5. Steps
avg_user_steps <- daily_activity %>%
  mutate(
    Id = as.character(Id)) %>%
  group_by(Id) %>%
  summarize(avg_steps = mean(TotalSteps, na.rm = TRUE))

# Average daily steps:
avg_daily_steps <- daily_steps_X %>%
    mutate(Id = as.character(Id),ActivityDay = mdy(ActivityDay)) %>%
  group_by(ActivityDay) %>%
  summarize(avg_steps = mean(StepTotal, na.rm = TRUE))

# Most active hour of day (across all users)
avg_hourly_steps <- hourly_steps %>%
  mutate(Id = as.character(Id),ActivityHour = mdy_hms(ActivityHour)) %>%
  group_by(ActivityHour) %>%
  summarize(hour_step = mean(StepTotal, na.rm = TRUE)) %>%
  arrange(desc(hour_step))

# 6. Sleep

avg_sleep_user_minutes <- sleep_day_X %>%
  mutate(Id = as.character(Id),sleep_day = mdy_hms(SleepDay)) %>%
  group_by(Id) %>%
  summarize(avg_sleep = mean(TotalMinutesAsleep, na.rm = TRUE))

# 7. Hourly intensity

hourly_intensity_summary <- hourly_intensities %>%
  mutate(Id = as.character(Id),Date = mdy_hms(ActivityHour) %>% as_date()) %>%
  group_by(Id, Date) %>%
  summarize(
    daily_total_intensity = sum(TotalIntensity, na.rm = TRUE),
    daily_avg_intensity   = mean(AverageIntensity, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  group_by(Id) %>%
  summarize(
    avg_intensity_minute_per_day = mean(daily_total_intensity, na.rm = TRUE),
    avg_hourly_intensity_per_day   = mean(daily_avg_intensity, na.rm = TRUE),
    .groups = "drop"
  )

# 8. Activity zone minutes

high_intensity_summary <- daily_intensities_X %>%
  mutate(Id = as.character(Id),Date = mdy(ActivityDay)) %>%
  group_by(Id) %>%
  summarize(
    avg_very_active_min = mean(VeryActiveMinutes, na.rm = TRUE),
    avg_fairly_active_min = mean(FairlyActiveMinutes, na.rm = TRUE),
    avg_lightly_active_min = mean(LightlyActiveMinutes, na.rm = TRUE),
    .groups = "drop"
  )

# Put them in a named list
summaries <- list(
  weight = weight_change,
  mets = avg_mets_user,
  high_int_min = high_int_minutes,
  heart_rate = avg_heart_rate_user,
  steps = avg_user_steps,
  sleep = avg_sleep_user_minutes,
  heart_rate_intensity = hourly_intensity_summary,
  zone_minutes = high_intensity_summary
)

user_summary <- reduce(summaries, full_join, by = "Id")
write.csv(user_summary, "user_summary_write.csv", row.names = FALSE)
readr::write_csv(user_summary, "user_summary_readr.csv")

glimpse(user_summary)


sapply(summaries, function(df) class(df$Id))
sapply(summaries, function(df) length(unique(df$Id)))
  

output_folder <- "C:/Users/user/Coursera/Google Data Analytics/Bellabeat/Exports"
dir.create(output_folder, showWarnings = FALSE)
for (name in names(summaries)) {
  write_csv(summaries[[name]], file = file.path(output_folder, paste0(name, ".csv")))
}
