# Mpesa Rails Application

![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)

## Table of Contents

- [Introduction](#introduction)
- [Technologies](#technologies)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Routes](#routes)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This is a Ruby on Rails application that integrates with Mpesa for handling payments. It includes endpoints for initiating STK push transactions and polling for payment status.

## Technologies

- Ruby
- Rails
- SQLite (for development and testing)
- Render (for deployment)

## Installation

1. **Clone the repository**

    ```bash
    git clone git@github.com:randy-kip/ROR_Mpesa_nahla-naturals.git
    cd mpesa-rails-app
    ```

2. **Install dependencies**

    Ensure you have Ruby and Rails installed. Then run:

    ```bash
    bundle install
    ```

3. **Set up environment variables**

    Create a `.env` file in the root of the project and add your Mpesa credentials and other necessary environment variables:

    ```bash
    MPESA_CONSUMER_KEY=your_consumer_key
    MPESA_CONSUMER_SECRET=your_consumer_secret
    MPESA_SHORTCODE=your_shortcode
    MPESA_PASSKEY=your_passkey
    ```

## Database Setup

1. **Create the database**

    ```bash
    rails db:create
    ```

2. **Run the migrations**

    ```bash
    rails db:migrate
    ```

## Routes

The application includes the following routes:

```ruby
resources :mpesas
post "/stkpush", to: "mpesas#stkpush"
post "/polling_payment", to: "mpesas#polling_payment"
```

## Usage

1. **Start the Rails server**

    ```bash
    rails server
    ```

2. **Initiate an STK push transaction**

    Send a POST request to `/stkpush` with the following parameters:

    ```json
    {
      "phoneNumber": "254712345678",
      "amount": 100
    }
    ```

3. **Poll for payment status**

    Send a POST request to `/polling_payment` with the following parameter:

    ```json
    {
      "checkoutRequestID": "ws_CO_123456789"
    }
    ```

## Contributing

1. **Fork the repository**
2. **Create a feature branch**

    ```bash
    git checkout -b feature-branch
    ```

3. **Commit your changes**

    ```bash
    git commit -m "Add some feature"
    ```

4. **Push to the branch**

    ```bash
    git push origin feature-branch
    ```

5. **Create a new Pull Request**

## Author

- [@Randy Kipkurui](https://github.com/randy-kip)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/randy-kip/ROR_Mpesa_nahla-naturals/blob/main/LICENSE.md) file for details.