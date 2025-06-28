// Fixed base styling functions for CV template
// This file handles both named tuples and array access patterns

#import "../config.typ": cv_config

// Apply base document styling with IBM Plex typography
#let apply_base_style(doc) = {
  set page(margin: (x: cv_config.page_margin_x, y: cv_config.page_margin_y))
  set text(font: cv_config.font, size: cv_config.font_size)
  set par(justify: true, leading: cv_config.paragraph_leading)
  set block(spacing: cv_config.line_height * 1em)
  
  show heading.where(level: 1): it => [
    #set text(font: cv_config.header_font, size: cv_config.header_font_size, weight: "semibold")
    #block(above: cv_config.section_spacing_above, below: cv_config.section_spacing_below)[#upper(it.body)]
  ]

  show heading.where(level: 2): it => [
    #set text(font: cv_config.header_font, size: cv_config.section_font_size, weight: "medium")
    #block(above: cv_config.subsection_spacing_above, below: cv_config.subsection_spacing_below)[#it.body]
  ]

  show heading.where(level: 3): it => [
    #set text(font: cv_config.font, size: cv_config.font_size, weight: "medium", style: "italic")
    #block(above: 0.8em, below: 0.4em)[#it.body]
  ]
  
  doc
}

// Helper function to safely access entry fields
#let get_entry_year(entry) = {
  if type(entry) == dictionary {
    entry.year
  } else if type(entry) == array and entry.len() >= 2 {
    entry.at(0)
  } else {
    // Try field access as fallback
    entry.year
  }
}

#let get_entry_content(entry) = {
  if type(entry) == dictionary {
    entry.content
  } else if type(entry) == array and entry.len() >= 2 {
    entry.at(1)
  } else {
    // Try field access as fallback
    entry.content
  }
}

// Create a year-content table (most common pattern in CV)
#let year_table(entries) = {
  let table_rows = ()
  for entry in entries {
    let year = get_entry_year(entry)
    let content = get_entry_content(entry)
    table_rows.push([*#year*])
    table_rows.push(content)
  }
  
  table(
    columns: (auto, 1fr),
    stroke: none,
    column-gutter: cv_config.table_column_gutter,
    align: (left, left),
    ..table_rows
  )
}

// Helper functions for two-column access
#let get_entry_left(entry) = {
  if type(entry) == dictionary {
    entry.left
  } else if type(entry) == array and entry.len() >= 2 {
    entry.at(0)
  } else {
    entry.left
  }
}

#let get_entry_right(entry) = {
  if type(entry) == dictionary {
    entry.right
  } else if type(entry) == array and entry.len() >= 2 {
    entry.at(1)
  } else {
    entry.right
  }
}

// Create a simple two-column table
#let two_column_table(entries) = {
  let table_rows = ()
  for entry in entries {
    let left = get_entry_left(entry)
    let right = get_entry_right(entry)
    table_rows.push(left)
    table_rows.push(right)
  }
  
  table(
    columns: (auto, 1fr),
    stroke: none,
    column-gutter: cv_config.table_column_gutter,
    ..table_rows
  )
}

// Create a single column table
#let single_column_table(entries) = {
  let table_rows = ()
  for entry in entries {
    table_rows.push(entry)
  }
  
  table(
    columns: (1fr,),
    stroke: none,
    ..table_rows
  )
}

// Format a section with heading
#let section(title, content) = [
  = #title
  #content
]

// Format a subsection with heading
#let subsection(title, content) = [
  == #title
  #content
]

// Format a subsubsection with heading
#let subsubsection(title, content) = [
  === #title
  #content
]