# Setup

# Install packages if not present
package_list <- c("auk", 
                  "fasterize",
                  "here",
                  "rmarkdown",
                  "rnaturalearth",
                  "sf",
                  "tidyverse")

package_new <- package_list[!(package_list %in% installed.packages()[,"Package"])]
if(length(package_new)) install.packages(package_new)

# Create directories if they don't exist
dirs <- c("./Data", "./Data/Raw", "./Data/Datasets", "./Data/Metadata",
          "./Results")

for(i in dirs) if(!dir.exists(i)) dir.create(i)
  