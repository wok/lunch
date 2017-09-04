# lunch
Fetch lunch list from Dylan and Amica and post to slack

# Installation

## Create user

```
useradd -m foodagent
```

## Download source

```
git clone https://github.com/wok/lunch.git
cd lunch
bundle install --path vendor/bundle
```

## Check if posting works

```
FOOD_SLACK_URL=https://hooks.slack.com/services/XXXX ./lunch.rb
```

## Update crontab

```
crontab -e
```

```
PATH=/opt/ruby/current/bin:/usr/local/bin:/usr/bin:/bin
FOOD_SLACK_URL=https://hooks.slack.com/services/XXXX
0 11 * * 1-5  /bin/bash -l -c 'cd /home/foodagent/lunch && ruby lunch.rb >> lunch.log 2>&1'
```
