import unittest
include linenotify

suite "validateSticker tests":
  test "valid":
    check validateSticker(1, 1) == true
    check validateSticker(2, 18) == true
    check validateSticker(3, 180) == true
    check validateSticker(4, 260) == true

  test "invalid pakcageId":
    check validateSticker(5, 1) == false

  test "invalid stickerId":
    check validateSticker(1, 18) == false
