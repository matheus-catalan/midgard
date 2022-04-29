# frozen_string_literal: true

# frozen_string_literal: true

require 'rails_helper'
require 'models_helper'

RSpec.configure do |config|
  config.swagger_root = "#{Rails.root}/swagger"

  models = ApplicationRecord.all_models_with_attributes

  config.swagger_docs = {
    'v1/api-docs.json' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1',
        description:
          '#### Notes: Some data types we use are not valid in open-api, so a type cast was made for similar types
            - json
            - jsonb
          '
      },
      servers: [
        {
          url: 'http://localhost:8080'
        }
      ],

      components: {
        schemas: models,
        partials: partials,
        securitySchemes: {
          recruiter_auth_jwt: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT,
            in: :header
          },
          candidate_auth_jwt: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT,
            in: :header
          }
        }
      }
    }
  }
  config.swagger_format = :json
end
