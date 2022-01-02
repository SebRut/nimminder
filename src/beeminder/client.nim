import httpclient
import std/json
import options
import std/strutils
import std/algorithm
import std/uri

type User = object
  username*: string
  timezone: string
  updated_at: int64
  goals*: seq[string]
  urgency_load: int

type Datapoint* = object
  id*: string
  timestamp: int64
  daystamp*: string
  value*: float
  comment*: string
  updated_at: int64

type Goal = object
  slug*: string
  updated_at*: int64
  title*: string
  fineprint*: string
  losedate*: int64
  thumb_url*: string
  datapoints: Option[seq[Datapoint]]

let client = newHttpClient()
const baseUrl = "https://www.beeminder.com/api"

proc getUser*(authToken: string): User =
  let query = {"auth_token": authToken}
  let uri = parseUri(baseUrl) / "v1/users/me.json" ? query
  let response = client.getContent($uri)
  let json = parseJson(response)

  return to(json, User)

proc getGoal*(authToken: string, goalSlug: string,
    fetchDatapoints: bool = false): Goal =
  let query = {"auth_token": authToken, "datapoints": $fetchDatapoints}
  let uri = parseUri(baseUrl) / "v1/users/me/goals" / (goalSlug & ".json") ? query
  let response = client.getContent($uri)
  let json = parseJson(response)

  return to(json, Goal)

proc createDatapoint*(authToken: string, goalSlug: string,
    datapoint: Datapoint): Datapoint =
  let query = {"auth_token": authToken, "daystamp": datapoint.daystamp,
      "value": formatFloat(datapoint.value), "comment": datapoint.comment}
  let uri = parseUri(baseUrl) / "v1/users/me/goals" / goalSlug /
      "datapoints.json" ? query
  let response = client.post($uri).body
  let json = parseJson(response)

  return to(json, Datapoint)

proc parseDatapointString*(input: string): Datapoint =
  let parts = input.split(' ')

  var date: string
  var value: string
  var comment: string

  var inCommentMode = false

  for part in parts.reversed:
    if part[part.len-1] == '"':
      inCommentMode = true
      comment = part.substr(0, part.len-2)
    elif inCommentMode:
      comment = part.substr(1) & " " & comment
      if part[0] == '"':
        inCommentMode = false
    elif value == "":
      try:
        discard parseFloat(part)
        value = part
      except:
        comment = part & " " & comment
    else:
      date = part & date

  return Datapoint(daystamp: date, value: parseFloat(value),
      comment: comment.strip())
