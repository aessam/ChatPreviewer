# ChatPreviewer
The module should help extracting Hashtags, mentions and URLS, if URL found it will start looking for Description and Image that usually used in FB preview

-
Input: "@chris you around?"

Return (string):
{
  "mentions": [
    "chris"
  ]
}
 
-
Input: "Good morning! (megusta) (coffee)"

Return (string):
{
  "emoticons": [
    "megusta",
    "coffee"
  ]
}

-
Input: "Olympics are starting soon; http://www.nbcolympics.com"
Return (string):
{
  "links": [
    {
      "url": "http://www.nbcolympics.com",
      "title": "NBC Olympics | 2014 NBC Olympics in Sochi Russia"
    }
  ]
}
 
-
Input: "@bob @john (success) such a cool feature; https://twitter.com/jdorfman/status/430511497475670016"
Return (string):
{
  "mentions": [
    "bob",
    "john"
  ],
  "emoticons": [
    "success"
  ],
  "links": [
    {
      "url": "https://twitter.com/jdorfman/status/430511497475670016",
      "title": "Twitter / jdorfman: nice @littlebigdetail from ..."
    }
  ]
}

-