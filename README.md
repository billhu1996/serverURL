# serverURL
ifLab在BISTU校内应用为了配合App Store审核所做的"妥协"

## How To Get Started

#### Podfile

```
source 'https://github.com/billhu1996/serverURL.git'
platform :ios, '7.0'

target 'TargetName' do
  use_frameworks!
  pod 'serverURL'
end
```

```
let url = "https://github.com/api/v2/saerverurl/_table/"
//获取真实URL
label.text = HBServerURL.getWithURL(url, apikey: "abcdefgrtghjkloiuyt") //after this line, label.text == https://real.url.com/api

```
