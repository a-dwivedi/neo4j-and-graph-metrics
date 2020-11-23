library(neo4r)
con <- neo4j_api$new(
  url = "http://localhost:7474",
  user = "neo4j", 
  password = "12345"
)
library(glue)
orgchart <- read.csv("orgchartdata.csv", TRUE)
for (row in 1:nrow(orgchart)) { 
  UniqueIdentifier <- gsub("[0-9+_]", "", orgchart[row, "Unique.Identifier"])
  Reoprt_To <-gsub("[0-9+_]", "", orgchart[row, "Reports.To"])
  temp <- glue("CREATE ({UniqueIdentifier})-[:REPORT_TO]->({Reoprt_To})")
  write.table(temp,file="relationOutput.txt",quote=FALSE,sep=";",eol="\r\n", row.names = FALSE, col.names = FALSE)
  gsc = send_cypher("relationOutput.txt", con, type = c("graph"), output = c("r", "json"), include_stats = TRUE, meta = FALSE)
}