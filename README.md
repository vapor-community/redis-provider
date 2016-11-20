# Redis Provider for Vapor

![Swift](http://img.shields.io/badge/swift-v3.0--dev.07.25-brightgreen.svg)
[![Build Status](https://travis-ci.org/qutheory/redis-provider.svg?branch=master)](https://travis-ci.org/vapor/redis-provider)
[![CircleCI](https://circleci.com/gh/vapor/redis-provider.svg?style=shield)](https://circleci.com/gh/vapor/redis-provider)
[![Code Coverage](https://codecov.io/gh/vapor/redis-provider/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor/redis-provider)
[![Codebeat](https://codebeat.co/badges/a793ad97-47e3-40d9-82cf-2aafc516ef4e)](https://codebeat.co/projects/github-com-vapor-redis-provider)
[![Slack Status](http://vapor.team/badge.svg)](http://vapor.team)

A Vapor provider for Redis database caching. 

Read more about [Providers](https://vapor.github.io/documentation/guide/provider.html) in Vapor's [documentation](http://docs.vapor.codes).

## 🐦 Redbird

This wrapper conforms Redbird to Vapor's `CacheProtocol`.

## Installing Redis

### Homebrew

```sh
brew install redis
brew services start redis
```

### Setup
Add config
```
{
    "address": "127.0.0.1",
    "port": "6379"
}
```
If password is required, the add "password": "secret" to the config

Add the provider
```
try drop.addProvider(VaporRedis.Provider(config: drop.config))
```

### Travis

Travis builds Swift VaporRedis on both Ubuntu 14.04 and macOS 10.11. Check out the `.travis.yml` file to see how this package is built and compiled during testing.

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to install Swift 3. 

## 💧 Community

We pride ourselves on providing a diverse and welcoming community. Join your fellow Vapor developers in [our slack](http://vapor.team) and take part in the conversation.

## 🔧 Compatibility

Node has been tested on OS X 10.11, Ubuntu 14.04, and Ubuntu 15.10.

## 👥 Author

Created by [Tanner Nelson](https://github.com/tannernelson).
