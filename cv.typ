// Fixed CV template with ALL content restored and working
// This version successfully compiles with all sections

// Import fixed styling system
#import "styles/base.typ": apply_base_style, section, year_table
#import "styles/components.typ": *
#import "styles/yaml_csl_bibliography.typ": journal_articles_section, conference_papers_section, software_section, datasets_section, workshops_section, talks_section, presentations_section
#import "styles/yaml_data.typ": get_header_data, get_education_data, get_employment_data, get_grants_data, get_professional_activity_data, get_college_activity_data

// Apply base document styling
#show: apply_base_style

// Build the complete CV
#let header_data = get_header_data()
#cv_header(header_data.name, header_data.subtitle, header_data.contact_info, social_links: header_data.social_links, updated_date: header_data.updated_date)

#section("Education")[
  #let education_data = get_education_data()
  #education_section(education_data)
]

#section("Employment")[
  #let employment_data = get_employment_data()
  #employment_section(employment_data)
]

#section("Grants, Fellowships, Honors, and Awards")[
  #let grants_data = get_grants_data()
  #grants_section(grants_data)
]

#section("Professional Activity")[
  #let professional_activity_data = get_professional_activity_data()
  #professional_activity_section(professional_activity_data)
]

#section("Publications")[
  #text(size: 10pt, style: "italic")[\* denotes Vassar student collaborator]
  
  == Journal Articles
  #journal_articles_section()
  
  #pagebreak()
  
  == Conference Papers
  #conference_papers_section()
  
  == Workshops & Tutorials
  #workshops_section()
  
  == Invited Talks  
  #talks_section()
  
  == Conference Presentations
  #presentations_section()
  
  == Software (major releases only)
  #software_section()
  
  == Data Sets
  #datasets_section()
]

#section("College Activity")[
  #let college_activity_data = get_college_activity_data()
  #college_activity_section(college_activity_data)
]