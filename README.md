# XToken.tz (InvestaX Digital Security Token)

XToken.tz is a digital security token compliant with FA 1.2 token standard.


## Installation Guide

**Clone This Repository**

```
git clone https://github.com/InvestaX/XToken.tz
```

**Tezos Sandbox**

Install `docker` on your development machine. Then start `flextesa` Tezos sandbox environment.

```
docker run --rm --name my-sandbox --detach -p 20000:20000 tqtezos/flextesa:20210216 edobox start
docker run --rm tqtezos/flextesa:20210216 edobox info
```

**Install Dependencies**

```
npm install
```

**Compile Contract**

```
npm run compile
```

**Run Tests**

```
npm test
```

or

```
mocha
```

## Project Structure

| Path | Description |
| --- | --- |
| src | Source code (PascalLIGO) |
| build | Michelson compilation output |
| config | Configuration files |
| test | Unit tests, utils, and helpers |
| .mocharc | Mocha configuration file |
| .env | Environment variables |
| env.json | Environment variables override |

## Development Environment

We recommend VSCode for the development:  
https://code.visualstudio.com/
