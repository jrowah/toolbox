# Client-Server Architecture

## Client; web browser, mobile app, crawlers etc,

- Sends a CRUD request

## Server

- Receives request, performs necessary operations and sends back a response.

# IP Address

- This is how a client knows how to locate a server. Every publicly deployed server has an IP address, that uniquely identifies it. Example; 172.217.170.174 is one of Google's IP addresses

# DNS (Domain Name System)

- Maps human readable domain names to ip addresses. When you type google.com on the browser, the browser asks a DNS server for the corresponding IP address 172.217.170.174, which is what the browser uses to establish a connection with google's server.

Use

```html
ping anydomainname.com
```

to see its IP address.

# Proxy / Reverse Proxy
- A middle man between your device and the internet, and forwards your requests to the target server. It hides your location, thereby keeping your location and identity private. A reverse proxy kind of protects the server, and intercepts client requests and forward to the servers following a set of predefined rules.
# Latency
- This is the time it takes for data to pass from one point to another on a network. Several factors affect this time delay between a user's action and the server's response. 
## Network Latency
- The time it takes for a data packet to travel across a network
## Server Latency
- The time the server takes to process the request.

-One of the factors that affect latency is physical distance. This is why some organizations have multiple data centers across the world, so that a user gets connected to the server nearest to them.
# HTTP/HTTPS
- A set of rules that govern client-server communications. 
-HTTP request-response lifecycle

- HTTP security concerns; sends data as texts.
- HTTPS sends data using SSL or TLS protocols
# APIs
- Middle men that allow client-serve communication and consumption of requests and responses (restaurant analogy).
- Client sends a request to an API hosted on a server, the API process the request, interacts with databases, or other services, and prepares a response, which it sends back using a format, JSON or XML.
- Two types:
## Rest API
-Representational State Transfer
- Stateless
- Every request is independent
- Everything is treated as a resource
- Has limitations; returns more data (solved by GraphQL)
## GraphQL API
- Lets clients ask for exactly what they need, nothing more, nothing less. 
- When getting a user with their most recent post for example, through a REST API, you might be forced to make multiple requests to different endpoints, while GraphQL enables you to combine these requests into one, and returns exactly what you need.
- Limitations
• Required more processing on the server side
* Is not easy to cash as rest
# Databases
- After making a request and getting a response, we always want to store, for small applications, we can store them as variables, or a file, and load it in memory. Modern applications handle huge loads of data that can't be stored or handled efficiently in the above ways.
- Enters dedicated server for data storage and management, databases.
-Dbs ensure efficient storage, retrieval, and management of data, while maintaining its security, integrity, consistency, and durability.
- Types
## SQL
- Store data in structured formats using;
* predefined schemas
* ACID properties
* strong consistency
* structured relationships
## NoSQL
- Designed for high scalability and performance, and use key-value stores, documented stores, wide-column and graph stores

- Choose SQL database if you need structured relational data and strong consistency.
- Choose NoSQL database if you need high scalability and flexible schema
## Scaling
- the process of increasing or decreasing a system's capacity to handle changing workloads, user numbers, or data volumes without compromising performance or stability
## Vertical Scaling
- Scaling by adding more CPU, RAM, and Storage to our server machines, this makes a single machine more powerful. Is usually a quick fix
- Limitations;
* Its impossible to keep upgrading forever as every machine has maximum capacity
* More powerful machines become exponentially more expensive
* If a single server fails, the entire system crashes (single point of failure(SPOF))
## Horizontal Scaling
- Involves adding more server to share the increasing load, making the system to handle increasing traffic more effectively. If one server crashes, others easily take over.
- Makes a system more reliable and fault tolerant.
- Brings a new challenge of how clients knowing which server to connect to, and this is where:
## Load Balancers
- Sits between clients and backend servers, and acts as a traffic manager, that distributes requests across multiple servers. When a server crashes, the load balancer automatically redirects the traffic to a healthier server, using certain rules or configurations.
- Load balancing algorithms to enable them know which requests to redirect to which server;
* Round-Ribon
* Least Connections
* IP hashing


- We can also scale databases vertically similar to servers, but there are limits to this as well.
- Other db scaling techniques that can help manage large volumes of data efficiently include;
## Database Indexing
- Speeds up database read queries.
- Think of this as the index page at the back of a book that helps you jump directly to the relevant page/section of the page instead of flipping through every page.
- This is a super-efficient lookup table that helps the database quickly locate the required data, without scanning an entire table.
- An index stores column values along with pointers to actual data rows on the tables. 
- Indexes are often created on columns that are frequently queried such as primary keys, foreign keys, and columns frequently used in where conditions. 
- Important to note that while indexes speed up read operations, they slow down write ones since the index needs to be updated whenever data changes, which is why we should only index the most frequently accessed columns
## Replication
- Is another db scaling technique which involves creating copies of our dbs across multiple serves. 
- One primary replica handles write operations, others secondary replicas handle read operations, a written database gets copied to the replicas for them to stay in sync. Read requests get spread across multiple replicas. When a primary replica fails, a read replica can take its place 
## Sharding
- Is a method of horizontally scaling databases by splitting large datasets into multiple smaller, more manageable databases, called shards and distribute them across multiple servers.
- Each shard contains a sub-set of the total data, 
- Helps in scaling write operations and mainly helps where the issue is the number of row. 
# Vertical Partitioning
- Split the database by columns
# Cashing
- Data retrieval from memory is usually much faster than from databases.
- Cashing helps by storing frequently accessed data in-memory (cashe) to optimize system performance
- We use TTL(time to live value) to prevent outdated data from being served
# Denormalization
- Reduces the number of joins by combining related data into a single table.
- An example would be instead of having users and posts tables, you would have users_orders table that stores users details along with their orders, so we do not need a join operation when retrieving a user's order history. 
- Normally used in read-heavy applications, but leads to increased storage and more complex update requests.
# CAP Theorem
- As we scale our systems across multiple servers, databases, and data centers, we enter the world of distributed systems.
The CAP theorem (Consistency(all nodes have the same data), Availability(all requests get a response), and Partition Tolerance(the system works despite network failures)) states that a distributed system can only guarantee two of the three properties simultaneously.
# Blob Storage
- How applications handle large files such as videos, pdfs, and other large files, which relational databases are not designed to store.
- Solution is to use Blob storage like AmazonS3.
- Blobs are like individual files which are stored in large containers in the clouds, where each file gets a unique url, making it easy to retrieve and serve over the web.
# CDN
- It becomes slow when you try to access large files such as say streaming a video from a Blob storage that is on the other side of the world.
- In comes the Content Delivery Network, that delivers content faster to users based on their locations.
A CDN is a global network of distributed servers that work together to deliver web content like html pages, javascript files, images, videos etc to users based on their geographic location
# WebSockets
- Solves regular http problems where clients send requests and the server processes it and sends back a response, and if the client needs new data, it must send another request which works fine for static web pages but is too slow abd inefficient for real-time applications like live chat applications, stock market dashboards, online multiplayer games.
- With HTTP, the only way to get real-time updates is through frequent polling, sending repeated requests every few seconds, which is inefficient as it increases server load and wastes bandwidth. Most responses are also often empty and there is no new data.
- In comes websockets, which allow continuos communication between the client and the server over a single persistent connection.
- The client initiates a websocket connection with the server, once established, the connection remains open and so the server can send updates to the client at any given time without waiting for a request while the client can also instantly send messages to the server, which eliminates polling, thus enabling real-time communication between a server and a client.
# Webhooks
- When a sever needs to inform another server about the occurrence of an event. For example, when a client makes a payment, the payment gateway needs to notify an application, instead of the application constantly polling the gateway to check for any event occurrences, webhooks would allow a server to send an HTTP request to another server as soon as the event occurs.
- You app registers a webhook url with the provider, when an event occurs, the provider sends a HTTP POST request to the webhook url with the event details.
# Microservices
- Traditional websites were built within a monolithic architecture, where all features are inside one large code base. This works well for small applications, but for larger scale systems, monoliths become a limitation and hard to manage, scale and deploy.
- In comes microservices architecture, a solution in which you break down your application into smaller independent services called micro-services that work together.
- Each micro-service handling a single responsibility, has its own database and logic, so it can scale independently, and communications with other micro-services is through APIs or message queues
# Message Queueing
- Solves the limiting aspects of micro services communications through APIs, by enabling micro services to communicate asynchronously thereby allowing requests to be processed without dropping other operations, the queuing helps prevent overload on internal services within our systems.
# Rate Limiting
- Helps prevent overload for the public APIs and services.
- Rate limiting restricts the number of requests a client can send within a specific time frame. 
- Every user, or IP address is assigned a request quota eg 100 requests mer minute, which if they exceed, the server temporarily blocks additional requests and throws an error.
- Rate limiting algorithms include;
* Fixed window
* Sliding window
* Token bucket
# API Gateways
- Helps us so we do not need to implement our own rate limiting systems
- An API gateway is a centralized service that handles authentication, rate limiting, logging, monitoring, request routing, etc.
- In a micro service based application with multiple services, instead of exposing each service directly to clients, an API gateway can act as a single entry point for all client requests to the appropriate microservice and responses also get sent back to the clients through the gateway 
- They simplify API management, improve scalability and security.
- Examples;
* Cloudflare API Gateway
* Amazon API Gateways
* NGINX
* Google Apigee
# Idempotency
- Network failures, and service retries are common in distributed systems.
- For example, during payment processing, when a user clicks "Pay Now" multiple times due to a slow connection, a system might request two payment requests instead of one. 
- Idempotent systems ensure that repeated requests produce the same result, as if the request were made only once
- Each request is assigned a unique id, before processing, the system checks if the request has already been handled, if yes, ignore the duplicate request, if no, process the request normally.