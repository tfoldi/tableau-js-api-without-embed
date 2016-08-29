# Tableau JS API without embed

![Tableau JS API without embed example](https://i.imgur.com/mMI3HYF.gif)

This is a Proof-Of-Concept example of using the Tableau Javascript SDK
without any embeds. For more details on the inner workings of this
sample please check the [Databoss Blog](http://databoss.starschema.net)

The source code is written in [CoffeeScript](http://coffeescript.org)
because writing plain JavaScript is a slow and error-prone process.

We use [GULP](http://gulpjs.com/) as the build tool to compile the
coffeescript code down to JavaScript.

## Pre-requistes

```bash

# Install all dependencies
npm install

# Install the gulp command line tool
sudo npm install gulp --global
```

## Running the development server

The development model is fairly simple:

#### Start your local development server:

```gulp watch serve```

This tells GULP to watch for any changes to our coffeescript files, and
recompile them upon change; and also start a web server that serves
these compiled javascript files.

#### Embed into tableau

- Use the web data connector to inject our javascript (see the Databoss
  article for details on how to do this).

- That web data connector currently points to `127.0.0.1:3000` which is
  your local development machine, so you can see any changes you make to
the javascript source code.
