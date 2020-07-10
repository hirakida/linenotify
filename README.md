# linenotify

## Install
```
$ nimble build

$ nimble install
```

## Enviroment variable
Set `LINE_NOTIFY_ACCESS_TOKEN` to an environment variable.  
https://notify-bot.line.me/

## Usage
```
$ linenotify -m=hello!

$ linenotify -m=hello! -p=1 -s=1

$ linenotify -m=hello! -i=image.png  

$ linenotify -m=hello! -t=https://example.com/thumbnail_image -f=https://example.com/fullsize_image

$ linenotify -h
Usage:
  notify [required&optional-params] 
Sends notification to LINE talk room that is related to the access token.
Options:
  -h, --help                                    print this cligen-erated help
  --help-syntax                                 advanced: prepend,plurals,..
  -m=, --message=             string  REQUIRED  1000 characters max
  -t=, --imageThumbnail=      string  ""        Image Thumbnail URL
  -f=, --imageFullsize=       string  ""        Image Fullsize URL
  -i=, --imageFile=           string  ""        Image File (.png, .jpg, .jpeg)
  -p=, --packageId=           int     0         Sticker Package ID
  -s=, --stickerId=           int     0         Sticker ID
  -n, --notificationDisabled  bool    false     true: The user doesn't receive a push notification when the message is sent.
```

### Available Sticker List
https://devdocs.line.me/files/sticker_list.pdf
