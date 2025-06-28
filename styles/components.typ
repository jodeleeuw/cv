// Fixed component styling for specific CV elements
// This file handles both named tuples and array access patterns

#import "../config.typ": cv_config
#import "base.typ": year_table, two_column_table, single_column_table
#import "@preview/fontawesome:0.5.0": *

// Helper functions to safely access section fields
#let get_section_title(section) = {
  if type(section) == dictionary {
    section.title
  } else {
    section.title
  }
}

#let get_section_type(section) = {
  if type(section) == dictionary {
    section.type
  } else {
    section.type
  }
}

#let get_section_entries(section) = {
  if type(section) == dictionary {
    section.entries
  } else {
    section.entries
  }
}

#let get_section_page_break(section) = {
  if type(section) == dictionary {
    section.page_break
  } else {
    section.page_break
  }
}

// Helper functions to access data structure fields
#let get_data_sections(data) = {
  if type(data) == dictionary {
    data.sections
  } else {
    data.sections
  }
}

#let get_contact_info_left(contact_info) = {
  if type(contact_info) == dictionary {
    contact_info.left
  } else {
    contact_info.left
  }
}

#let get_contact_info_right(contact_info) = {
  if type(contact_info) == dictionary {
    contact_info.right
  } else {
    contact_info.right
  }
}


// Modern compact header component
#let cv_header(name, subtitle, contact_info, social_links: (), updated_date: "") = [

  #align(center)[
    #stack(
      dir: ttb, 
      spacing: 0.8em,
      text(font: cv_config.header_font, size: 22pt, weight: "bold")[#name],
      text(font: cv_config.header_font, size: 14pt, weight: "regular", fill: cv_config.accent_color)[#subtitle],
      text(font: cv_config.header_font, size: 11pt, weight: "regular", fill: gray)[#updated_date]
    )
  ]
  
  #v(0.35em)
  
  // Contact info in a clean horizontal layout  
  #align(center)[
    #text(size: 9pt, fill: cv_config.accent_color)[#contact_info.compact]
  ]
  
  // Social links with larger icons
  #if social_links.len() > 0 [
    #v(0.3em)
    #align(center)[
      #text(size: 8pt)[
        #for (i, social_link) in social_links.enumerate() [
          #if i > 0 [ #h(0.8em) #text(fill: cv_config.accent_color, size: 6pt)[•] #h(0.8em) ]
          #fa-icon(social_link.icon, size: 1.1em, fill: cv_config.accent_color) 
          #h(0.2em)#link(social_link.url, text(fill: cv_config.accent_color)[#social_link.display_url])
        ]
      ]
    ]
  ]
  
  #v(0.8em)
]

// Education component
#let education_section(education_data) = {
  year_table(education_data)
}

// Employment component  
#let employment_section(employment_data) = {
  year_table(employment_data)
}

// Grants and awards component (can handle multiple items per year)
#let grants_section(grants_data) = {
  year_table(grants_data)
}

// Professional activity component
#let professional_activity_section(activity_data) = {
  two_column_table(activity_data)
}

// College activity component with teaching and service
#let college_activity_section(activity_data) = [
  #let sections = get_data_sections(activity_data)
  #for section in sections [
    #let title = get_section_title(section)
    #let section_type = get_section_type(section)
    #let entries = get_section_entries(section)
    
    == #title
    
    #if section_type == "single_column" [
      #single_column_table(entries)
    ] else if section_type == "year_table" [
      #year_table(entries)
    ] else [
      #two_column_table(entries)
    ]
  ]
]