# Fin whale (Balaenoptera physalus) occurrences from OBIS: download, save as
# CSV, and plot on a georeferenced map. Spec: specs/fin-whale-obis-map/.

FIN_WHALE_APHIA_ID <- 137091L # nolint: object_name_linter.

OBIS_FIELDS <- c( # nolint: object_name_linter.
  "id", "scientificName", "decimalLongitude", "decimalLatitude",
  "eventDate", "date_year", "basisOfRecord", "individualCount",
  "datasetName", "datasetID"
)

# Download every OBIS occurrence record for the taxon (child taxa included),
# restricted to `fields`. Columns OBIS omits are added as NA so the output
# always has exactly `fields`, in that order.
download_fin_whales <- function(taxonid = FIN_WHALE_APHIA_ID,
                                fields = OBIS_FIELDS) {
  df <- tryCatch(
    robis::occurrence(taxonid = taxonid, fields = fields),
    error = function(e) {
      stop("OBIS download failed: ", conditionMessage(e), call. = FALSE)
    }
  )
  if (is.null(df) || nrow(df) == 0) {
    stop("OBIS returned no fin whale records (taxonid ", taxonid, ").",
      call. = FALSE
    )
  }
  for (col in setdiff(fields, names(df))) {
    df[[col]] <- NA
  }
  dplyr::select(df, dplyr::all_of(fields))
}

# TRUE where a record has plottable WGS84 coordinates.
valid_coords <- function(df) {
  lon <- suppressWarnings(as.numeric(df$decimalLongitude))
  lat <- suppressWarnings(as.numeric(df$decimalLatitude))
  !is.na(lon) & !is.na(lat) & abs(lon) <= 180 & abs(lat) <= 90
}

plot_fin_whale_map <- function(df) {
  ok <- valid_coords(df)
  total <- nrow(df)
  omitted <- sum(!ok)

  points <- sf::st_as_sf(
    data.frame(
      lon = as.numeric(df$decimalLongitude[ok]),
      lat = as.numeric(df$decimalLatitude[ok])
    ),
    coords = c("lon", "lat"),
    crs = 4326
  )
  world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")

  subtitle <- if (omitted > 0) {
    sprintf(
      "%s records without valid coordinates are not shown",
      format(omitted, big.mark = ",")
    )
  }

  ggplot2::ggplot() +
    ggplot2::geom_sf(
      data = world, fill = "grey88", colour = "grey65", linewidth = 0.1
    ) +
    ggplot2::geom_sf(
      data = points, colour = "#1f5f8b", alpha = 0.25, size = 0.4
    ) +
    ggplot2::coord_sf(crs = sf::st_crs(4326), expand = FALSE) +
    ggplot2::labs(
      title = sprintf(
        "Fin whale (Balaenoptera physalus) observations in OBIS — total: %s",
        format(total, big.mark = ",")
      ),
      subtitle = subtitle,
      caption = sprintf("Source: OBIS (obis.org), accessed %s", Sys.Date()),
      x = "Longitude",
      y = "Latitude"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      panel.grid = ggplot2::element_line(colour = "grey92", linewidth = 0.2)
    )
}

# Write via a temporary file in the same directory, then rename over `path`,
# so an existing file is only replaced by a complete one. The temp name keeps
# the extension because ggsave picks the device from it.
write_atomic <- function(path, writer) {
  tmp <- file.path(dirname(path), paste0(".tmp-", basename(path)))
  on.exit(if (file.exists(tmp)) unlink(tmp), add = TRUE)
  writer(tmp)
  if (!file.rename(tmp, path)) {
    stop("Could not write ", path, call. = FALSE)
  }
  path
}

run_fin_whales <- function(out_dir = ".") {
  df <- download_fin_whales()

  csv <- file.path(out_dir, "fin_whale_occurrences.csv")
  png <- file.path(out_dir, "fin_whale_map.png")

  write_atomic(csv, function(tmp) {
    utils::write.csv(df, tmp, row.names = FALSE, na = "")
  })
  map <- plot_fin_whale_map(df)
  write_atomic(png, function(tmp) {
    ggplot2::ggsave(tmp, map, width = 12, height = 6.5, dpi = 200, bg = "white")
  })

  total <- nrow(df)
  message(sprintf(
    "Total fin whale observations: %s", format(total, big.mark = ",")
  ))
  message("CSV written: ", normalizePath(csv))
  message("Map written: ", normalizePath(png))
  invisible(list(total = total, csv = csv, png = png))
}
