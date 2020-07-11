import cligen
import httpClient
import os
import strformat
import strutils
import times

const url = "https://notify-api.line.me/api/notify"
const imageExtensions = [".png", ".jpg", ".jpeg"]

proc validateImageUrl(imageThumbnail: string, imageFullsize: string): bool =
  if imageThumbnail.len == 0:
    echo "Missing imageThumbnail"
    return false
  if imageFullsize.len == 0:
    echo "Missing imageFullsize"
    return false
  return true

proc validateImageFile(imageFile: string): bool =
  if not fileExists(imageFile):
    echo "Invalid imageFile"
    return false
  let fileSplit = splitFile(imageFile)
  if not imageExtensions.contains(fileSplit.ext):
    echo "Invalid image format"
    return false
  return true

proc validateSticker(packageId: int, stickerId: int): bool =
  case packageId
  of 1:
    case stickerId:
    of 1..17, 21, 100..139, 401..430: return true
    else: discard
  of 2:
    case stickerId:
    of 18..20, 22..47, 140..179, 501..527: return true
    else: discard
  of 3:
    case stickerId:
    of 180..259: return true
    else: discard
  of 4:
    case stickerId:
    of 260..307, 601..632: return true
    else: discard
  else:
    echo "Invalid packageId"
    return false

  echo "Invalid stickerId"
  return false

proc notify(message: string, imageThumbnail = "", imageFullsize = "",
            imageFile = "", packageId = 0, stickerId = 0,
            notificationDisabled = false) =
  ## Sends notification to LINE talk room that is related to the access token.

  if not existsEnv("LINE_NOTIFY_ACCESS_TOKEN"):
    echo "Missing LINE_NOTIFY_ACCESS_TOKEN"
    return
  let token = getEnv("LINE_NOTIFY_ACCESS_TOKEN")

  let client = newHttpClient()
  client.headers = newHttpHeaders({"Authorization": &"Bearer {token}"})
  let data = newMultipartData()
  data["message"] = message
  data["notificationDisabled"] = $notificationDisabled

  if imageThumbnail.len > 0 or imageFullsize.len > 0:
    if not validateImageUrl(imageThumbnail, imageFullsize):
      return
    data["imageThumbnail"] = $imageThumbnail
    data["imageFullsize"] = $imageFullsize

  if imageFile.len > 0:
    if not validateImageFile(imageFile):
      return
    data.addFiles({"imageFile": imageFile})

  if packageId > 0 or stickerId > 0:
    if not validateSticker(packageId, stickerId):
      return
    data["stickerPackageId"] = $packageId
    data["stickerId"] = $stickerId

  let response = client.request(url, httpMethod = HttpPost, multipart = data)
  echo response.body
  echo &"Limit: {response.headers[\"X-RateLimit-Limit\"]}"
  echo &"Remaining: {response.headers[\"X-RateLimit-Remaining\"]}"
  echo &"ImageLimit: {response.headers[\"X-RateLimit-ImageLimit\"]}"
  echo &"ImageRemaining: {response.headers[\"X-RateLimit-ImageRemaining\"]}"
  let reset = response.headers["X-RateLimit-Reset"]
  let utc = fromUnix(parseBiggestInt(reset)).utc
  echo &"Reset: {utc}"

when isMainModule:
  dispatch(notify,
           short = {
           "imageThumbnail": 't',
           "imageFullsize": 'f',
           "imageFile": 'i'},
           help = {
           "message": "1000 characters max",
           "imageThumbnail": "Image Thumbnail URL",
           "imageFullsize": "Image Fullsize URL",
           "imageFile": "Image File (.png, .jpg, .jpeg)",
           "packageId": "Sticker Package ID",
           "stickerId": "Sticker ID",
           "notificationDisabled": "true: The user doesn't receive a push notification when the message is sent."})
