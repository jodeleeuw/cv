// Manual CSL-style bibliography formatting using Typst's YAML parser
// This approach gives us complete control over grouping, filtering, and formatting

#import "base.typ": year_table

// Load and parse the Hayagriva YAML file
#let load_bibliography_data() = {
  yaml("../data/publications.yml")
}

// Extract year from date field
#let extract_year(date_value) = {
  if date_value == none { return "unknown" }
  
  let date_str = str(date_value)
  if date_str.contains("-") {
    date_str.split("-").at(0)
  } else {
    date_str.slice(0, 4)
  }
}

// Format author list in APA style
#let format_authors(authors) = {
  if authors.len() == 0 { return "" }
  
  if authors.len() == 1 {
    authors.at(0)
  } else if authors.len() == 2 {
    authors.at(0) + ", & " + authors.at(1)
  } else if authors.len() <= 20 {
    let result = ""
    for (i, author) in authors.enumerate() {
      if i == 0 {
        result = author
      } else if i == authors.len() - 1 {
        result = result + ", & " + author
      } else {
        result = result + ", " + author
      }
    }
    result
  } else {
    // More than 7 authors - use et al.
    let first_authors = authors.slice(0, 19)
    let result = first_authors.join(", ") + ", ... " + authors.at(-1)
    result
  }
}

// Format a journal article in APA style
#let format_journal_article(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year + "). " + title + ". "
  
  if "parent" in entry {
    let parent = entry.parent
    result = result + emph(parent.title)
    
    if "volume" in parent {
      result = result + ", " + str(parent.volume)
    }
    if "issue" in parent {
      result = result + "(" + str(parent.issue) + ")"
    }
    if "page-range" in parent {
      result = result + ", " + parent.page-range
    }
    result = result + ". "
  }
  
  if "doi" in entry {
    result = result + box(link("https://doi.org/" + entry.doi))
  } else if "url" in entry {
    result = result + box(link(entry.url))
  }
  
  if "note" in entry {
    result = result + " [" + entry.note + "]"
  }
  
  result
}

// Format a conference paper in APA style
#let format_conference_paper(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year + "). " + title + ". "
  
  if "parent" in entry {
    let parent = entry.parent
    if "editor" in parent {
      let editors = if type(parent.editor) == array { parent.editor } else { (parent.editor,) }
      result = result + "In " + editors.join(", ")
      if editors.len() == 1 {
        result = result + " (Ed.), "
      } else {
        result = result + " (Eds.), "
      }
    }
    
    result = result + emph(parent.title)
    
    if "page-range" in entry {
      result = result + " (pp. " + entry.page-range + ")"
    }
    result = result + ". "
    
    if "location" in parent and "publisher" in parent {
      result = result + parent.location + ": " + parent.publisher + "."
    }
  }
  
  if "doi" in entry {
    result = result + " " + box(link("https://doi.org/" + entry.doi))
  } else if "url" in entry {
    result = result + " " + box(link(entry.url))
  }
  
  result
}

// Format software/repository in APA style
#let format_software(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year
  
  // Add specific date if available
  if "date" in entry {
    let date_str = str(entry.date)
    if date_str.contains("-") {
      let parts = date_str.split("-")
      if parts.len() >= 3 {
        let months = ("", "January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December")
        let month_num = int(parts.at(1))
        if month_num > 0 and month_num <= 12 {
          result = result + ", " + months.at(month_num) + " " + parts.at(2)
        }
      }
    }
  }
  
  result = result + "). " + emph(title)
  
  if "version" in entry {
    result = result + " (Version " + entry.version + ")"
  }
  
  result = result + ". "
  
  if "url" in entry {
    result = result + box(link(entry.url))
  }
  
  result
}

// Format dataset/misc in APA style
#let format_dataset(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year + "). " + emph(title) + " [Data set]. "
  
  if "doi" in entry {
    result = result + box(link("https://doi.org/" + entry.doi))
  } else if "url" in entry {
    result = result + box(link(entry.url))
  }
  
  result
}

// Format workshop in APA style
#let format_workshop(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year + "). " + title + ". "
  
  if "venue" in entry {
    result = result + emph(entry.venue) + "."
  }
  
  if "parent" in entry {
    let parent = entry.parent
    result = result + "In " + emph(parent.title)
    if "page-range" in entry {
      result = result + " (pp. " + entry.page-range + ")"
    }
    result = result + ". "
    if "location" in parent {
      result = result + parent.location + ": "
    }
    if "publisher" in parent {
      result = result + parent.publisher + "."
    }
  }
  
  result
}

// Format invited talk in APA style
#let format_talk(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year + "). " + title + ". "
  
  if "venue" in entry {
    result = result + emph(entry.venue) + "."
  }
  
  result
}

// Format conference presentation in APA style
#let format_presentation(entry) = {
  let authors = format_authors(entry.author)
  let year = extract_year(entry.date)
  let title = entry.title
  
  let result = authors + " (" + year + "). " + title + ". "
  
  if "venue" in entry {
    result = result + emph(entry.venue)
  }
  
  if "note" in entry {
    result = result + " (" + entry.note + ")"
  }
  
  result = result + "."
  
  result
}

// Filter entries by type and parent type
#let filter_entries(entries, filter_func) = {
  let filtered = (:)
  for (key, entry) in entries.pairs() {
    if filter_func(entry) {
      filtered.insert(key, entry)
    }
  }
  filtered
}

// Journal articles: Articles with Periodical parents
#let is_journal_article(entry) = {
  entry.type == "Article" and "parent" in entry and entry.parent.type == "Periodical"
}

// Conference papers: Articles with Conference parents
#let is_conference_paper(entry) = {
  entry.type == "Article" and "parent" in entry and entry.parent.type == "Conference"
}

// Software: Repository type
#let is_software(entry) = {
  entry.type == "Repository"
}

// Datasets: Misc type
#let is_dataset(entry) = {
  entry.type == "Misc"
}

// Workshops: Workshop type
#let is_workshop(entry) = {
  entry.type == "Workshop"
}

// Invited talks: Talk type
#let is_talk(entry) = {
  entry.type == "Talk"
}

// Conference presentations: Presentation type
#let is_presentation(entry) = {
  entry.type == "Presentation"
}

// Group filtered entries by year with special categories
#let group_by_year(entries, format_func) = {
  let groups = (:)
  let special_groups = (:)
  
  for (key, entry) in entries.pairs() {
    let year_key = extract_year(entry.date)
    let formatted_entry = format_func(entry)
    
    // Check for special categories
    let is_special = false
    if "note" in entry {
      let note = entry.note
      if note.contains("under review") or note.contains("Under review") {
        if "Under review" not in special_groups {
          special_groups.insert("Under review", ())
        }
        special_groups.at("Under review").push(formatted_entry)
        is_special = true
      } else if note.contains("preprint") or note.contains("Preprint") {
        if "Pre-prints" not in special_groups {
          special_groups.insert("Pre-prints", ())
        }
        special_groups.at("Pre-prints").push(formatted_entry)
        is_special = true
      }
    }
    
    // If not special, add to regular year groups
    if not is_special and year_key != "unknown" {
      if year_key not in groups {
        groups.insert(year_key, ())
      }
      groups.at(year_key).push(formatted_entry)
    }
  }
  
  // Convert to year table format
  let year_table_data = ()
  
  // Add special categories first
  let special_order = ("Under review", "Pre-prints")
  for special_year in special_order {
    if special_year in special_groups and special_groups.at(special_year).len() > 0 {
      year_table_data.push((
        year: special_year,
        content: special_groups.at(special_year).join([
          
        ])
      ))
    }
  }
  
  // Add regular years in reverse chronological order
  let year_keys = groups.keys().map(k => int(k)).sorted().rev()
  for year_num in year_keys {
    let year_str = str(year_num)
    if groups.at(year_str).len() > 0 {
      year_table_data.push((
        year: year_str,
        content: groups.at(year_str).join([
          
        ])
      ))
    }
  }
  
  year_table_data
}

// Publication section functions
#let journal_articles_section() = {
  let all_entries = load_bibliography_data()
  let journal_articles = filter_entries(all_entries, is_journal_article)
  let grouped_data = group_by_year(journal_articles, format_journal_article)
  year_table(grouped_data)
}

#let conference_papers_section() = {
  let all_entries = load_bibliography_data()
  let conference_papers = filter_entries(all_entries, is_conference_paper)
  let grouped_data = group_by_year(conference_papers, format_conference_paper)
  year_table(grouped_data)
}

#let software_section() = {
  let all_entries = load_bibliography_data()
  let software_entries = filter_entries(all_entries, is_software)
  let grouped_data = group_by_year(software_entries, format_software)
  year_table(grouped_data)
}

#let datasets_section() = {
  let all_entries = load_bibliography_data()
  let dataset_entries = filter_entries(all_entries, is_dataset)
  let grouped_data = group_by_year(dataset_entries, format_dataset)
  year_table(grouped_data)
}

#let workshops_section() = {
  let all_entries = load_bibliography_data()
  let workshop_entries = filter_entries(all_entries, is_workshop)
  let grouped_data = group_by_year(workshop_entries, format_workshop)
  year_table(grouped_data)
}

#let talks_section() = {
  let all_entries = load_bibliography_data()
  let talk_entries = filter_entries(all_entries, is_talk)
  let grouped_data = group_by_year(talk_entries, format_talk)
  year_table(grouped_data)
}

#let presentations_section() = {
  let all_entries = load_bibliography_data()
  let presentation_entries = filter_entries(all_entries, is_presentation)
  let grouped_data = group_by_year(presentation_entries, format_presentation)
  year_table(grouped_data)
}