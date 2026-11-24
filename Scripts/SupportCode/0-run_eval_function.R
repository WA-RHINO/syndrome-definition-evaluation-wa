
run_evaluation <- function(n_defs_eval,
                           def_info_table = "DefinitionInformationTable.xlsx",
                           timed = FALSE) {
  
  # Step 0 (Optional-Start): Time the Syndrome Evaluation Toolkit
  if (timed == TRUE) {
    tictoc::tic("Syndrome Evaluation Toolkit") # Start Timing - Entire Toolkit
  }
  
  
  # Step 1: Read in User Selected Options
  DefinitionInformation <- multiplesheets(fname = def_info_table)
  
  ## 1a. Return the User Selected Options to the Global Environment
  ### Description: This is needed in the Global Environment to render the .Rmd template.
  assign("DefinitionInformation", DefinitionInformation, envir = .GlobalEnv)
  
  
  # Step 2: Perform Checks to Ensure Tool is Being Utilized Correctly.
  if(n_defs_eval > 3){stop("This tool can only analyze up to 3 syndromes simultaneously. Please change n_defs_eval to a value <= 3.")}
  
  if (n_defs_eval == 2) {
    instance1 <- stringr::str_extract(DefinitionInformation$DefinitionInformation$API[1],"((?<=.com/)|(?<=.org/)).+(?=/api/)")
    instance2 <- stringr::str_extract(DefinitionInformation$DefinitionInformation$API[2],"((?<=.com/)|(?<=.org/)).+(?=/api/)")
    if (instance1!=instance2) {
      stop("This tool can only compare data pulled from the same instance of ESSENCE at this time. Please update all APIs to pull from either WA ESSENCE or NSSP ESSENCE.")
    }
  }
  
  if (n_defs_eval == 3) {
    instance1 <- stringr::str_extract(DefinitionInformation$DefinitionInformation$API[1],"((?<=.com/)|(?<=.org/)).+(?=/api/)")
    instance2 <- stringr::str_extract(DefinitionInformation$DefinitionInformation$API[2],"((?<=.com/)|(?<=.org/)).+(?=/api/)")
    instance3 <- stringr::str_extract(DefinitionInformation$DefinitionInformation$API[3],"((?<=.com/)|(?<=.org/)).+(?=/api/)")
    if (instance1!=instance2|instance1!=instance3|instance2!=instance3) {
      stop("This tool can only compare data pulled from the same instance of ESSENCE at this time. Please update all APIs to pull from either WA ESSENCE or NSSP ESSENCE.")
    }
  }

  ## 2a. Return n_defs_eval to the Global Environment
  ### Description: This is needed in the Global Environment to render the .Rmd template.
  assign("n_defs_eval", n_defs_eval, envir = .GlobalEnv)
  
  # Step 3: Source Pre-Processing Scripts
  
  ## 3a. Parameter Script (No need to edit, pulls information from DefinitionInformation.xlsx)
  source(here::here("Scripts", "1_parameters.R"))
  
  ## 3b. Data Pull & Cleaning Script
  source(here::here("Scripts", "2_process_data.R"))
  
  
  # Step 4: Render Syndrome Definition Evaluation Report
  rmarkdown::render(input = "Scripts/Syndrome Evaluation Report Template.Rmd",
                    output_dir = params$filepaths$output,
                    output_file = paste0("Syndrome Evaluation Report.html"),
                    params = params)
  
  
  # Step 0 (Optional-End): Time the Syndrome Evaluation Toolkit
  if (timed == TRUE) {
    tictoc::toc() # End Timing - Entire Toolkit
  }
  
}
