module ContentCleaner
  extend self

  MINIMAL_SYMBOLS_QTY = 2_000.freeze

  def clean(record, atr)
    record.send(atr).gsub!(/#{URI::regexp}|[[:punct:]]/, '')
    record unless record.send(atr).size < MINIMAL_SYMBOLS_QTY
  end
end
