pacman::p_load(tidyverse,vroom,sparklyr, data.table,geobr, foreach)

getwd()


if (file.exists("datasus")) { print("A pasta já existe")} else {  dir.create("datasus")}

download.file("ftp://ftp.datasus.gov.br/dissemin/publicos/SINASC/1996_/Dados/DNRES/", "./datasus/referencia.txt")
teste <- read_table("datasus/referencia.txt",col_names = FALSE)

arquivo <- teste$X4
link <- paste("ftp://ftp.datasus.gov.br/dissemin/publicos/SINASC/1996_/Dados/DNRES/" , arquivo, sep="")
endereco_no_ssd <- paste("./datasus/",arquivo,sep="")

foreach(i = 1:686) %dopar% {download.file(link[i], endereco_no_ssd[i],mode="wb")}



#########################
## 2

pacman::p_load(arrow,read.dbc)
banco_teste <- list()

#cl <- parallel::makePSOCKcluster(2) # cria as cópias do R que rodam em paralelo
#doParallel::registerDoParallel(cl) 

for (i in 1:686){
  banco_teste[[i]] <- read.dbc(endereco_no_ssd[i])
}
###

nomes <- str_sub(arquivo,start=1,end=8)
nome_par <- paste(nomes,".parquet",sep="")
nomep <- paste("./datasus/",nome_par,sep="")


for (i in 1:686){
  write_parquet(as.data.frame(banco_teste[i]), nomep[i])}






nomes_totais <- as.tibble( arquivo)
nome_GO <- nomes_totais %>%
  filter(str_detect(value, "GO"))
nome_MS <- nomes_totais %>%
  filter(str_detect(value, "MS"))
nome_ES <- nomes_totais %>%
  filter(str_detect(value, "ES"))

nomes_totais <- rbind(nome_ES,nome_GO,nome_MS)
selecionados <- as.vector(nomes_totais)
selecionados <- selecionados$value

selecionados2 <- paste("./datasus/",selecionados,sep="")

banco2 <- list()
for (i in 1:75){
  banco2[[i]] <- read.dbc(selecionados2[i])}

selecao2 <- str_sub(selecionados,start=1,end=8)
selecao2 <- paste(selecao2,".csv",sep="")
selecao2p <- paste("./datasus/",selecao2,sep="")

for (i in 1:75){
  vroom_write(as.data.frame(banco2[i]),selecao2p[i])}




selecao3 <- str_sub(selecionados,start=1,end=8)
selecao3 <- paste(selecao3,".parquet",sep="")
selecao3 <- paste("./datasus/",selecao3,sep="")
arquivosCSV <- selecao2p
arquivosPARQUET <- selecao3
require(fs)
fscsv1 <- file.size(arquivosCSV)
fsparquet1 <- file.size(arquivosPARQUET)
fscsv2 <- file_size(arquivosCSV)
fsparquet2 <- file_size(arquivosPARQUET)
diferenca <- file_size(arquivosCSV) - file_size(arquivosPARQUET)
diferencasomada <- sum(diferenca)
diferenca <- as.data.frame(diferenca)

# C
df <- arquivosCSV %>%
  map(fread,
      nThread=3,
      fill=TRUE) %>%
  rbindlist(fill=TRUE)
df <- df[,1:21]
vroom_write(df,"./datasus/dfcsv")
dfparquet <- arquivosPARQUET %>%
  map(read_parquet) %>%
  rbindlist(fill=TRUE)
dfparquet <- dfparquet[,1:21]
write_parquet(dfparquet,"./datasus/dfparquet")
config <- spark_config()
config$sparklyr.connect.cores.local =3
sc <- spark_connect(master = "local")
teste_velocidade <- microbenchmark(
  {dfcsv = spark_read_csv(sc=sc,
                          name = "dfcsv",
                          path = "./datasus/dfcsv",
                          header = TRUE,
                          delimiter = "\\t",
                          charset = "latin1",
                          infer_schema = T,
                          overwrite = T)},
  {dfparquet = spark_read_parquet(sc=sc,
                                  name = "dfparquet",
                                  path = "./datasus/dfparquet",
                                  header = TRUE,
                                  delimiter = "\\t",
                                  charset = "latin1",
                                  infer_schema = T,
                                  overwrite = T)},times = 4)