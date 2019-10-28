# Compile data of all events, get the relevant columns
BBQ <- read.csv("~/Downloads/BBQ.csv", header=TRUE)[,c(1:7,9,13,14,19)]
AI <- read.csv("~/Downloads/AI.csv", header=TRUE)[,c(1:7,9,13,14,19)]
bernal <- read.csv("~/Downloads/bernal.csv", header=TRUE)[,c(1:7,9,13,14,19)]
farmers <- read.csv("~/Downloads/farmers.csv", header=TRUE)[,c(1:7,9,13,14,19)]
game1 <- read.csv("~/Downloads/game1.csv", header=TRUE)[,c(1:7,9,13,14,19)]
game2 <- read.csv("~/Downloads/game2.csv", header=TRUE)[,c(1:7,9,13,14,19)]
mentalhealth <- read.csv("~/Downloads/mentalhealth.csv", header=TRUE)[,c(1:7,9,13,14,19)]
noe <- read.csv("~/Downloads/noe.csv", header=TRUE)[,c(1:7,9,13,14,19)]
College.University <- data.frame("College.University" = rep(NA, nrow(pizzas)))
pizzas <- read.csv("~/Downloads/pizzas.csv", header=TRUE)
pizza <- cbind(pizzas[,c(1:7,9)],College.University,pizzas[,c(13,16)])
portola1 <- read.csv("~/Downloads/portola1.csv", header=TRUE)[,c(1:7,9,13,14,19)]
portola2 <- read.csv("~/Downloads/portola2.csv", header=TRUE)[,c(1:7,9,13,14,19)]
richmond <- read.csv("~/Downloads/richmond.csv", header=TRUE)[,c(1:7,9,13,14,19)]
russian <- read.csv("~/Downloads/russian.csv", header=TRUE)[,c(1:7,9,13,14,19)]
soma1 <- read.csv("~/Downloads/soma1.csv", header=TRUE)[,c(1:7,9,13,14,19)]
soma2 <- read.csv("~/Downloads/soma2.csv", header=TRUE)[,c(1:7,9,13,14,19)]
soma3 <- read.csv("~/Downloads/soma3.csv", header=TRUE)[,c(1:7,9,13,14,19)]
sunset1 <- read.csv("~/Downloads/sunset1.csv", header=TRUE)[,c(1:7,9,13,14,19)]
sunset2 <- read.csv("~/Downloads/sunset1.csv", header=TRUE)[,c(1:7,9,13,14,19)]
attendants <- rbind(AI, BBQ, bernal, farmers, game1, game2, mentalhealth, pizza, noe, portola1, portola2, richmond, russian, soma1, soma2, soma3, sunset1, sunset2)
attendants$Full.Name <- paste(attendants$First.Name,attendants$Last.Name)

# Those who came at least once and more than once
at_least_once <- as.data.frame(table(attendants$Full.Name))
more_than_once <- at_least_once[which(at_least_once$Freq > 1),]

# Data for each individual
sorted_names <- cbind(at_least_once, data.frame("College" = rep(NA, nrow(at_least_once))), data.frame("Company" = rep(NA, nrow(at_least_once))))


# Fill in college and company info for each unique intern
for (x in sorted_names$Var1) {
  sorted_names[which(sorted_names$Var1 == x),][1, "College"] <- tolower(as.character(attendants[which(attendants$Full.Name == x),][1, "College.University"]))
}

for (x in sorted_names$Var1) {
  sorted_names[which(sorted_names$Var1 == x),][1, "Company"] <- tolower(as.character(attendants[which(attendants$Full.Name == x),][1, "What.company.do.you.intern.for."]))
}

# Fill in missing data
sorted_names[which(is.na(sorted_names$College) == TRUE),][, "College"] = "n/a"
sorted_names[which(sorted_names$Var1 == "Shiao-li Green"),][1, "College"] = "minerva"
sorted_names[which(sorted_names$Var1 == "Shiao-li Green"),][1, "Company"] = "edpuzzle"
sorted_names[which(sorted_names$Var1 == "Rachel Nguyen"),][1, "College"] = "minerva"

# Homogenize different names for the same colleges
for (each in sorted_names$College) {
  if (grepl("minerva", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "minerva"
  } 
  if (grepl("harvard", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "harvard"
  }
  if (grepl("massachusetts institute of technology", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "mit"
  }
  if (grepl("berkeley", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "uc berkeley"
  }
  if (grepl("irvine", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "uc irvine"
  }
  if (grepl("ubc", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "university of british columbia"
  }
  if (grepl("urbana", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "uiuc"
  }
  if (grepl("amherst", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "umass amherst"
  }
  if (grepl("penn", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "university of pennsylvania"
  }
  if (grepl("washington", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "university of washington"
  }
  if (grepl("waterloo", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "university of waterloo"
  }
  if (grepl("wharton", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "wharton school"
  }
}

# Homogenize different names for the same companies
for (each in sorted_names$Company) {
  if (grepl("fb", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "facebook"
  }
  if (grepl("google", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "google"
  }
  if (grepl("minerva", each)) {
    sorted_names[which(sorted_names$College == each),][1, "College"] = "minerva"
  }
}

# Rank the frequencies of companies
companies <- as.data.frame(table(sorted_names$Company))
companies_sorted <- companies[order(companies$Freq, decreasing = TRUE),]

# Rank the frequencies of universities
universities <- as.data.frame(table(sorted_names$College))
universities_sorted <- universities[order(universities$Freq, decreasing = TRUE),]

# Extract data for each question
write.csv(at_least_once, "/Users/trangnguyenvn1398/Desktop/tris/at_least_once.csv", row.names = FALSE)
write.csv(more_than_once, "/Users/trangnguyenvn1398/Desktop/tris/more_than_once.csv", row.names = FALSE)
write.csv(companies_sorted, "/Users/trangnguyenvn1398/Desktop/tris/companies.csv", row.names = FALSE)
write.csv(universities_sorted, "/Users/trangnguyenvn1398/Desktop/tris/universities.csv", row.names = FALSE)
write.csv(attendants, "/Users/trangnguyenvn1398/Desktop/tris/attendant_raw.csv", row.names = FALSE)

# Print out results for each question
print("Number of interns who came at least once: ")
nrow(at_least_once)
print("Number of interns who came more than once: ")
nrow(more_than_once)
print("Top 5 univerities: ")
universities_sorted[c(1:5),]
print("Top 5 companies: ")
companies_sorted[c(1:5),]
