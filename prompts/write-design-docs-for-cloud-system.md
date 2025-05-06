## Cloud System Design Document Prompt

**Role:** *You are a **Senior Solutions Architect** with expertise in cloud-based system design and technical documentation.*

**Task:** *Write a comprehensive **Cloud System Design Document** for the system described below. Please ensure the document covers the following sections with the specified level of detail.*

**System Description:**
`"<Provide a CLEAR and SPECIFIC description of the system. Include its purpose, primary goals, target users, key functionalities, and any known constraints or technologies to consider. The more CONTEXT and BACKGROUND INFORMATION you provide, the better the LLM can tailor the document. e.g., An e-commerce web application for selling handmade crafts, hosted on AWS, aiming for high availability and a seamless user experience for non-technical sellers and buyers. Key features include product listing, shopping cart, secure payments, and order management.>" `

---

### General Instructions & Best Practices

*   **Output Format:** Draft the document in **Markdown**, using clear section headings (H2 for main sections, H3 for subsections, etc.) and sub-headings. Use bullet points or tables where helpful for readability.
*   **Clarity and Specificity:** Use clear, professional, and concise language. Avoid jargon where possible or explain it. Tailor explanations to the specific system; avoid generic statements.
*   **Assumptions:** If critical information is missing from the System Description, make reasonable assumptions and **explicitly state them** at the beginning of the relevant section or in a dedicated "Assumptions" section.
*   **Iterative Refinement:** The initial output may require refinement. Be prepared to iterate on this prompt or ask for specific sections to be regenerated with more detail if needed. You can also try few-shot prompting (providing small examples of desired output for a section) if the initial results are not satisfactory.
*   **Diagrams:** For any diagrams or architectural illustrations, please use [Mermaid](https://mermaid-js.github.io/) syntax in Markdown for clear and reproducible diagram rendering.
*   **Human Review (CRITICAL):** LLM-generated content **MUST** be thoroughly reviewed, validated, and corrected by human subject matter experts for accuracy, completeness, and appropriateness before use. LLMs can "hallucinate" or produce plausible-sounding but incorrect information. **Treat this document as a starting point, not a final product.**

---

### Document Sections

1.  **System Overview**
    *   **Purpose and Goals:** Clearly describe the main objectives and intended functionality of the cloud-based system. What problems will it solve, and what are its primary goals?
    *   **Target Audience:** Specify who will be the primary users or stakeholders of this system. What are their technical proficiencies and needs?
    *   **Scope:** Define what is in and out of scope for the system for this design.
    *   **High-Level Requirements:** Outline the key functional requirements (what the system should do) and non-functional requirements (e.g., performance, availability, security expectations) at a high level.

2.  **Architecture**
    *   **Overall Architecture Diagram (Textual Representation):** Describe the high-level architectural components of the system and their interactions. Specify the different layers or tiers and how they communicate. If possible, provide a textual representation of a high-level diagram (e.g., using ASCII art, or describing connections like "Component A sends data to Component B via REST API").
    *   **Architectural Style:** Specify the chosen architectural style (e.g., microservices, monolithic, serverless, event-driven, layered) and provide a clear rationale for this selection based on the system's requirements, scalability needs, team expertise, and maintainability.
    *   **Key Architectural Decisions:** Highlight the most significant architectural decisions made during the design process (e.g., choice of a specific cloud provider, database type, messaging system) and provide justifications for these choices, considering factors like scalability, maintainability, cost, security, performance, and team familiarity.

3.  **Components**
    *   For each major component identified in the architecture (e.g., web server, application server, API gateway, database, message queue, caching layer, authentication service, specific microservices):
        *   **Name and Description:** Provide a clear name and a detailed description of the component's responsibilities, key functionalities, and its role within the overall system.
        *   **Technology Stack:** Specify the primary technologies, programming languages, frameworks, and libraries that will be used for this component.
        *   **APIs and Interfaces:** Describe any APIs or interfaces this component will expose or consume, including the communication protocols (e.g., REST, gRPC, GraphQL), data formats (e.g., JSON, XML, Protobuf), and key operations.
        *   **Workflow / Key Algorithms:** Briefly describe important internal workflows or key algorithms if applicable.

4.  **Data Flow and Management**
    *   **End-to-End Data Flow:** Describe the flow of data through the system for key use cases. Explain how data is ingested, processed, transformed, stored, and accessed. Use diagrams or clear descriptions.
    *   **Data Model (High-Level):** Provide a high-level overview of the system's data model, including the key entities, their attributes, and the relationships between them. (e.g., for an e-commerce site: User, Product, Order, OrderItem).
    *   **Data Storage Solutions:** Specify the types of databases and storage services that will be used (e.g., relational database like PostgreSQL/MySQL, NoSQL database like MongoDB/DynamoDB, object storage like S3/Azure Blob Storage, data warehouse, caches). Provide a rationale for their selection based on data characteristics (structured, unstructured), access patterns (read-heavy, write-heavy), consistency requirements, scalability, and cost.

5.  **Security**
    *   **Security Requirements:** Outline the key security requirements for the system, including authentication, authorization, data confidentiality, integrity, and availability. Mention any relevant compliance standards or regulatory requirements (e.g., GDPR, HIPAA, PCI-DSS).
    *   **Security Measures:** Describe the security measures that will be implemented at different layers of the system (e.g., network security like firewalls/VPCs, application security like input validation/WAF, data security, infrastructure security). Specify the use of any cloud-specific security services.
    *   **Authentication and Authorization:** Explain the mechanisms for user authentication (verifying identity, e.g., OAuth 2.0, OpenID Connect, SAML) and authorization (controlling access to resources, e.g., RBAC, ABAC).
    *   **Data Encryption:** Specify how sensitive data will be encrypted both at rest (when stored, e.g., AES-256) and in transit (when transmitted over the network, e.g., TLS/SSL).
    *   **Vulnerability Management:** Describe the strategy for identifying, assessing, and mitigating security vulnerabilities in the system (e.g., regular security audits, penetration testing, dependency scanning).

6.  **Scalability**
    *   **Scalability Requirements:** Define the expected scalability needs of the system, including anticipated user growth, peak loads, data volume growth, and performance targets under load.
    *   **Scalability Strategies:** Describe the strategies that will be employed to ensure the system can handle increasing load and maintain performance (e.g., horizontal scaling/auto-scaling of compute resources, load balancing, database scaling techniques like read replicas or sharding, caching strategies, use of CDNs).
    *   **Performance Considerations:** Outline any specific performance requirements (e.g., response times for key APIs, throughput targets) and how the design will address these.

7.  **Deployment**
    *   **Deployment Model:** Specify the chosen deployment model (e.g., public cloud (AWS, Azure, GCP), private cloud, hybrid cloud).
    *   **Deployment Process (High-Level):** Describe the high-level steps involved in deploying the system to the target environment, including CI/CD pipeline stages (build, test, deploy).
    *   **Infrastructure as Code (IaC):** Indicate whether Infrastructure as Code (IaC) tools (e.g., Terraform, CloudFormation, ARM Templates, Pulumi) will be used for provisioning and managing the cloud infrastructure, and why.

8.  **Monitoring and Logging**
    *   **Monitoring Requirements:** Define the key metrics that will be monitored to ensure the health and performance of the system (e.g., CPU utilization, memory usage, disk I/O, network latency, error rates, application-specific metrics).
    *   **Monitoring Tools and Strategies:** Specify the tools (e.g., CloudWatch, Prometheus, Grafana, Datadog) and strategies that will be used for monitoring the system and generating alerts for critical issues.
    *   **Logging Strategy:** Describe how logs (application logs, system logs, audit logs) will be collected, aggregated, stored (e.g., Elasticsearch, CloudWatch Logs), and analyzed for troubleshooting, auditing, and gaining insights into system behavior.

9.  **Disaster Recovery and Business Continuity**
    *   **Recovery Objectives (RTO/RPO):** Define the target Recovery Time Objective (RTO - how quickly the system must be back online after a disaster) and Recovery Point Objective (RPO - how much data loss is acceptable) for the system.
    *   **Disaster Recovery Plan (High-Level):** Outline the high-level plan for recovering the system and its data in the event of a disaster or significant outage (e.g., multi-region/multi-AZ deployment, failover mechanisms).
    *   **Backup and Restore Strategy:** Describe the approach for backing up critical data (frequency, retention period, storage) and restoring it in case of data loss or corruption.

10. **Cost Considerations (High-Level)**
    *   Provide a high-level overview of the anticipated costs associated with the cloud infrastructure and services required to run the system.
    *   Outline any initial cost optimization strategies that will be considered during the design and implementation phase (e.g., choosing appropriate instance types, using reserved instances, auto-scaling to match demand, serverless options).

11. **Risks and Mitigations**
    *   List potential technical risks (e.g., single points of failure, vendor lock-in, security vulnerabilities, performance bottlenecks) and a mitigation plan for each.

12. **Alternatives Considered**
    *   Briefly describe other significant architectural approaches, technologies, or tools that were evaluated and the reasons for their rejection in favor of the chosen design.

13. **Conclusion**
    *   Summarize how the proposed design meets the stated objectives and requirements.
    *   Note any key assumptions made during the design process.
    *   Mention possible future enhancements or areas for further investigation.

---

*Feel free to ask clarifying questions if any critical information is missing from the System Description to provide a more accurate and detailed design document.*
