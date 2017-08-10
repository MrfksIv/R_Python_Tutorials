require("data.table")
require("R6")
require("assertive.types")
require("foreach")
require("parallel")
require("doParallel")
require("doSNOW")

#'  Data Import Class
#'   
#'  The class definition of the generic data import class. 
#'  This class should be extended to allow customisation for specific
#'  cases. 
#'

import_data_factory <- R6Class(
    "ImportDataClass",
    public = list(
        initialize = function(txtPath, sep=";", parallel="AUTO") {
            if (missing(txtPath)) {
                stop("The class requires the flat file directory to read from")
            } else {
                private$..txtPath = txtPath 
                private$..parallel = parallel
            }   
        },

        loadTransData = function(prefix="", ext=".txt", year="", lastFiles=NULL, firstFiles=NULL, keep=NULL, drop=NULL) {
            file_list <- private$getPathFiles(prefix, ext, year, lastFiles, firstFiles)
            if (is.null(keep)) {
                private$..select = names(private$..defaultFormats)
            }
            if (is.null(drop)) {
                private$..drop = c()
            }
            
            if (private$..parallel == "AUTO") {
                avg_file_size <- mean(file.info(file.path(private$..txtPath, file_list))$size)/1e6 #size in MB
                message(paste(length(file_list), "files to be loaded of average size:", round(avg_file_size, 2), "MB"))
                if (avg_file_size > 100 & length(file_list) > 3) {
                    private$..parallel = TRUE
                } else {
                    private$..parallel = FALSE
                }
            }
            if (!private$..parallel) {
                message("Running sequencially...")
                private$..data = foreach(index=1:length(file_list), .combine="rbind") %do% private$readAsDataTable(file_list[index])
            } else {
                message("Running in parallel...")
                cl <- parallel::makeCluster(min(detectCores() - 2, length(file_list)))
                parallel::clusterExport(cl, c("file_list", "private"), envir = environment())
                doParallel::registerDoParallel(cl)
                private$..data = foreach(index=1:length(file_list), .combine="rbind", .packages="data.table" ) %dopar% private$readAsDataTable(file_list[index])
                stopCluster(cl)
                gc()
            }
        }
    ),
    private = list(
        ..data = NULL,
        ..sep = ";",
        ..txtPath = "",
        ..parallel = "AUTO",
        ..encoding = "UTF-8",
        ..drop = NULL,
        ..select = NULL,
        ..defaultFormats = c(
            barcode="character", salesdate="YYMMDD", salestime="ITime", loyaltyno="character",
	        storecode="character", quantity="numeric", salesvalue="numeric", price="numeric",
	        salesvalue_exclvat= "numeric", price_exclvat="numeric", promotion= "character",
	        receipt_number= "character", key_row="character", flag="character", times= "integer"
        ),

        readAsDataTable = function(fileName) {
            data.table::fread(
                file.path(private$..txtPath, fileName), 
                colClasses= private$..defaultFormats, 
                drop = private$..drop,
                select = private$..select,
                encoding = private$..encoding
            )
        },

        getPathFiles = function(prefix="", ext=".txt", year="", lastFiles=NULL, firstFiles=NULL) {
            if (prefix == "") prefix = ".+"
            pattern <- paste0("^", prefix, "_", year, ".*\\",ext, "$")

            file_list <- list.files(private$..txtPath, pattern, ignore.case = TRUE)

            if(!is.null(lastFiles) & is.integer(as.integer(lastFiles))) {
                return(head(sort(file_list, decreasing = TRUE), lastFiles))
            } 

            if(!is.null(firstFiles) &is.integer(as.integer(firstFiles))) {
                return(tail(sort(file_list), firstFiles))
            }
            return(sort(file_list, decreasing = TRUE))
        }
    ),
    active = list(
        txtPath = function (path) {
            if (missing(path)) {
                private$..txtPath
            } else {
                private$..txtPath <- path
            }
        },
        sep = function(sep) {
            if (missing(sep)) {
                private$..sep
            } else {
                private$..sep <- sep
            }
        },
        parallel = function (bool) {
            if (missing(bool)) {
                private$..parallel
            } else {
                assertive.types::assert_is_a_bool(bool)
                private$..parallel <- bool
            }
        },
        defaultFormats = function (char_vec) {
            if (missing(char_vec)) {
                private$..defaultFormats
            } else {
                if(is.vector(char_vec) & is.character(char_vec)) {
                    private$..defaultFormats <- char_vec
                } else {
                    stop("The column formats should be of the form  c(salesvalue='numeric', barcode='character', ...)")
                }
                
                
            }
        },
        data = function () {
            if (is.null(private$..data)) {
                message("The object has no loaded data. You should call the loadTransData() first...")
            } else {
                private$..data
            }
        }
    )
)

am_seq <- import_data_factory$new("C:/Users/morfakis.c/Desktop/morf/1.RZ/R_Tests/RRZ_Data", parallel= FALSE)
am_parallel <-import_data_factory$new("C:/Users/morfakis.c/Desktop/morf/1.RZ/R_Tests/RRZ_Data")

library("microbenchmark")
microbenchmark(
    am_seq$loadTransData("alphamega", lastFiles=5),
    am_parallel$loadTransData("alphamega", lastFiles=5),
    times=1

)


bj$getPathFiles(prefix="alphamega", last=12)

bl_import_data_factory <- R6Class(
    "BLImportDataClass",
    inherit= import_data_factory,
    public = (
        getPathFiles = function() {
            asfa
            activesfasf
            asf

        }
    )
)



file_list<- c("ALPHAMEGA_201601.txt","ALPHAMEGA_201602.txt", "ALPHAMEGA_201603.txt")
min(detectCores() - 2, length(file_list)


setwd("C:/Users/morfakis.c/Desktop/morf/1.RZ/R_Tests/RRZ_Data")
doParal <- function() {
    cl <- parallel::makeCluster(min(detectCores() - 2, length(file_list)))
    parallel::clusterExport(cl, "file_list")
    doParallel::registerDoParallel(cl)
    dt <- foreach(index=1:length(file_list), .combine="rbind", .packages="data.table" ) %dopar% fread(file_list[index])
    stopCluster(cl)
    gc()
    dt
}

doSeq <- function() {
    foreach(index=1:length(file_list), .combine="rbind") %do% fread(file_list[index])   
}

library("microbenchmark")
microbenchmark(
    doParal(),
    doSeq(),
    times=2

)

