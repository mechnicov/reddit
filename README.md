## Reddit analyzer

### Requirements

- Ruby 2.6.6

- PostgreSQL

- [chromedriver](https://chromedriver.chromium.org/)

- python 3.8.5

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

To parse posts by date (`end` by default is current date, can be omitted)

```console
$ rake parse:by_date subreddit=relationship_advice start=2014-01-31 end=2014-03-31
```

To export all records to CSV

```console
$ rake export:csv
```

### Cron jobs

You can also use cron jobs for this rake tasks.

To customize them, use `config/schedule.rb`.

For more information [see docs](https://github.com/javan/whenever).

### Posts analysis

To analyze data run

```console
$ jupyter-notebook analyze.ipynb
```

You need to export data to CSV before.

Lemmatized data will be saved at `export/posts_normalized.csv`.

Page with topic modelling will be saved at `export/topic_modeling.html`.

Word clouds will be saved at `export/cloud*.png`.

### License

MIT – see `LICENSE`

### Contacts

Email me at:

```rb
'dcdl-snotynu?fl`hk-bnl'.each_char.map(&:succ).join
```
