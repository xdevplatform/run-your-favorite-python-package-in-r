install.packages('reticulate')
install.packages('dplyr')
install.packages('jsonlite')
install.packages('yaml')

library('reticulate')
library('dplyr')
library('yaml')
library('jsonlite')

path_to_python <- "/usr/bin/python3.7"
use_python(path_to_python)

virtualenv_install("tweetenv", "requests", ignore_installed = TRUE)
virtualenv_install("tweetenv", "json", ignore_installed = TRUE)
use_virtualenv("tweetenv", required = TRUE)

j <- import("json")
r <- import("requests")

input <- readline('What handle do you want to get Tweets from? ')

url <- sprintf("https://api.twitter.com/labs/2/tweets/search?query=from:%s", input)
print(url)

cred <- yaml.load_file("secret.yaml")

bearer_token <- cred$search_tweets_api$bearer_token
headers <- sprintf('{"Authorization": "Bearer %s"}', bearer_token)
header_dict <- j$loads(headers)

response <- r$request("GET", url, headers=header_dict)
print(response$text)

json_data <- fromJSON(response$text, flatten = TRUE)  %>% as.data.frame
View(json_data)

smaller_df <- select(json_data, data.id, data.text)
View(smaller_df)
