# Create conditional app name based on branch

app_name <- if (Sys.getenv("TRAVIS_BRANCH") == "master") {
  "google_geocode"
} else if (Sys.getenv("TRAVIS_BRANCH") == "develop") {
  "google_geocode_dev"
}

# Set account info
rsconnect::setAccountInfo(
  name = "adamrobinson361",
  token = Sys.getenv("SHINYAPPS_TOKEN"),
  secret = Sys.getenv("SHINYAPPS_SECRET")
)

# Print name to console
print(app_name)

# Deploy
rsconnect::deployApp(appName = app_name, appFiles = "app.R")