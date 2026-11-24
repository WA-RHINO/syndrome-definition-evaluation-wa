## Load ESSENCE Credentials
tryCatch({load("~/myProfileWA.rda");load("~/myProfileWA.rda")}, # Load myProfile credentials
         
         # If myProfile credentials are not available at the home directory, regenerate them! 
         error = function(e) {browseURL("https://github.com/WA-RHINO/rhino-essence-api-resources/wiki/ESSENCE-Credentials-Management")}) 

