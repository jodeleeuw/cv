// CV Configuration File
// Modify these settings to customize your CV appearance

// Font settings - IBM Plex family
#let cv_font = "IBM Plex Serif"
#let cv_font_size = 10pt
#let header_font_size = 16pt
#let section_font_size = 11pt
#let header_font = "IBM Plex Sans"  // Sans-serif for headers

// Spacing settings - Improved for better typography
#let section_spacing_above = 1.5em
#let section_spacing_below = 0.75em
#let subsection_spacing_above = 1.2em
#let subsection_spacing_below = 0.5em
#let paragraph_leading = 0.65em
#let line_height = 1.4  // Better line spacing for readability

// Page settings
#let page_margin_x = 0.75in
#let page_margin_y = 1in

// Colors (modify these if you want color accents)
#let primary_color = black
#let accent_color = rgb("#333333")

// Table settings
#let table_column_gutter = 1em

// Export settings for easy import
#let cv_config = (
  font: cv_font,
  font_size: cv_font_size,
  header_font: header_font,
  header_font_size: header_font_size,
  section_font_size: section_font_size,
  section_spacing_above: section_spacing_above,
  section_spacing_below: section_spacing_below,
  subsection_spacing_above: subsection_spacing_above,
  subsection_spacing_below: subsection_spacing_below,
  paragraph_leading: paragraph_leading,
  line_height: line_height,
  page_margin_x: page_margin_x,
  page_margin_y: page_margin_y,
  primary_color: primary_color,
  accent_color: accent_color,
  table_column_gutter: table_column_gutter
)