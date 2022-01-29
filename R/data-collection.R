# Data collection script for UW SOC 533 A

## Setup ----
library(demogR)
library(dplyr)
library(HMDHFDplus)

## Question set 1 ----
data(goodman)
mad1966counts <- goodman %>% dplyr::select(age, mad.nKx, mad.nDx)
mad1966lt <- demogR::life.table(
  x = mad1966counts$age,
  nKx = mad1966counts$mad.nKx,
  nDx = mad1966counts$mad.nDx
) %>%
  setNames(nm = stringr::str_replace_all(names(.), pattern = "^n", "")) %>%
  dplyr::rename(mx = Mx)
saveRDS(madlt, "data/q01_data.rds")

## Question set 2 ----
ukr2013rates <- HMDHFDplus::readHMDweb(
  CNTRY = "UKR",
  item = "Mx_5x1",
  username = keyring::key_list("human-mortality-database")$username,
  password = keyring::key_get(
    service = "human-mortality-database",
    username = keyring::key_list("human-mortality-database")$username
  )
) %>%
  dplyr::filter(Year == 2013) %>%
  dplyr::rename(x = Age, mx = Total) %>%
  dplyr::select(x, mx)
saveRDS(ukr2013rates, "data/q02_data.rds")
