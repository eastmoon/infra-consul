# infra-consul

## 簡介

HashiCorp Consul is a service networking solution that enables teams to manage secure network connectivity between services and across on-prem and multi-cloud environments and runtimes. Consul offers service discovery, service mesh, traffic management, and automated updates to network infrastructure device. You can use these features individually or together in a single Consul deployment.

Consul provides a control plane that enables you to register, query, and secure services deployed across your network. The control plane is the part of the network infrastructure that maintains a central registry to track services and their respective IP addresses. It is a distributed system that runs on clusters of nodes, such as physical servers, cloud instances, virtual machines, or containers.

The core Consul workflow consists of the following stages:

+ Register: Teams add services to the Consul catalog, which is a central registry that lets services automatically discover each other without requiring a human operator to modify application code, deploy additional load balancers, or hardcode IP addresses.
+ Query: Consul’s identity-based DNS lets you find healthy services in the Consul catalog.
+ Secure: After services locate upstreams, Consul ensures that service-to-service communication is authenticated, authorized, and encrypted.


## 指令

+ ```cli dev```：單一容器啟動，用於開發與試驗
+ ```cli up```：叢集主機啟動
+ ```cli down```：叢集主機關閉

## Server and Client

## service discovery

## health check

## key-value storage

## 文獻

+ [Consul](https://www.consul.io/)
    - [What is Consul?](https://developer.hashicorp.com/consul/docs/intro)
    - [Consul Architecture](https://developer.hashicorp.com/consul/docs/architecture)
+ [Consul - Docker](https://hub.docker.com/_/consul)
    - [hashicorp/consul - Docker](https://hub.docker.com/r/hashicorp/consul)，1.16 之後版本發布於此。
+ 教學文章
    - [Consul 1.9 中文文档](https://yushuai-w.gitbook.io/consul/intro)
        + [Consul 1.4 中文文档](https://kingfree.gitbook.io/consul/)
    - [Introduction to Consul Made Simple](https://reemishirsath.medium.com/introduction-to-consul-made-simple-5749b79e1)
    - [使用 Consul 作為成員資格提供者](https://learn.microsoft.com/zh-tw/dotnet/orleans/deployment/consul-deployment)
    - [HashiCorp釋出多雲服務平臺Consul 1.9版，強化存取控制與視覺化功能](https://www.ithome.com.tw/news/141383)
    - [什麼是Consul？Consul的基本架構和安裝介紹！](https://www.gushiciku.cn/pl/gUzz/zh-tw)
    - [基于Consul的服务发现](https://yunlzheng.gitbook.io/prometheus-book/part-ii-prometheus-jin-jie/sd/service-discovery-with-consul)
    - [使用Consul做服務發現的若幹姿勢](https://www.zendei.com/article/60622.html)
    - [使用 consul 及 nomad 建立起 dc 的基礎建設](https://poyu677.medium.com/8c4a8bedcd3f)
