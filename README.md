# MVTimeAnalyzer

这个仓库的目的是用来统计一个素材的曝光时间，即一个素材处于用户可见的范围内，是否超过一定的时间，默认是一秒钟。

当前的计算方法是：

1. 一个Cell（UICollectionViewCell & UITableViewCell）发起统计请求，即目前的Cell 处于加载完成状态（一般是一个素材的图片加载完成并成功显示）。
2. 获取到一个统计请求后，此仓库会在一定的时间后，去遍历当前Cell所处的父UI（UICollectionView & UITableView），然后获取到目前UI的所有可见cell
3. 判断获取的cell是否加载完成，且当前cell 是否有统计事件

基于性能方面的考虑，目前采取的计算方并不精确，只能作为一个大概的参考数据。


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 使用方式

1、引入MVTimeAnalyzer
2、MVTimeAnalyzer 添加至少一个自定义的 uploader， 需要实现 MVAnalyzerUploader 协议
3、使UICollectionView 实现 MVTimeAnalyzerAble 协议
4、为每一个Cell提供点击或者出现时候的数据，有两种方式：
   1. 通过实现 MVTimeAnalyzerAble 的方法（不推荐）
   2. 为CollectionView提供一个事件的dataSource, 实现AnalyzerEventsDataSource 协议
5、当cell 可以被观察的时候， 主动调用tryAnalyze 方法即可

## Requirements

iOS10.0 or higher

## Installation

MVTimeAnalyzer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MVTimeAnalyzer'
```

## Author

zhenghong, honglove1109@gmail.com

## License

MVTimeAnalyzer is available under the MIT license. See the LICENSE file for more info.
