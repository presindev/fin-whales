# Offline tests for FW-001 (specs/fin-whale-obis-map). robis::occurrence is
# always mocked; no network access (NFR-003).

fixture <- function(n = 5) {
  tibble::tibble(
    id = paste0("rec-", seq_len(n)),
    scientificName = "Balaenoptera physalus",
    decimalLongitude = seq(-60, 60, length.out = n),
    decimalLatitude = seq(-40, 40, length.out = n),
    eventDate = "2020-06-01",
    date_year = 2020L,
    basisOfRecord = "HumanObservation",
    individualCount = NA_character_,
    datasetName = "Fixture dataset",
    datasetID = "ds-1"
  )
}

test_that("AT1: download requests fin whale AphiaID and the REQ-003 fields", {
  seen <- NULL
  local_mocked_bindings(
    occurrence = function(...) {
      seen <<- list(...)
      fixture()
    },
    .package = "robis"
  )
  df <- download_fin_whales()
  expect_identical(seen$taxonid, 137091L)
  expect_identical(seen$fields, OBIS_FIELDS)
  expect_identical(names(df), OBIS_FIELDS)
})

test_that("download adds REQ-003 columns missing from the OBIS response", {
  local_mocked_bindings(
    occurrence = function(...) fixture()[, c("id", "decimalLongitude", "decimalLatitude")],
    .package = "robis"
  )
  df <- download_fin_whales()
  expect_identical(names(df), OBIS_FIELDS)
  expect_true(all(is.na(df$datasetName)))
})

test_that("AT2 + AT4: run writes CSV with header and REQ-003 columns, and a PNG", {
  local_mocked_bindings(occurrence = function(...) fixture(7), .package = "robis")
  out <- withr::local_tempdir()
  res <- suppressMessages(run_fin_whales(out))
  expect_identical(res$total, 7L)
  csv <- utils::read.csv(res$csv)
  expect_identical(names(csv), OBIS_FIELDS)
  expect_identical(nrow(csv), 7L)
  expect_identical(basename(res$csv), "fin_whale_occurrences.csv")
  expect_identical(basename(res$png), "fin_whale_map.png")
  expect_gt(file.size(res$png), 0)
  expect_length(list.files(out, all.files = TRUE, no.. = TRUE), 2L)
})

test_that("AT3: map is in EPSG:4326 and shows the total in the title", {
  p <- plot_fin_whale_map(fixture(5))
  expect_s3_class(p$coordinates, "CoordSf")
  expect_identical(sf::st_crs(p$coordinates$crs), sf::st_crs(4326))
  labs <- ggplot2::get_labs(p)
  expect_match(labs$title, "total: 5", fixed = TRUE)
  expect_null(labs$subtitle)
})

test_that("AT3: large totals are formatted with thousands separators", {
  df <- fixture(1)[rep(1, 1234), ]
  expect_match(ggplot2::get_labs(plot_fin_whale_map(df))$title, "total: 1,234", fixed = TRUE)
})

test_that("AT-EDGE1: invalid coordinates stay in the CSV but are omitted from the map", {
  df <- fixture(6)
  df$decimalLongitude[1] <- NA
  df$decimalLatitude[2] <- 95
  df$decimalLongitude[3] <- -181
  expect_identical(valid_coords(df), c(FALSE, FALSE, FALSE, TRUE, TRUE, TRUE))

  p <- plot_fin_whale_map(df)
  labs <- ggplot2::get_labs(p)
  expect_match(labs$title, "total: 6", fixed = TRUE)
  expect_match(labs$subtitle, "3 records without valid coordinates", fixed = TRUE)

  local_mocked_bindings(occurrence = function(...) df, .package = "robis")
  out <- withr::local_tempdir()
  res <- suppressMessages(run_fin_whales(out))
  expect_identical(nrow(utils::read.csv(res$csv)), 6L)
})

test_that("AT-ERR1: OBIS failure errors and leaves existing outputs untouched", {
  local_mocked_bindings(
    occurrence = function(...) stop("HTTP 503"),
    .package = "robis"
  )
  out <- withr::local_tempdir()
  csv <- file.path(out, "fin_whale_occurrences.csv")
  png <- file.path(out, "fin_whale_map.png")
  writeLines("old", csv)
  writeLines("old", png)
  expect_error(run_fin_whales(out), "OBIS download failed: HTTP 503")
  expect_identical(readLines(csv), "old")
  expect_identical(readLines(png), "old")
})

test_that("AT-ERR2: zero records errors and writes no files", {
  local_mocked_bindings(occurrence = function(...) tibble::tibble(), .package = "robis")
  out <- withr::local_tempdir()
  expect_error(run_fin_whales(out), "OBIS returned no fin whale records")
  expect_length(list.files(out, all.files = TRUE, no.. = TRUE), 0L)
})
