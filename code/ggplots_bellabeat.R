ggplot(user_summary, aes(x = avg_daily_mets, y = percentage)) +
  geom_point(alpha = 0.6, color = "#0073C2FF") +
  geom_smooth(method = "lm", se = FALSE, color = "darkred") +
  labs(title = "Weight % Change vs Avg Daily METs",
       x = "Avg Daily METs", y = "Weight % Change (%)")

ggplot(user_summary, aes(x = avg_high_min, y = percentage)) +
  geom_point(alpha = 0.6, color = "#EFC000FF") +
  geom_smooth(method = "lm", se = FALSE, color = "darkblue") +
  labs(title = "Weight % Change vs Avg High-Intensity Minutes",
       x = "Avg High-Intensity Minutes per Day", y = "Weight % Change (%)")

ggplot(user_summary, aes(x = avg_high_min, y = avg_heart_rate)) +
  geom_point(alpha = 0.6, color = "#868686FF") +
  geom_smooth(method = "lm", se = FALSE, color = "forestgreen") +
  labs(title = "Avg Heart Rate vs High-Intensity Minutes",
       x = "Avg High-Intensity Minutes per Day", y = "Avg Heart Rate (bpm)")

ggplot(user_activity_long, aes(x = Id, y = Minutes, fill = ActivityType)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Daily Activity Minutes per User", x = "User ID", y = "Minutes") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))