# linenotify-cli

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
```

### Available Sticker List
https://devdocs.line.me/files/sticker_list.pdf
