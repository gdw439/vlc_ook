### OOK离线代码介绍

#### 文件结构

![img](file:///C:/Users/vortex/AppData/Local/Temp/msohtmlclip1/01/clip_image002.jpg)

在data_a文件夹下面，当跑程序抓取示波器信号时，每次抓取的信号数据被保存在这里。

![img](file:///C:/Users/vortex/AppData/Local/Temp/msohtmlclip1/01/clip_image004.jpg)

在function文件夹下面存储了相关函数，比如说8b10b编解码程序、gardner位同步算法相关程序，以及读取示波器数据的程序（存在一些问题，使用比较繁琐）。

![img](file:///C:/Users/vortex/AppData/Local/Temp/msohtmlclip1/01/clip_image006.jpg)

#### 代码程序流程：

![img](file:///C:/Users/vortex/AppData/Local/Temp/msohtmlclip1/01/clip_image008.png)

这里的同步为Gardner同步方法，这里的解调首先是将串行的二进制信号转换为10位二进制并行信号，然后送入道10B8B解码模块，解码后的数据位宽为8，而后经过RS解码过程，获得发送端发送的原始数据，随后进行BER和眼图等各项测试。

 

#### 代码使用：

修改sim的值可实现仿真、实验和离线，正常情况下结果会输出眼图曲线和BER数据。

![img](file:///C:/Users/vortex/AppData/Local/Temp/msohtmlclip1/01/clip_image010.jpg)

 

 


 

### 修订记录

2020年1月6日星期一

​       \1. 修改程序中接收端读取函数，更改为osc_read_v1()， 无需使用ook_gui程序初始化，直接就能读取；

​       \2. 支持更改过采样倍数，直接修改N_OS参数即可；

​       \3. 代码默认不使用信道均衡， 若需使用的话，需自行获取信道参数向量。