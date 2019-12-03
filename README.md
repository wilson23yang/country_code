# country_code

## 1.example
```

        Scaffold(
           appBar: AppBar(
           title: const Text('Plugin example app'),
         ),
           body: CountryListPage(itemClickCallback: (Country country){
             print('country code:${country.phoneCode}');
           },),
         );

```

![view](https://github.com/wilson23yang/country_code/blob/master/example/img/page.jpg "view")


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
