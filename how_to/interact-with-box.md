---
title: "Interact with Box.com API"
output:
  html_document:
    toc: true
    toc_float: true
    toc_depth: 3
    code_folding: hide
    keep_md: true
---



# Purpose

This document describes how to interact with the Box.com API.
This enables users to automate file uploading, downloading, and sharing.

# Prerequisites

- You must have a PSU Access ID (e.g., rog1).
- You must have a Box.com account associated with your PSU ID.

# Installation

## Package dependencies

We'll use the `boxr` package.


```r
if (!require(boxr)){
  install.packages("boxr")
}
```

```
## Loading required package: boxr
```

```r
if (!require("openssl")){
  install.packages("openssl")
}
```

```
## Loading required package: openssl
```

## Create app on Box.com

You'll need to create an app on Box.com for your scripts to interact with. 
Visit <https://psu.app.box.com/developers/console>.
If you are not already logged in to Box.com, you'll be asked to login and provide your two-factor authentication credentials.

From the Box Developers My Apps console, press the Create New App Button.


```r
knitr::include_graphics("img/box-app-new.png")
```

<img src="img/box-app-new.png" style="display: block; margin: auto;" />

Select Custom App as the application type.


```r
knitr::include_graphics("img/box-custom-app.png")
```

<img src="img/box-custom-app.png" style="display: block; margin: auto;" />

Press the Next button to proceed.

Choose the method of Authentication.
For our purposes here, I recommend using Standard OAuth 2.0 (User Authentication).


```r
knitr::include_graphics("img/box-oath.png")
```

<img src="img/box-oath.png" style="display: block; margin: auto;" />

Press "Next" to proceed.

Name your app.


```r
knitr::include_graphics("img/box-name-app.png")
```

<img src="img/box-name-app.png" style="display: block; margin: auto;" />

Press Create App.
If you get the "Woot! Your app has been created" screen, you can do the computer happy dance if you like.
Otherwise, continue.
Press the "View Your App" button.

You app's configuration page will open.
Scroll down to the "OAuth 2.0 Credentials" section.


```r
knitr::include_graphics("img/box-edit-oauth-cred.png")
```

<img src="img/box-edit-oauth-cred.png" style="display: block; margin: auto;" />

Don't edit these.
**Note:** Your credentials will differ from mine.

### Change OAuth redirect

Scroll down a bit further to the 'OAuth 2.0 Redirect URI' panel.
Edit the 'Redirect URI' to `http://localhost:8080`.
This will force your script to launch a login window for Box when you try to authenticate.
If you don't change this field, your app will not work.

Hit the 'Save Changes' button.

Scroll back up to the 'OAuth 2.0 Credentials' section again.

## Set-up credentials in R

Type the following command template into your R console, but *do not hit enter* yet:

```
boxr::box_auth(client_id="", client_secret = "")
```

From your Box.com app configuration page, copy the `Client ID` field and paste it between the quotation marks in `client_id=""`.
Then, copy the `Client Secret` and paste it between the quotation marks in `client_secret=""` above.

## Test authentication from R

*Now* press enter at the R console to execute the `boxr::box_auth()` command.
You should see a login window like the following:


```r
knitr::include_graphics("img/box-grant-access.png")
```

<img src="img/box-grant-access.png" style="display: block; margin: auto;" />

Press the "Grant Access to Box" button, and close the browser window with the "Authentication complete. Please close this page and return to R." message.

## Store credentials (optional)

If you want to use R to access Box in the future, you may wish to follow the instructions that appear in the R console to save these credentials in your `.Renviron` file.

- Open your `.Renviron` file via `usethis::edit_r_environ()`.
- Paste the `BOX_CLIENT_ID` and `BOX_CLIENT_SECRET` lines into the file.
- Save the file.
- Restart R (Session/Restart R).

**Note:** Your `.Renviron` file should live in your user's root/home directory and thus *not* be part of a repo you are using for version control.
However, make absolutely sure that you add `.Renviron` to your `.gitignore` file or else you could inadvertently share your credentials with the world.

Here is a screenshot from the `.gitignore` file for the class repo.
Note that the `boxr` app added its own hidden folder `~/.boxr-oauth` to the list of files to ignore.
I added my root `.Renviron` file (`~/.Renviron`) and my local (to this project/repo) `.Renviron` file just to make absolutely sure I don't leak credentials.


```r
knitr::include_graphics("img/box-r-security.png")
```

<img src="img/box-r-security.png" style="display: block; margin: auto;" />

# Test the connection to Box

Let's interact with Box!

## Authenticate


```r
boxr::box_auth()
```

```
## Using `BOX_CLIENT_ID` from environment
```

```
## Using `BOX_CLIENT_SECRET` from environment
```

```
## boxr: Authenticated using OAuth2 as Rick Gilmore (rog1@psu.edu, id: 196373178)
```

## Creating directories


```r
my_dir_name <- "a-test-directory"
f <- boxr::box_dir_create(my_dir_name)
str(f)
```

```
## List of 22
##  $ type               : chr "folder"
##  $ id                 : chr "107936007462"
##  $ sequence_id        : chr "0"
##  $ etag               : chr "0"
##  $ name               : chr "a-test-directory"
##  $ created_at         : chr "2020-03-24T08:58:01-07:00"
##  $ modified_at        : chr "2020-03-24T08:58:01-07:00"
##  $ description        : chr ""
##  $ size               : int 0
##  $ path_collection    :List of 2
##   ..$ total_count: int 1
##   ..$ entries    :List of 1
##   .. ..$ :List of 5
##   .. .. ..$ type       : chr "folder"
##   .. .. ..$ id         : chr "0"
##   .. .. ..$ sequence_id: NULL
##   .. .. ..$ etag       : NULL
##   .. .. ..$ name       : chr "All Files"
##  $ created_by         :List of 4
##   ..$ type : chr "user"
##   ..$ id   : chr "196373178"
##   ..$ name : chr "Rick Gilmore"
##   ..$ login: chr "rog1@psu.edu"
##  $ modified_by        :List of 4
##   ..$ type : chr "user"
##   ..$ id   : chr "196373178"
##   ..$ name : chr "Rick Gilmore"
##   ..$ login: chr "rog1@psu.edu"
##  $ trashed_at         : NULL
##  $ purged_at          : NULL
##  $ content_created_at : chr "2020-03-24T08:58:01-07:00"
##  $ content_modified_at: chr "2020-03-24T08:58:01-07:00"
##  $ owned_by           :List of 4
##   ..$ type : chr "user"
##   ..$ id   : chr "196373178"
##   ..$ name : chr "Rick Gilmore"
##   ..$ login: chr "rog1@psu.edu"
##  $ shared_link        : NULL
##  $ folder_upload_email: NULL
##  $ parent             :List of 5
##   ..$ type       : chr "folder"
##   ..$ id         : chr "0"
##   ..$ sequence_id: NULL
##   ..$ etag       : NULL
##   ..$ name       : chr "All Files"
##  $ item_status        : chr "active"
##  $ item_collection    :List of 5
##   ..$ total_count: int 0
##   ..$ entries    : list()
##   ..$ offset     : int 0
##   ..$ limit      : int 100
##   ..$ order      :List of 2
##   .. ..$ :List of 2
##   .. .. ..$ by       : chr "type"
##   .. .. ..$ direction: chr "ASC"
##   .. ..$ :List of 2
##   .. .. ..$ by       : chr "name"
##   .. .. ..$ direction: chr "ASC"
##  - attr(*, "class")= chr "boxr_folder_reference"
```

That seemed to work.
We have stored the returned metadata in a variable `f`.
Now, let's create two subdirectories under that main directory.
First, we switch to the created directory and make it our temporary working directory.


```r
home_dir <- boxr::box_getwd()
boxr::box_setwd(f$id) # Box uses ID numbers to identify directories and files.
```

```
## box.com working directory changed to 'a-test-directory'
## 
##       id: 107936007462
##     tree: All Files/a-test-directory
##    owner: rog1@psu.edu
## contents: 0 files, 0 folders
```

Then we create two directories, `qa`, and `data_collection`.


```r
thing_1 <- boxr::box_dir_create("thing_1")
thing_2<- boxr::box_dir_create("thing_2")
```

## Listing directories

Let's retrieve a list of directories in our current working directory.
The default is the current working directory.
Note: We need to load the `tidyverse` package to have access to the pipe `%>%` operator.


```r
library(tidyverse)
```

```
## ── Attaching packages ──────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.0     ✓ purrr   0.3.3
## ✓ tibble  2.1.3     ✓ dplyr   0.8.5
## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.5.0
```

```
## ── Conflicts ─────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
my_box_dirs <- boxr::box_ls()
my_box_dirs %>%
  knitr::kable(.)
```



name      type     id              size  description   owner          path                         modified_at           content_modified_at   sha1    version
--------  -------  -------------  -----  ------------  -------------  ---------------------------  --------------------  --------------------  -----  --------
thing_1   folder   107935643847       0                rog1@psu.edu   All Files/a-test-directory   2020-03-24 11:58:02   2020-03-24 11:58:02   NA            1
thing_2   folder   107935936106       0                rog1@psu.edu   All Files/a-test-directory   2020-03-24 11:58:02   2020-03-24 11:58:02   NA            1

## Create a CSV data file and upload

Let's test the upload functionality by creating a CSV data frame and uploading it to the 'thing_1' folder.


```r
df <- data.frame(name = c("Tom", "Dick", "Harriet"),
                 age = c(10, 15, 20),
                 alive = c(FALSE, TRUE, TRUE))
```


```r
target_dir <- as.data.frame(my_box_dirs) %>%
  filter(name == "thing_1")
```

Now, we'll make a temporary csv data file and upload it 


```r
readr::write_csv(df, "tmp.csv")
boxr::box_ul(target_dir$id, file = "tmp.csv")
```

```
##   |                                                                              |                                                                      |   0%  |                                                                              |======================================================================| 100%
```

```
## 
## box.com remote file reference
## 
##  name        : tmp.csv 
##  file id     : 639637023367 
##  version     : V1 
##  size        : 57 B 
##  modified at : 2020-03-24 08:58:06 
##  created at  : 2020-03-24 08:58:06 
##  uploaded by : rog1@psu.edu 
##  owned by    : rog1@psu.edu 
##  shared link : None 
## 
##  parent folder name :  thing_1 
##  parent folder id   :  107935643847
```

### Downloading uploaded file

Let's list the files in the `thing_1` subdirectory first.


```r
target_list <- boxr::box_ls(target_dir$id)
target_list
```

```
## 
## box.com remote object list (1 objects)
## 
##   Summary of first 1:
## 
##      name type           id size        owner
## 1 tmp.csv file 639637023367 57 B rog1@psu.edu
## 
## 
## Use as.data.frame() to extract full results.
```

Now, we try to download it.


```r
boxr::box_dl(as.data.frame(target_list)$id, overwrite = TRUE, file_name = "new_tmp.csv")
```

```
##   |                                                                              |                                                                      |   0%  |                                                                              |======================================================================| 100%
```

```
## [1] "/Users/rog1/rrr/psy-525-reproducible-research-2020/how_to/new_tmp.csv"
```


```r
downloaded_f <- readr::read_csv("new_tmp.csv")
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   age = col_double(),
##   alive = col_logical()
## )
```

```r
str(downloaded_f)
```

```
## Classes 'spec_tbl_df', 'tbl_df', 'tbl' and 'data.frame':	3 obs. of  3 variables:
##  $ name : chr  "Tom" "Dick" "Harriet"
##  $ age  : num  10 15 20
##  $ alive: logi  FALSE TRUE TRUE
##  - attr(*, "spec")=
##   .. cols(
##   ..   name = col_character(),
##   ..   age = col_double(),
##   ..   alive = col_logical()
##   .. )
```
