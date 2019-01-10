include ActionDispatch::TestProcess

Document.destroy_all
Version.destroy_all
file = fixture_file_upload("#{Rails.root}/spec/fixtures/tax-return-2012.pdf", "application/pdf", true)
DocumentFactory.create(
  :subject_id => '110118bc-316e-11e6-b8e2-c715121d5b6f',
  :subject_type => 'Loan',
  :category => 'tax_return',
  :year => 2015,
  :country_code => 'de',
  :owner => 'mike@example.com',
  :versions => [
    :version => Time.now,
    :reason => 'owner upload',
    :file => file,
    :uploaded_by => 'mike@example.com'
  ]
)

DocumentFactory.create(
  :subject_id => '3162a936-316e-11e6-b8e2-c715121d5b6f',
  :subject_type => 'Loan',
  :category => 'tax_return',
  :year => 2016,
  :country_code => 'de',
  :owner => 'mike@example.com',
  :versions => [
    :version => Time.now,
    :reason => 'owner upload',
    :file => file,
    :uploaded_by => 'mike@example.com'
  ]
)
DocumentFactory.create(
  :subject_id => '38ef911e-316e-11e6-b8e2-c715121d5b6f',
  :subject_type => 'Loan',
  :category => 'bwa',
  :year => nil,
  :country_code => 'de',
  :owner => 'minnie@example.com',
  :versions => [
    :version => Time.now,
    :reason => 'owner upload',
    :file => file,
    :uploaded_by => 'mike@example.com'
  ]
)
document = DocumentFactory.create(
  :subject_id => '406d0692-316e-11e6-b8e2-c715121d5b6f',
  :subject_type => 'Loan',
  :category => 'bank_statement',
  :year => nil,
  :country_code => 'es',
  :owner => 'minnie@example.com',
  :versions => [
    :version => Time.now,
    :reason => 'initial upload',
    :file => file,
    :uploaded_by => 'minnie@example.com'
  ]
)
version = Version.create(
  :document_id => document.id,
  :uploaded_by => 'max.mueller@example.com',
  :version => Time.now,
  :reason => 'updated by underwriting',
  :file => file,
)



