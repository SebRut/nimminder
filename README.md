# nimminder
[![CI](https://github.com/SebRut/nimminder/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/SebRut/nimminder/actions/workflows/main.yml)

A CLI for [beeminder written](https://beeminder.com/) in nim. Inspired by [bmndr](https://github.com/lydgate/bmndr).

# Configuration

[Get your auth token](https://www.beeminder.com/api/v1/auth_token.json) and set the `BEEMINDER_AUTH_TOKEN` environment variable to it.

# Usage

## Show goal overview

Shows an overview of your goals with time to derailment.

`$ nimminder`

## Show specific goal

Show data of a specific goal. Currently quite basic.

`$ nimminder {GOAL_SLUG}`

## Log a data point

Adds a new datapoint to a goal. The format should be the same as for [emails](https://help.beeminder.com/article/36-what-is-my-data).

` nimminder {GOAL_SLUG} {DAYSTRING} {VALUE} [COMMENT]`
