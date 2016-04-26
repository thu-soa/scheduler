# Scheduler Web API Service

## APIs

### 如何读该API的文档
- 一些例子和约定
    - GET /api/v1/messages  token
        - Message[]

    - 解释  
        - GET:              HTTP Method
        - /api/v1/messages: Relative path
        - token:            需要token认证
        - 假设站点主机名为api.a1ex.wang, 则完整的HTTP请求为
            - GET http://api.a1ex.wang/api/v1/messages?token=1234xxxxx
        - 返回的JSON格式
            - { "status": "ok", "reason": "ok", messages: \[{"id": xxx, ...}\, ...\] }
            - status:   状态, 取值见下面status部分的说明
            - reason:   如果失败, 则是一个可读的字符串, 显示失败的原因
            - messages: 由于文档中写了Message[], 所以对应此字段名为messages, 类型是Message数组
            - 如果是POST请求, 用data: xxx表示POST的数据
    - status的取值
        - ok: 成功
        - not_found: uri错误
        - parameter_error: 参数错误
        - unauthorized: token错误
        - unknown_error: 服务器崩溃了
    - 各种类型的定义
        - Message
            - String id
            - String title
            - String source
            - String uri
            - String description
            - String content
            - ... ?
        - SimpleMessage
            - String id
            - String title
            - String source
            - String url

### For clients' polling
- GET /api/v1/unread_messages   token
    - SimpleMessage[] simple_messages
    - 获取所有未读的消息列表
- GET /api/v1/sources/:source_name/unread_messages  token
    - SimpleMessage[] simple_messages
    - 获取某个数据源的所有未读消息列表

### For message pushing
- POST /api/v1/unread_messages?user_id=1    token
    - data: SimpleMessage 
    - 添加消息
    
### Authorization Server(是和Scheduler独立的服务, 但是他们即使部署在同一个端口, URI也不会冲突)

- GET /api/v1/user_info token
    - String user_id
    - String username

- POST /api/v1/login?username=&password=
    - String user_id
    - String token