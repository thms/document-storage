## Document Storage Microservice Architecture

This diagram represents a high-level architecture for the document storage microservice based on the provided codebase.

```kroki-mermaid
graph LR
    subgraph Document Storage
        A[API Gateway] --> B{Document Controller}
        B --> C{Document Model}
        B --> D{Version Controller}
        D --> E{Version Model}
        C --> F{Document Producer}
        F --> G{Kafka}
        C --> H{Version Model}
        H --> I{Paperclip}
        I --> J{S3 Storage}
    end
    subgraph External Systems
        K{Loan System} --> B
        L{Underwriting System} --> D
    end
```

**Components:**

* **API Gateway (A):**  Handles incoming requests, authenticates users, and routes requests to the appropriate controllers.
* **Document Controller (B):**  Manages document metadata, including creation, retrieval, and updates.
* **Document Model (C):**  Represents a document in the database, including its attributes and relationships to versions.
* **Version Controller (D):**  Manages document versions, including uploading new versions and retrieving specific versions.
* **Version Model (E):**  Represents a document version in the database, including its file details and metadata.
* **Document Producer (F):**  Publishes document events to Kafka, including creation, updates, and deletions.
* **Kafka (G):**  A message queue used for asynchronous communication between the document storage microservice and other systems.
* **Version Model (H):**  Used by the Version Controller to access and manage document versions.
* **Paperclip (I):**  A library used for managing file uploads and storage.
* **S3 Storage (J):**  The cloud storage service used to store document files.
* **Loan System (K):**  An external system that interacts with the document storage microservice to store documents related to loans.
* **Underwriting System (L):**  An external system that interacts with the document storage microservice to upload and retrieve document versions.

**Key Interactions:**

* The API Gateway receives requests from external systems and routes them to the appropriate controllers.
* The Document Controller interacts with the Document Model to manage document metadata.
* The Version Controller interacts with the Version Model to manage document versions.
* The Document Producer publishes document events to Kafka, which are consumed by other systems.
* Paperclip handles file uploads and storage in S3.
* External systems like the Loan System and Underwriting System interact with the document storage microservice through the API Gateway.

**Notes:**

* This diagram represents a simplified view of the architecture. The actual implementation may involve additional components and interactions.
* The codebase uses Avro for data serialization and schema registry for schema management.
* The document storage microservice uses a database (likely PostgreSQL) to store document and version data.
* The microservice is deployed using Capistrano and uses Thin as the web server.
* The codebase includes extensive unit and integration tests.

This architecture diagram provides a high-level overview of the document storage microservice and its interactions with external systems. It highlights the key components and interactions involved in managing document metadata and files. 
