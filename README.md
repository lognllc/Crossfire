while your application launches, instead of setup _window, use

```objective-c
[CRWindows enableWithRootViewControllerClass:*YOUR_ROOT_VIEW_CONTROLLER_CLASS*];
```
