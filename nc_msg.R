require(httr)

# nextcloud_user ---------------------------------------------------------------
get_username <- function()
{
  Sys.getenv("NC_USERNAME")
}

# nextcloud_password -----------------------------------------------------------
get_password <- function()
{
  Sys.getenv("NC_PASSWORD")
}

# nextcloud_url ----------------------------------------------------------------
nextcloud_url <- function()
{
  Sys.getenv("NEXTCLOUD_URL")
}

id = get_username()  # Find username in user management view
password = get_password()

result <- POST("https://cloud.ecosysl.net/ocs/v2.php/apps/spreed/api/v1/chat/i6guskvx",
body = {'message': 
"Today's report at https://www.google.com.au/"},
add_headers(.headers = c("Accept"="application/json","cache-control"="no-cache", "OCS-APIRequest"="true")))

# TODO: figure out a way to get username and password to pass as auth
