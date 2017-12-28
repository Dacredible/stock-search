# stock-search
iOS app to search stocks using alpha vantage API

This is a iOS app written in Swift and back-end written in node.js on AWS Elastic Beanstalk. Basically, this app allow user to search for stock information using Alpha Vantage API and display the result using HighCharts embedded in "WKWebKitView", save some stock symbols as favorites, and post to Facebook timeline.

## Getting started
This app uses a lot third party libraries to support some features, be sure to run `pod install` before opening the project.

### Key Features

- Asynchronized network communication 

  Used "Alamofire" and "SwiftyJSON" pods to make async http request to back-end server running on AWS and stored response data in JSON format.
  
- Auto Complete

  Used "DropDown" and "http://dev.markitondemand.com/MODApis/Api/v2/Lookup/json?input=APPLE" API to achieve auto-complete suggestion for input field.

- Facebook Share

- Loading Animation

## Pods
- [Alamofire](https://github.com/Alamofire/Alamofire) - used to handle HTTP requests
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - used to help stored retrieved data as JSON format
- [SwiftSpinner](https://github.com/icanzilb/SwiftSpinner) - the loading animation used
- [EasyToast](https://github.com/f-meloni/EasyToast) - the toast used to indicate user interactive
- [DropDown](https://github.com/AssistoLab/DropDown) - dropdown list used to show auto-complete suggestion

## Demo Video
You can find demo video through here: [https://youtu.be/2P-yLwtG3rE](https://youtu.be/2P-yLwtG3rE)
