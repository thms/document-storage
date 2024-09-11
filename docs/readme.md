## Document Storage Microservice

This microservice provides storage and retrieval of documents and their versions. It is built using Ruby on Rails and leverages Kafka for event publishing.

**API:**

* **GET /documents**
    * Returns a list of documents based on provided filters: `country_code`, `subject_type`, `subject_id`, `category`, `year`.
    * Requires authentication token.
* **GET /documents/:id**
    * Returns metadata for a specific document, including links to its versions.
    * Requires authentication token.
* **POST /documents**
    * Creates a new document with its initial version.
    * Requires authentication token.
    * Accepts parameters: `id`, `subject_id`, `subject_type`, `country_code`, `owner`, `category`, `year`, `versions` (array of version attributes).
* **PUT /documents/:id**
    * Updates a document's category and year.
    * Requires authentication token.
    * Accepts parameters: `category`, `year`.
* **POST /documents/:document_id/versions**
    * Creates a new version for an existing document.
    * Requires authentication token.
    * Accepts parameters: `id`, `file`, `file_file_name`, `version`, `uploaded_by`, `reason`.
* **GET /documents/:document_id/versions/:id**
    * Streams the content of a specific version to the requestor.
    * Requires authentication token.
    * Returns the content with the correct mime type.

**Data Model:**

* **Document:**
    * `id` (UUID): Unique identifier for the document.
    * `country_code` (String): Country code of the document.
    * `subject_id` (UUID): Identifier of the subject the document belongs to.
    * `subject_type` (String): Type of the subject the document belongs to.
    * `category` (String): Category of the document.
    * `year` (Integer): Year of the document.
    * `owner` (String): Owner of the document.
* **Version:**
    * `id` (UUID): Unique identifier for the version.
    * `document_id` (UUID): Foreign key referencing the document.
    * `file` (Paperclip): Attachment for the document file.
    * `file_file_name` (String): Name of the file.
    * `file_content_type` (String): Mime type of the file.
    * `file_file_size` (Integer): Size of the file.
    * `file_updated_at` (DateTime): Timestamp of the last file update.
    * `file_fingerprint` (String): Fingerprint of the file.
    * `uploaded_by` (String): User who uploaded the version.
    * `reason` (String): Reason for uploading the version.
    * `version` (DateTime): Timestamp of the version.

**Business Logic:**

* **Document Creation:**
    * When a new document is created, an initial version is also created.
* **Version Creation:**
    * New versions can be created for existing documents.
* **Document Update:**
    * Only the category and year of a document can be updated.
* **Version Retrieval:**
    * The content of a specific version is streamed to the requestor.

**Events Consumed:**

* None

**Events Published:**

* **Document Event:**
    * Published to the `document` topic in Kafka.
    * Contains metadata and payload:
        * Metadata: `published_at`, `published_by`, `country`, `id`, `tracking_id`.
        * Payload: JSON representation of the document, including its versions.
    * Published when a document is created, updated, or deleted.

**Repo:**

* **Owner:** example.com
* **Name:** document-storage

**Current Time (UTC):** 2023-10-27 11:34:12

**Author:** Bard
