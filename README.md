# TWTCashRegister
该Repository主要实现了[ThoughtWorks"收银机"面试题目](https://jinshuju.net/f/n0ddSe)

以下是解题思路:

## 第一步：进一步解析输入
题目中“收银机”接收的输入为：

    [
        'ITEM000001',
        'ITEM000001',
        'ITEM000001',
        'ITEM000001',
        'ITEM000001',
        'ITEM000003-2',
        'ITEM000005',
        'ITEM000005',
        'ITEM000005'
    ]
因为需要知道每件商品的购买数量，故而需要把同类商品合并，进一步解析后的数据格式如下(格式是Dictionary，Key为条形码，Value为购买该商品的数量,具体解析过程参见**TWParse类**)

    {
    	‘ITEM000001’:5,
    	‘ITEM000003’:2,
    	‘ITEM000005’:3
    }
## 第二步：商品信息&优惠信息存储
商品信息&优惠信息存储在SQLite数据库中，具体格式如下:

商品信息表

|Barcode   |Name|Price|Unit|Category|
|----------|-----|----|----|--------|
|ITEM000001|羽毛球|1   |个   |Sport  |
|ITEM000003|苹果  |5.5 |斤   |Fruit  |
|ITEM000005|可口可乐| 3  |瓶  |Drink  |

优惠信息表

|id|Barcode  |FavorableType|FavorableValue|
|-|----------|-------------|--------------|
|1|ITEM000001|FreeOne      |2             |
|2|ITEM000003|Discount     |0.95          |
|3|ITEM000005|FreeOne      |2             |

## 第三步：构造商品对象&商品优惠类型
根据第一步中解析出来的**条形码**和**数量**配合第二步中存储的商品信息构造出商品对象，该部分代码请参考**TWProduct类**。至于商品的优惠类型就根据**条形码**查“优惠信息表”即可，该部分代码请参考**TWFavorable类**
## 最后一步：结算
通过第三步我们拿到了购买商品的清单(商品名称、数量、优惠类型)，然后根据具体的销售策略计算费用即可，该部分代码请参考**TWCashRegister类**

*BestRegards*

