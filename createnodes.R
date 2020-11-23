library(neo4r)
con <- neo4j_api$new(
  url = "http://localhost:7474",
  user = "neo4j", 
  password = "12345"
)
library(glue)
orgchart <- read.csv("orgchartdata.csv.csv", TRUE)
for (row in 1:nrow(orgchart)) {
  UniqueIdentifier<- gsub("[0-9+_]", "", orgchart[row, "Unique.Identifier"])
  name <- orgchart[row, "Name"]
  title <- orgchart[row, "Line.Detail.1"]
  location <- orgchart[row, "Location"]
  temp <- glue("CREATE ({UniqueIdentifier}:Employee {{name: '{name}', title:'{title}', location: '{location}'}})")
  write.table(temp, file="output.csv", quote=FALSE, eol="\r\n", row.names = FALSE, col.names = FALSE)
  gsc = send_cypher("output.csv", con, type = c("graph"), output = c("r", "json"), include_stats = TRUE, meta = FALSE)
}