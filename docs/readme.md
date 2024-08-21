# Document Storage Microservice

This microservice provides storage and retrieval of documents and their versions. It is built using Ruby on Rails and leverages Paperclip for file storage.

## API

The API is versioned using the `/api/v1` namespace.

**Documents**

* **GET /api/v1/documents** - Returns a list of documents.
    * **Query Parameters:**
        * `country_code` - Filter by country code.
        * `subject_type` - Filter by subject type.
        * `subject_id` - Filter by subject ID.
        * `category` - Filter by category.
        * `year` - Filter by year.
* **GET /api/v1/documents/:id** - Returns metadata for a specific document, including links to its versions.
* **POST /api/v1/documents** - Creates a new document.
    * **Request Body:**
        * `id` - (Optional) UUID for the document. If not provided, a random UUID will be generated.
        * `subject_id` - UUID of the subject the document belongs to.
        * `subject_type` - Type of the subject (e.g., "Loan").
        * `country_code` - Country code.
        * `owner` - Email address of the document owner.
        * `category` - Category of the document.
        * `year` - Year of the document.
        * `versions` - Array of version objects:
            * `file` - Uploaded file.
            * `file_file_name` - File name.
            * `uploaded_by` - Email address of the user who uploaded the version.
            * `version` - Timestamp of the version.
            * `reason` - Reason for the version.
* **PUT /api/v1/documents/:id** - Updates a document.
    * **Request Body:**
        * `category` - New category for the document.
        * `year` - New year for the document.

**Versions**

* **POST /api/v1/documents/:document_id/versions** - Creates a new version for an existing document.
    * **Request Body:**
        * `file` - Uploaded file.
        * `file_file_name` - File name.
        * `uploaded_by` - Email address of the user who uploaded the version.
        * `version` - Timestamp of the version.
        * `reason` - Reason for the version.
* **GET /api/v1/documents/:document_id/versions/:id** - Streams the content of a specific version.

## Data Model

The microservice uses two models:

* **Document:**
    * `id` - UUID (primary key)
    * `subject_id` - UUID
    * `subject_type` - String
    * `country_code` - String
    * `owner` - String
    * `category` - String
    * `year` - Integer
* **Version:**
    * `id` - UUID (primary key)
    * `document_id` - UUID (foreign key)
    * `file` - Paperclip attachment
    * `uploaded_by` - String
    * `version` - Timestamp
    * `reason` - String

## Business Logic

* **Document Creation:**
    * When a new document is created, a new version is also created with the initial file.
* **Version Creation:**
    * A new version can be created for an existing document.
* **Document Retrieval:**
    * Documents can be retrieved by their ID or by filtering based on various criteria.
* **Version Retrieval:**
    * Versions can be retrieved by their ID.
* **Version Content Streaming:**
    * The content of a version is streamed to the client.

## Events Consumed

This microservice does not consume any external events.

## Events Published

* **Document Created:**
    * Published to the `document` Kafka topic.
    * Message format:
        * `metadata`:
            * `published_at`: Timestamp
            * `published_by`: "document-storage"
            * `country`: Country code
            * `id`: UUID
            * `tracking_id`: UUID
        * `payload`: JSON representation of the document, including its versions.
* **Document Updated:**
    * Published to the `document` Kafka topic.
    * Message format: Same as `Document Created`.
* **Document Deleted:**
    * Published to the `document` Kafka topic.
    * Message format:
        * `metadata`: Same as `Document Created`.
        * `payload`: `null`

## Codebase

The codebase is located in the `document-storage` repository owned by `thms` on GitHub.

## Notes

* The microservice uses a Kafka producer to publish events.
* The API is protected with an access token.
* The codebase includes unit tests and integration tests.
* The microservice is deployed using Capistrano.
* The microservice uses a schema registry for Avro schemas.
* The microservice uses a database cleaner to ensure a clean database for each test.
* The microservice uses a custom logger to log events.
* The microservice uses a custom session store to store session data.
* The microservice uses a custom cable to handle WebSocket connections.
* The microservice uses a custom inflections file to define custom inflections.
* The microservice uses a custom application job to handle background tasks.
* The microservice uses a custom application controller to handle authentication and authorization.
* The microservice uses a custom application record to define common methods for all models.
* The microservice uses a custom locale file to define the default locale.
* The microservice uses a custom document model to define the document data model.
* The microservice uses a custom document producer to publish events to Kafka.
* The microservice uses a custom deploy file to define the deployment process.
* The microservice uses a custom environment file to define the environment variables.
* The microservice uses a custom spec helper file to define the test environment.
* The microservice uses a custom spring file to define the spring configuration.
* The microservice uses a custom filter parameter logging file to define the parameters to filter from the log file.
* The microservice uses a custom new framework defaults file to define the new framework defaults.
* The microservice uses a custom puma file to define the Puma configuration.
* The microservice uses a custom staging environment file to define the staging environment configuration.
* The microservice uses a custom production environment file to define the production environment configuration.
* The microservice uses a custom boot file to define the application boot process.
* The microservice uses a custom rails helper file to define the Rails test environment.
* The microservice uses a custom production deploy file to define the production deployment process.
* The microservice uses a custom development environment file to define the development environment configuration.
* The microservice uses a custom application mailer file to define the application mailer configuration.
* The microservice uses a custom test environment file to define the test environment configuration.