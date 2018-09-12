require 'active_record'
require './seeds'
require 'kaminari'
require 'sinatra/base'
require 'graphiti'
require 'graphiti/adapters/active_record'

class ApplicationResource < Graphiti::Resource
  self.abstract_class = true
  self.adapter = Graphiti::Adapters::ActiveRecord
  self.base_url = 'http://localhost:4567'
  self.endpoint_namespace = '/api/v1'
  # implement Graphiti.config.context_for_endpoint for validation
  self.validate_endpoints = false
end

class EmployeeResource < ApplicationResource
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :age, :integer

  has_many :positions
end

class PositionResource < ApplicationResource
  attribute :employee_id, :integer, only: [:filterable]
  attribute :department_id, :integer, only: [:filterable]
  attribute :title, :string

  belongs_to :employee
  belongs_to :department
end

class DepartmentResource < ApplicationResource
  attribute :name, :string

  has_many :positions
end

Graphiti.setup!

class EmployeeDirectoryApp < Sinatra::Application
  configure do
    mime_type :jsonapi, 'application/vnd.api+json'
  end

  before do
    content_type :jsonapi
  end

  after do
    ActiveRecord::Base.clear_active_connections!
  end

  get '/api/v1/employees' do
    employees = EmployeeResource.all(params)
    employees.to_jsonapi
  end

  get '/api/v1/employees/:id' do
    employees = EmployeeResource.find(params)
    employees.to_jsonapi
  end

  get '/api/v1/positions' do
    positions = PositionResource.all(params)
    positions.to_jsonapi
  end

  get '/api/v1/positions/:id' do
    positions = PositionResource.find(params)
    positions.to_jsonapi
  end

  get '/api/v1/departments/:id' do
    departments = DepartmentResource.find(params)
    departments.to_jsonapi
  end
end
