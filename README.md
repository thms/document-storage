# Document Storage

## Purpose
Provide storage for documents, created by the system or uploaded by a user in one central location

Has no UI, only API, accessible easily

## The API is protected by an access token:
curl http://127.0.0.1:3000/v1/documents/123 -H "Authorization: Token token=MJagrTYj2dCVTetpyFSyamuRPC2X9xNy"

curl http://127.0.0.1:3000/v1/document?country=de& -H "Authorization: Token token=MJagrTYj2dCVTetpyFSyamuRPC2X9xNy"


# Requirements
- User can upload document from Salesforce, Loan Manager, etc.
- Stores meta data about the document, e.g. country, loan_id, category, date, type, mime-type
- Encrypt documents at rest via S3 encryption, Amazon holds the key
- Backed by Amazon S3 to provide high-availability and redundancy
- Application can query storage to get all documents for loan and country
- Access to document categories must be by at least user role (e.g. underwriting is not allowed to see docs that collections uploaded)
- Access to documents may have to be by person e.g. account manager (account owner) can see, but other sales people cannot (but knowledge of who is currently logged in is a presentation layer question, should not be handled at the document storage layer?)
- Must support versioning
- Must support immutability of documents
- Must support immutability of meta data
- Search by meta data must be supported
- Full document search is optional
- Should support grouping of multiple files into a single document (e.g. if user takes individual pictures or scans of the pages of a document): handle via PDF creation r alloing zip files.
- Should we support a user interface for admin purposes - probably
- Must support audit trails
- Should support visibility rules as part of the meta data so we do not need to do this in code.
- Support document ownership
- Support flexible meta data?


### Nice to have
- post a set of files that forms a single document, e.g. multiple pages, system zips it or merges the pages together
- bulk upload API
- API to get all documents for a loan as one big zip file


## Open questions:
- how do we do visibility / permission rules?
-- by category in each application
-- + no need to support updates to meta data
-- + no need to change meta data when we want to change the rules of who can see what
-- - it is not explicitly clear from the data who has access to it.
-- by visibility roles in meta data
-- + rules are explicit in the data
-- + application only need to map user roles
-- - if we want to change visibility rules, we need to touch all existing documents - seems very clunky


## Use Cases
Salesforce user uploads new document to storage
Salesforce user views list of all documents associated with a loan
Salesforce user views list of all documents associated with a borrower
Salesforce user views list of all documents associated with an investor
Loan manager generates warrantor contract and uploads to document storage
Borrower uploads bank statement as single file
Borrower uploads bank statement as several files (can we just zip them?) - OPEN
Loan manager requests list of all documents for loan x and needs the meta data and actionable links
Scoring tool generates risk report for given loan and uploads to document storage
admin user clicks link to document, application requests content from document storage and streams to the user. (this allows encryption to be handled correctly and avoids exposing the document storage API to end users)
Loan manager generates new version of loan contract after payment plan change, and uploads this version to document storage

Someone requests zip file of all documents for a given object
System does validate mime types to avoid hacking attacks, this is built into Paperclip



Questions
- Should we make this searchable, i.e. the meta data and the content via Elasticsearch? - not yet
- Should we support uploading multiple pages for a single document version? document has many versions has many pages?? (or allow upload of new pages but concatenate them at the backend irks) - no user has to do that.
- Should support UUID's for all items - yes
- how to add meta data to S3 files? - we'll keep the meta data locally in the store
- Should rename files and store the original file name as meta data - yes


POSTING with document or version ID:
- document may already be generated with a proper ID elsewhere, we need to support POSTING with the ID for document and version. Supported


Documents
loan contract
passport picture
bank statement
SEPA mandate
investor contract
profit and loss statement
balance sheet



API
GET /documents?country=de&subject_id=123&subject_type=Loan
return meta data:

GET /documents/{document_id}/versions/{id}
Return actual content

POST /documents meta data * file content


Data Model
Document has_many versions
Version has_attached_document
Metadata split between document and versions
Version is identified by a timestamp for the version

Uploading of files have two options (both are implemented)
Multipart/form wich is implemented currently:
curl -i -X POST -H "Content-Type: multipart/form-data"  -F document[subject_type]=Loan -F document[subject_id]=7 -F document[country_code]=de -F document[owner]=mike@example.com -F "document[versions][][file]=@spec/axesor.pdf;type=application/pdf" -F document[versions][][uploaded_by]=ann.builder@example.com -F document[versions][][version]=2016-05-19 http://127.0.0.1:3000/api/v1/documents.json

or base64 encoded stream or data, which is easier for API:
client load file in memory, base64encode and push through the API
Document upload:
(echo -n '{"document": {"category":"bwa","subject_type":"Loan", "subject_id":"eeabaf94-5bf1-424e-a800-3b14e6e1a6cb","country_code" : "de", "owner":"mike@example.com", "versions":[{"file": "data:application/pdf;base64,'"$(base64 spec/axesor.pdf)"'", "content_type":"application/pdf", "file_file_name" :"axesor.pdf","uploaded_by":"ann.builder@example.com", "version":"2016-06-13"}]}}') | curl -i -X POST -H "Content-Type: application/json"  -d@- http://127.0.0.1:3000/api/v1/documents.json

with ID
(echo -n '{"document": {"id":"ffabaf94-5bf1-424e-a800-3b14e6e1a6cb", "category":"bwa","subject_type":"Loan", "subject_id":"ecabaf94-5bf1-424e-a800-3b14e6e1a6cb","country_code" : "de", "owner":"mike@example.com", "versions":[{"file": "data:application/pdf;base64,'"$(base64 spec/axesor.pdf)"'", "content_type":"application/pdf", "file_file_name" :"axesor.pdf","uploaded_by":"ann.builder@example.com", "version":"2016-06-13"}]}}') | curl -i -X POST -H "Content-Type: application/json"  -d@- http://127.0.0.1:3000/api/v1/documents.json

Version upload:
(echo -n '{"version": {"file": "data:application/pdf;base64,'"$(base64 spec/test.pdf)"'", "file_file_name":"test.pdf", "uploaded_by":"max.builder@example.com", "version":"2016-06-14", "reason":"signed_contract"}}') | curl -i -X POST -H "Content-Type: application/json"  -d@- http://127.0.0.1:3000/api/v1/documents/46c23d29-5e45-440f-9f7d-3fbf6d24ed12/versions.json

Version upload with ID:
(echo -n '{"version": {"id":"47c23d29-5e45-440f-9f7d-3fbf6d24ed12", "file": "data:application/pdf;base64,'"$(base64 spec/test.pdf)"'", "file_file_name":"test.pdf", "uploaded_by":"max.builder@example.com", "version":"2016-06-14", "reason":"signed_contract"}}') | curl -i -X POST -H "Content-Type: application/json"  -d@- http://127.0.0.1:3000/api/v1/documents/46c23d29-5e45-440f-9f7d-3fbf6d24ed12/versions.json

TODO
Remove csrf token - DONE
API for adding version  DONE
API for updating document metadata - DEFER, should not be needed
API for getting all categories?
Pagination - should not be needed if we limit access by object
protect index API to only allow a single object at a time, rather then the current very lax index filtering.
reasonable tests.

http://railscasts.com/episodes/342-migrating-to-postgresql?view=asciicast
