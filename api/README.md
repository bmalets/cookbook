# Cookbook API

A backend API service that helps users discover recipes based on available ingredients. The service leverages Groq's LLM capabilities to provide intelligent recipe matching and recommendations.

## API Documentation

The API is documented using OpenAPI (Swagger) specification. You can find the interactive API documentation here:

[API Documentation](../doc/api-docs.html)

## Technical Stack

- Ruby 3.3.4
- Ruby on Rails 7.2 (API mode)
- PostgreSQL 16
- Groq API integration
- Sidekiq for background processing
- OAuth 2.0 with Doorkeeper for authentication
- OpenAPI/Swagger for API documentation

## Prerequisites

- Groq API credentials
- Ruby 3.3.4
- PostgreSQL 16
- Redis (for Sidekiq)

## Supported Environments

- Development
- Test

## Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:your-username/cookbook-api.git
   cd cookbook-api
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up environment variables:
   ```bash
   cp .env.sample .env.development
   ```
   Then edit `.env.development` with your credentials.

4. Set up the database:
   ```bash
   rails db:setup
   ```

5. Copy API auth credentials that will be needed for the FE app (client_id and client_secret from `oauth_applications` table)

6. Start the Redis server (required for Sidekiq):
   ```bash
   redis-server
   ```

7. Start Sidekiq:
   ```bash
   bundle exec sidekiq
   ```

8. Start the Rails server:
   ```bash
   rails server
   ```

The API will be available at `http://localhost:3000`

### Unit tests

Please run
```bash
bundle exec rspec
```
