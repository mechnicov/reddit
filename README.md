## Reddit parser

### Requirements

- Ruby 2.6.6

- PostgreSQL

- [chromedriver](https://chromedriver.chromium.org/)

### Setup

1. Download or clone repo.

2. Install all dependencies and prepare database:

```console
$ bin/setup
```

3. Fill in your data your data in `.env`.

### Tasks

You can run parsing tasks. For example:

To get or update subreddit info

```console
$ rake parse:subreddit_info subreddit=relationship_advice
```

To parse or update posts in given subreddit

```console
$ rake parse:posts subreddit=relationship_advice
```

To get new posts in given subreddit

```console
$ rake parse:new_posts subreddit=relationship_advice
```

To parse posts starting from given list url

```console
$ rake parse:url url='https://old.reddit.com/r/relationships/new/?count=675&after=t3_ma444q'
```

### Cron jobs

You can also use cron jobs for this rake tasks.

To customize them, use `config/schedule.rb`.

For more information [see docs](https://github.com/javan/whenever).

### License

MIT – see `LICENSE`

### Contacts

Email me at:

```rb
'dcdl-snotynu?fl`hk-bnl'.each_char.map(&:succ).join
```
