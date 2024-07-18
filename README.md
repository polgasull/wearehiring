# WeAreHiring.io

Welcome to the official repository for [WeAreHiring.io](https://www.wearehiring.io/), a robust platform to connect job seekers with employers efficiently and effectively. This project leverages modern technologies and integrations to provide a seamless experience for both job posters and applicants.

## Features

- **Ruby on Rails 7**: The latest and most efficient version of Rails for a smooth development experience.
- **PostgreSQL 14**: Reliable and powerful database management.
- **Google for Jobs Integration**: Your job postings get wider visibility by appearing in Google job searches.
- **Discord Integration**: Stay connected with your team and job applicants in real-time.
- **SendGrid Integration**: Effortlessly manage your email communications.
- **Twitter Integration**: Share job postings directly on Twitter to reach a broader audience.

## Getting Started

### Prerequisites

- Ruby (version 3.1.0 or later)
- Rails (version 7.0 or later)
- PostgreSQL (version 14 or later)
- Node.js (version 14 or later)
- Yarn (version 1.22.10 or later)

### Installation

1. **Clone the Repository**

```bash
  git clone https://github.com/yourusername/wearehiring.git
  cd wearehiring.io
```

2. **Install Dependencies**

```bash
  bundle install
  yarn install
  Setup the Database
```

3. **Make sure PostgreSQL is running and create the database:**

```bash
  rails db:create
  rails db:migrate
  rails db:seed
```

4. **Environment Variables**

Create a .env file in the root directory and add your configuration details:

```bash
  GOOGLE_JOBS_API_KEY=your_google_jobs_api_key
  DISCORD_WEBHOOK_URL=your_discord_webhook_url
  SENDGRID_API_KEY=your_sendgrid_api_key
  TWITTER_API_KEY=your_twitter_api_key
  TWITTER_API_SECRET=your_twitter_api_secret
```

## Run the Server

6. **Start the Rails server:**

```bash
  rails server
  Visit http://localhost:3000 to see your application in action.
```


## Usage

### Posting a Job

1. Navigate to the job posting section.
2. Fill in the job details.
3. Your job will be automatically posted to Google for Jobs, Twitter, and notified on Discord.

### Managing Applications

1. View applications in the admin panel.
2. Communicate with applicants directly through the platform.
3. Use the SendGrid integration to send automated email updates to applicants.

## Contributing

We welcome contributions from the community! To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes and commit them with descriptive messages.
4. Push your changes to your forked repository.
5. Create a pull request to the main repository.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contact

For any inquiries or support, please contact us at [hello@wearehiring.io](mailto:hello@wearehiring.io).
