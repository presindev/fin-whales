# Download fin whale occurrences from OBIS, save them as CSV and plot a map.
# Usage (from the project root): Rscript run_fin_whales.R

source(file.path("R", "fin_whale_obis.R"))
run_fin_whales(".")
