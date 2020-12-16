

# facetado, fill, colores

mir_theme <- theme(plot.title = element_text(size = 18, family = "Source Sans Pro Semibold", 
                                             face = "italic", hjust = 0.5),
                   axis.line = element_line(color = "black", size = 1),
                   axis.title = element_text(size = 16),
                   axis.text = element_text(size = 14),
                   panel.background = element_rect(fill = NA),
                   plot.caption = element_text(size = 14),
                   legend.title = element_blank(),
                   legend.position = "bottom")