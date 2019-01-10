class Document < ApplicationRecord

  has_many :versions, :dependent => :destroy

  validates_presence_of :category, :owner, :subject_id, :subject_type, :country_code

  default_scope { order(:created_at) }

  # Normally we want to be able to publish event, but during some db migrations we want to disable that
  class_attribute :kafka_publishing_enabled
  self.kafka_publishing_enabled = true

  def self.disable_kafka_publishing
    self.kafka_publishing_enabled = false
  end

  # Publish model whenever it gets updated or deleted, but outside the transaction
  after_commit :publish_commit_event

  private

  def publish_commit_event
    Producers::DocumentProducer.new.produce([self]) if kafka_publishing_enabled
  end
end
