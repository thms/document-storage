```plantuml
@startuml
class Document {
  - id : UUID
  - subject_id : UUID
  - subject_type : String
  - category : String
  - year : Integer
  - owner : String
  - country_code : String
  - created_at : DateTime
  - updated_at : DateTime
  - kafka_publishing_enabled : Boolean
  + versions : Version[]
  + publish_commit_event()
}

class Version {
  - id : UUID
  - document_id : UUID
  - file : File
  - created_at : DateTime
  - updated_at : DateTime
}

Document *-- Version

class DocumentFactory {
  + create(params : Hash) : Document
}

class Producers::DocumentProducer {
  - producer : Kafka::Producer
  - kafka : Kafka
  - config : Hash
  - class_logger : Logger
  - avro : AvroTurf::Messaging
  + initialize()
  + produce(documents : Document[])
  + produce_entire_history()
}

class ApplicationRecord {
  + abstract_class = true
}

Document --|> ApplicationRecord
Version --|> ApplicationRecord

@enduml
```

**Data Model:**

* **Document:** Represents a document with attributes like ID, subject ID, subject type, category, year, owner, country code, and timestamps. It has a one-to-many relationship with **Version**.
* **Version:** Represents a version of a document with attributes like ID, document ID, file, and timestamps.
* **DocumentFactory:** A factory class for creating new documents and their initial versions.
* **Producers::DocumentProducer:** A producer class responsible for publishing document events to a Kafka topic.
* **ApplicationRecord:** An abstract base class for all ActiveRecord models.

**Relationships:**

* **Document** has a one-to-many relationship with **Version**.
* **Document** inherits from **ApplicationRecord**.
* **Version** inherits from **ApplicationRecord**.

**Notes:**

* The **file** attribute in **Version** represents an attached file.
* The **kafka_publishing_enabled** attribute in **Document** controls whether Kafka events are published for the document.
* The **DocumentProducer** class uses Avro for encoding messages before publishing them to Kafka.

**Current Time (UTC):** 2023-10-27 10:33:12

**Author:** Bard
