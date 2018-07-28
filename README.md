# IMPieChart -- OC-饼状图
### 欢迎加群讨论更多：83766186😊
---

## 预览
![预览](https://github.com/GitHub-Life/IMPieChart/raw/master/Picture/composite_demo.gif)
---
#### 导入项目方法：
git clone此项目到本机，将根目录下的 IMPieChart 文件夹导入至项目即可使用；
#### IMPieChart的使用：
由于鄙人项目赶紧，暂时无法脱身写文档，后续会补上，可以参考 IMPieChartDemo 中的使用方法使用。

#### 注意：后面IMPieChartView新增的needIncreaseHeight字段，有时会出现好几个很小的数据紧挨着，并且在顶部y轴附近，就会出现绘制超出区域的现象，为了防止绘制超出区域，就需要增加IMPieChartView的高度，needIncreaseHeight就是在原有高度的基础上需要增加的高度的一半，因为needIncreaseHeight只是垂直方向单个方向增加的高度，绘制的时候饼状图实在中间，增加高度需要上下都增加，所以需要 * 2。使用的时候监听needIncreaseHeight的值变化实时更新IMPieChartView的高度即可。

### 欢迎加群讨论更多：83766186😊
有什么问题或建议，咱们可以随时@我，咱们一起交流学习😊

#### 有兴趣的还可以看看我的[OC版趋势图](https://github.com/GitHub-Life/IMChart)、[Swift版K线图](https://github.com/GitHub-Life/IMKLine)😊
