// YAML data processing functions for CV
// This file handles loading and formatting CV data from the unified data.yml file

#import "base.typ": year_table

// Load CV data from separate files
#let load_header_data() = {
  yaml("../data/header.yml")
}

#let load_education_data() = {
  yaml("../data/education.yml")
}

#let load_employment_data() = {
  yaml("../data/employment.yml")
}

#let load_grants_data() = {
  yaml("../data/grants.yml")
}

#let load_professional_activity_data() = {
  yaml("../data/professional_activity.yml")
}

#let load_college_activity_data() = {
  yaml("../data/college_activity.yml")
}

// Header formatting functions
#let format_header(header) = {
  let contact = header.contact_info
  
  // Format contact info
  let left_contact = [
    *Office:* #contact.office \
    *Mailing:* #contact.mailing
  ]
  
  let right_contact = [
    *Phone:* #contact.phone \
    *Email:* #contact.email
  ]
  
  // Format compact contact info for header
  let compact_contact = [
    #contact.office #h(1.5em) • #h(1.5em)
    #contact.phone #h(1.5em) • #h(1.5em)
    #contact.email
  ]
  
  // Format social links if they exist
  let social_links = if "social_links" in header {
    header.social_links
  } else {
    ()
  }
  
  (
    name: header.name,
    subtitle: header.subtitle,
    updated_date: "Updated " + datetime.today().display("[month repr:long] [day], [year]"),
    contact_info: (
      left: left_contact,
      right: right_contact,
      compact: compact_contact
    ),
    social_links: social_links
  )
}

// Education section formatting
#let format_education(education) = {
  let formatted = ()
  
  for entry in education {
    let content = entry.degree + ", " + entry.institution
    if "field" in entry {
      content = content + ", " + entry.field
    }
    if "honors" in entry {
      content = content + ". " + entry.honors
    }
    
    formatted.push((
      year: entry.year,
      content: content
    ))
  }
  
  formatted
}

// Employment section formatting
#let format_employment(employment) = {
  let formatted = ()
  
  for entry in employment {
    let content = entry.position + ", " + entry.institution
    if "location" in entry {
      content = content + ", " + entry.location
    }
    
    formatted.push((
      year: entry.year,
      content: content
    ))
  }
  
  formatted
}

// Grants section formatting
#let format_grants(grants) = {
  let formatted = ()
  
  for entry in grants {
    let content = ""
    
    // Add type prefix
    if "type" in entry {
      content = content + emph(entry.type) + ": "
    }
    
    // Add title
    content = content + entry.title + ". "
    
    // Add funder
    if "funder" in entry {
      content = content + entry.funder + ". "
    }
    
    // Add role and amount
    if "role" in entry and "amount" in entry {
      content = content + entry.role + ", " + entry.amount + "."
    } else if "role" in entry {
      content = content + entry.role + "."
    } else if "amount" in entry {
      content = content + entry.amount + "."
    }
    
    formatted.push((
      year: entry.year,
      content: content
    ))
  }
  
  formatted
}

// Professional activity section formatting
#let format_professional_activity(activity) = {
  let formatted = ()
  
  for entry in activity {
    formatted.push((
      left: entry.role,
      right: entry.details
    ))
  }
  
  formatted
}

// College activity section formatting
#let format_college_activity(activity) = {
  let formatted = (sections: ())
  
  for section in activity.sections {
    let formatted_section = (
      title: section.title,
      type: section.type,
      entries: ()
    )
    
    if section.type == "single_column" {
      formatted_section.entries = section.entries
    } else if section.type == "year_table" {
      for entry in section.entries {
        formatted_section.entries.push((
          year: entry.year,
          content: entry.content
        ))
      }
    }
    
    formatted.sections.push(formatted_section)
  }
  
  formatted
}

// Export functions to get formatted data
#let get_header_data() = {
  let data = load_header_data()
  format_header(data)
}

#let get_education_data() = {
  let data = load_education_data()
  format_education(data)
}

#let get_employment_data() = {
  let data = load_employment_data()
  format_employment(data)
}

#let get_grants_data() = {
  let data = load_grants_data()
  format_grants(data)
}

#let get_professional_activity_data() = {
  let data = load_professional_activity_data()
  format_professional_activity(data)
}

#let get_college_activity_data() = {
  let data = load_college_activity_data()
  format_college_activity(data)
}