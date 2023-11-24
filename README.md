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
+ ```cli secure```：產生加密所需資訊與設定
+ ```cli into --<service-main-name>```：進入指定容器
+ ```cli logs --<service-main-name>```：顯示指定容器歷程

## Server and Client

+ [Agents Overview](https://developer.hashicorp.com/consul/docs/agent)
+ [The Consul system – servers and clients](https://subscription.packtpub.com/book/cloud-and-networking/9781800202627/2/ch02lvl1sec03/the-consul-system-servers-and-clients)

![](./doc/img/consul-architecture.png)

Consul agent is the core process of Consul. The agent maintains membership information, registers services, runs checks, responds to queries, and more. The agent must run on every node that is part of a Consul cluster.

Agents run in either client or server mode.

+ Server nodes are the core agent operations,  participate in the consensus quorum. The quorum is based on the Raft protocol, which provides strong consistency and availability in the case of failure. Server nodes should run on dedicated instances because they are more resource intensive than client nodes.

+ Client nodes are lightweight processes that make up the majority of the cluster. They interface with the server nodes for most operations and maintain very little state of their own. Clients run on every node where services are running.

基於安全性考量，Consul 建議設定以下的加密機制以確保服務間的通訊安全。

### [Gossip encrypt](https://developer.hashicorp.com/consul/tutorials/security/gossip-encryption-secure)

使用 [Consul Keygen](https://developer.hashicorp.com/consul/commands/keygen) 指令產生一組 32-bytes 的 Base64-encoded，用於 Consul 網路的加密通訊。

此值可透過 CLI 參數 ```-encrypt``` 或設定檔 ```encrypt``` 為 Key 來提供啟動的節點；在預設上可以不提供此一數值，但在產品環境則基於安全性必需設定。

在本專案可以使用

### [TLS encryption](https://developer.hashicorp.com/consul/tutorials/security/tls-encryption-secure)

基於 Certificate Authority (CA) 的加密通訊，使用於 [TLS](https://zh.wikipedia.org/zh-tw/%E5%82%B3%E8%BC%B8%E5%B1%A4%E5%AE%89%E5%85%A8%E6%80%A7%E5%8D%94%E5%AE%9A)，諸如 HTTP(S) 的通訊即是使用此通訊加密。

### [ACL](https://developer.hashicorp.com/consul/tutorials/security/access-control-setup-production)

基於 [Access Control List](https://developer.hashicorp.com/consul/docs/security/acl#acl-documentation) 的加密通訊。

## service discovery

+ [Register external services with Consul service discovery](https://developer.hashicorp.com/consul/tutorials/developer-discovery/service-registration-external-services)
    + [Register your services to Consul](https://developer.hashicorp.com/consul/tutorials/get-started-vms/virtual-machine-gs-service-discovery)
+ [Services](https://developer.hashicorp.com/consul/docs/services/services)
    + [Define services](https://developer.hashicorp.com/consul/docs/services/usage/define-services)
    + [Define health checks](https://developer.hashicorp.com/consul/docs/services/usage/checks)
        - [Checking service health status with Consul](https://codeblog.dotsandbrackets.com/consul-health-check/)
    + [Register services and health checks](https://developer.hashicorp.com/consul/docs/services/usage/register-services-checks)
        - [Service - Agent HTTP API](https://developer.hashicorp.com/consul/api-docs/agent/service)

![](./doc/img/consul-registering-services.png)

### Internal service

### External service

### health check

### key-value storage

## 文獻

+ [Consul](https://www.consul.io/)
    - [What is Consul?](https://developer.hashicorp.com/consul/docs/intro)
    - [Consul Architecture](https://developer.hashicorp.com/consul/docs/architecture)
+ [Consul - Docker](https://hub.docker.com/_/consul)
    - [hashicorp/consul - Docker](https://hub.docker.com/r/hashicorp/consul)，1.16 之後版本發布於此。
    - [Create a secure local Consul datacenter with Docker Compose](https://developer.hashicorp.com/consul/tutorials/docker/docker-compose-datacenter)
        + [Agents Configuration File Reference](https://developer.hashicorp.com/consul/docs/agent/config/config-files)
        + [Service Configuration File Reference](https://developer.hashicorp.com/consul/docs/services/configuration/services-configuration-reference)
        + [Health check configuration reference](https://developer.hashicorp.com/consul/docs/services/configuration/checks-configuration-reference)
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
