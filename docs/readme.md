# Document Storage Microservice

This microservice provides storage and retrieval of documents, including their versions. It is built using Ruby on Rails and leverages Kafka for event-driven communication.

## API

The API is defined using RESTful principles and is accessible through the `/api/v1` namespace.

**Endpoints:**

* **GET /documents:** Retrieves a list of documents based on provided filters (country_code, subject_type, subject_id, category, year).
* **GET /documents/:id:** Retrieves metadata for a specific document, including links to its versions.
* **POST /documents:** Creates a new document with its initial version.
* **PUT /documents/:id:** Updates the category and year of an existing document.
* **POST /documents/:document_id/versions:** Creates a new version for an existing document.
* **GET /documents/:document_id/versions/:id:** Retrieves the content of a specific version.

**Authentication:**

The API is protected using HTTP Basic Authentication with a predefined token.

## Data Model

The microservice uses two main models:

* **Document:** Represents a document with attributes like country_code, subject_id, subject_type, category, year, and owner.
* **Version:** Represents a specific version of a document with attributes like file (Paperclip attachment), uploaded_by, version (timestamp), and reason.

## Business Logic

* **Document Creation:** When a new document is created, a new version is also created and associated with the document.
* **Version Creation:** New versions can be added to existing documents.
* **Document Retrieval:** Documents can be retrieved based on various filters.
* **Version Retrieval:** The content of a specific version can be retrieved.
* **Document Update:** Only the category and year of a document can be updated.

## Events Consumed

This microservice does not consume any external events.

## Events Published

The microservice publishes events to Kafka whenever a document is created, updated, or deleted.

**Events:**

* **document.created:** Published when a new document is created.
* **document.updated:** Published when a document is updated.
* **document.deleted:** Published when a document is deleted.

**Event Schema:**

The event schema is defined using Avro and is available in the `app/schemas` directory.

**Event Payload:**

The event payload contains the serialized document data, including its versions.

## Codebase

The codebase is available on GitHub: [https://github.com/thms/document-storage](https://github.com/thms/document-storage)

## Deployment

The microservice is deployed using Capistrano and Thin.

**Deployment Steps:**

1. Clone the repository.
2. Configure the deployment settings in `config/deploy.rb`.
3. Run `cap deploy`.

## Monitoring

The microservice logs events to a dedicated log file.

**Log File:**

* `log/document.log`

## Future Enhancements

* Implement support for different file formats.
* Add support for document search.
* Implement versioning for document metadata.
* Integrate with other microservices.

This README provides a high-level overview of the Document Storage microservice. For more detailed information, please refer to the codebase.
