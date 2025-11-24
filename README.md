# README

## Overview

This project is a Ruby on Rails application. The sections below outline how to install dependencies, set up the environment, and run the app during development.

---

## Requirements

**Ruby Version**

* Ruby 3.4.7

**System Dependencies**

* Ruby 3.4.7
* Node.js
* PostgreSQL
* Webpack / webpack-cli

---

## Setup Instructions

### 1. Install Dependencies

```bash
brew install node
brew install postgresql
bundle install
npm install --save-dev webpack webpack-cli
npx webpack
```

### 2. Initialize the Application (First Setup Only)

Start PostgreSQL and create the initial database:

```bash
brew services start postgresql
bin/rails db:create
```

---

## Run the Application

Run migrations, seed data (if needed), and start the development server:

```bash
bin/rails db:migrate
bin/rails db:seed
bin/dev
```
