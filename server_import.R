
trials <- read.delim("data/trials.txt", sep="\t", header=TRUE, na.strings = "", fileEncoding = "UTF-8")
id <- str_split_fixed(trials$プロトコルID, "-", n=2)
id[id[,2] == "",][,2] <- id[id[,2] == "",][,1]
id[id[,2] == "BDR",][,2] <- apply(id[id[,2] == "BDR",], 1, function(x){paste0(x, collapse = "-")})
trials$society <- id[,1]
trials$resID <- id[,2]
trials[,25:34] <- apply(trials[,25:34], 2, function(x) { x <- gsub("竹内の", "竹内", x)})

member <- read.delim("data/address.csv", sep=",", header=TRUE)
dm_list <- as.list(member$id)
names(dm_list) <- member$name
