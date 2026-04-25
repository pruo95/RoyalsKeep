library(ggplot2)
library(dplyr)

# Data
df <- data.frame(
  Player = c("Carter Jensen", "Jac Caglianone", "Kyle Isbel",
             "Vinnie Pasquantino", "Michael Massey"),
  wRC_plus = c(150, 95, 118, 49, 87),
  vs_RHP = c(174, 115, 139, 74, 128),
  vs_LHP = c(86, 38, 23, -12, -32)
)

# Order by split difference
df <- df %>%
  mutate(diff = vs_RHP - vs_LHP) %>%
  arrange(diff)

df$Player <- factor(df$Player, levels = df$Player)

# Plot
ggplot(df, aes(y = Player)) +
  
  # Barbell line
  geom_segment(aes(x = vs_LHP, xend = vs_RHP, yend = Player),
               size = 2, color = "gray80") +
  
  # Endpoints
  geom_point(aes(x = vs_RHP, color = "vs RHP"), size = 5) +
  geom_point(aes(x = vs_LHP, color = "vs LHP"), size = 5) +
  
  # Overall point (black diamond)
  geom_point(aes(x = wRC_plus),
             shape = 18, size = 3, color = "black") +
  
  # Labels ONLY for endpoints
  geom_text(aes(x = vs_RHP, label = vs_RHP),
            vjust = -1.2, size = 3.5) +
  
  geom_text(aes(x = vs_LHP, label = vs_LHP),
            vjust = 2, size = 3.5) +
  
  # Colors
  scale_color_manual(
    name = "Split",
    values = c("vs RHP" = "#1f77b4", "vs LHP" = "#d62728")
  ) +
  
  # Optional: league average reference
  geom_vline(xintercept = 100, linetype = "dashed", color = "gray50") +
  
  labs(
    title = "Royals LH Hitters: Platoon Splits (wRC+)",
    subtitle = "Endpoints show performance vs RHP/LHP; diamonds show overall wRC+",
    x = "wRC+",
    y = NULL
  ) +
  
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.y = element_text(face = "bold"),
    plot.title = element_text(face = "bold"),
    legend.position = "top"
  )