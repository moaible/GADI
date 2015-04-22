# GADI

## 概要

GADI(Google Analytics Dependency Injection)の略

iOSでのGoogleAnalyticsによるトラッキング処理を外部から注入することが可能となる

内部の処理としてAOPライブラリの[MOAspects](https://github.com/MO-AI/MOAspects)を使ってAOP的にトラッキング処理を埋め込んでいる

## 始め方

### Podfile

Podfileに以下を記述し、`pod install`する

```
pod 'GADI'
pod 'GoogleAnalytics-iOS-SDK'
```

### 設定ファイルのインポート

このライブラリは設定用のPropertyListファイル(.plist)を基に処理を行うため、以下のplistファイルをプロジェクト内のリソースファイルにインポートする必要がある

#### [GoogleAnalyticsConfig.plist](https://github.com/MO-AI/GADI/blob/master/GoogleAnalyticsConfig.plist)

## 設定項目

| 設定名 | 詳細 | 必須 |
| :--- | :--- | :---: |
| Class | GAのトラッキング対象とするクラス | ○ |
| MethodSignature | GAのトラッキング対象とするメソッド | ○ |
| GA:Type | トラッキング種別、"Screen" か "Event" のどちらかを設定する | ○ |
| GA:Screen | GAの画面のトラッキングに必要なScreenの文字列 | × |
| GA:Category | GAのイベントのトラッキングに必要なCategoryの文字列 | × |
| GA:Action | GAのイベントのトラッキングに必要なActionの文字列 | × |
| GA:Label | GAのイベントのトラッキングに必要なLabelの文字列 | × |
| GA:Value | GAのイベントのトラッキングに必要なValueの文字列（現状未対応） | - |

### 実例

GAの埋め込み箇所の指定は全てこの設定ファイルの中で完結する

```xml:GoogleAnalyticsConfig.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <array>
        <dict>
            <key>Class</key>
            <string>AppleViewController</string>
            <key>MethodSignature</key>
            <string>viewDidAppear:</string>
            <key>GA:Type</key>
            <string>Screen</string>
            <key>GA:Screen</key>
            <string></string>
            <key>GA:Category</key>
            <string></string>
            <key>GA:Action</key>
            <string></string>
            <key>GA:Label</key>
            <string></string>
            <key>GA:Value</key>
            <string></string>
        </dict>
        <dict>
            <key>Class</key>
            <string> AppleViewController </string>
            <key>MethodSignature</key>
            <string>didTapAppleButton</string>
            <key>GA:Type</key>
            <string>Event</string>
            <key>GA:Screen</key>
            <string></string>
            <key>GA:Category</key>
            <string>Apple</string>
            <key>GA:Action</key>
            <string>Tap</string>
            <key>GA:Label</key>
            <string>Button</string>
            <key>GA:Value</key>
            <string></string>
        </dict>
    </array>
</plist>
```

## 準備完了

ここまで設定したら以下のメソッドを実行することでGAのトラッキングの実装は完了となる

```swift
GADInjector.injectWithTrackingID("", /* Please GoogleAnalytics tracking ID */
    configPropertyListPath:NSBundle.mainBundle().pathForResource("GoogleAnalyticsConfig.plist", ofType: ""))
```

## デモ

りんご、バナナ、オレンジが各画面で出てくるデモアプリ、実際にGAのトラッキングIDを埋め込んで動かすことでトラッキングできてることが確認できると思う

### GADIDemo

https://github.com/MO-AI/GADI/tree/master/GADIDemo/

## おわりに

まだイベントのトラッキングのValueに対応できてないが今後対応予定です、他に要望等あればIssueくれると喜びます！
