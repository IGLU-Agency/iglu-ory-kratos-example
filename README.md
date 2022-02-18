# IGLU Ory Kratos Example

## Introduction

This example project shows how to integrate all the self-services flows of [Ory Kratos](https://www.ory.sh/kratos) within a custom interface developed with Flutter.

All the details of this example are available in this [article](https://www.ory.sh/login-flutter-authentication-example-api-open-source/).

## Setup

To test the features of this project is very simple, as the first thing you have to run Kratos:

    kratos serve --config ./test/kratos.yml --dev

> if you have problems running this command, you probably have to change the path of the identity schema inside the kratos.yml file.

After that, you'll have to run the project on chrome and test how it works.

## Real World

If you are interested in seeing an actual project based on this, we invite you to look at our [unique solution](https://orykratos.iglu.dev/) that offers Ory Kratos.

If you need a plug-and-play containerized solution, leave us an [email](mailto:info@iglu.dev).
